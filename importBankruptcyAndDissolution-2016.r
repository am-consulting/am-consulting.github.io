library(XLConnect)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
sheetTitle <- vector()
baseURL <-
  'http://www.chusho.meti.go.jp/pamflet/hakusyo/H28/h28/excel/'
fileName <-
  c('b1_2_06_01.xlsx','b1_2_06_02.xlsx')
for(iii in 1:length(fileName)){
  download.file(paste0(baseURL, fileName[iii]),fileName[iii], mode = 'wb')
  buf0 <-
    readWorksheetFromFile(paste0(pathOutput, fileName[iii]), sheet = 1, check.names = F, header = F)
  sheetTitle[iii] <- buf0[1,1]
  colnames(buf0) <- buf0[3,]
  buf0 <- buf0[-c(1:3),]
  buf0 <- apply(buf0,2,function(x)as.numeric(gsub(',','',x)))
  if(iii == 1){
    buf0[,1] <-
      rev(seq(tail(buf0[,1],1) + 2000,by = -1,length.out = nrow(buf0)))
    assign('bankruptcyCase', buf0, envir = .GlobalEnv)
  }
  if(iii == 2){
    buf0[,1] <- buf0[,1] + 2000
    assign('dissolutionCase', buf0, envir = .GlobalEnv)
  }
  buf1 <-
    data.frame(as.Date(paste0(buf0[,1],'-1-1')),buf0[,-1],check.names = F,stringsAsFactors = F,row.names = NULL)
  colnames(buf1)[1] <- 'Date'
  if(iii == 1){
    assign('bankruptcyCase', buf1, envir = .GlobalEnv)
  }
  if(iii == 2){
    assign('dissolutionCase', buf1, envir = .GlobalEnv)
  }
}
# http://www.chusho.meti.go.jp/pamflet/hakusyo/
# http://www.chusho.meti.go.jp/pamflet/hakusyo/H28/h28/index.html
# http://www.chusho.meti.go.jp/pamflet/hakusyo/H28/h28/html/b1_2_1_2.html
# http://www.chusho.meti.go.jp/pamflet/hakusyo/H28/h28/excel/b1_2_06_01.xlsx
# http://www.chusho.meti.go.jp/pamflet/hakusyo/H28/h28/excel/b1_2_06_02.xlsx
# http://www.chusho.meti.go.jp/koukai/chousa/tousan/index.htm
# http://www.chusho.meti.go.jp/koukai/chousa/index.html
# 2016年版中小企業白書・小規模企業白書をまとめました(平成28年4月22日)
