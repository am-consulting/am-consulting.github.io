library(Nippon)
options(scipen = 999)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <-
  'VIdata.xlsx'
baseURL <-
  'http://www.iima.or.jp/Docs/ppp/index/'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(url = paste0(baseURL,fileName),
                destfile = fileName,
                mode = 'wb')
}
for(sss in 1:2){
  buf0 <-
    XLConnect::readWorksheetFromFile(file = paste0(pathOutput, fileName),
                                     sheet = sss,
                                     check.names = F,
                                     header = F)
  if(sss == 1){
    objColumn <-
      grep('\\bdate\\b',buf0[,1],ignore.case = T)
    colnames(buf0) <-
      buf0[objColumn,]
    buf1 <-
      buf0[-c(1:objColumn),]
    buf1[,1] <-
      as.Date(paste0(substring(buf1[,1],1,4),'-',
                     substring(buf1[,1],6,7),'-',
                     substring(buf1[,1],9,10)))
    colnames(buf1)[1] <- 'Date'
    buf2 <-
      buf1[,apply(buf1,2,function(x)sum(is.na(x))) < (nrow(buf1)-1)]
    buf2[,-1] <-
      apply(buf2[,-1],2,as.numeric)
    assign(paste0('GMVI',sss),buf2,envir = .GlobalEnv)
  }else{
    tmp <- NA
    for(ccc in 1:ncol(buf0)){
      if(!is.na(buf0[16,ccc])){tmp <- buf0[16,ccc]}
      buf0[16,ccc] <- tmp
    }
    colnames(buf0) <-
      paste0(buf0[16,],':',buf0[17,])
    buf1 <-
      buf0[!is.na(as.numeric(substring(buf0[,1],1,4))),]
    buf1[,1] <-
      as.Date(paste0(substring(buf1[,1],1,4),'-',
                     substring(buf1[,1],6,7),'-',
                     substring(buf1[,1],9,10)))
    colnames(buf1)[1] <- 'Date'
    buf2 <-
      buf1[,c(1:(grep('新興国',colnames(buf1))[1]-1))]
    buf2[,-1] <-
      apply(buf2[,-1],2,as.numeric)
    assign(paste0('GMVI',sss),buf2,envir = .GlobalEnv)
  }
}
