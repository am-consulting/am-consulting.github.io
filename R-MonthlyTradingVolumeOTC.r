fun_MonthlyTradingVolumeOTC <- function(sheetNo = 'USDJPY'){
library(Nippon)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <-
  'trading_vol_and_position.xls'
baseURL <-
  'http://www.ffaj.or.jp/performance/fx_flash_file/data/'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(url = paste0(baseURL,fileName),
                destfile = fileName,
                mode = 'wb')
}
buf0 <-
  XLConnect::readWorksheetFromFile(file = paste0(pathOutput, fileName),
                                   sheet = sheetNo,
                                   check.names = F,
                                   header = F)
sheetTitle <-
  gsub('\\s','',zen2han(paste0(buf0[1,1],':',buf0[4,1],':',buf0[7,1])))
tmp <- NA
for(ccc in 1:ncol(buf0)){
  if(!is.na(buf0[9,ccc])){tmp <- buf0[9,ccc]}
  buf0[9,ccc] <- tmp
}
colnames(buf0) <-
  gsub('::',':',gsub('\n|[a-z]|\\s','',paste0(buf0[9,],':',buf0[10,]),ignore.case = T))
colnames(buf0) <-
  paste0('通貨ペア:',sheetNo,':',colnames(buf0))
buf1 <-
  buf0[!is.na(as.numeric(buf0[,2])),]
buf1[,1] <-
  as.Date(paste0(buf1[,2],'-',buf1[,1],'-1'))
buf2 <-
  buf1[,-2]
colnames(buf2)[1] <- 'Date'
buf2[,-1] <- apply(buf2[,-1],2,function(x)as.numeric(gsub(',','',x)))
buf3 <-
  buf2[order(buf2[,1],decreasing = F),]
assign(sheetNo,buf3,envir = .GlobalEnv)
assign(paste0(sheetNo,'Title'),sheetTitle,envir = .GlobalEnv)
}
