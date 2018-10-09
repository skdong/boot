#!/usr/bin/env bash

MODULE=`dirname $0`
for requirements in $MODULE/requirements.d/*
do
    pip download -r $requirements -d $MODULE/pypi
done