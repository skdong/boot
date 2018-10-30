#!/usr/bin/env bash


MODULE=`dirname $0`
source $MODULE/bootrc

function init_env() {
    PROJECT=$(pwd)
}

function init_node() {
    sudo mkdir -p /opt/dire
    sudo cp -r $PROJECT/../packages /opt/dire/
    bash $PROJECT/boot/apt/sit.sh
}

function up_servers() {
    bash $PROJECT/boot/servers/sit.sh
}

function main() {
    init_env
    #init_node
    up_servers
}

main
