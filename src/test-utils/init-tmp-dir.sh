#!/usr/bin/env bash
# Given the path to a file (hopefully a test script file), creates an empty 
# directory under $curlman_dev_home/tmp/test whose path relative to it, it's 
# the same as the path of the file relative to $curlman_dev_home/src/test.
# Then returns the absolute path to the new directory.
# 
# Requires $curlman_dev_home to be set before calling.
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

theTestScript=$($curlman_dev_home/src/main/utils/canonicalise-path.sh "$1")
eval theRelativePathToCreate="\${theTestScript#$curlman_dev_home/src/test/}"
theRelativePathToCreate="tmp/test/$theRelativePathToCreate"

currentPath="$curlman_dev_home"
IFS='/' read -r -a array <<< ${theRelativePathToCreate#/}
for element in "${array[@]}"; do
    currentPath="$currentPath/$element"
    if [[ -f "$currentPath" ]]; then
        echo "ERROR: Cannot create directory in '$currentPath'. Is a file."
        exit 1
    elif [[ ! -e  "$currentPath" ]]; then
        mkdir "$currentPath"
    fi
done
rm -rf "$currentPath"/*

echo "$currentPath"
exit 0
