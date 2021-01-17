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
    if(item.openSection == "fishOpen") {
      $(".home").fadeIn(100); 
      $(".evidence-container").fadeIn(100); 
      $(".contractID").fadeIn(100);
      $(".contractAmount").fadeIn(100);
      $(".contractInfo").fadeIn(100);

      $(".remove").empty();
      $(".somthing").empty();
      $(".caseId").empty();
      $(".evidenceType").empty();
      $(".evidenceAmount").empty();
      $(".evidenceDetails").empty();
      
      $("#cursor").css("display", "block");

      $('.caseId').append(item.NUICaseId); 
    }

    if(item.openSection == "fishUpdate") {    
          var g = document.getElementById("remove");

          var f = document.createElement("p");
          f.setAttribute('id',"somthing");
          f.setAttribute('class',"somthing");
          g.appendChild(f);

          var i = document.createElement("p");
          i.setAttribute('class',"evidenceType");
          i.innerHTML = item.name;

          f.appendChild(i);

          var i = document.createElement("p");
          i.setAttribute('class',"evidenceAmount");
          i.innerHTML = item.size;

          f.appendChild(i);
    }


    if(item.openSection == "close") {
      $(".home").fadeOut(100); 
      $(".evidence-container").fadeOut(100); 
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
      $.post('http://np-fish/close', JSON.stringify({}));
    }
  };
});
