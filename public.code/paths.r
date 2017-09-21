user.name <- Sys.info()['user']
path.to.path.file <- paste0('C:/Users/',user.name,'/Desktop/pathToCSV/')
setwd(path.to.path.file)
file.name <- 'defaultPath.csv'
buf <-
  read.csv(file = file.name,header = F,skip = 0,
           stringsAsFactor = F,check.names = F,fileEncoding = 'utf-8')
path.to.r.functions <- paste0('C:/Users/',user.name,buf[7,1])
path.to.twitter.apps.csv <- paste0('C:/Users/',user.name,buf[6,1])
path.to.website <- paste0('C:/Users/',user.name,buf[5,1])
path.to.olive <- paste0('C:/Users/',user.name,buf[4,1])
path.to.io <- paste0('C:/Users/',user.name,buf[2,1])
