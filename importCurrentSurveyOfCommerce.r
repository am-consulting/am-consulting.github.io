fun_CurrentSurveyOfCommerce <- function(objTitle = '百貨店・スーパー商品別販売額及び前年'){
library(rvest);library(XLConnect);library(Nippon);library(lubridate)
options(scipen = 999)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
htmlMarkup <-
  read_html(x = 'http://www.e-stat.go.jp/SG1/estat/GL08020101.do?_toGL08020101_&tstatCode=000001081875',
            encoding = 'utf-8')
pageLink <-
  htmlMarkup %>% html_nodes(xpath = "//table[@class = 'noborder']") %>% html_nodes('tr')
tsLink <-
  pageLink[grep('時系列データ',pageLink)] %>% html_nodes('a') %>% html_attr('href')
objURL <-
  paste0('http://www.e-stat.go.jp/SG1/estat/',tsLink)
htmlMarkup <-
  read_html(x = objURL,encoding = 'utf-8')
fileLink <-
  htmlMarkup %>% html_nodes(xpath = "//table[@class = 'black']") %>% html_nodes('a') %>% html_attr('href')
buf <-
  as.data.frame(htmlMarkup %>% html_nodes(xpath = "//table[@class = 'black']") %>% html_table())
fileName0 <-
  sapply(buf[,2],zen2han)
objFile <-
  grep(paste0('^',objTitle),fileName0)
fileID <-
  gsub('.+fileid=([0-9]+)&.+','\\1',fileLink[objFile],ignore.case = T)
releaseCount <-
  gsub('.+releasecount=([0-9]+)','\\1',fileLink[objFile],ignore.case = T)
fileName <-
  paste0(fileID,'.xls')
download.file(url = paste0('http://www.e-stat.go.jp/SG1/estat/GL08020103.do?_xlsDownload_&fileId=',
                           fileID,'&releaseCount=',releaseCount),
              destfile = fileName,
              mode = 'wb')
sheetName <-
  getSheets(loadWorkbook(fileName))
buf0 <-
  readWorksheetFromFile(file = paste0(pathOutput, fileName),
                        sheet = "百貨店　販売額　月次",
                        check.names = F,
                        header = F)
buf1 <- buf0
buf2 <- buf1[!is.na(as.numeric(gsub(',','',buf1[,2]))),]
buf2[,1] <- sapply(gsub('\\W','',buf2[,1]),zen2han)
baseDate <-
  as.Date(gsub('昭和([0-9]+)年([0-9]+)月','19\\1-\\2-1',buf2[1,1]))  %m+% months(12*25)
Date <-
  seq(baseDate, by = "month", length.out = nrow(buf2))
buf3 <-
  data.frame(Date,apply(buf2[,-1],2,function(x)as.numeric(gsub(',','',x))),stringsAsFactors = F)
tmp <- NA
for(ccc in seq(ncol(buf1))){
  if(!is.na(buf1[6,ccc])){tmp <- buf1[6,ccc]}
  buf1[6,ccc] <- tmp
}
colnames(buf1) <-
  gsub('\\s','',paste0(buf1[5,],':',buf1[6,],':',buf1[7,],buf1[8,]))
colnames(buf1) <-
  sapply(gsub('na:|na|:na|:年月','',colnames(buf1),ignore.case = T),zen2han)
colnames(buf1)[1] <- 'Date'
colnames(buf3) <- colnames(buf1)
buf4 <- buf3[,-grep('year',colnames(buf3),ignore.case = T)]
assign('sheetTitle',zen2han(buf0[2,1]),envir = .GlobalEnv)
assign('sheetUnit',zen2han(buf0[4,14]),envir = .GlobalEnv)
assign('CurrentSurveyOfCommerce',buf4,envir = .GlobalEnv)
}
