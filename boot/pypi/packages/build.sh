#!/usr/bin/env bash

MODULE=`dirname $0`

docker run --run -it -v /opt/dire/packages/pypi:/opt/dire/packages/pytpi \
 -v $MODULE/download.sh:/usr/bin/download.sh \
 -v $MODULE/requirements.d:/opt/dire/pypi/requiremnts.d \
 --rm \
 dire/package_tools /bin/bash /usr/bin/download.sh