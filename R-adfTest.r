fun_adfTest <-
  function(obj, objColumn = 2, lag = 1, diff = 1){
    library(tseries)
    cat('原数値\n')
    print(apply(obj[,objColumn,drop = F],2,function(x)adf.test(x = x)))
    cat('一次差分\n')
    diffDF <-
      fun_makeDiffTable(obj = obj,
                        lag = lag,
                        diff = diff)
    print(apply(diffDF[,objColumn,drop = F],2,function(x)adf.test(x = x)))
  }
