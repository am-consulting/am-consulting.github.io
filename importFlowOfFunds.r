library(Nippon)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
baseURL <-
  'http://www.stat-search.boj.or.jp/info/'
fileName <- 'fof2_jp.zip'
download.file(paste0(baseURL,fileName),fileName,mode = 'wb')
unzip(fileName)
fileName <- 'ff_dl_fof_quarterly_jp.csv'
tmp0 <-
  read.table(file = fileName,sep = ',',header = T,as.is = T,check.names = F,stringsAsFactors = F)
tmp1 <- t(tmp0)
colnames(tmp1) <- sapply(tmp1[3,],zen2han)
tmp2 <- tmp1[-c(1:3),]
Date <-
  as.Date(paste0(as.numeric(substring(row.names(tmp2),1,4)),'-',
                 as.numeric(substring(row.names(tmp2),5,6))*3,'-1'))
tmp3 <-
  data.frame(Date,apply(tmp2,2,function(x)as.numeric(x)*10^-4),
             stringsAsFactors = F,check.names = F,row.names = NULL)
colnames(tmp3) <- paste0(colnames(tmp3),'(兆円)')
FlowOfFunds <- tmp3
