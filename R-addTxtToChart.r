fun_addTxtToChart <-
  function(objCol = 2){
    abline(v=as.numeric(as.Date('1989-4-1')),lty = 2)
    text(x = as.numeric(as.Date('1989-4-1')),y = mean(obj[,objCol]),labels = '消費税3%導入',
         srt = 90,pos=3,cex=1.0)
    abline(v=as.numeric(as.Date('1997-4-1')),lty = 2)
    text(x = as.numeric(as.Date('1997-4-1')),y = mean(obj[,objCol]),labels = '消費税増税(5%)',
         srt = 90,pos=3,cex=1.0)
    abline(v=as.numeric(as.Date('2008-9-15')),lty = 2)
    text(x = as.numeric(as.Date('2008-9-15')),y = mean(obj[,objCol]),labels = 'リーマンショック',
         srt = 90,pos=3,cex=1.0)
    abline(v=as.numeric(as.Date('2012-12-26')),lty = 2)
    text(x = as.numeric(as.Date('2012-12-26')),y = mean(obj[,objCol]),labels = '第二次安倍政権発足',
         srt = 90,pos=3,cex=1.0)
    abline(v=as.numeric(as.Date('2014-4-1')),lty = 2)
    text(x = as.numeric(as.Date('2014-4-1')),y = mean(obj[,objCol]),labels = '消費税増税(8%)',
         srt = 90,pos=3,cex=1.0)
  }
