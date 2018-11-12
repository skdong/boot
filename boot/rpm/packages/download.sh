#!/usr/bin/env bash

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
        yum install -y $(cat $packages)
    done

    find /var/cache/yum/x86_64/ -name "*.rpm" -exec mv {} /opt/dire/packages/rpms \;
    cd /opt/dire/packages
    tar -zcf rpms.tar.gz rpms
    rm -rf /opt/dire/packages/rpms
}

if [[ -f /opt/dire/packages/rpms/over ]] ; then
    download_packages
    touch /opt/dire/packages/rpms/over
else
    echo "deb is built"
fi
