fun_downloadESTAT <- function(bid = '000001006005', cycode = '1', dateS = '2016-1-1', dateE = '2016-1-1', objXLS = 1){
  library(rvest)
  urlToESTAT <-
    paste0('http://www.e-stat.go.jp/SG1/estat/OtherList.do?bid=',bid,'&cycode=',cycode)
  htmlMarkup0 <-
    read_html(urlToESTAT,
              encoding = "utf-8")
  hrefList0 <-
    htmlMarkup0 %>% html_nodes(xpath = '//table//tr//a') %>% html_attr("href")
  hrefList0 <-
    paste0('http://www.e-stat.go.jp/SG1/estat/', gsub('\\./','',hrefList0))
  dateTable0 <-
    htmlMarkup0 %>% html_nodes(xpath = '//table') %>% html_table()
  dateTable1 <-
    apply(dateTable0[[1]],2,function(x)gsub('\n|\t|年|月|:','',x))
  dateTable2 <-
    dateTable1[,apply(dateTable1,2,function(x)sum(is.na(x))) != nrow(dateTable1)]
  dateTable2 <-
    apply(dateTable2,2,as.numeric)
  dateTable3 <-
    apply(dateTable2[,-1],2,function(x)paste0(dateTable2[,1],'-',x,'-1'))
  dateList <-
    as.vector(t(dateTable3))
  dateList <-
    dateList[-grep('na',dateList,ignore.case = T)]
  if(length(dateList) == length(hrefList0)){
    linkList0 <- data.frame(as.Date(dateList),hrefList0,stringsAsFactors = F)
    linkList <- linkList0[order(linkList0[,1]),]
  }else{
    linkList <- data.frame()
  }
  colnames(linkList) <- c('Date','URL')
  username <-
    Sys.info()['user']
  pathOutput <-
    paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
  setwd(pathOutput)
  objlinkList <-
    subset(linkList, as.Date(dateS) <= linkList[,1] & linkList[,1] <= as.Date(dateE))
  for(rrr in seq(nrow(objlinkList))){
    htmlMarkup0 <-
      read_html(objlinkList[rrr,2],
                encoding = "utf-8")
    hrefList0 <-
      htmlMarkup0 %>% html_nodes(xpath = '//table//tr//a') %>% html_attr("href")
    tmpURL <-
      hrefList0[grep('xlsdl',hrefList0,ignore.case = T)][objXLS]
    dataURL <-
      paste0('http://www.e-stat.go.jp/SG1/estat/', gsub('\\./','',tmpURL))
    download.file(url = dataURL,
                  destfile = paste0(objlinkList[rrr,1],'.xls'),
                  mode = 'wb')
  }
}
