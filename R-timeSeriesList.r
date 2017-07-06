fun_timeSeriesList <- function(tsTitle = 0,htmlName = 0){
library(rvest)
userName <- Sys.info()['user']
pathToFile <-
  paste0('C:/Users/', userName,'/Desktop/pathToCSV/')
setwd(pathToFile)
fileName <- 'defaultPath.csv'
buf <-
  read.csv(file = fileName,header = F,skip = 0,stringsAsFactor = F,
           check.names = F,fileEncoding = 'utf-8',quote = "\"")
pathToCharts <-
  paste0("C:/Users/", userName, buf[2,1],'charts/')
setwd(pathToCharts)
htmlList <- dir(pathToCharts)
objHTML <- grep('[^-]+-[0-9]{5}.html',htmlList)
titleHTML <- data.frame()
for(iii in seq(length(objHTML))){
  targetHTML <- htmlList[objHTML[iii]]
  htmlMarkup <-
    read_html(x = targetHTML,encoding = 'utf8')
  htmlTitle <-
    htmlMarkup %>%
    html_nodes(xpath = "//div[@id = 'htmlTitle']") %>%
    html_text()
  htmlTitle <- gsub('\n|\r','',htmlTitle)
  timeStamp <- as.POSIXct(file.info(path = targetHTML)$mtime,origin = "1970-01-01")
  titleHTML[iii,1] <- iii
  titleTxt <- gsub('(.+):([0-9]{4}-[0-9]{2})','\\1',htmlTitle)
  dateTxt <- gsub('(.+):([0-9]{4}-[0-9]{2})','\\2',htmlTitle)
  titleHTML[iii,2] <-
    paste0('<a href="http://knowledgevault.saecanet.com/charts/',
           targetHTML,'" target="_blank">',titleTxt,'</a>')
  titleHTML[iii,3] <- dateTxt
  titleHTML[iii,4] <- as.character(timeStamp)
}
if(tsTitle!=0 & htmlName!=0){
  htmlTitle <- tsTitle
  timeStamp <- Sys.time()
  titleTxt <- gsub('(.+):([0-9]{4}-[0-9]{2})','\\1',htmlTitle)
  dateTxt <- gsub('(.+):([0-9]{4}-[0-9]{2})','\\2',htmlTitle)
  if(length(grep(htmlName,titleHTML[,2]))==0){
    iii <- iii + 1
    targetHTML <- paste0('am-consulting.co.jp-',htmlName,'.html')
    titleHTML[iii,1] <- iii
    titleHTML[iii,2] <-
      paste0('<a href="http://knowledgevault.saecanet.com/charts/',
             targetHTML,'" target="_blank">',titleTxt,'</a>')
    titleHTML[iii,3] <- dateTxt
    titleHTML[iii,4] <- as.character(timeStamp)
  }else{
    titleHTML[grep(htmlName,titleHTML[,2]),3] <- dateTxt
    titleHTML[grep(htmlName,titleHTML[,2]),4] <- as.character(timeStamp)
  }
}
colnames(titleHTML) <- c('No.','Title','Date','TimeStamp')
titleHTML <-
  titleHTML[order(titleHTML$TimeStamp,decreasing = T),]
titleHTML[,1] <- seq(nrow(titleHTML))
pathOutputTOcsv <-
  paste0("C:/Users/", userName, buf[2,1],'csv/')
setwd(pathOutputTOcsv)
write.csv(x = titleHTML,file = 'timeSeriesList.csv',
          quote = F,row.names = F,
          append = F,na = '',
          fileEncoding = 'UTF-8')
}
