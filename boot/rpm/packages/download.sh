#!/usr/bin/env bash

basedir='/opt/dire/'
type='rpm'

set -e

package_dir=${basedir}'packages/'
over_flag=${package_dir}${type}'_over'
worke_space=${package_dir}${type}
sources_package=${package_dir}${type}'.tar.gz'
packages_list=${basedir}${type}'/requirements.d/'

function download_packages() {
    yum install -y epel-release
    yum update -y
    yum install -y yum-utils \
      device-mapper-persistent-data \
      lvm2

    yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo

    for packages in /opt/dire/rpms/requirements.d/*
    do
        if [[ -s $packages ]] ; then
            yum install  --downloadonly -y $(cat $packages)
        fi
    done

    find /var/cache/yum/x86_64/ -name "*.rpm" -exec mv {} /opt/dire/packages/rpm \;
}

function compress_sources(){
    cd ${package_dir}
    tar -zcf ${type}.tar.gz ${type}
    rm -rf ${worke_space}
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
    compress_sources
    set_build_over
else
    echo ${type}" is built"
fi
