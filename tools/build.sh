#!/usr/bin/env bash

${MODULES:="apt pypi rpm docker"}
${CLEAN:="no"}
MODULE=$(dirname $(readlink -f $0))
BOOT=$MODULE/../boot

function verify_permission() {
    ls /root > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "this script need root permission"
        exit 1
    fi
}

function wait_building_over() {
    while [ 0 -ne $(docker ps | egrep -c "dire_.*_builder") ]
    do
        sleep 20
    done
    echo "build over"
}

function build_docker_image() {
    # build docker image
    bash $MODULE/../docker/build.sh

    # build mirror builder image
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

function clean_env() {
    rm -rf /opt/dire/packages
    docker ps -a | grep 'dire_*_builder' | awk '{print "docker rm -f "$1}' | bash
}

if [[ "$CLEAN" == "yes" ]] ; then
clean_env
fi
verify_permission
build_docker_image
build_packages
wait_building_over
