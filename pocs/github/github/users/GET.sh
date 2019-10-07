#!/usr/bin/env bash
thisDir="${0%/*}"

if [[ "${thisDir:0:2}" == "./"]]; then
    scriptDir=$(pwd)/${thisDir#./}
elif [[ "${thisDir:0:1}" != "/" ]]; then
    scriptDir=$(pwd)/${thisDir}
fi
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: scriptDir: «$scriptDir»"

httpMethod=$(basename $0)
httpMethod=${httpMethod%.sh}
test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: httpMethod: «$httpMethod»"

currentDir=$thisDir
while [[ "$currentDir" != "/" ]]; do
    if [[ -f "$currentDir/curlman.service.context" ]]; then
        serviceDir="$currentDir"
        break;
    fi
    currentDir=$(dirname "$currentDir")
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

test $debugCurlman && echo "[DEBUG]:[$(basename $0)]: curl command run: «curl -s -X $httpMethod \"$cfg_baseUrl/${actualResourcePath#/}\"»"
curl -s -X $httpMethod "$cfg_baseUrl/${actualResourcePath#/}"
