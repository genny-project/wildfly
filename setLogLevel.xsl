<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:log="urn:jboss:domain:logging:8.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="//log:subsystem">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
                <log:logger category="org.jbpm.process.audit.VariableInstanceLog">
                    <log:level>
                      <xsl:attribute name="name">${env.KEYCLOAK_LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.keycloak">
                    <log:level>
                      <xsl:attribute name="name">${env.KEYCLOAK_LOGLEVEL:INFO}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="com.hazelcast">
                    <log:level>
                      <xsl:attribute name="name">${env.HAZELCAST_LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.drools.compiler">
                    <log:level>
                      <xsl:attribute name="name">${env.DROOLS_LOGLEVEL:INFO}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.jboss.resteasy.resteasy_jaxrs.i18n">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.jboss.as.weld">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.jboss.weld">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.jboss.as.server.deployment">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.apache.activemq">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.jbpm.executor.impl.concurrent.LoadAndScheduleRequestsTask">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.jboss.modules.define">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.kie.api.internal.utils.ServiceDiscoveryImpl">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.wildfly.extension.messaging-activemq">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.infinispan.remoting.transport.jgroups.JGroupsTransport">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.jboss.as.ejb3.deployment">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.jboss.as.clustering.infinispan">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.infinispan.CLUSTER">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="io.vertx.resourceadapter.inflow.impl.VertxActivation">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="io.vertx.resourceadapter.impl.VertxPlatformFactory">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:OFF}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.wildfly.extension.undertow">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.jboss.modcluster">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.jgroups.protocols">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.jboss.as">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.hibernate">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.infinispan">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="io.smallrye.metrics">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.jboss.remoting">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.wildfly.extension">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.wildfly.iiop.openjdk">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.jboss.ws.common.management">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.xnio">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="javax.enterprise.resource">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.keycloak.adapters">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="io.vertx.core.impl.HAManager">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="org.drools.core.xml.ExtensibleXmlParser">
                    <log:level>
                      <xsl:attribute name="name">${env.LOGLEVEL:ERROR}</xsl:attribute>
                    </log:level>
                </log:logger>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>

