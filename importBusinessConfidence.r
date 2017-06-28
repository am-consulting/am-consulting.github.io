library(rvest)
library(Nippon)
targetURL <-
  'http://www.chusho.meti.go.jp/koukai/chousa/keikyo/index_kekka.htm'
htmlMarkup <-
  read_html(x = targetURL,encoding = 'shift_jis')
csvList <-
  htmlMarkup %>% html_nodes(xpath = "//table[@class = 'sei2']") %>% html_nodes('tr') %>%
  html_nodes('a') %>% html_attr('href')
businessConfidence <- list()
sheetTitle <- vector()
for(iii in seq(length(csvList))){
  buf0 <-
    read.csv(file = paste0('http://www.chusho.meti.go.jp/koukai/chousa/keikyo/',csvList[iii]),
             header = F,stringsAsFactors = F,na.strings = '')
  buf1 <- buf0
  objCol1 <- grep('業種',buf1[,1])[1]
  if(is.na(objCol1)){objCol1 <- grep('項目内容',buf1[,1])[1]+1}
  objCol2 <- which(!is.na(as.numeric(buf1[,1])))[1]
  for(rrr in objCol1:(objCol2-1)){
    tmp <- NA
    for(ccc in 1:ncol(buf1)){
      if(!is.na(buf1[rrr,ccc])){tmp <- buf1[rrr,ccc]}
      buf1[rrr,ccc] <- tmp
    }
  }
  cnt <- 1
  for(rrr in objCol1:(objCol2-1)){
    if(cnt==1){colN <- buf1[rrr,]}else{colN <- paste0(colN,':',buf1[rrr,])}
    cnt <- cnt + 1
  }
  colnames(buf1) <- sapply(gsub(':NA|NA:','',colN),zen2han)
  for(rrr in 1:objCol1){
    if(rrr==1){sheetTitle0 <- buf1[rrr,1]}else{sheetTitle0 <- paste0(sheetTitle0,'-',buf1[rrr,1])}
  }
  sheetTitle[iii] <-
    sapply(gsub('\\s','',sheetTitle0),zen2han)
  buf2 <- buf1[-c(1:(objCol2-1)),]
  colnames(buf2)[1:2] <- c('年','期')
  row.names(buf2) <- NULL
  buf2[,-2] <- apply(buf2[,-2],2,as.numeric)
  buf2[,2] <- sapply(buf2[,2],zen2han)
  print(sheetTitle[iii])
  print(tail(buf2[,c(1:3)],3))
  businessConfidence[[iii]] <- buf2
}
