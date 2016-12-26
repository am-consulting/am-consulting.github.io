fun_turningPoint <- function(obj, dateFormat = '%Y-%m'){
  obj[,1] <-  format(obj[,1],dateFormat)
  obj0 <- obj
  obj0[obj0 == 0] <- 1
  assign('objPNinclude0',
         obj[which(head(obj0[,2],-1) * tail(obj0[,2],-1) < 0) + 1,], envir = .GlobalEnv)
  obj0 <- obj
  obj0 <- subset(obj0,obj0[,2] != 0)
  assign('objPNexclude0',
         obj[which(head(obj0[,2],-1) * tail(obj0[,2],-1) < 0) + 1,], envir = .GlobalEnv)
}
