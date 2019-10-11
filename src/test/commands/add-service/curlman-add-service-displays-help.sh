#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir=$($curlman_dev_home/src/test-utils/init-tmp-dir.sh "$0")

# ARRANGE

# ACT
$curlman_dev_home/src/main/curlman.sh add service > "$tmpDir/out.txt"
exitCode=$?

# ASSERT
if [[ $exitCode -eq 0 ]]; then
    echo "[$(basename $0)]:[FAIL]: curlman ended normally: $exitCode"
    exit 1
fi

echo "ERROR: You must specify a service name and a base URL." > "$tmpDir/expected.out.txt"
cat "$curlman_dev_home/src/main/docs/add-service-usage.txt" >> "$tmpDir/expected.out.txt"
diff "$tmpDir/out.txt" "$tmpDir/expected.out.txt"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]:[FAIL]: Output differs expectation."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
