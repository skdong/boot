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
    echo "uncompress over"
}
function init_node() {
    bash $PROJECT/boot/apt/sit.sh
    echo "init over"
}

function up_servers() {
    bash $PROJECT/boot/servers/sit.sh
    echo "up servers over"
}

function main() {
    uncompress
    init_node
    up_servers
}

main
