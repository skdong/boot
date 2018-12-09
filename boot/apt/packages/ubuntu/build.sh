#/usr/bin/env bash

function deb_packages(){
    if [ `grep -c "personal-digest-preferences" ~/.gnupg/gpg.conf` -eq '0' ]; then
    
        echo "personal-digest-preferences SHA256" >> ~/.gnupg/gpg.conf
    fi
    
    rm -f deb/Packages.gz deb/Packages deb/Release deb/InRelease deb/Release.gpg
    apt-ftparchive packages deb | gzip -9c > deb/Packages.gz
    gunzip -k deb/Packages.gz
    apt-ftparchive release deb/ > deb/Release
    gpg -abs --default-key 927BA0AC  -o deb/Release.gpg deb/Release
    gpg --clearsign --default-key 927BA0AC -o deb/InRelease deb/Release
}

gpg --import /opt/dire/ubuntu/bjzdgt_ubuntu_2018.sec
cd /opt/dire/packages/
deb_packages
cd -
