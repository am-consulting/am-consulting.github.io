fun_timeSeriesList <- function(){
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
  titleHTML[iii,1] <- iii
  titleHTML[iii,2] <- htmlTitle
  titleHTML[iii,3] <-
    paste0('<a href="http://knowledgevault.saecanet.com/charts/',
           targetHTML,'" target="_blank">Link</a>')
}
colnames(titleHTML) <- c('No.','Title','Link')
pathOutputTOcsv <-
  paste0("C:/Users/", userName, buf[2,1],'csv/')
setwd(pathOutputTOcsv)
write.csv(x = titleHTML,file = 'timeSeriesList.csv',
          quote = F,row.names = F,
          append = F,na = '',
          fileEncoding = 'UTF-8')
}
