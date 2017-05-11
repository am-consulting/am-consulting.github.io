# 貸出・預金動向(月次) 2017年
library(Nippon)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
urlToData <-
  'http://www.stat-search.boj.or.jp/ssi/mtshtml/csv/'
fileName <-
  'md13_m_1.csv'
download.file(paste0(urlToData, fileName), fileName, mode = 'wb')
buf0 <-
  read.csv(paste0(pathOutput, fileName), check.names = F, header = F, stringsAsFactors = F)
colnames(buf0) <-
  gsub('\\s', '', sapply(paste0(buf0[3,], ':', buf0[4,], '(', buf0[6,], ')'), zen2han))
buf1 <- buf0[-c(1:9),]
for(rrr in 1:nrow(buf1)){
  yyyy <-
    substring(buf1[rrr,1], 1, 4)
  mm <-
    substring(buf1[rrr,1], 6)
  buf1[rrr,1] <-
    paste0(yyyy, '-', mm, '-1')
}
buf1[,1] <-
  as.Date(buf1[,1])
colnames(buf1)[1] <-
  'Date'
buf1[,-1] <-
  apply(buf1[,-1], 2, as.numeric)
PrincipalFiguresOfFinancialInstitutions <- buf1
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = PrincipalFiguresOfFinancialInstitutions,
                     dataType = 1,
                     csvFileName = '貸出預金動向速報')
# csv出力パート
