# http://stackoverflow.com/questions/12735503/extract-numbers-between-brackets-within-a-string
# http://stackoverflow.com/questions/952275/regex-group-capture-in-r-with-multiple-capture-groups
library(rvest);library(Nippon);library(dplyr)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/demographicForecast/")
setwd(pathOutput)
htmlMarkup0 <-
  read_html('http://www.e-stat.go.jp/SG1/estat/OtherList.do?bid=000001007603&cycode=1',
            encoding = "utf-8")
hrefList0 <-
  htmlMarkup0 %>% html_nodes(xpath = '//table//tr//a') %>% html_attr("href")
# 平成24年12月１日現在 (概算値)(hrefList[61])より以前、62以上は次のエラーが出る
# Error: OldExcelFormatException (Java): The supplied spreadsheet seems to be Excel 5.0/7.0 (BIFF5) format. POI only supports BIFF8 format (from Excel versions 97/2000/XP/2003)
cnt <- 1
for(iii in 1:length(hrefList0)){
  htmlMarkup <-
    read_html(paste0('http://www.e-stat.go.jp/SG1/estat/', gsub('\\./','',hrefList0[iii])))
  hrefList <-
    htmlMarkup %>% html_nodes(xpath = '//table//tr//a') %>% html_attr("href")
  rePattern <- '.*?id=([0-9]+)'
  fileName <-
    gsub(rePattern,'\\1',hrefList[1]) # or stringr::str_match(hrefList[1],rePattern)[2]
  fileName <- paste0(fileName,'.xls')
  if(!file.exists(paste0(pathOutput, fileName))) {
    download.file(url = paste0('http://www.e-stat.go.jp/SG1/estat/', gsub('\\./','',hrefList[1])),
                  destfile = fileName,
                  mode = 'wb')
  }
  sheetNo <- 1
  buf0 <-
    gdata::read.xls(xls = paste0(pathOutput, fileName), sheet = sheetNo,
                    fileEncoding = 'shift_jis', stringsAsFactors = F)
  if(nrow(buf0) == 0){
    buf0 <-
      XLConnect::readWorksheetFromFile(file = paste0(pathOutput, fileName),
                                       sheet = sheetNo,
                                       check.names = F,
                                       header = F)
  }
  buf0 <-
    buf0[,apply(buf0,2,function(x)sum(is.na(x)))!=nrow(buf0)]
  objRow <-
    which(apply(buf0,1,function(x)grep('再掲',gsub('\\s','',x),ignore.case = T)[1])!=0)[1]
  if(length(objRow) != 0){
    buf0 <-
      buf0[-c(objRow:nrow(buf0)),]
  }
  objRow <-
    which(apply(buf0,1,function(x)grep('概算値',x,ignore.case = T)[1])!=0)[1]
  objCol <-
    max(which(apply(buf0,2,function(x)grep('概算値',x,ignore.case = T)[1])!=0))
  sheetDate0 <-
    gsub('\\s','',zen2han(buf0[objRow,objCol]))
  preDate <-
    stringr::str_match(sheetDate0,'[^0-9]+?([0-9]+)年([0-9]+)月')
  yyyy <-
    as.numeric(preDate[2]) + 1988
  mm <-
    as.numeric(preDate[3])
  sheetDate0 <-
    as.Date(paste0(yyyy,'-',mm,'-1'))
  buf1 <-
    buf0[,c(1,objCol:ncol(buf0))]
  sheetCheck <-
    which(apply(buf1,2,function(x)grep('確定値',x,ignore.case = T))!=0)
  if(length(sheetCheck)!=0){
    objCol <- min(sheetCheck)
    buf1 <- buf1[,-c(objCol:ncol(buf1))]
  }
  objRow <-
    which(apply(buf1,1,function(x)grep('Total',x,ignore.case = T))!=0)[1]
  tmp <- NA
  for(ccc in 1:ncol(buf1)){
    if(!is.na(buf1[objRow,ccc]) & buf1[objRow,ccc] != ''){tmp <- buf1[objRow,ccc]}
    buf1[objRow,ccc] <- tmp
  }
  colnames(buf1) <-
    gsub('\\s','',paste0(buf1[objRow,],':',buf1[objRow+1,]))
  colnames(buf1) <-
    gsub('japanesepopulation','日本人人口:概算値',
         gsub('totalpopulation','総人口:概算値',colnames(buf1),ignore.case = T),
         ignore.case = T)
  buf1[,-1] <-
    apply(buf1[,-1],2,function(x)as.numeric(gsub(',|\\s','',x)))
  buf2 <-
    buf1[!is.na(buf1[,2]),]
  buf2[,1] <-
    gsub('\\s','',sapply(buf2[,1],zen2han))
  colnames(buf2)[1] <- '年齢階級'
  sheetCheck <-
    grep('na',colnames(buf2),ignore.case = T)
  if(length(sheetCheck) != 0){
    buf2 <- buf2[,-sheetCheck]
  }
  buf2 <-
    buf2[buf2[,1]!='',]
  buf3 <- t(buf2)
  colnames(buf3) <- buf3[1,]
  buf3 <- buf3[-1,]
  buf4 <-
    data.frame(`種別` = row.names(buf3),buf3,row.names = NULL,check.names = F,stringsAsFactors = F)
  buf5 <- buf4
  buf5[,1] <- as.Date('2000-1-1') # dammy
  if(nchar(buf5[1,2])<=5){
    buf5[,-1] <-
      apply(buf5[,-1],2,function(x) as.numeric(x)*10)
  }else{
    buf5[,-1] <-
      apply(buf5[,-1],2,function(x) as.numeric(x))
  }
  if(cnt == 1){
    TotalBothProvisional <- buf5[1,]
    TotalMaleProvisional <- buf5[2,]
    TotalFemaleProvisional <- buf5[3,]
  }else{
    TotalBothProvisional <- bind_rows(TotalBothProvisional,buf5[1,])
    TotalMaleProvisional <- bind_rows(TotalMaleProvisional,buf5[2,])
    TotalFemaleProvisional <- bind_rows(TotalFemaleProvisional,buf5[3,])
  }
  TotalBothProvisional[cnt,1] <-
    TotalMaleProvisional[cnt,1] <-
    TotalFemaleProvisional[cnt,1] <- sheetDate0
  cnt <- cnt + 1
}
colnames(TotalBothProvisional)[1] <-
  colnames(TotalMaleProvisional)[1] <-
  colnames(TotalFemaleProvisional)[1] <- 'Date'
TotalBothProvisional <-
  TotalBothProvisional[order(TotalBothProvisional[,1]),]
TotalMaleProvisional <-
  TotalMaleProvisional[order(TotalMaleProvisional[,1]),]
TotalFemaleProvisional <-
  TotalFemaleProvisional[order(TotalFemaleProvisional[,1]),]
TotalBothProvisional[,-1] <-
  apply(TotalBothProvisional[,-1],2,function(x)as.numeric(gsub('\\s','',x)))
TotalMaleProvisional[,-1] <-
  apply(TotalMaleProvisional[,-1],2,function(x)as.numeric(gsub('\\s','',x)))
TotalFemaleProvisional[,-1] <-
  apply(TotalFemaleProvisional[,-1],2,function(x)as.numeric(gsub('\\s','',x)))
# csvへの書き出し
fileName <-'defaultPath.csv'
pathToFile <-
  paste0('C:/Users/', username,'/Desktop/pathToCSV/')
setwd(pathToFile)
buf000 <-
  read.csv(fileName,header = F,skip = 0,stringsAsFactor = F,check.names = F,fileEncoding = 'utf-8')
pathOutputTOcsv <-
  paste0("C:/Users/", username, buf000[2,1],'csv/')
setwd(pathOutputTOcsv)
write.csv(x = TotalBothProvisional, file = paste0('TotalBothProvisional','.csv'),
          quote = F, row.names = F, append = F, fileEncoding = 'utf8')
write.csv(x = TotalMaleProvisional, file = paste0('TotalMaleProvisional','.csv'),
          quote = F, row.names = F, append = F, fileEncoding = 'utf8')
write.csv(x = TotalFemaleProvisional, file = paste0('TotalFemaleProvisional','.csv'),
          quote = F, row.names = F, append = F, fileEncoding = 'utf8')
