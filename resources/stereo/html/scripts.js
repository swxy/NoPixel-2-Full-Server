$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var RadioChannel = '0000.0';
  var Powered = true;
  var stations = [1982.9,0.0];
  var currentStation = 1;

  function escapeHtml (string) {
    return String(string).replace(/[&<>"'`=\/]/g, function (s) {
      return entityMap[s];
    });
  }

  

  function closeGui() {
      if (Powered) {
        $.post('http://stereo/close', JSON.stringify({ channel: stations[currentStation] }));
      } else {
        $.post('http://stereo/cleanClose', JSON.stringify({ }));
      }
  }

  function closeSave() {
      if (Powered) {
        RadioChannel = parseFloat(stations[currentStation])
        if (!RadioChannel) {
          RadioChannel = '0000.0'
        }
      }
      closeGui()
  }

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    if (item.reset === true) {
      closeGui()
    }
    if (item.set === true) {
      RadioChannel = item.setChannel
    }
    if (item.open === true) {

      if (stations[currentStation] != 0.0 && Powered) {
        $("#RadioChannel").val(stations[currentStation])
      } else {
        if (Powered) {
          $("#RadioChannel").val('')
        } else {
          $("#RadioChannel").val('')
          $("#DisplayStation").html("0000.0")
        }
        
      }
      
      $(".full-screen").fadeIn(100);
       $(".radio-container").fadeIn(100);
      $("#cursor").css("display", "block");
      $("#RadioChannel").focus()
    } 
    if (item.open === false) {
      $(".full-screen").fadeOut(100);
      $(".radio-container").fadeOut(100);
      $("#cursor").css("display", "none");
    }

  });

  $('#Radio-Form').submit(function(e) { 
    e.preventDefault();
    closeSave();
  });

  $("#power").click(function() {
    if (Powered === false) {
      Powered = true;
      $("#RadioChannel").val(stations[currentStation])
      $.post('http://stereo/click', JSON.stringify({}));
      $.post('http://stereo/poweredOn', JSON.stringify({ channel: stations[currentStation] }));
      $("#DisplayStation").html(stations[currentStation])
    } else {
      Powered = false;
      $.post('http://stereo/click', JSON.stringify({}));
      $.post('http://stereo/poweredOff', JSON.stringify({}));

      $("#RadioChannel").val(0)
      $("#DisplayStation").html("0000.0")
    }   
  });
  $("#volumeUp").click(function() {
    $.post('http://stereo/click', JSON.stringify({}));
    $.post('http://stereo/volumeUp', JSON.stringify({}));
  });
  
  $("#volumeDown").click(function() {
    $.post('http://stereo/click', JSON.stringify({}));
    $.post('http://stereo/volumeDown', JSON.stringify({}));
  });

  $("#radioChange").click(function() {
    var reset = false
    if(Powered){
      if(currentStation >= stations.length-1){
        currentStation = 0
        reset = true
      }
      else if(!reset)
      {
        currentStation += 1
      }

      $("#RadioChannel").val(stations[currentStation])
      if(stations[currentStation] == 0.0)
      {
        $("#DisplayStation").html("0000.0")  
      }
      else
      {
        $("#DisplayStation").html(stations[currentStation])  
      }
      $.post('http://stereo/channelChange', JSON.stringify({ channel: stations[currentStation] }));
    }
    $.post('http://stereo/click', JSON.stringify({}));
  });

  

  // On 'Esc' call close method
  document.onkeyup = function (data) {
    if (data.which == 27 ) {
      closeSave()
    }
  };

});
