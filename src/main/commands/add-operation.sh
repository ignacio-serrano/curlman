#!/usr/bin/env bash
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: Args: «$@»" >> "$curlman_log"
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: installDir: «$installDir»" >> "$curlman_log"

case "$1" in
    '--help')
        cat "$installDir/docs/add-operation-usage.txt"
        exit 0
    ;;
esac

if [[ $# -lt 1 ]] || [[ "${1:0:1}" == '-' ]]; then
    echo "ERROR: You must specify an HTTP method."
    cat "$installDir/docs/add-operation-usage.txt"
    exit 1
fi

httpMethod=$(echo "$1" | tr '[:lower:]' '[:upper:]')
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: httpMethod: «$httpMethod»" >> "$curlman_log"
shift

# TODO: Add support to specify the candidateDir as $3 argument (like in add-service.sh).
# TODO: or add support to specify the service as $3 argument (like in add-service.sh).
declare -a queryParams
queryParamsIdx=0
unset queryParamFlag
if [[ $# -ge 1 ]]; then
    for arg in "$@"; do
        if [[ "$arg" == "--query-parameter" ]]; then
            queryParamFlag=1
        elif [[ $queryParamFlag ]]; then
            queryParams[$queryParamsIdx]=$arg
            queryParamsIdx=$((queryParamsIdx + 1))
            unset queryParamFlag
        else
            echo "ERROR: Unexpected argument «$arg»."
            exit 1
        fi
    done
#    resourcePath="$1"
#    shift
fi

# TODO: Add implement resource creation on-the-fly.

candidateDir="$(pwd)"

serviceDir=$($installDir/misc/resolve-service-dir.sh "$candidateDir")
if [[ -z "$serviceDir" ]]; then
    echo "ERROR: Cannot create operation. Target directory «$candidateDir» doesn't belong to a service."
    exit 1
fi
#unset candidateDir

test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: Resolved serviceDir: «$serviceDir»" >> "$curlman_log"

operationFile="$candidateDir/$httpMethod"
touch "$operationFile"
for element in "${queryParams[@]}"; do
    echo "query:$element" >> "$operationFile"
done
# Believe it or not, everything written between this command and an EOL would be
# written to a file.
#cat >> "$operationScript" << EOL
