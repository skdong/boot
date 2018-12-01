#!/usr/bin/env bash

over='/opt/dire/packages/docker_over'
packages='/opt/dire/packages/docker.tar.gz'

MODULE=$(dirname $(readlink -f $0))

function pull_image() {
    docker pull $1
    if [[ $1 != $(echo $1 | sed 's/^[^/]*\.[^/]*\///g' ) ]] ; then
        docker tag $1 $(echo $1 | sed 's/^[^/]*\.[^/]*\///g' )
        docker rmi $1
    fi
}

function save_images() {
    cp $1  /opt/dire/packages/docker/images.d
    images=/opt/dire/packages/docker/images.d/$(basename $1)
    sed  -i 's/^[^/]*\.[^/]*\///g' $images
}

function build_packages() {
    mkdir -p /opt/dire/packages/docker/
    mkdir -p /opt/dire/packages/docker/images.d/
    for images in /opt/dire/docker/images.d/*
    do
        if [[ -f $images ]]; then
            for image in $(cat $images)
            do
                pull_image $image
            done
            save_images $images
        fi
    done
    docker image prune -f
    cd /opt/dire/packages
    tar -zcf docker.tar.gz /var/lib/docker

}

function trim_hostname() {
    docker images | grep -v none | egrep "[^/]*\.[^/]*/" | awk '{print "docker tag " $1 ":" $2 "  " $1 ":" $2}' | awk '{gsub("  [^/]*/", " " ,$0); print $0}' | bash
}

if [[ ! -f $over || ! -f $packages ]] ; then
    rm -rf /opt/dire/packages/docker
    build_packages
    touch /opt/dire/packages/docker_over
else
    echo "docker package is build"
fi
