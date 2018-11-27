#!/usr/bin/env bash

#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))

function set_env() {
    cat<<EOF > $MODULE/env
HOST_NAME=$HOST_NAME
HOST=$HOST
PASSWD=$KEYSTORE_PASS
EOF
}

function clean_env() {
    rm env
}

function up_servers() {
    mkdir /opt/dire/ssl -p
    docker swarm init
    docker stack deploy --compose-file docker-compose.yml dire
    #docker-compose -f $MODULE/docker-compose.yml up -d
}

function deploy_docker_certs() {
    mkdir -p /etc/docker/certs.d/$HOST_NAME/
    cp /opt/dire/ssl/keystore.crt /etc/docker/certs.d/$HOST_NAME/
    if [[ `grep -c "$HOST_NAME" /etc/hosts` -eq '0' ]]; then

        echo "$HOST $HOST_NAME" >> /etc/hosts
    fi
}

function site() {
    set_env
    up_servers
    deploy_docker_certs
}

function clean() {
    clean_env
    rm -rf /opt/dire/ssl
}
