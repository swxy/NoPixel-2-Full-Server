$(document).ready(function(){
  // Listen for NUI Events
  window.addEventListener('message', function(event){

    var item = event.data;

    if(item.openSection == "calculator") {
      $(".calculator").css("opacity", 1.0);
    }

    if(item.openSection == "close") {
      $(".calculator").css("opacity", 0.0);
    }
  });

  function _keyup(e) {
    if (e.which == 27) {
      $.post('http://np-webpages/close', JSON.stringify({}));
    }
  }

  document.onkeyup = _keyup;

  $("iframe").load(function () {
    $(this).contents().keyup(_keyup);
  });
});
