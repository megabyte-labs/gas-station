#!/usr/bin/env bash

# @file .gitlab/ci/scripts/propagate-groups.sh
# @brief Triggers the pipelines of downstream common file groups
# @description Grabs all the project IDs associated with the group IDs specified as a comma
#   seperated list in a CI variable. After that, it triggers the pipeline for all of the projects.
#   This is used to keep documentation and meta files in sync across repository groups.

set -eo pipefail

# @description Basic function for acquiring the value for a specific key in a JSON response
#
# @example
#   parseJSON "$JSON_RESPONSE" 'object_key'
#
# @arg $1 string The JSON payload
# @arg $2 string The key you wish to retrieve the data from
#
# @exitcode 0 If the JSON was successfully parsed
# @exitcode 1+ If there was an error parsing the JSON or acquiring the data
function parseJSON() {
  echo "$1" \
    | sed -e 's/[{}]/''/g' \
    | sed -e 's/", "/'\",\"'/g' \
    | sed -e 's/" ,"/'\",\"'/g' \
    | sed -e 's/" , "/'\",\"'/g' \
    | sed -e 's/","/'\"---SEPERATOR---\"'/g' \
    | awk -F=':' -v RS='---SEPERATOR---' "\$1~/\"$2\"/ {print}" \
    | sed -e "s/\"$2\"://" \
    | tr -d "\n\t" \
    | sed -e 's/\\"/"/g' \
    | sed -e 's/\\\\/\\/g' \
    | sed -e 's/^[ \t]*//g' \
    | sed -e 's/^"//' -e 's/"$//' \
    | cut -f1 -d'"'
}

# @description Triggers the pipeline for all the projects in a specific group
#
# @example
#   triggerUpdates 'groupIDXkjdn' '1'
#
# @arg $1 string The GitLab group ID
# @arg $2 string The index (used for recursion)
#
# @exitcode 0 If the projects were successfully looped through
# @exitcode 1+ If there was an error looping through the projects or recursively calling the same function
function triggerUpdates() {
  # shellcheck disable=SC2155
  local PROJECT_IDS=$(curl -s -H "Content-Type: application/json" -H "PRIVATE-TOKEN: ${PRIVATE_READ_ONLY_TOKEN}" "https://gitlab.com/api/v4/groups/$1/projects?page=$2" | jq '.[].id')
  # shellcheck disable=SC2207
  local PROJECT_IDS_LIST=($(echo "$PROJECT_IDS" | tr ' ' '\n'))
  echo "${#PROJECT_IDS_LIST[@]} projects being triggered to update."
  for PROJECT_ID in "${PROJECT_IDS_LIST[@]}"; do
    echo "Triggering pipeline for project ID ${PROJECT_ID}"
    RESPONSE=$(curl -s --request POST --form "token=${CI_JOB_TOKEN}" --form ref=master "https://gitlab.com/api/v4/projects/${PROJECT_ID}/trigger/pipeline")
    MESSAGE=$(parseJSON "$RESPONSE" web_url)
    if [ "$MESSAGE" ]; then
      echo "Pipeline URL: $MESSAGE"
    else
      echo "Response did not contain a pipeline URL"
      echo "Response: $RESPONSE"
    fi
  done
  if [ "${#PROJECT_IDS_LIST[@]}" == 20 ]; then
    local PAGE_NUMBER=$(($2 + 1))
    triggerUpdates "$1" "$PAGE_NUMBER"
  fi
}

# @description Loop through the comma-seperated groups stored in the `DOWNSTREAM_GROUP_IDS` environment variable
# and trigger the pipelines for all the projects in those groups.
#
# shellcheck disable=SC2207
GROUP_IDS=($(echo "$DOWNSTREAM_GROUP_IDS" | tr ',' '\n'))
for GROUP_ID in "${GROUP_IDS[@]}"; do
  triggerUpdates "$GROUP_ID" "1"
done
