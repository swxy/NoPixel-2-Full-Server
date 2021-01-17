$(document).ready(function(){
  
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var curTask = 0;
  var processed = []
  var percent = 0;

  document.onkeydown = function (data) {
      // 69 = E btw lol rofl heh 
      if (data.which == 69) {
        closeMain()
        $.post('http://np-taskbarskill/taskEnd', JSON.stringify({taskResult: percent}));
      }
  }


  function openMain() {
    $(".divwrap").fadeIn(10);
  }

  function closeMain() {
    $(".divwrap").css("display", "none");
  }  

  window.addEventListener('message', function(event){

    var item = event.data;
    if(item.runProgress === true) {
      percent = 0;
      openMain();
      $('#progress-bar').css("width","0%");
      $('.skillprogress').css("left",item.chance + "%")
      $('.skillprogress').css("width",item.skillGap + "%");
    }

    if(item.runUpdate === true) {
      percent = item.Length
      $('#progress-bar').css("width",item.Length + "%");

      if (item.Length < (item.chance + item.skillGap) && item.Length > (item.chance)) {
        $('.skillprogress').css("background-color","rgba(120,50,50,0.9)");

      } else {
        $('.skillprogress').css("background-color","rgba(255,250,250,0.4)");
      }

    }

    if(item.closeFail === true) {
      closeMain()
      $.post('http://np-taskbarskill/taskCancel', JSON.stringify({tasknum: curTask}));
    }

    if(item.closeProgress === true) {
      closeMain();
    }

  });

});
