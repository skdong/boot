#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
docker build  -t aions/git_tool $MODULE
