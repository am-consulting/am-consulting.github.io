fun_preparePlot <- function(){
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
  pathOutputTOchart <-
    paste0("C:/Users/", username, buf[2,1],'charts/chartImages/')
  setwd(pathOutputTOchart)
  getwd()
}

fun_PlotStrawAnd4charts <-
  function(obj,varType=1,width=1000,height=600,
           dateFormat='%Y-%m',tailN=c(10^10,12*5,12*3,12),chartType='o'){
    fun_preparePlot()
    if(exists('htmlName')){
      pngFile <- paste0(htmlName, "1.png")
      png(file = pngFile, width = width, height = height)
    }
    par(mfrow = c(1,1),family = 'Meiryo')
    tmp0 <- fun_tsDataByYear(objDF = obj,dateCol = 1,dataCol = 2)
    tmp1 <- fun_strawBroomData(objDF = tmp0,varType = varType)
    fun_plotStrawBroomByYear(strawData = tmp1$strawData,
                             lastDate = tmp1$lastDate,
                             variation = tmp1$variation)
    if(exists('htmlName')){
      pngFile <- paste0(htmlName, "2.png")
      png(file = pngFile, width = width, height = height)
    }
    par(mfrow = c(1,1),family = 'Meiryo')
    fun_plot4charts(obj = obj,
                    dateFormat = dateFormat,
                    tailN = tailN,
                    type = chartType)
}
