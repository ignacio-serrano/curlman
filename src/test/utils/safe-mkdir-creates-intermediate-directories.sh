#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir=$($curlman_dev_home/src/test-utils/init-tmp-dir.sh "$0")

# ARRANGE
unset debugCurlman

# ACT
$curlman_dev_home/src/main/utils/safe-mkdir.sh "$tmpDir/some/complex/path"
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
