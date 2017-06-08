library(rvest)
library(Nippon)
library(XLConnect)
pathOutput <-
  paste0("C:/Users/",Sys.info()['user'],"/Desktop/R_Data_Write/")
setwd(pathOutput)
htmlMarkup <-
  read_html(x = 'https://www.e-miki.com/market/office.html',encoding = 'shift_jis')
hrefS <- htmlMarkup %>% html_nodes('a') %>% html_attr('href')
xlsFiles <- gsub('.+/([^/]+\\.xls)','\\1',unique(hrefS[grep('\\.xls',hrefS)]))
baseURL <- 'https://www.e-miki.com/market/download/office/'
cnt <- 1
for(iii in seq(length(xlsFiles))){
  download.file(url = paste0(baseURL,xlsFiles[iii]),xlsFiles[iii],mode = 'wb')
  sheetName <-
    getSheets(loadWorkbook(xlsFiles[iii]))
  for(ccc in seq(length(sheetName))){
    if(length(grep('データの',sheetName[ccc]))==0){
      buf0 <-
        readWorksheetFromFile(paste0(pathOutput,xlsFiles[iii]),sheet = ccc,check.names = F,header = F)
      buf1 <- buf0[!is.na(buf0[,1]),]
      buf2 <- t(buf1)
      colnames(buf2) <- buf2[1,]
      buf3 <- buf2[-1,]
      Date <- as.Date(gsub('([0-9]+)\\.([0-9]+)','\\1-\\2-1',buf3[,1]))
      buf4 <-
        data.frame(Date,apply(buf3[,-1],2,function(x)as.numeric(gsub(',','',x))),
                   check.names = F,stringsAsFactors = F,row.names = NULL)
      colnames(buf4) <- sapply(colnames(buf4),zen2han)
      buf4$`地区` <- zen2han(sheetName[ccc])
      buf4$`xlsFile` <- xlsFiles[iii]
      if(cnt == 1){officeData <- buf4}else{officeData <- rbind(officeData,buf4)}
      cnt <- cnt + 1
    }
  }
}
addTxt <- gsub('[^0-9]+([0-9]+).+','\\1',xlsFiles[1])
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = officeData,dataType = 1,
                     csvFileName = paste0('officeData_',addTxt))
# csv出力パート
remove('buf0','buf1','buf2','buf3','buf4')
