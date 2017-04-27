library(Nippon)
historicalFXDataURL <-
  'https://www.mizuhobank.co.jp/rate/market/csv/quote.csv'
historicalFXData0 <-
  read.csv(file = historicalFXDataURL,header = F,
           quote = "\"",na.strings = c('','*****'),check.names = F,stringsAsFactors = F,skip = 1)
colnames(historicalFXData0) <-
  sapply(paste0(historicalFXData0[1,],':',historicalFXData0[2,]),zen2han)
historicalFXData0 <- historicalFXData0[-c(1:2),]
historicalFXData <-
  data.frame(Date=as.Date(historicalFXData0[,1]),
             apply(historicalFXData0[,-1],2,as.numeric),
             stringsAsFactors = F,check.names = F,row.names = NULL)
colnames(historicalFXData)[-1] <- colnames(historicalFXData0)[-1]
