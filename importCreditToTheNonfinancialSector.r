# 世界各国の非金融部門(政府,企業,家計)債務残高対国内総生産(GDP)比
# http://www.bis.org/statistics/totcredit.htm?m=6%7C326
# Private non-financial sector = Households and NPISHs + Non-financial corporations
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
baseURL <-
  'http://www.bis.org/statistics/totcredit/'
fileName <- 'totcredit.xlsx'
download.file(paste0(baseURL,fileName),fileName,mode = 'wb')
buf0 <-
  gdata::read.xls(xls = paste0(pathOutput, fileName),
                  sheet = 3,stringsAsFactors = F,header = F,check.names = F,na.strings = '')
buf1 <- buf0
buf1 <- buf1[,c(1,grep('per cent',buf1[2,],ignore.case = T))]
# buf1 <- buf1[,-grep('nominal',buf1[1,],ignore.case = T)]
objCol <-
  grep('Non financial sector|General government|Households and NPISHs|Non-financial corporations|Private non-financial sector',
       buf1[1,],ignore.case = T)
buf2 <- buf1[,c(1,objCol)]
colnames(buf2) <- paste0(buf2[1,],':',buf2[2,])
buf3 <- buf2[-c(1:grep('period',buf2[,1],ignore.case = T)),]
Date <- as.Date(gsub('([0-9]+)\\.([0-9]+)\\.([0-9]+)','\\3-\\2-\\1',buf3[,1]))
CreditToTheNonfinancialSector <-
  data.frame(Date,apply(buf3[,-1],2,as.numeric),stringsAsFactors = F,check.names = F,row.names = NULL)
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = CreditToTheNonfinancialSector,dataType = 1,
                     csvFileName = '世界各国の非金融部門債務残高対GDP比')
# csv出力パート
