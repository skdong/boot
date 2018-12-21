#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
name="dire_git_builder"
basedir='/opt/dire/'
type='git'

package_dir=${basedir}'packages/'
over_flag=${package_dir}${type}'_over'
worke_space=${package_dir}${type}
sources_package=${package_dir}${type}'.tar.gz'

function building_packages(){
    docker run -it -d -v /opt/dire/packages:/opt/dire/packages \
     -v $MODULE/build/download.sh:/usr/bin/download.sh \
     -v $MODULE/requirements.d:/opt/dire/git/requirements.d \
     -v $MODULE/keypair/id_rsa:/root/.ssh/id_rsa \
     -v $MODULE/keypair/id_rsa.pub:/root/.ssh/id_rsa.pub \
     --name $name aions/git_tool
    while [[ ! -f ${over_flag} || ! -f ${sources_package} ]]
    do
        docker exec  -u root $name /bin/sh /usr/bin/download.sh
        sleep 20
    done
    docker stop $name
    docker rm $name
}

docker ps | grep  $name
if [ $? -ne 0 ]; then
    building_packages
else
    echo "git package is building"
fi
