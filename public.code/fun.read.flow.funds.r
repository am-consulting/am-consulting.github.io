fun.read.flow.funds <- function(load.library = F,path.to.folder = '/Desktop/R_Data_Write/'){
  if(load.library==T){lapply(c('Nippon'),require,character.only = T)}
  path.to.folder <- paste0('C:/Users/',Sys.info()['user'],path.to.folder)
  setwd(path.to.folder)
  base.url <- 'http://www.stat-search.boj.or.jp/info/'
  file.name <- 'fof2_jp.zip'
  Sys.sleep(1) # To prevent server overload
  download.file(paste0(base.url,file.name),file.name,mode = 'wb')
  csv.name <- gsub('\\./','',unzip(file.name)[grep('quarterly',unzip(file.name))])
  tmp0 <-
    read.table(file = csv.name,sep = ',',header = T,as.is = T,check.names = F,stringsAsFactors = F)
  tmp1 <- t(tmp0)
  colnames(tmp1) <- sapply(tmp1[3,],zen2han)
  tmp2 <- tmp1[-c(1:3),]
  Date <-
    as.Date(paste0(as.numeric(substring(row.names(tmp2),1,4)),'-',
                   as.numeric(substring(row.names(tmp2),5,6))*3,'-1'))
  tmp3 <-
    data.frame(Date,apply(tmp2,2,function(x)as.numeric(x)*10^-4),
               stringsAsFactors = F,check.names = F,row.names = NULL)
  colnames(tmp3)[-1] <- paste0(colnames(tmp3)[-1],'(兆円)')
  flow.of.funds <- tmp3
  return(flow.of.funds)
}
