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

thisDir="${0%/*}"

# ACT
installDir="$thisDir/../main"
export installDir=$($installDir/utils/canonicalise-path.sh "$installDir")
tmpDir=$($installDir/utils/canonicalise-path.sh "$tmpDir")

ret=$($thisDir/../main/misc/resolve-service-dir.sh "$tmpDir/curlman-root/github/any/resource/path")

# ASSERT
if [[ "$ret" != "" ]]; then
    echo "[$(basename $0)]: FAIL: resolve-service-dir.sh returned «$ret». Expected empty string."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
