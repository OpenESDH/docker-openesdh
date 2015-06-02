FROM java:8

RUN apt-get update
#RUN apt-get install -y wget
RUN apt-get install -y supervisor

COPY install.sh /tmp/install.sh
RUN chmod 755 /tmp/install.sh
RUN /tmp/install.sh

COPY init.sh /alfresco/init.sh
RUN chmod 755 /alfresco/init.sh

VOLUME /alfresco/alf_data
VOLUME /alfresco/tomcat/logs

EXPOSE 21 137 138 139 445 7070 8080
WORKDIR /alfresco
CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf -n
