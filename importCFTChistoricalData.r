fun_CFTChistoricalData <- function(target = 'deacot',objLast = 1,objFirst = 6){
# fut_disagg_txt:Disaggregated Futures Only Reports
# com_disagg_txt:Disaggregated Futures-and-Options Combined Reports
# fut_fin_txt:raders in Financial Futures ; Futures Only Reports
# com_fin_txt:Traders in Financial Futures ; Futures-and-Options Combined Reports
# deacot:Futures Only Reports
# deahistfo:Futures-and-Options Combined Reports
# dea_cit_txt:Commodity Index Trader Supplement
library(rvest)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
targetURL <-
  'http://www.cftc.gov/MarketReports/CommitmentsofTraders/HistoricalCompressed/index.htm'
htmlMarkup <-
  read_html(x = targetURL,encoding = 'UTF-8')
hrefS <-
  htmlMarkup %>% html_nodes('a') %>% html_attr('href')
zipFiles <-
  hrefS[grep('\\/history\\/',hrefS)]
txtFiles <- zipFiles[-grep('xls',zipFiles)]
targetFiles <- txtFiles[grep(target,txtFiles)]
targetZIPFiles <- gsub('\\.\\.\\/','',targetFiles)
baseURL <- 'http://www.cftc.gov/'
for(iii in objLast:objFirst){
  fileName <- gsub('.+/([^\\/]+)','\\1',targetZIPFiles[iii])
  download.file(paste0(baseURL,targetZIPFiles[iii]),fileName,mode = 'wb')
  tmp0 <-
    read.table(unzip(fileName),sep = ',',header = T,as.is = T,check.names = F,stringsAsFactors = F)
  if(iii==1){cftcData <- tmp0}else{cftcData <- rbind(cftcData,tmp0)}
}
cftcData[,1] <- gsub('\\s$','',cftcData[,1])
MarketNames <- unique(cftcData[,1])
CFTCMarketData <- list()
for(mmm in seq(length(MarketNames))){
  buf0 <- subset(cftcData,MarketNames[mmm]==cftcData[,1])
  objCol <- grep('yyyy-mm-dd',colnames(buf0),ignore.case = T)
  Date <- as.Date(buf0[,objCol])
  objCol <- grep('units',colnames(buf0),ignore.case = T)
  Unit <- buf0[,objCol]
  objCol <-
    grep('^(Commercial|Noncommercial).+(long|short).+(all)',colnames(buf0),ignore.case = T)
  objDF0 <-
    data.frame(Date,buf0[,objCol],Unit,check.names = F,stringsAsFactors = F,row.names = NULL)
  objDF <- objDF0[order(objDF0[,1]),]
  colLong <-
    grep('noncommercial.+long.+',colnames(objDF),ignore.case = T)
  colShort <-
    grep('noncommercial.+short.+',colnames(objDF),ignore.case = T)
  objDF$`Noncommercial Positions-Net (All)` <- objDF[,colLong]-objDF[,colShort]
  colLong <-
    grep('^commercial.+long.+',colnames(objDF),ignore.case = T)
  colShort <-
    grep('^commercial.+short.+',colnames(objDF),ignore.case = T)
  objDF$`Commercial Positions-Net (All)` <- objDF[,colLong]-objDF[,colShort]
  objDF$Name <- MarketNames[mmm]
  CFTCMarketData[[mmm]] <- objDF
  print(tail(CFTCMarketData[[mmm]],1))
}
  return(CFTCMarketData)
}
