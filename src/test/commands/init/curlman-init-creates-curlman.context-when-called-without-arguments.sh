#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir=$($curlman_dev_home/src/test-utils/init-tmp-dir.sh "$0")

# ARRANGE

pushd $tmpDir > /dev/null

# ACT
$curlman_dev_home/src/main/curlman.sh init
exitCode=$?
popd > /dev/null

# ASSERT
if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended abnormally: $exitCode"
    exit 1
fi

if [[ ! -f "$tmpDir/curlman.context" ]]; then
    echo "[$(basename $0)]:FAIL: «$tmpDir/curlman.context» was not created."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
