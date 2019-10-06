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
$thisDir/../main/utils/safe-mkdir.sh "$tmpDir/some/complex/path"
exitCode=$?

# ASSERT
if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: safe-mkdir ended abnormally: $exitCode"
    exit 1
fi

if [[ ! -d "$tmpDir/some" ]]; then
    echo "[$(basename $0)]: FAIL: safe-mkdir did not create intermediate directory «$tmpDir/some»."
fi

if [[ ! -d "$tmpDir/some/complex" ]]; then
    echo "[$(basename $0)]: FAIL: safe-mkdir did not create intermediate directory «$tmpDir/some/complex»."
fi

if [[ ! -d "$tmpDir/some/complex/path" ]]; then
    echo "[$(basename $0)]: FAIL: safe-mkdir did not create intermediate directory «$tmpDir/some/complex/path»."
fi

echo "[$(basename $0)]: PASS"
exit 0
