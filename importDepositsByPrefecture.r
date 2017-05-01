library(rvest);library(Nippon);library(XLConnect)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
htmlMarkup <-
  read_html(x = 'http://www.boj.or.jp/statistics/dl/depo/pref/index.htm/',
            encoding = 'utf8')
linkTable <-
  as.data.frame(htmlMarkup %>% html_nodes(xpath = "//table[@class = 'js-tbl']") %>% html_table())
linkTable$file <-
  htmlMarkup %>% html_nodes(xpath = "//table[@class = 'js-tbl']")  %>% html_nodes('a') %>% html_attr('href')
sheetTitle <- vector()
DepositsByPrefecture <- list()
for(rrr in seq(nrow(linkTable))){
  if(length(grep('xlsx',linkTable$file[rrr]))!=0){
    fileName <- gsub('.+/(.+\\.xlsx)','\\1',linkTable$file[rrr])
    download.file(url = paste0('http://www.boj.or.jp',linkTable$file[rrr]),
                  destfile = fileName, mode = 'wb')
    buf0 <-
      readWorksheetFromFile(paste0(pathOutput, fileName),
                            sheet = 1, check.names = F, header = F)
    buf1 <- buf0
    sheetTitle[rrr] <- zen2han(buf1[3,1])
    sheetUnit <- zen2han(buf1[5,ncol(buf1)])
    tmp <- NA
    objRow2 <- 8
    for(ccc in seq(ncol(buf1))){
      if(!is.na(buf1[objRow2,ccc])){tmp <- buf1[objRow2,ccc]}
      if(is.na(buf1[objRow2-1,ccc])){buf1[objRow2,ccc] <- tmp}
    }
    tmp <- NA
    objRow1 <- 7
    for(ccc in seq(ncol(buf1))){
      if(!is.na(buf1[objRow1,ccc])){tmp <- buf1[objRow1,ccc]}
      buf1[objRow1,ccc] <- tmp
    }
    objRow3 <- 9
    objRow4 <- 10
    colnames(buf1) <-
      paste0(sapply(gsub('\n|:na|','',
                         paste0(buf1[objRow1,],':',buf1[objRow2,],':',buf1[objRow3,],':',buf1[objRow4,]),
                         ignore.case = T),zen2han),sheetUnit)
    colnames(buf1) <-
      gsub(':[a-z| ]+','',colnames(buf1),ignore.case = T)
    buf2 <- buf1[-c(1:grep('北海道',buf1[,1])-1),]
    buf3 <- buf2[!is.na(buf2[,2]),]
    buf4 <- buf3[,-grep('[a-z]+',buf3[1,],ignore.case = T)]
    buf4[,-1] <- data.frame(apply(buf4[,-1],2,function(x) as.numeric(gsub(',','',x))))
    colnames(buf4)[1] <-
      gsub('\\(.+\\)','',colnames(buf4)[1])
    print(colnames(buf4))
    DepositsByPrefecture[[rrr]] <- buf4
  }
}
