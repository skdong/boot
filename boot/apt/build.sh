#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
docker build  -t dire/deb_builder $MODULE