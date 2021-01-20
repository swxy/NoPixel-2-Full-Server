  // Mouse Controls
  let documentWidth = document.documentElement.clientWidth;
  let documentHeight = document.documentElement.clientHeight;
  let audioPlayer = null
  let authCodeField = null;
  let padStatus = null;
  let validPins = {};
  let failedAttempts = 0;
  let lockedOut = false;

$(document).ready(function() {
  $('body').on('keydown', function(e) {
    playSound('blop', 0.2);
  });
  $('#authcode').val('');
  authCodeField = $('#authcode');
  padStatus = $('#padstatus');
}); //docready

function keypadPress(buttonValue) {
  playSound('blop', 0.2);
  let authCodeCurrentValue = authCodeField.val();
  if ((authCodeCurrentValue.length >= 7) || lockedOut)
  {
    return;
  }
  authCodeField.val( authCodeCurrentValue + buttonValue);
}

function keypadClear() {
  $('#authcode').val('');
}

function keypadSubmit() {
  if (lockedOut) {
    return;
  }
  let bElevated = false;
  if (parseInt(validPins[0]) == parseInt(authCodeField.val())) {
    bElevated = true;
  }
  if ((parseInt(validPins[0]) == parseInt(authCodeField.val()))||(parseInt(validPins[1]) == parseInt(authCodeField.val()))) {
    pinSuccess(bElevated);
  } else {
    pinFailure();
  }
}

function reset() {
  keypadClear();
}

function playSound(file,volume)
{
  if (audioPlayer != null) {
    audioPlayer.pause();
  } else {
      audioPlayer = new Audio("./sounds/" + file + ".ogg");
  }
  audioPlayer.volume = volume;
  //audioPlayer.play();
}

function pinFailure() {
  $.post('http://np-stash/failure', JSON.stringify({pinResult: false}));
  gameOver = true;
  $('#modal').fadeIn();
  ++failedAttempts;
  if (failedAttempts >= 3)
  {
    setTimeout(resetFails, 60000);
  }
}

function pinSuccess(pElevated) {
  $.post('http://np-stash/complete', JSON.stringify({pinResult: true, owner: pElevated}));
  playSound("lockUnlocked",0.6)
  gameOver = true;
  $('#modal').fadeIn();
}


var gameObject = null

function openContainer()
{
  $("body").css("display", "block");
   document.body.style.backgroundColor = "rgba(190,190,190,0.2)";
   authCodeField.focus();
   authCodeField.keypress(function (e) {
    var key = e.which;
    if(key === 13)  // the enter key code
    {
      keypadSubmit();
      return false;
    }
  });
  if (failedAttempts >= 3) {
    padStatus.removeClass('padStatusGood');
    padStatus.addClass('padStatusBad');
    padStatus.val('OFFLINE');
    lockedOut = true;
  } else {
    padStatus.removeClass('padStatusBad');
    padStatus.addClass('padStatusGood');
    padStatus.val('READY');
    lockedOut = false;
  }
}

function closeContainer()
{
  $("body").css("display", "none");
  document.body.style.backgroundColor = "rgba(190,190,190,0.0)";
}

// Listen for NUI Events
window.addEventListener('message', function(event) {
  let item = event.data;

  if(item.openPinPad === true) {
    reset();
    openContainer();
    validPins = item.requiredPins;
  }

  if(item.openPinPad === false) {
    closeContainer();
  }
});

function resetFails() {
  failedAttempts = 0;
}

document.onkeyup = function (data) {
  if (data.which == 27 ) {
    $.post('http://np-stash/close', JSON.stringify({pinResult: false}));
  }
};

