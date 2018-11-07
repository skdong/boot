#!/usr/bin/env bash
MODULES="ansible apt pypi rpm docker"

function build_docker_image() {
    for module in $MODULES:
    do
        if [ -f ../boot/$module/build.sh ] ; then
            bash ../boot/$module/build.sh
        fi
    done
}

fuction build_packages() {
    for module in $MODULES:
    do
        if [ -f ../boot/$module/packages/build.sh ] ; then
            bash ../boot/$module/packages/build.sh
        fi
    done
}

build_docker_image
build_packages