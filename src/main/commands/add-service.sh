#!/usr/bin/env bash
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: Args: «$@»" >> "$curlman_log"
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: installDir: «$installDir»" >> "$curlman_log"

case "$1" in
    '--help')
        cat "$installDir/docs/add-service-usage.txt"
        exit 0
    ;;
esac

if [[ $# -lt 2 ]]; then
    echo "ERROR: You must specify a service name and a base URL."
    cat "$installDir/docs/add-service-usage.txt"
    exit 1
fi

serviceName="$1"
baseUrl="$2"

candidateDir="$(pwd)"
if [[ $# -ge 3 ]]; then
    candidateDir=$($installDir/utils/canonicalise-path.sh "$3")
fi

currentDir="$candidateDir"
while [[ "$currentDir" != "/" ]]; do
    if [[ -f "$currentDir/curlman.context" ]]; then
        tgtDir="$currentDir"
        break;
    fi
    currentDir=$(dirname "$currentDir")
done

if [[ -z "$tgtDir" ]]; then
    echo "ERROR: Cannot create service. Target directory «$candidateDir» doesn't belong to a curlman tree."
    exit 1
fi
unset candidateDir

tgtDir="$tgtDir/$serviceName"
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: Resolved tgtDir: «$tgtDir»" >> "$curlman_log"

# TODO: Enable overwritting of file/directory with flag (perhaps -f).
if [[ -e "$tgtDir" ]]; then
    echo "ERROR: Cannot create service «$serviceName». «$tgtDir» already exists."
    exit 1
fi
mkdir "$tgtDir"

echo "cfg_baseUrl=${baseUrl%/}" > "$tgtDir/curlman.service.context"
