<?xml version='1.0' encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'
		             xmlns:date="http://exslt.org/dates-and-times">

<xsl:output method="text" indent="yes" encoding="utf-8"/>

<xsl:variable name="CLASSNAME">
	<xsl:call-template name="settings"><xsl:with-param name="varname" select="'class-name'"/></xsl:call-template>
</xsl:variable>
<xsl:variable name="ARGPREFIX">
	<xsl:call-template name="settings"><xsl:with-param name="varname" select="'arg-prefix'"/></xsl:call-template>
</xsl:variable>
<xsl:variable name="PACKAGE">
	<xsl:call-template name="settings"><xsl:with-param name="varname" select="'package'"/></xsl:call-template>
</xsl:variable>

<xsl:template match="/">

<xsl:if test="normalize-space($PACKAGE)=''">
package main
</xsl:if>
<xsl:if test="normalize-space($PACKAGE)!=''">
package <xsl:value-of select="$PACKAGE"/>
</xsl:if>

import (
	"fmt"
	"uniset"
)

// ----------------------------------------------------------------------------------
type  <xsl:value-of select="$CLASSNAME"/>_SK struct {

	// ID
	<xsl:call-template name="ID-LIST"/>

	// i/o
	<xsl:call-template name="IO-LIST"/>

	// variables
	<xsl:call-template name="VAR-LIST"/>

	ins  []*uniset.Int64Value // список входов
	outs []*uniset.Int64Value // список выходов

	myname string
	id uniset.ObjectID
}

// ----------------------------------------------------------------------------------
func Init_<xsl:value-of select="$CLASSNAME"/>( sk* <xsl:value-of select="$CLASSNAME"/>, name string, section string ) {

	sk.myname = name

	cfg, err := uniset.GetConfigParamsByName(name,section)
	if err != nil {
		panic(fmt.Sprintf("(Init_<xsl:value-of select="$CLASSNAME"/>): error: %s", err))
	}

	sk.id = uniset.InitObjectID(cfg,"",name)

	<xsl:call-template name="VAR-INIT"/>
	<xsl:call-template name="ID-INIT"/>

	<xsl:call-template name="INS-INIT"/>
	<xsl:call-template name="OUTS-INIT"/>
}
// ----------------------------------------------------------------------------------
</xsl:template>


<xsl:template name="setprefix">
<xsl:choose>
	<xsl:when test="normalize-space(@vartype)='in'">in_</xsl:when>
	<xsl:when test="normalize-space(@vartype)='out'">out_</xsl:when>
	<xsl:when test="normalize-space(@vartype)='none'">nn_</xsl:when>
	<xsl:when test="normalize-space(@vartype)='io'">NOTSUPPORTED_IO_VARTYPE_</xsl:when>
</xsl:choose>
</xsl:template>

<xsl:template name="settings">
	<xsl:param name="varname"/>
	<xsl:for-each select="//settings">
		<xsl:for-each select="./*">
			<xsl:if test="normalize-space(@name)=$varname"><xsl:value-of select="@val"/></xsl:if>
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>

<xsl:template name="VAR-LIST">
	<xsl:for-each select="//variables/item">
<!--	<xsl:if test="normalize-space(@private)=''">
	<xsl:if test="normalize-space(@public)=''">
-->
	<xsl:if test="normalize-space(@type)!=''"></xsl:if>
	<xsl:if test="normalize-space(@type)='int'"><xsl:value-of select="@name"/> int32 /*!&lt; <xsl:value-of select="@comment"/> */
	</xsl:if>
	<xsl:if test="normalize-space(@type)='long'"><xsl:value-of select="@name"/> int64 /*!&lt; <xsl:value-of select="@comment"/> */
	</xsl:if>
	<xsl:if test="normalize-space(@type)='float'"><xsl:value-of select="@name"/> float32 /*!&lt; <xsl:value-of select="@comment"/> */
	</xsl:if>
	<xsl:if test="normalize-space(@type)='double'"><xsl:value-of select="@name"/> float64 /*!&lt; <xsl:value-of select="@comment"/> */
	</xsl:if>
	<xsl:if test="normalize-space(@type)='bool'"><xsl:value-of select="@name"/> bool /*!&lt; <xsl:value-of select="@comment"/> */
	</xsl:if>
	<xsl:if test="normalize-space(@type)='str'"><xsl:value-of select="@name"/> string /*!&lt; <xsl:value-of select="@comment"/> */
	</xsl:if>
	<xsl:if test="normalize-space(@type)='sensor'"><xsl:value-of select="@name"/> uniset.SensorID /*!&lt; <xsl:value-of select="@comment"/> */
	</xsl:if>
	<xsl:if test="normalize-space(@type)='object'"><xsl:value-of select="@name"/> uniset.ObjectID /*!&lt; <xsl:value-of select="@comment"/> */
	</xsl:if>
<!--
	</xsl:if>
	</xsl:if>
-->
	</xsl:for-each>
</xsl:template>

<xsl:template name="VAR-INIT">
	<xsl:for-each select="//variables/item">
<!--
	<xsl:if test="normalize-space(@private)=''">
	<xsl:if test="normalize-space(@public)=''">
-->
	<xsl:if test="normalize-space(@type)!=''">
	<xsl:if test="normalize-space(@type)='int'">sk.<xsl:value-of select="@name"/> = uniset.InitInt32(cfg,"<xsl:value-of select="@name"/>","<xsl:value-of select="@default"/>")
	</xsl:if>
	<xsl:if test="normalize-space(@type)='long'">sk.<xsl:value-of select="@name"/> = uniset.InitInt64(cfg,"<xsl:value-of select="@name"/>","<xsl:value-of select="@default"/>")
	</xsl:if>
	<xsl:if test="normalize-space(@type)='float'">sk.<xsl:value-of select="@name"/> = uniset.InitFloat32(cfg,"<xsl:value-of select="@name"/>","<xsl:value-of select="@default"/>")
	</xsl:if>
	<xsl:if test="normalize-space(@type)='double'">sk.<xsl:value-of select="@name"/> = uniset.InitFloat64(cfg,"<xsl:value-of select="@name"/>","<xsl:value-of select="@default"/>")
	</xsl:if>
	<xsl:if test="normalize-space(@type)='bool'">sk.<xsl:value-of select="@name"/> = uniset.InitBool(cfg,"<xsl:value-of select="@name"/>","<xsl:value-of select="@default"/>")
	</xsl:if>
	<xsl:if test="normalize-space(@type)='str'">sk.<xsl:value-of select="@name"/> = uniset.InitString(cfg,"<xsl:value-of select="@name"/>","<xsl:value-of select="@default"/>")
	</xsl:if>
	<xsl:if test="normalize-space(@type)='sensor'">sk.<xsl:value-of select="@name"/> = uniset.InitSensorID(cfg,"<xsl:value-of select="@name"/>","<xsl:value-of select="@default"/>")
	</xsl:if>
	<xsl:if test="normalize-space(@type)='object'">sk.<xsl:value-of select="@name"/> = uniset.InitObjectID(cfg,"<xsl:value-of select="@name"/>","<xsl:value-of select="@default"/>")
	</xsl:if>
	</xsl:if>
<!--
	</xsl:if>
	</xsl:if>
-->
	</xsl:for-each>

</xsl:template>

<xsl:template name="IO-LIST">
	<xsl:for-each select="//smap/item"><xsl:if test="normalize-space(@vartype)='in'"><xsl:call-template name="setprefix"/><xsl:value-of select="@name"/> int64
	</xsl:if>
	<xsl:if test="normalize-space(@vartype)='out'"><xsl:call-template name="setprefix"/><xsl:value-of select="@name"/> int64
	</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template name="ID-LIST">
	<xsl:for-each select="//smap/item"><xsl:value-of select="@name"/> uniset.SensorID
	</xsl:for-each>
</xsl:template>

<xsl:template name="ID-INIT">
	<xsl:for-each select="//smap/item">sk.<xsl:value-of select="@name"/> = uniset.InitSensorID(cfg,"<xsl:value-of select="@name"/>","<xsl:value-of select="@default"/>")
	</xsl:for-each>
</xsl:template>

<xsl:template name="INS-INIT">
	sk.ins = []*uniset.Int64Value {
	<xsl:for-each select="//smap/item">
	<xsl:if test="normalize-space(@vartype)='in'">uniset.NewInt64Value(&amp;sk.<xsl:value-of select="@name"/>,&amp;sk.<xsl:call-template name="setprefix"/><xsl:value-of select="@name"/>),
	</xsl:if>
	</xsl:for-each>}
</xsl:template>
<xsl:template name="OUTS-INIT">
	sk.outs = []*uniset.Int64Value {
	<xsl:for-each select="//smap/item">
	<xsl:if test="normalize-space(@vartype)='out'">uniset.NewInt64Value(&amp;sk.<xsl:value-of select="@name"/>,&amp;sk.<xsl:call-template name="setprefix"/><xsl:value-of select="@name"/>),
	</xsl:if>
	</xsl:for-each>}
</xsl:template>

</xsl:stylesheet>