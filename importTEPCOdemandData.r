fun_TEPCOdemand <- function(plot = 0){
  # http://www.tepco.co.jp/forecast/html/area_data-j.html
  buf0 <-
    read.csv(file = 'http://www.tepco.co.jp/forecast/html/images/area-2016.csv',
             as.is = T,
             stringsAsFactors = F,
             header = F,
             check.names = F)
  sheetUnit <- paste0('(',gsub('単位\\[(.+)\\]','\\1',buf0[1,1]),')')
  buf0[buf0 == ""] <- NA
  tmp <- NA
  for(ccc in 1:ncol(buf0)){
    if(!is.na(buf0[2,ccc])){tmp <- buf0[2,ccc]}
    buf0[2,ccc] <- tmp
  }
  colnames(buf0) <-
    paste0(buf0[2,],':',buf0[3,])
  colnames(buf0) <-
    gsub(':na','',colnames(buf0),ignore.case = T)
  buf1 <- buf0[-c(1:3),]
  buf1[,1] <-
    as.POSIXct(paste0(buf1[,1],' ',buf1[,2]))
  buf2 <- buf1[,-2]
  buf2[,-1] <-
    apply(buf2[,-1],2,function(x)as.numeric(gsub(',','',x)))
  colnames(buf2)[-1] <-
    paste0(colnames(buf2)[-1],sheetUnit)
  assign('areaDemand',buf2,envir = .GlobalEnv)
  # http://www.tepco.co.jp/forecast/html/download-j.html
  buf2016 <-
    read.csv(file = 'http://www.tepco.co.jp/forecast/html/images/juyo-2016.csv',
             as.is = T,
             stringsAsFactors = F,
             header = T,
             skip = 1,
             check.names = F)
  buf2017 <-
    read.csv(file = 'http://www.tepco.co.jp/forecast/html/images/juyo-2017.csv',
             as.is = T,
             stringsAsFactors = F,
             header = T,
             skip = 1,
             check.names = F)
  buf0 <- rbind(buf2016,buf2017)
  buf0[,1] <-
    as.POSIXct(paste0(buf0[,1],' ',buf0[,2]))
  buf1 <- buf0[,-2]
  assign('actualElectricityDemand',buf1,envir = .GlobalEnv)
  # http://www.tepco.co.jp/forecast/html/calendar-j.html
  buf2016 <-
    read.csv(file = 'http://www.tepco.co.jp/forecast/html/images/juyo-result-2016-j.csv',
             as.is = T,
             stringsAsFactors = F,
             header = T,
             skip = 1,
             check.names = F)
  buf2017 <-
    read.csv(file = 'http://www.tepco.co.jp/forecast/html/images/juyo-result-j.csv',
             as.is = T,
             stringsAsFactors = F,
             header = T,
             skip = 1,
             check.names = F)
  buf0 <- rbind(buf2016,buf2017)
  buf0[,1] <-
    as.POSIXct(paste0(buf0[,1],' ',buf0[,2]))
  assign('maxDemand',buf0,envir = .GlobalEnv)
  if(plot != 0){
    par(mfrow = c(1,2))
    plot(x = areaDemand[,1],
         y = areaDemand[,2],
         type = 'l',
         xaxt = 'n',
         xlab = '',
         ylab = colnames(areaDemand)[2])
    axis.POSIXct(side = 1,
                 x = areaDemand[,1],
                 format = '%Y-%m')
    plot(x = actualElectricityDemand[,1],
         y = actualElectricityDemand[,2],
         type = 'l',
         xaxt = 'n',
         xlab = '',
         ylab = colnames(actualElectricityDemand)[2])
    axis.POSIXct(side = 1,
                 x = actualElectricityDemand[,1],
                 format = '%Y-%m')
  }
}
