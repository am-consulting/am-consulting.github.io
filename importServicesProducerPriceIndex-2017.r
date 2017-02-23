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
