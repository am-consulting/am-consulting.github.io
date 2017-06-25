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
# By States
buf0 <-
  xl.read.file(fileName, header=F, top.left.cell = "A6", xl.sheet = 3, excel.visible = F)
tmp <- NA
for(ccc in seq(ncol(buf0))){
  if(!is.na(buf0[1,ccc])){tmp <- buf0[1,ccc]}
  buf0[1,ccc] <- tmp
}
colnames(buf0) <- paste0(buf0[1,],':',buf0[2,])
buf1 <- tail(t(tail(buf0,1)),-1)
buf2 <-
  data.frame(State=row.names(buf1),
             `RigCounts(Oil+Gas+Misc)`=buf1[,1],
             stringsAsFactors = F,check.names = F,row.names = NULL)
buf3 <-
  buf2[-grep('TOTAL US',buf2[,1],ignore.case = T),]
buf3[,2] <- as.numeric(buf3[,2])
objTxt <- 'Land'
Land <-  buf3[grep(objTxt,buf3[,1],ignore.case = T),]
colnames(Land)[2] <- paste0(colnames(Land)[2],':',objTxt)
Land[,1] <- gsub('(.+):.+','\\1',Land[,1])
objTxt <- 'Offshore'
Offshore <-  buf3[grep(objTxt,buf3[,1],ignore.case = T),]
colnames(Offshore)[2] <- paste0(colnames(Offshore)[2],':',objTxt)
Offshore[,1] <- gsub('(.+):.+','\\1',Offshore[,1])
buf4 <-
  merge(Land,Offshore,by='State',all=T)
buf4[is.na(buf4)] <- 0
buf4$`RigCounts(Oil+Gas+Misc):Total` <- buf4[,2]+buf4[,3]
colnames(buf4)[-1] <- paste0(colnames(buf4)[-1],':',tail(buf0[,1],1))
buf4$StateName <- tolower(buf4$State)
buf4[grep('D.C.',buf4$State),5] <- 'district of columbia'
buf4[grep('Mass.',buf4$State),5] <- 'massachusetts'
buf4[grep('Minn.',buf4$State),5] <- 'minnesota'
buf4[grep('N. Carolina',buf4$State),5] <- 'north carolina'
buf4[grep('N. Dakota',buf4$State),5] <- 'north dakota'
buf4[grep('N. Hamp.',buf4$State),5] <- 'new hampshire'
buf4[grep('N. Mexico',buf4$State),5] <- 'new mexico'
buf4[grep('N. York',buf4$State),5] <- 'new york'
buf4[grep('Penn.',buf4$State),5] <- 'pennsylvania'
buf4[grep('Rhode Is.',buf4$State),5] <- 'rhode island'
buf4[grep('S. Carolina',buf4$State),5] <- 'south carolina'
buf4[grep('S. Dakota',buf4$State),5] <- 'south dakota'
buf4[grep('W. Virgina',buf4$State),5] <- 'west virginia'
buf4[grep('Wash.',buf4$State),5] <- 'washington'
buf4[grep('Tennesee',buf4$State),5] <- 'tennessee'
if(length(grep('connecticut',buf4$State,ignore.case = T))==0){
  buf4[nrow(buf4)+1,] <- c('Connecticut',0,0,0,'connecticut')
}
ByStateData <- buf4
remove(buf0,buf1,buf2,buf3,buf4)
