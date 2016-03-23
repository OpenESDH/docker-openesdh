# Install alfresco.google.docs to alfresco.war first
wget https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/integrations/alfresco-googledocs-repo/3.0.2/alfresco-googledocs-repo-3.0.2.amp
/alfresco/java/bin/java -jar /alfresco/bin/alfresco-mmt.jar install alfresco-googledocs-repo-3.0.2.amp /alfresco/tomcat/webapps/alfresco.war -nobackup -force

cp /alfresco/tomcat/webapps/alfresco.war /alfresco/tomcat/webapps/alfresco.war_bak
mkdir -p /tmp/opene_updates/opene_repo
mkdir -p /tmp/opene_updates/opene_ui

cat > /tmp/opene_updates/opene_ui/update_openeui.sh << EOF
cd /OpeneUI
pwd
git pull https://github.com/OpenESDH/OpenESDH-UI.git
cp /tmp/VismaCase.svg /OpeneUI/app/assets/images/VismaCase.svg
#npm install
bower update --allow-root | xargs echo
gulp all-modules-install
gulp --title="Visma case" --logo "./app/assets/images/VismaCase.svg" all-modules build
EOF

chmod 755 /tmp/opene_updates/opene_ui/update_openeui.sh

cd /OpeneUI
rm -fr *
rm -f *.*
git clone https://github.com/OpenESDH/OpenESDH-UI.git .
npm install
/tmp/opene_updates/opene_ui/update_openeui.sh

apt-get update
apt-get install --yes apache2

cat >> /etc/apache2/apache2.conf << EOF
<Directory /OpeneUI/>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
EOF

cd /etc/apache2/sites-enabled
rm -f *.conf
cat > ./000-default.conf << EOF
<VirtualHost *:80>
        ProxyPreserveHost On
        DocumentRoot /OpeneUI
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        ProxyPass       /alfresco/opene/cases/  http://localhost:7070/alfresco/opene/cases/
        ProxyPass       /alfresco/  http://localhost:8080/alfresco/
        ProxyPassReverse /alfresco/opene/cases/  http://localhost:7070/alfresco/opene/cases/
        ProxyPassReverse /alfresco/  http://localhost:8080/alfresco/
</VirtualHost>
EOF

a2enmod proxy
a2enmod proxy_ajp
a2enmod proxy_http
a2enmod rewrite
a2enmod deflate
a2enmod headers
a2enmod proxy_balancer
a2enmod proxy_connect

#KLE properties
cat >> /alfresco/tomcat/shared/classes/alfresco-global.properties << EOF
# This specifies some reasonable defaults for a production setup of OpenESDH
# Change as needed.

# Whether to sync classification data
openesdh.classification.sync.enabled=true

# How often to sync classification data
# The first Sunday of every 3 months at 0200
openesdh.classification.sync.cron=0 0 2 ? 1/3 SUN#1 *

# Sync KLE data on startup if it is missing?
openesdh.classification.kle.syncOnStartupIfMissing=false

# KLE emneplan XML file URL
openesdh.classification.kle.emneplan.url=http://www.klxml.dk/download/XML-ver2-0/KLE-Emneplan_Version2-0.xml

# Notification and invitation mails settings
notification.email.siteinvite=true
#mail.host=smtp.gmail.com
#mail.username=vismacase@gmail.com
#mail.password=openesdh
#mail.port=587
#mail.smtp.starttls.enable=true

# The following share properties are used for notification and invitation emails to provide links to OpeneUI
share.protocol=http
share.host=10.170.12.125
share.port=80
share.context=
EOF

cat > /etc/supervisor/conf.d/apache2.conf << EOF
[program:apache2]
command=/bin/bash -c "/etc/init.d/apache2 start"
EOF

cat >> /alfresco/tomcat/bin/setenv.sh << EOF
export CATALINA_OPTS="-Dhttps.protocols=TLSv1,SSLv3,SSLv2Hello"
EOF

cat > /tmp/opene_updates/opene_repo/update_repo.sh << EOF
cd /tmp/opene_updates/opene_repo
if [ -f openesdh-repo-*.amp ]
then
    supervisorctl stop alfresco
    javapid=\`pidof java\`
    kill -9 \$javapid
    ALF_HOME=/alfresco
    CATALINA_HOME=/alfresco/tomcat
    JAVA_HOME=/alfresco/java
    rm -rf \$CATALINA_HOME/webapps/alfresco
    rm -f \$CATALINA_HOME/webapps/alfresco.war
    cp \$CATALINA_HOME/webapps/alfresco.war_bak \$CATALINA_HOME/webapps/alfresco.war
	REPO_AMP=\`find openesdh-repo*.amp\`
    \$JAVA_HOME/bin/java -jar \$ALF_HOME/bin/alfresco-mmt.jar install "\$REPO_AMP" "\$CATALINA_HOME/webapps/alfresco.war" -nobackup -force
    rm -f \$REPO_AMP
    \$JAVA_HOME/bin/java -jar \$ALF_HOME/bin/alfresco-mmt.jar install "/tmp/opene_updates/opene_repo" "\$CATALINA_HOME/webapps/alfresco.war" -directory -nobackup -force
    rm -f *.amp

    rm -rf \$CATALINA_HOME/webapps/addo_webapp
    rm -f \$CATALINA_HOME/webapps/addo_webapp.war
    cp ./addo*.war \$CATALINA_HOME/webapps/addo_webapp.war
    rm -f addo*.war
    supervisorctl start alfresco
else
echo "No update files."
fi

EOF
chmod 755 /tmp/opene_updates/opene_repo/update_repo.sh

apt-get install --yes mc
