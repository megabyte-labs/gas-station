#!/bin/bash
GIT_DIFF_FILES=$(git diff-tree --no-commit-id --name-only -r be05898f)
MODIFIED_DIRS=()
for i in "${GIT_DIFF_FILES[@]}"
do
    if [[ $i =~ \.yml$ ]]; then
        TRIMMED_DIR="$(echo "$i" | cut -f 1,2,3 -d '/')"
        if [[ ! " ${MODIFIED_DIRS[*]} " =~ ${TRIMMED_DIR} ]]; then
            echo "YAAA"
            echo "$i"
            MODIFIED_DIRS[${#MODIFIED_DIRS[@]}]=${TRIMMED_DIR}
        fi
    fi
done

for j in "${MODIFIED_DIRS[@]}"
do
    cd "$j" || exit
    molecule test -s docker || continue
    cd ../../.. || exit
done