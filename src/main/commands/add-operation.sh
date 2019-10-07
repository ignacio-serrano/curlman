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

httpMethod=$(echo "$1" | tr '[:lower:]' '[:upper:]')
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: httpMethod: «$httpMethod»"
shift

# TODO: Add support to specify the candidateDir as $3 argument (like in add-service.sh).
# TODO: or add support to specify the service as $3 argument (like in add-service.sh).
if [[ $# -ge 1 ]]; then
    resourcePath="$1"
    shift
fi

# TODO: Add implement resource creation on-the-fly.

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
    echo "ERROR: Cannot create operation. Target directory «$candidateDir» doesn't belong to a service."
    exit 1
fi
#unset candidateDir

test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Resolved serviceDir: «$serviceDir»"

operationScript="$candidateDir/$httpMethod.sh"
touch "$operationScript"

# Believe it or not, everything written between this command and an EOL would be
# written to a file.
#cat >> "$operationScript" << EOL
