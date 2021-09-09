#!/bin/bash

#----------------------------------------------------------------------------------------#
# Bash script to find the name of the archive or binary to install from GitHub Releases.
# This script can also be used to find the checksum of the binary if it is published.
#----------------------------------------------------------------------------------------#

find_file_name() {
  ALL_NAMES=( $1 )
  OS_FAMILY=$2
  BINARY_NAME=$3
  PREFERRED_FORMAT=( $4 )

  # Define the OS based Regex to be added to the final regex
  LINUX_REGEX="linux"
  MAC_REGEX="(darwin|mac|osx)"
  WINDOWS_REGEX="(win|windows)"

  # File Extensions for each platform, used to find the right installer file
  LINUX_EXTN_DEFAULT=( tar tar.gz tar.bz2 zip rpm deb appimage )
  MAC_EXTN_DEFAULT=( dmg tar tar.gz tar.bz2 zip )
  WINDOWS_EXTN_DEFAULT=( exe msi zip )

  # Regex to find the list of file names that do not contain an extension (except exe).
  # This is used to filter release files that are precompiled binaries
  NO_EXTN_REGEX="^$BINARY_NAME((?!(\.[a-zA-Z]{2,3})).)*$"

  if [[ $OS_FAMILY == 'linux' ]]; then
    OS_REGEX="$LINUX_REGEX"
    NON_OS_REGEX="^((?!$MAC_REGEX)(?!$WINDOWS_REGEX).)*$"
    [[ -z "${PREFERRED_FORMAT[@]}" ]] && EXTN_REGEX=("${LINUX_EXTN_DEFAULT[@]}") || EXTN_REGEX=("${PREFERRED_FORMAT[@]}")
  elif [[ $OS_FAMILY == 'darwin' ]]; then
    OS_REGEX="$MAC_REGEX"
    NON_OS_REGEX="^((?!$LINUX_REGEX)(?!$WINDOWS_REGEX).)*$"
    [[ -z "${PREFERRED_FORMAT[@]}" ]] && EXTN_REGEX=("${MAC_EXTN_DEFAULT[@]}") || EXTN_REGEX=("${PREFERRED_FORMAT[@]}")
  elif [[ $OS_FAMILY == 'win32nt' ]]; then
    NO_EXTN_REGEX="^$BINARY_NAME((?!(\.[a-zA-Z]{2,3})).)*(\.exe)+$"
    OS_REGEX="$WINDOWS_REGEX"
    NON_OS_REGEX="^((?!$MAC_REGEX)(?!$LINUX_REGEX).)*$"
    [[ -z "${PREFERRED_FORMAT[@]}" ]] && EXTN_REGEX=("${WINDOWS_EXTN_DEFAULT[@]}") || EXTN_REGEX=("${PREFERRED_FORMAT[@]}")
  fi

  # Check if the provided list of files has files without extension. If so, install that
  # file (precompiled binary)
  # If not, find the appropriate archive/installer that will then be used by the ansible playbook
  NO_EXTN_FILES=( $(printf '%s\n' "${ALL_NAMES[@]}" | grep -Po $NO_EXTN_REGEX) )
  if [[ ${#NO_EXTN_FILES[@]} -gt 0 ]]; then
    OS_FILTER_REGEX=".*(?i)$OS_REGEX.*"
    FILTERED_LIST=$(printf '%s\n' "${NO_EXTN_FILES[@]}" | grep -Po $OS_FILTER_REGEX)

    FILE_REGEX="(?i)$BINARY_NAME[-_a-zA-Z]*[-v]{0,1}((\d*\.)*\d*[-_]{0,1}(?i)$OS_REGEX)[-_]{0,1}((arm|amd|x86_|x){0,1}64){0,1}$"
    if [[ $OS_FAMILY == 'win32nt' ]]; then
      FILE_REGEX=${FILE_REGEX%%"\$"}".exe$"
    fi
    FILE_NAME=$(printf '%s\n' "${FILTERED_LIST[@]}" | grep -Po $FILE_REGEX)
    echo 'NO_EXTN'$FILE_NAME
  else
    # If a preferred installation method is provided, check if a matching file name is
    # available. If none if available, use the `DEFAULT` list of extensions and find an
    # installer to use. To enable this, the process is run twice. If there is a match in
    # the first iteration, further processing using the `DEFAULT` list is skipped

    # If not preference is provided, iterate over the `DEFAULT` list. The value of `count`
    # is set to 1 in this case, 0 otherwise
    if [[ -z "${PREFERRED_FORMAT[@]}" ]]; then
      count=1
    else
      count=0
    fi

    while [[ $count -le 1 ]]; do
      # Iterate through the list of extensions defined to find matching file names
      declare -a FILE_NAMES
      for rgx in "${EXTN_REGEX[@]}"; do
        if [[ -z $FILE_NAMES ]]; then
          FILE_NAMES=$(printf '%s\n' "${ALL_NAMES[@]}" | grep -Po ".*(?i)$rgx$")
          FILE_NAMES=( ${FILE_NAMES// /\n} )
        fi
      done

      # In cases where there are multiple files matched (e.g. zip, tar, etc.), use additional
      # criteria to filter out files. First one checks for those that are not for 32-bit systems,
      # 2nd one checks those that have a 64 bit system string in the name and 4th contains
      # the OS_FAMILY filter.
      # 3rd one, 'musl' is for linux with static binaries. This has an additional processing
      # step because some releases have just 'musl' in the name but not 'linux'. In those cases,
      # this will match them before going to the 4th regex (which will remove all names and
      # that has to be avoided). In cases where there is no 'musl' it will just send the filtered
      # list as is to be filtered by the OS_REGEX
      FILTER_REGEX=( "^((?!32).)*$" "([^(?i)ppc](arm|amd|x86_|x){0,1}64)" musl $OS_REGEX )

      for frgx in "${FILTER_REGEX[@]}"; do
        if [[ "${#FILE_NAMES[@]}" -gt 1 ]]; then
          FILE_NAMES_TMP=$(printf '%s\n' "${FILE_NAMES[@]}" | grep -Po "^.*((?i)$frgx)+.*$")
          if [[ "$frgx" == 'musl' ]]; then
            if [[ -z "${FILE_NAMES_TMP[@]}" ]]; then
              continue
            fi
          fi
          FILE_NAMES=( ${FILE_NAMES_TMP// /\n} )
        fi
      done

      FILE_NAME=$(printf '%s\n' "${FILE_NAMES[@]}" | grep -Po "$NON_OS_REGEX")
      if [[ -n "$FILE_NAME" ]]; then
        echo "$FILE_NAME"
        break
      fi
      (( count++ ))
    done
  fi
}

find_checksum() {
  ALL_URLS=( $1 )
  ARCHIVE_NAME=$2

  # Check if there are 2 URLs. This is the case in one GitHub Repository, which publishes
  # a checksum file containing multiple values, and a companion file describing the order
  # of algorithms used. The fields are separated by 2 space characters
  # If there is only one URL, then find the checksum (SHA256) based on the binary name.
  # If there are 2 URLs, find the checksum based on the field that contains SHA256 sum.
  if [[ ${#ALL_URLS[@]} -eq 1 ]]; then
    CHECKSUMS=$(curl -Ls "${ALL_URLS[0]}")
    CHECKSUM_REGEX="[[:print:]]+$ARCHIVE_NAME"

    [[ $CHECKSUMS =~ $CHECKSUM_REGEX ]]
    CHECKSUM_ARCHIVE="${BASH_REMATCH[0]}"
    echo "${CHECKSUM_ARCHIVE//[[:blank:]]*$ARCHIVE_NAME/}"
  elif [[ ${#ALL_URLS[@]} -eq 2 ]]; then
    CHECKSUMS=$(curl -Ls $(printf '%s\n' "${ALL_URLS[@]}" | grep -Po '.*checksums*$'))
    CHECKSUMS_INFO=$(curl -Ls $(printf '%s\n' "${ALL_URLS[@]}" | grep -Po '.*(hash|order|info).*$'))

    HASH_INDEX=$(echo "$CHECKSUMS_INFO" | grep -nP '(SHA256|SHA-256)' | cut -d: -f 1)
    HASH=$(echo "$CHECKSUMS" | grep "$ARCHIVE_NAME " | cut -d ' ' -f $(( $HASH_INDEX*2+1 )))
    echo "$HASH"
  fi
}
