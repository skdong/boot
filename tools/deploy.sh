#!/usr/bin/env bash

function init_env{
    export PROJECT=`pwd`
}

function up_source_repo{
    docker-compose -f $PROJECT/boot/docker-compose.yml start
}

function init_node{
    bash $PROJECT/boot/apt/sit.sh
}

function main{
    init_env
    init_node
    up_source_repo
}

main
