#!/usr/bin/env bash

set -e
basedir='/opt/dire/'
type='pypi'

package_dir=${basedir}'packages/'
over_flag=${package_dir}${type}'_over'
worke_space=${package_dir}${type}
sources_package=${package_dir}${type}'.tar.gz'
packages_list=${basedir}${type}'/requirements.d/'

function download_packages() {
    mkdir -p /opt/dire/packages/pypi
    for requirements in /opt/dire/pypi/requirements.d/*
    do
        pip install -r $requirements -d /opt/dire/packages/pypi
    done
}

function compress_sources(){
    cd ${package_dir}
    tar -zcf ${type}.tar.gz ${type}
    rm -rf ${worke_space}
}

function clean() {
    rm -rf ${over_flag}
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
