library(XLConnect);library(Nippon)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileURL <- 'http://www.iima.or.jp/Docs/ppp/PPPdata.xlsx'
fileName <- gsub('.+/([^/]+.xlsx)','\\1',fileURL)
download.file(url = fileURL, destfile = fileName, mode = 'wb')
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName),
                        sheet = 1, check.names = F, header = F)
buf1 <- buf0
keyWord <- 'Euro against'
objRow <- which(apply(buf1,1,function(x)(length(grep(keyWord,x))))!=0)
buf2 <- buf1[-c(objRow[1]:nrow(buf1)),]
keyWord <- '^Date$'
objRow <- which(apply(buf2,1,function(x)(length(grep(keyWord,x))))!=0)
objCol <- which(apply(buf2,2,function(x)(length(grep(keyWord,x))))!=0)
objCol <- c(objCol,ncol(buf2)+1)
PPPData <- list()
for(ccc in seq(length(objCol)-1)){
  obj <- buf2[objRow:nrow(buf2),objCol[ccc]:(objCol[ccc+1]-1)]
  colnames(obj) <- obj[1,]
  obj <- obj[-1,]
  colnames(obj) <- gsub('\n',' ',colnames(obj))
  if(ncol(obj)==5){
    obj[,1] <- as.Date(paste0(gsub('([0-9]+)\\.([0-9]+)','\\1-\\2-1',obj[,1])))
    obj <- obj[!is.na(obj[,2]),]
  }
  if(ncol(obj)==6){
    obj[,1] <- paste0(obj[,1],'.',obj[,2])
    obj <- obj[,-2]
    obj <- obj[!is.na(obj[,2]),]
    obj[,1] <-
      seq(as.Date(paste0(gsub('([0-9]+)\\.([0-9]+)','\\1-\\2-1',obj[1,1]))),
          by = 'month',
          length.out = nrow(obj))
  }
  print(obj)
  PPPData[[ccc]] <- obj
}
PPPDataUSDJPY <-
  Reduce(function(x, y) rbind(x, y), PPPData)
PPPDataUSDJPY[,-1] <-
  data.frame(apply(PPPDataUSDJPY[,-1],2,as.numeric),stringsAsFactors = F,check.names = F)
row.names(PPPDataUSDJPY) <- NULL
