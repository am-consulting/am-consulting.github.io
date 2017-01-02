function MakeNegative() {
/* Reference Reference http://www.hanselman.com/blog/MakingNegativeNumbersTurnRedUsingCSSAndJavascript.aspx */
  TDs = document.getElementsByTagName('td');
  for (var i=0; i<TDs.length; i++) {
    var temp = TDs[i];
    if (temp.firstChild.nodeValue.indexOf('-') == 0) temp.className = "negative";
  }
}
