# http://www.boj.or.jp/research/research_data/cai/index.htm/
library(Nippon)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <-
  'cai.xlsx'
baseURL <-
  'http://www.boj.or.jp/research/research_data/cai/'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(url = paste0(baseURL,fileName),
                destfile = fileName,
                mode = 'wb')
}
sheetNo <- 1
buf0 <-
  XLConnect::readWorksheetFromFile(file = paste0(pathOutput, fileName),
                                   sheet = sheetNo,
                                   check.names = F,
                                   header = F)
colnames(buf0) <-
  paste0(buf0[2,],':',buf0[3,])
buf1 <-
  buf0[!is.na(as.numeric(substring(buf0[,1],1,4))),]
buf1[,1] <-
  as.Date(paste0(substring(buf1[,1],1,4),'-',substring(buf1[,1],6,7),'-',substring(buf1[,1],9,10)))
colnames(buf1)[1] <- 'Date'
buf1[,-1] <-
  apply(buf1[,-1],2,as.numeric)
assign('ConsumptionActivityIndex',buf1,envir = .GlobalEnv)
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = buf1,dataType = 1,csvFileName = '消費活動指数')
# csv出力パート
