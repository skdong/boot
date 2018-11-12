#!/usr/bin/env bash

function download_packages() {
    for requirements in /opt/dire/pypi/requirements.d/*
    do
        pip download -r $requirements -d /opt/dire/packages/pypi
    done
    cd /opt/dire/packages
    tar -zcf pypi.tar.gz pypi
    rm -rf /opt/dire/packages/pypi
}

if [[ ! -f /opt/dire/packages/pypi/over ]] ; then
    download_packages
else
    echo "pypi is built"
fi