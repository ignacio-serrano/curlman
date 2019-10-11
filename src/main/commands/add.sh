#!/usr/bin/env bash
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: Args: «$@»" >> "$curlman_log"
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: installDir: «$installDir»" >> "$curlman_log"

if [[ $# -eq 0 ]]; then
    cat "$installDir/docs/add-usage.txt"
    exit 1
fi

case "$1" in
    '--help')
        cat "$installDir/docs/add-usage.txt"
        exit 0
    ;;
esac

exitCode=0
cmd="$1"
shift
case "$cmd" in
    'service')
        $installDir/commands/add-$cmd.sh $@
        exitCode=$?
    ;;
    'resource')
        $installDir/commands/add-$cmd.sh $@
        exitCode=$?
    ;;
    'operation')
        $installDir/commands/add-$cmd.sh $@
        exitCode=$?
    ;;
    *)
        echo "ERROR: Command «$cmd» does not exist."
        cat "$installDir/docs/add-usage.txt"
        exit 1
    ;;
esac

exit $exitCode