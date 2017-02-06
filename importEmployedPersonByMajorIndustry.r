library(Nippon)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- 'lt01-c30.xls'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(url = paste0('http://www.stat.go.jp/data/roudou/longtime/zuhyou/',fileName),
                destfile = fileName,
                mode = 'wb')
}
sheetNo <- 1
buf0 <-
  XLConnect::readWorksheetFromFile(file = paste0(pathOutput, fileName),
                                   sheet = sheetNo,
                                   check.names = F,
                                   header = F)
startYear <-
  as.numeric(gsub('平成(.+)年','\\1',buf0[grep('^平成[0-9]+年$',buf0[,1])[1],1]))+1988
startMonth <-
  as.numeric(gsub('(.+)月','\\1',buf0[grep('[0-9]+月',buf0[,2])[1],2]))
date <-
  seq(as.Date(paste0(startYear,'-',startMonth,'-1')),
      by='+1 month',
      length.out = length(grep('[0-9]+月',buf0[,2])))
figureDF <-
  buf0[grep('[0-9]+月',buf0[,2]),]
tmp <- NA
for(ccc in 1:ncol(buf0)){
  if(!is.na(buf0[6,ccc])){
    if(gsub('\\s','',buf0[6,ccc])!=''){
      tmp <- buf0[6,ccc]
    }
  }
  buf0[6,ccc] <- tmp
}
colnames(figureDF) <-
  sapply(gsub(':na','',paste0(buf0[6,],':',buf0[7,],':',buf0[8,]),ignore.case = T),zen2han)
buf1 <-
  data.frame(Date=date,
             figureDF[,grep('総数',colnames(figureDF)):ncol(figureDF)],check.names = F,stringsAsFactors = F)
buf1[,-1] <-
  apply(buf1[,-1],2,function(x)as.numeric(gsub('<|>|\\(|\\)','',x)))
assign('EmployedPersonByMajorIndustry',buf1,envir = .GlobalEnv)
sheetTtile <- zen2han(buf0[1,5])
figureType <- zen2han(buf0[4,5])
figureUnit <- zen2han(gsub('[a-z]|\\s','',buf0[5,5],ignore.case = T))
