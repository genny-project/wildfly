#!/bin/bash

JBOSS_HOME=/opt/jboss/wildfly
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=standalone
JBOSS_CONFIG=standalone.xml

function wait_for_server() {
  until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do
    sleep 1
  done
}

echo "=> Starting WildFly server"
/opt/jboss/wildfly/bin/standalone.sh  -c standalone.xml >/dev/null &

echo "=> Waiting for the server to boot"
wait_for_server

##### THIS ENABLES KEYCLOAK!!
$JBOSS_CLI -c --file=bin/adapter-install.cli
echo "=> Executing the commands to install JMS"
$JBOSS_CLI -c --file=/jms.cli
$JBOSS_CLI -c --file=/timing.cli

echo "=> Shutting down WildFly"
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown"
else
  $JBOSS_CLI -c "/host=*:shutdown"
fi
