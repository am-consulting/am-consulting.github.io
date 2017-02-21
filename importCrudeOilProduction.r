username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
csvList <-
  dir(pattern = 'world_primary',ignore.case = T)
tmp0 <-
  read.csv(file = csvList[1],header = F,skip = F,stringsAsFactors = F)
sheetTitle <-
  paste0(tmp0[1,1],',',tmp0[2,1],',',tmp0[3,1])
sheetTitle <-
  gsub(' - ',':',sheetTitle)
objRow <-
  grep('time', tmp0[,1], ignore.case = T)
mm <-
  sapply(toupper(substring(tmp0[objRow,],1,3)),function(x) match(x, toupper(month.abb)))
yyyy <-
  as.numeric(substring(tmp0[objRow,],4))
colnames(tmp0) <-
  paste0(yyyy,'-',mm,'-1')
objRow <-
  grep('country', tmp0[,1], ignore.case = T)
tmp1 <-
  tmp0[-c(1:objRow),]
tmp2 <-
  t(tmp1)
colnames(tmp2) <- tmp2[1,]
tmp3 <- tmp2[-1,]
tmp4 <-
  data.frame(Date = as.Date(row.names(tmp3)),tmp3,stringsAsFactors = F,check.names = F,row.names = NULL)
tmp4[,-1] <- apply(tmp4[,-1],2,as.numeric)
assign('CrudeOilProduction',tmp4,envir = .GlobalEnv)
