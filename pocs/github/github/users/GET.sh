#!/usr/bin/env bash
if [[ -z "$curlman_dev_home" ]]; then
    echo "[$(basename $0)]: ERROR: curlman_dev_home variable not set. Set it to the absolute path of your local working tree."
    exit 1
fi

scriptDir=$($curlman_dev_home/src/main/utils/canonicalise-path.sh "${0%/*}")
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: scriptDir: «$scriptDir»"

httpMethod=$(basename $0)
httpMethod=${httpMethod%.sh}
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: httpMethod: «$httpMethod»"

currentDir=$scriptDir
while [[ "$currentDir" != "/" ]]; do
    if [[ -f "$currentDir/curlman.service.context" ]]; then
        serviceDir="$currentDir"
        break;
    fi
    currentDir=$(dirname "$currentDir")
    test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: currentDir: «$currentDir»"
done
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Resolved serviceDir: «$serviceDir»"

# TODO: Do something if serviceDir not found.

while IFS='=' read -r key value; do
    test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: Resolved $key: «$value»"
    printf -v $key "$value"
done < "$serviceDir/curlman.service.context"

serviceDirLength=$(expr length "$serviceDir")
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: serviceDirLength: «$serviceDirLength»"

resourcePath=$(echo $scriptDir | cut -c $((serviceDirLength +1))-)
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: resourcePath: «$resourcePath»"

actualResourcePath=''
IFS='/' read -r -a array <<< ${resourcePath#/}
for element in "${array[@]}"; do
    elementLength="${#element}"
    test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: elementLength: «$elementLength»"
    elementFirstChar=${element:0:1}
    test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: elementFirstChar: «$elementFirstChar»"
    elementLastChar=$(echo $element | cut -c "$elementLength"-)
    test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: elementLastChar: «$elementLastChar»"

    if [[ "$elementFirstChar" == '{' ]] && [[ "$elementLastChar" == '}' ]]; then
        pathParameterName=$(echo $element | cut -c 2-$((elementLength - 1)))
        test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: pathParameterName: «$pathParameterName»"

        test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: username: «$username»"
        # This beautiful hack didn't work. Dependeing on scpaing, it either
        # always sets the variable or always unsets it.
        #eval "if [[ -z \${$pathParameterName:+x} ]]; then isSet=1; else unset isSet; fi"
        eval "isSet=\$$pathParameterName"
        test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: isSet: «$isSet»"
        if [[ -n "$isSet" ]]; then
            test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: «$pathParameterName» is set"
            eval "pathParameterValue=\$$pathParameterName"
        else
            test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: «$pathParameterName» is NOT set"
            read -p "Path parameter {$pathParameterName}: " pathParameterValue
        fi
        test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: pathParameterValue: «$pathParameterValue»"
        actualResourcePath=$actualResourcePath/$pathParameterValue
    else
        actualResourcePath=$actualResourcePath/$element
    fi
done

curlCommand="curl -s -X $httpMethod \"$cfg_baseUrl/${actualResourcePath#/}\""
if [[ $# -ge 1 ]]; then
    curlCommand="$curlCommand -G"
    declare -A queryParams
    while IFS=':' read -r paramType name; do
        test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: paramType: «$paramType»"
        test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: name: «$name»"
        if [[ "$paramType" == "query" ]]; then
            test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: paramType goes in"
            queryParams[$name]=" "
        fi
    done < "$scriptDir/$httpMethod"
    test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: queryParams: «${!queryParams[@]}»"

    for arg in "$@"; do
        test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: arg: «$arg»"
        test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: {arg:0:8}: «${arg:0:8}»"
        test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: {arg:8}: «${arg:8}»"
        if [[ "${arg:0:8}" == "--query:" ]]; then
            IFS='=' read -r name value <<< "${arg:8}"
            test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: name: «$name»"
            test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: value: «$value»"
            for k in "${!queryParams[@]}"; do
                if [[ "$k" == "$name" ]]; then
                    queryParams[$k]="$value"
                fi
            done
        fi
    done
    test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: queryParams: «${queryParams[@]}»"
fi

for k in "${!queryParams[@]}"; do
    curlCommand="$curlCommand --data-urlencode $name=${queryParams[$k]}"
done

test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: curl command run: «$curlCommand»"
eval "$curlCommand"
