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


  var entityMap = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
    '/': '&#x2F;',
    '`': '&#x60;',
    '=': '&#x3D;'
  };

  function escapeHtml (string) {
    return String(string).replace(/[&<>"'`=\/]/g, function (s) {
      return entityMap[s];
    });
  }

  $(".btntuneSystem").click(function(){
    console.log("h345elloooo")
      $.post('http://np-tuner/tuneSystem', JSON.stringify({ boost: $("#boost").val(),fuel: $("#fuel").val(),gears: $("#gears").val(),braking: $("#braking").val(),drive: $("#drive").val()  }));
  });


  $(".btnDefault").click(function(){
      $("#boost").val(0);
      $("#fuel").val(0);
      $("#gears").val(0);
      $("#braking").val(5);
      $("#train").val(5);
      console.log("helloooo")
  });

  $(".btnSport").click(function(){
      $("#boost").val(10);
      $("#fuel").val(10);
      $("#gears").val(10);
      console.log("helloooo121221")
  });



  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Open sub-windows / partials

    if(item.openSection == "openNotepad") {
      $(".notepad-container").fadeIn(100); 
      $("#Ticket-form-JailRead").css("display", "none");
      $("#Ticket-form-Jail").fadeIn(100); 
      $("#cursor").css("display", "Block");
    }

    if(item.openSection == "close") {
      $(".notepad-container").fadeOut(100)
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
      $.post('http://np-tuner/close', JSON.stringify({}));
    }
  };
});
