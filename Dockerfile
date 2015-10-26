FROM opene/alfresco:5.0.d

COPY annotations-*.amp /alfresco/amps/
COPY webscripts-*.amp /alfresco/amps/
COPY *-repo*.amp /alfresco/amps/
COPY *-share*.amp /alfresco/amps_share/

RUN (yes | /alfresco/bin/apply_amps.sh -force)

COPY kle.properties /tmp/
RUN cat /tmp/kle.properties >> /alfresco/tomcat/shared/classes/alfresco-global.properties
