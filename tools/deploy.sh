#!/usr/bin/env bash

set -e

MODULE=$(dirname $(readlink -f $0))
PROJECT=$MODULE/..
source $MODULE/bootrc

ENABLE_HELM=${ENABLE_HELM:-'no'}
ENABLE_GITLAB=${ENABLE_GITLAB:-'no'}

function decompress_project() {
    if [[ -f $1.tar.gz ]] && [[ ! -d $1 ]] ; then
        tar -zxf $1.tar.gz
        echo "decompress $1 over"
    else
        if [[ ! -d $1 ]] ; then
            echo "need $1 packages file"
            exit 1
        fi
        echo "$1 is already exit"
    fi
}

# decompress packages
# deb pypi rpm
# docker package decompress when install docker
function decompress() {
    echo "decompress packages"
    cd /opt/dire/packages

    for project in deb pypi rpm
    do
        decompress_project $project
    done

    if [[ $ENABLE_HELM == 'yes' ]] ; then
        decompress_project helm
    fi
}

# init deploy node env
# set local repo
# install common package
# install docker-ce
# load docker images
function initiate() {
    echo "init depoly node"
    bash $PROJECT/boot/apt/sit.sh
    echo "init over"
}

function serve() {
    bash $PROJECT/boot/servers/sit.sh
    echo "up servers over"
}

function all() {
    decompress
    initiate
    serve
}

function usage() {
    echo "################################################"
    echo "# decompress|initiate|serve|all"
    echo "# decompress: decompress pypi deb rpm package"
    echo "# initiate: ini deploy node"
    echo "# serve: up neuxs and gitlab server"
    echo "# all: do up action all"
    echo "################################################"
}

if [ $# == 0 ]; then
    all
fi

if [ $# -gt 1 ]; then
    usage
fi

case "$1" in
    decompress)
        decompress
        ::
    initiate)
        initiate
        ;;
    serve)
        serve
        ;;
    all)
        all
        ;;
    *)
        usage
        exit 1
esac

exit 0
