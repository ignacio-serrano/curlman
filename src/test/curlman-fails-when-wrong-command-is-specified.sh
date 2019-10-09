#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir="$curlman_dev_home/tmp"
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
$curlman_dev_home/src/main/curlman.sh wrong-command > "$tmpDir/out.txt"
exitCode=$?

# ASSERT
if [[ $exitCode -eq 0 ]]; then
    echo "[$(basename $0)]:[FAIL]: curlman ended normally: $exitCode"
    exit 1
fi

echo "ERROR: Command «wrong-command» does not exist." > "$tmpDir/expected.out.txt"
cat "$curlman_dev_home/src/main/docs/usage.txt" >> "$tmpDir/expected.out.txt"
diff "$tmpDir/out.txt" "$tmpDir/expected.out.txt"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]:[FAIL]: Output differs expectation."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
