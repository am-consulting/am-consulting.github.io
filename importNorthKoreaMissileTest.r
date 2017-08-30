# http://www.nti.org/
# http://www.nti.org/analysis/articles/cns-north-korea-missile-test-database/
library(rvest);library(XLConnect)
path.to.folder <-
  paste0("C:/Users/",Sys.info()['user'],"/Desktop/R_Data_Write/")
setwd(path.to.folder)
target.url <-
  'http://www.nti.org/analysis/articles/cns-north-korea-missile-test-database/'
htmlMarkup <- read_html(x = target.url,encoding = 'utf8')
a.list <- htmlMarkup %>% html_nodes('a')
target.url <- a.list[grep('.xlsx',a.list)] %>% html_attr('href')
xls.file <-
  gsub('.+/([^/]+)','\\1',target.url)
download.file(url = target.url,xls.file,mode = 'wb')
sheetName <- getSheets(loadWorkbook(xls.file))
buf0 <-
  readWorksheetFromFile(xls.file,sheet = 1,check.names = F,header = F)
obj.row <- grep('date',buf0[,2],ignore.case = T)
colnames(buf0) <- buf0[obj.row,]
buf1 <- buf0[-c(1:obj.row),-1]
buf1[,1] <- as.Date(gsub('(.+)\\s.+','\\1',buf1[,1]))
buf1[,2] <- as.Date(gsub('(.+)\\s.+','\\1',buf1[,2]))
row.names(buf1) <- NULL
north.korea.missile.test <- buf1
agg.data <- as.data.frame(table(buf1[,1]),stringsAsFactors = F)
agg.data[,1] <- as.Date(agg.data[,1])
agg.data[,2] <- as.numeric(agg.data[,2])
colnames(agg.data) <- c('Date','Frequency')
data.source <- 'Nuclear Threat Initiative'
