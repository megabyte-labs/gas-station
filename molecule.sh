#!/bin/bash

# Determines which roles have been modified and then loops
# through them, running `molecule test -s docker`

GIT_DIFF_FILES=$(git diff-tree --no-commit-id --name-only -r "$CI_COMMIT_SHA")
MODIFIED_DIRS=()
for i in "${GIT_DIFF_FILES[@]}"
do
    if [[ $i =~ \.yml$ ]]; then
        TRIMMED_DIR="$(echo "$i" | cut -f 1,2,3 -d '/')"
        if [[ ! " ${MODIFIED_DIRS[*]} " =~ ${TRIMMED_DIR} ]]; then
            MODIFIED_DIRS[${#MODIFIED_DIRS[@]}]=${TRIMMED_DIR}
        fi
    fi
done

EXIT_CODE_SUM=0
for j in "${MODIFIED_DIRS[@]}"
do
    cd "$j" || continue
    set -e
    molecule test -s docker
    EXIT_CODE=$?
    EXIT_CODE_SUM=$(($EXIT_CODE_SUM + $EXIT_CODE))
    set +e
    cd ../../.. || continue
done

exit "$EXIT_CODE_SUM"
