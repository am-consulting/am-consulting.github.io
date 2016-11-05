library(excel.link);library(XML)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- 'NorthAmericaRotaryRigCount.xlsb'
url <- "http://phx.corporate-ir.net/phoenix.zhtml?c=79687&p=irol-reportsother"
htmlMarkup <- htmlParse(url)
links <- xpathSApply(htmlMarkup, "//a/@href")
urlToData <- links[[grep('External.File\\?item=',links)[1]]]
download.file(urlToData, fileName, mode = "wb")
buf0 <- xl.read.file(fileName, header=F, top.left.cell = "A10", xl.sheet = 2, excel.visible = F)
buf1 <- buf0[, c(1, grep('total', buf0[1,], ignore.case = T):ncol(buf0))]
colnames(buf1) <- paste0(buf1[1,2], '-', buf1[2,])
buf2 <- buf1[-(1:2),]
buf2[,1] <- as.Date(buf2[,1])
buf3 <- buf2[,colSums(is.na(buf2)) != nrow(buf2)]
colnames(buf3)[1] <- 'Date'
buf3[,-1] <- apply(buf3[,-1],2,as.numeric)
northAmericaRotaryRigCount_BakerHughes <- buf3