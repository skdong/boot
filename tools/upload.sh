#!/usr/bin/env bash

function upload_python_packages{
    docker run -it --rm -v /opt/packages:/opt/packages package_tools twine upload -r pypi /opt/packages/pypi/*
}