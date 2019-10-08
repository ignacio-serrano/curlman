#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir="$curlman_dev_home/tmp"
if [[ ! -e  "$tmpDir" ]]; then
    mkdir "$tmpDir"
fi
tmpDir="$tmpDir/commands"
if [[ ! -e  "$tmpDir" ]]; then
    mkdir "$tmpDir"
fi
tmpDir="$tmpDir/add-resource"
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
mkdir "$tmpDir/curlman-root"
touch "$tmpDir/curlman-root/curlman.context"
mkdir "$tmpDir/curlman-root/github"
touch "$tmpDir/curlman-root/github/curlman.service.context"
echo "cfg_baseUrl=https://api.github.com" >> "$tmpDir/curlman-root/github/curlman.service.context"
mkdir "$tmpDir/curlman-root/github/users"

tmpDir=$($curlman_dev_home/src/main/utils/canonicalise-path.sh "$tmpDir")
pushd "$tmpDir/curlman-root/github/users" > /dev/null

# ACT
$curlman_dev_home/src/main/curlman.sh add resource {username} > "$tmpDir/out.txt"
exitCode=$?
popd > /dev/null

# ASSERT
if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended abnormally: $exitCode"
    exit 1
fi

if [[ ! -d "$tmpDir/curlman-root/github/users/{username}" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create resource directory «$tmpDir/curlman-root/github/users/{username}»."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
