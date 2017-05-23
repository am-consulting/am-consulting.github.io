# Reference http://uub.jp/pdr/g/j.html
centerList0 <-
  read.table("clipboard",
             header = F,
             sep = "\t",
             stringsAsFactor = F,
             check.names = F)
centerList <- centerList0[,c(1,2,3)]
centerList$Lon10Base <-
  as.numeric(gsub('([0-9]+):([0-9]+):([0-9]+)','\\1',centerList[,2]))+
  as.numeric(gsub('([0-9]+):([0-9]+):([0-9]+)','\\2',centerList[,2]))/60+
  as.numeric(gsub('([0-9]+):([0-9]+):([0-9]+)','\\3',centerList[,2]))/3600
centerList$Lat10Base <-
  as.numeric(gsub('([0-9]+):([0-9]+):([0-9]+)','\\1',centerList[,3]))+
  as.numeric(gsub('([0-9]+):([0-9]+):([0-9]+)','\\2',centerList[,3]))/60+
  as.numeric(gsub('([0-9]+):([0-9]+):([0-9]+)','\\3',centerList[,3]))/3600
colnames(centerList)[1:3] <- c('Prefecture','Lon60base','Lat60base')
tmp <-
  data.frame(ID = seq(47),Prefecture = prefectures)
# prefectures:都道府県番号順に並べた都道府県名ベクター
data <- merge(centerList,tmp,by='Prefecture')
data <- data[,c(6,1,4,5,2,3)]
data <- data[order(data[,1]),]
data[,3:4] <- apply(data[,3:4],2,function(x)round(x,5))
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = data,dataType = 11,csvFileName = 'CenterOfPrefecture')
# csv出力パート
