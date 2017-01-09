fun_ForeignExchangeTurnover <-
  function(baseURL = 'http://www.bis.org/publ/', fileName = 'rpfx16fx_tables.xls', sheetNo = 3){
# http://www.bis.org/publ/rpfx16fx.pdf
# http://www.bis.org/publ/rpfx16.htm
# http://www.bis.org/publ/rpfx16fx_tables.xls
library(XLConnect)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
baseURL <-
  baseURL
fileName <-
  fileName
sheetNo <-
  sheetNo
download.file(paste0(baseURL, fileName), fileName, mode = 'wb')
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = sheetNo, check.names = F, header = F)
assign('sheetTitle01',
       buf0[2,1],
       envir = .GlobalEnv)
assign('sheetTitle02',
       buf0[3,1],
       envir = .GlobalEnv)
tmp <- NA
for(ccc in 1:ncol(buf0)){
  if(!is.na(buf0[4,ccc])){tmp <- buf0[4,ccc]}
  buf0[4,ccc] <- tmp
}
colnames(buf0) <-
  paste0(buf0[4,],'(',buf0[5,],')')
buf1 <-
  buf0[-c(1:5),]
colnames(buf1) <- gsub('\\(na\\)','',colnames(buf1),ignore.case = T)
buf1[,-1] <-
  apply(buf1[,-1], 2, function(x)as.numeric(gsub(',','',x)))
buf2 <-
  buf1[-which((ncol(buf1)-1) <= apply(buf1,1,function(x)sum(is.na(x)))),]
assign('OTC_ForeignExchangeTurnoverByCurrencyPair',
       buf2,
       envir = .GlobalEnv)
  }
