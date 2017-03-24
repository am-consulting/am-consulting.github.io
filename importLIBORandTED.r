library(quantmod)
fredData <- list()
cnt <- 0
treasuryRate <-
  c(
    'USD1MTD156N', '1-Month London Interbank Offered Rate (LIBOR), based on U.S. Dollar',
    'USD3MTD156N', '3-Month London Interbank Offered Rate (LIBOR), based on U.S. Dollar',
    'USD6MTD156N', '6-Month London Interbank Offered Rate (LIBOR), based on U.S. Dollar',
    'USD12MD156N', '12-Month London Interbank Offered Rate (LIBOR), based on U.S. Dollar',
    'TEDRATE', 'TED Spread'
  )
for (lll in seq(1, length(treasuryRate), by = 2)) {
  cnt <- cnt + 1
  tmp <- getSymbols(treasuryRate[lll], src = 'FRED', auto.assign = F)
  tmp <-
    data.frame(
      Date = as.Date(index(tmp)),
      tmp[, 1],
      check.names = F,
      row.names = NULL,
      stringsAsFactors = F
    )
  colnames(tmp)[2] <- treasuryRate[lll + 1]
  fredData[[cnt]] <- tmp
  tail(fredData[[cnt]])
  if(lll == 1){LIBOR <- tmp}else{LIBOR <- merge(LIBOR, tmp, by='Date', all=T)}
}
