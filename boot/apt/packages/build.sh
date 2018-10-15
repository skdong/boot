#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))

docker run -it -v --rm /opt/dire/packages/debs:/opt/dire/packages/debs \
 -v $MODULE/download.sh:/usr/bin/download.sh \
 -v $MODULE/requirements.d:/opt/dire/deb/requirements.d \
 -v $MODULE/sources.list.d/:/etc/apt/sources.list.d/ \
 dire/deb_tools /bin/bash /usr/bin/download.sh
