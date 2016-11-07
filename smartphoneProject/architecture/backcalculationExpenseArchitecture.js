<!--
function BCgetConditions(){//要parseFloat処理.
	KoujiShubetsu=parseFloat(document.form1.KoujiShubetsu.value);
	switch(KoujiShubetsu){
		case 1://新築建築工事
			KoujiType="新営-建築工事";break;
		case 2://改修建築工事
			KoujiType="改修-建築工事";break;
		case 3://新築電気設備工事
			KoujiType="新営-電気設備工事";break;
		case 4://改修電気設備工事
			KoujiType="改修-電気設備工事";break;
		case 5://新築機械設備工事
			KoujiType="新営-機械設備工事";break;
		case 6://改修機械設備工事
			KoujiType="改修-機械設備工事";break;
		case 7://昇降機設備工事
			KoujiType="昇降機設備工事";break;
	}
	finalcostKouji=parseFloat(document.form1.finalcostKouji.value.replace(/,/g, ''));
	costTumiageKyoutsuuKasetsu=parseFloat(document.form1.costTumiageKyoutsuuKasetsu.value.replace(/,/g, ''));
	hoseiKyoutsuuKasetsu=parseFloat(document.form1.hoseiKyoutsuuKasetsu.value);
	hoseiGenbaKanri=parseFloat(document.form1.hoseiGenbaKanri.value);
	hoseiIppanKanri=parseFloat(document.form1.hoseiIppanKanri.value);
	costTumiageGenbaKanri=parseFloat(document.form1.costTumiageGenbaKanri.value.replace(/,/g, ''));
	hoseiKeiyakuHoshou=parseFloat(document.form1.hoseiKeiyakuHoshou.value);
	hoseiKanriJimusho=parseFloat(document.form1.hoseiKanriJimusho.value);
	hoseiMaebaraikinKubun=parseFloat(document.form1.hoseiMaebaraikinKubun.value);
	Kouki=parseFloat(document.form1.Kouki.value);
	ConsumptionTaxRate=parseFloat(document.form1.ConsumptionTaxRate.value);
	if(isNaN(costTumiageKyoutsuuKasetsu) || costTumiageKyoutsuuKasetsu<0){costTumiageKyoutsuuKasetsu=0;}
	if(isNaN(costTumiageGenbaKanri) || costTumiageGenbaKanri<0){costTumiageGenbaKanri=0;}
	if(isNaN(hoseiKyoutsuuKasetsu) || hoseiKyoutsuuKasetsu<=0){hoseiKyoutsuuKasetsu=1;}
	if(isNaN(hoseiGenbaKanri) || hoseiGenbaKanri<=0){hoseiGenbaKanri=1;}
	if(isNaN(hoseiIppanKanri) || hoseiIppanKanri<=0){hoseiIppanKanri=1;}
	T=Kouki;
}

//消費税分の逆算
function BCcalKouji(){
	costKouji=Math.ceil(finalcostKouji/(1+ConsumptionTaxRate));
	consumptionTax=finalcostKouji-costKouji;
}

//工事原価の逆算
function BCexpenseIppanKanri(){//一般管理費
	coefGp();
	for(tmpGp=f; tmpGp<=e; tmpGp=tmpGp+0.01){
		tmpGp=Math.round(Math.floor(tmpGp*Math.pow(10,7))/10)/Math.pow(10,6);
		tmpGpAfter=tmpGp*hoseiMaebaraikinKubun*hoseiIppanKanri+hoseiKeiyakuHoshou;
		tmpcostKoujiGenka=costKouji/((100+tmpGpAfter)/100);
		if(d<=tmpcostKoujiGenka){
			bufGp=f;
		}else if(tmpcostKoujiGenka<=c){
			bufGp=e;
		}else{
			bufGp=a-b*Math.LOG10E*Math.log(tmpcostKoujiGenka/1000);
		}
		if(Math.abs(tmpGp-bufGp)<0.01){
			costKoujiGenka=costKouji/((100+tmpGpAfter)/100);
			break;	
		}
	}	
	Gp=tmpGp;
	costKoujiGenka=Math.ceil(costKoujiGenka);
	expIppanKanri=costKouji-costKoujiGenka;
}

//工事原価の逆算用係数
function coefGp(){
	switch(KoujiShubetsu){
		//Gp=a-b*log10(Cp),Cp:工事原価(千円)
		//c:工事原価下限閾値,d:工事原価上限閾値,e:工事原価下限閾値一般管理費率,f:工事原価上限閾値一般管理費率
		case 1://新築建築工事
		case 2://改修建築工事
			a=15.065;b=1.028;c=5*Math.pow(10,6);d=3*Math.pow(10,9);e=11.26;f=8.41;break;
		case 3://新築電気設備工事
		case 4://改修電気設備工事
			a=17.286;b=1.577;c=3*Math.pow(10,6);d=2*Math.pow(10,9);e=11.8;f=7.35;break;
		case 5://新築機械設備工事
		case 6://改修機械設備工事
		case 7://昇降機設備工事
			a=15.741;b=1.305;c=3*Math.pow(10,6);d=2*Math.pow(10,9);e=11.2;f=7.52;break;
	}	
}

//純工事費の逆算
function BCexpenseGenbaKanri(){//現場管理費
	tmpcostKoujiGenka=costKoujiGenka-costTumiageGenbaKanri;
	if(KoujiShubetsu==7){//昇降機設備工事
		coefJo();
		for(tmpJo=f; tmpJo<=e; tmpJo=tmpJo+0.01){
			tmpJo=Math.round(Math.floor(tmpJo*Math.pow(10,7))/10)/Math.pow(10,6);	
			tmpJoAfter=tmpJo*hoseiGenbaKanri;
			tmpcostJyunKouji=tmpcostKoujiGenka/((100+tmpJoAfter)/100);
			if(d<=tmpcostJyunKouji){
				bufJo=f;
			}else if(tmpcostJyunKouji<=c){
				bufJo=e;
			}else{
				bufJo=a*Math.pow(tmpcostJyunKouji/1000,b);
			}
			if(Math.abs(tmpJo-bufJo)<0.01){
				costJyunKouji=tmpcostKoujiGenka/((100+tmpJoAfter)/100);
				break;	
			}			
		}
	}else{
		coefJo();
		for(tmpJo=eu; 0<tmpJo; tmpJo=tmpJo-0.01){
			tmpJo=Math.round(Math.floor(tmpJo*Math.pow(10,7))/10)/Math.pow(10,6);
			tmpJoAfter=tmpJo*hoseiGenbaKanri;
			tmpcostJyunKouji=tmpcostKoujiGenka/((100+tmpJoAfter)/100);
			bufJo=a*Math.pow(tmpcostJyunKouji/1000,b)*Math.pow(T,c);
			if(tmpcostJyunKouji<=d){
				bufJoLower=el;
				bufJoUpper=eu;
			}else{
				bufJoLower=fl*Math.pow(tmpcostJyunKouji/1000,g);
				bufJoUpper=fu*Math.pow(tmpcostJyunKouji/1000,g);
			}	
			bufJo=Math.max(Math.min(bufJo,bufJoUpper),bufJoLower);
			if(Math.abs(tmpJo-bufJo)<0.01){
				costJyunKouji=tmpcostKoujiGenka/((100+tmpJoAfter)/100);
				break;	
			}
		}
	}
	Jo=tmpJo;
	costJyunKouji=Math.ceil(costJyunKouji);
	expGenbaKanri=costKoujiGenka-costJyunKouji;
}

//純工事費の逆算用係数
function coefJo(){
if(KoujiShubetsu==7){//昇降機設備工事
		//Jo=a*Np^b,Np:純工事費(千円)
		//c:純工事費下限閾値,d:純工事費上限閾値,e:純工事費下限閾値現場管理費率,f:純工事費上限閾値現場管理費率
		a=15.1;b=-0.1449;c=Math.pow(10,7);d=5*Math.pow(10,8);e=3.98;f=2.26;
	}else{
		switch(KoujiShubetsu){
			//Jo=a*Np^b*T^c,Np:純工事費(千円)
			//純工事費閾値を超える純工事費.現場管理費率.上限=fu*Np^g
			//純工事費閾値を超える純工事費.現場管理費率.下限=fl*Np^g
			//d:純工事費閾値,eu:純工事費閾値以下上限共通仮設費率,el:純工事費閾値以下下限共通仮設費率
			case 1://新築建築工事
				a=151.08;b=-0.3396;c=0.586;d=Math.pow(10,7);eu=20.13;el=10.01;fu=75.97;fl=37.76;g=-0.1442;break;
			case 2://改修建築工事
				a=356.2;b=-0.4085;c=0.5766;d=5*Math.pow(10,6);eu=26.86;el=12.7;fu=184.58;fl=87.29;g=-0.2263;break;
			case 3://新築電気設備工事
				a=351.48;b=-0.3528;c=0.3524;d=5*Math.pow(10,6);eu=38.6;el=22.91;fu=263.03;fl=156.07;g=-0.2253;break;
			case 4://改修電気設備工事
				a=658.42;b=-0.4896;c=0.7247;d=3*Math.pow(10,6);eu=50.37;el=17.67;fu=530.68;fl=186.18;g=-0.2941;break;
			case 5://新築機械設備工事
				a=152.72;b=-0.3085;c=0.4222;d=5*Math.pow(10,6);eu=31.23;el=17.14;fu=165.22;fl=90.67;g=-0.1956;break;
			case 6://改修機械設備工事
				a=825.85;b=-0.5122;c=0.6648;d=3*Math.pow(10,6);eu=42.07;el=15.25;fu=467.95;fl=169.65;g=-0.3009;break;
		}
	}	
}	

//直接工事費の逆算
function BCexpenseKyoutsuuKasetsu(){//共通仮設費
//	tmpcostChokusetsuKouji=costJyunKouji-costTumiageKyoutsuuKasetsu;
	tmpcostJyunKouji=costJyunKouji-costTumiageKyoutsuuKasetsu;
	hoseiKanriJimushoKyoutsuuKasetsu=1;
	if(hoseiKanriJimusho==2){//監理事務所を設けない場合
		hoseiKanriJimushoKyoutsuuKasetsu=0.9;
	}
	if(KoujiShubetsu==7){//昇降機設備工事
		coefKr();
		for(tmpKr=f; tmpKr<=e; tmpKr=tmpKr+0.01){
			tmpKr=Math.round(Math.floor(tmpKr*Math.pow(10,7))/10)/Math.pow(10,6);	
			tmpKrAfter=tmpKr*hoseiKanriJimushoKyoutsuuKasetsu*hoseiKyoutsuuKasetsu;	
			tmpcostChokusetsuKouji=tmpcostJyunKouji/((100+tmpKrAfter)/100);
			if(d<=tmpcostChokusetsuKouji){
				bufKr=f;
			}else if(tmpcostChokusetsuKouji<=c){
				bufKr=e;
			}else{
				bufKr=a*Math.pow(tmpcostChokusetsuKouji/1000,b);
			}
			if(Math.abs(tmpKr-bufKr)<0.01){
				costChokusetsuKouji=tmpcostJyunKouji/((100+tmpKrAfter)/100);
				break;	
			}			
		}		
	}else{
		coefKr();
		for(tmpKr=eu; 0<tmpKr; tmpKr=tmpKr-0.01){
			tmpKr=Math.round(Math.floor(tmpKr*Math.pow(10,7))/10)/Math.pow(10,6);
			tmpKrAfter=tmpKr*hoseiKanriJimushoKyoutsuuKasetsu*hoseiKyoutsuuKasetsu;	
			tmpcostChokusetsuKouji=tmpcostJyunKouji/((100+tmpKrAfter)/100);
			bufKr=a*Math.pow(tmpcostChokusetsuKouji/1000,b)*Math.pow(T,c);
			if(tmpcostChokusetsuKouji<=d){
				bufKrLower=el;
				bufKrUpper=eu;
			}else{
				bufKrLower=fl*Math.pow(tmpcostChokusetsuKouji/1000,g);
				bufKrUpper=fu*Math.pow(tmpcostChokusetsuKouji/1000,g);
			}	
			bufKr=Math.max(Math.min(bufKr,bufKrUpper),bufKrLower);
			if(Math.abs(tmpKr-bufKr)<0.01){
				costChokusetsuKouji=tmpcostJyunKouji/((100+tmpKrAfter)/100);
				break;	
			}
		}
	}
	Kr=tmpKr;
	origKr=Kr;
	costChokusetsuKouji=Math.ceil(costChokusetsuKouji);
	expKyoutsuuKasetsu=costJyunKouji-costChokusetsuKouji;
}

//直接工事費の逆算用係数
function coefKr(){
	if(KoujiShubetsu==7){//昇降機設備工事
		//Kr=a*P^b,P:直接工事費(千円)
		//c:直接工事費下限閾値,d:直接工事費上限閾値,e:直接工事費下限閾値共通仮設費率,f:直接工事費上限閾値共通仮設費率
		a=7.89;b=-0.1021;c=Math.pow(10,7);d=5*Math.pow(10,8);e=3.08;f=2.07;
	}else{
		switch(KoujiShubetsu){
			//Kr=a*P^b*T^c,P:直接工事費(千円)
			//直接工事費閾値を超える直接工事費.共通仮設費率.上限=fu*P^g
			//直接工事費閾値を超える直接工事費.共通仮設費率.下限=fl*P^g
			//d:直接工事費閾値,eu:直接工事費閾値以下上限共通仮設費率,el:直接工事費閾値以下下限共通仮設費率
			case 1://新築建築工事
				a=7.56;b=-0.1105;c=0.2389;d=Math.pow(10,7);eu=4.33;el=3.25;fu=5.78;fl=4.34;g=-0.0313;break;
			case 2://改修建築工事
				a=18.03;b=-0.2027;c=0.4017;d=5*Math.pow(10,6);eu=6.07;el=3.59;fu=11.74;fl=6.94;g=-0.0774;break;
			case 3://新築電気設備工事
				a=22.89;b=-0.2462;c=0.41;d=5*Math.pow(10,6);eu=7.19;el=3.9;fu=16.73;fl=9.08;g=-0.0992;break;
			case 4://改修電気設備工事
				a=10.15;b=-0.2462;c=0.6929;d=3*Math.pow(10,6);eu=5.21;el=1.91;fu=8.47;fl=3.1;g=-0.0608;break;
			case 5://新築機械設備工事
				a=12.15;b=-0.1186;c=0.0882;d=5*Math.pow(10,6);eu=5.51;el=4.86;fu=12.4;fl=10.94;g=-0.0952;break;
			case 6://改修機械設備工事
				a=12.21;b=-0.2596;c=0.6874;d=3*Math.pow(10,6);eu=4.96;el=1.73;fu=7.02;fl=2.44;g=-0.0433;break;
		}	
	}
}

function BCcalculation(){ 
	BCgetConditions();
	if(isNaN(finalcostKouji)==false && isNaN(Kouki)==false && 0<finalcostKouji && 0<Kouki){
		BCcalKouji();
		BCexpenseIppanKanri();
		BCexpenseGenbaKanri();
		BCexpenseKyoutsuuKasetsu();
		expKyoutsuu=Math.floor(expIppanKanri+expGenbaKanri+expKyoutsuuKasetsu);
		rateKyoutsuu=Math.round(Math.floor(expKyoutsuu/costChokusetsuKouji*100*1000)/10)/100;
		number=new Array();
		number[1]=costChokusetsuKouji;
		number[2]=expKyoutsuuKasetsu;
		number[3]=expGenbaKanri;
		number[4]=expIppanKanri;
		number[5]=costJyunKouji;
		number[6]=costKoujiGenka;
		number[7]=costKouji;
		number[8]=expKyoutsuu;
		number[9]=consumptionTax;
		number[10]=finalcostKouji;
		number[11]=costTumiageKyoutsuuKasetsu;
		number[12]=costTumiageGenbaKanri;
		z=13;
		thousandSeparator();
		BCresultOuPut01();BCresultOuPut02();//clearBox('chart1');graph01();clearBox('chart2');graph02();clearBox('chart3');graph03();clearBox('chart4');graph04();
	}else{
		window.alert("注)工事費、工期を共に入力");
	}	
}

function BCresultOuPut01(){
	document.form1.costChokusetsuKouji.value=number[1];
	document.form2.KoujiType.value=KoujiType;
	document.form2.Kouki.value=Kouki;
	document.form2.finalcostKouji.value=number[10];
	document.form2.consumptionTax.value=number[9];
	document.form2.costKouji.value=number[7];
	document.form2.costKoujiGenka.value=number[6];
	document.form2.costJyunKouji.value=number[5];
	document.form2.costChokusetsuKouji.value=number[1];
	}

function BCresultOuPut02(){
	document.form3.expKyoutsuuKasetsu.value=number[2];
	document.form3.expGenbaKanri.value=number[3];
	document.form3.expIppanKanri.value=number[4];
	document.form3.costTumiageKyoutsuuKasetsu.value=number[11];
	document.form3.costTumiageGenbaKanri.value=number[12];
	document.form3.rateKyoutsuuKasetsu.value=Kr;
	document.form3.rateGenbaKanri.value=Jo;
	document.form3.rateIppanKanri.value=Gp;
	document.form3.expKyoutsuu.value=number[8];
	document.form3.rateKyoutsuu.value=rateKyoutsuu;
	document.form3.hoseiMaebaraikinKubun.value=hoseiMaebaraikinKubun;
	document.form3.hoseiKeiyakuHoshou.value=hoseiKeiyakuHoshou;
	document.form3.hoseiKanriJimushoKyoutsuuKasetsu.value=hoseiKanriJimushoKyoutsuuKasetsu;
	document.form3.hoseiKyoutsuuKasetsu.value=hoseiKyoutsuuKasetsu;
	document.form3.hoseiGenbaKanri.value=hoseiGenbaKanri;
	document.form3.hoseiIppanKanri.value=hoseiIppanKanri;
}

function graph01(){
	$(document).ready(function(){
		var data = [
		['直接工事費', costChokusetsuKouji],['共通仮設費', expKyoutsuuKasetsu], ['現場管理費', expGenbaKanri], ['一般管理費', expIppanKanri],['消費税', consumptionTax]
		];
		var plot1 = jQuery.jqplot ('chart1', [data], 
		{ 
		seriesDefaults: {
			renderer: jQuery.jqplot.PieRenderer, 
			rendererOptions: {
			showDataLabels: true
			}
		}, 
		legend: { show:true, location: 'e' }
		}
		);
	});
}

function graph02(){//共通仮設費率
	$(document).ready(function(){
		coefKr();
		var graphData01 = [];
		if(KoujiShubetsu==7){
			start=c;
			end=50*Math.pow(10,8);
			labeltext="共通仮設費率:Kr="+a+"*P^"+b;	
		}else{
			start=d;
			end=50*Math.pow(10,8);
			labeltext="共通仮設費率:Kr="+a+"*P^"+b+"*T^"+c;	
		}
		step=(end-start)/50;
		minKr=100;
		for(P=start; P<end; P=P+step){
			if(KoujiShubetsu==7){//昇降機設備工事
				if(P<=c){
					Kr=e;
				}else if(P>d){
					Kr=f;
				}else{
					Kr=a*Math.pow(P/1000,b);
				}			
			}else{	
				bufKr=a*Math.pow(P/1000,b)*Math.pow(T,c);
				bufKrLower=fl*Math.pow(P/1000,g);
				bufKrUpper=fu*Math.pow(P/1000,g);
				Kr=Math.max(Math.min(bufKr,bufKrUpper),bufKrLower);	
				Kr=Math.round(Math.floor(Kr*1000)/10)/100;
			}
			graphData01.push([P/Math.pow(10,8), Kr]);
			minKr=Math.min(minKr,Kr);
		}		
		var plot02 = $.jqplot('chart2', [graphData01], 
			{ 
				title: KoujiType, 
				seriesDefaults: {
					rendererOptions: {
						smooth: true
					}
				},
				series:[ 
					{
						lineWidth:1 ,
						showLine:true,
						markerOptions:{show: false},
						label:labeltext
					}
				],
				axes:{
					xaxis:{
						label:'直接工事費(億円)',
						min: 0,//start/Math.pow(10,8),
						max: end/Math.pow(10,8),
						numberTicks: 5
					},
					yaxis:{
						label:'Kr',
						min: Math.floor(minKr)//,
						//max:
					}
				},
				legend: {
					show: true,
					location: 'ne',
					xoffset: 12,
					yoffset: 12
				}
			}
		);
	});		
}

function graph03(){//現場管理費率
	$(document).ready(function(){
		coefJo();
		var graphData02 = [];
		if(KoujiShubetsu==7){
			start=c;
			end=50*Math.pow(10,8);
			labeltext="現場管理費率:Jo="+a+"*Np^"+b;
		}else{
			start=d;
			end=50*Math.pow(10,8);
			labeltext="現場管理費率:Jo="+a+"*Np^"+b+"*T^"+c;
		}
		step=(end-start)/50;
		minJo=100;
		for(Np=start; Np<end; Np=Np+step){
			if(KoujiShubetsu==7){//昇降機設備工事
				if(Np<=c){
					Jo=e;
				}else if(Np>d){
					Jo=f;
				}else{
					Jo=a*Math.pow(Np/1000,b);
				}			
			}else{	
				bufJo=a*Math.pow(Np/1000,b)*Math.pow(T,c);
				bufJoLower=fl*Math.pow(Np/1000,g);
				bufJoUpper=fu*Math.pow(Np/1000,g);
				Jo=Math.max(Math.min(bufJo,bufJoUpper),bufJoLower);	
				Jo=Math.round(Math.floor(Jo*1000)/10)/100;
			}
			graphData02.push([Np/Math.pow(10,8), Jo]);
			minJo=Math.min(minJo,Jo);
		}		
		var plot03 = $.jqplot('chart3', [graphData02], 
			{ 
				title: KoujiType, 
				seriesDefaults: {
					rendererOptions: {
						smooth: true
					}
				},
				series:[ 
					{
						lineWidth:1 ,
						showLine:true,
						markerOptions:{show: false},
						label:labeltext
					}
				],
				axes:{
					xaxis:{
						label:'純工事費(億円)',
						min: 0,//start/Math.pow(10,8),
						max: end/Math.pow(10,8),
						numberTicks: 5
					},
					yaxis:{
						label:'Jo',
						min: Math.floor(minJo)//,
						//max:
					}
				},
				legend: {
					show: true,
					location: 'ne',
					xoffset: 12,
					yoffset: 12
				}
			}
		);
	});		
}

function graph04(){//一般管理費率
	$(document).ready(function(){
		coefGp();
		var graphData03 = [];
		start=c;
		end=50*Math.pow(10,8);
		step=(end-start)/50;
		minGp=100;
		labeltext="一般管理費率:Gp="+a+"-"+b+"*log(Cp)";	
		for(Cp=start; Cp<end; Cp=Cp+step){
			Gp=a-b*Math.LOG10E*Math.log(Cp/1000);
			Gp=Math.round(Math.floor(Gp*1000)/10)/100;
			graphData03.push([Cp/Math.pow(10,8), Gp]);
			minGp=Math.min(minGp,Gp);
		}		
		var plot04 = $.jqplot('chart4', [graphData03], 
			{ 
				title: KoujiType, 
				seriesDefaults: {
					rendererOptions: {
						smooth: true
					}
				},
				series:[ 
					{
						lineWidth:1 ,
						showLine:true,
						markerOptions:{show: false},
						label:labeltext
					}
				],
				axes:{
					xaxis:{
						label:'工事原価(億円)',
						min: 0,//start/Math.pow(10,8),
						max: end/Math.pow(10,8),
						numberTicks: 5
					},
					yaxis:{
						label:'Gp',
						min: Math.floor(minGp)//,
						//max:
					}
				},
				legend: {
					show: true,
					location: 'ne',
					xoffset: 12,
					yoffset: 12
				}
			}
		);
	});		
}

function clearBox(chart1){
    document.getElementById(chart1).innerHTML="";
}
function clearBox(chart2){
    document.getElementById(chart2).innerHTML="";
}
function clearBox(chart3){
    document.getElementById(chart3).innerHTML="";
}
function clearBox(chart4){
    document.getElementById(chart4).innerHTML="";
}
-->