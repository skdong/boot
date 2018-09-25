#!/usr/bin/env bash

REPO_DIR=$PROJECT/boot/repo

function up_source_repo{
    docker-compose -f $REPO_DIR/docker-compose.yml up -d
}

function main{
    up_source_repo
}

main