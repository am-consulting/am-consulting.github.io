options(scipen = 999)
pathOutput <-
  paste0("C:/Users/",Sys.info()['user'],"/Desktop/R_Data_Write/")
setwd(pathOutput)
getwd()
targetURL <-
  'https://github.com/am-consulting/am-consulting.github.io/blob/master/csv/WorldDevelopmentIndicators/Data_Extract_From_World_Development_Indicators.zip'
targetURL <-
  'https://github.com/am-consulting/am-consulting.github.io/raw/master/csv/WorldDevelopmentIndicators/Data_Extract_From_World_Development_Indicators.zip'
fileName <-
  gsub('.+/([^/]+)','\\1',targetURL)
if(!file.exists(fileName)){download.file(url = targetURL,fileName,mode = 'wb')}
unzip(fileName)
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
# https://stats.stackexchange.com/questions/16796/reading-only-two-out-of-three-columns-with-read-csv
objCSV <-
  dir(pathOutput)[grep('Source.csv',dir(pathOutput),ignore.case = T)]
objXLS <-
  gsub('\\.csv','\\.xls',objCSV)
# read.csv(header = T)では456行目迄しか読み込まれない。そのため不本意ながら手作業で一旦xlsとして保存する。
buf0 <-
  XLConnect::readWorksheetFromFile(file = objXLS,sheet = 1,check.names = F,header = T)
buf0[,4] <-
  gsub('NA','',paste0(buf0[,4],buf0[,5],buf0[,6],buf0[,7],buf0[,8],buf0[,9],buf0[,10],buf0[,11]))
buf1 <- buf0[,-c(5:11)]
WDI_Definition <- buf1
remove(buf0,buf1,buf2)
