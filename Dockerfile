FROM opene/alfresco:5.0.d

COPY OpenE-UI/ /OpeneUI/
COPY init_opene.sh /OpeneUI/init_opene.sh
RUN chmod 755 /OpeneUI/init_opene.sh
WORKDIR /OpeneUI
RUN ./init_opene.sh

COPY annotations*.amp /alfresco/amps/
COPY webscripts*.amp /alfresco/amps/
RUN (yes | /alfresco/bin/apply_amps.sh -force)

COPY openesdh-repo*.amp /alfresco/amps/
RUN (yes | /alfresco/bin/apply_amps.sh -force)

#COPY aoi-repo*.amp /alfresco/amps/
#COPY office-repo*.amp /alfresco/amps/
COPY simple-case-repo*.amp /alfresco/amps/
COPY staff-repo*.amp /alfresco/amps/
RUN (yes | /alfresco/bin/apply_amps.sh -force)

# no share amps required any more
#COPY *-share*.amp /alfresco/amps_share/
#RUN (yes | /alfresco/bin/apply_amps.sh -force)

COPY addo-webapp*.war /alfresco/tomcat/webapps/

COPY kle.properties /tmp/
RUN cat /tmp/kle.properties >> /alfresco/tomcat/shared/classes/alfresco-global.properties

CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf -n