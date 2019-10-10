#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir=$($curlman_dev_home/src/test-utils/init-tmp-dir.sh "$0")

# ARRANGE
unset debugCurlman
pushd $tmpDir > /dev/null

# ACT
$curlman_dev_home/src/main/curlman.sh add service github https://api.github.com some-dir > "$tmpDir/out.txt"
exitCode=$?
popd > /dev/null

# ASSERT
if [[ $exitCode -eq 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended normally: $exitCode"
    exit 1
fi

if [[ -d "$tmpDir/some-dir" ]]; then
    echo "[$(basename $0)]: FAIL: curlman created intermediate directory «$tmpDir/some-dir»."
    exit 1
fi

if [[ -d "$tmpDir/github" ]]; then
    echo "[$(basename $0)]: FAIL: curlman created service directory «$tmpDir/github»."
    exit 1
fi

if [[ -f "$tmpDir/curlman.service.context" ]]; then
    echo "[$(basename $0)]: FAIL: curlman created curlman.service.context file «$tmpDir/curlman.service.context»."
    exit 1
fi

echo "ERROR: Cannot create service. Target directory «$tmpDir/some-dir» doesn't belong to a curlman tree." > "$tmpDir/expected.out.txt"
diff "$tmpDir/out.txt" "$tmpDir/expected.out.txt"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]:[FAIL]: Output differs expectation."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
