fun_updateURLcsv.olive <- function(){
  fileName <- 'defaultPath.csv'
  username <- Sys.info()['user']
  pathToFile <- paste0('C:/Users/', username,'/Desktop/pathToCSV/')
  setwd(pathToFile)
  buf000 <-
    read.csv(fileName,header = F,skip = 0,stringsAsFactor = F,check.names = F,fileEncoding = 'utf-8')
  pathOutput <- paste0("C:/Users/", username, buf000[2,1],'csv/')
  setwd(pathOutput)
  fileName <-
    dir(pathOutput)[grep('knowledgevaultURL_List.olive',dir(pathOutput),ignore.case = T)]
  tmp0 <- read.table(fileName, sep = ',', fileEncoding = 'utf8', header = T)
  buf <- tmp0
  buf[,1] <- gsub(',','、',buf[,1])
  buf[,grep('title',colnames(buf),ignore.case = T)] <-
    paste0('<a href="',buf[,grep('url',colnames(buf),ignore.case = T)],
           '" target="_blank">',
           buf[,grep('title',colnames(buf),ignore.case = T)],
           '</a>')
  fileList <-
    paste0(paste0('C:/Users/',username,buf000[4,1]),gsub('http.+/(.+.html)','\\1',buf$URL))
  timeStamp <-
    as.POSIXct(sapply(fileList,function(x)file.info(path = x)$mtime),origin = "1970-01-01")
  buf$TimeStamp <- timeStamp
  buf <-
    buf[,-grep('url',colnames(buf),ignore.case = T),drop=F]
  buf <-
    data.frame(`No.`=seq(1,nrow(buf)),buf,check.names = F,stringsAsFactors = F)
  if(exists('htmlName')){
    buf[grep(paste0('am-consulting.co.jp-',htmlName,'.html'),buf[,2]),3] <- Sys.time()
  }
  buf <- buf[order(buf$TimeStamp,decreasing = T),]
  buf$`No.` <- seq(nrow(buf))
  setwd(pathOutput)
  write.csv(x = buf,file = "urlList.olive.csv",quote = F,row.names = F,append = F,
            fileEncoding = 'utf8',na = "-")
}
