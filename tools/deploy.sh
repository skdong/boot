#!/usr/bin/env bash

set -e

MODULE=$(dirname $(readlink -f $0))
source $MODULE/bootrc
PROJECT=$MODULE/..

function uncompress() {
    cd /opt/dire/packages
    tar -zxvf debs.tar.gz
    tar -zxvf pypi.tar.gz
    tar -zxvf rpms.tar.gz
    tar -zxvf docker.tar.gz
}
function init_node() {
    bash $PROJECT/boot/apt/sit.sh
}

function up_servers() {
    bash $PROJECT/boot/servers/sit.sh
}

function main() {
    init_node
    up_servers
}

main
