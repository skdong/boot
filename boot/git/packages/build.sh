#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
name="dire_git_builder"

function building_packages(){
    docker run -it -d -v /opt/dire/packages:/opt/dire/packages \
     -v $MODULE/build/download.sh:/usr/bin/download.sh \
     -v $MODULE/requirements.d:/opt/dire/git/requirements.d \
     -v $MODULE/keypair/id_rsa:/root/.ssh/id_rsa \
     -v $MODULE/keypair/id_rsa.pub:/root/.ssh/id_rsa.pub \
     --name $name aions/git_tool /bin/bash /usr/bin/download.sh
 }

docker ps | grep  $name
if [ $? -ne 0 ]; then
    building_packages
else
    echo "git package is building"
fi
