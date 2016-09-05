--- 
tags : [体感治安,警察信頼度,警察庁] 
published : true
---
#都道府県別の体感治安と警察信頼度
##統計データ概要
1. 本コロプレスマップは谷謙二様が公開されていますアプリケーション、”MANDARA”( http://ktgis.net/mandara/index.php )を利用して作成しています。
1. データ出所：警察庁、ラジオ福島 http://www.rfc.jp/sp/news/disp.html?id=32455 、毎日新聞 http://mainichi.jp/articles/20160831/k00/00m/040/120000c
1. 以下はラジオ福島Webサイトより引用。

>調査では「地域の治安をどの程度だと感じるか」を尋ね、5点満点で回答を求めた。全国平均は3.66。都道府県別の平均値をみると、ベスト3は4点を超えた山形、島根、秋田。ワースト3は3.5を割り込んだ大阪、千葉、愛知だった。  
>「地域の警察を信頼できると感じるか」も質問したところ、全国平均は3.45。ベスト3は福島、山梨、山形。ワースト3は神奈川、大阪、千葉だった。


###体感治安と警察信頼度の相関係数と線形回帰(※ cor.test {stats}、lm {stats} による)
1. cor.test(体感治安,警察信頼度)
	1. 相関係数=0.6237638
	1. p値=2.812e-06
	1. 帰無仮説:『true correlation is not equal to 0』
	1. 95パーセント信頼区間=0.4100462~0.7725484
1. summary(lm(警察信頼度~体感治安))
 
||Estimate|Std. Error|t value|Pr(>&#124;t&#124;)||
|:-|-:|-:|-:|-:|-:|    
|(Intercept) | 1.60423 |   0.35691 |  4.495 |4.84e-05 |\***|
|体感治安    | 0.50874   | 0.09503  | 5.353 |2.81e-06 |\***|
 
![散布図](http://knowledgevault.saecanet.com/oliveImage/am-consulting.co.jp-20160905-01.png)
 
 
***
|都道府県 | 体感治安| 警察信頼度|
|:--------|--------:|----------:|
|山形     |     4.04|       3.73|
|島根     |     4.03|       3.48|
|秋田     |     4.02|       3.71|
|福井     |     3.99|       3.64|
|鳥取     |     3.95|       3.53|
|長崎     |     3.92|       3.60|
|宮崎     |     3.91|       3.56|
|岩手     |     3.89|       3.64|
|長野     |     3.89|       3.58|
|新潟     |     3.89|       3.56|
|熊本     |     3.88|       3.70|
|石川     |     3.88|       3.55|
|青森     |     3.86|       3.59|
|徳島     |     3.86|       3.50|
|愛媛     |     3.85|       3.48|
|高知     |     3.84|       3.43|
|鹿児島   |     3.83|       3.62|
|大分     |     3.82|       3.63|
|富山     |     3.81|       3.47|
|山口     |     3.81|       3.42|
|佐賀     |     3.81|       3.35|
|静岡     |     3.80|       3.51|
|福島     |     3.78|       3.79|
|和歌山   |     3.78|       3.62|
|山梨     |     3.77|       3.74|
|栃木     |     3.76|       3.50|
|沖縄     |     3.73|       3.61|
|岐阜     |     3.73|       3.59|
|東京     |     3.70|       3.58|
|北海道   |     3.69|       3.45|
|宮城     |     3.69|       3.44|
|滋賀     |     3.68|       3.50|
|群馬     |     3.67|       3.48|
|兵庫     |     3.67|       3.48|
|奈良     |     3.66|       3.46|
|神奈川   |     3.66|       3.21|
|広島     |     3.65|       3.46|
|三重     |     3.63|       3.47|
|岡山     |     3.63|       3.37|
|香川     |     3.62|       3.42|
|茨城     |     3.54|       3.68|
|京都     |     3.52|       3.49|
|埼玉     |     3.51|       3.34|
|福岡     |     3.50|       3.38|
|愛知     |     3.42|       3.27|
|千葉     |     3.41|       3.26|
|大阪     |     3.38|       3.25|

***

##データテーブル･チャート
Link - [都道府県別の体感治安と警察信頼度](http://knowledgevault.saecanet.com/mandara_html/am-consulting.co.jp-20160905-01-mandara.html)

<iframe src="http://knowledgevault.saecanet.com/mandara_html/am-consulting.co.jp-20160905-01-mandara.html" width="100%" height="300px"></iframe>

<style>
blockquote{
  display:block;
  background: #fff;
  padding: 15px 20px 15px 45px;
  margin: 0 0 20px;
  position: relative;
  
  /*Font*/
  font-family: Georgia, serif;
  font-size: 16px;
  line-height: 1.2;
  color: #666;
  text-align: justify;
  
  /*Borders - (Optional)*/
  border-left: 15px solid #c76c0c;
  border-right: 2px solid #c76c0c;
  
  /*Box Shadow - (Optional)*/
  -moz-box-shadow: 2px 2px 15px #ccc;
  -webkit-box-shadow: 2px 2px 15px #ccc;
  box-shadow: 2px 2px 15px #ccc;
}

blockquote::before{
  content: "\201C"; /*Unicode for Left Double Quote*/
  
  /*Font*/
  font-family: Georgia, serif;
  font-size: 60px;
  font-weight: bold;
  color: #999;
  
  /*Positioning*/
  position: absolute;
  left: 10px;
  top:5px;
}

blockquote::after{
  /*Reset to make sure*/
  content: "";
}

blockquote a{
  text-decoration: none;
  background: #eee;
  cursor: pointer;
  padding: 0 3px;
  color: #c76c0c;
}

blockquote a:hover{
 color: #666;
}

blockquote em{
  font-style: italic;
}
</style>