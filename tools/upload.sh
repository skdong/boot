#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
WORK_SPACE=${MODULE}'/..'
source $MODULE/bootrc

package_dir='/opt/dire/packages/'

ENABLE_HELM=${ENABLE_HELM:-'no'}
ENABLE_GITLAB=${ENABLE_GITLAB:-'no'}
KUBE_VERSION=${KUBE_VERSION:-'v1.14.3'}

NEXUS_USER=${NEXUS_USER:-"admin"}
NEXUS_PASSWORD=${NEXUS_PASSWORD:-"admin123"}
IDENTITY="$NEXUS_USER:$NEXUS_PASSWORD"

function upload_python_packages() {
    docker run -it --rm \
               --add-host repo.scourge.com:$HOST \
               -v /opt/dire:/opt/dire \
               dire/package_tools twine upload -r pypi \
               -u $NEXUS_USER -p $NEXUS_PASSWORD /opt/dire/packages/pypi/*
}

function trim_hostname() {
    docker images | grep -v none | egrep "[^/]*\.[^/]*/" | awk '{print "docker tag " $1 ":" $2 "  " $1 ":" $2}' | awk '{gsub("  [^/]*/", " " ,$0); print $0}' | bash
}

function upload_rpm_packages() {
    for package in ${package_dir}rpm/*
    do
        curl  -v --user $IDENTITY --upload-file $package  http://$HOST/repository/yum/
    done
}

function upload_deb_packages() {
    for file in ${package_dir}deb/*
    do
        curl  -v --user $IDENTITY --upload-file $file  http://$HOST/repository/deb/
    done
}

function upload_certs() {
    mkdir -p ${package_dir}/certs/
    cp -f $MODULE/../boot/apt/packages/ubuntu/bjzdgt_ubuntu_2018.pub /opt/dire/packages/certs/
    cp -f /opt/dire/ssl/keystore.crt  ${package_dir}certs/
    for file in /opt/dire/packages/certs/*
    do
        curl  -v --user $IDENTITY --upload-file $file  http://$HOST/repository/certs/
    done
}

function upload_helm() {
    if [[ -d ${package_dir}helm || -f ${package_dir}helm.tar.gz ]]; then
        if [[ ! -d /opt/dire/packages/helm ]]; then
            tar -zxf ${package_dir}helm.tar.gz -C ${package_dir}
        fi
        for file in ${package_dir}helm/*
        do
            curl  -v --user $IDENTITY --upload-file $file  http://$HOST/repository/helm/
        done
    fi
}

function upload_file() {
    if [[ -d ${package_dir}file || -f ${package_dir}file.tar.gz ]]; then
        if [[ ! -d /opt/dire/packages/file ]]; then
            tar -zxf ${package_dir}file.tar.gz -C ${package_dir}
        fi
        for file in ${package_dir}file/*
        do
            curl  -v --user $IDENTITY --upload-file $file  http://$HOST/repository/files/$KUBE_VERSION/
        done
    fi
}

function push_docker_images() {
    docker login $HOST_NAME -u $NEXUS_USER -p $NEXUS_PASSWORD
    for image in ${package_dir}docker/*.tar
    do
        if [[ -f $image ]]; then
            sudo docker load -i $image
        fi
    done
    for images in ${package_dir}docker/images.d/*
    do
        for image in `cat $images`
        do
            docker tag $image $HOST_NAME/$image
            docker push $HOST_NAME/$image
        done
    done
}

function upload_git_projects() {
    bash ${WORK_SPACE}/boot/git/packages/publish.sh
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
file)
    upload_file
    ;;
docker)
    push_docker_images
    ;;
git)
    upload_git_projects
    ;;
all)
    upload_python_packages
    upload_rpm_packages
    upload_deb_packages
    upload_certs
    upload_file
    if [ $ENABLE_HELM == "yes" ]; then
        upload_helm
    fi
    push_docker_images
    if [ $ENABLE_GITLAB == "yes" ]; then
        upload_git_projects
    fi
    ;;
*)
    echo "Usage upload python rpm deb certs docker all"
    exit 1
    ;;
esac

exit 0
