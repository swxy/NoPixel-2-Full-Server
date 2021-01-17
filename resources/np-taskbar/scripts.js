$(document).ready(function(){
  
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var curTask = 0;
  var processed = []
  function openMain() {
    $(".divwrap").fadeIn(10);
  }

  function closeMain() {
    $(".divwrap").css("display", "none");
  }  

  window.addEventListener('message', function(event){

    var item = event.data;
    if(item.runProgress === true) {
      openMain();

      $('#progress-bar').css("width","0%");
      $(".nicesexytext").empty();
      $('.nicesexytext').append(item.name);
    }

    if(item.runUpdate === true) {

      var percent = "" + item.Length + "%"
      $('#progress-bar').css("width",percent);

      $(".nicesexytext").empty();
      $('.nicesexytext').append(item.name);
    }

    if(item.closeFail === true) {
      closeMain()
      $.post('http://np-taskbar/taskCancel', JSON.stringify({tasknum: curTask}));
    }

    if(item.closeProgress === true) {
      closeMain();
    }

  });

});
