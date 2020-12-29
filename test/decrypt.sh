#!/bin/bash

PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function main() {
    cd $PWD

    local GPG_PRIVATE_KEY=$(cat bot-deployer@agora.priv_key)

    docker build --rm -t blackbox . && 
    docker run -it \
    --env-file test.env \
    -e GPG_PRIVATE_KEY="$GPG_PRIVATE_KEY" \
    blackbox \
    cat staging.env
}

main