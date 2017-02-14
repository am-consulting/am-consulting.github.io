fun_cointegration <-
  function(obj, objX = 2, objY = 3){
    cat(paste0('x:',colnames(obj)[objX],' , y:',colnames(obj)[objY]))
    `x~y` <- obj[,c(objX,objY)]
    tseries::po.test(x = `x~y`)
  }
