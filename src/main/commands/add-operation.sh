#!/usr/bin/env bash
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Args: «$@»"
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: installDir: «$installDir»"

case "$1" in
    '--help')
        cat "$installDir/docs/add-operation-usage.txt"
        exit 0
    ;;
esac

if [[ $# -lt 1 ]]; then
    echo "ERROR: You must specify an HTTP method."
    cat "$installDir/docs/add-operation-usage.txt"
    exit 1
fi

resourcePath="$1"

# TODO: Add support to specify the candidateDir as $2 argument (like in add-service.sh).
# TODO: or add support to specify the service as $2 argument (like in add-service.sh).
candidateDir="$(pwd)"

currentDir="$candidateDir"
while [[ "$currentDir" != "/" ]]; do
    if [[ -f "$currentDir/curlman.service.context" ]]; then
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

test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Resolved serviceDir: «$serviceDir»"

if [[ "${resourcePath:0:1}" == "/" ]]; then
    tgtDir="$serviceDir/${resourcePath#/}"
else
    tgtDir="$(pwd)/${resourcePath#/}"
fi
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: tgtDir: «$tgtDir»"

$installDir/utils/safe-mkdir.sh "$tgtDir"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    exit $exitCode
fi
