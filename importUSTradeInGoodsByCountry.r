username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- 'country.xlsx'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(url = paste0('https://www.census.gov/foreign-trade/balance/',fileName),
                destfile = fileName,
                mode = 'wb')
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

# - https://www.census.gov/foreign-trade/data/index.html
# - https://www.census.gov/foreign-trade/statistics/historical/index.html
# - https://www.census.gov/foreign-trade/balance/index.html
# - https://www.census.gov/foreign-trade/statistics/country/index.html
