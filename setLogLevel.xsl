<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:log="urn:jboss:domain:logging:7.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="//log:subsystem">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
                <log:logger category="org.keycloak">
                    <log:level>
                      <xsl:attribute name="name">${env.KEYCLOAK_LOGLEVEL:INFO}</xsl:attribute>
                    </log:level>
                </log:logger>
                <log:logger category="com.hazelcast">
                    <log:level>
                      <xsl:attribute name="name">${env.HAZELCAST_LOGLEVEL:INFO}</xsl:attribute>
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
                <log:logger category="org.apache.activemq">
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

