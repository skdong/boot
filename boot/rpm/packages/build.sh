#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))

docker run -it -d --rm -v /opt/dire/packages/rpms:/opt/dire/packages/rpms \
 -v $MODULE/download.sh:/usr/bin/download.sh \
 -v $MODULE/requirements.d:/opt/dire/rpms/requirements.d \
 dire/rpm_builder /bin/bash /usr/bin/download.sh
