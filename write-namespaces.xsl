<!--
Copyright (c) 2020, ivan386
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of ivan386 nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="write-namespaces">
		<xsl:apply-templates select=".|@*" mode="write-namespaces"/>
	</xsl:template>

	<xsl:template match="*" mode="write-namespaces">
		<xsl:if test="namespace-uri()">
			<xsl:call-template name="test-ancestor"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@*" mode="write-namespaces">
		<xsl:choose>
			<xsl:when test="not(namespace-uri())" />
			<xsl:when test="substring-before(name(), ':')=substring-before(name(..), ':')" />
			<xsl:when test="../@*[substring-before(name(), ':')][1] != current()" />
			<xsl:otherwise>
				<xsl:call-template name="test-ancestor"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="test-ancestor">
		<xsl:choose>
			<xsl:when test="(ancestor::* | ancestor-or-self::*/../@*)
				[substring-before(name(), ':') = substring-before(name(current()), ':')]
				[last()]
				[namespace-uri() = namespace-uri(current())]"/>
			<xsl:otherwise>
				<xsl:call-template name="write-namespace">
					<xsl:with-param name="prefix" select="substring-before(name(), ':')"/>
					<xsl:with-param name="uri" select="namespace-uri()"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>