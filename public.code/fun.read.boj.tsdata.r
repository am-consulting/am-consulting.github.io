fun.read.boj.tsdata <- function(){
  # required package:Nippon , rvest
  index.url <- 'http://www.stat-search.boj.or.jp/index.html'
  html.markup <- read_html(x = index.url,encoding = 'shift_jis')
  data.page <-
    html.markup %>% html_nodes(xpath = "//a[@class = 'referenceLinkForMainTime-series']") %>% html_attr('href')
  file.name <- gsub('.+/([^/]+)\\.html','\\1', data.page)
  base.url <- 'http://www.stat-search.boj.or.jp/ssi/mtshtml/csv/'
  for(iii in seq(length(file.name))){
    Sys.sleep(1) # To prevent server overload
    buf0 <-
      read.csv(file = paste0(base.url,file.name[iii],'.csv'),check.names = F,header = F,stringsAsFactors = F)
    row.name <- grep('系列名称',buf0[,1])
    row.unit <- grep('単位',buf0[,1])
    row.data <- grep('最終更新日',buf0[,1])+1
    colnames(buf0) <- sapply(paste0(buf0[row.name-1,],':',buf0[row.name,],':',buf0[row.unit,]),zen2han)
    buf1 <- buf0[row.data:nrow(buf0),]
    period.type <- gsub('.+_(.+)_.+','\\1',file.name[iii])
    date <- paste0(substring(buf1[,1],1,4),'-',substring(buf1[,1],6,7))
    if(period.type=='d' | period.type=='w1'){
      date <- as.Date(paste0(date,'-',substring(buf1[,1],9,10)))
    }else if(period.type=='fy'){
      date <- as.Date(paste0(date,'1-1'))
    }else if(period.type=='m' | period.type=='q'){
      date <- as.Date(paste0(date,'-1'))
    }
    buf1[,-1] <- apply(buf1[,-1,drop=F],2,as.numeric)
    buf2 <- data.frame(Date = date,buf1[,-1,drop=F],check.names = F,stringsAsFactors = F,row.names = NULL)
    if(iii==1){boj.tsdata <- buf2}else{boj.tsdata <- merge(boj.tsdata,buf2,by='Date',all=T)}
  }
  row.names(boj.tsdata) <- NULL
  return(boj.tsdata)
}
