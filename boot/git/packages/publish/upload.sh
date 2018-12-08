#!/usr/bin/env bash
BOOT_GROUP=${BOOT_GROUP:='dire'}
URL='http://'${GIT_HOST}'/'
python /opt/dire/publish/create_keypair.py
python /opt/dire/publish/upload_key.py -l $URL -t $TOKEN
python /opt/dire/publish/create_group.py -l $URL -t $TOKEN -g ${BOOT_GROUP}
for project in /opt/dire/packages/git/*
do
    cd ${project}
    git remote remove dire
    git remote add dire git@${GIT_HOST}:${BOOT_GROUP}/$(basename ${project}).git
    git push dire
done
