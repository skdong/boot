#!/usr/bin/env bash

set -e

MODULE=$(dirname $(readlink -f $0))
source $MODULE/bootrc
PROJECT=$MODULE/..

function uncompress_project() {
    if [[ -f $1.tar.gz ]] && [[ ! -d $1 ]] ; then
        tar -zxf $1.tar.gz
        echo "uncompress $1 over"
    else
        if [[ ! -d $1 ]] ; then
            echo "need $1 packages file"
            exit 1
        fi
        echo "$1 is already exit"
    fi
}

function uncompress() {
    cd /opt/dire/packages
    uncompress_project debs
    uncompress_project pypi
    uncompress_project rpms
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
