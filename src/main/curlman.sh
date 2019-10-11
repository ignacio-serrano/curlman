#!/usr/bin/env bash
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: Args: «$@»" >> "$curlman_log"

# Indentifies curlman installation directory.
# TODO: Turn this into a function.
installDir="${0%/*}"
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: installDir: «$installDir»" >> "$curlman_log"
export installDir=$($installDir/utils/canonicalise-path.sh "$installDir")
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: Resolved installDir: «$installDir»" >> "$curlman_log"

if [[ $# -eq 0 ]]; then
    cat "$installDir/docs/usage.txt"
    exit 1
fi

case "$1" in
    '--help')
        cat "$installDir/docs/usage.txt"
        exit 0
    ;;
    '--version')
        echo "0.0.1"
        exit 0
    ;;
esac

exitCode=0
cmd="$1"
shift
case "$cmd" in
    'init')
        $installDir/commands/$cmd.sh $@
        exitCode=$?
    ;;
    'add')
        $installDir/commands/$cmd.sh $@
        exitCode=$?
    ;;
    'request')
        $installDir/commands/$cmd.sh $@
        exitCode=$?
    ;;
    *)
        echo "ERROR: Command «$cmd» does not exist."
        cat "$installDir/docs/usage.txt"
        exit 1
    ;;
esac

exit $exitCode