# http://www.senkyo.metro.tokyo.jp/election/togikai-all/togikai-sokuhou2017/
library(XLConnect)
pathOutput <-
  paste0("C:/Users/",Sys.info()['user'],"/Desktop/R_Data_Write/")
setwd(pathOutput)
xlsURL <-
  'http://www.senkyo.metro.tokyo.jp/uploads/h29togi_kaihyou_touhabetsutokuhyouritsu-1.xls'
xlsFile <-
  gsub('.+/(.+)','\\1',xlsURL)
download.file(url = xlsURL,xlsFile,mode = 'wb')
sheetName <-
  getSheets(loadWorkbook(xlsFile))
buf0 <-
  readWorksheetFromFile(paste0(pathOutput,xlsFile),sheet = 1,check.names = F,header = F)
tmp <- NA
for(ccc in 1:ncol(buf0)){
  if(!is.na(buf0[5,ccc])){tmp <- buf0[5,ccc]}
  buf0[5,ccc] <- tmp
}
colnames(buf0) <-
  sapply(gsub('\\s','',paste0(buf0[5,],':',buf0[6,])),Nippon::zen2han)
buf1 <- buf0[-c(1:6),]
buf1[,-1] <-
  apply(buf1[,-1],2,function(x)as.numeric(gsub(',','',x)))
buf1[,1] <- sapply(gsub('\\s','',buf1[,1]),Nippon::zen2han)
row.names(buf1) <- NULL
colnames(buf1)[1] <- 'Area'
share <- buf1
votes <- share[,c(1,grep(':票数',colnames(share)))]
ratio <- share[,c(1,grep(':率',colnames(share)))]
votes <- votes[,-tail(grep('無所属',colnames(votes)),1)]
ratio <- ratio[,-tail(grep('無所属',colnames(ratio)),1)]
