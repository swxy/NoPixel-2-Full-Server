  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var audioPlayer = null

  
$(document).ready(function(){
 
  function playSound(file,volume)
  {
    if (audioPlayer != null) {
      audioPlayer.pause();
    }

    audioPlayer = new Audio("./sounds/" + file + ".ogg");
    audioPlayer.volume = volume;
    audioPlayer.play();

  }

  document.getElementById("sigh").onclick = AttemptComplition;

  function AttemptComplition() {
    var isFailed = false
    var failureMessage = ""

    var first = document.getElementById("first").value;
    var Last = document.getElementById("last").value;
    var Job = document.getElementById("job").value;
    var Sex = document.getElementById("sex").value;
    var DOB = document.getElementById("dob").value;

    if(first == null || first == "")
    {
      if(failureMessage != ""){failureMessage = "You Have Multipul field error's"}else{failureMessage = "You Must Input a First Name"}
      isFailed = true
    }

    if(Last == null || Last == "")
    {
      if(failureMessage != ""){failureMessage = "You Have Multipul field error's"}else{failureMessage = "You Must Input a Last Name"}
      isFailed = true
    }

    if(Job == null || Job == "")
    {
      if(failureMessage != ""){failureMessage = "You Have Multipul field error's"}else{failureMessage = "You Must Input a Job"}
      isFailed = true
    }

    if(Sex == null || Sex == "")
    {
      if(failureMessage != ""){failureMessage = "You Have Multipul field error's"}else{failureMessage = "You Must Input Sex"}
      isFailed = true
    }

    if(DOB == null || DOB == "")
    {
      if(failureMessage != ""){failureMessage = "You Have Multipul field error's"}else{failureMessage = "You Must Input a DOB"}
      isFailed = true
    }

    if(isFailed)
    {
      $.post('http://np-cid/error', JSON.stringify({  message: failureMessage}));
    }
    else
    {
      $.post('http://np-cid/create', JSON.stringify({first: first, last: Last,job: Job,sex: Sex,dob: DOB }));
    }
     
  }


  function openContainer()
  {
    $(".phone-container").css("display", "block");
  }

  function closeContainer()
  {
     $(".phone-container").css("display", "none");
  }

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;

    if(item.openPhone === true) {
      openContainer();
    }


    if(item.openPhone === false) {
      closeContainer();
    }

     document.onkeyup = function (data) {
      if (data.which == 27 ) {
        $.post('http://np-cid/close', JSON.stringify({}));
      }
    }
  });

});