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

function load-docker-images(){
    for package in /opt/dire/packages/docker/*tar
    do
        sudo docker load -i $package
    done
}

function install-util-packages(){
    sudo apt-get install -y python-pip
}

function add-apt-key() {
    sudo apt-key add $MODULE/packages/ubuntu/bjzdgt_ubuntu_2018.pub
}

function main(){
    clean-sources
    add-apt-key
    deploy-boot-source
    install-docker
    install-util-packages
    load-docker-images
}

main

