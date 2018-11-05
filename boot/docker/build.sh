#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))

mkdir -p /opt/dire/packages/docker/
mkdir -p /opt/dire/packages/docker/images.d/

function build_packages() {
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

trim_hostname
