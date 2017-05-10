fun_writeCSVtoFolder <-
  function(objData = obj, dataType = c(1,2),
           csvFileName = format(Sys.time(),'%Y%m%d%H%M%S')){
    username <-
      Sys.info()['user']
    pathToFile <-
      paste0('C:/Users/', username,'/Desktop/pathToCSV/')
    setwd(pathToFile)
    fileName <-
      'defaultPath.csv'
    buf <-
      read.csv(file = fileName,
               header = F,
               skip = 0,
               stringsAsFactor = F,
               check.names = F,
               fileEncoding = 'utf-8',quote = "\"")
    if(dataType == 1){ # Time Series Data
      pathToFolder <- 'TSdata'
    }else{# Not Time Series Data
      pathToFolder <- 'NotTSdata'
    }
    pathOutputTOcsv <-
      paste0("C:/Users/", username, buf[2,1],'csv/csvData/',pathToFolder,'/')
    setwd(pathOutputTOcsv)
    write.csv(x = objData,
              file = paste0(csvFileName,'.csv'),
              quote = T,
              row.names = F,
              append = F,
              na = '',
              fileEncoding = 'UTF-8')
}
