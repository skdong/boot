#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
PROJECT=$MODULE/..
source $MODULE/bootrc

bash $PROJECT/docker/build.sh
