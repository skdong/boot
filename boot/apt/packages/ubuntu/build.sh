#/usr/bin/env bash

function debs_packages(){
    if [ `grep -c "personal-digest-preferences" ~/.gnupg/gpg.conf` -eq '0' ]; then
    
        echo "personal-digest-preferences SHA256" >> ~/.gnupg/gpg.conf
    fi
    
    rm -f debs/Packages.gz debs/Packages debs/Release debs/InRelease debs/Release.gpg
    apt-ftparchive packages debs | gzip -9c > debs/Packages.gz
    gunzip -k debs/Packages.gz
    apt-ftparchive release debs/ > debs/Release
    gpg -abs --default-key 927BA0AC  -o debs/Release.gpg debs/Release
    gpg --clearsign --default-key 927BA0AC -o debs/InRelease debs/Release
}

gpg --import /opt/dire/ubuntu/bjzdgt_ubuntu_2018.sec
cd /opt/dire/packages/
debs_packages
cd -
