#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))

IMAGES="ansible "
for image in $IMAGES
do
    echo "build $image image"
    bash $MODULE/$image/build.sh
done
