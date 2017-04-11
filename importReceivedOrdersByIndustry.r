# 建設工事受注動態統計調査 確報 受注高 月次 業種別受注高
library(rvest);library(XLConnect);library(Nippon)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
htmlMarkup <-
  read_html(x = 'http://www.e-stat.go.jp/SG1/estat/GL08020102.do?_toGL08020102_&tclassID=000001011031&cycleCode=1&requestSender=estat',encoding = 'utf-8')
pageLink <-
  htmlMarkup %>% html_nodes(xpath = "//table[@class = 'noborder']") %>% html_nodes('a') %>% html_attr('href')
buf <-
  as.data.frame(htmlMarkup %>% html_nodes(xpath = "//table[@class = 'noborder']") %>% html_table())
objURL <-
  paste0('http://www.e-stat.go.jp/SG1/estat/',pageLink[length((grep('[0-9]+月',buf[1,])))])
htmlMarkup <-
  read_html(x = objURL,encoding = 'utf-8')
fileLink <-
  htmlMarkup %>% html_nodes(xpath = "//table[@class = 'black']") %>% html_nodes('a') %>% html_attr('href')
xlsLink <-
  fileLink[grep('xls',fileLink)]
fileName0 <-
  as.data.frame(htmlMarkup %>% html_nodes(xpath = "//table[@class = 'black']") %>% html_table())[,2]
objFile <- grep('^業種別',fileName0)
xlsFile <- gsub('.+fileid=([0-9]+)&.+','\\1',xlsLink[objFile],ignore.case = T)
fileName <- paste0(xlsFile,'.xls')
download.file(url = paste0('http://www.e-stat.go.jp/SG1/estat/GL08020103.do?_xlsDownload_&fileId=',
                           xlsFile,'&releaseCount=1'),
              destfile = fileName,
              mode = 'wb')
getSheets(loadWorkbook(fileName))
buf0 <-
  readWorksheetFromFile(file = paste0(pathOutput, fileName),
                        sheet = 1,
                        check.names = F,
                        header = F)
tmp <- NA
for(ccc in 1:ncol(buf0)){
  if(!is.na(buf0[4,ccc])){tmp <- buf0[4,ccc]}
  buf0[4,ccc] <- tmp
}
tmp <- NA
for(ccc in 1:ncol(buf0)){
  if(!is.na(buf0[5,ccc])){tmp <- buf0[5,ccc]}
  buf0[5,ccc] <- tmp
}
tmp <- NA
for(ccc in 1:ncol(buf0)){
  if(!is.na(buf0[6,ccc])){tmp <- buf0[6,ccc]}
  buf0[6,ccc] <- tmp
}
colnames(buf0) <-
  paste0(buf0[4,],':',buf0[5,],':',buf0[6,],':',buf0[7,])
sheetDate <- paste0(buf0[2,5],buf0[2,6])
sheetUnit <- zen2han(buf0[3,9])
sheetTitle <- zen2han(buf0[3,1])
buf1 <- buf0[-c(1:7),]
buf2 <- apply(buf1,2,function(x)gsub('▲','-',x))
buf3 <-
  data.frame(buf2[,1],apply(buf2[,-1],2,function(x)as.numeric(gsub(',|\\s','',x))),check.names = F,stringsAsFactors = F)
buf3 <-
  buf3[!is.na(buf3[,1]),]
colnames(buf3) <-
  gsub(':na','',colnames(buf3),ignore.case = T)
colnames(buf3)[1] <- '業種'
buf3[,1] <- sapply(buf3[,1],zen2han)
assign('receivedOrdersByIndustry',buf3,envir = .GlobalEnv)
