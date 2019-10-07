#!/usr/bin/env bash
tmpDir="${0%/*}/../../tmp"
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
installDir="$thisDir/../main"
export installDir=$($installDir/utils/canonicalise-path.sh "$installDir")
tmpDir=$($installDir/utils/canonicalise-path.sh "$tmpDir")

ret=$($thisDir/../main/misc/resolve-service-dir.sh "$tmpDir/curlman-root/github/any/resource/path")

# ASSERT
if [[ "$ret" != "$tmpDir/curlman-root/github" ]]; then
    echo "[$(basename $0)]: FAIL: resolve-service-dir.sh returned «$ret». Expected «$tmpDir/curlman-root/github»."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
