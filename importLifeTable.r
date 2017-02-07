library(Nippon)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <-
  'life15-12.xls'
baseURL <-
  'http://www.mhlw.go.jp/toukei/saikin/hw/life/life15/dl/'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(url = paste0(baseURL,fileName),
                destfile = fileName,
                mode = 'wb')
}
fun_readXLS <- function(sheetNo = sheetNo){
  buf0 <-
    XLConnect::readWorksheetFromFile(file = paste0(pathOutput, fileName),
                                     sheet = sheetNo,
                                     check.names = F,
                                     header = F)
  buf1 <-
    buf0[!is.na(buf0[,1]),]
  sheetTitle <- zen2han(gsub('\\s','',buf1[1,1]))
  colnames(buf1) <- paste0(buf1[3,],':',buf1[4,])
  colnames(buf1) <-
    gsub('na:tx','定常人口:Tx',colnames(buf1),ignore.case = T)
  buf2 <-
    buf1[!is.na(as.numeric(buf1[,1])),]
  buf2 <-
    buf2[which(apply(buf2,1,function(x)grep('（年）',x))!=0):nrow(buf2),]
  buf3 <-
    buf2[,which(colnames(buf2)!='NA:NA')]
  colnames(buf3)[1] <-
    paste0(colnames(buf3)[1],':',gsub('.+\\((.)\\)','\\1',sheetTitle))
  colnames(buf3)[1] <-
    paste0(colnames(buf3)[1],':',gsub('(平成[0-9]{2}年).+','\\1',sheetTitle))
  buf4 <<-
    apply(buf3,2,function(x)as.numeric(gsub('\\s','',x)))
}
sheetNo <- 1
fun_readXLS(sheetNo = sheetNo)
assign('lifeTableMale',buf4,envir = .GlobalEnv)
sheetNo <- 2
fun_readXLS(sheetNo = sheetNo)
assign('lifeTableFemale',buf4,envir = .GlobalEnv)
# Source http://www.mhlw.go.jp/toukei/saikin/hw/seimei/list54-57-02.html
# Source http://www.mhlw.go.jp/toukei/saikin/hw/life/life15/index.html
# http://www.mhlw.go.jp/toukei/saikin/hw/life/life15/dl/life15-12.xls
