library(Nippon)
urlToData <-
  'http://www.stat-search.boj.or.jp/ssi/mtshtml/csv/'
for(iii in 1:8){
  buf0 <-
    read.csv(file = paste0(urlToData,'co_q_',iii,'.csv'), check.names = F, header = F, stringsAsFactors = F)
  colnames(buf0) <-
    gsub('\\s', '', sapply(paste0(buf0[3,], ':', buf0[4,], '(', buf0[6,], ')'), zen2han))
  buf1 <- buf0[-c(1:9),]
  buf1[,1] <-
    as.Date(paste0(gsub('(.+)/.+','\\1', buf1[,1]),'-',gsub('.+/(.+)','\\1', buf1[,1]),'-1'))
  colnames(buf1)[1] <- 'Date'
  buf1[,-1] <-
    apply(buf1[,-1,drop = F], 2, as.numeric)
  assign(paste0('NICHIGINTANKAN_',iii),buf1)
}
