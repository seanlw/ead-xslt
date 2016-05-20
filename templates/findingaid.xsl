<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:output method="html"
              encoding="UTF-8"
              indent="yes" />

  <xsl:template match="/*">
    <html>
      <head>
        <title><xsl:value-of select="ead:archdesc/ead:did/ead:unittitle" /></title>
        <link rel="icon" type="image/png" href="img/favicon.ico" />
        <link rel="stylesheet" href="css/font-awesome.min.css" />
        <link rel="stylesheet" href="css/bootstrap.css" />
        <link rel="stylesheet" href="css/findingaid.css" />
        <link rel="stylesheet" href="css/uh-webfonts.css" />
        <script src="js/jquery-1.12.3.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/findingaid.js"></script>
      </head>
      <body>
        <nav class="navbar navbar-uh">
          <div class="container-fluid">
            <div class="navbar-header">
              <a class="navbar-brand" href="#">
                <img alt="Brand" src="img/uhl_avatar.png" />
              </a>
              Finding Aids
            </div>
          </div>
        </nav>
        <div class="container-fluid">
          <div class="row">
            <div class="col-md-3">
              <div id="sidebar-menu" class="list-group">
                <a href="#overview" class="list-group-item active">Overview</a>
                <a href="#scope" class="list-group-item">Scope and Contents</a>
                <a href="#subjects" class="list-group-item">Subject/Index Terms</a>
                <a href="#administrative" class="list-group-item">Administrative Information</a>
                <a href="#listings" class="list-group-item">Box and Folder Listing</a>
              </div>
            </div>
            <div class="col-md-9">
              <!-- OVERVIEW -->
              <xsl:apply-templates select="ead:archdesc/ead:did" />
              <!-- SCOPE AND CONTENTS -->
              <xsl:apply-templates select="ead:archdesc/ead:scopecontent" />
              <!-- TERMS AND ADMINISTRATIVE INFORMATION -->
              <xsl:apply-templates select="ead:archdesc" />
              <!-- BOX/FOLDER LISTING -->
              <xsl:apply-templates select="ead:archdesc/ead:dsc" />
            </div>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- OVERVIEW -->
  <xsl:template match="ead:archdesc/ead:did">
    <h1><xsl:value-of select="ead:unittitle" />, <xsl:value-of select="ead:unitdate" /></h1>
    <div id="overview" class="panel panel-info">
      <div class="panel-heading">
        <h2 class="panel-title">Overview</h2>
      </div>
      <div class="panel-body">
        <p><span class="bold">Title: </span><xsl:value-of select="ead:unittitle" /></p>
        <p><span class="bold">ID: </span><xsl:value-of select="ead:unitid" /></p>
        <p><span class="bold">Primary Creator: </span><xsl:value-of select="ead:origination[@label='creator']/ead:corpname" /></p>
        <p><span class="bold">Extent: </span><xsl:value-of select=".//ead:extent" /></p>
        <p><span class="bold">Subjects: </span>
          <xsl:for-each select="../ead:controlaccess/*[@source='local']">
            "<xsl:value-of select="." />"
            <xsl:if test="position() &lt; last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </p>
        <p><span class="bold">Forms of Material: </span>
          <xsl:for-each select="../ead:controlaccess/ead:genreform">
            <xsl:value-of select="." />
            <xsl:if test="position() &lt; last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </p>
        <p><span class="bold">Languages: </span>
          <xsl:for-each select="ead:langmaterial/ead:language ">
            <xsl:value-of select="." />
            <xsl:if test="position() &lt; last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </p>
      </div>
    </div>
  </xsl:template>

  <!-- SCOPE AND CONTENTS -->
  <xsl:template match="ead:archdesc/ead:scopecontent">
    <div id="scope" class="panel panel-default">
      <div class="panel-heading">
        <h2 class="panel-title"><xsl:value-of select="ead:head" /></h2>
      </div>
      <div class="panel-body">
        <xsl:value-of select="ead:p" />
      </div>
    </div>
  </xsl:template>

  <!-- TERMS AND ADMINISTRATIVE INFORMATION -->
  <xsl:template match="ead:archdesc">
    <div id="subjects" class="panel panel-default">
      <div class="panel-heading">
        <h2 class="panel-title">Subject/Index Terms</h2>
      </div>
      <div class="panel-body">
        <ul>
          <xsl:for-each select="ead:controlaccess/*[@source='local']">
            <li><xsl:value-of select="." /></li>
          </xsl:for-each>
        </ul>
      </div>
    </div>
    <div id="administrative" class="panel panel-default">
      <div class="panel-heading">
        <h2 class="panel-title">Administrative Information</h2>
      </div>
      <div class="panel-body">
        <p><span class="bold">Repository: </span><xsl:value-of select="ead:did/ead:repository/ead:corpname" /></p>
        <p>
          <span class="bold"><xsl:value-of select="ead:accessrestrict/ead:head" />: </span>
          <xsl:value-of select="ead:accessrestrict/ead:p" />
        </p>
        <p>
          <span class="bold"><xsl:value-of select="ead:userestrict/ead:head" />: </span>
          <xsl:value-of select="ead:userestrict/ead:p" />
        </p>
        <p><span class="bold">Acquisition Method: </span><xsl:value-of select="ead:acqinfo/ead:p" /></p>
        <p><span class="bold">Preferred Citation: </span><xsl:value-of select="ead:prefercite/ead:p" /></p>
        <p><span class="bold">Processing Information: </span><xsl:value-of select="ead:processinfo/ead:p" /></p>
        <p><span class="bold">Other Note: </span><xsl:value-of select="ead:odd/ead:p" /></p>
      </div>
    </div>
  </xsl:template>

  <!-- BOX/FOLDER LISTING -->
  <xsl:template match="ead:archdesc/ead:dsc">
    <div id="listings" class="panel panel-warning">
      <div class="panel-heading">
        <h2 class="panel-title">Box and Folder Listing</h2>
      </div>
      <div class="panel-body">
        <xsl:choose>
          <xsl:when test="ead:c[@level='series']">  
            <xsl:apply-templates select="ead:c[@level='series']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="ead:c[@level='file' or @level='item']" />
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </div>
  </xsl:template>

  <!-- SERIES LEVEL -->
  <xsl:template match="ead:c[@level='series']">
    <xsl:for-each select=".">
      <ul class="series">
        <li>
          <xsl:value-of select="ead:did/ead:unitid" />: <xsl:value-of select="ead:did/ead:unittitle" />
          <xsl:if test="ead:did/ead:unitdate">
            <xsl:text>, </xsl:text><xsl:value-of select="ead:did/ead:unitdate" />
          </xsl:if>
          <div class="desc"><xsl:value-of select="ead:scopecontent/ead:p" /></div>
          <xsl:apply-templates select="ead:c[@level='subseries']" />
          <xsl:apply-templates select="ead:c[@level='file' or @level='item']" />
        </li>
      </ul>
    </xsl:for-each>
  </xsl:template>

  <!-- SUB-SERIES LEVEL -->
  <xsl:template match="ead:c[@level='subseries']">
    <xsl:for-each select=".">
      <ul class="subseries">
        <li>
          <xsl:value-of select="ead:did/ead:unitid" />: <xsl:value-of select="ead:did/ead:unittitle" />
          <xsl:if test="ead:did/ead:unitdate">
            <xsl:text>, </xsl:text><xsl:value-of select="ead:did/ead:unitdate" />
          </xsl:if>
          <div class="desc"><xsl:value-of select="ead:scopecontent/ead:p" /></div>
          <xsl:apply-templates select="ead:c[@level='subseries']" />
          <xsl:apply-templates select="ead:c[@level='file' or @level='item']" />
        </li>
      </ul>
    </xsl:for-each>
  </xsl:template>

  <!-- BOX LEVEL -->
  <xsl:template match="ead:c[@level='file' or @level='item']">
    <xsl:for-each select=".">
      <xsl:variable name="lastbox">
        <xsl:value-of select="preceding-sibling::ead:c[1]/ead:did/ead:container/@type" />
        <xsl:value-of select="preceding-sibling::ead:c[1]/ead:did/ead:container[@type='box' or @type='ovs_box']" />
      </xsl:variable>
        <xsl:variable name="btestbox">
          <xsl:value-of select="ead:did/ead:container/@type" />
          <xsl:value-of select="ead:did/ead:container[@type='box' or @type='ovs_box']" />
        </xsl:variable>
        <xsl:if test="not($btestbox = $lastbox)">
          <xsl:variable name="currentbox">
            <xsl:value-of select="ead:did/ead:container/@type" />
            <xsl:value-of select="ead:did/ead:container[@type='box' or @type='ovs_box']" /> 
          </xsl:variable>
          <ul class="box">
            <li>
              <xsl:if test="ead:did/ead:container[@type='ovs_box']">
                OVS
              </xsl:if>
              Box <xsl:value-of select="ead:did/ead:container[@type='box' or @type='ovs_box']" />
              <ul class="folder">
                <xsl:for-each select="../ead:c[@level='file' or @level='item']">
                  <xsl:variable name="testbox">
                    <xsl:value-of select="ead:did/ead:container/@type" />
                    <xsl:value-of select="ead:did/ead:container[@type='box' or @type='ovs_box']" /> 
                  </xsl:variable>
                  <xsl:if test="$testbox = $currentbox">
                    <xsl:apply-templates select="ead:did" />
                  </xsl:if>
                </xsl:for-each>
              </ul>
            </li>
          </ul>
        </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- FOLDER LEVEL -->
  <xsl:template match="ead:did">
    <li>
      <xsl:value-of select="ead:unitid" />: <xsl:value-of select="ead:unittitle" />
      <xsl:if test="ead:unitdate">
        <xsl:text>, </xsl:text><xsl:value-of select="ead:unitdate" />
      </xsl:if>
      <xsl:if test="ead:dao/@xlink:href">
        <ul class="digital-objects">
        <xsl:for-each select="ead:dao">
          <li>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="./@xlink:href" />
            </xsl:attribute>
            <xsl:attribute name="class">digital-object-link</xsl:attribute>
            <i class="fa fa-picture-o" aria-hidden="true"></i><span class="small">View digital object</span>
          </xsl:element>
          </li>
        </xsl:for-each>
        </ul>
      </xsl:if>
      <xsl:if test="../ead:c[@level='item' or @level='file']">
        <ul class="folder">
          <xsl:for-each select="../ead:c[@level='file' or @level='item']">
            <xsl:apply-templates select="ead:did" />
          </xsl:for-each>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

</xsl:stylesheet>