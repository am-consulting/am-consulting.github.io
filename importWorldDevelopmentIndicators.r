options(scipen = 999)
pathOutput <-
  paste0("C:/Users/",Sys.info()['user'],"/Desktop/R_Data_Write/")
setwd(pathOutput)
getwd()
targetURL <-
  'https://github.com/am-consulting/am-consulting.github.io/blob/master/csv/WorldDevelopmentIndicators/Data_Extract_From_World_Development_Indicators.zip'
fileName <-
  gsub('.+/([^/]+)','\\1',targetURL)
download.file(url = targetURL,fileName,mode = 'wb')
unzip(fileName)
pathOutput <-
  paste0("C:/Users/",Sys.info()['user'],"/Desktop/R_Data_Write/",gsub('(.+)\\.zip','\\1',fileName))
setwd(pathOutput)
getwd()
buf0 <-
  read.csv(file = dir(pathOutput)[grep('data.csv',dir(pathOutput),ignore.case = T)],
           header = T,check.names = F,stringsAsFactors = F,fileEncoding = 'UTF-8-BOM')
buf1 <- buf0
objCol <-
  which(!is.na(as.numeric(substring(colnames(buf1),1,4))))
buf1[,objCol] <-
  apply(buf1[,objCol],2,as.numeric)
colnames(buf1)[objCol] <- as.numeric(substring(colnames(buf1)[objCol],1,4))
buf2 <-
  buf1[buf1$`Country Code`!='',]
WorldDevelopmentIndicators <- buf2
buf0 <-
  read.csv(file = dir(pathOutput)[-grep('data.csv',dir(pathOutput),ignore.case = T)],
           header = T,check.names = F,stringsAsFactors = F,fileEncoding = 'UTF-8-BOM')
WDI_Definition <- buf0
remove(buf0,buf1,buf2)
