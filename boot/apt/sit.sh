#!/usr/bin/env bash

set -e

MODULE=$(dirname $(readlink -f $0))

# copy packages to /opt/dire

function clean_sources(){
    rm -rf /etc/apt/sources.list.d/*
    truncate --size=0 /etc/apt/sources.list
}

function deploy_boot_source(){
    cp $MODULE/files/boot.list /etc/apt/sources.list.d
    apt-get update -y
}

function install_docker(){
    apt-get install docker-ce -y
}

function setup_docker(){
    systemctl stop docker
    rm -rf /var/lib/docker
    tar -zxvf /opt/dire/packages/docker.tar.gz -C /
    systemctl start docker
    usermod -a -G docker $SUDO_USER
}

function load_docker_images(){
    for package in /opt/dire/packages/docker/*tar
    do
        docker load -i $package
    done
}

function install_util_packages(){
    apt-get install -y -q python-pip
}

function dist_upgrade() {
    apt-get -y -q dist-upgrade
}

function add_apt_key() {
    apt-key add $MODULE/packages/ubuntu/bjzdgt_ubuntu_2018.pub
}

function setup_pip() {
    mkdir $SUDO_USER/.pip
    cat << EOF > $SUDO_USER/.pip/pip.conf
[global]
index-url = http://$HOST/repository/pypi/simple/
[install]
trusted-host = $HOST
EOF
    chown $SUDO_USER.$SUDO_USER -R $SUDO_USER/.pip
}

function main(){
    clean_sources
    add_apt_key
    deploy_boot_source
    dist_upgrade
    install_util_packages
    install_docker
    setup_docker
}

main
