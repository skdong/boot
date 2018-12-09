#!/usr/bin/env bash

basedir='/opt/dire/'
type='docker'

set -e

package_dir=${basedir}'packages/'
over_flag=${package_dir}${type}'_over'
worke_space=${package_dir}${type}
sources_package=${package_dir}${type}'.tar.gz'
packages_list=${basedir}${type}'/requirements.d/'

function pull_image() {
    docker pull $1
    if [[ $1 != $(echo $1 | sed 's/^[^/]*\.[^/]*\///g' ) ]] ; then
        docker tag $1 $(echo $1 | sed 's/^[^/]*\.[^/]*\///g' )
        docker rmi $1
    fi
}

function save_images() {
    cp $1  /opt/dire/packages/docker/images.d
    images=/opt/dire/packages/docker/images.d/$(basename $1)
    sed  -i 's/^[^/]*\.[^/]*\///g' $images
}

function download_packages() {
    mkdir -p /opt/dire/packages/docker/images.d/
    for images in /opt/dire/docker/images.d/*
    do
        if [[ -f $images ]]; then
            for image in $(cat $images)
            do
                pull_image $image
            done
            save_images $images
        fi
    done
    docker image prune -f
    cd /opt/dire/packages
    tar -zcf docker.tar.gz /var/lib/docker

}

function trim_hostname() {
    docker images | grep -v none | egrep "[^/]*\.[^/]*/" | awk '{print "docker tag " $1 ":" $2 "  " $1 ":" $2}' | awk '{gsub("  [^/]*/", " " ,$0); print $0}' | bash
}

function clean() {
    rm -rf ${over_flag}
    rm -rf ${worke_space}
    rm -rf ${sources_package}
}

function init_work_space() {
    clean
    mkdir -p ${worke_space}
}

function set_build_over {
    md5sum ${sources_package} > ${over_flag}
}

if [[ ! -f ${over_flag} || ! -f ${sources_package} ]] ; then
    init_work_space
    download_packages
    set_build_over
else
    echo ${type}" is built"
fi
