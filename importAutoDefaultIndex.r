library(rvest)
library(XLConnect)
pathOutput <-
  paste0("C:/Users/",Sys.info()['user'],"/Desktop/R_Data_Write/")
setwd(pathOutput)
targetURL <-
  'http://us.spindices.com/indices/specialty/sp-experian-auto-default-index'
htmlMarkup <-
  read_html(x = targetURL,encoding = 'utf8')
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
xlsFile <-
  'AutoDefaultIndex.xls'
download.file(url = xlsURL,xlsFile,mode = 'wb')
sheetName <-
  getSheets(loadWorkbook(xlsFile))
buf0 <-
  readWorksheetFromFile(paste0(pathOutput,xlsFile),sheet = 1,check.names = F,header = F)
objRaw <- grep('Effective date',buf0[,1],ignore.case = T)

colnames(buf0) <- buf0[objRaw,]
buf1 <- buf0[(objRaw+1):nrow(buf0),]
buf1[,2] <- as.numeric(gsub('%','',buf1[,2]))
colnames(buf1)[2] <- paste0(colnames(buf1)[2],'(%)')
buf2 <- buf1[!is.na(buf1[,2]),]
buf2[,1] <-
  as.Date(paste0(substring(buf2[,1],5),'-',match(tolower(substring(buf2[,1],1,3)),tolower(month.abb)),'-1'))
row.names(buf2) <- NULL
AutoDefaultIndex <- buf2
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = AutoDefaultIndex,dataType = 1,
                     csvFileName = paste0('AutoDefaultIndex-',format(Sys.Date(),'%Y%m%d')))
# csv出力パート
