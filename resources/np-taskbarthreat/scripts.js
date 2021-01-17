$(document).ready(function(){
  
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var curTask = 0;
  var lastTrigger = 0;
  var processed = [];

  function closeMain() {
    lastTrigger = 0;
    $(".divwrap").fadeOut(10);
    $(".divwrap").css("display", "none");
  }  

  window.addEventListener('message', function(event){

    var item = event.data;
    if (item.runProgress === true) {

      var percent = item.Length;

      if ( percent == 80 && lastTrigger != 3 ) {
        lastTrigger = 3;
        $(".divwrap").fadeIn(10);
        $(".divwrap").fadeOut(5000);
      }

      if ( percent == 60 && lastTrigger != 2 ) {
        lastTrigger = 2;
        $(".divwrap").fadeIn(10);
        $(".divwrap").fadeOut(5000);
      }

      if ( percent > 30 && lastTrigger != 1 ) {
        lastTrigger = 1;
        $(".divwrap").fadeIn(10);
        $(".divwrap").fadeOut(5000);
      }      

      var red = 100 + item.Length
      var green = 200 - item.Length * 2
      $('.progress-bar').css('background', "rgba(" + red + "," + green + ",0,0.6)");
      $('.progress-bar').css('width', item.Length + "%");
      $(".nicesexytext").empty();
      $('.nicesexytext').append(item.Task);
    }

    if(item.closeProgress === true) {
      closeMain();
    }

  });

});
