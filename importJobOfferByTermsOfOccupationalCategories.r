fun_jobOffer <- function(dataID = '000031515544', sheetNo = 1){
  library(Nippon);library(lubridate);library(XLConnect)
  username <-
    Sys.info()['user']
  pathOutput <-
    paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
  setwd(pathOutput)
  baseURL <-
    'http://www.e-stat.go.jp/SG1/estat/Xlsdl.do?sinfid='
  download.file(paste0(baseURL, dataID), paste0(dataID,'.xls'), mode = 'wb')
  buf0 <-
    readWorksheetFromFile(paste0(pathOutput, paste0(dataID,'.xls')), sheet = sheetNo, check.names = F, header = F)
  assign('sheetTitle', zen2han(buf0[1,6]), envir = .GlobalEnv)
  buf1 <-
    buf0[-c(1:2),c(1,grep('月',buf0[3,]))]
  yyyy <-
    as.numeric(substring(buf1[1,2], 1,(regexpr('年', buf1[1,2])-1))) + 1988
  mm <-
    as.numeric(gsub('月', '', substring(buf1[1,2], regexpr('年', buf1[1,2]) + 1)))
  firstDate <-
    as.Date(paste0(yyyy,'-',mm,'-1'))
  buf1[1,] <-
    c('職種', as.character(seq(firstDate,by = '+1 month',length.out = ncol(buf1) -1)))
  tmp <- NA
  for(rrr in 1:nrow(buf1)){
    if(length(grep('\\s', substring(buf1[rrr,1],1,1)))==0){
      tmp <- buf1[rrr,1]
    }else{
      buf1[rrr,1] <- paste0(tmp,':',substring(buf1[rrr,1],2))
    }
  }
  buf2 <-
    buf1[apply(buf1,1,function(x)sum(is.na(x)))!=(ncol(buf1)-1),]
  buf3 <-
    t(buf2)
  colnames(buf3) <-
    buf3[1,]
  buf4 <- buf3[-1,]
  colnames(buf4)[1] <- 'Date'
  buf4[,-1] <-
    apply(buf4[,-1],2,function(x)as.numeric(gsub(',','',x)))
  tmp <-
    as.Date(buf4[,1])
  buf5 <-
    data.frame(Date = tmp, buf4[,-1], check.names = F, stringsAsFactors = F)
  assign('jobOffer', buf5, envir = .GlobalEnv)
}
