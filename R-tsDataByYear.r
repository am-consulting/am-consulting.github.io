fun_tsDataByYear <-
  function(objDF){
    yearList <- unique(year(objDF[,1]))
    byYear <-
      lapply(yearList,function(x)subset(objDF,x==year(objDF[,1])))
    cbindData0<-
      Reduce(function(x,y){qpcR:::cbind.na(x, y)},byYear)
    objCol <-
      grep('date',colnames(cbindData0),ignore.case = T)
    colnames(cbindData0)[-objCol] <-
      paste0(colnames(cbindData0)[-objCol],':',year(as.Date(unlist(cbindData0[1,objCol]))))
    cbindData1 <- cbindData0[,-objCol]
    returnDF <-
      list("cbindData0" = cbindData0, "cbindData1" = cbindData1)
    return(returnDF)
}
