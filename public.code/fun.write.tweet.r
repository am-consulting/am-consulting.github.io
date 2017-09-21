fun.write.tweet <- function(load.library = F,txt = '',lat = NULL,long = NULL,placeID = NULL,displayCoords = NULL,inReplyTo = NULL,mediaPath = NULL,bypassCharLimit = F){
  if(load.library==T){lapply(c('twitteR'),require,character.only = T)}
  buf.wd <- getwd()
  user.name <- Sys.info()['user']
  path.to.file <- paste0('C:/Users/',user.name,'/Desktop/pathToCSV/')
  setwd(path.to.file)
  file.name <- 'defaultPath.csv'
  buf <-
    read.csv(file = file.name,header = F,skip = 0,
             stringsAsFactor = F,check.names = F,fileEncoding = 'utf-8')
  twitter.app.info <-
    read.csv(file = paste0('C:/Users/',user.name,buf[6,1]),header = F,stringsAsFactors = F)
  setup_twitter_oauth(twitter.app.info[1,2],twitter.app.info[2,2],twitter.app.info[3,2],twitter.app.info[4,2])
  updateStatus(text = txt,lat = lat,long = long,placeID = placeID,displayCoords = displayCoords,
               inReplyTo = inReplyTo,mediaPath = mediaPath,bypassCharLimit = bypassCharLimit)
  setwd(buf.wd)
}
