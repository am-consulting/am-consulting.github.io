fun_addTxtToChart <-
  function(obj,objCol = 2,cexTxt = 1.2,funType = 'mean',col = 'red'){ # 1:mean,2:min,3:max
    y <- funType
    if(funType=='mean'){y <- mean(obj[,objCol])}
    if(funType=='min'){y <- min(obj[,objCol])}
    if(funType=='max'){y <- max(obj[,objCol])}
    abline(v=as.numeric(as.Date('1989-04-01')),lty = 2)
    text(x = as.numeric(as.Date('1989-04-01')),y = y,labels = '消費税3%導入',
         srt = 90,pos=4,cex=cexTxt,col=col)
    abline(v=as.numeric(as.Date('1997-04-01')),lty = 2)
    text(x = as.numeric(as.Date('1997-04-01')),y = y,labels = '消費税増税(5%)',
         srt = 90,pos=4,cex=cexTxt,col=col)
    abline(v=as.numeric(as.Date('2008-09-15')),lty = 2)
    text(x = as.numeric(as.Date('2008-09-15')),y = y,labels = 'リーマンショック',
         srt = 90,pos=4,cex=cexTxt,col=col)
    abline(v=as.numeric(as.Date('2012-12-26')),lty = 2)
    text(x = as.numeric(as.Date('2012-12-26')),y = y,labels = '第二次安倍政権発足',
         srt = 90,pos=4,cex=cexTxt,col=col)
    abline(v=as.numeric(as.Date('2014-04-01')),lty = 2)
    text(x = as.numeric(as.Date('2014-04-01')),y = y,labels = '消費税増税(8%)',
         srt = 90,pos=4,cex=cexTxt,col=col)
  }
