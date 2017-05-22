# Source http://www.customs.go.jp/toukei/shinbun/trade-st/sadj.htm
library(rvest);library(lubridate)
htmlMarkup <-
  read_html(x = 'http://www.customs.go.jp/toukei/shinbun/trade-st/sadj.htm',
            encoding = 'shift_jis')
hrefLink <-
  htmlMarkup %>% html_nodes('a') %>% html_attr('href')
csvFile <-
  hrefLink[grep('\\.csv',hrefLink)]
buf0 <-
  read.csv(file = paste0('http://www.customs.go.jp/toukei/shinbun/trade-st/',csvFile),
           header = F,
           quote = "\"",
           check.names = F,stringsAsFactors = F,fileEncoding = 'shift_jis')
notes01 <- buf0[1,1]
colnames(buf0) <- buf0[3,]
buf1 <- buf0[-c(1:4),]
Date <-
  as.Date(gsub('([0-9]+)/([0-9]+)','\\1-\\2-1',buf1[,1]))
buf2 <-
  data.frame(Date,apply(buf1[,-1],2,as.numeric),stringsAsFactors = F,row.names = NULL,check.names = F)
if(length(grep('百万円',notes01))!=0){
  buf2[,-1] <-
    apply(buf2[,-1],2,function(x)x*10^-6)
  colnames(buf2)[-1] <- paste0(colnames(buf2)[-1],'(Trillion JPY)')
}else{
  buf2 <- 0
}
assign('ExportAndImportSA',buf2)
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = buf2,dataType = 1,csvFileName = '財務省貿易統計_輸出及び輸入_季節調整値_兆円')
# csv出力パート
