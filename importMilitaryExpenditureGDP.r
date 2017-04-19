# Source https://www.sipri.org/databases/milex
library(rvest);library(XLConnect);library(lubridate)
options(scipen = 999)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
htmlMarkup <-
  read_html(x = 'https://www.sipri.org/databases/milex',
            encoding = 'utf-8')
hrefLink <-
  htmlMarkup %>% html_nodes('a') %>% html_attr('href')
xlsxLink <-
  unique(hrefLink[grep('.xlsx',hrefLink)])[2]
fileName <-
  gsub('.+/([^/]+\\.xlsx)','\\1',xlsxLink)
download.file(url = paste0('https://www.sipri.org',xlsxLink),
              destfile = fileName,
              mode = 'wb')
sheetName <-
  getSheets(loadWorkbook(fileName))
buf0 <-
  readWorksheetFromFile(file = paste0(pathOutput, fileName),
                        sheet = sheetName[grep('gdp',sheetName,ignore.case = T)],
                        check.names = F,
                        header = F)
buf1 <- buf0
notes <-vector()
notes[1] <- buf1[1,1]
notes[2] <- buf1[2,1]
notes[3] <- buf1[3,1]
notes[4] <- buf1[4,1]
buf2 <-
  buf1[c(grep('^country$',buf1[,1],ignore.case = T):nrow(buf1)),-2]
colnames(buf2) <- buf2[1,]
buf3 <- buf2[-1,]
buf4 <-
  buf3[!is.na(buf3[,ncol(buf3)]),]
buf4[,-1] <-
  apply(buf4[,-1],2,function(x)gsub('xxx','-9999',x))
buf4[,-1] <-
  apply(buf4[,-1],2,function(x)as.numeric(gsub('%','',x)))

buf5 <- t(buf4)
colnames(buf5) <- buf5[1,]
buf6 <- buf5[-1,]
buf7 <-
  data.frame(Date = as.Date(paste0(rownames(buf6),'-1-1')),
             apply(buf6,2,as.numeric),
             stringsAsFactors = F,
             check.names = F,
             row.names = NULL)
assign('MilitaryExpenditureByCountryAsPercentageOfGrossDomesticProduct',
       buf7,
       envir = .GlobalEnv)
