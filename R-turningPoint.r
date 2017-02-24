fun_turningPoint <- function(obj, dateFormat = '%Y-%m', unit = '月', judge = c('輸入超','輸出超')){
  obj[,1] <- as.Date(obj[,1])
  obj0 <- obj
  obj0[obj0 == 0] <- 1
  obj0 <- obj[which(head(obj0[,2],-1) * tail(obj0[,2],-1) < 0) + 1,]
  assign('durationInclude0', nrow(subset(obj, tail(obj0[,1],1) <= obj[,1])), envir = .GlobalEnv)
  obj0[,1] <-  format(obj0[,1],dateFormat)
  assign('objPNinclude0', obj0, envir = .GlobalEnv)
  obj0 <- obj
  obj0 <- subset(obj0,obj0[,2] != 0)
  obj0 <- obj0[which(head(obj0[,2],-1) * tail(obj0[,2],-1) < 0) + 1,]
  assign('durationExclude0', nrow(subset(obj, tail(obj0[,1],1) <= obj[,1])), envir = .GlobalEnv)
  obj0[,1] <-  format(obj0[,1],dateFormat)
  assign('objPNexclude0', obj0, envir = .GlobalEnv)
  assign('texInclude0',paste0(tail(objPNinclude0[,1],1),
                              'から',
                              format(tail(obj[,1],1), dateFormat),
                              'まで',
                              durationInclude0,
                              unit,
                              '連続で',
                              ifelse(tail(objPNinclude0[,2],1) < 0,
                                     judge[1],
                                     judge[2])),
         envir = .GlobalEnv)
  assign('texExclude0',paste0(tail(objPNexclude0[,1],1),
                              'から',
                              format(tail(obj[,1],1), dateFormat),
                              'まで',
                              durationExclude0,
                              unit,
                              '連続で',
                              ifelse(tail(objPNexclude0[,2],1) < 0,
                                     judge[1],
                                     judge[2])),
         envir = .GlobalEnv)
}
