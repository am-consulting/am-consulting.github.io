# Source 日本相互証券株式会社 http://www.bb.jbts.co.jp/marketdata/marketdata05.html
library(RCurl)
chartData <-
  getURL('http://www.bb.jbts.co.jp/_graph/js/graph_bei.js', ssl.verifyhost=F, ssl.verifypeer=F)
data <-
  unlist(regmatches(chartData, gregexpr('\\{year.+?\\}', chartData, fixed = F)))
BEItable <- data.frame()
for(iii in seq(length(data))){
  date0 <-
    gsub('.+([0-9]{4}/[0-9]{2})','\\1',gsub('\"','',gsub('\\{(year:.+?),.+','\\1',data[iii],ignore.case = T)))
  date <-
    paste0(substring(date0,1,4),'-',substring(date0,6),'-1')
  bei <-
    as.numeric(gsub('bei:(.+)','\\1', gsub('.+?(bei.+?),.+','\\1',data[iii],ignore.case = T),ignore.case = T))
  nominalyield <-
    as.numeric(gsub('nominalyield:(.+)','\\1',
                    gsub('.+?(nominalyield.+?),.+','\\1',data[iii],ignore.case = T),ignore.case = T))
  realyield <-
    as.numeric(gsub('realyield:(.+)','\\1',
                    gsub('.+?(realyield.+?)}','\\1',data[iii],ignore.case = T),ignore.case = T))
  BEItable[iii,1] <- date
  BEItable[iii,2] <- realyield # graph.valueField = "realyield";　//値がことなっていたため　BEI→realyield
  BEItable[iii,3] <- nominalyield
  BEItable[iii,4] <- bei # graph.valueField = "BEI"; //値がことなっていたため　realyield→BEI
}
BEItable[,1] <- as.Date(BEItable[,1])
colnames(BEItable) <- c('Year/Month','BEI','Nominal Yield','Real Yield')
plot(BEItable[,2],type='o',pch=20,cex=0.8,ylab=colnames(BEItable)[2])
script <-
  getURL(
    "https://raw.githubusercontent.com/am-consulting/Rscript/master/Rscript_JGBInterestRate.r",
    ssl.verifypeer = F
  )
eval(parse(text = script))
jgb10Y <- na.omit(jgbData[,c(1,11)])
