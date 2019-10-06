#!/usr/bin/env bash

# -G:               Put --data arguments as request parameters (as it would do by default on a GET request).
# --data-urlencode: Key-value pair to include in the request.
# -X POST:          Use POST method.
# curl -X POST https://oauth2.googleapis.com/token \
#     -G \
#     --data-urlencode refresh_token= \
#     --data-urlencode client_id= \
#     --data-urlencode client_secret= \
#     --data-urlencode grant_type=refresh_token

while IFS=':' read -r key value; do
    echo "$key=$value"
    if [[ $key == url ]]; then
        echo $value
        url=${value/\"/}
        echo $url
        url="${url% \"}"
        echo $url
        url="${url#\"}"
        echo $url
        echo "URL found to be $url"
    fi
done < POST