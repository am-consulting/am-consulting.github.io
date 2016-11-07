<!--
function calcStep1(){
	constructionType=new Array();
	constructionType=["河川工事","河川・道路構造物工事","海岸工事","道路改良工事","鋼橋架設工事","PC橋工事","舗装工事","砂防・地すべり等工事","公園工事","電線共同溝工事","情報BOX工事","道路維持工事","河川維持工事","共同溝等工事1","共同溝等工事2","トンネル工事","下水道工事1","下水道工事2","下水道工事3","コンクリートダム工事","フィルダム工事","橋梁保全工事"];//20160503
	rateKyoutsuukasetsuList=new Array();
	rateKyoutsuukasetsuList[0]=[12.53,238.6,-0.1888,4.77];//河川工事
//	rateKyoutsuukasetsuList[1]=[26.94,6907.7,-0.3554,4.37];//河川・道路構造物工事
	rateKyoutsuukasetsuList[1]=[20.77,1228.3,-0.2614,5.45];//河川・道路構造物工事 20160503
	rateKyoutsuukasetsuList[2]=[13.08,407.9,-0.2204,4.24];//海岸工事
	rateKyoutsuukasetsuList[3]=[12.78,57,-0.0958,7.83];//道路改良工事
//	rateKyoutsuukasetsuList[4]=[26.1,633,-0.2043,9.18];//鋼橋架設工事
	rateKyoutsuukasetsuList[4]=[38.36,10668.4,-0.3606,6.06];//鋼橋架設工事 20160503
	rateKyoutsuukasetsuList[5]=[27.04,1636.8,-0.2629,7.05];//PC橋工事
	rateKyoutsuukasetsuList[6]=[17.09,435.1,-0.2074,5.92];//舗装工事
	rateKyoutsuukasetsuList[7]=[15.19,624.5,-0.2381,4.49];//砂防・地すべり等工事
	rateKyoutsuukasetsuList[8]=[10.8,48,-0.0956,6.62];//公園工事
	rateKyoutsuukasetsuList[9]=[9.96,40,-0.0891,6.31];//電線共同溝工事
	rateKyoutsuukasetsuList[10]=[18.93,494.9,-0.2091,6.5];//情報BOX工事
//	rateKyoutsuukasetsuList[11]=[16.64,34596.3,-0.4895,4.2];//道路維持工事
	rateKyoutsuukasetsuList[11]=[23.94,4118.1,-0.3548,5.97];//道路維持工事 20160503
	rateKyoutsuukasetsuList[12]=[8.34,26.8,-0.0748,6.76];//河川維持工事
	rateKyoutsuukasetsuList[13]=[8.86,68.3,-0.1267,4.53];//共同溝等工事1
	rateKyoutsuukasetsuList[14]=[13.79,92.5,-0.1181,7.37];//共同溝等工事2
	rateKyoutsuukasetsuList[15]=[31.87,5388.7,-0.3183,5.9];//トンネル工事
	rateKyoutsuukasetsuList[16]=[12.85,422.4,-0.2167,4.08];//下水道工事1
	rateKyoutsuukasetsuList[17]=[13.32,485.4,-0.2231,4.08];//下水道工事2
	rateKyoutsuukasetsuList[18]=[7.64,13.5,-0.0353,6.34];//下水道工事3
	rateKyoutsuukasetsuList[19]=[12.29,105.2,-0.11,9.02];//コンクリートダム工事
	rateKyoutsuukasetsuList[20]=[7.57,43.7,-0.0898,5.88];//フィルダム工事
	rateKyoutsuukasetsuList[21]=[27.32,7050.2,-0.3558,6.79];//橋梁保全工事 20160503
	cost=new Array();
	cost[1]=parseFloat(document.form1.a.value.replace(/,/g, ''));//直接工事費
	cost[2]=parseFloat(document.form1.b.value.replace(/,/g, ''));//桁等購入費
	cost[3]=parseFloat(document.form1.c.value.replace(/,/g, ''));//鋼橋門扉等工場原価
	cost[4]=parseFloat(document.form1.d.value.replace(/,/g, ''));//事業損失防止施設費
	cost[5]=parseFloat(document.form1.e.value.replace(/,/g, ''));//無償貸与機械等評価額
	cost[6]=parseFloat(document.form1.f.value.replace(/,/g, ''));//共通仮設費対象支給品費等
	cost[7]=parseFloat(document.form1.g.value.replace(/,/g, ''));//イメージアップ経費対象支給品費等
	cost[8]=parseFloat(document.form1.h.value.replace(/,/g, ''));//現場管理費対象支給品費等
	cost[9]=parseFloat(document.form1.i.value.replace(/,/g, ''));//直接工事費に含まれる処分費
	cost[10]=parseFloat(document.form1.j.value.replace(/,/g, ''));//準備費に含まれる処分費
	cost[11]=parseFloat(document.form1.k.value.replace(/,/g, ''));//イメージアップ特別積上額
	cost[12]=parseFloat(document.form1.l.value.replace(/,/g, ''));//その他積上分共通仮設費
	for(i=1; i<=12; i++){
		if(isNaN(cost[i]) || cost[i]<0){
			cost[i]=0;
		}
	}
	constructionSegment=parseFloat(document.form1.constructionSegment.value);
	correctionPeriod=parseFloat(document.form1.correctionPeriod.value);
	if(isNaN(correctionPeriod) || correctionPeriod<0){
		correctionPeriod=0;
	}
	correctionContract=parseFloat(document.form1.correctionContract.value);
	if(isNaN(correctionContract) || correctionContract<0){
		correctionContract=0;
	}
	allocateImageup=parseFloat(document.form1.allocateImageup.value);
	correctionRateImageup=parseFloat(document.form1.correctionRateImageup.value);//20160503
	correctionMaebaraikin=parseFloat(document.form1.correctionMaebaraikin.value);
	correctionArea=parseFloat(document.form1.correctionArea.value);
	correctionBigcity=parseFloat(document.form1.correctionBigcity.value);
	rateConsumptionTax=parseFloat(document.form1.rateConsumptionTax.value);
	if(isNaN(rateConsumptionTax) || rateConsumptionTax<0){
		rateConsumptionTax=0;
	}
	ketaMarume=parseFloat(document.form1.ketaMarume.value);
//共通仮設費対象額=直接工事費-桁等購入費-鋼橋門扉等工場原価+事業損失防止施設費+無償貸与機械等評価額+共通仮設費対象支給品費等
	coverageKyoutsuukasetsu=cost[1]-cost[2]-cost[3]+cost[4]+cost[5]+cost[6];
	coverageKyoutsuukasetsu=Math.round(Math.floor(coverageKyoutsuukasetsu*Math.pow(10,7))/10)/Math.pow(10,6);
//計上処分費の計算
//(直接工事費に含まれる処分費+準備費に含まれる処分費)/(共通仮設費対象額+準備費に含まれる処分費)
	shobunCostTotal=cost[9]+cost[10];
	shobunCostTotal=Math.round(Math.floor(shobunCostTotal*Math.pow(10,7))/10)/Math.pow(10,6);
	PplusShobun=coverageKyoutsuukasetsu+cost[10];
	PplusShobun=Math.round(Math.floor(PplusShobun*Math.pow(10,7))/10)/Math.pow(10,6);
	if(PplusShobun!=0){
		ratio=shobunCostTotal/PplusShobun;
		if(ratio<=0.03 && shobunCostTotal<=30000000){
			allocateShobunCost=shobunCostTotal;
		}
		else
		if(0.03<ratio && shobunCostTotal<=30000000){
			allocateShobunCost=PplusShobun*0.03;
		}
		else{
			allocateShobunCost=30000000;
		}
	}
	else{
		ratio=0;
		allocateShobunCost=0;
	}
	allocateShobunCost=Math.round(Math.floor(allocateShobunCost*Math.pow(10,7))/10)/Math.pow(10,6);
//率計算共通仮設費対象額(P)=共通仮設費対象額-直接工事費に含まれる処分費+計上対象処分費.
	P=coverageKyoutsuukasetsu-cost[9]+allocateShobunCost;
	P=Math.round(Math.floor(P*Math.pow(10,7))/10)/Math.pow(10,6);
//率計算イメージアップ経費対象額=直接工事費-直接工事費に含まれる処分費等+イメージアップ経費対象支給品費等+無償貸与機械等評価額.
	Pi=cost[1]-cost[9]+cost[7]+cost[5];
	if(Pi>500000000){
		rateImageup=0.69;
		Pi=500000000;
	}
	else
	if(Pi>0){
		rateImageup=11*Math.pow(Pi,-0.138);
	}
	else{
		rateImageup=0;
	}
	rateImageup=Math.round(Math.floor(rateImageup*allocateImageup*1000)/10)/100;
	originalRateImageup=rateImageup;
/*20160503
//	if(correctionArea==1){    //2015/05/28
//	if(correctionBigcity==0){ //2015/05/28
	if(correctionBigcity==0 || correctionArea==1){ //2015/07/10
		correctionRateImageup=1.5*allocateImageup;
	}
	else{
		correctionRateImageup=0;
	}
20160503*/	
	rateImageup=Math.round(Math.floor((rateImageup+correctionRateImageup)*1000)/10)/100;
	Ki=(Pi*rateImageup/100)*allocateImageup;
	Ki=Math.round(Math.floor(Ki*Math.pow(10,7))/10)/Math.pow(10,6);
	Ki=Math.floor(Ki/Math.pow(10,ketaMarume))*Math.pow(10,ketaMarume);
	imageupCostTotal=Math.floor((Ki+cost[11])/Math.pow(10,ketaMarume))*Math.pow(10,ketaMarume);
//共通仮設費率の計算
	if(constructionSegment<=10){
		lowerLimit=6000000;
		upperLimit=1000000000;
	}
	else
	if(constructionSegment<=12){
		lowerLimit=6000000;
		upperLimit=100000000;
	}
	else
	if(constructionSegment<=18){
		lowerLimit=10000000;
		upperLimit=2000000000;
	}
	else
	if(constructionSegment<=20){
		lowerLimit=300000000;
		upperLimit=5000000000;
	}
//20160503	
	else
	if(constructionSegment==21){
		lowerLimit=6000000;
		upperLimit=300000000;
	}
//20160503	
	if(P<=lowerLimit){
		rateKyoutsuukasetsu=rateKyoutsuukasetsuList[constructionSegment][0];
	}
	else
	if(upperLimit<P){
		rateKyoutsuukasetsu=rateKyoutsuukasetsuList[constructionSegment][3];
	}
	else{
		rateKyoutsuukasetsu=rateKyoutsuukasetsuList[constructionSegment][1]*Math.pow(P,rateKyoutsuukasetsuList[constructionSegment][2]);
	}
	rateKyoutsuukasetsu=Math.round(Math.floor(rateKyoutsuukasetsu*1000)/10)/100;
	originalRateKyoutsuukasetsu=rateKyoutsuukasetsu;
//共通仮設費率大都市補正
/*
	if(correctionBigcity==1){
		rateKyoutsuukasetsuBigsityCorrection=1.5;
	}
	else
	if(correctionBigcity==2){
		rateKyoutsuukasetsuBigsityCorrection=1;
	}
	else{
		if(constructionSegment==4 || constructionSegment==6 || constructionSegment==9 || constructionSegment==11){//2015/07/10
			rateKyoutsuukasetsuBigsityCorrection=1.3;
		}//2015/07/10
		else{//2015/07/10
			rateKyoutsuukasetsuBigsityCorrection=1;//2015/07/10
		}//2015/07/10
	}	
*/
//20160503	
	if(correctionBigcity==0){
		rateKyoutsuukasetsuBigsityCorrection=1.0;//非適用
	}
	else
	if(correctionBigcity==1){
		rateKyoutsuukasetsuBigsityCorrection=2.0;//大都市補正(1)
	}
	else
	if(correctionBigcity==2){
		rateKyoutsuukasetsuBigsityCorrection=1.5;//大都市補正(2)
	}
	else{
		rateKyoutsuukasetsuBigsityCorrection=1.3;//地域補正
	}
//20160503	
	rateKyoutsuukasetsu=rateKyoutsuukasetsuBigsityCorrection*rateKyoutsuukasetsu;
//共通仮設費率施工地補正
/*
	if(constructionSegment!=9 && constructionSegment!=19 && constructionSegment!=20){
		if(correctionArea==1){
			if(constructionSegment!=4 && constructionSegment!=6 && constructionSegment!=9 && constructionSegment!=11){//2015/07/10
				rateKyoutsuukasetsuAreaCorrection=2;
			}//2015/07/10
			else{//2015/07/10
				rateKyoutsuukasetsuAreaCorrection=0;//2015/07/10
			}//2015/07/10	
		}
		else
		if(correctionArea==2){
			rateKyoutsuukasetsuAreaCorrection=1;
		}
		else
		if(correctionArea==3){
			rateKyoutsuukasetsuAreaCorrection=1.5;
		}
		else{
			rateKyoutsuukasetsuAreaCorrection=0;
		}
	}
	else{
		rateKyoutsuukasetsuAreaCorrection=0;
	}
*/	
//20160503
	if(correctionArea==1){
		rateKyoutsuukasetsuAreaCorrection=2;
	}
	else
	if(correctionArea==2){
		rateKyoutsuukasetsuAreaCorrection=1;
	}
	else
	if(correctionArea==3){
		rateKyoutsuukasetsuAreaCorrection=1.5;
	}
	else{
		rateKyoutsuukasetsuAreaCorrection=0;
	}
//20160503
	rateKyoutsuukasetsu=Math.round(Math.floor((rateKyoutsuukasetsu+rateKyoutsuukasetsuAreaCorrection)*1000)/10)/100;
	if(P<=lowerLimit || upperLimit<P){
		kyoutsuuKasetsuCoefA="*";
		kyoutsuuKasetsuCoefb="*";
	}
	else{
		kyoutsuuKasetsuCoefA=rateKyoutsuukasetsuList[constructionSegment][1];
		kyoutsuuKasetsuCoefb=rateKyoutsuukasetsuList[constructionSegment][2];
	}
	kyoutsuuKasetsuByRate=P*rateKyoutsuukasetsu/100;
	kyoutsuuKasetsuByRate=Math.round(Math.floor(kyoutsuuKasetsuByRate*Math.pow(10,7))/10)/Math.pow(10,6);
	kyoutsuuKasetsuByRate=Math.floor(kyoutsuuKasetsuByRate/Math.pow(10,ketaMarume))*Math.pow(10,ketaMarume);
	expenseKyoutsuuKasetsu=kyoutsuuKasetsuByRate+Ki+cost[4]+cost[11]+cost[12];
	expenseKyoutsuuKasetsu=Math.round(Math.floor(expenseKyoutsuuKasetsu*Math.pow(10,7))/10)/Math.pow(10,6);
	expenseKyoutsuuKasetsu=Math.floor(expenseKyoutsuuKasetsu/Math.pow(10,ketaMarume))*Math.pow(10,ketaMarume);
}

function calcStep2(){ 
//現場管理費率係数
	rateGenbakanriList=new Array();
	rateGenbakanriList[0]=[42.02,1169,-0.211,14.75];//河川工事
//	rateGenbakanriList[1]=[28.22,52.6,-0.0395,23.2];//河川・道路構造物工事
	rateGenbakanriList[1]=[41.29,420.8,-0.1473,19.88];//河川・道路構造物工事 20160503
	rateGenbakanriList[2]=[26.9,104,-0.0858,17.57];//海岸工事
	rateGenbakanriList[3]=[32.73,80,-0.0567,24.71];//道路改良工事
//	rateGenbakanriList[4]=[39.06,105.6,-0.0631,28.56];//鋼橋架設工事
	rateGenbakanriList[4]=[46.66,276.1,-0.1128,26.66];//鋼橋架設工事 20160503
	rateGenbakanriList[5]=[30.09,113.1,-0.084,19.84];//Ｐ・Ｃ橋工事
	rateGenbakanriList[6]=[39.39,622.2,-0.1751,16.52];//舗装工事
	rateGenbakanriList[7]=[44.58,1281.7,-0.2131,15.48];//砂防・地すべり等工事
	rateGenbakanriList[8]=[41.68,366.3,-0.1379,21.03];//公園工事
	rateGenbakanriList[9]=[58.82,2235.6,-0.2308,18.72];//電線共同溝工事
	rateGenbakanriList[10]=[52.66,1570,-0.2154,18.08];//情報ボックス工事
//	rateGenbakanriList[11]=[51.14,316.8,-0.1257,31.27];//道路維持工事
	rateGenbakanriList[11]=[58.61,605.1,-0.1609,31.23];//道路維持工事 20160503
	rateGenbakanriList[12]=[41.28,166.7,-0.0962,28.34];//河川維持工事
	rateGenbakanriList[13]=[48.95,367.7,-0.1251,25.23];//共同溝等工事(1)
	rateGenbakanriList[14]=[37.5,110.6,-0.0671,26.28];//共同溝等工事(2)
	rateGenbakanriList[15]=[43.96,203.6,-0.0951,26.56];//トンネル工事
	rateGenbakanriList[16]=[33.46,50.8,-0.0259,29.17];//下水道工事(1)
	rateGenbakanriList[17]=[36.91,213.5,-0.1089,20.73];//下水道工事(2)
	rateGenbakanriList[18]=[31.58,48.4,-0.0265,27.44];//下水道工事(3)
	rateGenbakanriList[19]=[22.6,301.3,-0.1327,15.56];//コンクリートダム
	rateGenbakanriList[20]=[33.08,166.5,-0.0828,26.2];//フィルダム
	rateGenbakanriList[21]=[63.1,1508.7,-0.2014,29.6];//橋梁保全工事 20160503
/*	
	rateGenbakanriList[0]=[38.13,862.8,-0.1979,14.28];//河川工事 
	rateGenbakanriList[1]=[25.89,40,-0.0276,22.58];//河川・道路構造物工事 
	rateGenbakanriList[2]=[24.58,78.3,-0.0735,17.07];//海岸工事 
	rateGenbakanriList[3]=[29.53,57.8,-0.0426,23.91];//道路改良工事 
	rateGenbakanriList[4]=[36.07,81.6,-0.0518,27.89];//鋼橋架設工事 
	rateGenbakanriList[5]=[27.79,88.1,-0.0732,19.33];//Ｐ・Ｃ橋工事 
	rateGenbakanriList[6]=[36.27,480.3,-0.1639,16.08];//舗装工事 
	rateGenbakanriList[7]=[40.98,987.6,-0.2019,15.05];//砂防・地すべり等工事 
	rateGenbakanriList[8]=[38.88,293.3,-0.1282,20.58];//公園工事 
	rateGenbakanriList[9]=[53.77,1686.2,-0.2186,18.18];//電線共同溝工事 
	rateGenbakanriList[10]=[48.51,1214.2,-0.2043,17.6];//情報ボックス工事 
	rateGenbakanriList[11]=[40.5,264.7,-0.1191,29.51];//道路維持工事 
	rateGenbakanriList[12]=[34.3,142.6,-0.0904,26.97];//河川維持工事 
	rateGenbakanriList[13]=[45.93,290.8,-0.1145,25.04];//共同溝等工事 
	rateGenbakanriList[14]=[35,85.9,-0.0557,26.06];//
	rateGenbakanriList[15]=[41.15,159.6,-0.0841,26.35];//トンネル工事 
	rateGenbakanriList[16]=[30.29,35.3,-0.0095,28.8];//下水道工事 
	rateGenbakanriList[17]=[34.43,166.3,-0.0977,20.52];//
	rateGenbakanriList[18]=[29.71,38.7,-0.0164,27.24];//
	rateGenbakanriList[19]=[21.73,229.7,-0.1208,15.47];//コンクリートダム 
	rateGenbakanriList[20]=[31.7,123.8,-0.0698,26.05];//フィルダム 
*/	
//純工事費
	costJyunkouji=expenseKyoutsuuKasetsu+cost[1];
	costJyunkouji=Math.round(Math.floor(costJyunkouji*Math.pow(10,7))/10)/Math.pow(10,6);
	costJyunkouji=Math.floor(costJyunkouji/Math.pow(10,ketaMarume))*Math.pow(10,ketaMarume);
//率計算現場管理費対象額=直接工事費-鋼橋門扉等工場原価+無償貸与機械等評価額+共通仮設費+現場管理費対象支給品費等-直工に含まれる準備費-準備費に含まれる処分費+計上対象処分費.
	Np=cost[1]-cost[3]+cost[5]+expenseKyoutsuuKasetsu+cost[8]-cost[9]-cost[10]+allocateShobunCost;
	if(constructionSegment<=10){
		lowerLimit=7000000;
		upperLimit=1000000000;
	}
	else
	if(constructionSegment<=12){
		lowerLimit=7000000;
		upperLimit=100000000;
	}
	else
	if(constructionSegment<=18){
		lowerLimit=10000000;
		upperLimit=2000000000;
	}
	else
	if(constructionSegment<=20){
		lowerLimit=300000000;
		upperLimit=5000000000;
	}
//20160503	
	else
	if(constructionSegment==21){
		lowerLimit=7000000;
		upperLimit=300000000;
	}
//20160503	
	if(Np<=lowerLimit){
	rateGenbakanri=rateGenbakanriList[constructionSegment][0];
	}
	else
	if(upperLimit<Np){
	rateGenbakanri=rateGenbakanriList[constructionSegment][3];
	}
	else{
	rateGenbakanri=rateGenbakanriList[constructionSegment][1]*Math.pow(Np,rateGenbakanriList[constructionSegment][2]);
	}
	rateGenbakanri=Math.round(Math.floor(rateGenbakanri*1000)/10)/100;
	originalRateGenbakanri=rateGenbakanri;
//現場管理費率大都市補正
/*20160503
	if(correctionBigcity==1){
		genbakanriBigcityCorrection=1.2;
	}
	else
	if(correctionBigcity==2){
		genbakanriBigcityCorrection=1;
	}
	else{
		if(constructionSegment==4 || constructionSegment==6 || constructionSegment==9 || constructionSegment==11){//2015/07/10
			genbakanriBigcityCorrection=1.1;
		}//2015/07/10
		else{//2015/07/10
			genbakanriBigcityCorrection=1;//2015/07/10
		}//2015/07/10
	}
*/
//20160503
	if(correctionBigcity==0){
		genbakanriBigcityCorrection=1.0;//非適用
	}
	else
	if(correctionBigcity==1){
		genbakanriBigcityCorrection=1.2;//大都市補正(1)
	}
	else
	if(correctionBigcity==2){
		genbakanriBigcityCorrection=1.2;//大都市補正(2)
	}
	else{
		genbakanriBigcityCorrection=1.1;//地域補正
	}
//20160503
	rateGenbakanri=genbakanriBigcityCorrection*rateGenbakanri;
//現場管理費率施工地補正	
/*
	if(constructionSegment!=9 && constructionSegment!=19 && constructionSegment!=20){
		if(correctionArea==1){
			if(constructionSegment!=4 && constructionSegment!=6 && constructionSegment!=9 && constructionSegment!=11){//2015/07/10
				rateGenbakanriAreaCorrection=1.5;
			}//2015/07/10
			else{//2015/07/10
				rateGenbakanriAreaCorrection=0;//2015/07/10
			}//2015/07/10	
		}
		else
		if(correctionArea==2){
			rateGenbakanriAreaCorrection=0.5;
		}
		else
		if(correctionArea==3){
			rateGenbakanriAreaCorrection=1;
		}
		else{
			rateGenbakanriAreaCorrection=0;
		}
	}
	else{
		rateGenbakanriAreaCorrection=0;
	}
*/
//20160503
	if(correctionArea==1){
		rateGenbakanriAreaCorrection=1.5;
	}
	else
	if(correctionArea==2){
		rateGenbakanriAreaCorrection=0.5;
	}
	else
	if(correctionArea==3){
		rateGenbakanriAreaCorrection=1;
	}
	else{
		rateGenbakanriAreaCorrection=0;
	}
//20160503
	rateGenbakanri=Math.round(Math.floor((rateGenbakanri+rateGenbakanriAreaCorrection)*1000)/10)/100;
	if(Np<=lowerLimit || upperLimit<Np){
		genbaKanriCoefA="*";
		genbaKanriCoefb="*";
	}
	else{
		genbaKanriCoefA=rateGenbakanriList[constructionSegment][1];
		genbaKanriCoefb=rateGenbakanriList[constructionSegment][2];
	}
	rateGenbakanri=Math.round(Math.floor((rateGenbakanri+correctionPeriod)*Math.pow(10,7))/10)/Math.pow(10,6);
	expenseGenbaKanri=Np*rateGenbakanri/100;
	expenseGenbaKanri=Math.round(Math.floor(expenseGenbaKanri*Math.pow(10,7))/10)/Math.pow(10,6);
	expenseGenbaKanri=Math.floor(expenseGenbaKanri/Math.pow(10,ketaMarume))*Math.pow(10,ketaMarume);
	costKoujiGenka=costJyunkouji+expenseGenbaKanri;
	costKoujiGenka=Math.round(Math.floor(costKoujiGenka*Math.pow(10,7))/10)/Math.pow(10,6);
	costKoujiGenka=Math.floor(costKoujiGenka/Math.pow(10,ketaMarume))*Math.pow(10,ketaMarume);
}

function calcStep3(){ 
//率計算一般管理費対象額=直接工事費-直工に含まれる準備費-準備費に含まれる処分費+共通仮設費+現場管理費+計上対象処分費.
	Gp=cost[1]-cost[9]-cost[10]+expenseKyoutsuuKasetsu+expenseGenbaKanri+allocateShobunCost;
	if(Gp<=5000000){
		//rateIppanKanri=14.38;
		rateIppanKanri=20.29;
	}
	else
	if(3000000000<Gp){
		//rateIppanKanri=7.22;
		rateIppanKanri=7.41;
	}
	else{
		//rateIppanKanri=-2.57651*Math.LOG10E*Math.log(Gp)+31.63531
		rateIppanKanri=-4.63586*Math.LOG10E*Math.log(Gp)+51.34242
	}
	rateIppanKanri=Math.round(Math.floor(rateIppanKanri*1000)/10)/100;
	originalRateIppankanri=rateIppanKanri;
	rateIppanKanri=Math.round(Math.floor((rateIppanKanri*correctionMaebaraikin+correctionContract)*1000)/10)/100;
	expenseIppanKanri=Gp*rateIppanKanri/100;
	expenseIppanKanri=Math.round(Math.floor(expenseIppanKanri*Math.pow(10,7))/10)/Math.pow(10,6);
	expenseIppanKanri=Math.floor(expenseIppanKanri/Math.pow(10,ketaMarume))*Math.pow(10,ketaMarume);
//工事価格
	costKoujiKakaku=costKoujiGenka+expenseIppanKanri;
	costKoujiKakaku=Math.round(Math.floor(costKoujiKakaku*Math.pow(10,7))/10)/Math.pow(10,6);
	costKoujiKakaku=Math.floor(costKoujiKakaku/Math.pow(10,ketaMarume))*Math.pow(10,ketaMarume);
//消費税
	consumptionTax=Math.floor(rateConsumptionTax/100*costKoujiKakaku);
//工事費
	finalConstructionCost=costKoujiKakaku+consumptionTax;
	finalConstructionCost=Math.round(Math.floor(finalConstructionCost*Math.pow(10,7))/10)/Math.pow(10,6);
	finalConstructionCost=Math.floor(finalConstructionCost/Math.pow(10,ketaMarume))*Math.pow(10,ketaMarume);
//諸経費費合計
	totalExpense=expenseKyoutsuuKasetsu+expenseGenbaKanri+expenseIppanKanri;
	totalExpense=Math.round(Math.floor(totalExpense*Math.pow(10,7))/10)/Math.pow(10,6);
	if(cost[1]!=0){
		rateTotalExpense=Math.round(Math.floor(totalExpense/cost[1]*100*1000)/10)/100
	}
	else{
		rateTotalExpense=0;
	}
	number=new Array();
	for(i=1; i<=12; i++){
		number[i]=cost[i];
	}
	number[13]=P;//率計算共通仮設費対象額
	number[14]=Pi;//率計算イメージアップ経費対象額
	number[15]=allocateShobunCost;//計上対象処分費
	number[16]=Ki;//率計算分イメージアップ経費
	number[17]=kyoutsuuKasetsuByRate;//率計算分共通仮設費
	number[18]=expenseKyoutsuuKasetsu;//共通仮設費
	number[19]=costJyunkouji;//純工事費
	number[20]=Np;//率計算現場管理費対象額
	number[21]=expenseGenbaKanri;//現場管理費
	number[22]=costKoujiGenka;//工事原価
	number[23]=Gp;//率計算一般管理費対象額
	number[24]=expenseIppanKanri;//一般管理費
	number[25]=costKoujiKakaku;//工事価格
	number[26]=consumptionTax;//消費税
	number[27]=finalConstructionCost;//工事費
	number[28]=totalExpense;//共通費合計
	number[29]=coverageKyoutsuukasetsu;//共通仮設費対象額
	z=30;
}

function output01(){
	document.form2.constructionSegment.value=constructionType[constructionSegment];
	document.form2.a.value=number[1];
	document.form2.costJyunkouji.value=number[19];
	document.form2.costKoujiGenka.value=number[22];
	document.form2.costKoujiKakaku.value=number[25];
	document.form2.consumptionTax.value=number[26];
	document.form2.finalConstructionCost.value=number[27];
}

function output02(){
	document.form3.expenseKyoutsuukasetsu.value=number[18];
	document.form3.expenseGenbakanri.value=number[21];
	document.form3.expenseIppankanri.value=number[24];
	document.form3.totalExpense.value=number[28];
	document.form3.rateTotalExpense.value=rateTotalExpense;
	document.form3.rateImageup.value=rateImageup;
	document.form3.rateKyoutsuukasetsu.value=rateKyoutsuukasetsu;
	document.form3.rateGenbakanri.value=rateGenbakanri;
	document.form3.rateIppanKanri.value=rateIppanKanri;
	document.form3.coverageKyoutsuukasetsu.value=number[29];
	document.form3.ratio.value=ratio.toExponential(6);
	document.form3.P.value=number[13];
	document.form3.Pi.value=number[14];
	document.form3.allocateShobunCost.value=number[15];
	document.form3.Ki.value=number[16];
	document.form3.kyoutsuuKasetsuByRate.value=number[17];
	document.form3.Np.value=number[20];
	document.form3.Gp.value=number[23];
}
-->