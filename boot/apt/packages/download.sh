#!/usr/bin/env bash
basedir='/opt/dire/'
type='debs'

set -e

package_dir=${basedir}'packages/'
over_flag=${package_dir}${type}'_over'
worke_space=${package_dir}${type}
sources_package=${package_dir}${type}'.tar.gz'
packages_list=${basedir}${type}'/requirements.d/'

function download_packages() {
    apt-get update -y

    apt-get -y --download-only dist-upgrade

    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

    apt-get -y update

    mkdir -p /opt/dire/packages/debs
    cd  /opt/dire/packages/debs
    for package in $(cat /opt/dire/ubuntu/base)
    do
        apt-get download $package
    done

    for list in /opt/dire/deb/requirements.d/*
    do
        for package in $(cat $list)
        do
            apt-get install --download-only -d -q -y $package > /dev/null 2>&1
        done
        echo "download $packages over"
    done
}

function build_ubuntu_apt() {
    find /var/cache/apt/archives/ -name "*.deb" -exec mv {}  /opt/dire/packages/debs \;
    bash /opt/dire/ubuntu/build.sh
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
    build_ubuntu_apt
    compress_sources
    set_build_over
else
    echo ${type}" is built"
fi
