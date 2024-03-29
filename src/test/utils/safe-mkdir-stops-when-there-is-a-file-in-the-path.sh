#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir=$($curlman_dev_home/src/test-utils/init-tmp-dir.sh "$0")

# ARRANGE
touch "$tmpDir/some-file"

# ACT
$curlman_dev_home/src/main/utils/safe-mkdir.sh "$tmpDir/some-file/path" > "$tmpDir/out.txt"
exitCode=$?

# ASSERT
if [[ $exitCode -eq 0 ]]; then
    echo "[$(basename $0)]: FAIL: safe-mkdir ended normally: $exitCode"
    exit 1
fi

tmpDir=$($curlman_dev_home/src/main/utils/canonicalise-path.sh "$tmpDir")
echo "ERROR: Cannot create directory in '$tmpDir/some-file'. Is a file." > "$tmpDir/expected.out.txt"
diff "$tmpDir/out.txt" "$tmpDir/expected.out.txt"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: Output differs expectation."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
