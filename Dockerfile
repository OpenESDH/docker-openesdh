FROM opene/alfresco:5.0.d

COPY dk.openesdh/openesdh-repo/1.0-SNAPSHOT/*.amp /alfresco/amps/

RUN yes | /alfresco/bin/apply_amps.sh 
