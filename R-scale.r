fun_scale <-
  function(obj,center = T,scale = T){
    resultScale0 <-
      scale(obj[,-1], center = center, scale = scale)
    resultScaleDF <-
      data.frame(attributes(resultScale0)$`scaled:center`,
                 attributes(resultScale0)$`scaled:scale`,
                 stringsAsFactors = F)
    colnames(resultScaleDF) <- c('Center','Scale')
    resultScale <-
      data.frame(obj[,1,drop=F],
                 resultScale0,
                 stringsAsFactors = F,
                 check.names = F,
                 row.names = NULL)
    assign('resultScaleDF', resultScaleDF, envir = .GlobalEnv)
    assign('resultScale',   resultScale,   envir = .GlobalEnv)
  }
