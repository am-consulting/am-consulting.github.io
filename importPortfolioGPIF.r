library(Nippon)
options(scipen = 999)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <-
  'unyoujoukyou_h28_14.xlsx'
baseURL <-
  'http://www.gpif.go.jp/operation/state/pdf/'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(url = paste0(baseURL,fileName),
                destfile = fileName,
                mode = 'wb')
}
for(sss in 2:5){
  buf0 <-
    XLConnect::readWorksheetFromFile(file = paste0(pathOutput, fileName),
                                     sheet = sss,
                                     check.names = F,
                                     header = F)
  objRow <-
    which(apply(buf0,1,function(x)length(grep('時点\\b',x))!=0))
  objColumn <-
    which(apply(buf0,2,function(x)length(grep('時点\\b',x))!=0))
  assign(paste0('sheetTitle',sss),
         zen2han(paste0(buf0[1,1],':',buf0[objRow,objColumn])),envir = .GlobalEnv)
  tmp <- NA
  for(ccc in 1:ncol(buf0)){
    if(!is.na(buf0[objRow+1,ccc])){tmp <- buf0[objRow+1,ccc]}
    buf0[objRow+1,ccc] <- tmp
  }
  colnames(buf0) <-
    gsub(':na','',paste0(buf0[objRow+1,],':',buf0[objRow+1+1,]),ignore.case = T)
  buf0[,1] <-
    sapply(buf0[,1],zen2han)
  buf1 <-
    buf0[!is.na(as.numeric(buf0[,1])),]
  objColumn <-
    c(1,grep('時価総額|数量',colnames(buf1)))
  buf1[,objColumn] <-
    apply(buf1[,objColumn,drop=F],2,function(x)as.numeric(gsub(',','',x)))
  assign(paste0('Portfolio',sss-1),buf1,envir = .GlobalEnv)
}
