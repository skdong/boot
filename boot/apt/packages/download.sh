#!/usr/bin/env bash

apt-get update -y

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

for packages in /opt/dire/deb/requirements.d/*
do
    for package in $(cat $packages)
    do
        apt-get install -d -q -y $package
    done
done

find /var/cache/apt/archives/ -name "*.deb" -exec mv {}  /opt/dire/packages/debs \;

bash /opt/dire/ubuntu/build.sh

