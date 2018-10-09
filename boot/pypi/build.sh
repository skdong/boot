#!/usr/bin/env bash

MODULE=`dirname $0`
docker build  -t dire/package_tools $MODULE
