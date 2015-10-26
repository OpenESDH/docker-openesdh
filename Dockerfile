FROM opene/alfresco:5.0.d

COPY annotations-*.amp /alfresco/amps/
COPY webscripts-*.amp /alfresco/amps/
RUN (yes | /alfresco/bin/apply_amps.sh -force)

COPY openesdh-repo*.amp /alfresco/amps/
RUN (yes | /alfresco/bin/apply_amps.sh -force)

COPY aoi-repo*.amp /alfresco/amps/
COPY office-repo*.amp /alfresco/amps/
COPY simple-case-repo*.amp /alfresco/amps/
COPY staff-repo*.amp /alfresco/amps/
RUN (yes | /alfresco/bin/apply_amps.sh -force)

COPY *-share*.amp /alfresco/amps_share/
RUN (yes | /alfresco/bin/apply_amps.sh -force)

COPY kle.properties /tmp/
RUN cat /tmp/kle.properties >> /alfresco/tomcat/shared/classes/alfresco-global.properties
