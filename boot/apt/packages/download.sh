#!/usr/bin/env bash

yum update -y

for packages in /opt/dire/rpm/requirements.d/*
do
    yum install -y $(cat packages)
done

find /var/cache/yum/x86_64/ -name "*.rpm" -exec mv {} /tmp/packages \;
