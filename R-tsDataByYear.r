fun_tsDataByYear <-
  function(objDF,dateCol = 1,dataCol = 2){
    obj <- objDF[,c(dateCol,dataCol)]
    yearList <- unique(year(obj[,1]))
    byYear <-
      lapply(yearList,function(x)subset(obj,x==year(obj[,1])))
    cbindData0<-
      Reduce(function(x,y){qpcR:::cbind.na(x, y)},byYear)
    objCol <-
      grep('date',colnames(cbindData0),ignore.case = T)
    colnames(cbindData0)[-objCol] <-
      paste0(colnames(cbindData0)[-objCol],':',year(as.Date(unlist(cbindData0[1,objCol]))))
    cbindData1 <- cbindData0[,-objCol]
    returnDF <-
      list("withDate" = cbindData0, "withoutDate" = cbindData1)
    return(returnDF)
}

fun_strawBroomData <-
  function(objDF,varType = 1){
    buf <- objDF$withoutDate
    if(varType == 1){
      obj <- apply(buf,2,function(x)(na.omit(x)/head(x,1)-1)*100)
      variation <- 'Variation(%)'
    }else{
      obj <- apply(buf,2,function(x)na.omit(x)-head(x,1))
      variation <- 'Variation(Difference)'
    }
    strawData <-
      Reduce(function(x,y){qpcR:::cbind.na(x, y)},obj)
    colnames(strawData) <-
      colnames(buf)
    lastDate <-
      tail(na.omit(objDF$withDate[,grep(year(Sys.Date()),colnames(objDF$withDate))-1]),1)
    returnDF <-
      list('variation' = variation,
           'strawData' = strawData,
           'lastDate' = lastDate)
    return(returnDF)
  }

fun_plotStrawBroomByYear <-
  function(strawData,lastDate,variation,startYear = 2013,pch = 20,cex = 1){
    startYearCol <-
      grep(startYear,colnames(strawData))
    ylim <-
      c(min(strawData[,startYearCol:ncol(strawData)],na.rm = T),
        max(strawData[,startYearCol:ncol(strawData)],na.rm = T))
    dateFormat <-
      ifelse(12 < nrow(strawData),'%Y-%m-%d','%Y-%m')
    par(family = 'Meiryo',font.main = 1,mar = c(5,3,3,1),cex.main = 1.1)
    for(ccc in startYearCol:ncol(strawData)){
      obj <- strawData[,ccc,drop=F]
      if(ccc == startYearCol){
        plot(obj,
             xlab = ifelse(12<nrow(obj),ifelse(55<nrow(obj),'Day','Week'),ifelse(4<nrow(obj),'Month','Quarter')),
             ylab = '',
             pch = pch,
             cex = cex,
             col = ifelse(ccc%%2 == 1,'blue','black'),
             lwd = 1,
             type = ifelse(12 < nrow(obj),'l','o'),
             ylim = ylim,
             panel.first = grid(nx = NULL,ny = NULL,lty = 2,equilogs = T),
             main = paste0(gsub('(.+):([0-9]+)','\\1',colnames(obj)),
                           ':',variation,' Since the Beginning of the Year . Last:',
                           format(x = lastDate,dateFormat)))
      }else{
        lines(obj,
              xlab = '',
              ylab = '',
              pch = pch,
              cex = cex,
              col = ifelse(ccc==ncol(strawData),'red',ifelse(ccc%%2 == 1,'blue','black')),
              lwd = ifelse(ccc==ncol(strawData),2,1),
              type = ifelse(12 < nrow(obj),'l','o'),
              xaxt = 'n',
              yaxt = 'n')
      }
      text(x = tail(index(na.omit(obj)),1),
           y = tail(na.omit(obj),1),
           labels = gsub('.+:([0-9]+)','\\1',colnames(obj)),
           col = ifelse(ccc == ncol(strawData),'red',ifelse(ccc%%2 == 1,'blue','black')),
           cex = ifelse(ccc == ncol(strawData),1.5,1.0),
           adj = 1,
           font = 4)
    }
    abline(h = 0,col = 'black',lwd = 2)
  }
