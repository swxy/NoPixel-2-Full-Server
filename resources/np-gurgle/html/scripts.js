$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var cursor = $('#cursor');
  var cursorX = documentWidth / 2;
  var cursorY = documentHeight / 2;

  function UpdateCursorPos() {
      $('#cursor').css('left', cursorX+2);
      $('#cursor').css('top', cursorY+2);
  }

  function triggerClick(x, y) {
      var element = $(document.elementFromPoint(x, y));
      element.focus().click();
      return true;
  }

  // Partial Functions
  function closeMain() {
    $(".body").fadeOut(100); 
    $(".home").fadeOut(100); 
  }

  function closeAll() {
    $(".body").fadeOut(100); 
    $(".home").fadeOut(100); 
  }

  function openContracts() {
    $(".contract-container").fadeIn(100); 
  }
  $(".btnSubmit").click(function(){

      $.post('http://np-gurgle/btnSubmit', JSON.stringify({
          websiteName: $(".contractID").val(),
          websiteKeywords: $(".contractAmount").val(),
          websiteDescription: $(".contractInfo").val()
      }));

  });

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Trigger adding a new warrant to the log and create its display
 
    // Open sub-windows / partials


    if(item.openSection == "openGurgle") {
      $(".home").fadeIn(100); 
      $(".contract-container").fadeIn(100); 
      $("#cursor").css("display", "Block");
    }

    if(item.openSection == "closeGurgle") {
      $(".home").css("display", "none");
      $(".contract-container").css("display", "none");
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
    if ( data.which == 27 ) {
      $.post('http://np-gurgle/close', JSON.stringify({}));
    }
  };
});
