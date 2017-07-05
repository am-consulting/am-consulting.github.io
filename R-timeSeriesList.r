fun_timeSeriesList <- function(tsTitle = tsTitle){
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
  if(length(grep(htmlName,targetHTML))==0){
    htmlMarkup <-
      read_html(x = targetHTML,encoding = 'utf8')
    htmlTitle <-
      htmlMarkup %>%
      html_nodes(xpath = "//div[@id = 'htmlTitle']") %>%
      html_text()
    htmlTitle <- gsub('\n|\r','',htmlTitle)
    timeStamp <- as.POSIXct(file.info(path = targetHTML)$mtime,origin = "1970-01-01")
  }else{
    htmlTitle <- tsTitle
    timeStamp <- Sys.time()
  }
  titleHTML[iii,1] <- iii
  titleHTML[iii,2] <- htmlTitle
  titleHTML[iii,3] <-
    paste0('<a href="http://knowledgevault.saecanet.com/charts/',
           targetHTML,'" target="_blank">Link</a>')
  titleHTML[iii,4] <- as.character(timeStamp)
}
iii <- iii + 1
if(length(grep(htmlName,titleHTML[,3]))==0){
  targetHTML <- paste0('am-consulting.co.jp-',htmlName,'.html')
  htmlTitle <- tsTitle
  timeStamp <- Sys.time()
  titleHTML[iii,1] <- iii
  titleHTML[iii,2] <- htmlTitle
  titleHTML[iii,3] <-
    paste0('<a href="http://knowledgevault.saecanet.com/charts/',
           targetHTML,'" target="_blank">Link</a>')
  titleHTML[iii,4] <- as.character(timeStamp)
}
titleTxt <-  gsub('(.+):([0-9]{4}-[0-9]{2})','\\1',titleHTML[,2])
dateTxt <- gsub('(.+):([0-9]{4}-[0-9]{2})','\\2',titleHTML[,2])
titleHTML[,2] <- titleTxt
titleHTML$Date <- dateTxt
colnames(titleHTML) <- c('No.','Title','Link','TimeStamp','Date')
titleHTML <- titleHTML[,c(1,2,5,3,4)]
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
