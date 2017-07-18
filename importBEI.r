# Source 日本相互証券株式会社 http://www.bb.jbts.co.jp/marketdata/marketdata05.html
library(lubridate)
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
script <-
  getURL(
    "https://raw.githubusercontent.com/am-consulting/Rscript/master/Rscript_JGBInterestRate.r",
    ssl.verifypeer = F
  )
eval(parse(text = script))
jgb10Y <- na.omit(jgbData[,c(1,grep('10y',colnames(jgbData),ignore.case = T))])
colnames(jgb10Y)[2] <- 'JGB:10Year'
origJGB10Y <- jgb10Y
# 検証Part
buf01 <-
  aggregate(x = list(BEI=BEItable$BEI),by = list(BEItable$`Year/Month`),length)
jgb10Y$YM <-
  as.Date(paste0(year(jgb10Y[,1]),'-',month(jgb10Y[,1]),'-1'))
jgb10Y <-
  jgb10Y[BEItable[1,1]<=jgb10Y$YM,]
buf02 <-
  aggregate(x = list(JGB10Year=jgb10Y$`JGB:10Year`),by = list(jgb10Y$YM),length)
buf02 <- head(buf02,-1)
compareDF <-
  merge(buf01,buf02)
compareDF$Diff <-
  compareDF[,2]-compareDF[,3]
print(compareDF)
# 検証の結果、日本相互証券データと国債利回りデータとの間には月毎のデータ数に差が見られる。
# よって日本相互証券データの日付(日(day))を国債利回りデータの日付から割り当てることは正確性を担保できない。
# 以降日本相互証券データの日付データの日(day)が確認できるようになるまで中止。
# 検証Part
# ブレークイーブン･インフレ率(BEI)
# 10年利付国債複利利回り(名目イールド)(nominal yield)
# 10年物価連動国債複利利回り(実質イールド)(real yield)
