fun_turningPoint <- function(obj, dateFormat = '%Y-%m'){
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
}
