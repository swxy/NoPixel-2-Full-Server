$(document).ready(function(){
  
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var curTask = 0;
  var processed = []


  window.addEventListener('message', function(event){

    var item = event.data;
    if (item.runProgress === true) {

      var message = item.textsent
      var fadetimer = item.fadesent
      var element
      $('#colorsent' + item.colorsent).css('display', 'none');
      if (item.colorsent == 2) {
        element = $('<div id="colorsent' + item.colorsent + '" class="notification-bg red" style="display:none">' + message + '</div>'); 
      } else if (item.colorsent == 69) {
        element = $('<div id="colorsent' + item.colorsent + '" class="notification-bg taxi" style="display:none">' + message + '</div>');
      } else if (item.colorsent == 155) {
        element = $('<div id="colorsent' + item.colorsent + '" class="notification-bg medical" style="display:none">' + message + '</div>');
      } else {
        element = $('<div id="colorsent' + item.colorsent + '" class="notification-bg normal" style="display:none">' + message + '</div>'); 
      }

      
      $('.notify-wrap').prepend(element);
      $(element).fadeIn(500);
      setTimeout(function(){
         $(element).fadeOut(fadetimer-(fadetimer / 2));
      }, fadetimer / 2);

      setTimeout(function(){
        $(element).css('display', 'none');
      }, fadetimer);
    }
  });

});
