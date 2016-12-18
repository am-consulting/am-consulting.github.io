importOECDStatisticData <-
  function(sdmxURL){
    library(countrycode);library(rsdmx)
    # mm <- 10
    # sdmxURL <- paste0("http://stats.oecd.org/restsdmx/sdmx.ashx/GetData/MEI_CLI/LOLITOAA.AUS+AUT+BEL+CAN+CHL+CZE+DNK+EST+FIN+FRA+DEU+GRC+HUN+IRL+ISR+ITA+JPN+KOR+LVA+LUX+MEX+NLD+NZL+NOR+POL+PRT+SVK+SVN+ESP+SWE+CHE+TUR+GBR+USA+EA19+G4E+G-7+NAFTA+OECDE+OECD+ONM+A5M+NMEC+BRA+CHN+IND+IDN+RUS+ZAF.M/all?startTime=1947-02&endTime=2016-",mm)
    # Composite Leading Indicators (MEI)
    OECDdataSet0 <- readSDMX(sdmxURL)
    OECDdataSet0 <- as.data.frame(OECDdataSet0)
    OECDdataSet <- OECDdataSet0
    unique(OECDdataSet$SUBJECT)
    unique(OECDdataSet$LOCATION)
    unique(OECDdataSet$FREQUENCY)
    unique(OECDdataSet$TIME_FORMAT)
    unique(OECDdataSet$UNIT)
    unique(OECDdataSet$POWERCODE)
    unique(OECDdataSet$obsTime)
    naR <- which(is.na(countrycode(OECDdataSet$LOCATION, 'iso3c', 'country.name')))
    OECDdataSet$LOCATION[-naR] <-
      paste0(countrycode(OECDdataSet$LOCATION[-naR], 'iso3c', 'country.name'),':',OECDdataSet$LOCATION[-naR])
    OECDdataSet$obsTime <- as.Date(paste0(OECDdataSet$obsTime,'-1'))
    countryList <- unique(OECDdataSet$LOCATION)
    for(iii in  1:length(countryList)){
      buf <- subset(OECDdataSet,OECDdataSet$LOCATION == countryList[iii])
      buf <- buf[,grep('obstime|obsvalue',colnames(buf),ignore.case = T)]
      colnames(buf)[grep('value', colnames(buf), ignore.case = T)] <- countryList[iii]
      if(iii == 1){allData <- buf}else{allData <- merge(allData,buf,by = 'obsTime',all = T )}
    }
    colnames(allData)[1] <- 'Date'
    assign('allOECDData',allData,envir = .GlobalEnv)
    }
