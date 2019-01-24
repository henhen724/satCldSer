
@echo off \

set WCT_HOME=%~dp0 \

java -mx3500m -Djava.awt.headless=true -classpath "%WCT_HOME%dist\wct-4.2.1.jar" gov.noaa.ncdc.wct.export.WCTExportBatch %* \
		