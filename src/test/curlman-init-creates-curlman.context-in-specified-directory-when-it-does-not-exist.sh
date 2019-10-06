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
thisDir=$($thisDir/../main/utils/canonicalise-path.sh "$thisDir")

# ACT
theCurlman="$thisDir/../main/curlman.sh init '$tmpDir/a/curlman-root'"
eval "$theCurlman"
exitCode=$?

# ASSERT
if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended abnormally: $exitCode"
    exit 1
fi

if [[ ! -d "$tmpDir/a" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create intermediate directory «$tmpDir/a»."
fi

if [[ ! -d "$tmpDir/a/curlman-root" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create curlman root directory «$tmpDir/a/curlman-root»."
fi

if [[ ! -f "$tmpDir/a/curlman-root/curlman.context" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create curlman.context «$tmpDir/a/curlman-root/curlman.context»."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
