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
tmpDir="$tmpDir/add-service"
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

pushd $tmpDir/curlman-root > /dev/null

# ACT
$curlman_dev_home/src/main/curlman.sh add service github https://api.github.com
exitCode=$?
popd > /dev/null

# ASSERT
if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended abnormally: $exitCode"
    exit 1
fi

if [[ ! -d "$tmpDir/curlman-root/github" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create service directory «$tmpDir/curlman-root/github»."
    exit 1
fi

if [[ ! -f "$tmpDir/curlman-root/github/curlman.service.context" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create curlman.service.context file «$tmpDir/curlman-root/github/curlman.service.context»."
    exit 1
fi

echo "cfg_baseUrl=https://api.github.com" > "$tmpDir/expected.curlman.service.context"
diff "$tmpDir/curlman-root/github/curlman.service.context" "$tmpDir/expected.curlman.service.context"
exitCode=$?

if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]:[FAIL]: «$tmpDir/curlman-root/github/curlman.service.context» differs from expectation."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
