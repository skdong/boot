#!/usr/bin/env bash

function upload_python_packages() {
    docker run -it --rm --add-host repo.scourge.com:$HOST -v /opt/packages:/opt/packages package_tools twine upload -r pypi /opt/packages/pypi/*
}

function upload_rpm_packages() {
    for package in /opt/packages/rpms/*
    do
        curl  -v --user 'admin:admin123' --upload-file $package  http://$HOST/repository/yum/
    done
}

function upload_deb_packages{
    for file in /opt/packages/ubuntu/debs/*
    do
        curl  -v --user 'admin:admin123' --upload-file $file  http://$HOST/repository/debs/
    done
}

function upload_deb_packages() {
    for file in /opt/packages/debs/*
    do
        curl  -v --user 'admin:admin123' --upload-file $file  http://$HOST/repository/debs/
    done
}

function upload_certs() {
    cp /opt/dire/ssl/keystore.crt  /opt/packages/certs/
    for file in /opt/packages/certs/*
    do
        curl  -v --user 'admin:admin123' --upload-file $file  http://$HOST/repository/certs/
    done
}

function push_docker_images() {
    docker login $HOST -u admin -p admin123
    for image in /opt/packages/docker/*.tar
    do
        if [[ -f $image ]]; then
            docker load -i $image
        fi
    done
    for list in /opt/packages/docker/image.d/*
    do
        for image in `cat $list`
        do
            docker tag $image $HOST/$image
            docker push $HOST/$image
        done
    done
}

upload_python_packages
upload_rpm_packages
upload_deb_packages
upload_certs
push_docker_images

