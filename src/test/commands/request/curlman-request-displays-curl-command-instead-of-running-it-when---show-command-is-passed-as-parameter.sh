#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir=$($curlman_dev_home/src/test-utils/init-tmp-dir.sh "$0")

# ARRANGE
unset debugCurlman
mkdir "$tmpDir/curlman-root"
touch "$tmpDir/curlman-root/curlman.context"
mkdir "$tmpDir/curlman-root/github"
touch "$tmpDir/curlman-root/github/curlman.service.context"
echo "cfg_baseUrl=https://api.github.com" >> "$tmpDir/curlman-root/github/curlman.service.context"
mkdir "$tmpDir/curlman-root/github/users"
touch "$tmpDir/curlman-root/github/users/GET"

pushd "$tmpDir/curlman-root/github/users" > /dev/null

# ACT
$curlman_dev_home/src/main/curlman.sh request ./GET --show-command > "$tmpDir/out.txt"
exitCode=$?

# ASSERT
if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended abnormally: $exitCode"
    exit 1
fi

echo "curl -D \"$tmpDir/curlman-root/github/users/GET.response.headers.txt\" -o \"$tmpDir/curlman-root/github/users/GET.response.body\" -s -X GET \"https://api.github.com/users\"" > "$tmpDir/expected.out.txt"
diff "$tmpDir/out.txt" "$tmpDir/expected.out.txt"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]:[FAIL]: Output differs expectation."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
