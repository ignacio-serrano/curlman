#!/usr/bin/env bash
# Given a path, returns the closest parent directory that contains a file 
# named curlman.service.context. If there isn't any, returns an empty string.
# Requires installDir to be set before calling.
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: Args: «$@»" >> "$curlman_log"
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: installDir: «$installDir»" >> "$curlman_log"

thePath=$($installDir/utils/canonicalise-path.sh "$1")
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: thePath: «$thePath»" >> "$curlman_log"

currentDir="$thePath"
while [[ "$currentDir" != "/" ]]; do
    if [[ -f "$currentDir/curlman.service.context" ]]; then
        serviceDir="$currentDir"
        break;
    fi
    currentDir=$(dirname "$currentDir")
done
echo $serviceDir