username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- 'country.xlsx'
if(!file.exists(paste0(pathOutput, fileName))) {
  # download.file(url = paste0('https://www.census.gov/foreign-trade/balance/',fileName),
  #               destfile = fileName,
  #               mode = 'wb')
  # https://yokekeong.com/download-files-over-https-in-r-with-httr/
  library(httr)
  GET(url = paste0('https://www.census.gov/foreign-trade/balance/',fileName),
      write_disk(fileName, overwrite=T))
}
sheetNo <- 1
buf0 <-
  XLConnect::readWorksheetFromFile(file = paste0(pathOutput, fileName),
                                   sheet = sheetNo,
                                   check.names = F,
                                   header = T)
buf0 <-
  buf0[-which(buf0[,1]==''),]
bufImport <-
  buf0[,c(1:3,grep('^i[a-z]+',colnames(buf0),ignore.case = T))]
bufExport <-
  buf0[,c(1:3,grep('^e[a-z]+',colnames(buf0),ignore.case = T))]
fun_creatTSDF <- function(iii,buf,countryS){
  tmp0 <-
    subset(buf,buf$CTYNAME==countryS[iii])
  tmp1 <-
    tmp0[,c(grep('year',colnames(tmp0),ignore.case = T),
            grep('jan',colnames(tmp0),ignore.case = T):grep('dec',colnames(tmp0),ignore.case = T))]
  bufValue <-
    as.vector(t(tmp1[,-1]))
  bufDate <-
    seq(as.Date(paste0(tmp1[1,1],'-1-1')),by = '+1 month',length.out = nrow(tmp1) * 12)
  tmp2 <<-
    data.frame(bufDate,bufValue,stringsAsFactors = F)
}
exportData <- importData <- TradeInGoodsByCountry <- list()
# import
buf <- bufImport
countryS <-
  unique(buf$CTYNAME)
for(iii in seq(length(countryS))){
  fun_creatTSDF(iii = iii,buf = buf,countryS = countryS)
  colnames(tmp2) <- c('Date',paste0(countryS[iii],':Import'))
  print(tail(tmp2))
  importData[[iii]] <- tmp2
}
# export
buf <- bufExport
countryS <-
  unique(buf$CTYNAME)
for(iii in seq(length(countryS))){
  fun_creatTSDF(iii = iii,buf = buf,countryS = countryS)
  colnames(tmp2) <- c('Date',paste0(countryS[iii],':Export'))
  print(tail(tmp2))
  exportData[[iii]] <- tmp2
}
# merge
for(iii in seq(length(countryS))){
  TradeInGoodsByCountry[[iii]] <-
    merge(importData[[iii]],exportData[[iii]],by='Date',all=T)
  print(tail(TradeInGoodsByCountry[[iii]],3))
}
# omit blank data
objCountry <-
  grep('japan',countryS,ignore.case = T)
endDate <-
  tail(TradeInGoodsByCountry[[objCountry]][TradeInGoodsByCountry[[objCountry]][,2]!=0,],1)[,1]
for(iii in seq(length(countryS))){
  TradeInGoodsByCountry[[iii]] <-
    subset(TradeInGoodsByCountry[[iii]], TradeInGoodsByCountry[[iii]][,1] <= endDate)
  TradeInGoodsByCountry[[iii]]$Balance <-
    TradeInGoodsByCountry[[iii]][,3] - TradeInGoodsByCountry[[iii]][,2]
  colnames(TradeInGoodsByCountry[[iii]])[4] <-
    paste0(gsub('(.+):.+','\\1',colnames(TradeInGoodsByCountry[[iii]])[2]),':Balance(E-I)')
  print(tail(TradeInGoodsByCountry[[iii]],3))
  if(iii == 1){
    grandData <- TradeInGoodsByCountry[[iii]]
  }else{
    grandData <- merge(grandData,TradeInGoodsByCountry[[iii]],by='Date',all=T)
  }
}
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = grandData,dataType = 1,csvFileName = 'USATradeInGoodsByCountry')
# csv出力パート

# - https://www.census.gov/foreign-trade/data/index.html
# - https://www.census.gov/foreign-trade/statistics/historical/index.html
# - https://www.census.gov/foreign-trade/balance/index.html
# - https://www.census.gov/foreign-trade/statistics/country/index.html
