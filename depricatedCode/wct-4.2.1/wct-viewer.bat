
@echo off \

java -mx3500m -Dsun.java2d.d3d=false -Dsun.java2d.dpiaware=false -Djava.awt.headless=false -classpath dist\wct-4.2.1.jar;lib\swt\swt-3.7M6-win32-win32-x86.jar gov.noaa.ncdc.wct.ui.WCTViewerSplash %* \
		