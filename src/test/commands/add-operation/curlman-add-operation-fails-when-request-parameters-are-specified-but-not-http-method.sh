#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir=$($curlman_dev_home/src/test-utils/init-tmp-dir.sh "$0")

# ARRANGE
unset debugCurlman
theServiceDir=$($curlman_dev_home/src/test-utils/given/a-github-service-dir.sh "$tmpDir")
mkdir "$theServiceDir/users"

pushd $tmpDir > /dev/null

# ACT
$curlman_dev_home/src/main/curlman.sh add operation --query-parameter since > "$tmpDir/out.txt"
exitCode=$?
popd > /dev/null

# ASSERT
if [[ $exitCode -eq 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended normally: $exitCode"
    exit 1
fi

if [[ -f "$tmpDir/GET" ]]; then
    echo "[$(basename $0)]: FAIL: curlman created operation file «$tmpDir/GET»."
    exit 1
fi

echo "ERROR: You must specify an HTTP method." > "$tmpDir/expected.out.txt"
cat "$curlman_dev_home/src/main/docs/add-operation-usage.txt" >> "$tmpDir/expected.out.txt"
diff "$tmpDir/out.txt" "$tmpDir/expected.out.txt"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: Output differs expectation."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
