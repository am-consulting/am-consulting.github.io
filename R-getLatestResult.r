fun_latestResult <- function(obj, objColumn = -1){
  assign('latestResult',
         paste0(paste0(colnames(obj)[objColumn], ':', tail(obj[,objColumn],1)), collapse = ','),
         envir = .GlobalEnv)
}
