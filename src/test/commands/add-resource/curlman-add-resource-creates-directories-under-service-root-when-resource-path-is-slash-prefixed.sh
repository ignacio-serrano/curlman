#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir=$($curlman_dev_home/src/test-utils/init-tmp-dir.sh "$0")

# ARRANGE
theServiceDir=$($curlman_dev_home/src/test-utils/given/a-github-service-dir.sh "$tmpDir")
mkdir "$theServiceDir/some"
mkdir "$theServiceDir/some/other"
mkdir "$theServiceDir/some/other/resource"

pushd "$theServiceDir/some/other/resource" > /dev/null

# ACT
$curlman_dev_home/src/main/curlman.sh add resource /users > "$tmpDir/out.txt"
exitCode=$?
popd > /dev/null

# ASSERT
if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended abnormally: $exitCode"
    exit 1
fi

if [[ ! -d "$theServiceDir/users" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create resource directory «$theServiceDir/users»."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
