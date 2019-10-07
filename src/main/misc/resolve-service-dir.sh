#!/usr/bin/env bash
# Given a path, returns the closest parent directory that contains a file 
# named curlman.service.context. If there isn't any, returns an empty string.
# Requires installDir to be set before calling.
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Args: «$@»"
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: installDir: «$installDir»"

thePath=$($installDir/utils/canonicalise-path.sh "$1")
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: thePath: «$thePath»"

currentDir="$thePath"
while [[ "$currentDir" != "/" ]]; do
    if [[ -f "$currentDir/curlman.service.context" ]]; then
        serviceDir="$currentDir"
        break;
    fi
    currentDir=$(dirname "$currentDir")
done
echo $serviceDir