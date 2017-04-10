library (RCurl);library(XLConnect);library(rvest);library(Nippon)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
htmlMarkup <-
  read_html('http://www.chusho.meti.go.jp/koukai/chousa/tousan/index.htm',
            encoding = "cp932")
linkList <-
  htmlMarkup %>% html_nodes(xpath = "//div//a") %>% html_attr("href")
xlsxList <-
  linkList[grep('\\.xls', linkList)]
fileName <-
  xlsxList[grep(max(substring(xlsxList,1,6)),xlsxList)]
download.file(paste0('http://www.chusho.meti.go.jp/koukai/chousa/tousan/', fileName),
              fileName,
              mode = 'wb')
sheetTitle <- vector()
# sheet1
sheetNo <- 1
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = sheetNo, check.names = F, header = F)
unitText <- zen2han(buf0[2,10])
sheetTitle[sheetNo] <-
  zen2han(gsub('\\s','',buf0[1,1]))
sheetTitle[sheetNo] <-
  gsub('金額',paste0('金額',unitText),sheetTitle[sheetNo])
objColumn <-
  c(grep('年',buf0[,2]),grep('～',buf0[,3]))
buf1 <-
  buf0[-objColumn,]
buf2 <-
  buf1[grep('月',buf1[,4]),]
buf2[,1] <-
  as.numeric(gsub('年','',buf2[,1])) + 1988
tmp <- NA
for(rrr in 1:nrow(buf2)){
  if(!is.na(buf2[rrr,1])){tmp <- buf2[rrr,1]}
  buf2[rrr,1] <- tmp
}
buf2[,1] <-
  as.Date(paste0(buf2[,1],'-',as.numeric(gsub('月','',buf2[,4])),'-1'))
buf2[,-1] <-
  apply(buf2[,-1],2,function(x) gsub('△','-',x))
buf2[,-1] <-
  apply(buf2[,-1],2,function(x) as.numeric(gsub(',|\\s','',x)))
tmp <- NA
for(ccc in 1:ncol(buf1)){
  if(!is.na(buf1[3,ccc])){tmp <- gsub('\\s','',buf1[3,ccc])}
  buf1[3,ccc] <- tmp
}
colnames(buf2) <-
  gsub('na','',paste0(buf1[3,],':',
                      gsub('\\s','',buf1[4,]),':',
                      sapply(gsub('\\s','',paste0(buf1[5,],buf1[6,])),zen2han)),ignore.case = T)
colnames(buf2)[1] <- 'Date'
colnames(buf2) <- gsub('::',':',colnames(buf2))
buf3 <-
  buf2[,apply(buf2,2,function(x)sum(is.na(x))) != nrow(buf2)]
colnames(buf3)[-1] <-
  paste0(sheetTitle[sheetNo],':',colnames(buf3)[-1])
assign('bankruptcyCase',buf3,envir = .GlobalEnv)
# sheet4
sheetNo <- 4
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = sheetNo, check.names = F, header = F)
sheetTitle[sheetNo] <-
  zen2han(gsub('\\s','',buf0[1,1]))
objColumn <-
  grep('月',buf0[,1])
buf1 <-
  buf0[objColumn,]
buf2 <-
  buf1[-grep('～',buf1[,1]),]
tmp <-
  gsub('\\s','',buf2[1,1])
yyyy <-
  as.numeric(substring(tmp,1,(regexpr('年',tmp)-1))) + 1988
mm <-
  as.numeric(substring(tmp,(regexpr('年',tmp)+1),(nchar(tmp)-1)))
buf2[,1] <-
  seq(as.Date(paste0(yyyy,'-',mm,'-1')),by = '1 month',length.out = nrow(buf2))
tmp <- NA
for(ccc in 1:ncol(buf0)){
  if(!is.na(buf0[3,ccc])){tmp <- gsub('\\s','',buf0[3,ccc])}
  buf0[3,ccc] <- tmp
}
colnames(buf2) <-
  sapply(paste0(buf0[3,],':',buf0[4,]),zen2han)
colnames(buf2)[1] <- 'Date'
buf3 <-
  buf2[apply(buf2,1,function(x)sum(is.na(x))) != ncol(buf2)-1,]
buf3[,-1] <-
  apply(buf3[,-1],2,function(x)as.numeric(gsub(',','',x)))
colnames(buf3)[-1] <-
  paste0(sheetTitle[sheetNo],':',colnames(buf3)[-1])
assign('bankruptcyCaseByCategory',buf3,envir = .GlobalEnv)
# sheet5
sheetNo <- 5
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = sheetNo, check.names = F, header = F)
sheetTitle[sheetNo] <-
  zen2han(gsub('\\s','',buf0[1,1]))
objColumn <-
  c(grep('年',buf0[,2]),grep('～',buf0[,3]))
buf1 <-
  buf0[-objColumn,]
buf2 <-
  buf1[grep('月',buf1[,4]),]
buf2[,1] <-
  as.numeric(gsub('年','',buf2[,1])) + 1988
tmp <- NA
for(rrr in 1:nrow(buf2)){
  if(!is.na(buf2[rrr,1])){tmp <- buf2[rrr,1]}
  buf2[rrr,1] <- tmp
}
buf2[,1] <-
  as.Date(paste0(buf2[,1],'-',as.numeric(gsub('月','',buf2[,4])),'-1'))
buf2[,-1] <-
  apply(buf2[,-1],2,function(x) as.numeric(gsub(',|△','',x)))
colnames(buf2) <-
  gsub('\\s','',paste0(substring(buf1[3,],regexpr('\n',buf1[3,])+1),substring(buf1[3,],1,regexpr('\n',buf1[3,])-1)))
colnames(buf2)[1] <-
  'Date'
buf3 <-
  buf2[,apply(buf2,2,function(x)sum(is.na(x))) != nrow(buf2)]
colnames(buf3)[-1] <-
  paste0(sheetTitle[sheetNo],':',colnames(buf3)[-1])
assign('bankruptcyCaseByReason',buf3,envir = .GlobalEnv)
assign('sheetTtiles',unlist(na.omit(sheetTitle)),envir = .GlobalEnv)
