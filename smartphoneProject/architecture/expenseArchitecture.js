//参考資料
//国土交通省大臣官房官庁営繕部.『公共建築工事積算基準等資料 平成26年版』
//国土交通省大臣官房官庁営繕部.『公共建築工事共通費積算基準 平成26年版』
<!-- //全変数グローバル扱いであることに留意.
function getConditions(){//要parseFloat処理.
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
	costChokusetsuKouji=parseFloat(document.form1.costChokusetsuKouji.value.replace(/,/g, ''));
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
	KetaMarume=parseFloat(document.form1.KetaMarume.value);
	if(isNaN(costTumiageKyoutsuuKasetsu) || costTumiageKyoutsuuKasetsu<0){costTumiageKyoutsuuKasetsu=0;}
	if(isNaN(costTumiageGenbaKanri) || costTumiageGenbaKanri<0){costTumiageGenbaKanri=0;}
	if(isNaN(hoseiKyoutsuuKasetsu) || hoseiKyoutsuuKasetsu<=0){hoseiKyoutsuuKasetsu=1;}
	if(isNaN(hoseiGenbaKanri) || hoseiGenbaKanri<=0){hoseiGenbaKanri=1;}
	if(isNaN(hoseiIppanKanri) || hoseiIppanKanri<=0){hoseiIppanKanri=1;}
	T=Kouki;
}

function roundOff(){
	tmp=Math.round(Math.floor(tmp*Math.pow(10,7))/10)/Math.pow(10,6);
	tmp=Math.round(Math.floor(tmp*1000)/10)/100;
}

function expenseKyoutsuuKasetsu(){//共通仮設費
	if(KoujiShubetsu==7){//昇降機設備工事
		//Kr=a*P^b,P:直接工事費(千円)
		//c:直接工事費下限閾値,d:直接工事費上限閾値,e:直接工事費下限閾値共通仮設費率,f:直接工事費上限閾値共通仮設費率
		a=7.89;b=-0.1021;c=Math.pow(10,7);d=5*Math.pow(10,8);e=3.08;f=2.07;
		if(costChokusetsuKouji<=c){rateKyoutsuuKasetsu=e;}
		else
		if(costChokusetsuKouji>d){rateKyoutsuuKasetsu=f;}
		else{
		rateKyoutsuuKasetsu=a*Math.pow(costChokusetsuKouji/1000,b);}
	}
	else{
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
		if(costChokusetsuKouji<=d){P=d/1000;}
		else{P=costChokusetsuKouji/1000;}
		Kr=a*Math.pow(P,b)*Math.pow(T,c);
		tmp=Kr;
		roundOff();
		Kr=tmp;
		if(costChokusetsuKouji<=d){
			tmprateKyoutsuuKasetsu=Math.max(Kr,el);
			tmprateKyoutsuuKasetsu=Math.min(tmprateKyoutsuuKasetsu,eu);
			KrUpperLimit=eu;
			KrLowerLimit=el;
		}
		else{
			KrUpperLimit=fu*Math.pow(P,g);
			tmp=KrUpperLimit;
			roundOff();
			KrUpperLimit=tmp;
			KrLowerLimit=fl*Math.pow(P,g);
			tmp=KrLowerLimit;
			roundOff();
			KrLowerLimit=tmp;
			tmprateKyoutsuuKasetsu=Math.max(Kr,KrLowerLimit);
			tmprateKyoutsuuKasetsu=Math.min(tmprateKyoutsuuKasetsu,KrUpperLimit);
		}
		rateKyoutsuuKasetsu=tmprateKyoutsuuKasetsu;
	}
	hoseiKanriJimushoKyoutsuuKasetsu=1;
	if(hoseiKanriJimusho==2){//監理事務所を設けない場合
		hoseiKanriJimushoKyoutsuuKasetsu=0.9;
	}
	rateKyoutsuuKasetsu=rateKyoutsuuKasetsu*hoseiKanriJimushoKyoutsuuKasetsu*hoseiKyoutsuuKasetsu;
	tmp=rateKyoutsuuKasetsu;
	roundOff();
	rateKyoutsuuKasetsu=tmp;
	expKyoutsuuKasetsu=costChokusetsuKouji*rateKyoutsuuKasetsu/100+costTumiageKyoutsuuKasetsu;
	tmp=expKyoutsuuKasetsu;
	roundOff();
	expKyoutsuuKasetsu=tmp;
	expKyoutsuuKasetsu=Math.floor(expKyoutsuuKasetsu/Math.pow(10,KetaMarume))*Math.pow(10,KetaMarume);
	costJyunKouji=costChokusetsuKouji+expKyoutsuuKasetsu;
	tmp=costJyunKouji;
	roundOff();
	costJyunKouji=tmp;
}

function expenseGenbaKanri(){//現場管理費
	if(KoujiShubetsu==7){//昇降機設備工事
		//Jo=a*Np^b,Np:純工事費(千円)
		//c:純工事費下限閾値,d:純工事費上限閾値,e:純工事費下限閾値現場管理費率,f:純工事費上限閾値現場管理費率
		a=15.1;b=-0.1449;c=Math.pow(10,7);d=5*Math.pow(10,8);e=3.98;f=2.26;
		if(costJyunKouji<=c){rateGenbaKanri=e;}
		else
		if(costJyunKouji>d){rateGenbaKanri=f;}
		else{
		rateGenbaKanri=a*Math.pow(costJyunKouji/1000,b);}
	}
	else{
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
		if(costJyunKouji<=d){Np=d/1000;}
		else{
			Np=costJyunKouji/1000;
		}
		Jo=a*Math.pow(Np,b)*Math.pow(T,c);
		tmp=Jo;
		roundOff();
		Jo=tmp;
		if(costJyunKouji<=d){
			tmprateGenbaKanri=Math.max(Jo,el);
			tmprateGenbaKanri=Math.min(tmprateGenbaKanri,eu);
			JoUpperLimit=eu;
			JoLowerLimit=el;
		}
		else{
			JoUpperLimit=fu*Math.pow(Np,g);
			tmp=JoUpperLimit;
			roundOff();
			JoUpperLimit=tmp;
			JoLowerLimit=fl*Math.pow(Np,g);
			tmp=JoLowerLimit;
			roundOff();
			JoLowerLimit=tmp;
			tmprateGenbaKanri=Math.max(Jo,JoLowerLimit);
			tmprateGenbaKanri=Math.min(tmprateGenbaKanri,JoUpperLimit);
		}
		rateGenbaKanri=tmprateGenbaKanri;
	}
	tmp=rateGenbaKanri*hoseiGenbaKanri;
	roundOff();
	rateGenbaKanri=tmp;
	expGenbaKanri=costJyunKouji*rateGenbaKanri/100+costTumiageGenbaKanri;
	tmp=expGenbaKanri;
	roundOff();
	expGenbaKanri=tmp;
	expGenbaKanri=Math.floor(expGenbaKanri/Math.pow(10,KetaMarume))*Math.pow(10,KetaMarume);
	costKoujiGenka=costJyunKouji+expGenbaKanri;
	tmp=costKoujiGenka;
	roundOff();
	costKoujiGenka=tmp;
}

function expenseIppanKanri(){//一般管理費
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
	if(costKoujiGenka<=c){rateIppanKanri=e;}
	else
	if(costKoujiGenka>d){rateIppanKanri=f;}
	else{
		rateIppanKanri=a-b*Math.LOG10E*Math.log(costKoujiGenka/1000);
	}
	rateIppanKanri=rateIppanKanri*hoseiMaebaraikinKubun*hoseiIppanKanri+hoseiKeiyakuHoshou;
	tmp=rateIppanKanri;
	roundOff();
	rateIppanKanri=tmp;
	expIppanKanri=costKoujiGenka*rateIppanKanri/100;
	tmp=expIppanKanri;
	roundOff();
	expIppanKanri=tmp;
	expIppanKanri=Math.floor(expIppanKanri/Math.pow(10,KetaMarume))*Math.pow(10,KetaMarume);
	costKouji=costKoujiGenka+expIppanKanri;
	tmp=costKouji;
	roundOff();
	costKouji=tmp;
}

function calKouji(){
	consumptionTax=Math.floor(costKouji*ConsumptionTaxRate);
	finalcostKouji=costKouji+consumptionTax;
	tmp=finalcostKouji;
	roundOff();
	finalcostKouji=tmp;
	finalcostKouji=Math.floor(finalcostKouji/Math.pow(10,KetaMarume))*Math.pow(10,KetaMarume);
}

function calculation(){ 
	getConditions();
	if(isNaN(costChokusetsuKouji)==false && isNaN(Kouki)==false && 0<costChokusetsuKouji && 0<Kouki){
		expenseKyoutsuuKasetsu();
		expenseGenbaKanri();
		expenseIppanKanri();
		expKyoutsuu=Math.floor(expIppanKanri+expGenbaKanri+expKyoutsuuKasetsu);
		calKouji();
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
		resultOuPut01();resultOuPut02();//clearBox('chart');graph01();
	}else{
		window.alert("注)工事費、工期を共に入力");
	}	
}

function resultOuPut01(){
	document.form2.costChokusetsuKouji.value=number[1];
	document.form2.KoujiType.value=KoujiType;
	document.form2.costJyunKouji.value=number[5];
	document.form2.costKoujiGenka.value=number[6];
	document.form2.costKouji.value=number[7];
	document.form2.consumptionTax.value=number[9];
	document.form2.finalcostKouji.value=number[10];
	document.form2.Kouki.value=Kouki;
	document.form1.finalcostKouji.value=number[10];
}

function resultOuPut02(){
	document.form3.expKyoutsuuKasetsu.value=number[2];
	document.form3.expGenbaKanri.value=number[3];
	document.form3.expIppanKanri.value=number[4];
	document.form3.costTumiageKyoutsuuKasetsu.value=number[11];
	document.form3.costTumiageGenbaKanri.value=number[12];
	document.form3.rateKyoutsuuKasetsu.value=rateKyoutsuuKasetsu;
	document.form3.rateGenbaKanri.value=rateGenbaKanri;
	document.form3.rateIppanKanri.value=rateIppanKanri;
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
		var plot1 = jQuery.jqplot ('chart', [data], 
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

function clearBox(chart){
    document.getElementById(chart).innerHTML="";
}
-->