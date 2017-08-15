library(XLConnect);library(lubridate)
fun_EstimatedFundFlows <- function(type = 'weekly'){
  pathOutput <- paste0("C:/Users/",Sys.info()['user'],"/Desktop/R_Data_Write/")
  setwd(pathOutput)
  base.url <- paste0('https://www.ici.org/info/combined_flows_data_',year(Sys.Date()),'.xls')
  file.name <- gsub('.+/([^\\/]+)','\\1',base.url)
  download.file(base.url,file.name, mode = 'wb')
  sheet.name <- getSheets(loadWorkbook(file.name))
  buf0 <- readWorksheetFromFile(file.name,sheet = 1,check.names = F,header = F)
  buf1 <- buf0[,apply(buf0,2,function(x)sum(is.na(x)))!=nrow(buf0)]
  target.row <- 5
  tmp <- NA
  for(ccc in seq(ncol(buf1))){
    target.cell <- buf1[target.row,ccc]
    if(!is.na(target.cell)){tmp <- target.cell}
    buf1[target.row,ccc] <- tmp
  }
  colnames(buf1) <- paste0(buf1[target.row,],':',buf1[target.row+1,])
  colnames(buf1) <- gsub(':na','',colnames(buf1),ignore.case = T)
  sheet.title <- buf1[2,1]
  sheet.unit <- buf1[3,1]
  target.row <- grep('weekly fund flows',buf1[,1])
  if(type == 'monthly'){
    buf2 <- buf1[1:(target.row-1),]
  }else{
    buf2 <- buf1[target.row:nrow(buf1),]
  }
  buf3 <- buf2[!is.na(as.numeric(gsub(',','',buf2[,2]))),]
  buf3[,1] <- as.Date(gsub('(\\d+)/(\\d+)/(\\d+)','\\3-\\1-\\2',buf3[,1]))
  buf3[,-1] <- data.frame(apply(buf3[,-1],2,function(x)as.numeric(gsub(',','',x))),
                          stringsAsFactors = F,check.names = F)
  row.names(buf3) <- NULL
  return(buf3)
}
estimated.fund.flows <- fun_EstimatedFundFlows(type = 'weekly')
