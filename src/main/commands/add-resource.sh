#!/usr/bin/env bash
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Args: «$@»"
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: installDir: «$installDir»"

case "$1" in
    '--help')
        cat "$installDir/docs/add-resource-usage.txt"
        exit 0
    ;;
esac

if [[ $# -lt 1 ]]; then
    echo "ERROR: You must specify the resource path."
    cat "$installDir/docs/add-resource-usage.txt"
    exit 1
fi

resourcePath="$1"

# TODO: Add support to specify the candidateDir as $2 argument (like in add-service.sh).
# TODO: or add support to specify the service as $2 argument (like in add-service.sh).
candidateDir="$(pwd)"

currentDir="$candidateDir"
while [[ "$currentDir" != "/" ]]; do
    if [[ -f "$currentDir/curlman.context" ]]; then
        serviceDir="$currentDir"
        break;
    fi
    currentDir=$(dirname "$currentDir")
done

if [[ -z "$serviceDir" ]]; then
    echo "ERROR: Cannot create resource. Target directory «$candidateDir» doesn't belong to a service."
    exit 1
fi
unset candidateDir

tgtDir="$tgtDir/$serviceName"
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Resolved tgtDir: «$tgtDir»"

# TODO: Enable overwritting of file/directory with flag (perhaps -f).
if [[ -e "$tgtDir" ]]; then
    echo "ERROR: Cannot create service «$serviceName». «$tgtDir» already exists."
    exit 1
fi
mkdir "$tgtDir"

echo "cfg_baseUrl=${baseUrl%/}" > "$tgtDir/curlman.service.context"
