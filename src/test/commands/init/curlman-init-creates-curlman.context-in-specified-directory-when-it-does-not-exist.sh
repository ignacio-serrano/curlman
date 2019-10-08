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
tmpDir="$tmpDir/init"
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
$curlman_dev_home/src/main/curlman.sh init "$tmpDir/a/curlman-root"
exitCode=$?

# ASSERT
if [[ $exitCode -ne 0 ]]; then
    echo "[$(basename $0)]: FAIL: curlman ended abnormally: $exitCode"
    exit 1
fi

if [[ ! -d "$tmpDir/a" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create intermediate directory «$tmpDir/a»."
fi

if [[ ! -d "$tmpDir/a/curlman-root" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create curlman root directory «$tmpDir/a/curlman-root»."
fi

if [[ ! -f "$tmpDir/a/curlman-root/curlman.context" ]]; then
    echo "[$(basename $0)]: FAIL: curlman did not create curlman.context «$tmpDir/a/curlman-root/curlman.context»."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
