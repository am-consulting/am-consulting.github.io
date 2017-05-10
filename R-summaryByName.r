fun_summaryByName <- function(obj,omitFirst = 1,objColumn = 2,objPerson = 'primeminister',digits = 2){
if(exists('summaryByName',envir = .GlobalEnv)){remove('summaryByName',envir = .GlobalEnv)}
fun_withList(obj = obj[,c(1,objColumn)])
objPersonColumn <-
  grep(objPerson,colnames(dfWithList),ignore.case = T)
buf0 <-
  dfWithList[,c(1,2,objPersonColumn)]
if(omitFirst == 1){
  buf0 <-
    subset(buf0,unique(buf0[,3])[1]!=buf0[,3])
}
uniqObj <-
  unique(buf0[,3])
for(iii in seq(length(uniqObj))){
  tmp <- subset(buf0,buf0[,3] == uniqObj[iii])
  if(iii == 1){
    allRecord <- summary(tmp[,2])
  }else{
    allRecord <- rbind(allRecord,summary(tmp[,2]))
  }
}
rownames(allRecord) <- NULL
Period <-
  sapply(uniqObj,function(x)paste0(format(range(buf0[buf0[,3]==x,1]),dateFormat),collapse = '~'))
objColumn <- grep('Mean',colnames(allRecord))
allRecord[,objColumn] <- round(allRecord[,objColumn],digits)
# assign('summaryByName',
#        data.frame(Name = uniqObj,allRecord,Period, stringsAsFactors = F,check.names = F,row.names = NULL),
#        envir = .GlobalEnv)
return(data.frame(Name = uniqObj,allRecord,Period, stringsAsFactors = F,check.names = F,row.names = NULL))
}
