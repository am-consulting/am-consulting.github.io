fun_plotQuadrant <-
  function(obj,aggFun = 'mean',pm = 'japan',xCol = 2,yCol = 3,main = '',pCEX = 2,pCol = 'blue'){
    fun_withList(obj = obj)
    pmCol <-
      grep(pm,colnames(dfWithList),ignore.case = T)
    dfWithList$ShortName <-
      gsub('菅直','菅',substring(dfWithList[,pmCol],1,2))
    objRaw <-
      grep('[0-9]',dfWithList[,pmCol])
    if(length(objRaw)!=0){
      dfWithList$ShortName[objRaw] <-
        paste0(dfWithList$ShortName[objRaw],
               gsub('.+(\\(.+\\))','\\1',dfWithList[,pmCol][objRaw]))
    }
    objCol <-
      grep('shortname',colnames(dfWithList),ignore.case = T)
    x <- na.omit(dfWithList[,c(xCol,objCol)])
    x <- subset(x,unique(x[,2])[1]!=x[,2])
    y <- na.omit(dfWithList[,c(yCol,objCol)])
    y <- subset(y,unique(y[,2])[1]!=y[,2])
    aggX <- aggregate(x[,1,drop=F],list(x[,2]),aggFun)
    aggY <- aggregate(y[,1,drop=F],list(y[,2]),aggFun)
    obj <- merge(aggX,aggY,by='Group.1')
    par(mar = c(5,5,3,1),family = 'Meiryo',font.main = 1,cex.main = 1)
    plot(x = obj[,2],y = obj[,3],type = 'p',pch = 20,cex = pCEX,
         xlab = paste0(colnames(obj)[2],':',aggFun),ylab = paste0(colnames(obj)[3],':',aggFun),
         col = pCol,main = paste0(main,'\nSource:',dataSource))
    text(x = obj[,2],y = obj[,3],labels = obj[,1],pos = 4,offset = 0.3)
    abline(v = 0);abline(h = 0)
    rect(par('usr')[1],0,0,par('usr')[3],border = "black",
         col = rgb(red = 245,green = 222,blue = 179,alpha = 50,maxColorValue = 255))
    rect(0,0,par('usr')[2],par('usr')[4],border = "black",
         col = rgb(red = 245,green = 222,blue = 179,alpha = 50,maxColorValue = 255))
    rect(0,par('usr')[3],par('usr')[2],0,border = "black",
         col = rgb(red = 176,green = 196,blue = 222,alpha = 50,maxColorValue = 255))
    rect(par('usr')[1],0,0,par('usr')[4],border = "black",
         col = rgb(red = 176,green = 196,blue = 222,alpha = 50,maxColorValue = 255))
  }
