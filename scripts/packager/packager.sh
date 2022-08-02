#!/usr/bin/env bash
FILE=~/input.yml     # Input YAML file
PACKAGE_DIR="$HOME/media" # Direcotory to store the generated packages
S3_BUCKET_PATH="s3_bucket_name/path"

# File contining the names of files to exclude when creating packages
echo -e "*README*\n*LICENSE*\n*CHANGELOG*\n*CREDITS*\n*Readme*\n*Changes*\n*nversion*" > ~/exclude_files

# Function to download the release and create Linux packages
create_linux_packages () {
  while read item; do
    export SFW=$item
    echo "****************Processing $SFW*******************"
    CMDTEMPLATE='fpm --exclude-file ~/exclude_files -s "$SOURCEFMT" -t "$TGT" -n "$SFW" -v "${VERSION//[a-z-_]}" -a "$ARCH"'

    # Read inputs from the provided file
    GHREPO=$(yq '.software_package[env(SFW)]["github"]' $FILE)
    PATTERNS=( $(yq '.software_package[env(SFW)]["linux_patterns"] | .[]' $FILE) )
    POSTINSTALL=$(yq '.software_package[env(SFW)]["linux_postinstall"]' $FILE)
    PREREMOVE=$(yq '.software_package[env(SFW)]["linux_preremove"]' $FILE)
    RELEASEURL=$(yq '.software_package[env(SFW)]["release_url"]' $FILE)
    TAROPTIONS=$(yq '.software_package[env(SFW)]["tar_options"]' $FILE)

    # Skip the software if it does not have any patterns (there are no releases published)
    if [ ${#PATTERNS[@]} != 0 ]; then

      SOURCEFMT=tar
      TARGETFMT=( pacman ) # Array to store the target formats to be generated

      # Add RPM if `rpm` is not in the input patterns
      if [[ ! ${PATTERNS[@]} =~ "rpm" ]]; then
        TARGETFMT+=( "rpm" )
      fi

      # Add DEB if `deb` is not in the input patterns
      # If there is `deb` in the input pattern, use it as the source to generate other package formats
      if [[ ! ${PATTERNS[@]} =~ "deb" ]]; then
        TARGETFMT+=( "deb" )
      fi
      if [[ ${PATTERNS[@]} =~ "deb" ]]; then
        SOURCEFMT="deb"
      fi

      # Build `rpm/pacman` from `deb` or `deb/rpm/pacman` from `tar/gz`
      # Do not build `deb/rpm` if they are published in the repository
      for PATTERN in "${PATTERNS[@]}"; do
        TMP=$(mktemp -d)
        cd $TMP

        # Skip processing if the source is determined to be a `deb` file but there is a `tar` in the list of patterns
        # This avoids having to process the software twice (`deb` as a source and then `tar` as a source)
        if  [[ $SOURCEFMT == "deb" && $PATTERN =~ "tar" ]]; then
          continue;
        fi

        # If RPM is the only format in the input pattern, use it as the source, if not, download the RPM and continue
        if [[ $PATTERN =~ "rpm" && ${#PATTERNS[@]} == 1 ]]; then
          SOURCEFMT="rpm"
          cp *.rpm $PACKAGE_DIR
        elif [[ $PATTERN =~ "rpm" && ${#PATTERNS[@]} > 1 ]]; then
          gh release download -R "$GHREPO" -p "$PATTERN"
          mv *.rpm $PACKAGE_DIR
          continue;
        fi

        # Determine the package version from the repo and download the release.
        # If the release files are hosted external to GitHub use the appropriate URL to download the releases
        VERSION=$(gh release view -R "$GHREPO" --json tagName --jq '.tagName')
        if [[ $RELEASEURL != "null" ]]; then
          EXTURL=$(eval echo "$RELEASEURL$PATTERN")
          curl "$EXTURL" -o "$(eval echo \"${PATTERN##*/}\")"
        else
          gh release download -R "$GHREPO" -p "$PATTERN"
        fi
        RELEASEFILES=( $(find . -type f) )

        # If a pattern results in multiple files being downloaded, then log a message and continue to the item. In this case,
        # the input pattern needs to be adjusted
        if [[ ${#RELEASEFILES[@]} -gt 1 ]]; then
          echo "Multiple releases have been downloaded. Update the pattern (currently '$PATTERN') for '$SFW' so that it matches exactly one release file and rerun..."
        else
          # Set value for the architecture based on the name of the release file
          case "$PATTERN" in
            *arm*|*aarch*|*ARM*|*AARCH*)
              ARCH="arm64"
              ;;
            *)
              ARCH="amd64"
              ;;
          esac

          # If a package has `postinstall` or `preremove` scripts, process them
          if [[ $POSTINSTALL != "null" ]]; then
            echo "$POSTINSTALL" > /tmp/postinstall
            CMDTEMPLATE="$CMDTEMPLATE --after-install /tmp/postinstall"
          fi
          if [[ $PREREMOVE != "null" ]]; then
            echo "$PREREMOVE" > /tmp/preremove
            CMDTEMPLATE="$CMDTEMPLATE --before-remove /tmp/preremove"
          fi

          # Special processing of GZipped (not tar.gz) files and ZIP files
          if [[ (${RELEASEFILES[0]} =~ "gz" && ! ${RELEASEFILES[0]} =~ "tar") || ${RELEASEFILES[0]} =~ "zip" ]]; then
            SOURCEFMT="dir"
            # Packages can be installed to /opt/<package> or /usr/local/bin, depending on the package structure (and input value). Defaults to /opt
            if [[ ${RELEASEFILES[0]} =~ "zip" ]]; then
              INSTALLDIR=$(yq '.software_package[env(SFW)]["install_dir"]' $FILE)
              if [[ $INSTALLDIR == "opt" ]]; then
                DEST="./opt/$SFW"
              elif [[ $INSTALLDIR == "usr" ]]; then
                DEST="./usr/local/bin"
              else
                DEST="./opt/$SFW"
                INSTALLDIR="opt"
              fi

              mkdir -p "$DEST"
              eval $(echo "bsdtar $( [[ $TAROPTIONS != "null" ]] && printf %s "$TAROPTIONS" ) -xf "$TMP/${RELEASEFILES[0]}" -C "$DEST"")
              CMD="$CMDTEMPLATE ./$INSTALLDIR"
            elif [[ ${RELEASEFILES[0]} =~ "gz" ]]; then
              gunzip "$TMP/${RELEASEFILES[0]}"
              BINNAME=$(find . -maxdepth 1 -type f -printf '%f\n')
              CMD="$CMDTEMPLATE $BINNAME=/usr/local/bin/$SFW"
            fi
          fi

          # Handling binary files (checking for the absence of extensions, as check for a '.' does not work since some binary releases have a '.' in the name)
          if [[ ! ${RELEASEFILES[0]} =~ ".deb" && ! ${RELEASEFILES[0]} =~ ".gz" && ! ${RELEASEFILES[0]} =~ ".zip" && ! ${RELEASEFILES[0]} =~ ".tar" && ! ${RELEASEFILES[0]} =~ ".rpm" ]]; then
            SOURCEFMT="dir"
            BINNAME=$(find . -maxdepth 1 -type f -printf '%f\n')
            CMD="$CMDTEMPLATE $BINNAME=/usr/local/bin/$SFW"
          fi

          if [[ $SOURCEFMT == "tar" ]]; then
            CMD="$( [[ $TAROPTIONS != "null" ]] && printf %s "TAR_OPTIONS=$TAROPTIONS" ) $CMDTEMPLATE --prefix /usr/local/bin ${RELEASEFILES[0]}"
          fi
          if [[ $SOURCEFMT == "deb" || $SOURCEFMT == "rpm" ]]; then
            CMD="$CMDTEMPLATE ${RELEASEFILES[0]}"
          fi

          # Create the packages
          for TGT in ${TARGETFMT[@]}; do
            eval "$CMD"

            # Target 'pacman' creates files with extension 'pkg.tar.zst', so the value of `TGT` is changed to move the proper package
            if [[ $TGT == "pacman" ]]; then
              TGT="pkg"
            fi
            mv $SFW*$TGT* $PACKAGE_DIR
          done

          # Since `deb` file are not generated, the downloaded files is moved to the destination and then uploaded
          if [[ $SOURCEFMT == "deb" ]]; then
            mv ${RELEASEFILES[0]} $PACKAGE_DIR
          fi
        fi
        rm -rf "$TMP"
        unset RELEASEFILES
      done
    else
      echo "There are no releases available for '$SFW' for '$OS'"
    fi
    unset SFW GHREPO PATTERNS PATTERN VERSION POSTINSTALL PREREMOVE
  done < <(yq '.software_package | keys | ... comments="" | .[]' $FILE)
}

# Function to download the release and create Mac packages
create_mac_packages () {
  while read item; do
    export SFW=$item
    echo "****************Processing $SFW*******************"
    CMDTEMPLATE='fpm --exclude-file ~/exclude_files -s "$SOURCEFMT" -t "$TGT" -n "$SFW" -v "${VERSION//[a-z-_]}-$ARCH" -a "$ARCH"'

    # Read inputs from the provided file
    GHREPO=$(yq '.software_package[env(SFW)]["github"]' $FILE)
    PATTERNS=( $(yq '.software_package[env(SFW)]["mac_patterns"] | .[]' $FILE) )
    POSTINSTALL=$(yq '.software_package[env(SFW)]["mac_postinstall"]' $FILE)
    PREREMOVE=$(yq '.software_package[env(SFW)]["mac_preremove"]' $FILE)
    RELEASEURL=$(yq '.software_package[env(SFW)]["release_url"]' $FILE)
    TAROPTIONS=$(yq '.software_package[env(SFW)]["mac_tar_options"]' $FILE)

    # Skip the software if it does not have any patterns (there are no releases published)
    if [ ${#PATTERNS[@]} != 0 ]; then
      # Build `rpm/pacman` from `deb` or `deb/rpm/pacman` from `tar/gz`
      # Do not build `deb/rpm` if they are published in the repository
      for PATTERN in "${PATTERNS[@]}"; do

        SOURCEFMT=tar
        TARGETFMT=osxpkg

        TMP=$(mktemp -d)
        cd $TMP

        # Determine the package version from the repo and download the release.
        # If the release files are hosted external to GitHub use the appropriate URL to download the releases
        VERSION=$(gh release view -R "$GHREPO" --json tagName --jq '.tagName')
        if [[ $RELEASEURL != "null" ]]; then
          EXTURL=$(eval echo "$RELEASEURL$PATTERN")
          curl "$EXTURL" -o "$(eval echo \"${PATTERN##*/}\")"
        else
          gh release download -R "$GHREPO" -p "$PATTERN"
        fi
        RELEASEFILES=( $(find . -type f) )

        # If a pattern results in multiple files being downloaded, then log a message and continue to the item. In this case,
        # the input pattern needs to be adjusted
        if [[ ${#RELEASEFILES[@]} -gt 1 ]]; then
          echo "Multiple releases have been downloaded. Update the pattern (currently '$PATTERN') for '$SFW' so that it matches exactly one release file and rerun..."
        else
          # Set value for the architecture based on the name of the release file
          case "$PATTERN" in
            *arm*|*aarch*|*ARM*|*AARCH*|*m1*)
              ARCH="arm64"
              ;;
            *)
              ARCH="amd64"
              ;;
          esac

          # If a package has `postinstall` or `preremove` scripts, process them
          if [[ $POSTINSTALL != "null" ]]; then
            echo "$POSTINSTALL" > /tmp/postinstall
            CMDTEMPLATE="$CMDTEMPLATE --after-install /tmp/postinstall"
          fi
          if [[ $PREREMOVE != "null" ]]; then
            echo "$PREREMOVE" > /tmp/preremove
            CMDTEMPLATE="$CMDTEMPLATE --before-remove /tmp/preremove"
          fi

          # Special processing of GZipped (not tar.gz) files and ZIP files
          if [[ (${RELEASEFILES[0]} =~ "gz" && ! ${RELEASEFILES[0]} =~ "tar") || ${RELEASEFILES[0]} =~ "zip" ]]; then
            SOURCEFMT="dir"
            # Packages can be installed to /Applications or /usr/local/bin, depending on the package structure (and input value). Defaults to /Applications
            if [[ ${RELEASEFILES[0]} =~ "zip" ]]; then
              INSTALLDIR=$(yq '.software_package[env(SFW)]["mac_install_dir"]' $FILE)
              if [[ $INSTALLDIR == "apps" ]]; then
                DEST="./Applications"
                INSTALLDIR="Applications"
              elif [[ $INSTALLDIR == "usr" ]]; then
                DEST="./usr/local/bin"
              else
                DEST="./Applications"
                INSTALLDIR="Applications"
              fi

              mkdir -p "$DEST"
              eval $(echo "bsdtar $( [[ $TAROPTIONS != "null" ]] && printf %s "$TAROPTIONS" ) -xf "$TMP/${RELEASEFILES[0]}" -C "$DEST"")
              CMD="$CMDTEMPLATE ./$INSTALLDIR"
            elif [[ ${RELEASEFILES[0]} =~ "gz" ]]; then
              gunzip "$TMP/${RELEASEFILES[0]}"
              BINNAME=$(find . -maxdepth 1 -type f | sed -e 's|./||')
              CMD="$CMDTEMPLATE $BINNAME=/usr/local/bin/$SFW"
            fi
          fi

          # Handling binary files (checking for the absence of extensions, as check for a '.' does not work since some binary releases have a '.' in the name)
          if [[ ! ${RELEASEFILES[0]} =~ ".gz" && ! ${RELEASEFILES[0]} =~ ".zip" && ! ${RELEASEFILES[0]} =~ ".tar" ]]; then
            SOURCEFMT="dir"
            BINNAME=$(find . -maxdepth 1 -type f | sed -e 's|./||')
            CMD="$CMDTEMPLATE $BINNAME=/usr/local/bin/$SFW"
          fi

          if [[ $SOURCEFMT == "tar" ]]; then
            CMD="$( [[ $TAROPTIONS != "null" ]] && printf %s "TAR_OPTIONS=$TAROPTIONS" ) $CMDTEMPLATE --prefix /usr/local/bin ${RELEASEFILES[0]}"
          fi

          # Create the packages
          for TGT in ${TARGETFMT[@]}; do
            eval "$CMD"

            mv $SFW*.pkg $PACKAGE_DIR
          done
        fi
        rm -rf "$TMP"
        unset RELEASEFILES
      done
    else
      echo "There are no releases available for '$SFW' for '$OS'"
    fi
    unset SFW GHREPO PATTERNS PATTERN VERSION POSTINSTALL PREREMOVE
  done < <(yq '.software_package | keys | ... comments="" | .[]' $FILE)
}

export OS="$(uname)"
case $OS in
  'Linux')
    # Install prerequisites
    apt update -y
    apt install -y binutils cpio curl gh git language-pack-en-base libarchive-tools rpm ruby xz-utils zstd
    gem install fpm
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    if [[ ! -a /usr/local/bin/yq ]]; then
      gh release download -R mikefarah/yq -p yq_linux_amd64 -D /usr/local/bin
      mv /usr/local/bin/yq_linux_amd64 /usr/local/bin/yq
      chmod +x /usr/local/bin/yq
    fi

    if [[ ! -a /usr/local/bin/s5cmd ]]; then
      gh release download -R peak/s5cmd -p *Linux-64bit.tar.gz
      tar -xf s5cmd*.tar.gz --exclude=CHANGELOG.md --exclude=LICENSE --exclude=README.md -C /usr/local/bin
    fi
    mkdir -p "$PACKAGE_DIR"

    create_linux_packages
    ;;
  'Darwin')
    brew install gnu-tar gh yq peak/tap/s5cmd
    export PATH=/usr/local/opt/gnu-tar/libexec/gnubin:$PATH
    mkdir -p "$PACKAGE_DIR"

    create_mac_packages
    ;;
  *) ;;
esac

# Upload the generated packages to S3 bucket
s5cmd cp "$PACKAGE_DIR/" "s3://$S3_BUCKET_PATH"
