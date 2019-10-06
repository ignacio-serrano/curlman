#!/usr/bin/env bash
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Args: «$@»"

case "$1" in
    '--help')
        cat "$installDir/docs/init-usage.txt"
        exit 0
    ;;
esac

tgtDir="$(pwd)"
if [[ $# -eq 1 ]]; then
    tgtDir="$1"
fi

$installDir/utils/safe-mkdir.sh "$tgtDir"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    exit $exitCode
fi

touch "$tgtDir/curlman.context"
