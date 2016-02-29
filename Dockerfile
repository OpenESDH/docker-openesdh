FROM opene/alfresco:5.0.d

COPY init_opene.sh /tmp/init_opene.sh
RUN chmod 755 /tmp/init_opene.sh

COPY opene_test_log.sh /tmp/opene_test_log.sh
RUN chmod 755 /tmp/opene_test_log.sh

COPY VismaCase.svg /tmp/VismaCase.svg

WORKDIR /tmp
RUN ./init_opene.sh

CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf -n
