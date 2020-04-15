FROM  openjdk:8u212-jre-alpine3.9

RUN apk update && apk add jq && apk add curl && apk add bash && apk add xmlstarlet && apk add wget && apk add vim && apk add unzip && apk add sed
RUN echo http://mirror.yandex.ru/mirrors/alpine/v3.9/main > /etc/apk/repositories; \
    echo http://mirror.yandex.ru/mirrors/alpine/v3.9/community >> /etc/apk/repositories
RUN ln -s /bin/sed /usr/bin/sed
RUN chmod a+x /usr/bin/sed

MAINTAINER Adam Crow <acrow@crowtech.com.au>
ENV HOME /opt/jboss
ENV WILDFLY_VERSION 19.0.0.Final
ENV KEYCLOAK_VERSION 9.0.2
ENV MYSQLCONNECTOR_VERSION 8.0.19 

# Enables signals getting passed from startup script to JVM
# ensuring clean shutdown when container is stopped.
ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV MYSQL_PORT_3306_TCP_PORT 3306

USER root

RUN chmod -Rf 777 /tmp
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


#Update jgroups UDP send/rx buffer size
RUN echo "# Allow a 25MB UDP receive buffer for JGroups  " > /etc/sysctl.conf
RUN echo "net.core.rmem_max = 26214400 " >> /etc/sysctl.conf 
RUN echo "# Allow a 1MB UDP send buffer for JGroups " >> /etc/sysctl.conf 
RUN echo "net.core.wmem_max = 1048576" >> /etc/sysctl.conf

USER root

WORKDIR $HOME 

############################ Database #############################
ADD changeDatabase.xsl $JBOSS_HOME/
RUN java -jar /usr/share/java/saxon.jar -s:$JBOSS_HOME/standalone/configuration/standalone.xml -xsl:$JBOSS_HOME/changeDatabase.xsl -o:$JBOSS_HOME/standalone/configuration/standalone.xml;  
RUN java -jar /usr/share/java/saxon.jar -s:$JBOSS_HOME/standalone/configuration/standalone-ha.xml -xsl:$JBOSS_HOME/changeDatabase.xsl -o:$JBOSS_HOME/standalone/configuration/standalone-ha.xml;  
RUN java -jar /usr/share/java/saxon.jar -s:$JBOSS_HOME/standalone/configuration/standalone-full-ha.xml -xsl:$JBOSS_HOME/changeDatabase.xsl -o:$JBOSS_HOME/standalone/configuration/standalone-full-ha.xml;  
RUN mkdir -p $JBOSS_HOME/modules/system/layers/base/com/mysql/jdbc/main; cd $JBOSS_HOME/modules/system/layers/base/com/mysql/jdbc/main  && curl -O https://repo1.maven.org/maven2/mysql/mysql-connector-java/$MYSQLCONNECTOR_VERSION/mysql-connector-java-$MYSQLCONNECTOR_VERSION.jar 
#RUN mkdir -p $JBOSS_HOME/modules/system/layers/base/com/mysql/jdbc/main; cd $JBOSS_HOME/modules/system/layers/base/com/mysql/jdbc/main  && curl -O https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java-$MYSQLCONNECTOR_VERSION.zip && unzip -o mysql-connector-java-$MYSQLCONNECTOR_VERSION.zip
#RUN mkdir -p $JBOSS_HOME/modules/system/layers/base/com/mysql/jdbc/main; cd $JBOSS_HOME/modules/system/layers/base/com/mysql/jdbc/main && curl -O https://mvnrepository.com/artifact/mysql/mysql-connector-java/$MYSQLCONNECTOR_VERSION/mysql-connector-java-$MYSQLCONNECTOR_VERSION.jar
#RUN curl -O https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java-$MYSQLCONNECTOR_VERSION.zip
#RUN unzip -o mysql-connector-java-$MYSQLCONNECTOR_VERSION.zip
#RUN rm -Rf mysql-connector-java-$MYSQLCONNECTOR_VERSION.zip
ADD module.xml $JBOSS_HOME/modules/system/layers/base/com/mysql/jdbc/main/
RUN sed -i "s/mysql-connector-java/mysql-connector-java-$MYSQLCONNECTOR_VERSION/g" $JBOSS_HOME/modules/system/layers/base/com/mysql/jdbc/main/module.xml
RUN sed -i 's/ExampleDS/gennyDS/g' $JBOSS_HOME/standalone/configuration/standalone.xml
RUN sed -i 's/ExampleDS/gennyDS/g' $JBOSS_HOME/standalone/configuration/standalone-ha.xml
RUN sed -i 's/ExampleDS/gennyDS/g' $JBOSS_HOME/standalone/configuration/standalone-full-ha.xml

############################ Security #############################
#Add Keycloak Support
WORKDIR $JBOSS_HOME
RUN wget http://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/adapters/keycloak-oidc/keycloak-wildfly-adapter-dist-$KEYCLOAK_VERSION.zip  -O $JBOSS_HOME/keycloak-wildfly-adapter-dist.zip
RUN unzip -o $JBOSS_HOME/keycloak-wildfly-adapter-dist.zip 
RUN rm -Rf keycloak-wildfly-adapter-dist.zip

############################ Node Identifier #############################
ADD node-identifier.xsl $JBOSS_HOME/
RUN java -jar /usr/share/java/saxon.jar -s:$JBOSS_HOME/standalone/configuration/standalone.xml -xsl:$JBOSS_HOME/node-identifier.xsl -o:$JBOSS_HOME/standalone/configuration/standalone.xml;  
RUN java -jar /usr/share/java/saxon.jar -s:$JBOSS_HOME/standalone/configuration/standalone-ha.xml -xsl:$JBOSS_HOME/node-identifier.xsl -o:$JBOSS_HOME/standalone/configuration/standalone-ha.xml;  
RUN java -jar /usr/share/java/saxon.jar -s:$JBOSS_HOME/standalone/configuration/standalone-full-ha.xml -xsl:$JBOSS_HOME/node-identifier.xsl -o:$JBOSS_HOME/standalone/configuration/standalone-full-ha.xml;  


ADD execute.sh /
ADD command.cli /
#ADD deployment-timeout.cli /
ADD kie-jms3.cli /
ADD timeout.cli /
RUN /execute.sh

ADD setLogLevel.xsl $JBOSS_HOME/
RUN java -jar /usr/share/java/saxon.jar -s:$JBOSS_HOME/standalone/configuration/standalone.xml -xsl:$JBOSS_HOME/setLogLevel.xsl -o:$JBOSS_HOME/standalone/configuration/standalone.xml
RUN java -jar /usr/share/java/saxon.jar -s:$JBOSS_HOME/standalone/configuration/standalone-ha.xml -xsl:$JBOSS_HOME/setLogLevel.xsl -o:$JBOSS_HOME/standalone/configuration/standalone-ha.xml
RUN java -jar /usr/share/java/saxon.jar -s:$JBOSS_HOME/standalone/configuration/standalone-full-ha.xml -xsl:$JBOSS_HOME/setLogLevel.xsl -o:$JBOSS_HOME/standalone/configuration/standalone-full-ha.xml

#Set up for proxy
RUN xmlstarlet ed -L -i "//*[local-name()='http-listener']"  -t attr -n "proxy-address-forwarding" -v "true"  $JBOSS_HOME/standalone/configuration/standalone.xml
RUN xmlstarlet ed -L -i "//*[local-name()='http-listener']"  -t attr -n "proxy-address-forwarding" -v "true"  $JBOSS_HOME/standalone/configuration/standalone-ha.xml
RUN xmlstarlet ed -L -i "//*[local-name()='http-listener']"  -t attr -n "proxy-address-forwarding" -v "true"  $JBOSS_HOME/standalone/configuration/standalone-full-ha.xml

RUN sed -i 's/127.0.0.1/0.0.0.0/g' $JBOSS_HOME/standalone/configuration/standalone.xml
RUN sed -i 's/CHANGE ME!!/WubbaLubbaDubDub/g' $JBOSS_HOME/standalone/configuration/standalone.xml
RUN sed -i 's/127.0.0.1/0.0.0.0/g' $JBOSS_HOME/standalone/configuration/standalone-ha.xml
RUN sed -i 's/CHANGE ME!!/WubbaLubbaDubDub/g' $JBOSS_HOME/standalone/configuration/standalone-ha.xml
RUN sed -i 's/127.0.0.1/0.0.0.0/g' $JBOSS_HOME/standalone/configuration/standalone-full-ha.xml
RUN sed -i 's/CHANGE ME!!/WubbaLubbaDubDub/g' $JBOSS_HOME/standalone/configuration/standalone-full-ha.xml

RUN sed -i 's/coordinator-environment statistics-enabled=/coordinator-environment default-timeout="4200" statistics-enabled=/g'  $JBOSS_HOME/standalone/configuration/standalone.xml
RUN sed -i 's/coordinator-environment statistics-enabled=/coordinator-environment default-timeout="4200" statistics-enabled=/g'  $JBOSS_HOME/standalone/configuration/standalone-ha.xml
RUN sed -i 's/coordinator-environment statistics-enabled=/coordinator-environment default-timeout="4200" statistics-enabled=/g'  $JBOSS_HOME/standalone/configuration/standalone-full-ha.xml

# clean up empty xmlns strings
RUN sed -i 's/xmlns=\"\"//g' $JBOSS_HOME/standalone/configuration/standalone.xml
RUN sed -i 's/xmlns=\"\"//g' $JBOSS_HOME/standalone/configuration/standalone-ha.xml
RUN sed -i 's/xmlns=\"\"//g' $JBOSS_HOME/standalone/configuration/standalone-full-ha.xml

RUN cp -f $JBOSS_HOME/standalone/configuration/standalone-full-ha.xml $JBOSS_HOME/standalone/configuration/standalone.xml
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
