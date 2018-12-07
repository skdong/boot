#!/usr/bin/env bash
URL='http://'${GIT_HOST}/
python /opt/dire/publish/create_keypair.py
python /opt/dire/publish/upload_key.py -u $URL -t $TOKEN
python /opt/dire/publish/create_projects.py -u $URL -t $TOKE
for project in '/opt/dire/packages/*'
do
    cd ${project}
    git add remote dire git@${GIT_HOST}:dire/$(basename ${project}).git
    git push
done