library(XLConnect);library(Nippon);library(rvest)
htmlMarkup <-
  read_html(x = 'http://www.boj.or.jp/statistics/boj/fm/juqp/index.htm/',
            encoding = 'utf8')
linkList <-
  htmlMarkup %>% html_nodes(xpath = "//table[@class = 'js-tbl']") %>% html_nodes('tr')
xlsLink <-
  linkList[grep('.xls',linkList)] %>% html_nodes('a') %>% html_attr('href')
xlsFile <-
  gsub('.+/([^/]+.xlsx)','\\1',xlsLink)
targetURL <-
  paste0('http://www.boj.or.jp',xlsLink)
sheetTitle <- sheetUnit <- vector()
changesCurrentAccount <- list()
for(iii in seq(length(targetURL))){
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
download.file(url = targetURL[iii],
              destfile = xlsFile[iii], mode = 'wb')
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, xlsFile[iii]),
                        sheet = 1, check.names = F, header = F)
buf1 <- buf0
sheetTitle[iii] <- zen2han(buf1[5,1])
sheetUnit[iii] <- zen2han(buf1[10,6])
keyWork <- '銀行券要因'
objCol0 <- which(apply(buf1,2,function(x)(length(grep(paste0(keyWork,'$'),x))))!=0)
keyWork <- '資金過不足'
objRow1 <- which(apply(buf1,1,function(x)(length(grep(paste0(keyWork,'$'),x))))!=0)
keyWork <- '<前年比>'
objRow0 <- which(apply(buf1,1,function(x)(length(grep(paste0(keyWork,'$'),x))))!=0)
objCol1 <- which(apply(buf1,2,function(x)(length(grep(paste0(keyWork,'$'),x))))!=0)
objDF0 <- buf1[objRow0:objRow1,objCol0:objCol1]
colnames(objDF0) <- objDF0[1,]
objDF1 <- objDF0[-1,]
tmp <- NA
for(rrr in 1:nrow(objDF1)){
  if(!is.na(objDF1[rrr,1])){tmp <- objDF1[rrr,1]}
  objDF1[rrr,1] <- tmp
}
objDF1[,1] <-
  sapply(gsub(':na','',paste0(objDF1[,1],':',objDF1[,2]),ignore.case = T),zen2han)
objDF2 <- objDF1[,-2]
colnames(objDF2)[2:4] <-
  paste0(colnames(objDF2)[2:4],sheetUnit[iii])
colnames(objDF2)[1] <- sheetTitle[iii]
colnames(objDF2) <-
  sapply(colnames(objDF2),function(x)zen2han(gsub('\\s','',x)))
objDF2[,-1] <-
  data.frame(apply(objDF2[,-1],2,function(x)as.numeric(gsub(',','',x))))
colnames(objDF2) <- gsub('<|>','',colnames(objDF2))
colnames(objDF2) <- gsub('─',':',colnames(objDF2))
# Sources of Changes in Current Account Balances at the Bank of Japan (Projections)
changesCurrentAccount[[iii]] <- objDF2
print(changesCurrentAccount[[iii]])
tmp <-
  gsub('[^0-9]+([0-9]+)年([0-9]+)月.+','\\1\\2',sheetTitle[iii])
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = changesCurrentAccount[[iii]],dataType = 2,
                     csvFileName = paste0('SourcesOfChangesInCurrentAccountBalancesAtTheBankOfJapan_',
                                          tmp)
                     )
# csv出力パート
}
