#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

tmpDir=$($curlman_dev_home/src/test-utils/init-tmp-dir.sh "$0")

# ARRANGE
mkdir "$tmpDir/curlman-root"
touch "$tmpDir/curlman-root/curlman.context"
mkdir "$tmpDir/curlman-root/github"
touch "$tmpDir/curlman-root/github/curlman.service.context"

thisDir="${0%/*}"

# ACT
installDir="$curlman_dev_home/src/main"
export installDir=$($installDir/utils/canonicalise-path.sh "$installDir")
tmpDir=$($installDir/utils/canonicalise-path.sh "$tmpDir")

ret=$($installDir/misc/resolve-service-dir.sh "$tmpDir/curlman-root/github/any/resource/path")

# ASSERT
if [[ "$ret" != "$tmpDir/curlman-root/github" ]]; then
    echo "[$(basename $0)]: FAIL: resolve-service-dir.sh returned «$ret». Expected «$tmpDir/curlman-root/github»."
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
