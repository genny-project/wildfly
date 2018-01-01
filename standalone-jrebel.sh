#!/bin/bash
export REBEL_HOME=/opt/jboss/wildfly/jrebel
export JAVA_OPTS="-agentpath:$REBEL_HOME/lib/libjrebel64.so -Drebel.remoting_plugin=true -Xms256m -Xmx512m -XX:MaxPermSize=256m $JAVA_OPTS"
`dirname $0`/standalone.sh $@

