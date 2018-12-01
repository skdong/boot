#/usr/bin/env bash

ansible_tool=$1
ansible_tool=${ansible_tool:='ansible_tool'}
echo $ansible_tool

#docker rm  ansible_tool
docker run -it -d --name $ansible_tool --hostname $ansible_tool \
           -v /home/kolla/.ssh/:/root/.ssh \
           -v /home/kolla/dire:/opt/dire dire/ansible_tools bash
docker start ansible_tool
