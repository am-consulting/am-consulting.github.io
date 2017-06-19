library(XLConnect)
pathOutput <-
  paste0("C:/Users/",Sys.info()['user'],"/Desktop/R_Data_Write/")
setwd(pathOutput)
getwd()
targetURL <- 'https://www.eia.gov/dnav/pet/xls/PET_PRI_FUT_S1_D.xls'
fileName <- gsub('.+/([^/]+)','\\1',targetURL)
download.file(url = targetURL,fileName,mode = 'wb')
sheetName <-
  getSheets(loadWorkbook(fileName))
NYMEXFuturesPrices <- list()
for(sss in seq(length(sheetName))){
  if(length(grep('data',sheetName[sss],ignore.case = T))!=0){
    buf0 <-
      readWorksheetFromFile(paste0(pathOutput,fileName),
                            sheet = sss,check.names = F,header = F)
    buf1 <- buf0
    colnames(buf1) <- buf1[3,]
    buf2 <- buf1[-c(1,2,3),]
    buf2[,1] <- as.Date(buf2[,1])
    buf2[,-1] <- apply(buf2[,-1,drop=F],2,function(x)as.numeric(gsub(',','',x)))
    print(tail(buf2,2))
    NYMEXFuturesPrices[[sss]] <- buf2
  }
}
sheetTitle <- 'NYMEX Futures Prices'