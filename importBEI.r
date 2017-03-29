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
# plot(BEItable[,2],type='o',pch=20,cex=0.8,ylab=colnames(BEItable)[2])
script <-
  getURL(
    "https://raw.githubusercontent.com/am-consulting/Rscript/master/Rscript_JGBInterestRate.r",
    ssl.verifypeer = F
  )
eval(parse(text = script))
jgb10Y <- na.omit(jgbData[,c(1,grep('10y',colnames(jgbData),ignore.case = T))])
colnames(jgb10Y)[2] <- 'JGB:10Year'
library(lubridate)
mergeData0 <-
  data.frame(tail(subset(jgb10Y,jgb10Y[,1] <= (tail(BEItable[,1],1) %m+% months(1) -1)),nrow(BEItable)),
             BEItable,
             stringsAsFactors = F,check.names = F)
# 2016年4月分が11データセットしかないため国債データとのマージでは日付にズレが発生する。
mergeData <-
  subset(mergeData0,as.Date('2016-5-1') <= mergeData0[,1])
mergeData$Check <-
  ifelse(month(mergeData[,1]) == month(mergeData[,3]),0,10)
sum(mergeData$Check)
# ブレークイーブン･インフレ率(BEI)
# 10年利付国債複利利回り(名目イールド)(nominal yield)
# 10年物価連動国債複利利回り(実質イールド)(real yield)
