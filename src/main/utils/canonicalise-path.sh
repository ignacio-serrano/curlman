#!/usr/bin/env bash
#test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Args: «$@»"

thePath="$1"
if [[ "${thePath:0:2}" == '..' ]]; then
    #test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: thePath is '..' relative."
    auxPath="$(pwd)"
    auxPath="$(dirname $auxPath)"
    thePath="$auxPath${thePath#..}"
elif [[ "${thePath:0:1}" == '.' ]]; then
    #test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: thePath is '.' relative."
    thePath="$(pwd)${thePath#.}"
elif [[ "${thePath:0:1}" == "/" ]]; then
    #test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: thePath is absolute."
    :
else
    #test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: thePath is relative."
    thePath="$(pwd)/${thePath}"
fi
#test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Absolutised path: «$thePath»"

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
