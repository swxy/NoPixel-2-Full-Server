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
    $(".meter-container").fadeOut(100); 
  }

  function closeAll() {
    $(".body").fadeOut(100); 
    $(".meter-container").fadeOut(100); 
  }

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Trigger adding a new warrant to the log and create its display
    if (item.type == "click") {
     // triggerClick(cursorX - 1, cursorY - 1);
    }
    // Open sub-windows / partials

//total
//permile
//basefare

    if(item.openSection == "updateTotal") {
      var newCount = item.sentnumber
      $(".total").empty();
      $(".total").prepend(newCount);
    }

    if(item.openSection == "updatePerMinute") {
      var newCount = item.sentnumber
      $(".perminute").empty();
      $(".perminute").prepend(newCount);
    }

    if(item.openSection == "updateBaseFare") {
      var newCount = item.sentnumber
      $(".basefare").empty();
      $(".basefare").prepend(newCount);      
    }

    if(item.openSection == "openTaxiMeter") {
      $(".meter-container").fadeIn(100); 
    }

    if(item.openSection == "closeTaxiMeter") {
      $(".meter-container").css("display", "none");
    }

  });

  $(document).mousemove(function(event) {
    cursorX = event.pageX;
    cursorY = event.pageY;
    UpdateCursorPos();
  });

});
