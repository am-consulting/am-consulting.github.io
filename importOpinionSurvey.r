# http://www.boj.or.jp/research/o_survey/index.htm/
library(Nippon)
fileURL <- c('http://www.boj.or.jp/research/o_survey/survey03.csv',
             'http://www.boj.or.jp/research/o_survey/survey04.csv')
fileCaution <- vector()
for(iii in seq(length(fileURL))){
  buf0 <-
    read.csv(file = fileURL[iii],header = F,stringsAsFactors = F)
  fileCaution[iii] <-
    paste0(sapply(buf0[grep('注[0-9]*?',buf0[,1])[-1],1],zen2han),collapse = '<br>')
  tmp <-
    sapply(gsub('月','',buf0[,1]),zen2han)
  dateColumn <-
    paste0(as.numeric(substring(tmp,1,4)),'-',as.numeric(substring(tmp,6)),'-1')
  buf1 <-
    buf0[,apply(buf0,2,function(x)sum(is.na(x)))!=nrow(buf0)]
  tmp <- NA
  for(ccc in 1:ncol(buf1)){
    if(!is.na(buf1[1,ccc]) & buf1[1,ccc]!=''){tmp <- buf1[1,ccc]}
    buf1[1,ccc] <- tmp
  }
  tmp <- NA
  for(ccc in 1:ncol(buf1)){
    if(!is.na(buf1[3,ccc]) & buf1[3,ccc]!=''){tmp <- buf1[3,ccc]}
    buf1[3,ccc] <- tmp
  }
  colnames(buf1) <-
    sapply(paste0(buf1[1,],':',buf1[3,],':',buf1[5,]),zen2han)
  buf2 <- buf1[,-c(1,2,4)]
  buf3 <-
    data.frame(dateColumn,buf2,check.names = F,stringsAsFactors = F)
  buf4 <-
    buf3[-grep('na',buf3[,1],ignore.case = T),]
  buf4[,1] <-
    as.Date(buf4[,1])
  buf4[,-c(1:2)] <-
    apply(buf4[,-c(1:2)],2,as.numeric)
  colnames(buf4)[1:2] <- c('Date','調査回')
  colnames(buf4) <-
    gsub('\\(注.*?\\)|<注.*?>|\\s','',colnames(buf4))
  print(colnames(buf4))
  assign(paste0('survey0',iii+2),buf4,envir = .GlobalEnv)
}
assign('fileCaution',fileCaution,envir = .GlobalEnv)
