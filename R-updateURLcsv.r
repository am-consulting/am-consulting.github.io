fun_updateURLcsv <- function(){
  fileName <-
    'defaultPath.csv'
  username <-
    Sys.info()['user']
  pathToFile <-
    paste0('C:/Users/', username,'/Desktop/pathToCSV/')
  setwd(pathToFile)
  buf000 <-
    read.csv(fileName,header = F,skip = 0,stringsAsFactor = F,check.names = F,fileEncoding = 'utf-8')
  pathOutput <-
    paste0("C:/Users/", username, buf000[2,1],'csv/')
  setwd(pathOutput)
  fileName <-
    dir(pathOutput)[grep('knowledgevault',dir(pathOutput),ignore.case = T)]
  tmp0 <-
    read.table(fileName, sep = ',', fileEncoding = 'utf8', header = T)
  buf <-
    tmp0
  buf[,1] <-
    gsub(',','、',buf[,1])
  buf[,grep('title',colnames(buf),ignore.case = T)] <-
    paste0('<a href="',buf[,grep('url',colnames(buf),ignore.case = T)],
           '" target="_blank">',
           buf[,grep('title',colnames(buf),ignore.case = T)],
           '</a>')
  buf <-
    buf[,-grep('url',colnames(buf),ignore.case = T)]
  buf <-
    data.frame(`No.`=seq(1,nrow(buf)),buf,check.names = F,stringsAsFactors = F)
  fileList <-
    paste0(paste0('C:/Users/',
                  username,
                  buf000[2,1],
                  'charts/'),
           gsub('http.+/(.+.html)','\\1',tmp0[,3]))
  timeStamp <-
    as.POSIXct(sapply(fileList,function(x)file.info(path = x)$mtime),origin = "1970-01-01")
  buf$TimeStamp <-
    timeStamp
  buf <-
    buf[order(buf$TimeStamp,decreasing = T),]
  buf$`No.` <- seq(nrow(buf))
  setwd(pathOutput)
  write.csv(x = buf[,c(1,2,4)],
            file = "urlList.csv",
            quote = F,
            row.names = F,
            append = F,
            fileEncoding = 'utf8',
            na = "-")
}
