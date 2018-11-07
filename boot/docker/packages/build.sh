#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))

function build_packages() {
    mkdir -p /opt/dire/packages/docker/
    mkdir -p /opt/dire/packages/docker/images.d/
    for images in $MODULE/images.d/*
    do
        if [[ -f $images ]]; then
            docker save $(cat $images) -o /opt/dire/packages/docker/$(basename $images).tar
            cp $images  /opt/dire/packages/docker/images.d
        fi
    done
}

function trim_hostname() {
    docker images | grep -v none | egrep "[^/]*\.[^/]*/" | awk '{print "docker tag " $1 ":" $2 "  " $1 ":" $2}' | awk '{gsub("  [^/]*/", " " ,$0); print $0}' | bash
}

if [ ! -d /opt/dire/packages/docker ] ; then
    trim_hostname
    build_packages
else
    echo "docker package is build"
fi
