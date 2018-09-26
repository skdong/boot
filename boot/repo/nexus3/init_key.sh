#!/usr/bin/env bash

NEXUS_DOMAIN=10.0.35.21
NEXUS_IP_ADDRESS=10.0.35.21
PASSWD=nexus3

cd /opt/sonatype/nexus/etc/ssl
if [[ ! -f keystore.jks ]]; then
    keytool -genkeypair -keystore keystore.jks -storepass ${PASSWD} \
     -keypass ${PASSWD} -alias nexus -keyalg RSA -keysize 2048 \
     -validity 5000 -dname "CN=${NEXUS_DOMAIN}, \
     OU=Nexus, O=Nexus, L=Beijing, ST=Beijing, C=CN" \
     -ext "SAN=IP:${NEXUS_IP_ADDRESS}" -ext "BC=ca:true" \
     -storetype pkcs12
fi

if [[ ! -f keystore.crt ]]; then
    keytool -export -alias nexus -keystore keystore.jks \
      -file keystore.crt -storepass $PASSWD -rfc
fi
