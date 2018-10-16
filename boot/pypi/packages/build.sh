#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))

docker run -it --rm -v /opt/dire/packages/pypi:/opt/dire/packages/pypi \
 -v $MODULE/download.sh:/usr/bin/download.sh \
 -v $MODULE/requirements.d:/opt/dire/pypi/requirements.d \
 dire/pypi_builder /bin/bash /usr/bin/download.sh
