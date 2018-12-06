#!/usr/bin/env bash
MODULE=$(dirname $(readlink -f $0))

cd $MODULE

curl -O http://$HOST_NAME/repository/certs/bjzdgt_ubuntu_2018.pub
echo "deb http://$HOST/repository debs/" > steam_source.list
cat << EOF > pip.conf
[global]
index-url = http://$HOST/repository/pypi/simple/
[install]
trusted-host = $HOST
EOF

docker build -t dire/base:latest $MODULE

rm bjzdgt_ubuntu_2018.pub steam_source.list pip.conf

cd -
