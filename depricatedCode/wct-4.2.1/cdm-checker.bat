
@echo off
java -mx3500m -classpath dist\wct-4.2.1.jar gov.noaa.ncdc.wct.decoders.cdm.CheckCDMFeatureType %*
        