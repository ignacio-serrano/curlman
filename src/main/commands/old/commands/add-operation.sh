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
    cat "$installDir/docs/add-operation-usage-v0.txt"
elif [[ $# -lt 1 ]] || [[ "${1:0:2}" == "--" ]]; then
    echo "ERROR: You must specify an HTTP method."
    cat "$installDir/docs/add-operation-usage-v0.txt"
    exit 1
fi

httpMethod=$(echo "$1" | tr '[:lower:]' '[:upper:]')
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: httpMethod: «$httpMethod»"
shift

# TODO: Add support to specify the candidateDir as $2 argument (like in add-service.sh).
# TODO: or add support to specify the service as $2 argument (like in add-service.sh).
resourcePath="$(pwd)"
if [[ $# -gt 1 ]] && [[ "${1:0:2}" != "--" ]]; then
    resourcePath="$2"
    shift
fi

for arg in "$@"; do
    echo $arg
done

$installDir/lib/add-resource.sh "$resourcePath"
exitCode=$?
if [[ $exitCode -gt 0 ]]; then
    exit $exitCode
fi

candidateDir="$(pwd)"
# TBC...: add-resource.sh can create the directory, but can't tell me which one is it.
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
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Final currentDir: «$currentDir»"

operationScript="$currentDir/$httpMethod.sh"
cp "$installDir/resources/operation-template.sh" "$operationScript"

# Believe it or not, everything written between this command and an EOL would be
# written to a file.
#cat >> "$operationScript" << EOL
