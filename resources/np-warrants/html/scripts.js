$(document).ready(function() {
  function closeAll() {
    $(".public-container").css('opacity', 0).fadeOut(200);
    $(".warrants-container").css('opacity', 0).fadeOut(200);
    $(".doctor-container").css('opacity', 0).fadeOut(200);
    $(".body").css('opacity', 0).fadeOut(200);
  }

  function openContainer() {
    $(".body").css('opacity', 1).fadeIn(200);
    $(".warrants-container").css('opacity', 1).fadeIn(200);
    $(".warrants-container").css('top', '5%');
    $(".public-container").css('top', '105%');
    $(".doctor-container").css('top', '105%');
  } 

  function openDoctorContainer() {
    $(".body").css('opacity', 1).fadeIn(200);
    $(".doctor-container").css('opacity', 1).fadeIn(200);
    $(".doctor-container").css('top', '5%');
    $(".public-container").css('top', '105%');
    $(".warrants-container").css('top', '105%');
  } 

  function openPublicRecords() {
    $(".body").css('opacity', 1).fadeIn(200);
    $(".public-container").css('opacity', 1).fadeIn(200);
    $(".warrants-container").css('top', '105%');
    $(".public-container").css('top', '5%');
    $(".doctor-container").css('top', '105%');
  }

  window.addEventListener('message', function(event){
    var item = event.data;

    if(item.openWarrants === true) {
      closeAll();
      openContainer();
    }

    if(item.openDoctors === true) {
      closeAll();
      openDoctorContainer();
    }

    if(item.openSection == "publicrecords") {
      closeAll();
      openPublicRecords();
    }

    if(item.closeGUI) {
      closeAll();
    }
    
  });

  function _keyup(e) {
    if (e.which == 27){
      $.post('http://np-warrants/close', JSON.stringify({}));
      closeAll();
    }
  }

  document.onkeyup = _keyup;

  $(".warrants-container iframe, .public-container iframe").load(function(){
    $(this).contents().keyup(_keyup);
  });
});
