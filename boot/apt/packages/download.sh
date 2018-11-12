#!/usr/bin/env bash

function download_packate() {
    apt-get update -y

    apt-get -y dist-upgrade

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

    cd  /opt/dire/packages/debs
    for package in $(cat /opt/dire/ubuntu/base)
    do
        apt-get download $package
    done
    cd -

    for packages in /opt/dire/deb/requirements.d/*
    do
        for package in $(cat $packages)
        do
            apt-get install -d -q -y $package > /dev/null 2>&1
        done
    done
}

function build_ubuntu_apt() {
    find /var/cache/apt/archives/ -name "*.deb" -exec mv {}  /opt/dire/packages/debs \;
    bash /opt/dire/ubuntu/build.sh
    cd /opt/dire/packages/
    tar -zcf debs.tar.gz debs
    rm -rf /opt/dire/packages/debs
}

if [[ ! -f /opt/dire/packages/debs_over ]] ; then
    download_packate
    build_ubuntu_apt
    touch /opt/dire/packages/debs_over
else
    echo "packages is built"
fi

