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

  $(".btnPrev").click(function(){
      $.post('http://np-contracts/previousID', JSON.stringify({}));
  });

  $(".btnNext").click(function(){
      $.post('http://np-contracts/nextID', JSON.stringify({}));
  });

  $(".btnPay").click(function(){
      $.post('http://np-contracts/payID', JSON.stringify({}));
  });

  $(".btnGive").click(function(){
      $.post('http://np-contracts/giveID', JSON.stringify({ target: $("#contractID2").val(), conamount: $("#contractAmount2").val(), coninformation: $("#contractInfo2").val()}));
  });

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Trigger adding a new warrant to the log and create its display
    if (item.type == "click") {
     // triggerClick(cursorX - 1, cursorY - 1);
    }
    // Open sub-windows / partials
    if(item.openSection == "contractUpdate") {
      $(".home").fadeIn(10);
      $(".contract-container").fadeIn(10);
      $(".full-screen").fadeIn(10);
      $(".contractID").empty();
      $(".contractAmount").empty();
      $(".contractInfo").empty();

      $("#cursor").css("display", "block");
      $('.contractID').append(item.NUIcontractID);
      $('.contractAmount').append(item.NUIcontractAmount);
      $('.contractInfo').append(item.NUIcontractInfo);
    }

    if(item.openSection == "openContractDummy") {
      $(".home").fadeIn(100); 
      $(".contract-container3").fadeIn(100); 
      $("#cursor").css("display", "Block");

     $('.contractID3').append("Sign Here");
      $('.contractAmount3').append(item.price);
      $('.contractInfo3').append(item.strg);

    }

    if(item.openSection == "openContracts") {
      $(".home").fadeIn(100); 
      $(".contract-container").fadeIn(100); 
      $("#cursor").css("display", "Block");
    }

    if(item.openSection == "openContractStart") {
      $(".home").fadeIn(100); 
      $(".contract-container2").fadeIn(100); 
      $("#cursor").css("display", "Block");
    }

    if(item.openSection == "close") {
      $(".home").css("display", "none");
      $(".contract-container").css("display", "none");
      $(".contract-container2").css("display", "none");
      $(".contract-container3").css("display", "none");
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
      $.post('http://np-contracts/close', JSON.stringify({}));
    }
    if ( data.which == 37 ) {
      $.post('http://np-contracts/previousID', JSON.stringify({}));
    }
    if ( data.which == 39 ) {
      $.post('http://np-contracts/nextID', JSON.stringify({}));
    }
  };
});
