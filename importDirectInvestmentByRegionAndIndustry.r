library(XLConnect);library(Nippon)
# http://stackoverflow.com/questions/24534782/how-do-skip-or-f-work-on-regex
# http://stackoverflow.com/questions/8613237/extract-info-inside-all-parenthesis-in-r
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
sheetTitle <- vector()
for(sheetNo in 1:4){
  buf0 <-
    readWorksheetFromFile(paste0(pathOutput, fileName), sheet = sheetNo, check.names = F, header = F)
  buf1 <-
    buf0
  sheetTitle[sheetNo] <-
    zen2han(gsub('\\s','',paste0(buf1[8,3],':',buf1[9,16])))
  colnames(buf1) <-
    gsub('\\s|na','',sapply(paste0(buf1[11,],buf1[12,],buf1[13,]),zen2han),ignore.case = T)
  buf1[,1] <-
    gsub('na','',sapply(paste0(buf1[,1],buf1[,2]),zen2han),ignore.case = T)
  buf2 <-
    buf1[buf1[,1]!='',]
  buf3 <-
    buf2[,c(1,which(colnames(buf2)!=''))]
  buf4 <-
    buf3[!is.na(buf3[,2]),]
  buf5 <-
    apply(buf4,2,function(x)as.numeric(gsub("[\\(\\)]", "",
                                            regmatches(x,gregexpr("\\([0-9]*?\\)",x))))*-1)
  buf5[is.na(buf5)] <-
    buf4[is.na(buf5)]
  buf6 <-
    data.frame(ID = seq(nrow(buf5)),
               buf5[,1,drop=F],
               as.matrix(apply(buf5[,-1],2,function(x)as.numeric(gsub(',','',x)))),
               check.names = F,
               stringsAsFactors = F,
               row.names = NULL)
  colnames(buf6)[2] <- '地域'
  assign(paste0('DirectInvestment',sheetNo),
         buf6,
         envir = .GlobalEnv)
}
assign('DirectInvestmentIncomeCredit',
       merge(DirectInvestment1,DirectInvestment2, by = c('ID','地域'), all = T),
       envir = .GlobalEnv)
assign('DirectInvestmentIncomeDebit',
       merge(DirectInvestment3,DirectInvestment4, by = c('ID','地域'), all = T),
       envir = .GlobalEnv)
