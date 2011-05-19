var reload = {
  document:function() {
    for ( var i = 0; i < window.length; i++ ) {
      if ( content.location == window[i].location ) {
        return window[i].document;
      }
    }
  },
  css:function(filename) {
    var doc = reload.codumet();
    var l = doc.getElementsByTagName('link');
    for ( var i = 0; i < l.length; i++ ) {
      var ss = l[i];
      if ( ss.href && ss.href.indexOf(filename) != -1 ) {
        repl.print("reloading: " + ss.href);
        try {
          ss.href = (ss.href.split("?")[0]) + "?" + Math.random();
        } catch (e) {
          repl.print(e);
        }
      }
    }
  },
  js:function(filename) {
    var xpath = '//script[contains(@src, "'+ filename +'")]';
    var doc = reload.document();
    var node = doc.evaluate(xpath, document, null, XPathResult.ANY_TYPE, null).iterateNext();
    if ( node ) {
      repl.print("reloading: " + filename);
      var newScript = doc.createElement('script');
      newScript.src = node.src.split("?")[0] + "?" + Math.random();
      document.getElementsByTagName('head')[0].appendChild(newScript);
    } else {
      rpl.print("not found: " + filename);
    }
  }
};
