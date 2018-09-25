
function clean-sources(){
    sudo rm /etc/apt/sources.list.d/*
    sudo truncate --size=0 /etc/apt/sources.list
}

function deploy-boot-source(){
    sudo cp files/boot.list /etc/apt/sources.list.d
    sudo apt-get update -y
}

function link-packages(){
    sudo mkdir -p /var/dire
    sudo rm /var/dire/boot
    sudo ln -s $PROJECT/boot/apt/packages/ubuntu /var/dire/boot
}

function install-docker(){
    sudo apt-get install docker-ce -y
}

function main(){
    link-packages
    clean-sources
    deploy-boot-source
    install-docker
}

main

