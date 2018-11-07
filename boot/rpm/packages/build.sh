#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
name="dire_rpm_builder"

docker run -it -d --rm -v /opt/dire/packages/rpms:/opt/dire/packages/rpms \
 -v $MODULE/download.sh:/usr/bin/download.sh \
 -v $MODULE/requirements.d:/opt/dire/rpms/requirements.d \
 --name $name dire/rpm_builder /bin/bash /usr/bin/download.sh

docker inspect $name > /dev/null 2>&1
if [ $? -ne 0 ]; then
    building_packages
else
    echo "rpm package is building"
fi