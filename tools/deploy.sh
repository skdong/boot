#!/usr/bin/env bash

function init_env{
    PROJECT=$(pwd)
}

function up_repo{
    bash $PROJECT/boot/repo/sit.sh
}

function init_node{
    sudo ln -s $PROJECT/../packages /opt/
    bash $PROJECT/boot/apt/sit.sh
}

function main{
    init_env
    init_node
    up_repo
}

main
