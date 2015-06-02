FROM opene/alfresco:5.0.d

COPY **/*.amp /alfresco/amps/

RUN yes | /alfresco/bin/apply_amps.sh 
