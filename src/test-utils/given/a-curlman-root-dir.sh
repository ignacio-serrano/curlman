#!/usr/bin/env bash
# Given the path to a test tmp directory, populates it with a curlman root 
# directory.
# 
# Return the path of the curlman root directory?
# 
# Requires $curlman_dev_home to be set before calling.
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

theTmpDir="$1"
mkdir "$theTmpDir/curlman-root"
touch "$theTmpDir/curlman-root/curlman.context"

echo "$theTmpDir/curlman-root"
exit 0
