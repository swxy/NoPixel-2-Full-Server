  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var audioPlayer = null

  var minRot = -90,
    maxRot = 90,
    solveDeg = ( Math.random() * 180 ) - 90,
    solvePadding = 1,
    maxDistFromSolve = 25,
    pinRot = 0,
    cylRot = 0,
    lastMousePos = 0,
    mouseSmoothing = 2,
    keyRepeatRate = 25,
    cylRotSpeed = 3,
    pinDamage = 10,
    pinHealth = 100,
    pinDamageInterval = 150,
    numPins = 1,
    userPushingCyl = false,
    gameOver = false,
    gamePaused = false,
    pin, cyl, driver, cylRotationInterval, pinLastDamaged;


$(document).ready(function(){
  
  //pop vars
  pin = $('#pin');
  cyl = $('#cylinder');
  driver = $('#driver');
  
  $('body').on('mousemove', function(e){

    if (lastMousePos && !gameOver && !gamePaused) {
      var pinRotChange = (e.clientX - lastMousePos)/mouseSmoothing;
      pinRot += pinRotChange/2;
      pinRot = Util.clamp(pinRot,maxRot,minRot);
      pin.css({
        transform: "rotateZ("+pinRot+"deg)"
      })
    }
    lastMousePos = e.clientX;
  });
  $('body').on('mouseleave', function(e){
    lastMousePos = 0;
  });

 

  $('body').on('keydown', function(e){  

    if ( (e.keyCode == 87 || e.keyCode == 65 || e.keyCode == 83 || e.keyCode == 68 ) && !userPushingCyl && !gameOver && !gamePaused) {
      pushCyl();
    }
    if ( (e.keyCode == 39) && !userPushingCyl && !gameOver && !gamePaused) {
      pinUpdate(1)
    }
    
    if ( (e.keyCode == 37 ) && !userPushingCyl && !gameOver && !gamePaused) {
      pinUpdate(2)
    }

  });
  
  $('body').on('keyup', function(e){
     pinUpdate(0)

    if ( (e.keyCode == 87 || e.keyCode == 65 || e.keyCode == 83 || e.keyCode == 68 ) && !gameOver) {
      unpushCyl();
    }
  });
  
  //TOUCH HANDLERS
  $('body').on('touchstart', function(e){
    console.log('touchStart',e)
    if ( !e.touchList ) {
    }
    else if (e.touchList) {
    }
  })
}); //docready

let updating = 0;
let penis = false;
function pinUpdate(set) {
  updating = set
  if (set == 0 || penis) {
    return
  }
  penis = true
  if (set == 1) {
    pinRot = pinRot + 1
  } else {
    pinRot = pinRot - 1
  }
  pin = $('#pin');
  pin.css({
    transform: "rotateZ("+pinRot+"deg)"
  })


  if (updating != 0 && !userPushingCyl && !gameOver && !gamePaused) {
    setTimeout(() => {
      pinUpdate(updating);
      penis = false;
    },1)
  }
}



//CYL INTERACTIVITY EVENTS
function pushCyl() {
  var distFromSolve, cylRotationAllowance;
      clearInterval(cylRotationInterval);
      userPushingCyl = true;
      //set an interval based on keyrepeat that will rotate the cyl forward, and if cyl is at or past maxCylRotation based on pick distance from solve, display "bounce" anim and do damage to pick. If pick is within sweet spot params, allow pick to rotate to maxRot and trigger solve functionality
      
      //SO...to calculate max rotation, we need to create a linear scale from solveDeg+padding to maxDistFromSolve - if the user is more than X degrees away from solve zone, they are maximally distant and the cylinder cannot travel at all. Let's start with 45deg. So...we need to create a scale and do a linear conversion. If user is at or beyond max, return 0. If user is within padding zone, return 100. Cyl may travel that percentage of maxRot before hitting the damage zone.
      
      distFromSolve = Math.abs(pinRot - solveDeg) - solvePadding;
      distFromSolve = Util.clamp(distFromSolve, maxDistFromSolve, 0);
     
      cylRotationAllowance = Util.convertRanges(distFromSolve, 0, maxDistFromSolve, 1, 0.02); //oldval is distfromsolve, oldmin is....0? oldMax is maxDistFromSolve, newMin is 100 (we are at solve, so cyl may travel 100% of maxRot), newMax is 0 (we are at or beyond max dist from solve, so cyl may not travel at all - UPDATE - must give cyl just a teensy bit of travel so user isn't hammered);
      cylRotationAllowance = cylRotationAllowance * maxRot;
      
      cylRotationInterval = setInterval(function(){
        cylRot += cylRotSpeed;
        if (cylRot >= maxRot) {
          cylRot = maxRot;
          // do happy solvey stuff
          clearInterval(cylRotationInterval);
          unlock();
        }
        else if (cylRot >= cylRotationAllowance) {
          cylRot = cylRotationAllowance;
          // do sad pin-hurty stuff
          damagePin();
        }
        
        cyl.css({
          transform: "rotateZ("+cylRot+"deg)"
        });
        driver.css({
          transform: "rotateZ("+cylRot+"deg)"
        });
      },keyRepeatRate);
}

function unpushCyl(){
  userPushingCyl = false;
      //set an interval based on keyrepeat that will rotate the cyl backward, and if cyl is at or past origin, set to origin and stop.
      clearInterval(cylRotationInterval);
      cylRotationInterval = setInterval(function(){
        cylRot -= cylRotSpeed;
        cylRot = Math.max(cylRot,0);
        cyl.css({
          transform: "rotateZ("+cylRot+"deg)"
        })
        driver.css({
          transform: "rotateZ("+cylRot+"deg)"
        })
        if (cylRot <= 0) {
          cylRot = 0;
          clearInterval(cylRotationInterval);
        }
      },keyRepeatRate);
}

//PIN AND SOLVE EVENTS

function damagePin() {
  if ( !pinLastDamaged || Date.now() - pinLastDamaged > pinDamageInterval) {
    var tl = new TimelineLite();
    pinHealth -= pinDamage;
    pinLastDamaged = Date.now()
    
    //pin damage/lock jiggle animation
    tl.to(pin, (pinDamageInterval/4)/1000, {
      rotationZ: pinRot - 2
    });
    tl.to(pin, (pinDamageInterval/4)/1000, {
      rotationZ: pinRot
    });
    if (pinHealth <= 0) {
      breakPin();
    }
  }
}

function breakPin() {
  playSound("pinbreak",0.3)
      var tl, pinTop,pinBott;
      gamePaused = true;
      clearInterval(cylRotationInterval);
      numPins--;
  $('span').text(numPins)
      pinTop = pin.find('.top');
      pinBott = pin.find('.bott');
      tl = new TimelineLite();
      tl.to(pinTop, 0.7, {
              rotationZ: -400,
              x: -200,
              y: -100,
              opacity: 0
            });
      tl.to(pinBott, 0.7, {
        rotationZ: 400,
        x: 200,
        y: 100,
        opacity: 0,
        onComplete: function(){
          if (numPins > 0) {
            gamePaused = false; 
            reset();
          }
          else {
            outOfPins();
          }
        }
      }, 0)
      tl.play();       
}

function reset() {
      //solveDeg = ( Math.random() * 180 ) - 90;
      cylRot = 0;
      pinHealth = 100;
      pinRot = 0;
      pin.css({
        transform: "rotateZ("+pinRot+"deg)"
      })  
      cyl.css({
        transform: "rotateZ("+cylRot+"deg)"
      })  
      driver.css({
        transform: "rotateZ("+cylRot+"deg)"
      })  
      TweenLite.to(pin.find('.top'),0,{
        rotationZ: 0,
        x: 0,
        y: 0,
        opacity: 1
      });
      TweenLite.to(pin.find('.bott'),0,{
        rotationZ: 0,
        x: 0,
        y: 0,
        opacity: 1
      });
}

function playSound(file,volume)
{
  if (audioPlayer != null) {
    audioPlayer.pause();
  }

  audioPlayer = new Audio("./sounds/" + file + ".ogg");
  audioPlayer.volume = volume;
  audioPlayer.play();

}

function outOfPins() {
  $.post('http://np-lockpicking/failure', JSON.stringify({}));
  gameOver = true;
  $('#lose').css('display','inline-block');
  $('#modal').fadeIn();
}

function unlock() {
  $.post('http://np-lockpicking/complete', JSON.stringify({}));
  playSound("lockUnlocked",0.6)
  gameOver = true;
  $('#win').css('display','inline-block');
  $('#modal').fadeIn();
}

//UTIL
Util = {};
Util.clamp = function(val,max,min) {
  return Math.min(Math.max(val, min), max);
}
Util.convertRanges = function(OldValue, OldMin, OldMax, NewMin, NewMax) {
  return (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
}



var gameObject = null

function openContainer()
{
  $("#wrap").css("display", "block");
   document.body.style.backgroundColor = "rgba(190,190,190,0.2)";
}

function closeContainer()
{
  $("#wrap").css("display", "none");
  document.body.style.backgroundColor = "rgba(190,190,190,0.0)";
}

// Listen for NUI Events
window.addEventListener('message', function(event){
  var item = event.data;

  if(item.openPhone === true) {
    openContainer();
  }

  if(item.openSection == "playgame") {
    
    solveDeg = ( Math.random() * 180 ) - 90
    solvePadding = item.padding
    maxDistFromSolve = item.solveDist
    pinDamage = item.damage
    pinHealth = item.health

    minRot = -90
    maxRot = 90
    pinRot = 0,
    cylRot = 0,
    lastMousePos = 0,
    mouseSmoothing = 2,
    keyRepeatRate = 25,
    cylRotSpeed = 3,
    pinDamageInterval = 150,
    numPins = 1,
    userPushingCyl = false,
    gameOver = false,
    gamePaused = false,
    pin = $('#pin');
    cyl = $('#cylinder');
    driver = $('#driver');
    cylRotationInterval = null 
    pinLastDamaged = null 



    reset()
  }

  if(item.openPhone === false) {
    closeContainer();
  }
});


document.onkeyup = function (data) {
  if (data.which == 27 ) {
    $.post('http://np-lockpicking/close', JSON.stringify({}));
  }
};

