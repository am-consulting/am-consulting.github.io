# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
# csv出力パート
library(rvest)
library(XLConnect)
pathOutput <-
  paste0("C:/Users/",Sys.info()['user'],"/Desktop/R_Data_Write/")
targetURL <-
  c('http://us.spindices.com/indices/equity/sp-global-reit-us-dollar',
    'http://us.spindices.com/indices/equity/sp-united-states-reit-us-dollar',
    'http://us.spindices.com/indices/equity/sp-developed-reit-us-dollar')
for(iii in seq(length(targetURL))){
setwd(pathOutput)
htmlMarkup <-
  read_html(x = targetURL[iii],encoding = 'utf8')
script <-
  htmlMarkup %>% html_nodes('script')
buf <-
  script[grep('var hostIdentifier',script)] %>% html_text()
hostIdentifier <-
  gsub('.+var hostIdentifier.+"([^"]+)";.+','\\1',buf)
buf <-
  script[grep('var indexIdForReference',script)] %>% html_text()
indexIdForReference <-
  gsub('.+var indexIdForReference\\W+(\\w+);.+','\\1',buf)
xlsURL <-
  paste0('http://us.spindices.com/idsexport/file.xls?hostIdentifier=',hostIdentifier,'&selectedModule=PerformanceGraphView&selectedSubModule=Graph&yearFlag=tenYearFlag&indexId=',indexIdForReference)
xlsFile <- paste0(gsub('.+/([^/]+)','\\1',targetURL),'.xls')
download.file(url = xlsURL,xlsFile[iii],mode = 'wb')
sheetName <-
  getSheets(loadWorkbook(xlsFile[iii]))
buf0 <-
  readWorksheetFromFile(paste0(pathOutput,xlsFile[iii]),sheet = 1,check.names = F,header = F)
objRaw <- grep('Effective date',buf0[,1],ignore.case = T)
colnames(buf0) <- buf0[objRaw,]
buf1 <- buf0[(objRaw+1):nrow(buf0),]
buf1[,2] <- as.numeric(buf1[,2])
buf2 <- buf1[!is.na(buf1[,2]),]
buf2[,1] <- as.Date(buf2[,1])
row.names(buf2) <- NULL
dataName <- gsub('(.+)\\.xls','\\1',xlsFile[iii])
assign(dataName,buf2)
# csv出力パート
fun_writeCSVtoFolder(objData = get(dataName),dataType = 1,
                     csvFileName = paste0(dataName,'-',format(Sys.Date(),'%Y%m%d')))
# csv出力パート
}
