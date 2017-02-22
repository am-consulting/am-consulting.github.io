library(Nippon)
fileName <-
  'ff_q_1.csv'
bojURL <-
  'http://www.stat-search.boj.or.jp/ssi/mtshtml/csv/'
buf0 <-
  read.csv(paste0(bojURL, fileName), check.names = F, header = F, stringsAsFactors = F,as.is = T)
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
  apply(buf1[,-1,drop = F], 2, as.numeric)
buf1$tmp <- buf1[,2]*10^-4
colnames(buf1)[ncol(buf1)] <-
  gsub('\\(億円\\)','\\(兆円\\)',colnames(buf1)[2])
HouseholdFinancialAsset  <- buf1
