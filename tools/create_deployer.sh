
#/usr/bin/env bash

deployer=$1
if  [[ ! -n $deployer ]]; then
    echo "please input deployer name"
    exit 1
fi
echo $deployer

#docker rm  ansible_tool
docker run -it -d --name $deployer --hostname $deployer \
           -v /opt/dire/data:/opt/dire/data --net host \
            --restart always dire/deploy bash
docker start $deployer
