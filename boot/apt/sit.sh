#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))

# copy packages to /opt/dire

function clean-sources(){
    sudo rm /etc/apt/sources.list.d/*
    sudo truncate --size=0 /etc/apt/sources.list
}

function deploy-boot-source(){
    sudo cp $MODULE/files/boot.list /etc/apt/sources.list.d
    sudo apt-get update -y
}

function install-docker(){
    sudo apt-get install docker-ce docker-compose  -y
}

function main(){
    clean-sources
    deploy-boot-source
    install-docker
}

main

