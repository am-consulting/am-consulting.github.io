fun.date.format <- function(obj,date.col = 1){
  date.format <- '%Y-%m-%d'
  if(length(unique(lubridate::month(obj[,date.col])))==1){date.format <- '%Y'}
  if(length(unique(lubridate::day(obj[,date.col])))<=4){date.format <- '%Y-%m'}
  date.range <- paste0(format(range(obj[,date.col]),date.format),collapse = ' ~ ')
  returnList <-
    list('date.format' = date.format,
         'date.range' = date.range)
  return(returnList)
}
