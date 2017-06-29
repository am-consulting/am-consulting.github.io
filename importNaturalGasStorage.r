# http://ir.eia.gov/ngs/ngs.html
library(XLConnect)
pathOutput <-
  paste0("C:/Users/",Sys.info()['user'],"/Desktop/R_Data_Write/")
setwd(pathOutput)
targetURL <-
  'http://ir.eia.gov/ngs/ngshistory.xls'
fileName <-
  gsub('.+/([^/]+)','\\1',targetURL)
download.file(url = targetURL,fileName,mode = 'wb')
sheetName <-
  getSheets(loadWorkbook(fileName))
buf0 <-
  readWorksheetFromFile(paste0(pathOutput,fileName),sheet = 1,check.names = F,header = F)
objRaw <-
  grep('^week ending$',buf0[,1],ignore.case = T)
buf1 <-
  buf0[(objRaw+1):nrow(buf0),]
colnames(buf1) <- buf0[objRaw,]
buf2 <- buf1[,-2]
buf2[,-1] <- apply(buf2[,-1],2,function(x)as.numeric(gsub(',','',x)))
buf2[,1] <- as.Date(buf2[,1])
NaturalGasStorage <- buf2
sheetUnit <-
  'billion cubic feet(Bcf)'
sheetTitle <-
  'Working gas in underground storage, Lower 48 states'
