#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
name="dire_pypi_builder"

function building_packages() {
    docker run -it -d --rm -v /opt/dire/packages/:/opt/dire/packages/ \
     -v $MODULE/download.sh:/usr/bin/download.sh \
     -v $MODULE/requirements.d:/opt/dire/pypi/requirements.d \
     --name $name dire/base /bin/bash /usr/bin/download.sh
     #--name $name dire/pypi_builder /bin/bash /usr/bin/download.sh
 }

docker inspect $name > /dev/null 2>&1
if [ $? -ne 0 ]; then
    building_packages
else
    echo "pypi package is building"
fi
