#!/usr/bin/env bash

MODULE=`dirname $0`
docker build  -t dire/pypi_builder $MODULE
