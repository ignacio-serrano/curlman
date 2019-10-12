#!/usr/bin/env bash
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: Args: «$@»" >> "$curlman_log"
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: installDir: «$installDir»" >> "$curlman_log"

declare -A queryParamsFromArgs
for arg in "$@"; do
    test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: arg: «$arg»" >> "$curlman_log"
    if [[ "$arg" == "--help" ]]; then
        cat "$installDir/docs/request-usage.txt"
        exit 0
    elif [[ "$arg" == "--show-command" ]]; then
        showCommandFlag=1
    elif [[ "$arg" == "--query-parameter" ]]; then
        queryParamFlag=1
    elif [[ $queryParamFlag ]]; then
        IFS='=' read -r name value <<< "$arg"
        queryParamsFromArgs[$name]="$value"
        unset queryParamFlag
    elif [[ -z "$operationFile" ]]; then
        operationFile="$arg"
    elif [[ -z "$requestFile" ]]; then
        requestFile="$arg"
    else
        echo "ERROR: Unexpected argument «$arg»."
        exit 1
    fi
done
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: Parsed arguments" >> "$curlman_log"
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: showCommandFlag: «$showCommandFlag»" >> "$curlman_log"
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: operationFile: «$operationFile»" >> "$curlman_log"
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: requestFile: «$requestFile»" >> "$curlman_log"
test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: #queryParamsFromArgs[@]: «${#queryParamsFromArgs[@]}»" >> "$curlman_log"
if [[ -n "$curlman_log" ]]; then
    for name in "${!queryParamsFromArgs[@]}"; do
        echo "[DEBUG]:[$(basename $0)]: queryParamsFromArgs[$name]: «${queryParamsFromArgs[$name]}»" >> "$curlman_log"
    done
fi

if [[ -z "$operationFile" ]]; then
    echo "ERROR: You must specify an operation file."
    cat "$installDir/docs/request-usage.txt"
    exit 1
fi

httpMethod=$(basename "$operationFile")
serviceDir=$($installDir/misc/resolve-service-dir.sh "$operationFile")
operationDir=$(dirname "$operationFile")
operationDir=$($installDir/utils/canonicalise-path.sh "$operationDir")
eval resourcePath="\${operationDir#$serviceDir}"

cfg_editor=vi
while IFS='=' read -r key value; do
    printf -v $key "$value"
done < "$serviceDir/curlman.service.context"

if [[ -n "$requestFile" ]]; then
    if [[ -f "$requestFile" ]]; then
        declare -A queryParamsFromFile
        while IFS=':' read -r paramType valueDefinition; do
            if [[ "$paramType" == 'query' ]]; then
                IFS='=' read -r name value <<< "$valueDefinition"
                queryParamsFromFile[$name]="$value"
            else
                echo "WARNING: Ignoring parameter. Type «$paramType» not recognised."
            fi
        done < "$requestFile"
    else
        echo "ERROR: Request file «$requestFile» does not exist."
        exit 1
    fi
fi

test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: #queryParamsFromFile[@]: «${#queryParamsFromFile[@]}»" >> "$curlman_log"
for name in "${!queryParamsFromFile[@]}"; do
    test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: queryParamsFromFile[$name]: «${queryParamsFromFile[$name]}»" >> "$curlman_log"
    if [[ ! ${queryParamsFromArgs[$name]} ]]; then
        queryParamsFromArgs[$name]="${queryParamsFromFile[$name]}"
    fi
done

test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: #queryParamsFromArgs[@]: «${#queryParamsFromArgs[@]}»" >> "$curlman_log"
if [[ -n "$curlman_log" ]]; then
    for name in "${!queryParamsFromArgs[@]}"; do
        echo "[DEBUG]:[$(basename $0)]: queryParamsFromArgs[$name]: «${queryParamsFromArgs[$name]}»" >> "$curlman_log"
    done
fi

curlCommand="curl -D \"$operationDir/$httpMethod.response.headers.txt\" -o \"$operationDir/$httpMethod.response.body\" -s -X $httpMethod \"$cfg_baseUrl/${resourcePath#/}\""
if [[ ${#queryParamsFromArgs[@]} -gt 0 ]]; then
    test -n "$curlman_log" && echo "[DEBUG]:[$(basename $0)]: There are query params!" >> "$curlman_log"
    curlCommand="$curlCommand -G"
    for name in "${!queryParamsFromArgs[@]}"; do
        curlCommand="$curlCommand --data-urlencode $name=${queryParamsFromArgs[$name]}"
    done
fi
if [[ $showCommandFlag ]]; then
    echo $curlCommand
    exit 0
fi

rm -f "$operationDir"/$httpMethod.response.*
eval "$curlCommand"

findOutMimeType () {
    sed 1d "$operationDir/$httpMethod.response.headers.txt" | while IFS=':' read -r key value; do
        if [[ "${key,,}" == "content-type" ]]; then
            responseContentType=$(echo "$value" | xargs)
            IFS=';' read -r mimeType encoding <<< $responseContentType
            echo "$mimeType"
            return 0
        fi
    done
}

mimeType=$(findOutMimeType)
if [[ "${mimeType,,}" == "application/json" ]]; then
    responseBodyFileName="$operationDir/$httpMethod.response.body.json"
else
    responseBodyFileName="$operationDir/$httpMethod.response.body.txt"
fi
mv "$operationDir/$httpMethod.response.body" "$responseBodyFileName"
$cfg_editor "$responseBodyFileName"

exit 0
