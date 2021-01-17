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

  function triggerClick(x, y) {
      var element = $(document.elementFromPoint(x, y));
      element.focus().click();
      return true;
  }
  // Partial Functions
  function closeMain() {
      $(".home").fadeOut(100); 
      $(".evidence-container").fadeOut(100); 
       $(".evidence-container-header").fadeOut(100); 
  }
  function openMain() {
    $(".home").fadeIn(100); 
  }
  function closeAll() {
      $(".home").fadeOut(100); 
      $(".evidence-container").fadeOut(100); 
       $(".evidence-container-header").fadeOut(100);  
  }
  function openContainer() {

    $(".warrants-container").fadeIn(100); 

    $("#cursor").css("display", "block");
  }
  function closeContainer() {
      $(".home").fadeOut(100); 
      $(".evidence-container").fadeOut(100); 
       $(".evidence-container-header").fadeOut(100);  

    $("#cursor").css("display", "none");
  }
  function openContracts() {
    $(".evidence-container").fadeIn(100); 
  }
  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Trigger adding a new warrant to the log and create its display
    if (item.type == "click") {
     // triggerClick(cursorX - 1, cursorY - 1);
    }
    // Open sub-windows / partials
    if(item.openSection == "truckerOpen") {
      $(".home").fadeIn(100); 
      $(".evidence-container").fadeIn(100); 
      $(".evidence-container-header").fadeIn(100); 

      $(".contractID").fadeIn(100);
      $(".contractAmount").fadeIn(100);
      $(".contractInfo").fadeIn(100);
      $(".wtfspace").fadeIn(100);

      $("#remove").empty();

      $("#cursor").css("display", "block");

    }


    if(item.openSection == "truckerUpdate") {    

        var element = $('<div class="bubble-container2"> Delivery to ' + item.street2 + ' </div> <div class="bubble-container3"> Click to accept. </div> <hr> ');  
        
        element.click(function(){  
          $.post('http://truckerjob/selectedJob', JSON.stringify({jobType: item.jobType ,jobId: item.jobId}));  
        });  
        $(".container2").append(element);

    }


    if(item.openSection == "close") {

      $("#remove").empty();
      

      $(".home").fadeOut(100); 
      $(".evidence-container").fadeOut(100); 
       $(".evidence-container-header").fadeOut(100); 
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
      $.post('http://truckerjob/close', JSON.stringify({}));
    }
  };
});
