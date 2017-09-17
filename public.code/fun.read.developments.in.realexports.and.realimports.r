fun.read.developments.in.realexports.and.realimports <- function(load.library = F,copy.to.clipboard = F){
  if(load.library==T){lapply(c('Nippon','XLConnect'),require,character.only = T)}
  user.name <- Sys.info()['user']
  path.to.folder <- paste0('C:/Users/',user.name,'/Desktop/R_Data_Write/')
  setwd(path.to.folder)
  base.url <- 'http://www.boj.or.jp/research/research_data/reri/'
  file.name <- 'reri.xlsx'
  download.file(paste0(base.url,file.name),file.name, mode = 'wb')
  buf0 <- readWorksheetFromFile(file = file.name,sheet = 1,check.names = F,header = F)
  colnames(buf0) <- sapply(paste0(buf0[1,],':',buf0[2,]),zen2han)
  buf0 <-buf0[-c(1:4),]
  tmp0 <- which(apply(buf0,2,function(x){sum(is.na(x))}) == nrow(buf0))
  if(length(tmp0) != 0){buf0 <- buf0[,-tmp0]}
  colnames(buf0)[1] <- 'Date'
  buf0[,-1] <-apply(buf0[,-1],2,as.numeric)
  buf0[,1] <- as.Date(buf0[,1],tz = 'Asia/Tokyo')
  row.names(buf0) <- NULL
  realexports.realimports.01 <- buf0
  buf0 <- readWorksheetFromFile(file = file.name,sheet = 2,check.names = F,header = F)
  ccc <- grep('その他',buf0[2,])[1]
  buf0[2,ccc] <- paste0(buf0[2,ccc],'国･地域')
  colnames(buf0) <- sapply(paste0(buf0[1,],':',buf0[2,],':',buf0[3,]),zen2han)
  buf0 <- buf0[-c(1:6),]
  tmp0 <- which(apply(buf0,2,function(x){sum(is.na(x))}) == nrow(buf0))
  if(length(tmp0) != 0){buf0 <- buf0[,-tmp0]}
  if(!is.null(nrow(buf0))){
    colnames(buf0)[1] <- 'Date'
    buf0[,-1] <- apply(buf0[,-1],2,as.numeric)
    buf0[,1] <- as.Date(buf0[,1],tz = 'Asia/Tokyo')
    colnames(buf0) <- gsub('NA:','',colnames(buf0))
    realexports.realimports.02 <- buf0
    allData <-
      merge(realexports.realimports.01,realexports.realimports.02,by = 'Date',all = T)
    if(copy.to.clipboard==T){
      write.table(allData, "clipboard-16384", sep = "\t", row.names = F, col.names = T, quote = F)
    }
    developments.in.realexports.and.realimports <- allData
  }else{
    developments.in.realexports.and.realimports <- RealExportsAndRealImports01
  }
  return(developments.in.realexports.and.realimports)
}
