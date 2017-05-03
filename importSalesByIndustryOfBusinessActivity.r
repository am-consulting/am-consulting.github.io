fun_SalesByIndustryOfBusinessActivity <- function(fileName = fileName){
library(XLConnect);library(Nippon)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName),
                        sheet = 1, check.names = F, header = F)
buf1 <- buf0
objRow1 <- 10
buf1[objRow1,!is.na(as.numeric(sapply(substring(buf1[objRow1,],1,1),zen2han)))] <- NA
buf1[objRow1+1,!is.na(as.numeric(sapply(substring(buf1[objRow1+1,],1,1),zen2han)))] <- NA
buf1[objRow1+2,!is.na(as.numeric(sapply(substring(buf1[objRow1+2,],1,1),zen2han)))] <- NA
buf1[objRow1+3,!is.na(as.numeric(sapply(substring(buf1[objRow1+3,],1,1),zen2han)))] <- NA
buf1[objRow1+4,!is.na(as.numeric(sapply(substring(buf1[objRow1+4,],1,1),zen2han)))] <- NA
tmp <- NA
for(ccc in seq(ncol(buf1))){
  if(!is.na(buf1[objRow1,ccc])){
    tmp <-
      paste0(buf1[objRow1,ccc],buf1[objRow1+1,ccc],buf1[objRow1+2,ccc])
  }
  buf1[objRow1,ccc] <- gsub('na','',tmp,ignore.case = T)
  buf1[objRow1+1,ccc] <-
    gsub('na','',paste0(buf1[objRow1+1,ccc],buf1[objRow1+2,ccc],buf1[objRow1+3,ccc],buf1[objRow1+4,ccc]),ignore.case = T)
}
colnames(buf1) <-
  gsub(':$','',sapply(paste0(buf1[objRow1,],':',buf1[objRow1+1,]),zen2han))
buf2 <- buf1[-c(1:grep('月次',buf1[,9])),-c(1:10)]
buf3 <-
  buf2[1:(which(is.na(buf2[,5]))[1]-1),]
tmp <-
  gsub('平成([0-9]+)年([0-9]+)月','\\1*\\2',gsub('\\s','',buf3[1,1]))
dateS <-
  as.Date(paste0(as.numeric(gsub('([0-9]+).+','\\1',tmp))+1988,'-',
                 as.numeric(gsub('[0-9]+\\*([0-9]+)','\\1',tmp)),'-1'))
Date <-
  seq(dateS,by = "month",length.out = nrow(buf3))
buf4 <-
  data.frame(Date,
             apply(buf3[,-c(1:4)],2,function(x)as.numeric(gsub(',','',x))),
             stringsAsFactors = F,check.names = F,row.names = NULL)
sheetUnit <- zen2han(buf0[20,9])
colnames(buf4)[-1] <- paste0(colnames(buf4)[-1],sheetUnit)
assign('sheetTitle',zen2han(buf0[5,9]),envir = .GlobalEnv)
assign('SalesByIndustryOfBusinessActivity',buf4,envir = .GlobalEnv)
}
