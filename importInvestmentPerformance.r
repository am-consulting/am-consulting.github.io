library(XLConnect);library(Nippon);library(rvest)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
htmlMarkup <-
  read_html(x = 'http://www.jsda.or.jp/shiraberu/foreign/info4/index.html',
            encoding = 'utf8')
linkList <-
  htmlMarkup %>% html_nodes(xpath = "//div[@class = 'jsda_table01 jsda_table01_data']") %>%
  html_nodes('table') %>% html_nodes('tr')
sheetDate <-
  gsub('\n','',zen2han(gsub('(.+末).+','\\1',linkList[2] %>% html_text())))
xlsFile <-
  linkList[2] %>% html_nodes('a') %>% html_attr('href')
targetFile <- 1
targetURL <-
  paste0('http://www.jsda.or.jp/shiraberu/foreign/info4',gsub('^\\.','',xlsFile[targetFile]))
fileName <-
  gsub('.+/(.+.xls)','\\1',xlsFile[targetFile])
download.file(url = targetURL,
              destfile = fileName, mode = 'wb')
sheetName <-
  sapply(getSheets(loadWorkbook(fileName)),zen2han)
fundList <- list()
cnt <- 1
for(iii in seq(length(sheetName))){
  if(length(grep('債券MMF型|表紙|について|注意書き',sheetName[iii]))==0){
    buf0 <-
      readWorksheetFromFile(paste0(pathOutput, fileName),
                            sheet = sheetName[iii], check.names = F, header = F)
    buf1 <- buf0
    objRow1 <- 2
    objRow2 <- 3
    objRow3 <- 4
    objRow4 <- 5
    objCol1 <- grep('分配金込み',buf1[objRow1,])
    objCol2 <- grep('^設立年月日$|^ファンド名$|^投資顧問会社$',buf1[objRow2,])
    objCol3 <- grep('^備考$',buf1[objRow2,])
    buf2 <-
      buf1[,c(objCol2,objCol1:(objCol3-1))]
    tmp <- NA
    for(ccc in seq(ncol(buf2))){
      if(!is.na(buf2[objRow1,ccc])){tmp <- buf2[objRow1,ccc]}
      buf2[objRow1,ccc] <- tmp
    }
    tmp <- NA
    for(ccc in seq(ncol(buf2))){
      if(!is.na(buf2[objRow2,ccc])){tmp <- buf2[objRow2,ccc]}
      buf2[objRow2,ccc] <- tmp
    }
    colnames(buf2) <-
      gsub('na:|:na','',
           sapply(paste0(buf2[objRow1,],':',buf2[objRow2,],':',buf2[objRow3,],':',buf2[objRow4,]),zen2han),
           ignore.case = T)
    buf3 <- buf2[-c(1:objRow4),]
    buf3[,1] <- sapply(buf3[,1],zen2han)
    buf3[,2] <- sapply(buf3[,2],zen2han)
    buf3[,3] <- as.Date(gsub('\\.','-',buf3[,3]))
    buf3[,-c(1:3)] <- data.frame(apply(buf3[,-c(1:3)],2,as.numeric),check.names = F,stringsAsFactors = F)
    row.names(buf3) <- NULL
    buf4 <- buf3[,c(3,1,2,4:ncol(buf3))]
    print(head(buf4))
    fundList[[cnt]] <- buf4
    cnt <- cnt + 1
  }
}
