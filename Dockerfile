#FROM  openjdk:9.0.1-11-jre-sid
#RUN apt-get clean && apt-get -y update && apt-get install -y jq sed curl bash xmlstarlet wget vim unzip  && apt-get clean

FROM  openjdk:8u151-jre-alpine3.7
RUN apk update && apk add jq && apk add curl && apk add bash && apk add xmlstarlet && apk add wget && apk add vim && apk add unzip && apk add sed
RUN echo http://mirror.yandex.ru/mirrors/alpine/v3.7/main > /etc/apk/repositories; \
    echo http://mirror.yandex.ru/mirrors/alpine/v3.7/community >> /etc/apk/repositories
RUN ln -s /bin/sed /usr/bin/sed
RUN chmod a+x /usr/bin/sed

MAINTAINER Adam Crow <acrow@crowtech.com.au>
ENV HOME /opt/jboss
ENV WILDFLY_VERSION 14.0.1.Final
ENV KEYCLOAK_VERSION 3.4.0.Final
ENV MYSQLCONNECTOR_VERSION 5.1.41

# Enables signals getting passed from startup script to JVM
# ensuring clean shutdown when container is stopped.
ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV MYSQL_PORT_3306_TCP_PORT 3306

USER root

RUN mkdir -p /opt/jboss
RUN chown -R root:root $HOME 

COPY java/* /usr/share/java/

USER root 
ENV JBOSS_HOME $HOME/wildfly

#RUN echo "http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.zip -O $HOME/wildfly.zip | tar zx && mv $HOME/keycloak-$WILDFLY_VERSION $JBOSS_HOME"
RUN cd /opt/jboss/ && curl -L http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.zip -o $HOME/wildfly.zip
RUN unzip $HOME/wildfly.zip -d $HOME
RUN mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME
ADD docker-entrypoint.sh $HOME/
RUN rm -f $HOME/wildfly.zip
RUN cp -f $JBOSS_HOME/standalone/configuration/standalone-full-ha.xml $JBOSS_HOME/standalone/configuration/standalone.xml

ADD setLogLevel.xsl $JBOSS_HOME/
RUN java -jar /usr/share/java/saxon.jar -s:$JBOSS_HOME/standalone/configuration/standalone.xml -xsl:$JBOSS_HOME/setLogLevel.xsl -o:$JBOSS_HOME/standalone/configuration/standalone.xml


USER root

WORKDIR $HOME 

############################ Database #############################
ADD changeDatabase.xsl $JBOSS_HOME/
RUN java -jar /usr/share/java/saxon.jar -s:$JBOSS_HOME/standalone/configuration/standalone.xml -xsl:$JBOSS_HOME/changeDatabase.xsl -o:$JBOSS_HOME/standalone/configuration/standalone.xml;  
RUN mkdir -p $JBOSS_HOME/modules/system/layers/base/com/mysql/jdbc/main; cd $JBOSS_HOME/modules/system/layers/base/com/mysql/jdbc/main && curl -O http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQLCONNECTOR_VERSION/mysql-connector-java-$MYSQLCONNECTOR_VERSION.jar

ADD module.xml $JBOSS_HOME/modules/system/layers/base/com/mysql/jdbc/main/
RUN sed -i "s/mysql-connector-java/mysql-connector-java-$MYSQLCONNECTOR_VERSION/g" $JBOSS_HOME/modules/system/layers/base/com/mysql/jdbc/main/module.xml
RUN sed -i 's/ExampleDS/gennyDS/g' $JBOSS_HOME/standalone/configuration/standalone.xml

############################ Security #############################
#Add Keycloak Support
WORKDIR $JBOSS_HOME
RUN wget http://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/adapters/keycloak-oidc/keycloak-wildfly-adapter-dist-$KEYCLOAK_VERSION.zip  -O $JBOSS_HOME/keycloak-wildfly-adapter-dist.zip
RUN unzip -o $JBOSS_HOME/keycloak-wildfly-adapter-dist.zip 
RUN rm -Rf keycloak-wildfly-adapter-dist.zip

############################ Node Identifier #############################
#ADD node-identifier.xsl $JBOSS_HOME/
#RUN java -jar /usr/share/java/saxon.jar -s:$JBOSS_HOME/standalone/configuration/standalone.xml -xsl:$JBOSS_HOME/node-identifier.xsl -o:$JBOSS_HOME/standalone/configuration/standalone.xml;  


ADD execute.sh /
ADD command.cli /
ADD jms.cli /
ADD timeout.cli /
RUN /execute.sh

#Set up for proxy
RUN xmlstarlet ed -L -i "//*[local-name()='http-listener']"  -t attr -n "proxy-address-forwarding" -v "true"  $JBOSS_HOME/standalone/configuration/standalone.xml

#ADD standalone.xml $JBOSS_HOME/standalone/configuration/standalone.xml

RUN sed -i 's/127.0.0.1/0.0.0.0/g' $JBOSS_HOME/standalone/configuration/standalone.xml

# clean up empty xmlns strings
RUN sed -i 's/xmlns=\"\"//g' $JBOSS_HOME/standalone/configuration/standalone.xml

#COPY standalone-full-ha.xml /opt/jboss/wildfly/standalone/configuration/standalone-full-ha.xml

RUN rm -Rf $JBOSS_HOME/standalone/configuration/standalone_xml_history/current
RUN chown -R root:root $HOME
USER root 

EXPOSE 8080
EXPOSE 9990
EXPOSE 8787
EXPOSE 50293
EXPOSE 8998

ENTRYPOINT [ "/opt/jboss/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]
