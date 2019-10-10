#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir=$($curlman_dev_home/src/test-utils/init-tmp-dir.sh "$0")

# ARRANGE
unset debugCurlman

tmpDir=$($curlman_dev_home/src/main/utils/canonicalise-path.sh "$tmpDir")
pushd $tmpDir > /dev/null

# ACT
$curlman_dev_home/src/main/curlman.sh add resource /users > "$tmpDir/out.txt"
exitCode=$?
popd > /dev/null

# ASSERT
if [[ $exitCode -eq 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended normally: $exitCode"
    exit 1
fi

if [[ -d "$tmpDir/users" ]]; then
    echo "[$(basename $0)]: FAIL: curlman created resource directory «$tmpDir/users»."
    exit 1
fi

echo "ERROR: Cannot create resource. Target directory «$tmpDir» doesn't belong to a service." > "$tmpDir/expected.out.txt"
diff "$tmpDir/out.txt" "$tmpDir/expected.out.txt"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]:[FAIL]: Output differs expectation."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0