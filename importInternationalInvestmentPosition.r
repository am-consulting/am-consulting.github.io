# Source http://www.mof.go.jp/international_policy/reference/iip/data.htm
library(rvest);library(XLConnect);library(lubridate);library(Nippon)
options(scipen = 999)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
htmlMarkup <-
  read_html(x = 'http://www.mof.go.jp/international_policy/reference/iip/data.htm',
            encoding = 'Shift_JIS')
aS <-
  htmlMarkup %>% html_nodes('a')
hrefS <-
  htmlMarkup %>% html_nodes('a') %>% html_attr('href')
fileName <-
  hrefS[grep('本邦対外資産負債残高の推移',aS %>% html_text())]
download.file(url = paste0('http://www.mof.go.jp/international_policy/reference/iip/',fileName),
              destfile = fileName,
              mode = 'wb')
sheetName <-
  getSheets(loadWorkbook(fileName))
buf0 <-
  readWorksheetFromFile(file = paste0(pathOutput, fileName),
                        sheet = 1,
                        check.names = F,
                        header = F)
sheetTtile <-
  gsub('\\s','',zen2han(buf0[1,1]))
buf1 <- buf0
tmp <- NA
for(ccc in seq(ncol(buf1))){
  if(!is.na(buf1[5,ccc])){tmp <- buf1[5,ccc]}
  buf1[5,ccc] <- tmp
}
colnames(buf1) <-
  gsub(':na','',paste0(buf1[5,],':',buf1[7,]),ignore.case = T)
objRow <- which(apply(buf1,1,function(x)(length(grep('単位',x))))!=0)
objCol <- which(apply(buf1,2,function(x)(length(grep('単位',x))))!=0)
sheetUnit <-
  gsub('\\s','',gsub('(.+)\\(.+\\)','\\1',buf1[objRow,objCol]))
buf2 <-
  buf1[grep('^平成.+年末',buf1[,1]),]
Date <-
  as.Date(paste0(gsub('.+\\s([0-9]{4})','\\1',buf2[,2]),'-1-1'))
buf2 <-
  apply(buf2,2,function(x)as.numeric(gsub(',','',x))*10^-3)
colnames(buf2) <-
  paste0(colnames(buf2),'(兆円)')
buf3 <-
  data.frame(Date,
             buf2[,-grep('na',colnames(buf2),ignore.case = T)],
             stringsAsFactors = F,check.names = F,row.names = NULL)
assign('InternationalInvestmentPosition',buf3,envir = .GlobalEnv)
