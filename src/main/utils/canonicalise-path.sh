#!/usr/bin/env bash
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: Args: «$@»" >> "$curlman_log"

thePath="$1"
if [[ "${thePath:0:2}" == '..' ]]; then
    test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: thePath is '..' relative." >> "$curlman_log"
    auxPath="$(pwd)"
    auxPath="$(dirname $auxPath)"
    thePath="$auxPath${thePath#..}"
elif [[ "${thePath:0:1}" == '.' ]]; then
    test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: thePath is '.' relative." >> "$curlman_log"
    thePath="$(pwd)${thePath#.}"
elif [[ "${thePath:0:1}" == "/" ]]; then
    test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: thePath is absolute." >> "$curlman_log"
else
    test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: thePath is relative." >> "$curlman_log"
    thePath="$(pwd)/${thePath}"
fi
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: Absolutised path: «$thePath»" >> "$curlman_log"

currentPath=''
IFS='/' read -r -a array <<< ${thePath#/}
for element in "${array[@]}"; do
    if [[ "$element" == '..' ]]; then
        currentPath=$(dirname "$currentPath")
    elif [[ "$element" != '.' ]]; then
        currentPath="$currentPath/$element"
    fi
done

echo "$currentPath"
exit 0
