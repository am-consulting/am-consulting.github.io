library(rvest);library(Nippon)
htmlMarkup <-
  read_html(x = 'http://www.taisyaku.jp/search/result/index/1/',
            encoding = 'utf8')
dlList <-
  htmlMarkup %>% html_nodes(xpath = "//div[@class = 'dl-list']")
aList <-
  dlList %>% html_nodes('a')
fileList <-
  cbind(aList %>% html_text(),aList %>% html_attr('href'))
fileTitle <- fileSource <- fileUnit <- vector()
stockBalance <- list()
objTable <- fileList[grep('貸株残高',fileList[,1]),]
for(iii in 1:nrow(objTable)){
  buf0 <-
    read.csv(file = objTable[iii,2],header = F,na.strings = '',stringsAsFactors = F)
  buf1 <- buf0
  objRow <- grep('申込日',buf1[,1])
  buf2 <- buf1[,!is.na(buf1[objRow,])]
  colnames(buf2) <-
    sapply(buf2[objRow,],zen2han)
  fileTitle[iii] <- buf2[1,1]
  fileSource[iii] <- buf2[2,1]
  fileUnit[iii] <- buf2[3,1]
  buf3 <- buf2[-(1:objRow),]
  buf3[,1] <- as.Date(buf3[,1])
  buf3[,5:ncol(buf3)] <-
    data.frame(apply(buf3[,5:ncol(buf3)],2,as.numeric ),check.names = F,stringsAsFactors = F)
  buf3[,3] <- sapply(buf3[,3],zen2han)
  stockBalance[[iii]] <- buf3
  print(head(stockBalance[[iii]]))
}
