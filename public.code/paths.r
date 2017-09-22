user.name <- Sys.info()['user']
path.to.path.file <- paste0('C:/Users/',user.name,'/Desktop/pathToCSV/')
setwd(path.to.path.file)
file.name <- 'defaultPath.csv'
buf <-
  read.csv(file = file.name,header = F,skip = 0,
           stringsAsFactor = F,check.names = F,fileEncoding = 'utf-8')
for(rrr in seq(nrow(buf))){
  tmp <- buf[rrr,1]
  target <- gsub('.+/([^/]+)','\\1',gsub('\\/$','',tmp))
  assign(paste0('path.to.',target),paste0('C:/Users/',user.name,buf[rrr,1]))
}
