library(quantmod)
fredData <- list()
cnt <- 0
popular <-
  c(
    'CPIAUCSL','Consumer Price Index for All Urban Consumers: All Items','Index 1982-1984=100,Seasonally Adjusted',
    'FEDFUNDS','Effective Federal Funds Rate','Percent,Not Seasonally Adjusted',
    'DGS10','10-Year Treasury Constant Maturity Rate','Percent,Not Seasonally Adjusted',
    'BAMLH0A0HYM2','BofA Merrill Lynch US High Yield Option-Adjusted Spread©','Percent,Not Seasonally Adjusted',
    'GDPC1','Real Gross Domestic Product','Billions of Chained 2009 Dollars,Seasonally Adjusted Annual Rate',
    'UNRATE','Civilian Unemployment Rate','Percent,Seasonally Adjusted',
    'MEHOINUSA672N','Real Median Household Income in the United States','2015 CPI-U-RS Adjusted Dollars,Not Seasonally Adjusted',
    'USD1MTD156N','1-Month London Interbank Offered Rate (LIBOR), based on U.S. Dollar©','Percent,Not Seasonally Adjusted',
    'GDP','Gross Domestic Product','Billions of Dollars,Seasonally Adjusted Annual Rate',
    'USD3MTD156N','3-Month London Interbank Offered Rate (LIBOR), based on U.S. Dollar©','Percent,Not Seasonally Adjusted'
  )
for (lll in seq(1, length(popular), by = 3)) {
  cnt <- cnt + 1
  tmp <- getSymbols(popular[lll], src = 'FRED', auto.assign = F)
  tmp <-
    data.frame(
      Date = as.Date(index(tmp)),
      tmp[, 1],
      check.names = F,
      row.names = NULL,
      stringsAsFactors = F
    )
  colnames(tmp)[2] <- paste0(popular[lll + 1],'(',popular[lll + 2],')')
  fredData[[cnt]] <- tmp
  tail(fredData[[cnt]])
  if(lll == 1){popular10 <- tmp}else{popular10 <- merge(popular10, tmp, by='Date', all=T)}
}
