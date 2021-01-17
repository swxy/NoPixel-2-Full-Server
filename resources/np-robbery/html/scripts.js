$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;

  function renderToolOptions(tool,card)
  {
    if(tool == "electricLock")
    {
      $(".signup-b").css("display", "inline");
      document.getElementById('voice').src='electronic.png'
    }
    else if(tool == "physicalPick")
    {
      $(".signup-b").css("display", "inline");
       document.getElementById('voice').src='lockpick.png'
    }
    else if(tool == "physicalThermite")
    {
      $(".signup-b").css("display", "inline");
       document.getElementById('voice').src='thermite.png'
    }
    else if(tool == "cardedlock")
    {
      $(".signup-b").css("display", "inline");
      document.getElementById('voice').src='gruppe62.png'
    }
    else if(tool == "cardedlock2")
    {
      $(".signup-b").css("display", "inline");
      document.getElementById('voice').src='gruppe622.png'
    }
    else if(tool == "airLock")
    {
      $(".signup-b").css("display", "inline");
      document.getElementById('voice').src='airlock.png'
    }    
    else
    {
      $(".signup-b").css("display", "none");
      $(".signup-b").fadeOut(150);
    }
  }


  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    if(item.openSection == "toolSelect") {
      var tool = item.tool
      var card = item.card
      renderToolOptions(tool,card)
    }
  });

});   
   