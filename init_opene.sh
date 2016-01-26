
cp /alfresco/tomcat/webapps/alfresco.war /alfresco/tomcat/webapps/alfresco.war_bak
mkdir -p /tmp/opene_updates/opene_repo
mkdir -p /tmp/opene_updates/opene_ui

cat > /tmp/opene_updates/opene_ui/update_openeui.sh << EOF
cd /OpeneUI
git pull https://github.com/OpenESDH/OpenESDH-UI.git
npm install
bower update --allow-root | xargs echo
gulp all-modules-install
gulp all-modules build
EOF

chmod 755 /tmp/opene_updates/opene_ui/update_openeui.sh

cd /OpeneUI
rm -fr *
rm -f *.*
git clone https://github.com/OpenESDH/OpenESDH-UI.git .

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
EOF

cat > /etc/supervisor/conf.d/apache2.conf << EOF
[program:apache2]
command=/bin/bash -c "/etc/init.d/apache2 start"
EOF