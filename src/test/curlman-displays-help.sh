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

# ACT
theCurlman="${0%/*}/../main/curlman.sh"
$theCurlman > "$tmpDir/out.txt"
exitCode=$?

# ASSERT
if [[ $exitCode -eq 0 ]]; then
    echo "[$(basename $0)]:[FAIL]: curlman ended normally: $exitCode"
    exit 1
fi

diff "$tmpDir/out.txt" "${0%/*}/../../src/main/docs/usage.txt"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]:[FAIL]: Output differs expectation."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
