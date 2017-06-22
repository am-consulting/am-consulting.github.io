library(XLConnect)
library(Nippon)
pathOutput <-
  paste0("C:/Users/",Sys.info()['user'],"/Desktop/R_Data_Write/")
setwd(pathOutput)
targetURL <-
  paste0('http://www.jsda.or.jp/shiryo/toukei/trr/files/trrts.xls')
fileName <-
  gsub('.+/([^/]+)','\\1',targetURL)
download.file(url = targetURL,fileName,mode = 'wb')
sheetName <-
  getSheets(loadWorkbook(fileName))
buf0 <-
  readWorksheetFromFile(paste0(pathOutput,fileName),sheet = 1,check.names = F,header = F)
buf1 <- buf0
tmp <- NA
for(ccc in 1:ncol(buf1)){
  if(!is.na(buf1[6,ccc])){tmp <- buf1[6,ccc]}
  buf1[6,ccc] <- tmp
}
buf2 <- buf1[!is.na(as.numeric(substring(buf1[,1],1,4))),]
colnames(buf2) <-
  sapply(paste0(buf1[6,],':',buf1[7,]),zen2han)
buf2[,1] <- as.Date(buf2[,1])
colnames(buf2)[1] <- 'Date'
buf2[,-1] <- apply(buf2[,-1],2,as.numeric)
row.names(buf2) <- NULL
TokyoRepoRate <- buf2
