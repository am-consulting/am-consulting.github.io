# http://www.stat-search.boj.or.jp/info/dload.html
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
# csv出力パート
library(Nippon)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
zipFiles <-
  c('bp_m_jp.zip','regbp_q_jp.zip','qiip_q_jp.zip','iip_cy_jp.zip')
baseURL <- 'http://www.stat-search.boj.or.jp/info/'
for(iii in seq(length(zipFiles))){
  setwd(pathOutput)
  download.file(url = paste0(baseURL,zipFiles[iii]),zipFiles[iii],mode = 'wb')
  unzip(zipFiles[iii])
  buf0 <-
    read.csv(file = paste0(pathOutput,gsub('\\.zip','\\.csv',zipFiles[iii])),
             header = F,check.names = F,stringsAsFactors = F,na.strings = '')
  if(length(grep('_cy_',zipFiles[iii]))==0){
    buf0[1,] <- gsub('([0-9]{4})([0-9]{2})','\\1-\\2-01',buf0[1,])
  }else{
    buf0[1,] <- gsub('([0-9]{4})','\\1-01-01',buf0[1,])
  }
  if(length(grep('_q_',zipFiles[iii]))!=0){
    buf0[1,] <-
      paste0(gsub('([0-9]+)-([0-9]+)-([0-9]+)','\\1',buf0[1,]),'-',
             as.numeric(gsub('([0-9]+)-([0-9]+)-([0-9]+)','\\2',buf0[1,]))*3,'-',
             gsub('([0-9]+)-([0-9]+)-([0-9]+)','\\3',buf0[1,]))
    buf0[1,grep('na',buf0[1,],ignore.case = T)] <- NA
  }
  buf1 <- t(buf0)
  objCol <- tail(which(is.na(buf1[,1])),1)
  colnames(buf1) <- sapply(paste0(buf1[objCol-1,],':',buf1[objCol,]),zen2han)
  buf2 <- buf1[-c(1:objCol),]
  buf3 <-
    data.frame(Date = as.Date(buf2[,1]),
               apply(buf2[,-1],2,as.numeric),
               check.names = F,stringsAsFactors = F,row.names = NULL)
  switch(iii,
         KokusaiShuushiM <- buf3,
         ChikibetsuKokusaiShuushiQ <- buf3,
         TaigaiShisanFusaiQ <- buf3,
         TaigaiShisanFusaiY <- buf3)
  switch(iii,
         csvFileName <- '国際収支統計',
         csvFileName <- '地域別国際収支_四半期',
         csvFileName <- '本邦対外資産負債残高_四半期_対外債務',
         csvFileName <- '本邦対外資産負債残高_年次')
  fun_writeCSVtoFolder(objData = buf3,dataType = 1,csvFileName = csvFileName)
}
remove('buf0','buf1','buf2','buf3')
