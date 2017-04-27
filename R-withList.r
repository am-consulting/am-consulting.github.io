fun_withList <- function(obj){
csvFile <-
  c('primeMinisterOfJapan.csv','boj.csv','potus.csv','frb.csv')
baseURL <-
  'https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/csv/ListOfPresidents/'
for(iii in seq(length(csvFile))){
  listDF <-
    read.csv(file = paste0(baseURL,csvFile[iii]),header = T,
             quote = "\"",stringsAsFactors = F,check.names = F,fileEncoding = 'utf8')
  objRow <-
    sapply(obj[,1],function(x)tail(which(as.Date(listDF[,1]) <= x & x <= as.Date(listDF[,2])),1))
  objRow <- unlist(objRow)
  if(iii==1){buf <- listDF[objRow,3]}else{buf <- cbind(buf,listDF[objRow,3])}
}
colnames(buf) <- toupper(gsub('.csv','',csvFile))
bufDF <-
  data.frame(obj,buf,stringsAsFactors = F,check.names = F,row.names = NULL)
assign('dfWithList',bufDF,envir = .GlobalEnv)
}
