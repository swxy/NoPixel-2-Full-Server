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

  function spawnButton() {
    var element = $('<a href="#" class="button2 sans btnHome">Spawn Now</a> <br><br>');  
       
    element.click(function(){  
      $.post('http://apartments/confirmspawn', JSON.stringify({ }));  
    });  

    $(element).fadeIn(100);
    $(".myspawns").append(element);
    
  }

  function insertSpawnPoint(message) {

    var address = message.textmessage
    var selectedspawn = message.tableid


    var element = $('<div class="button">' + address + '</div> ');  
       
    element.click(function(){  
      $.post('http://apartments/selectedspawn', JSON.stringify({ tableidentifier: selectedspawn }));  
    });  

    $(element).fadeIn(100);
    $(".myspawns").append(element);

  }


  window.addEventListener('message', function(event){

    var item = event.data;
    if(item.openSection === "main") {
      $(".myspawns").empty();
      spawnButton();
      
      openMain();
    }

    if(item.openSection === "enterspawn") {
      insertSpawnPoint(item);
    }

    if(item.openSection === "close") {
      closeMain();
    }


  });

});
