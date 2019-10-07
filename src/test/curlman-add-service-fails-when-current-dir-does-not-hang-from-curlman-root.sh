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
tmpDir=$($thisDir/../main/utils/canonicalise-path.sh "$tmpDir")
pushd $tmpDir > /dev/null

# ACT
theCurlman="$thisDir/../main/curlman.sh add service github https://api.github.com"
$theCurlman > "$tmpDir/out.txt"
exitCode=$?
popd > /dev/null

# ASSERT
if [[ $exitCode -eq 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended normally: $exitCode"
    exit 1
fi

if [[ -d "$tmpDir/github" ]]; then
    echo "[$(basename $0)]: FAIL: curlman created service directory «$tmpDir/github»."
    exit 1
fi

echo "ERROR: Cannot create service. Target directory «$tmpDir» doesn't belong to a curlman tree." > "$tmpDir/expected.out.txt"
diff "$tmpDir/out.txt" "$tmpDir/expected.out.txt"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]:[FAIL]: Output differs expectation."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
