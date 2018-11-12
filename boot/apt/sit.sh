#!/usr/bin/env bash

set -e

MODULE=$(dirname $(readlink -f $0))

# copy packages to /opt/dire

function clean_sources(){
    sudo rm -rf /etc/apt/sources.list.d/*
    sudo truncate --size=0 /etc/apt/sources.list
}

function deploy_boot_source(){
    sudo cp $MODULE/files/boot.list /etc/apt/sources.list.d
    sudo ps -ef | grep apt | grep -v grep | awk '{print "kill -9 "$2}' | sudo bash
    sudo apt-get update -y
}

function install_docker(){
    sudo apt-get install docker-ce docker-compose  -y
    sudo systemctl stop docker
    sudo rm -rf /var/lib/docker
    sudo tar -zxvf /opt/dire/packages/docker.tar -C /
    sudo systemctl start docker
}

function load-docker-images(){
    for package in /opt/dire/packages/docker/*tar
    do
        sudo docker load -i $package
    done
}

function install_util_packages(){
    sudo apt-get install -y python-pip
}

function dist_upgrade() {
    sudo apt-get -y dist-upgrade
}

function add_apt_key() {
    sudo apt-key add $MODULE/packages/ubuntu/bjzdgt_ubuntu_2018.pub
}

function main(){
    clean_sources
    add_apt_key
    deploy_boot_source
    dist_upgrade
    install_util_packages
    install_docker
}

main

