#!/usr/bin/env bash

function upload_python_packages() {
    docker run -it --rm \
               --add-host repo.scourge.com:$HOST \
               -v /opt/dire:/opt/dire \
               dire/package_tools twine upload -r pypi /opt/dire/packages/pypi/*
}

function upload_rpm_packages() {
    for package in /opt/dire/packages/rpms/*
    do
        curl  -v --user 'admin:admin123' --upload-file $package  http://$HOST/repository/yum-test/
    done
}

function upload_deb_packages() {
    for file in /opt/dire/packages/debs/*
    do
        curl  -v --user 'admin:admin123' --upload-file $file  http://$HOST/repository/debs/
    done
}

function upload_certs() {
    cp /opt/dire/ssl/keystore.crt  /opt/dire/packages/certs/
    for file in /opt/dire/packages/certs/*
    do
        curl  -v --user 'admin:admin123' --upload-file $file  http://$HOST/repository/certs/
    done
}

function push_docker_images() {
    docker login $HOST -u admin -p admin123
    for image in /opt/dire/packages/docker/*.tar
    do
        if [[ -f $image ]]; then
            sudo docker load -i $image
        fi
    done
    for images in /opt/dire/packages/docker/images.d/*
    do
        for image in `cat $images`
        do
            docker tag $image $HOST/$image
            docker push $HOST/$image
        done
    done
}

#upload_python_packages
upload_rpm_packages
#upload_deb_packages
#upload_certs
#push_docker_images

