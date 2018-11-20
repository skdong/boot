#/usr/bin/env bash

docker rm -f ansible_tool
docker run -it -d --name ansible_tool -v /home/kolla/dire:/opt/dire dire/ansible_tools bash
docker start ansible_tool
