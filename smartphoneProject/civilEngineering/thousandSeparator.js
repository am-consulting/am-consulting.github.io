<!--
function thousandSeparator(){
	for(a=0; a<z; a++){
		afterDecimalNumeric=0;
		afterDecimalCharacter="";
		str="";cnt=0;n="";minus=0;
		if(isNaN(number[a])){number[a]=0;}
		if(number[a]<0){number[a]=number[a]*-1;minus=1;}
		if(number[a] !=Math.floor(number[a])){ 
			afterDecimalNumeric=number[a]-Math.floor(number[a]);
			afterDecimalNumeric=Math.round(Math.floor(afterDecimalNumeric*Math.pow(10,5))/10)/Math.pow(10,4);
			str=""+afterDecimalNumeric;
			for (i=str.length-1; i>=1; i--){n = str.charAt(i) + n;}
			afterDecimalCharacter=n;
		}
		cnt=0;str = ""+Math.floor(number[a]);
		n= "";
		for (i=str.length-1; i>=0; i--){
			n= str.charAt(i) + n;
			cnt++;
			if (((cnt % 3) == 0) && (i != 0)){
				n= ","+n;
			}
		}
		number[a]=n+afterDecimalCharacter;
		if(minus==1){
			number[a]="-"+number[a];
		}
	}
}
-->