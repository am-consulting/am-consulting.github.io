fun_MSPD <- function(startYear = 2013, breakYear =2016, breakMonth = 9999){
  library(XLConnect);library(Nippon);library(lubridate);library(excel.link)
  username <- Sys.info()['user']
  pathOutput <- paste0("C:/Users/", username, "/Desktop/MSPD/")
  setwd(pathOutput)
  MSPD <- data.frame()
  cnt <- 0
  for(yyyy in startYear:breakYear){
    for(mm in 1:12){
      if(yyyy == breakYear & mm == breakMonth){break}
      dataDate <- paste0(yyyy,'-',mm,'-1')
      fileName <- paste0('opdm',formatC(mm,width = 2,flag = '0'),yyyy,'.xls')
      if(!file.exists(paste0(pathOutput, fileName))) {
        download.file(paste0('https://www.treasurydirect.gov/govt/reports/pd/mspd/',yyyy,'/',fileName),
                      fileName, mode = "wb")
      }
      buf0 <-
        readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 1, check.names = F, header = F)
      buf0[sapply(buf0,function(x)regexpr('\\w',x)) == -1] <- NA
      buf1 <- buf0[,apply(buf0,2,function(x){sum(is.na(x))}) != nrow(buf0)]
      buf2 <- buf1[apply(buf1,1,function(x){sum(is.na(x))}) != ncol(buf1),]
      cnt <- cnt + 1
      MSPD[cnt,1] <- dataDate
      MSPD[cnt,2] <-
        as.numeric(gsub(',','',buf2[grep('Total Public Debt Outstanding',buf2[,1],ignore.case = T),ncol(buf2)]))
      gc();gc()
    }
  }
  MSPD[,1] <- as.Date(MSPD[,1])
  colnames(MSPD) <- c('Date','Total Public Debt Outstanding(Millions of dollars)')
  assign('MSPD',MSPD,envir = .GlobalEnv)
  assign('tableTitle', 'MONTHLY STATEMENT OF THE PUBLIC DEBT OF THE UNITED STATES', envir = .GlobalEnv)
}
