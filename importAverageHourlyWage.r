# http://jbrc.recruitjobs.co.jp/data/opendata/
# http://stackoverflow.com/questions/2617600/importing-data-from-a-json-file-into-r
fun_averageHourlyWage <- function(dateS = '2012-1-1',dateE = '2017-3-1'){
  library(rjson);library(Nippon)
  dateRange <- seq(as.Date(dateS),as.Date(dateE),'1 month')
  for(iii in seq(length(dateRange))){
    tmp <- format(dateRange[iii],'%Y%m')
    jsonURL <-
      paste0('http://jbrc.recruitjobs.co.jp/data/opendata/csv/',tmp,'_opendata.json')
    jsonData <-
      rjson::fromJSON(paste(iconv(readLines(jsonURL,encoding = 'shift_jis'),
                                  from = 'shift_jis',
                                  to = 'UTF-8'),
                            collapse = ""))
    jsonDataDF <-
      data.frame(matrix(unlist(jsonData), ncol = length(jsonData[[1]]), byrow = T),
                 stringsAsFactors = F)
    jsonDataDF <-
      apply(jsonDataDF,2,function(x)sapply(x,zen2han))
    colnames(jsonDataDF) <- names(jsonData[[1]])
    if(iii == 1){jsonDataDFS0 <- jsonDataDF}else{jsonDataDFS0 <- rbind(jsonDataDFS0,jsonDataDF)}
  }
  jsonDataDFS <- jsonDataDFS0
  assign('averageHourlyWage',jsonDataDFS,envir = .GlobalEnv)
}
