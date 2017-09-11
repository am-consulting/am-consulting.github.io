function MakeNegative() {
/* Reference Reference http://www.hanselman.com/blog/MakingNegativeNumbersTurnRedUsingCSSAndJavascript.aspx */
  TDs = document.getElementsByTagName('td');
  for (var i=0; i<TDs.length; i++) {
    var temp = TDs[i];
/*    if (temp.firstChild.nodeValue.indexOf('-') == 0) temp.className = "negative";*/
    if (temp.firstChild.nodeValue.replace(/(\r\n|\n|\r)/gm,"").indexOf('-') == 0) temp.className = "negative";
  }
}

$(document).ready(function() {
    var interval = setInterval(function() {
        var momentNow = moment();
        $('#date-part').html(momentNow.format('YYYY MMMM DD') + ' '
                            + momentNow.format('dddd')
                             .substring(0,3).toUpperCase());
        $('#time-part').html(momentNow.format('A hh:mm:ss'));
    }, 100);
    
    $('#stop-interval').on('click', function() {
        clearInterval(interval);
    });
});

!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');

(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-3077339-5', 'auto');
ga('send', 'pageview');