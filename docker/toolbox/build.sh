#!/usr/bin/env bash
MODULE=$(dirname $(readlink -f $0))
cd $MODULE

docker build -t dire/toolbox:latest $MODULE

cd -
