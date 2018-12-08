#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
name="dire_git_publish"

function uncompress_package() {
    if [[ -f /opt/dire/packages/git.tar.gz ]]; then
        if [[ ! -d /opt/dire/packages/git ]]; then
            tar -zxvf /opt/dire/packages/git.tar.gz -C /opt/dire/packages
        fi
    else
        if [[ ! -d /opt/dire/packages/git ]]; then
            echo "git package not exist"
            exit 1
        fi
    fi
}

function uploading_projects() {
    docker run -it -d --rm -v /opt/dire/packages:/opt/dire/packages \
     -v $MODULE/publish:/opt/dire/publish \
     -e GIT_HOST=$GIT_HOST -e TOKEN=$TOKEN \
     --name $name aions/git_tool /bin/bash /opt/dire/publish/upload.sh
 }

docker inspect $name > /dev/null 2>&1
if [ $? -ne 0 ]; then
    uncompress_package
    uploading_projects
else
    echo "git package is publishing"
fi
