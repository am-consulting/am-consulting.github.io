fun.read.jgb.trade <- function(load.library = F,path.to.folder = '/Desktop/R_Data_Write/'){
  # http://www.jsda.or.jp/shiryo/toukei/toushika/tkbk/index.html
  if(load.library==T){lapply(c('XLConnect','Nippon','lubridate'),require,character.only = T)}
  buf.wd <- getwd()
  path.to.folder <- paste0('C:/Users/',Sys.info()['user'],path.to.folder)
  setwd(path.to.folder)
  target.url <- 'http://www.jsda.or.jp/shiryo/toukei/toushika/tkb/files/kokusaiichiran.xls'
  xls.file <- gsub('.+/([^/]+)','\\1',target.url)
  Sys.sleep(1) # To prevent server overload
  download.file(url = target.url,xls.file,mode = 'wb')
  sheet.name <- sapply(getSheets(loadWorkbook(xls.file)),zen2han)
  sheet.title <- vector()
  for(sheet in 1:2){
    tmp0 <- readWorksheetFromFile(xls.file,sheet = sheet,check.names = F,header = F)
    buf0 <- tmp0
    sheet.unit <- zen2han(buf0[1,24])
    sheet.title[sheet] <- zen2han(buf0[1,2])
    for(rrr in 3:5){
      tmp <- NA
      for(ccc in seq(ncol(buf0))){
        if(!is.na(buf0[rrr,ccc])){
          tmp <- gsub('\\s|\\([a-z]+\\)|-','',gsub('([^\n]+)\n.+','\\1',zen2han(buf0[rrr,ccc])),ignore.case = T)
        }
        buf0[rrr,ccc] <- tmp
      }
    }
    buf0[6,]<-gsub('([^\n]+)\n.+','\\1',sapply(buf0[6,],zen2han))
    colnames(buf0) <- gsub('内訳:|:NA','',paste0(buf0[3,],':',buf0[4,],':',buf0[5,],':',buf0[6,],sheet.unit))
    buf1 <- buf0[!is.na(as.numeric(buf0[,1])),]
    date <- as.Date(paste0(gsub('\\.','-',buf1[,1]),'-1'))
    buf2 <-
      data.frame(Date = date,apply(buf1[,-1],2,function(x)as.numeric(gsub(',|－','',x))),
                 check.names = F,row.names = NULL,stringsAsFactors = F)
    if(sheet == 1){jgb.trade <- buf2}else{jgb.trade <- merge(jgb.trade,buf2,by='Date',all=T)}
  }
  setwd(buf.wd)
  returnList <-
    list('sheet.name' = paste0(sheet.name),
         'jgb.trade' = jgb.trade,
         'sheet.title' = sheet.title)
  return(returnList)
}
