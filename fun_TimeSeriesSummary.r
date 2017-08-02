fun_TimeSeriesSummary <- function(obj,dateCol = 1,dataCol = 2,
                                  dateFormat = '%Y-%m',indicatorName = '' ){
dateRange <- paste0(paste0(format(range(obj[,dateCol]),dateFormat),collapse = 'から'),'における')
if(indicatorName==''){indicatorName <- colnames(obj)[dataCol]}
cat('<ol>\n')
for(iii in 1:6){
  statName <- switch(iii,'最小値','第1四分位数','中央値','平均値','第3四分位数','最大値')
  cat(paste0('<li>',indicatorName,'の',dateRange,statName,'は',
             if(iii!=4){summary(obj[,dataCol])[iii]}else{round(summary(obj[,dataCol])[iii],4)},'</li>\n'))
}
meanResult <-
  fun_meanS(objDF = obj,dateCol = dateCol,objCol = dataCol,dateFormat = dateFormat)
meanResult <- meanResult[-grep('^平均値|^中央値',meanResult[,1]),]
for(iii in 1:nrow(meanResult)){
  cat(paste0('<li>',indicatorName,'の',dateRange,meanResult[iii,1],'は',
             meanResult[iii,2]),'</li>\n')
}
summaryResult <- fun_summaryByName(obj = obj,objColumn = dataCol,dateFormat = dateFormat)
maxResult <- summaryResult[which.max(summaryResult$Mean),]
minResult <- summaryResult[which.min(summaryResult$Mean),]
cat(paste0('<li>',indicatorName,'の平均値が最も高い政権は',
           maxResult[1,1],'政権の',
           maxResult[1,grep('mean',colnames(maxResult),ignore.case = T)],'</li>\n'))
cat(paste0('<li>',indicatorName,'の平均値が最も低い政権は',
           minResult[1,1],'政権の',
           minResult[1,grep('mean',colnames(minResult),ignore.case = T)],'</li>\n'))
cat('</ol>\n')
}
