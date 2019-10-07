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
echo "cfg_baseUrl=https://api.github.com" >> "$tmpDir/curlman-root/github/curlman.service.context"
mkdir "$tmpDir/curlman-root/github/users"

thisDir="${0%/*}"
thisDir=$($thisDir/../main/utils/canonicalise-path.sh "$thisDir")
tmpDir=$($thisDir/../main/utils/canonicalise-path.sh "$tmpDir")
pushd "$tmpDir/curlman-root/github/users" > /dev/null

# ACT
theCurlman="$thisDir/../main/curlman.sh add operation get"
$theCurlman > "$tmpDir/out.txt"
exitCode=$?
popd > /dev/null

# ASSERT
if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended abnormally: $exitCode"
    exit 1
fi

if [[ ! -f "$tmpDir/curlman-root/github/users/GET" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create GET file «$tmpDir/curlman-root/github/users/GET»."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
