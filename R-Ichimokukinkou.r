# 熊谷悦生、舟尾暢男(2008).『Rで学ぶデータマイニング　Ⅱシミュレーション編』.オーム社.248pp.
# https://ja.wikipedia.org/wiki/%E4%B8%80%E7%9B%AE%E5%9D%87%E8%A1%A1%E8%A1%A8
# http://equations.am-consulting.co.jp/2014/03/23/910/
fun_Ichimokukinkou <-
  function(objDF,objDateCol = 1,objCloseCol = 2,objPlotCol = 2,
           a1 = 26,a2 = 52,ct = 9,st = 26,dateFormat = '%Y-%m-%d',tailN = 20*6){
    lineColor <- c('','black','blue','red')
    objClose <- objDF[,objCloseCol]
    obj <- objDF[,-objDateCol]
    KijyunSen <- TenkanSen <- SenkouSpan1 <- SenkouSpan2 <- ChikouSpan <- vector()
    for(iii in (ct-1):nrow(objDF)){
      # 基準線:26次ラグまでの最大値と最小値の平均値の系列。
      # (過去26日間における最高値+同最安値)÷2
      if(iii > (st-1)){
        KijyunSen[iii] <- (max(obj[(iii-(st-1)):iii,]) + min(obj[(iii-(st-1)):iii,]))/2
      }
      # 遅行スパン:26次ラグの系列.
      # (本日の終値)を(当日を含めた26日前すなわち)25日前にプロットしたもの
      if(iii > a1){
        ChikouSpan[iii-a1] <- objClose[iii]
      }
      # 先行スパン2：52次ラグまでの最大値と最小値の平均値をマイナス26次ラグとする系列
      # {(過去52日間における最高値+同最安値)÷2}を(当日を含めた26日先すなわち)25日先にプロットしたもの
      if(iii > (a2-1)){
        SenkouSpan2[iii+a1] <-
          (max(obj[(iii-(a2-1)):iii,]) + min(obj[(iii-(a2-1)):iii,]))/2
      }
      # 転換線:9次ラグまでの最大値と最小値の平均値の系列
      # (過去9日間における最高値+同最安値)÷2
      TenkanSen[iii] <-
        (max(obj[(iii-(ct-1)):iii,]) + min(obj[(iii-(ct-1)):iii,]))/2
      # 先行スパン1：基準線と転換線の平均値をマイナス26次ラグとする系列
      # {(転換値+基準値)÷2}を(当日を含めた26日先すなわち)25日先にプロットしたもの
      SenkouSpan1[iii+a1] <- (KijyunSen[iii] + TenkanSen[iii])/2
    }
    length(SenkouSpan1)
    length(SenkouSpan2)
    length(TenkanSen)
    length(KijyunSen)
    length(ChikouSpan)
    # 基準線と転換線
    plotDF <-
      tail(cbind(objDF[,c(objDateCol,objPlotCol)],KijyunSen,TenkanSen),tailN)
    y1 <- min(plotDF[,-1],na.rm = T)
    y2 <- max(plotDF[,-1],na.rm = T)
    par(family='Meiryo',font.main=1,mar=c(4,4,3,2),cex.main=1.1,cex.axis=1)
    plot(plotDF[,c(1,2)],
         ylim = c(y1,y2),
         type = 'l',
         main = paste0(colnames(plotDF)[2],'、基準線、転換線'),
         xlab = '',
         ylab = '',
         xaxt = 'n',
         lty = 2,
         panel.first = grid(nx = NULL,ny = NULL,lty = 2,equilogs = T))
    axis.Date(side = 1,at = plotDF[,1],format = dateFormat,padj = 1,cex.axis = 1)
    lines(plotDF[,c(1,3)],col='blue',lwd=2)
    lines(plotDF[,c(1,4)],col='red',lwd=3)
    graphics::legend(x = 'topleft',
                     col = lineColor[c(2,3,4)],
                     lty = c(2,1,1),
                     legend = colnames(plotDF)[c(2,3,4)],
                     cex = 1.2,
                     bty = 'n',
                     lwd = 2)
    cat('<hr>')
    # 先行スパン
    plotDF <-
      tail(cbind(SenkouSpan1,SenkouSpan2),length(SenkouSpan1)-nrow(objDF))
    row.names(plotDF) <- NULL
    y1 <- min(plotDF,na.rm = T)
    y2 <- max(plotDF,na.rm = T)
    par(family='Meiryo',font.main=1,mar=c(4,4,3,2),cex.main=1.1,cex.axis=1)
    plot(plotDF[,1],
         ylim = c(y1,y2),
         type = 'o',
         pch = 20,
         main = paste0(gsub('東京市場.?(.+).+スポット.+','\\1',colnames(objDF)[2]),
                       ':先行スパン1と先行スパン2'),
         xlab = '',
         ylab = '',
         xaxt = 'n',
         col= lineColor[3],
         lwd = 2,
         cex = 1.2,
         panel.first = grid(nx = NULL,ny = NULL,lty = 2,equilogs = T))
    axis(side = 1,at = index(plotDF),labels = paste0(index(plotDF),'日目'),las=2)
    lines(plotDF[,2],
          col = lineColor[4],
          lwd = 2,
          type = 'o',
          pch = 20,
          cex = 1.2)
    graphics::legend(x = 'topleft',
                     col = lineColor[c(3,4)],
                     lty = 1,
                     legend = colnames(plotDF)[c(1,2)],
                     cex = 1.2,
                     bty = 'n',
                     lwd = 2)
  }
