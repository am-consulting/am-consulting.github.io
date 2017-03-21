fun_JapanPropertyPriceIndexREV <- function(sheetName = '全国',objXLSX = 1,needReadHtml = 0){
  library(rvest)
  library(XLConnect)
  library(Nippon)
  username <-
    Sys.info()['user']
  pathOutput <-
    paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
  setwd(pathOutput)
  if(needReadHtml == 1){
    htmlMarkup <-
      read_html(x = 'http://tochi.mlit.go.jp/?post_type=secondpage&p=15623',encoding = 'utf-8')
    hrefS <-
      htmlMarkup %>% html_nodes('a') %>% html_attr('href')
    texS <-
      htmlMarkup %>% html_nodes('a') %>% html_text()
    obj <- cbind(texS,hrefS)
    obj <- obj[grep('xlsx',obj[,2]),]
    obj[,2] <-
      gsub('.+/(.+\\.xlsx)','\\1',obj[,2])
    fileName <- obj[objXLSX,2]
    download.file(url = paste0('http://tochi.mlit.go.jp/wp-content/uploads/2017/02/',fileName),
                  destfile = fileName,
                  mode = 'wb')
  }else{
    fileName <- dir(pattern = '.xlsx',ignore.case = T)[objXLSX]
  }
  gc();gc()
  getSheets(loadWorkbook(fileName))
  buf0 <-
    readWorksheetFromFile(file = paste0(pathOutput, fileName),
                                     sheet = sheetName,
                                     check.names = F,
                                     header = F)
  tmp <- NA
  for(ccc in seq(ncol(buf0))){
    if(!is.na(buf0[4,ccc])){tmp <- buf0[4,ccc]}
    buf0[4,ccc] <- tmp
  }
  colnames(buf0) <-
    sapply(gsub('\n','',paste0(buf0[4,],':',buf0[6,])),zen2han)
  buf1 <- buf0[!is.na(buf0[,1]),]
  if(class(buf1[,1]) != 'numeric'){
    buf1[,1] <- as.numeric(sapply(buf1[,1],zen2han))
  }
  buf1 <- buf1[!is.na(buf1[,1]),]
  buf1[,1] <- as.Date(as.numeric(buf1[,1]),origin = "1899-12-30")
  buf1 <- apply(buf1,2,function(x)gsub('▲','-',x))
  buf1 <- apply(buf1,2,function(x)gsub('\\s|,','',x))
  buf2 <-
    data.frame(buf1[,1],apply(buf1[,-1],2,as.numeric),stringsAsFactors = F,check.names = F,row.names = NULL)
  colnames(buf2)[1] <- 'Date'
  colnames(buf2)[-1] <- paste0(sheetName,':',colnames(buf2)[-1])
  assign(paste0('JapanPropertyPriceIndex',objXLSX),buf2,envir = .GlobalEnv)
}
