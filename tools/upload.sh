#!/usr/bin/env bash

function upload_python_packages{
    docker run -it --rm --add-host repo.scourge.com:$HOST -v /opt/packages:/opt/packages package_tools twine upload -r pypi /opt/packages/pypi/*
}

function upload_rpm_packages{
    for package in /opt/packages/rpms/*
    do
        curl  -v --user 'admin:admin123' --upload-file $package  http://$HOST/repository/yum/
    done

}

function push_docker_images{
    for image in images:
    do
        docker tag $image $HOST/repository/docker:$image
        docker push $HOST/repository/docker:$image
    done

}

upload_python_packages
upload_rpm_packages
push_docker_images