#!/bin/sh

apt-get -qq -y update
adduser --system --no-create-home --disabled-login --disabled-password --group alfresco
echo "alfresco       soft    nofile          8192" | tee -a /etc/security/limits.conf
echo "alfresco       hard    nofile         65536" | tee -a /etc/security/limits.conf
echo "session required pam_limits.so" | tee -a /etc/pam.d/common-session
echo "session required pam_limits.so" | tee -a /etc/pam.d/common-session-noninteractive
rm -rf $CATALINA_HOME/webapps/*

JDBCPOSTGRESURL=https://jdbc.postgresql.org/download
JDBCPOSTGRES=postgresql-9.4-1201.jdbc41.jar

curl -o $CATALINA_HOME/lib/$JDBCPOSTGRES $JDBCPOSTGRESURL/$JDBCPOSTGRES

ALFREPOWAR=https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco/5.0.d/alfresco-5.0.d.war
curl -o $CATALINA_HOME/webapps/alfresco.war $ALFREPOWAR

ALF_HOME=/opt/alfresco
ALF_DATA_HOME=$ALF_HOME/alf_data
KEYSTOREBASE=https://svn.alfresco.com/repos/alfresco-open-mirror/alfresco/HEAD/root/projects/repository/config/alfresco/keystore

mkdir -p $ALF_DATA_HOME/keystore

curl -o $ALF_DATA_HOME/keystore/browser.p12 $KEYSTOREBASE/browser.p12
curl -o $ALF_DATA_HOME/keystore/generate_keystores.sh $KEYSTOREBASE/generate_keystores.sh
curl -o $ALF_DATA_HOME/keystore/keystore $KEYSTOREBASE/keystore
curl -o $ALF_DATA_HOME/keystore/keystore-passwords.properties $KEYSTOREBASE/keystore-passwords.properties
curl -o $ALF_DATA_HOME/keystore/ssl-keystore-passwords.properties $KEYSTOREBASE/ssl-keystore-passwords.properties
curl -o $ALF_DATA_HOME/keystore/ssl-truststore-passwords.properties $KEYSTOREBASE/ssl-truststore-passwords.properties
curl -o $ALF_DATA_HOME/keystore/ssl.keystore $KEYSTOREBASE/ssl.keystore
curl -o $ALF_DATA_HOME/keystore/ssl.truststore $KEYSTOREBASE/ssl.truststore
