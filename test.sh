#!/usr/bin/env bash
if [[ $# -gt 0 ]]; then
    for file in "$@"; do
        $file
    done
else
    thisDir="${0%/*}"
    for file in $(find $thisDir/src/test ! -name 'skip-*' -a -name '*.sh'); do
        $file
    done
fi
