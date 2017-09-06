/*
 * Responsive Tables plugin 2.0.0
 * Ryan Wells 
 * Copyright 2017, Ryan Wells (http://ryanwells.com)
 * Free to use under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
*/

/* Original
$.extend({
    responsiveTables: function (breakpoint) {
        breakpoint = breakpoint || '800px';
        if ($('table').length > 0) {
            $('table').each(function (i) {
                i++;
                var className = 'jrt-instance-' + i;
                var $this = $(this);
                $this.addClass('jrt');
                $this.addClass(className);

                var respondHtml = '<style type="text/css">\n';
                respondHtml += '@media only screen and (max-width:' + breakpoint + ')  {\n';
                var arrHeaderText = [];
                $this.find('thead th').each(function (i, $text) {
                    $text = $(this).text();
                    i++;
                    arrHeaderText.push($text);
                    respondHtml += '\t.' + className + '>tbody>tr>td.jrt-cell-' + i + ':before { content: "' + $text + '"; }\n';
                });
                $this.find('tbody > tr').each(function (i) {
                    var $this = $(this);
                    i++;
                    var arrColspan = [];
                    var modIndex = [];
                    $this.find('td').each(function (i, c, m) {
                        var $this = $(this);
                        i++;
                        if (modIndex > 0) {
                            modIndex[0];
                            i++;
                        }
                        if (arrColspan > 0) {
                            m = (i + arrColspan.shift() - 1);
                            modIndex.splice(0, 1);
                            modIndex.push(m);
                            i = m;
                        }
                        if ($this.is('[colspan]')) {
                            c = parseInt($(this).prop('colspan'), 10);
                            arrColspan.push(c);
                        }
                        $this.addClass('jrt-cell-' + i);
                    });
                });
                respondHtml += '}\n';
                respondHtml += '</style>';
                $this.before(respondHtml);
            });
        }
    }
});

*/

/*
 * Responsive Tables plugin 1.1
 * Ryan Wells 
 * Copyright 2015, Ryan Wells (http://ryanwells.com)
 * Free to use under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
*/
!function(n){
	n.extend({
		responsiveTables:function(t){
			t=t||"800px",n(".amcc").not("responded").length>0&&n(".amcc").not("responded").each(function(e){
				e++;var s="rt-instance-"+e,d=n(this);
				d.addClass(s),d.addClass("responded");
				var a='<style type="text/css">\n';
				a+="@media only screen and (max-width:"+t+")  {\n";
				var o=[];
				d.find("thead th").each(function(t,e){e=n(this).text(),t++,o.push(e),a+="	."+s+">tbody>tr>td.rt-cell-"+t+':before { content: "'+e+'"; }\n'}),d.find("tbody > tr").each(function(t){
					var e=n(this);
					t++;
					var s=[],d=[];
					e.find("td").each(function(t,e,a){
						var o=n(this);
						t++,d>0&&(d[0],t++),s>0&&(a=t+s.shift()-1,d.splice(0,1),d.push(a),t=a),o.is("[colspan]")&&(e=parseInt(n(this).prop("colspan"),10),s.push(e)),o.addClass("rt-cell-"+t)
						})
				}),a+="}\n",a+="</style>",d.before(a)
			})
		}
	})
}(jQuery);