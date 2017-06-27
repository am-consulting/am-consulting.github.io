fun_waterMark <- function(){
  text(x = grconvertX(0.5, from = "npc"),
       y = grconvertY(0.5, from = "npc"),
       labels = "http://olive.saecanet.com",
       cex = 3, font = 2,col = rgb(1, 0, 0, .1),srt = 45)
  watermark <-
    paste("http://am-consulting.co.jp",Sys.Date())
  mtext(watermark, side = 1, line = -1, adj = 1, col = rgb(1, 0, 0, .1), cex = 1.2)
}
