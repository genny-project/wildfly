<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ds="urn:jboss:domain:datasources:4.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="//ds:subsystem/ds:datasources/ds:datasource[@jndi-name='java:jboss/datasources/ExampleDS']">
        <ds:datasource jndi-name="java:jboss/datasources/gennyDS" pool-name="gennyDS" enabled="true" use-java-context="true" use-ccm="false">
            <ds:connection-url>jdbc:mysql:loadbalance://${env.MYSQL_URL:db}:${env.MYSQL_PORT:3306}/${env.MYSQL_DB:db}?failOverReadOnly=false&amp;maxReconnects=100&amp;zeroDateTimeBehavior=convertToNull&amp;autoReconnect=true&amp;characterEncoding=UTF-8&amp;characterSetResults=UTF-8&amp;useUnicode=true&amp;interactiveClient=true&amp;connectTimeout=60000&amp;socketTimeout=60000</ds:connection-url>
            <ds:driver>mysql</ds:driver>
            <ds:security>
                <ds:user-name>${env.MYSQL_USER:admin}</ds:user-name>
                <ds:password>${env.MYSQL_PASSWORD:password}</ds:password>
            </ds:security>
            <ds:validation>
                <ds:check-valid-connection-sql>SELECT 1</ds:check-valid-connection-sql>
                <ds:background-validation>true</ds:background-validation>
                <ds:background-validation-millis>60000</ds:background-validation-millis>
                <ds:validate-on-match>true</ds:validate-on-match>
            </ds:validation>
            <ds:pool>
                <ds:flush-strategy>IdleConnections</ds:flush-strategy>
                <ds:max-pool-size>150</ds:max-pool-size>
            </ds:pool>
        </ds:datasource>
    </xsl:template>

    <xsl:template match="//ds:subsystem/ds:datasources/ds:drivers">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <ds:driver name="mysql" module="com.mysql.jdbc">
                <ds:xa-datasource-class>com.mysql.jdbc.jdbc2.optional.MysqlXADataSource</ds:xa-datasource-class>
            </ds:driver>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>

