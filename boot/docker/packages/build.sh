#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
name="dire_docker_builder"

basedir='/opt/dire/'
type='docker'

package_dir=${basedir}'packages/'
over_flag=${package_dir}${type}'_over'
worke_space=${package_dir}${type}
sources_package=${package_dir}${type}'.tar.gz'

function building_packages(){
    docker run  -d  --privileged \
     -v /opt/dire/packages:/opt/dire/packages \
     -v $MODULE/download.sh:/usr/bin/download.sh \
     -v $MODULE/images.d:/opt/dire/docker/images.d \
     -v /etc/docker/certs.d/:/etc/docker/certs.d/ \
     -v /etc/hosts:/etc/hosts \
     --name $name docker:dind
    while [[ ! -f ${over_flag} || ! -f ${sources_package} ]]
    do
        docker exec  -u root $name /bin/sh /usr/bin/download.sh
        sleep 20
    done
    docker stop $name
 }

docker ps | grep  $name
if [ $? -ne 0 ]; then
    set -e
    building_packages &
else
    echo "docker package is building"
fi



