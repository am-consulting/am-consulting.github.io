# script <- getURL("https://raw.githubusercontent.com/am-consulting/Rscript/master/consumerPriceIndexofJapan.r", ssl.verifypeer = F)
# eval(parse(text = script))

fun_beforeORafter <-
  function(obj,
           dateFormat = '%Y-%m',
           colName = '項目',
           grepWord = c('%', '倍率', '\\(倍\\)', '消費者態度指数', '消費者意識指標', '不足率'),
           targetYear = 2012) {
    library(RCurl)
    library(lubridate)
    script <-
      getURL(
        "https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/transposeDataFrame.r",
        ssl.verifypeer = F
      )
    eval(parse(text = script))
    obj <-
      obj[which(apply(obj[, -1, drop = F], 1, function(x) sum(is.na(x))) == 0), ]
    obj <-
      subset(obj, as.Date(paste0(targetYear, '-', month(tail(obj[, 1], 1)), '-1')) <= obj[, 1])
    obj <- obj[c(1, nrow(obj)), ]
    obj0 <-
      fun_transposeDataFrame(
        obj = obj,
        tailN = 2,
        dateFormat = dateFormat,
        colName = colName
      )
    rateR <-
      grep(paste0(grepWord, collapse = '|'), obj0[, 1], ignore.case = T)
    if(length(rateR) != 0){
      obj0[rateR, 4] <- obj0[rateR, 3] - obj0[rateR, 2]
      obj0[-rateR, 4] <- round((obj0[-rateR, 3] - obj0[-rateR, 2]) / obj0[-rateR, 2] * 100, 1)
    }else{
      obj0[, 4] <- round((obj0[, 3] - obj0[, 2]) / obj0[, 2] * 100, 1)
    }
    colnames(obj0)[4] <- '変化(%またはポイント)'
    obj0 <-
      data.frame(
        ID = seq(1, nrow(obj0)),
        obj0,
        check.names = F,
        stringsAsFactors = F
      )
    assign('beforeORafter', obj0, envir = .GlobalEnv)
  }
