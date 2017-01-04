fun_latestResult <- function(obj){
  assign('latestResult',
         paste0(paste0(colnames(obj)[-1], ':', tail(obj[,-1],1)), collapse = ','),
         envir = .GlobalEnv)
}
