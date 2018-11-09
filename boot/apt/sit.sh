#!/usr/bin/env bash

set -e

MODULE=$(dirname $(readlink -f $0))

# copy packages to /opt/dire

function clean-sources(){
    sudo rm -rf /etc/apt/sources.list.d/*
    sudo truncate --size=0 /etc/apt/sources.list
}

function deploy-boot-source(){
    sudo cp $MODULE/files/boot.list /etc/apt/sources.list.d
    sudo ps -ef | grep apt | grep -v grep | awk '{print "kill -9 "$2}' | sudo bash
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

function dist-upgrade() {
    sudo apt-get dist-upgrade
}

function add-apt-key() {
    sudo apt-key add $MODULE/packages/ubuntu/bjzdgt_ubuntu_2018.pub
}

function main(){
    clean-sources
    add-apt-key
    deploy-boot-source
    install-util-packages
    install-docker
    load-docker-images
}

main

