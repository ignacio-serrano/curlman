#!/usr/bin/env bash
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Args: «$@»"
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: installDir: «$installDir»"

while true; do
    case "$1" in
        '--help')
            showHelp=1
            shift
        ;;
        *)
            break
        ;;
    esac
done

if [[ $showHelp ]]; then
    cat "$installDir/docs/add-resource-usage.txt"
elif [[ $# -lt 1 ]]; then
    echo "ERROR: You must specify the resource path."
    cat "$installDir/docs/add-resource-usage.txt"
    exit 1
fi

resourcePath="$1"

# TODO: Add support to specify the candidateDir as $2 argument (like in add-service.sh).
# TODO: or add support to specify the service as $2 argument (like in add-service.sh).
candidateDir="$(pwd)"
pushd "$candidateDir" > /dev/null
pushCnt=1
while true; do
    if [[ -e "./curlman.service.context" ]]; then
        serviceDir=$(pwd)
        break
    fi
    if [[ "$(pwd)" == "/" ]]; then
        break
    fi
    pushd .. > /dev/null
    pushCnt=$((pushCnt + 1))
    test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: pushCnt: «$pushCnt»"
done

for ((i = 0 ; i < $pushCnt ; i++)); do
    popd > /dev/null
done
unset pushCnt

if [[ -z "$serviceDir" ]]; then
    echo "ERROR: Cannot create resource. Target directory «$candidateDir» doesn't belong to a service."
    exit 1
fi
unset candidateDir

test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Resolved serviceDir: «$serviceDir»"

if [[ "${resourcePath:0:1}" == "/" ]]; then
    currentDir="$serviceDir"
else
    currentDir="$(pwd)"
fi
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Resolved currentDir: «$currentDir»"

IFS='/' read -r -a array <<< ${resourcePath}
for element in "${array[@]}"; do
    currentDir="$currentDir/$element"
    if [[ ! -e "$currentDir" ]]; then
        mkdir "$currentDir"
    fi
done
