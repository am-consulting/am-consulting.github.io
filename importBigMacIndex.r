# http://www.economist.com/content/big-mac-index
library(rvest);library(XLConnect);library(gdata);library(plyr)
options(scipen = 999)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
htmlMarkup <-
  read_html(x = 'http://www.economist.com/content/big-mac-index',encoding = 'utf-8')
aLink <-
  htmlMarkup %>% html_nodes(xpath = "//a[@title = ' (opens in a new window) ']") %>% html_attr('href')
objURL <- aLink[grep('.xls',aLink)]
fileName <-
  gsub('.+/(.+\\.xls)','\\1',objURL)
download.file(url = paste0('http://infographics.economist.com/2017/databank/',fileName),
              destfile = fileName,
              mode = 'wb')
sheetName <-
  getSheets(loadWorkbook(fileName))
for(sss in 1:length(sheetName)){
  buf0 <-
    read.xls (xls = paste0(pathOutput, fileName),
              sheet = sheetName[sss],
              header = T,
              na.strings = c(''))
  buf0 <-
    buf0[,apply(buf0,2,function(x)sum(is.na(x)))!=nrow(buf0)]
  buf0$Date <-
    as.Date(paste0(gsub('.+([0-9]{4})','\\1',sheetName[sss]),'-',
                   match(gsub('(.+)[0-9]{4}','\\1',sheetName[sss]),month.abb),'-1'))
  buf0$cnt <- sss
  colnames(buf0) <- gsub('id','Country',colnames(buf0),ignore.case = T)
  if(sss == 1){
    bigMacIndex0 <- buf0
  }else{
    bigMacIndex0 <- rbind.fill(bigMacIndex0,buf0)
  }
}
objColumn <-
  grep('date',colnames(bigMacIndex0),ignore.case = T)
assign('bigMacIndex',
       bigMacIndex0[,c(objColumn,1:(objColumn-1),(objColumn+1):ncol(bigMacIndex0))],
       envir = .GlobalEnv)
