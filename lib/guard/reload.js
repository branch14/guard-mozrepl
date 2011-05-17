// borrowed from
// https://github.com/jlbfalcao/mozrepl_tools/blob/master/lib/textmate/Support/lib/mozrepl_tools.rb

var reload = (function(content, window) {
                  var window = (function() {
                                    for ( var i = 0; i < window.length; i++ ) {
                                        if ( content.location == window[i].location ) {
                                            return window[i];
                                        }
                                    }
                                })();
                  var document = doc = window.document;
                  var Ext = window.Ext;
                  // firebug
                  var console = window.console || {debug:function(){}};

                  console.debug("loading...");

                  var head = document.getElementsByTagName("head")[0];

                  return {
                      css:function(file) {
                          var l = doc.getElementsByTagName('link');
                          for ( var i = 0; i < l.length; i++ ) {
                              var ss = l[i];
                              console.debug("reloading:", ss);
                              if ( ss.href && ss.href.indexOf(file) != -1 ) {
                                  try {

                                      ss.href = (ss.href.split("?")[0]) + "?" + Math.random();
                                  } catch (e) {

                                      repl.print(e);
                                  }
                              }
                          }
                      },
                      jsEval:function(text) {

                          var script = document.createElement('script');
                          script.type = "text/javascript";
                          script.textContent = text;
                          repl.print(text);
                          head.appendChild(script);
                      },
                      js:function(filename) {

                          var filename = filename.split("/").pop();
                          // console.debug("filename:", filename);
                          // TODO: sometimes cant't work.'
                          var xpath = '//script[contains(@src, "'+ filename +'")]';
                          var node = document.evaluate(xpath, document, null, XPathResult.ANY_TYPE, null).iterateNext()
                          if ( node ) {

                              var newScript = document.createElement('script');
                              newScript.src = node.src.split("?")[0] + "?" + Math.random();
                              document.getElementsByTagName('head')[0].appendChild(newScript);
                              console.debug("reloaded")
                          } else {

                              console.debug("this file isn't included.'")
                          }
                      }
                  };
              })(content, window);
