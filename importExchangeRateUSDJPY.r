library(Nippon)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
urlToData <-
  'http://www.stat-search.boj.or.jp/ssi/mtshtml/csv/'
fileName <-
  'fm08_m_1.csv'
download.file(paste0(urlToData, fileName), fileName, mode = 'wb')
buf0 <-
  read.csv(paste0(pathOutput, fileName), check.names = F, header = F, stringsAsFactors = F)
colnames(buf0) <-
  gsub('\\s', '', sapply(paste0(buf0[3,], ':', buf0[4,], '(', buf0[6,], ')'), zen2han))
buf1 <- buf0[-c(1:9),]
buf1[,1] <-
  paste0(substring(buf1[,1], 1, 4),'-',substring(buf1[,1], 6),'-1')
buf1[,1] <-
  as.Date(buf1[,1])
colnames(buf1)[1] <-
  'Date'
buf1[,-1] <-
  apply(buf1[,-1], 2, as.numeric)
ExchangeRateUSDJPY <- buf1
