#!/usr/bin/env bash
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Args: «$@»"
thisDir="${0%/*}"
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: thisDir: «$thisDir»"

thePath=$($thisDir/canonicalise-path.sh "$1")
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: thePath: «$thePath»"

currentPath=''
IFS='/' read -r -a array <<< ${thePath#/}
for element in "${array[@]}"; do
    currentPath="$currentPath/$element"
    test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: currentPath: «$currentPath»"
    if [[ -f "$currentPath" ]]; then
        echo "ERROR: Cannot create directory in '$currentPath'. Is a file."
        exit 1
    elif [[ ! -e  "$currentPath" ]]; then
        mkdir "$currentPath"
    fi
done

exit 0
