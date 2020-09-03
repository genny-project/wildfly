#!/bin/bash

if [ $ADMIN_USERNAME ] && [ $ADMIN_PASSWORD ]; then
    /opt/jboss/wildfly/bin/add-user.sh  $ADMIN_USERNAME  $ADMIN_PASSWORD
fi

if [ $XMX ] ; then
    echo "JVM XMX = "$XMX
    sed -i 's,-Xmx512m,-Xmx'"$XMX"',g' /opt/jboss/wildfly/bin/standalone.conf 
fi

if [ $XMS ] ; then
    echo "JVM XMS = "$XMS
    sed -i 's,-Xms64m,-Xms'"$XMS"',g' /opt/jboss/wildfly/bin/standalone.conf
fi

/opt/jboss/wildfly/bin/add-user.sh  jmsuser jmspassword1 

if [[ $DEBUG == "TRUE" ]]; then 
    echo "Remote Debug on port 8787 True"; 
    /opt/jboss/wildfly/bin/standalone.sh --debug 8787 -Drebel.remoting_plugin=true  -DHIBERNATE_SHOW_SQL=${HIBERNATE_SHOW_SQL:=false} -DHIBERNATE_HBM2DDL=$HIBERNATE_HBM2DDL -DMYSQL_USER=$MYSQL_USER -DMYSQL_PASSWORD=$MYSQL_PASSWORD -Djava.security.auth.login.config=''   -Dhazelcast.health.monitoring.level=OFF  $@
else 
    echo "Debug is False"; 
    /opt/jboss/wildfly/bin/standalone.sh  -DHIBERNATE_SHOW_SQL=$HIBERNATE_SHOW_SQL -DHIBERNATE_HBM2DDL=$HIBERNATE_HBM2DDL -DMYSQL_USER=$MYSQL_USER -DMYSQL_PASSWORD=$MYSQL_PASSWORD -Djava.security.auth.login.config=''  -Dhazelcast.health.monitoring.level=OFF $@
fi
