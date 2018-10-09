#!/usr/bin/env bash

MODULE=`dirname $0`
docker build -f  $MODULE/Dockerfile -t package_tools