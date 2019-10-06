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
thisDir=$($thisDir/../main/utils/canonicalise-path.sh "$thisDir")
pushd $tmpDir > /dev/null

# ACT
theCurlman="$thisDir/../main/curlman.sh add service github https://api.github.com"
$theCurlman
exitCode=$?
popd > /dev/null

# ASSERT
if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended abnormally: $exitCode"
    exit 1
fi

if [[ ! -d "$tmpDir/github" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create service directory «$tmpDir/github»."
    exit 1
fi

if [[ ! -f "$tmpDir/github/curlman.service.context" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create curlman.service.context file «$tmpDir/github/curlman.service.context»."
    exit 1
fi

echo "cfg_baseUrl=https://api.github.com" > "$tmpDir/expected.curlman.service.context"
diff "$tmpDir/github/curlman.service.context" "$tmpDir/expected.curlman.service.context"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]:[FAIL]: «$tmpDir/github/curlman.service.context» differs from expectation."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
