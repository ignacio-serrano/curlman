#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir="$curlman_dev_home/tmp"
if [[ ! -e  "$tmpDir" ]]; then
    mkdir "$tmpDir"
fi
tmpDir="$tmpDir/misc"
if [[ ! -e  "$tmpDir" ]]; then
    mkdir "$tmpDir"
fi
tmpDir="$tmpDir/$(basename $0)"
if [[ -e  "$tmpDir" ]]; then
    rm -r "$tmpDir"
fi
mkdir "$tmpDir"

# ARRANGE
unset debugCurlman
mkdir "$tmpDir/curlman-root"
touch "$tmpDir/curlman-root/curlman.context"
mkdir "$tmpDir/curlman-root/github"
touch "$tmpDir/curlman-root/github/curlman.service.context"

thisDir="${0%/*}"

# ACT
installDir="$curlman_dev_home/src/main"
export installDir=$($installDir/utils/canonicalise-path.sh "$installDir")
tmpDir=$($installDir/utils/canonicalise-path.sh "$tmpDir")

ret=$($installDir/misc/resolve-service-dir.sh "$tmpDir/curlman-root/github/any/resource/path")

# ASSERT
if [[ "$ret" != "$tmpDir/curlman-root/github" ]]; then
    echo "[$(basename $0)]: FAIL: resolve-service-dir.sh returned «$ret». Expected «$tmpDir/curlman-root/github»."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
