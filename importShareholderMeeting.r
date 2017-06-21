library(XLConnect)
library(rvest)
library(Nippon)
pathOutput <-
  paste0("C:/Users/",Sys.info()['user'],"/Desktop/R_Data_Write/")
setwd(pathOutput)
getwd()
targetURL <-
  'http://www.jpx.co.jp/listing/event-schedules/shareholders-mtg/index.html'
htmlMarkup <-
  read_html(x = targetURL)
trS <-
  htmlMarkup %>% html_nodes('tr')
hrefS <-
  trS[grep('決算会社',trS)] %>% html_nodes('a') %>% html_attr('href')
targetURL <-
  paste0('http://www.jpx.co.jp',hrefS[1])
fileName <-
  gsub('.+/([^/]+)','\\1',targetURL)
download.file(url = targetURL,fileName,mode = 'wb')
sheetName <-
  getSheets(loadWorkbook(fileName))
buf0 <-
  readWorksheetFromFile(paste0(pathOutput,fileName),sheet = 1,check.names = F,header = F)
buf1 <- buf0
shareholderMeetingTitle <-
  zen2han(buf1[1,1])
objRaw <-
  grep('会社名',buf1[,1])[1]
buf2 <-
  buf1[(objRaw+1):nrow(buf1),]
colnames(buf2) <- buf1[objRaw,]
for(ccc in 3:6){
  buf2[,ccc] <- as.character(format(as.Date(buf2[,ccc]),'%m月%d日'))
}
buf2[is.na(buf2)] <- '-'
buf2[,2] <- as.numeric(buf2[,2])
colnames(buf2) <- sapply(gsub('\n','',colnames(buf2)),zen2han)
row.names(buf2) <- NULL
shareholderMeeting <- buf2
