#!/usr/bin/env bash
MODULES="ansible apt pypi rpm docker"
MODULE=$(dirname $(readlink -f $0))
BOOT=$MODULE/../boot

function verify_permission() {
    ls /root > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "this script need root permission"
    fi
}

function build_docker_image() {
    for module in $MODULES
    do
        if [ -f $BOOT/$module/build.sh ] ; then
            echo "buid $module image"
            bash $BOOT/$module/build.sh
        fi
    done
}

function build_packages() {
    for module in $MODULES
    do
        if [ -f $BOOT/$module/packages/build.sh ] ; then
            echo "buid $module pakcages"
            bash $BOOT/$module/packages/build.sh
        fi
    done
}

verify_permission
build_docker_image
build_packages