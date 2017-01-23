# http://stackoverflow.com/questions/12735503/extract-numbers-between-brackets-within-a-string
# http://stackoverflow.com/questions/952275/regex-group-capture-in-r-with-multiple-capture-groups
library(rvest);library(Nippon)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
htmlMarkup0 <-
  read_html('http://www.e-stat.go.jp/SG1/estat/OtherList.do?bid=000001007603&cycode=1',
            encoding = "utf-8")
hrefList0 <-
  htmlMarkup0 %>% html_nodes(xpath = '//table//tr//a') %>% html_attr("href")
# 平成24年12月１日現在 (概算値)(hrefList[61])より以前、62以上は次のエラーが出る
# Error: OldExcelFormatException (Java): The supplied spreadsheet seems to be Excel 5.0/7.0 (BIFF5) format. POI only supports BIFF8 format (from Excel versions 97/2000/XP/2003)
for(iii in 61:61){
#for(iii in 1:1){
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
  if(iii <= 61){
    buf0 <-
      XLConnect::readWorksheetFromFile(file = paste0(pathOutput, fileName),
                                       sheet = sheetNo,
                                       check.names = F,
                                       header = F)
  }else{
    data <-
      gdata::read.xls(xls = paste0(pathOutput, fileName), sheet = sheetNo)
  }
  objRow <- which(apply(buf0,1,function(x)grep('\\(確定値\\)',x))!=0)
  objCol <- which(apply(buf0,2,function(x)grep('\\(確定値\\)',x))!=0)
  sheetDate0 <- gsub('\\s','',zen2han(buf0[objRow,objCol]))
  buf1 <- buf0[,c(1,objCol:ncol(buf0))]
}
