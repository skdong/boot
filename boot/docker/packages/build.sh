#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))

function pull_image() {
    docker pull $1
    if [[ $1 == *.*/* ]] ; then
        docker tag $1 $(echo $1 | 's/^[^/]*\.[^/]*\///g' )
    fi
}

function save_images() {
    cp $1  /opt/dire/packages/docker/images.d
    images=/opt/dire/packages/docker/images.d/$(basename $1)
    sed  -i 's/^[^/]*\.[^/]*\///g' $images
    docker save $(cat $images) -o /opt/dire/packages/docker/$(basename $1).tar
}

function build_packages() {
    mkdir -p /opt/dire/packages/docker/
    mkdir -p /opt/dire/packages/docker/images.d/
    for images in $MODULE/images.d/*
    do
        if [[ -f $images ]]; then
            for image in $(cat $images)
            do
                pull_image $image
            done
            save_images $images
        fi
    done
}

function trim_hostname() {
    docker images | grep -v none | egrep "[^/]*\.[^/]*/" | awk '{print "docker tag " $1 ":" $2 "  " $1 ":" $2}' | awk '{gsub("  [^/]*/", " " ,$0); print $0}' | bash
}

if [ ! -d /opt/dire/packages/docker ] ; then
    build_packages
else
    echo "docker package is build"
fi
