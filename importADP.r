library(rvest)
library(XLConnect)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
htmlMarkup <-
  read_html(x = 'http://www.adpemploymentreport.com/',encoding = 'utf-8')
latestPage <-
  htmlMarkup %>% html_nodes(xpath = "//div[@class = 'ner-overview']") %>% html_nodes('a') %>% html_attr('href')
htmlMarkup <-
  read_html(x = paste0('http://www.adpemploymentreport.com',latestPage),encoding = 'utf-8')
xlsFile <-
  htmlMarkup %>% html_nodes(xpath = "//div[@id = 'download-btns']") %>% html_nodes('a') %>% html_attr('href')
xlsFile <-
  xlsFile[grep('xlsx',xlsFile)]
fileName <-
  gsub('.+/(.+\\.xlsx)','\\1',xlsFile)
download.file(url = paste0('http://www.adpemploymentreport.com',xlsFile),
              destfile = fileName,
              mode = 'wb')
getSheets(loadWorkbook(fileName))
buf <-
  readWorksheetFromFile(file = paste0(pathOutput, fileName),
                        sheet = 1,
                        check.names = F,
                        header = F)
buf0 <- buf
tmp <- NA
for(ccc in seq(ncol(buf0))){
  if(!is.na(buf0[2,ccc])){tmp <- buf0[2,ccc]}
  buf0[2,ccc] <- tmp
}
colnames(buf0) <-
  paste0(buf0[3,],'(',buf0[2,],')')
buf1 <-
  buf0[!is.na(as.numeric(substring(buf0[,1],1,4))),]
Date <-
  as.Date(gsub('([0-9]+)m([0-9]+)','\\1-\\2-1',buf1[,1],ignore.case = T))
buf2 <-
  data.frame(Date, apply(buf1[,-1],2,function(x)as.numeric(gsub(',','',x))),
             check.names = F,
             stringsAsFactors = F)
ADPreport <- buf2
