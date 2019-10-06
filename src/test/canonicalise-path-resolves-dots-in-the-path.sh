#!/usr/bin/env bash

# ARRANGE
unset debugCurlman

pushd ${0%/*} > /dev/null
thisDir=$(pwd)

# ACT
ret=$(../main/utils/canonicalise-path.sh "$thisDir/./utils")
popd > /dev/null

# ASSERT
if [[ "$ret" != "$thisDir/utils" ]]; then
    echo "[$(basename $0)]: FAIL: canonicalise-path.sh returned «$ret». Expected «$thisDir/utils"
    exit 1
fi

echo "[$(basename $0)]: PASS"
exit 0
