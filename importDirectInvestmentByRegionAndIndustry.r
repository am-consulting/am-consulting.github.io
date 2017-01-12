library(XLConnect);library(Nippon)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileURL <-
  'http://www.boj.or.jp/statistics/br/bop_06/dii163q.xlsx'
fileName <-
  'DirectInvestmentByRegionAndIndustry.xlsx'
download.file(fileURL, fileName, mode = 'wb')
for(sheetNo in 1:4){
  assign(paste0('DirectInvestmentByRegionAndIndustry',sheetNo),
         readWorksheetFromFile(paste0(pathOutput, fileName), sheet = sheetNo, check.names = F, header = F))
}
dataSet <- DirectInvestmentByRegionAndIndustry1
sheetTitle <- zen2han(dataSet[8,3])
colnames(dataSet) <-
  gsub('\\s|na','',sapply(paste0(dataSet[11,],dataSet[12,],dataSet[13,]),zen2han),ignore.case = T)

dataSet[,1] <-
  gsub('na','',sapply(paste0(dataSet[,1],dataSet[,2]),zen2han),ignore.case = T)
dataSet <-
  dataSet[dataSet[,1]!='',]
dataSet <-
  dataSet[,c(1,which(colnames(dataSet)!=''))]
dataSet <-
  dataSet[!is.na(dataSet[,2]),]
