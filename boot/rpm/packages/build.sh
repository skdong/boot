#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))

mkdir -p /opt/dire/packages/rpms
rm -rf /opt/dire/packages/rpms/*

docker run -it -v --rm /opt/dire/packages/rpm:/opt/dire/packages/rpms \
 -v $MODULE/download.sh:/usr/bin/download.sh \
 -v $MODULE/requirements.d:/opt/dire/rpm/requirements.d \
 -v $MODULE/yum.repos.d/:/etc/yum.repos.d \
 dire/centos_tools /bin/bash /usr/bin/download.sh