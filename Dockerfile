FROM opene/alfresco:5.0.d

COPY *-repo*.amp /alfresco/amps/
COPY *-share*.amp /alfresco/amps_share/

RUN (yes | /alfresco/bin/apply_amps.sh)
