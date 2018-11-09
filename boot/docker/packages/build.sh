#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
name="dire_docker_builder"

function building_packages(){
    docker run  -d --rm -v /opt/dire/packages/docker:/opt/dire/packages/docker \
     -v $MODULE/download.sh:/usr/bin/download.sh \
     -v $MODULE/images.d:/opt/dire/docker/images.d \
     -v /etc/docker/certs.d/:/etc/docker/certs.d/ \
     -v /etc/hosts:/etc/hosts \
     --name $name docker:dind
    docker exec -it -uroot /bin/sh /usr/bin/download.sh
    docker rm -f $name
 }

docker inspect $name > /dev/null 2>&1
if [ $? -ne 0 ]; then
    building_packages
else
    echo "docker package is building"
fi