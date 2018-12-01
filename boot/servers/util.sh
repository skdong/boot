#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))

function set_env() {
    cat<<EOF > $MODULE/env
HOST_NAME=$HOST_NAME
HOST=$HOST
PASSWD=$KEYSTORE_PASS
DIRE_NET=$DIRE_NET
DOMAIN=$DOMAIN
GIT_HOST=$GIT_HOST
EOF
}

function verify_network() {
    docker network inspect $DIRE_NET >/dev/null 2>&1
    echo $?
}

function create_network() {
    docker network create -d macvlan  \
      --ip-range=$DIRE_IP_RANGE  \
      --subnet=$DIRE_SUBNET  \
      --gateway=$DIRE_GATWAY  \
      -o parent=$DIRE_INTERFACE $DIRE_NET
}

function clean_network() {
    docker network rm $DIRE_NET
}

function spawn_network() {
    if [ ! $(verify_network) -eq 0 ] ; then
        create_network
    fi
}

function install_docker_compose() {
    cp -f $MODULE/files/docker-compose /usr/local/bin
    chmod +x /usr/local/bin/docker-compose
}

function clean_env() {
    rm env
}

function up_servers() {
    mkdir /opt/dire/ssl -p
    /usr/local/bin/docker-compose -f $MODULE/docker-compose.yml up -d
}

function down_servers_all() {
    /usr/local/bin/docker-compose -f $MODULE/docker-compose.yml down -v
}

function down_servers() {
    /usr/local/bin/docker-compose -f $MODULE/docker-compose.yml down
}

function deploy_docker_certs() {
    mkdir -p /etc/docker/certs.d/$HOST_NAME/
    while [ ! -f /opt/dire/ssl/keystore.crt ]
    do
      echo 'wait for docker crt created'
      sleep 5
    done
    cp -f /opt/dire/ssl/keystore.crt /etc/docker/certs.d/$HOST_NAME/
    if [[ `grep -c "$HOST_NAME" /etc/hosts` -eq '0' ]]; then

        echo "$HOST $HOST_NAME" >> /etc/hosts
    fi
}

function clean_nexus_cert() {
    rm -rf /opt/dire/ssl
}

function site() {
    spawn_network
    set_env
    install_docker_compose
    up_servers
    deploy_docker_certs
}

function clean() {
    down_servers_all
    clean_env
    clean_network
    clean_nexus_cert
}

function rebuild() {
    down_servers
    clean_nexus_cert
    set_env
    up_servers
    deploy_docker_certs
}
