FROM tomcat:7.0.61-jre8

COPY install.sh /install.sh
RUN chmod 755 /install.sh

RUN /install.sh
