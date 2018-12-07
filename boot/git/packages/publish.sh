#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
name="dire_git_publish"

function building_packages(){
    docker run -it -d --rm -v /opt/dire/packages:/opt/dire/packages \
     -v $MODULE/publish:/opt/dire/publish \
     -e GIT_HOST=$GIT_HOST -e TOKE=$TOKEN \
     --name $name iaiong/git_tool /bin/bash /usr/bin/upload.sh
 }

docker inspect $name > /dev/null 2>&1
if [ $? -ne 0 ]; then
    building_packages
else
    echo "git package is building"
fi