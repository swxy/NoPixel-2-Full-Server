$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var cursor = $('#cursor');
  var cursorX = documentWidth / 2;
  var cursorY = documentHeight / 2;

  function UpdateCursorPos() {
      $('#cursor').css('left', cursorX+10);
      $('#cursor').css('top', cursorY+10);
  }


  // Partial Functions
  function closeMain() {
    $(".body").fadeOut(100); 
    $(".home").fadeOut(100); 
  }
  function openMain() {
    $(".home").fadeIn(100); 
  }
  function closeAll() {
    $(".body").fadeOut(100); 
    $(".home").fadeOut(100); 
  }
  function openContainer() {

    $(".warrants-container").fadeIn(100); 

    $("#cursor").css("display", "block");
  }
  function closeContainer() {
   $(".warrants-container").fadeOut(100); 

    $("#cursor").css("display", "none");
  }


  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Trigger adding a new warrant to the log and create its display

    // Open sub-windows / partials
    if(item.openSection == "newsUpdate") {
      $(".home").fadeIn(100); 
      $(".news-container").fadeIn(100); 
      $(".lstNews").fadeIn(100);
      $(".lstNews").empty();
      $(".lstNews2").fadeIn(100);
      $(".lstNews2").empty();
      $("#cursor").css("display", "block");
      $('.lstNews').append(item.string);
      $('.lstNews2').append(item.string2);
    }

    if(item.openSection == "close") {
      $(".home").fadeOut(100); 
      $(".news-container").fadeOut(100); 
      $("#cursor").css("display", "none");
    }


  });

  $(document).mousemove(function(event) {
    cursorX = event.pageX;
    cursorY = event.pageY;
    UpdateCursorPos();
  });

  // On 'Esc' call close method
  document.onkeyup = function (data) {
    if (data.which == 27 ) {
      $.post('http://np-news/close', JSON.stringify({}));
    }
  };
});
