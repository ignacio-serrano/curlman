#!/usr/bin/env bash
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Args: «$@»"
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: installDir: «$installDir»"

case "$1" in
    '--help')
        cat "$installDir/docs/request-usage.txt"
        exit 0
    ;;
esac

if [[ $# -lt 1 ]]; then
    echo "ERROR: You must specify an operation."
    cat "$installDir/docs/request-usage.txt"
    exit 1
fi

operationFile="$1"

httpMethod=$(basename "$operationFile")
serviceDir=$($installDir/misc/resolve-service-dir.sh "$operationFile")
operationDir=$(dirname "$operationFile")
operationDir=$($installDir/utils/canonicalise-path.sh "$resourcePath")
eval resourcePath="\${operationDir#$serviceDir}"

cfg_editor=vi
while IFS='=' read -r key value; do
    printf -v $key "$value"
done < "$serviceDir/curlman.service.context"

rm -f "$operationDir"/$httpMethod.response.*
curl -D "$operationDir/$httpMethod.response.headers.txt" -o "$operationDir/$httpMethod.response.body" -s -X $httpMethod "$cfg_baseUrl/${resourcePath#/}"

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
