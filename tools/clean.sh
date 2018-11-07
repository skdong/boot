#!/usr/bin/env bash
MODULE_DIR=$(dirname $(readlink -f $0))
docker-compose -f $MODULE_DIR/../boot/servers/docker-compose.yml stop
docker-compose -f $MODULE_DIR/../boot/servers/docker-compose.yml rm
rm -rf /opt/dire/ssl/*
