library(Nippon)
csvFile <- c('h01-1.csv','h02-1.csv','h03-1.csv','h04-1.csv','h05-1.csv',
             'h06-1.csv','h07-1.csv','h08-1.csv','h09-1.csv','h10-1.csv',
             'h11-1.csv','h12-1.csv','h13-1.csv','h14-1.csv','h15-1.csv',
             'h16-1.csv','h17-1.csv','h18-1.csv')
baseURL <- 'http://survey.gov-online.go.jp/h28/h28-shakai/zh/'
for(iii in seq(length(csvFile))){
  tmp0 <-
    read.csv(file = paste0(baseURL,csvFile[iii]),
             header = F,quote = "\"",stringsAsFactors = F,na.strings = c(""))
  tmp <- tmp0
  sheetTitle <- gsub('表.+[0-9]+','',zen2han(tmp[1,1]))
  bufRow <- which(tmp[,2]=='該当者数')
  colnames(tmp) <-
    sapply(paste0(sheetTitle,':',tmp[bufRow,],'(',tmp[bufRow+1,],')'),zen2han)
  tmp <- tmp[-c(1:(bufRow+1)),]
  colnames(tmp)[1] <- '属性'
  tmp[,1] <- gsub('\\s','',sapply(tmp[,1],zen2han))
  buf <- NA
  for(rrr in 1:nrow(tmp)){
    if(is.na(tmp[rrr,2])){buf <- tmp[rrr,1]}
    if(!is.na(buf)){tmp[rrr,1] <- paste0(buf,':',tmp[rrr,1])}
  }
  buf <- NA
  for(rrr in 1:nrow(tmp)){
    if(length(grep('\\(男性\\)',tmp[rrr,1]))!=0){
      buf <- '(男性)'
    }else if(length(grep('\\(女性\\)',tmp[rrr,1]))!=0){
      buf <- '(女性)'
    }
    if(!is.na(buf)){
      if(length(grep('歳',tmp[rrr,1]))!=0){
        tmp[rrr,1] <- paste0(buf,':',tmp[rrr,1])
      }
    }
  }
  tmp <- tmp[!is.na(tmp[,2]),]
  row.names(tmp) <- NULL
  if(iii == 1){
    tmp$No <- seq(nrow(tmp))
    allData <- tmp
  }else{
    allData <- merge(allData,tmp,by='属性',all=T)
  }
}
NoColumn <- grep('no',colnames(allData),ignore.case = T)
bufDF <-
  cbind(No = allData[,NoColumn],allData[,-NoColumn])
bufDF <- bufDF[order(bufDF[,1],decreasing = F),]
bufDF[,-c(1,2)] <-
  apply(bufDF[,-c(1,2)],2,function(x)as.numeric(gsub(',','',x)))
row.names(bufDF) <- NULL
assign('socialConsciousH28',bufDF)
