fun.read.labor.excess.deficiency <- function(load.library = F,path.to.folder = '/Desktop/R_Data_Write/'){
  # 産業、雇用形態、労働者の過不足状況別事業所割合
  if(load.library==T){lapply(c('XLConnect','Nippon','lubridate'),require,character.only = T)}
  buf.wd <- getwd()
  path.to.folder <- paste0('C:/Users/',Sys.info()['user'],path.to.folder)
  setwd(path.to.folder)
  file.name <- 'jikeiretu1-1.xls'
  base.url <- 'http://www.e-stat.go.jp/SG1/estat/GL08020103.do?_xlsDownload_&fileId=000008023739&releaseCount=2'
  download.file(base.url,file.name,mode = "wb")
  sheet <- length(getSheets(loadWorkbook(file.name)))
  buf0 <-
    readWorksheetFromFile(file.name,sheet = sheet,check.names = F,header = F)
  sheet.title <- zen2han(buf0[1, 1])
  sheet.unit <- zen2han(buf0[2,ncol(buf0)])
  tmp <- NA
  for(ccc in seq(ncol(buf0))){
    if(!is.na(buf0[3,ccc])){tmp <- buf0[3,ccc]};buf0[3,ccc] <- tmp
  }
  colnames(buf0) <- sapply(paste0(buf0[3,],':',buf0[4,]),zen2han)
  obj.col <- grep('不足|過剰',colnames(buf0))
  colnames(buf0)[obj.col] <- paste0(colnames(buf0)[obj.col],'(%)')
  colnames(buf0)[-obj.col] <- paste0(colnames(buf0)[-obj.col],'(Point)')
  buf1 <- buf0[-c(1:4),]
  buf1[-grep('平成',buf1[,1]),1] <- NA
  tmp <- NA
  for(rrr in seq(nrow(buf1))){
    if(!is.na(buf1[rrr,1])){tmp <- as.numeric(gsub('[^0-9]+([0-9]+).+','\\1',buf1[rrr,1]))+1988}
    buf1[rrr,1] <- tmp
  }
  buf1[-grep('月調査',buf1[,2]),2] <- NA
  tmp <- NA
  for(rrr in seq(nrow(buf1))){
    if(!is.na(buf1[rrr,2])){tmp <- as.numeric(gsub('([0-9]+).+','\\1',buf1[rrr,2]))}
    buf1[rrr,2] <- tmp
  }
  date <- as.Date(paste0(buf1[,1],'-',buf1[,2],'-1'))
  buf2 <-
    data.frame(Date=date,buf1[,3,drop=F],apply(buf1[,-c(1,2,3)],2,as.numeric),
               check.names = F,stringsAsFactors = F,row.names = NULL)
  colnames(buf2)[2] <- '産業'
  buf3 <- buf2[!is.na(buf2[,grep('d.i',colnames(buf2),ignore.case = T)[1]]),]
  labor.excess.deficiency <- buf3
  setwd(buf.wd)
  returnList <-
    list('labor.excess.deficiency' = labor.excess.deficiency,
         'sheet.title' = sheet.title,
         'sheet.unit' = sheet.unit)
  return(returnList)
}
