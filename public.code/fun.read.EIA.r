fun.read.eia <- function(load.library = F,path.to.folder = '/Desktop/R_Data_Write/'){
  if(load.library==T){lapply(c('XLConnect'),require,character.only = T)}
  path.to.folder <- paste0('C:/Users/',Sys.info()['user'],path.to.folder)
  setwd(path.to.folder)
  file.name <- 'psw09.xls'
  if(!file.exists(file.name)){
    download.file(paste0('http://ir.eia.gov/wpsr/',file.name),file.name,mode = "wb")
  }
  target.sheet <- c(2:22)
  for(sss in 1:length(target.sheet)){
    buf <-
      readWorksheetFromFile(file.name,sheet = target.sheet[sss],check.names = F,header = F)
    colnames(buf) <- unlist(buf[3,])
    buf <- buf[-c(1:3),]
    if(sss == 1){eia.data <- buf}else{eia.data <- merge(eia.data,buf,by = 'Date',all = T)}
    gc();gc()
  }
  eia.data[,1] <- as.Date(eia.data[,1])
  eia.data <- eia.data[order(eia.data[,1]),]
  eia.data <-
    data.frame(eia.data[,1,drop = F],apply(eia.data[,-1],2,as.numeric),
               check.names = F,stringsAsFactors = F,row.names = NULL)
  colname.txt <- c(
    'Weekly U.S. Ending Stocks excluding SPR of Crude Oil  ',
    'Weekly Cushing, OK Ending Stocks excluding SPR of Crude Oil  ',
    'Weekly U.S. Ending Stocks of Total Gasoline  ',
    'Weekly U.S. Ending Stocks of Distillate Fuel Oil  ',
    'Weekly U.S. Ending Stocks of Propane and Propylene  ',
    'Weekly U.S. Refiner Net Input of Crude Oil  ',
    'Weekly U.S. Percent Utilization of Refinery Operable Capacity ',
    'Weekly U.S. Imports of Crude Oil  ',
    'Weekly U.S. Imports of Total Gasoline  ')
  eia.data.extract <- eia.data[,c(1,sapply(colname.txt,function(x)grep(x,colnames(eia.data))))]
  return.list <-
    list('eia.data' = eia.data,
         'eia.data.extract' = eia.data.extract,
         'lab.title' = 'Weekly Petroleum Status Report',
         'data.source' = 'EIA')
  return(return.list)
}
