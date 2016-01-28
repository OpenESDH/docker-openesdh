FROM opene/alfresco:5.0.d

COPY init_opene.sh /tmp/init_opene.sh
RUN chmod 755 /tmp/init_opene.sh
WORKDIR /tmp
RUN ./init_opene.sh

CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf -n
