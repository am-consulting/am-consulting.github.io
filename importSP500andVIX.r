library(quantmod)
tmp <-
  getSymbols(Symbols = '^GSPC',auto.assign = F)
SP500 <-
  data.frame(Date = index(tmp),tmp,stringsAsFactors = F,row.names = NULL)
colnames(SP500) <- gsub('gspc','S&P500',colnames(SP500),ignore.case = T)
tmp <-
  getSymbols(Symbols = '^VIX',auto.assign = F)
VIX <-
  data.frame(Date = index(tmp),tmp,stringsAsFactors = F,row.names = NULL)
