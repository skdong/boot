#!/usr/bin/env bash
source /env
BOOT_GROUP=${BOOT_GROUP:='dire'}
URL='http://'${GIT_HOST}'/'
python /opt/dire/build/create_keypair.py
python /opt/dire/build/upload_key.py -l $URL -t $TOKEN
python /opt/dire/build/get_projects.py -l $URL -t $TOKEN -g ${BOOT_GROUP}
cd /opt/dire/
for project in $(cat /opt/dire/projects.ini)
do
    git clone git@${GIT_HOST}:${BOOT_GROUP}/$(basename ${project}).git
done
