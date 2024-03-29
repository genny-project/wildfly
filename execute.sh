#!/bin/bash

JBOSS_HOME=/opt/jboss/wildfly
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=standalone
JBOSS_CONFIG=standalone.xml

function wait_for_server() {
  until `/bin/bash $JBOSS_CLI -c "ls /deployment" &> /dev/null `; do
    sleep 1

  done
}

echo "=> Starting WildFly server"
/opt/jboss/wildfly/bin/standalone.sh  -c standalone-full-ha.xml >/dev/null &

echo "=> Waiting for the server to boot"
wait_for_server

##### THIS ENABLES KEYCLOAK!!
#$JBOSS_CLI -c --file=bin/adapter-install.cli
/bin/bash $JBOSS_CLI -c --file=/opt/jboss/wildfly/bin/adapter-elytron-install.cli
echo "=> Executing the commands to install JMS"
/bin/bash $JBOSS_CLI -c --file=/timeout.cli
/bin/bash $JBOSS_CLI -c --file=/command.cli
/bin/bash $JBOSS_CLI -c --file=/kie-jms3.cli

echo "=> Shutting down WildFly"
if [ "$JBOSS_MODE" = "standalone" ]; then
  /bin/bash $JBOSS_CLI -c ":shutdown"
else
  /bin/bash $JBOSS_CLI -c "/host=*:shutdown"
fi
