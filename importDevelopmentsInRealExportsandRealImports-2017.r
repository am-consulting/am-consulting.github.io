# 日本銀行 実質輸出入の動向 2017年
library(Nippon);library(XLConnect)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
urlToData <-
  'http://www.boj.or.jp/research/research_data/reri/'
fileName <-
  'reri.xlsx'
download.file(paste0(urlToData, fileName), fileName, mode = 'wb')
# sheet1
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 1, check.names = F, header = F)
colnames(buf0) <-
  sapply(paste0(buf0[1,],':',buf0[2,]),zen2han)
buf0 <-
  buf0[-c(1:4),]
tmp0 <-
  which(apply(buf0,2,function(x){sum(is.na(x))}) == nrow(buf0))
tmp1 <-
  length(tmp0)
if(tmp1 != 0){
  buf0 <- buf0[,-tmp0]
}
colnames(buf0)[1] <-
  'Date'
buf0[,-1] <-
  apply(buf0[,-1],2,as.numeric)
buf0[,1] <-
  as.Date(buf0[,1],tz = 'Asia/Tokyo')
RealExportsAndRealImports01 <-
  buf0
# sheet1
# sheet2
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 2, check.names = F, header = F)
ccc <-
  grep('その他',buf0[2,])[1]
buf0[2,ccc] <-
  paste0(buf0[2,ccc],'国･地域')
colnames(buf0) <-
  sapply(paste0(buf0[1,],':',buf0[2,],':',buf0[3,]),zen2han)
buf0 <-
  buf0[-c(1:6),]
tmp0 <-
  which(apply(buf0,2,function(x){sum(is.na(x))}) == nrow(buf0))
tmp1 <-
  length(tmp0)
if(tmp1 != 0){
  buf0 <- buf0[,-tmp0]
}
if(!is.null(nrow(buf0))){
colnames(buf0)[1] <-
  'Date'
buf0[,-1] <-
  apply(buf0[,-1],2,as.numeric)
buf0[,1] <-
  as.Date(buf0[,1],tz = 'Asia/Tokyo')
colnames(buf0) <-
  gsub('NA:','',colnames(buf0))
RealExportsAndRealImports02 <-
  buf0
# sheet2
allData <-
  merge(RealExportsAndRealImports01,
        RealExportsAndRealImports02,
        by = 'Date',
        all = T)
write.table(allData, "clipboard-16384", sep = "\t", row.names = F, col.names = T, quote = F)
assign('developmentsInRealExportsAndRealImports',allData,envir = .GlobalEnv)
}else{
  assign('developmentsInRealExportsAndRealImports',RealExportsAndRealImports01,envir = .GlobalEnv)
}
