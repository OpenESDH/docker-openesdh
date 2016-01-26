
cp /alfresco/tomcat/webapps/alfresco.war /alfresco/tomcat/webapps/alfresco.war_bak
mkdir -p /tmp/opene_updates/opene_repo
mkdir -p /tmp/opene_updates/opene_ui

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
        ServerAdmin webmaster@localhost
        DocumentRoot /OpeneUI
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

#KLE properties
cat > /alfresco/tomcat/shared/classes/alfresco-global.properties << EOF
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

cd /OpeneUI
rm -f *.*
git clone https://github.com/OpenESDH/OpenESDH-UI.git .

npm install
bower update --allow-root | xargs echo
gulp all-modules-install

#cat > /etc/supervisor/conf.d/openeui.conf << EOF
#[program:openeui]
#priority=20
#directory=/OpeneUI
#command=gulp all-modules local
#user=root
#autostart=true
#autorestart=true
#EOF