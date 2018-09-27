#!/usr/bin/env bash

MODULE=`dirname $0`

docker run --run -it -v $MODULE:/root/packages package_tools