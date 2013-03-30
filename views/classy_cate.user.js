// ==UserScript==
// @name         Classy CATE
// @author       Peter Hamilton
// @description  CATE Hurts eyes. This makes it hurt them less.
// @version 1.2
// @match https://cate.doc.ic.ac.uk/*
// ==/UserScript==

function main() {
    window.classy_cate_script_version = "1.2";
    $('head').append('<script type="text/javascript" src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/js/bootstrap.min.js"></script>');
    //$('head').append('<script type="text/javascript" src="https://localhost:4567/classy-cate.js"></script>');  //testing
    $('head').append('<script type="text/javascript" src="https://classy-cate.herokuapp.com/classy-cate.js"></script>');
}

// a function that loads jQuery and calls a callback function when jQuery has finished loading
function addJQuery(callback) {
  var script = document.createElement("script");
  script.setAttribute("src", "//ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js");
  script.addEventListener('load', function() {
    var script = document.createElement("script");
    // script.textContent = "window.jQ=jQuery.noConflict(true);(" + callback.toString() + ")();";
    script.textContent = "(" + callback.toString() + ")();";
    document.body.appendChild(script);
  }, false);
  document.body.appendChild(script);
}

// load jQuery and execute the main function
addJQuery(main);
