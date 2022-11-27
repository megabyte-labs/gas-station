#!/usr/bin/env bash

# @file .gitlab/ci/scripts/cancel-pipeline.sh
# @brief Cancels the current GitLab CI pipeline

set -eox pipefail

# @description Cancels the current pipeline
#
# @noarg
#
# @exitcode 0 If the GitLab pipeline API responded without an HTTP error
# @exitcode 1+ If the GitLab pipeline API responded with an HTTP error
function cancelPipeline() {
  if [[ $(git status --porcelain) ]]; then
    curl --request POST --header "PRIVATE-TOKEN: ${GROUP_ACCESS_TOKEN}" "https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/pipelines/${CI_PIPELINE_ID}/cancel"
  fi
}

# @description Cancel the current pipeline
cancelPipeline
