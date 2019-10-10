#!/usr/bin/env bash
# Given the path to a test tmp directory, populates it with the usual github 
# service tree.
# 
# Add flags to skip/add parts to it?
# 
# Requires $curlman_dev_home to be set before calling.
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

theTmpDir=$($curlman_dev_home/src/main/utils/canonicalise-path.sh "$1")
theCurlmanRootDir=$($curlman_dev_home/src/test-utils/given/a-curlman-root-dir.sh "$theTmpDir")
mkdir "$theCurlmanRootDir/github"
echo "cfg_baseUrl=https://api.github.com" > "$theTmpDir/curlman-root/github/curlman.service.context"

echo "$theCurlmanRootDir/github"
exit 0
