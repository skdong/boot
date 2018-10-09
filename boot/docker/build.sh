#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))

mkdir -p /opt/dire/package/docker/
mkdir -p /opt/dire/packages/docker/images.d/

for images in $MODULE/images.d/*
do
    if [[ -f $images ]]; then
        docker save $(cat $images) -o /opt/dire/packages/docker/$(basename $images).tar
        cp $images  /opt/dire/packages/docker/images.d
    fi
done
