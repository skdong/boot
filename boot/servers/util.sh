#!/usr/bin/env bash

MODULE_DIR=`dirname $0`

function set_env() {
    cat<<EOF > $MODULE_DIR/env
HOST_NAME=$HOST_NAME
HOST=$HOST
PASSWD=$KEYSTORE_PASS
EOF
}

function clean_env() {
    rm env
}

function up_servers() {
    docker-compose -f $MODULE_DIR/docker-compose.yml up -d
}

function deploy_docker_certs{
    mkdir -p /etc/docker/certs.d/$HOST_NAME/
    cp /opt/dire/ssl/keystore.crt /etc/docker/certs.d/$HOST_NAME/
}

function sit() {
    set_env
    up_servers
    deploy_docker_certs
}

function clean() {
    clean_env
    rm -rf /opt/dire/ssl
}
