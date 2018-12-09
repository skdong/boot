#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
name="dire_apt_builder"

function building_packages() {
    docker run -it -d -v /opt/dire/packages:/opt/dire/packages \
     -v $MODULE/download.sh:/usr/bin/download.sh \
     -v $MODULE/requirements.d:/opt/dire/deb/requirements.d \
     -v $MODULE/sources.list.d/:/etc/apt/sources.list.d/ \
     -v $MODULE/ubuntu:/opt/dire/ubuntu \
     --name $name dire/deb_builder /bin/bash /usr/bin/download.sh
 }

docker ps | grep $name
if [ $? -ne 0 ]; then
    building_packages
else
    echo "apt package is building"
fi
