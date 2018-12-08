#!/usr/bin/env bash

basedir='/opt/dire/packages/'
type='helm'
over_flag=${basedir}${type}'_over'
worke_space=${basedir}${type}
sources_package=${basedir}${type}'.tar.gz'
packages_list=${basedir}${type}'/requirements.d/'

function download_packages() {
    MODULE=$(dirname $(readlink -f $0))
    cd ${worke_space}
    for file in $(cat ${MODULE}/files)
    do
        curl -L -O $file
    done
}

function compress_sources(){
    cd ${basedir}
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
