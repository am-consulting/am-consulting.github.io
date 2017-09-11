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