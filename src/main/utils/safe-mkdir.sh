#!/usr/bin/env bash
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: Args: «$@»" >> "$curlman_log"
thisDir="${0%/*}"
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: thisDir: «$thisDir»" >> "$curlman_log"

thePath=$($thisDir/canonicalise-path.sh "$1")
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: thePath: «$thePath»" >> "$curlman_log"

currentPath=''
IFS='/' read -r -a array <<< ${thePath#/}
for element in "${array[@]}"; do
    currentPath="$currentPath/$element"
    test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: currentPath: «$currentPath»" >> "$curlman_log"
    if [[ -f "$currentPath" ]]; then
        echo "ERROR: Cannot create directory in '$currentPath'. Is a file."
        exit 1
    elif [[ ! -e  "$currentPath" ]]; then
        mkdir "$currentPath"
    fi
done

exit 0
