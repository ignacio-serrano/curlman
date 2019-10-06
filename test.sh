#!/usr/bin/env bash
thisDir="${0%/*}"
for file in $(ls -1p $thisDir/src/test | grep -v /); do
    if [[ "${file:0:5}" != "test-" ]]; then
        $thisDir/src/test/$file
    fi
done
