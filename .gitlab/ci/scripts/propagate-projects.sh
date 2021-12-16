#!/usr/bin/env bash

# @file .gitlab/ci/scripts/propagate-projects.sh
# @brief Triggers the pipelines of the repositories that use this repository as their `.common/` submodule
# @description Loops through a list of project IDs stored in the `DOWNSTREAM_PROJECT_IDS` GitLab CI
#   variable and trigger the pipeline for each of those projects.

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

# @description Loops through all of the comma-seperated GitLab project IDs stored in `DOWNSTREAM_PROJECT_IDS`
# and attempts to trigger their pipelines
#
# shellcheck disable=SC2207
PROJECT_IDS=($(echo "$DOWNSTREAM_PROJECT_IDS" | tr ',' '\n'))
for PROJECT_ID in "${PROJECT_IDS[@]}"; do
  echo "Triggering pipeline for project ID ${PROJECT_ID}"
  RESPONSE=$(curl -s --request POST --form "token=${CI_JOB_TOKEN}" --form ref=synchronize --form "variables[PIPELINE_SOURCE]=$CI_PROJECT_ID" "https://gitlab.com/api/v4/projects/${PROJECT_ID}/trigger/pipeline")
  MESSAGE=$(parseJSON "$RESPONSE" web_url)
  if [ "$MESSAGE" ]; then
    echo "Pipeline URL: $MESSAGE"
  else
    echo "Response did not contain a pipeline URL"
    echo "Response: $RESPONSE"
  fi
done
