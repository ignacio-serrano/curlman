#!/usr/bin/env bash
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Args: «$@»"
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: installDir: «$installDir»"

case "$1" in
    '--help')
        cat "$installDir/docs/request-usage.txt"
        exit 0
    ;;
esac

if [[ $# -lt 1 ]] || [[ "${1:0:1}" == '-' ]]; then
    echo "ERROR: You must specify an operation."
    cat "$installDir/docs/request-usage.txt"
    exit 1
fi

operationFile="$1"
shift

if [[ $# -ge 1 ]]; then
    for arg in "$@"; do
        if [[ "$arg" == "--show-command" ]]; then
            showCommandFlag=1
        else
            echo "ERROR: Unexpected argument «$arg»."
            exit 1
        fi
    done
fi

httpMethod=$(basename "$operationFile")
serviceDir=$($installDir/misc/resolve-service-dir.sh "$operationFile")
operationDir=$(dirname "$operationFile")
operationDir=$($installDir/utils/canonicalise-path.sh "$operationDir")
eval resourcePath="\${operationDir#$serviceDir}"

cfg_editor=vi
while IFS='=' read -r key value; do
    printf -v $key "$value"
done < "$serviceDir/curlman.service.context"

curlCommand="curl -D \"$operationDir/$httpMethod.response.headers.txt\" -o \"$operationDir/$httpMethod.response.body\" -s -X $httpMethod \"$cfg_baseUrl/${resourcePath#/}\""
if [[ $showCommandFlag ]]; then
    echo $curlCommand
    exit 0
fi

rm -f "$operationDir"/$httpMethod.response.*
eval "$curlCommand"

findOutMimeType () {
    sed 1d "$operationDir/$httpMethod.response.headers.txt" | while IFS=':' read -r key value; do
        if [[ "${key,,}" == "content-type" ]]; then
            responseContentType=$(echo "$value" | xargs)
            IFS=';' read -r mimeType encoding <<< $responseContentType
            echo "$mimeType"
            return 0
        fi
    done
}

mimeType=$(findOutMimeType)
if [[ "${mimeType,,}" == "application/json" ]]; then
    responseBodyFileName="$operationDir/$httpMethod.response.body.json"
else
    responseBodyFileName="$operationDir/$httpMethod.response.body.txt"
fi
mv "$operationDir/$httpMethod.response.body" "$responseBodyFileName"
$cfg_editor "$responseBodyFileName"

exit 0
