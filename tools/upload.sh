#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
source $MODULE/bootrc

function upload_python_packages() {
    docker run -it --rm \
               --add-host repo.scourge.com:$HOST \
               -v /opt/dire:/opt/dire \
               dire/package_tools twine upload -r pypi /opt/dire/packages/pypi/*
}

function trim_hostname() {
    docker images | grep -v none | egrep "[^/]*\.[^/]*/" | awk '{print "docker tag " $1 ":" $2 "  " $1 ":" $2}' | awk '{gsub("  [^/]*/", " " ,$0); print $0}' | bash
}

function upload_rpm_packages() {
    for package in /opt/dire/packages/rpms/*
    do
        curl  -v --user 'admin:admin123' --upload-file $package  http://$HOST/repository/yum/
    done
}

function upload_deb_packages() {
    for file in /opt/dire/packages/debs/*
    do
        curl  -v --user 'admin:admin123' --upload-file $file  http://$HOST/repository/debs/
    done
}

function upload_certs() {
    mkdir -p /opt/dire/packages/certs/
    cp -f $MODULE/../boot/apt/packages/ubuntu/bjzdgt_ubuntu_2018.pub /opt/dire/packages/certs/
    cp -f /opt/dire/ssl/keystore.crt  /opt/dire/packages/certs/
    for file in /opt/dire/packages/certs/*
    do
        curl  -v --user 'admin:admin123' --upload-file $file  http://$HOST/repository/certs/
    done
}

function upload_helm() {
    if [[ -d /opt/dire/packages/helm ]]; then
        for file in /opt/dire/packages/helm/*
        do
            curl  -v --user 'admin:admin123' --upload-file $file  http://$HOST/repository/helm/
        done
    fi
}

function push_docker_images() {
    docker login $HOST_NAME -u admin -p admin123
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
            docker tag $image $HOST_NAME/$image
            docker push $HOST_NAME/$image
        done
    done
}

case "$1" in
python)
    upload_python_packages
    ;;
rpm)
    upload_rpm_packages
    ;;
deb)
    upload_deb_packages
    ;;
certs)
    upload_certs
    ;;
helm)
    upload_helm
    ;;
docker)
    push_docker_images
    ;;
all)
    upload_python_packages
    upload_rpm_packages
    upload_deb_packages
    upload_certs
    upload_helm
    push_docker_images
    ;;
*)
    echo "Usage upload python rpm deb certs docker all"
    exit 1
    ;;
esac

exit 0
