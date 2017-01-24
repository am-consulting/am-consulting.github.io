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
  if(iii <= 61 | 117 == iii | 148 == iii){
    buf0 <-
      XLConnect::readWorksheetFromFile(file = paste0(pathOutput, fileName),
                                       sheet = sheetNo,
                                       check.names = F,
                                       header = F)
  }else{
    buf0 <-
      gdata::read.xls(xls = paste0(pathOutput, fileName), sheet = sheetNo,
                      fileEncoding = 'shift_jis', stringsAsFactors = F)
  }
  objRow <-
    which(apply(buf0,1,function(x)grep('注',x,ignore.case = T)[1])!=0)[1]
  if(length(objRow) != 0){
    buf0 <-
      buf0[-c(objRow:nrow(buf0)),]
  }
  objRow <- which(apply(buf0,1,function(x)grep('確定値',x,ignore.case = T)[1])!=0)[1]
  objCol <- max(which(apply(buf0,2,function(x)grep('確定値',x,ignore.case = T)[1])!=0))
  sheetDate0 <- gsub('\\s','',zen2han(buf0[objRow,objCol]))
  buf1 <- buf0[,c(1,objCol:ncol(buf0))]
  sheetCheck <-
    which(apply(buf1,2,function(x)grep('概算値',x,ignore.case = T))!=0)
  if(length(sheetCheck)!=0){
    objCol <- max(sheetCheck)
    buf1 <- buf1[,-c(objCol:ncol(buf1))]
  }
  objRow <- which(apply(buf1,1,function(x)grep('Total',x,ignore.case = T))!=0)[1]
  tmp <- NA
  for(ccc in 1:ncol(buf1)){
    if(!is.na(buf1[objRow,ccc]) & buf1[objRow,ccc] != ''){tmp <- buf1[objRow,ccc]}
    buf1[objRow,ccc] <- tmp
  }
  colnames(buf1) <-
    gsub('\\s','',paste0(buf1[objRow,],':',buf1[objRow+1,]))
  colnames(buf1) <-
    gsub('japanesepopulation','日本人人口',
         gsub('totalpopulation','総人口',colnames(buf1),ignore.case = T),
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
  buf3 <- t(buf2)
  colnames(buf3) <- buf3[1,]
  buf3 <- buf3[-1,]
  buf4 <- data.frame(`年齢階級` = row.names(buf3),buf3,row.names = NULL,check.names = F,stringsAsFactors = F)
  if(cnt == 1){
    TotalBoth <- buf4[1,]
    TotalMale <- buf4[2,]
    TotalFemale <- buf4[3,]
    JaBoth <- buf4[4,]
    JaMale <- buf4[5,]
    JaFemale <- buf4[6,]
    TotalBoth[cnt,1] <- TotalMale[cnt,1] <- TotalFemale[cnt,1] <-
      JaBoth[cnt,1] <- JaMale[cnt,1] <- JaFemale[cnt,1] <- sheetDate0
  }else{
    TotalBoth <- bind_rows(TotalBoth,buf4[1,])
    TotalMale <- bind_rows(TotalMale,buf4[2,])
    TotalFemale <- bind_rows(TotalFemale,buf4[3,])
    JaBoth <- bind_rows(JaBoth,buf4[4,])
    JaMale <- bind_rows(JaMale,buf4[5,])
    JaFemale <- bind_rows(JaFemale,buf4[6,])
    TotalBoth[cnt,1] <- TotalMale[cnt,1] <- TotalFemale[cnt,1] <-
      JaBoth[cnt,1] <- JaMale[cnt,1] <- JaFemale[cnt,1] <- sheetDate0
  }
  cnt <- cnt + 1
}
