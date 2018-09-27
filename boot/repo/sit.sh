#!/usr/bin/env bash

REPO_DIR=$PROJECT/boot/repo

function set_env{
    cat <<EOF > env
HOST_NAME=$HOST_NAME
HOST=$HOST
PASSWD=$KEYSTORE_PASS
EOF
}

function clean_env{
    rm env
}

function up_source_repo{
    docker-compose -f $REPO_DIR/docker-compose.yml up -d
}

function main{
    set_env
    up_source_repo
}

main