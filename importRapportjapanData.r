# ラポール･ジャパンデータパースコード
library(Nippon)
# dataSet0 <-
#   read.table("clipboard", header = T,sep = "\t", stringsAsFactor = F,
#              na.strings = '',check.names = F,row.names = NULL)
dataSet <- dataSet0
dataSet[,1] <- sapply(dataSet[,1],zen2han)
dataSet[,2] <- sapply(dataSet[,2],zen2han)
colnames(dataSet) <- sapply(colnames(dataSet),zen2han)
lawmaker <-
  unique(dataSet$`政治家`)
lawmakerList <-
  lapply(lawmaker,function(x){dataSet[x==dataSet$`政治家`,]})
politicalMoney <- list()
lawmakerName <- objYear <- vector()
for(iii in seq(length(lawmakerList))){
  obj <- lawmakerList[[iii]]
  objCol1 <- grep('政治家',colnames(obj))
  objCol2 <- grep('対象年',colnames(obj))
  lawmakerName[iii] <- unique(obj[,objCol1])
  objYear[iii] <- unique(obj[,objCol2])
  tmp1 <- t(obj)
  objRow1 <- grep('報告書名',row.names(tmp1))
  objRow2 <- grep('政治家',row.names(tmp1))
  objRow3 <- grep('対象年',row.names(tmp1))
  colnames(tmp1) <- tmp1[objRow1,]
  tmp2 <- tmp1[-c(objRow1,objRow2,objRow3),,drop=F]
  tmp3 <-data.frame(Item = row.names(tmp2),
                    apply(tmp2,2,as.numeric),
                    row.names = NULL,check.names = F,stringsAsFactors = F )
  tmp3$`合計` <- apply(tmp3[,-1,drop=F],1,sum)
  colnames(tmp3)[1] <- '項目'
  politicalMoney[[iii]] <- tmp3
  print(lawmakerName[iii])
  print(objYear[iii])
  print(politicalMoney[[iii]])
}
