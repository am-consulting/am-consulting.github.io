library(rvest);library(XLConnect)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- 'employmentReferralsForGeneralWorkers.xls'
baseURL <- 'http://www.e-stat.go.jp/SG1/estat/'
keyword1 <- '労働市場関係指標（求人倍率・就職率・充足率・求人数・求職者数・就職件数）'
keyword1 <- iconv(keyword1,'shift_jis','utf8')
url <- paste0('http://www.e-stat.go.jp/SG1/estat/GL02010201.do?method=searchTop&andKeyword=', URLencode(keyword1))
htmlMarkup <- read_html(url, encoding = "utf8")
trList <- htmlMarkup %>% html_nodes(xpath = "//tr")
objTr <- gsub('\n|\t','',trList)
pattern <- "<a\\shref=\".*?xlsDownload.*?\""
objHref <- unlist(regmatches(objTr, gregexpr(pattern, objTr, fixed = F)))
pattern <- "./.*?\\.do"
objDo <- gsub('(./)','',unlist(regmatches(objHref, gregexpr(pattern, objHref, fixed = F))))
pattern <- "fileId=[0-9]+"
objID <- unlist(regmatches(objHref, gregexpr(pattern, objHref, fixed = F)))
pattern <- "releaseCount=[0-9]+"
objCount <- unlist(regmatches(objHref, gregexpr(pattern, objHref, fixed = F)))
fileURL <- paste0(baseURL,objDo,'?method=xlsDownload&',objID,'&',objCount)
download.file(fileURL, fileName, mode = "wb")
buf0 <- readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 1, check.names = F, header = F)
buf <- buf0
dataType <- ""
for(ccc in 1:ncol(buf)){
  if(!is.na(buf[3,ccc])){dataType<-buf[3,ccc]}
  if(is.na(buf[5,ccc])){unitName <- '(-)'}else{unitName <- paste0('(',gsub('\\s','',buf[5,ccc]),')')}
  buf[4,ccc]<- paste0(buf[4,ccc],unitName,'-',dataType)
}
colnames(buf) <- gsub('\n','',buf[4,])
rowS <- grep('14年1月', buf[,1])[1]-0
rowE <- grep('昭和39',  buf[,1])[1]-2
Date <- seq(from = as.Date('2002-1-1'), by = 'month', length.out = rowE-rowS+1)
tmp <- buf[rowS:rowE,]
tmp[,-1] <- as.numeric(gsub(',','',as.matrix(tmp[,-1])))
jobOpenings <- data.frame(Date,tmp,check.names = F,stringsAsFactors = F)
colnames(jobOpenings)[2] <- '元号'
