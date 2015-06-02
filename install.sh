#!/bin/sh

ALF_HOME=/alfresco
ALF_BIN=alfresco-community-5.0.d-installer-linux-x64.bin
cd /tmp
wget http://dl.alfresco.com/release/community/5.0.d-build-00002/$ALF_BIN
chmod +x $ALF_BIN

./$ALF_BIN --mode unattended --prefix $ALF_HOME --alfresco_admin_password admin

rm $ALF_BIN

cat > /etc/supervisor/conf.d/alfresco.conf << EOF
[program:alfresco]
priority=20
directory=/alfresco/tomcat/logs
command=/alfresco/init.sh
user=root
autostart=true
autorestart=true
stdout_logfile=/alfresco/tomcat/logs/catalina_stdout.log
stderr_logfile=/alfresco/tomcat/logs/catalina_stderr.log
EOF
