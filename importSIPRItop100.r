library(XLConnect)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <-
  'SIPRI-Top-100-2002-2015.xlsx'
download.file(url = paste0('https://www.sipri.org/sites/default/files/',fileName),
              destfile = fileName,
              mode = 'wb')
armSales <- list()
sheetTitle <- sheetUnit <- sheetYear <- vector()
cnt <- 0
for(sss in 2002:2015){
  if(sss == 2002|sss == 2005|sss == 2006|sss == 2007|sss == 2009|sss == 2010){
    sheet <- paste0(sss,' ')
  }else{
    sheet <- sss
  }
  buf0 <-
    readWorksheetFromFile(file = paste0(pathOutput, fileName),
                                     sheet = as.character(sheet),
                                     check.names = F,
                                     header = F)
  buf1 <- buf0[!is.na(buf0[,3]),]
  colnames(buf1) <- buf1[1,]
  buf2 <- buf1[-1,]
  buf3 <-
    buf2[,-grep('^rank|^note', colnames(buf2), ignore.case = T)]
  buf3[,-c(1,2)] <- apply(buf3[,-c(1,2)],2,as.numeric)
  buf4 <-
    buf3[,apply(buf3,2,function(x)sum(is.na(x))!=nrow(buf3))]
  txt <-
    regexpr('\\s\\*note.+|\\snote.+', colnames(buf4), ignore.case = T)
  lastN <- txt - 1
  lastN[lastN < 0] <- 10^2
  colnames(buf4) <-
    substring(text = colnames(buf4), first = 1, last = lastN)
  row.names(buf4) <- NULL
  cnt <- cnt + 1
  armSales[[cnt]] <- buf4
  sheetTitle[cnt] <- buf0[1,1]
  sheetUnit[cnt] <- buf0[2,1]
  sheetYear[cnt] <- sss
  print(head(armSales[[cnt]],1))
  gc();gc()
}
