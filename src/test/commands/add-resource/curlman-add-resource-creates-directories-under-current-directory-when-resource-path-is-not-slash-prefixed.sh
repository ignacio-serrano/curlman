#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir=$($curlman_dev_home/src/test-utils/init-tmp-dir.sh "$0")

# ARRANGE
theServiceDir=$($curlman_dev_home/src/test-utils/given/a-github-service-dir.sh "$tmpDir")
mkdir "$theServiceDir/users"

pushd "$theServiceDir/users" > /dev/null

# ACT
$curlman_dev_home/src/main/curlman.sh add resource {username} > "$tmpDir/out.txt"
exitCode=$?
popd > /dev/null

# ASSERT
if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended abnormally: $exitCode"
    exit 1
fi

if [[ ! -d "$theServiceDir/users/{username}" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create resource directory «$theServiceDir/users/{username}»."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
