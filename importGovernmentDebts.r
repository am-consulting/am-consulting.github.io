library(Nippon);library(lubridate)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <-
  'suii.xls'
baseURL <-
  'http://www.mof.go.jp/jgbs/reference/gbb/'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(url = paste0(baseURL,fileName),
                destfile = fileName,
                mode = 'wb')
}
buf0 <-
  XLConnect::readWorksheetFromFile(file = paste0(pathOutput, fileName),
                                   sheet = 1,
                                   check.names = F,
                                   header = F)
buf1 <- t(buf0)
sheetTitle <-
  zen2han(buf1[1,1])
sheetUnit <-
  zen2han(buf1[23,2])
tmpColumn <- grep('^借入金',gsub('\\s','',buf1[1,]))
tmp <- NA
for(ccc in 1:ncol(buf1)){
  if(!is.na(buf1[1,ccc])){tmp <- buf1[1,ccc]}
  buf1[1,ccc] <- tmp
}
tmp <- NA
for(ccc in 1:ncol(buf1)){
  if(tmpColumn <= ccc){break}
  if(!is.na(buf1[2,ccc])){tmp <- buf1[2,ccc]}
  buf1[2,ccc] <- tmp
}
colnames(buf1) <-
  sapply(gsub('\\s','',paste0(buf1[1,],':',buf1[2,],':',buf1[3,])),zen2han)
buf2 <- buf1[-c(1:3),-c(1:2)]
objColumn <-
  grep('末',buf2[1,])
buf2 <-
  buf2[,-objColumn[2]]
buf2[,-1] <-
  apply(buf2[,-1],2,function(x)as.numeric(gsub(',|\\(|\\)|－','',x)))
buf3 <-
  buf2[,apply(buf2,2,function(x)sum(is.na(x)) != nrow(buf2))]
yyyy <-
  as.numeric(substring(text = buf3[,1],first = 2,last = 3)) + 1988
mm <-
  as.numeric(gsub('.+\\.([0-9]+)末','\\1',buf3[,1]))
Date <-
  as.Date(paste0(yyyy,'-',mm,'-1')) %m+% months(1) - 1
buf4 <-
  data.frame(Date,
             buf3[,-1],
             stringsAsFactors = F,
             check.names = F,
             row.names = NULL)
colnames(buf4) <-
  gsub(':na','',colnames(buf4),ignore.case = T)
buf4[,-1] <-
  apply(buf4[,-1],2,as.numeric)
assign('GovernmentDebts',buf4,envir = .GlobalEnv)
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = buf4,dataType = 1,csvFileName = '国債及び借入金並びに政府保証債務現在高(億円)')
# csv出力パート
