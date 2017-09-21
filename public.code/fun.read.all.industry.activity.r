fun.read.all.industry.activity <- function(load.library = F,path.to.folder = '/Desktop/R_Data_Write/'){
  # 全産業活動指数
  if(load.library==T){lapply(c('XLConnect','Nippon','lubridate'),require,character.only = T)}
  buf.wd <- getwd()
  path.to.folder <- paste0('C:/Users/',Sys.info()['user'],path.to.folder)
  setwd(path.to.folder)
  file.name <- c('b2010_zsmj.xls','b2010_zomj.xls')
  base.url <- 'http://www.meti.go.jp/statistics/tyo/zenkatu/result-2/xls/'
  sheet.title <- vector()
  for(iii in 1:2){
    download.file(paste0(base.url,file.name[iii]),file.name[iii],mode = "wb")
    buf0 <-
      readWorksheetFromFile(file.name[iii],sheet = 1,check.names = F,header = F)
    sheet.title[iii] <- zen2han(buf0[1, 1])
    buf0[,2] <- sapply(paste0(gsub('\\s','',buf0[,2]),'(ウエイト:', buf0[,3],')'),zen2han)
    buf1 <- buf0[-c(1,2),-c(1,3)]
    buf2 <- t(buf1)
    buf2[,1] <-
      paste0(substring(buf2[,1],1,4),'-',substring(buf2[,1],5,6),'-01')
    colnames(buf2) <- buf2[1,]
    buf2 <- buf2[-1,]
    buf3 <-
      data.frame(Date=as.Date(buf2[,1]),apply(buf2[,-1],2,as.numeric),
                 stringsAsFactors = F,check.names = F,row.names = NULL)
    if(iii==1){colnames(buf3)[-1] <- paste0(colnames(buf3)[-1],':季節調整値')}
    if(iii==2){colnames(buf3)[-1] <- paste0(colnames(buf3)[-1],':原数値')}
    switch(iii,
           assign('all.industry.activity.SA',buf3),
           assign('all.industry.activity.NSA',buf3))
  }
  setwd(buf.wd)
  returnList <-
    list('all.industry.activity.SA' = all.industry.activity.SA,
         'all.industry.activity.NSA' = all.industry.activity.NSA,
         'sheet.title',sheet.title)
  return(returnList)
}
