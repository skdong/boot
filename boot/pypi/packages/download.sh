#!/usr/bin/env bash

for requirements in /opt/dire/pypi/requirements.d/*
do
    pip download -r $requirements -d /opt/dire/packages/pypi
done