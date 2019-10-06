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
touch "$tmpDir/some-file"
thisDir="${0%/*}"

# ACT
$thisDir/../main/utils/safe-mkdir.sh "$tmpDir/some-file/path" > "$tmpDir/out.txt"
exitCode=$?

# ASSERT
if [[ $exitCode -eq 0 ]]; then
    echo "[$(basename $0)]: FAIL: safe-mkdir ended normally: $exitCode"
    exit 1
fi

tmpDir=$($thisDir/../main/utils/canonicalise-path.sh "$tmpDir")
echo "ERROR: Cannot create directory in '$tmpDir/some-file'. Is a file." > "$tmpDir/expected.out.txt"
diff "$tmpDir/out.txt" "$tmpDir/expected.out.txt"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: Output differs expectation."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
