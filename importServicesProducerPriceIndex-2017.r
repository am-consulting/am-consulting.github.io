library(Nippon)
fileName <-
  'pr02_m_1.csv'
bojURL <-
  'http://www.stat-search.boj.or.jp/ssi/mtshtml/csv/'
buf0 <-
  read.csv(paste0(bojURL, fileName), check.names = F, header = F, stringsAsFactors = F,as.is = T)
colnames(buf0) <-
  gsub('\\s', '', sapply(paste0(buf0[3,], ':', buf0[4,], '(', buf0[6,], ')'), zen2han))
buf1 <- buf0[-c(1:9),]
buf1[,1] <-
  as.Date(paste0(substring(buf1[,1], 1, 4),'-',substring(buf1[,1], 6),'-1'))
colnames(buf1)[1] <-
  'Date'
buf1[,-1] <-
  apply(buf1[,-1], 2, as.numeric)
ServicesProducerPriceIndex <- buf1
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = ServicesProducerPriceIndex,dataType = 1,
                     csvFileName = '企業向けサービス価格指数')
# csv出力パート
