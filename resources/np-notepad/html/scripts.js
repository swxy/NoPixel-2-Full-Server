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


  $(".btnDrop").click(function(){
      $.post('http://np-notepad/drop', JSON.stringify({ noteText: escapeHtml($("#notepadInfof").val()) }));
  });

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;

    // Open sub-windows / partials

    if(item.openSection == "openNotepadRead") {
      $(".notepad-container").fadeIn(100); 
      $("#Ticket-form-Jail").css("display", "none");
      $("#Ticket-form-JailRead").fadeIn(100); 
      $("#cursor").css("display", "Block");
      $("#notepadInfofRead").val(item.TextRead);
    }

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
      $.post('http://np-notepad/close', JSON.stringify({}));
    }
  };
});
