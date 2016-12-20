fun_MSPD <- function(startYear = 2016, breakYear =2016, breakMonth = 9999){
  library(XLConnect);library(lubridate);library(excel.link);library(gdata)
  username <- Sys.info()['user']
  pathOutput <- paste0("C:/Users/", username, "/Desktop/MSPD/")
  setwd(pathOutput)
  MSPD <- data.frame()
  cnt <- 0
  for(yyyy in startYear:breakYear){
    for(mm in 1:12){
      if(yyyy == breakYear & mm == breakMonth){break}
      dataDate <- as.Date(paste0(yyyy,'-',formatC(mm,width = 2,flag = '0'),'-01'))
      fileName <- paste0('opdm',formatC(mm,width = 2,flag = '0'),yyyy,'.xls')
      if(!file.exists(paste0(pathOutput, fileName))) {
        if(dataDate < as.Date('2007-04-01')){
          download.file(paste0('ftp://ftp.publicdebt.treas.gov/opd/',fileName),
                        fileName, mode = "wb")
        }else{
          download.file(paste0('https://www.treasurydirect.gov/govt/reports/pd/mspd/',yyyy,'/',fileName),
                        fileName, mode = "wb")
        }
      }
      # buf0 <-
      #   readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 1, check.names = F, header = F)
      # 計算式のセルはNAとなる.
      buf0 <-
        read.xls(paste0(pathOutput, fileName), sheet = 1, header = F)
      buf0[sapply(buf0,function(x){regexpr('\\w',x,ignore.case = T)}) == -1] <- NA
      buf1 <- buf0[,apply(buf0,2,function(x){sum(is.na(x))}) != nrow(buf0)]
      buf2 <- buf1[apply(buf1,1,function(x){sum(is.na(x))}) != ncol(buf1),]
      cnt <- cnt + 1
      MSPD[cnt,1] <- as.character(dataDate)
      MSPD[cnt,2] <-
        as.numeric(gsub(',','',buf2[grep('Total Public Debt Outstanding',buf2[,1],ignore.case = T),ncol(buf2)]))
      gc();gc()
    }
  }
  MSPD[,1] <- as.Date(MSPD[,1])
  colnames(MSPD) <- c('Date','Total Public Debt Outstanding')
  assign('MSPD',MSPD,envir = .GlobalEnv)
  assign('tableTitle', 'MONTHLY STATEMENT OF THE PUBLIC DEBT OF THE UNITED STATES(Millions of dollars)', envir = .GlobalEnv)
}
