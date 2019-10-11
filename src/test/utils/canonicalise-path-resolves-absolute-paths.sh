#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

# ARRANGE

pushd ${0%/*} > /dev/null
thisDir=$(pwd)

# ACT
ret=$($curlman_dev_home/src/main/utils/canonicalise-path.sh "$thisDir/utils")
popd > /dev/null

# ASSERT
if [[ "$ret" != "$thisDir/utils" ]]; then
    echo "[$(basename $0)]: FAIL: canonicalise-path.sh returned «$ret». Expected «$thisDir/utils"
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
