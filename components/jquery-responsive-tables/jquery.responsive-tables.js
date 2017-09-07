/*
 * Responsive Tables plugin 1.1
 * Ryan Wells 
 * Copyright 2015, Ryan Wells (http://ryanwells.com)
 * Free to use under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
*/
!function(n){n.extend({responsiveTables:function(t){
	/* 
	 * https://stackoverflow.com/questions/10161947/how-to-remove-specific-characters-in-a-particular-element 
	 * https://stackoverflow.com/questions/10805125/how-to-remove-all-line-breaks-from-a-string
	*/
	var elements = document.getElementsByClassName("amccrespontable");
	for(var i = 0; i < elements.length; ++i){elements[i].innerHTML = elements[i].innerHTML.replace(/(\r\n|\n|\r)/gm,"");};
	t=t||"800px",n(".amccrespontable").not("responded").length>0&&n(".amccrespontable").not("responded").each(function(e){e++;var s="rt-instance-"+e,d=n(this);d.addClass(s),d.addClass("responded");var a='<style type="text/css">\n';a+="@media only screen and (max-width:"+t+")  {\n";var o=[];d.find("thead th").each(function(t,e){e=n(this).text(),t++,o.push(e),a+="	."+s+">tbody>tr>td.rt-cell-"+t+':before { content: "'+e+'"; }\n'}),d.find("tbody > tr").each(function(t){var e=n(this);t++;var s=[],d=[];e.find("td").each(function(t,e,a){var o=n(this);t++,d>0&&(d[0],t++),s>0&&(a=t+s.shift()-1,d.splice(0,1),d.push(a),t=a),o.is("[colspan]")&&(e=parseInt(n(this).prop("colspan"),10),s.push(e)),o.addClass("rt-cell-"+t)})}),a+="}\n",a+="</style>",d.before(a)})}})}(jQuery);