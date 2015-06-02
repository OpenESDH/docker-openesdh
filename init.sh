#!/bin/bash

ALF_HOME=/alfresco
CATALINA_HOME=$ALF_HOME/tomcat

source $ALF_HOME/scripts/setenv.sh

$ALF_HOME/postgresql/scripts/ctl.sh start

$CATALINA_HOME/bin/catalina.sh run
