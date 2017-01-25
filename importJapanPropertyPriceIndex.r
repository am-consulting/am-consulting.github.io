fun_JapanPropertyPriceIndex <- function(sheetNo = 1){
library(rvest);library(Nippon);library(lubridate)
perl <-
  gdata:::findPerl('perl') # perl path
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
htmlMarkup0 <-
  read_html(x = 'http://tochi.mlit.go.jp/kakaku/shisuu',
            encoding = 'utf-8')
aList <-
  htmlMarkup0 %>% html_nodes(xpath = '//a')
hrefList <-
  aList %>% html_attr("href")
txtList <-
  aList %>% html_text()
txtList <-
  sapply(txtList,zen2han)
objNo <-
  grep('^不動産価格指数\\(.+?\\)',txtList)
xlsList <-
  hrefList[objNo]
titleList <-
  txtList[objNo]
for(iii in seq(length(objNo))){
  download.file(url = xlsList[iii],
                destfile = paste0('JapanPropertyPriceIndex',iii,'.xlsx'),
                mode = 'wb')
}
iii <- 1
buf0 <-
  XLConnect::readWorksheetFromFile(file = paste0('JapanPropertyPriceIndex',iii,'.xlsx'),
                                   sheet = sheetNo,
                                   check.names = F,
                                   header = F);gc();gc()
buf1 <- buf0
area <- buf1[1,12]
dateData <-
  as.numeric(iconv(buf1[,1],'shift_jis','utf-8'))
buf1[,1] <-
  as.Date(dateData,origin = "1899-12-30")
tmp <- NA
for(ccc in 1:ncol(buf1)){
  if(!is.na(buf1[4,ccc])){tmp <- buf1[4,ccc]}
  buf1[4,ccc] <- tmp
}
colnames(buf1) <-
  paste0(area,':',sapply(gsub('\n|\\s','',paste0(buf1[4,],':',buf1[6,])),zen2han))
buf2 <-
  buf1[!is.na(buf1[,1]),]
buf3 <-
  apply(apply(buf2,2,function(x)gsub('▲','-',x)),2,function(x)gsub('\\s|,','',x))
buf3[,-1] <-
  apply(buf3[,-1],2,as.numeric)
buf4 <-
  data.frame(as.Date(paste0(year(buf3[,1]),'-',month(buf3[,1]),'-1')),
             buf3[,-1],
             check.names = F,
             stringsAsFactors = F,
             row.names = NULL)
colnames(buf4)[1] <- 'Date'
assign('JapanResidentalProperty', buf4, envir = .GlobalEnv)
}
