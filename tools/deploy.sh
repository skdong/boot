#!/usr/bin/env bash


MODULE=$(dirname $(readlink -f $0))
source $MODULE/bootrc
PROJECT=$MODULE/..

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
