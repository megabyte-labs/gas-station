#!/bin/bash

# Determines which roles have been modified and then loops
# through them, running `molecule test -s docker`

GIT_DIFF_FILES=$(git diff-tree --no-commit-id --name-only -r 14e85d62)
MODIFIED_DIRS=()
GIT_DIFF_FILES_ARRAY=()
while IFS='' read -r line; do GIT_DIFF_FILES_ARRAY+=("$line"); done < <(echo "$GIT_DIFF_FILES" | tr ' ' '\n')
for i in "${GIT_DIFF_FILES_ARRAY[@]}"; do
  if [[ $i =~ \.yml$ ]]; then
    TRIMMED_DIR="$(echo "$i" | cut -f 1,2,3 -d '/')"
    if [[ ! " ${MODIFIED_DIRS[*]} " =~ ${TRIMMED_DIR} ]]; then
      MODIFIED_DIRS[${#MODIFIED_DIRS[@]}]=${TRIMMED_DIR}
    fi
  fi
done

EXIT_CODE_SUM=0
for j in "${MODIFIED_DIRS[@]}"; do
  cd "$j" || continue
  SNAP_REFERENCES=$(grep -Ril "community.general.snap:" ./tasks)
  if [ "$SNAP_REFERENCES" ]; then
    molecule test -s docker-snap || EXIT_CODE=$?
  else
    molecule test -s docker || EXIT_CODE=$?
  fi
  EXIT_CODE_SUM=$((EXIT_CODE_SUM + EXIT_CODE))
  cd ../../.. || continue
done

exit "$EXIT_CODE_SUM"
