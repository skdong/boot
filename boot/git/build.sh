#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
docker build  -t iaiong/git_tool $MODULE