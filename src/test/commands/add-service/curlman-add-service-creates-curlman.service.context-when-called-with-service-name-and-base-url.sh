#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir=$($curlman_dev_home/src/test-utils/init-tmp-dir.sh "$0")

# ARRANGE
theCurlmanRootDir=$($curlman_dev_home/src/test-utils/given/a-curlman-root-dir.sh "$tmpDir")

pushd "$theCurlmanRootDir" > /dev/null

# ACT
$curlman_dev_home/src/main/curlman.sh add service github https://api.github.com
exitCode=$?
popd > /dev/null

# ASSERT
if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended abnormally: $exitCode"
    exit 1
fi

if [[ ! -d "$theCurlmanRootDir/github" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create service directory «$theCurlmanRootDir/github»."
    exit 1
fi

if [[ ! -f "$theCurlmanRootDir/github/curlman.service.context" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create curlman.service.context file «$theCurlmanRootDir/github/curlman.service.context»."
    exit 1
fi

echo "cfg_baseUrl=https://api.github.com" > "$tmpDir/expected.curlman.service.context"
diff "$theCurlmanRootDir/github/curlman.service.context" "$tmpDir/expected.curlman.service.context"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]:[FAIL]: «$tmpDir/curlman-root/github/curlman.service.context» differs from expectation."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
