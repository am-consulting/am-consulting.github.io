library(XLConnect)
library(Nippon)
library(lubridate)
library(xts)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
urlToData <-
  'https://www.boj.or.jp/research/research_data/gap/'
fileName <-
  'gap.xlsx'
download.file(paste0(urlToData, fileName),
              fileName,
              mode = 'wb')
buf0 <-
  readWorksheetFromFile(fileName, sheet = 1, check.names = F, header = F)
colnames(buf0) <-
  paste0(buf0[2,],
         '(',
         buf0[4,],
         ')')
colnames(buf0) <-
  sapply(colnames(buf0), zen2han)
buf0 <-
  buf0[-c(1:5),]
tmp0 <-
  which(apply(buf0, 2, function(x){sum(is.na(x))}) == nrow(buf0))
tmp1 <-
  length(tmp0)
if(tmp1 != 0){
  buf0 <-
    buf0[,-tmp0]
}
colnames(buf0)[1] <-
  'Date'
buf0[,-1] <-
  apply(buf0[,-1], 2, as.numeric)
buf0[,1] <-
  as.yearqtr(gsub('Q', '', gsub('\\.', '-', buf0[,1])))
buf0[,1] <-
  as.Date(buf0[,1])
OutputGapAndPotentialGrowthRate <-
  buf0
write.table(OutputGapAndPotentialGrowthRate,
            "clipboard-16384",
            sep = "\t",
            row.names = F,
            col.names = T,
            quote = F)
