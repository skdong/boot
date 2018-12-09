#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))

for image in ${MODULE}/*
do
    if [[ -d $image ]] ; then
        echo "build $image image"
        bash $image/build.sh
    fi
done
