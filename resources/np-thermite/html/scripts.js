$(document).ready(function(){
  //loadGame();
  //polyfillKey(); 

  var audioPlayer = null;

  function loadGame() {
    var button = document.createElement('button');
    button.textContent = 'Start Game';
    var main = document.getElementById('main');
    main.appendChild(button);
    button.addEventListener('click', function startIt(e) {
      
    });
  }

  function getRandomIntInclusive(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min; //The maximum is inclusive and the minimum is inclusive 
  }



  function playGame(DropAmount,letterSet,speed,intervalSet) {
    var main = document.getElementById('main');
    main.textContent = '';
    var LETTERS = [];

    if(letterSet == 1)
    {
      LETTERS = ['q','w','e']
    }
    else if(letterSet == 2)
    {
      LETTERS = ['q','w','e','a','s']
    }
    else
    {
       LETTERS = ['q','w','e','j','k','l']
    }

    var animations = {'q':[],'w':[],'e':[],'j':[],'k':[],'l':[],'a':[],'s':[]};

    var gameOn = true;
    var timeOffset = intervalSet; //interval between letters starting, will be faster over time
    var DURATION = 10000;
    var main = document.getElementById('main');
    var score = 0
    var rate = speed;
    var RATE_INTERVAL = .05; //playbackRate will increase by .05 for each letter... so after 20 letters, the rate of falling will be 2x what it was at the start
    var misses = 0;
    var currentAmount = DropAmount;

    //Create a letter element and setup its falling animation, add the animation to the active animation array, and setup an onfinish handler that will represent a miss. 
    function create() {
      var idx = Math.floor(Math.random() * LETTERS.length);
      var y = getRandomIntInclusive(1,3);
      var x = ""
      if(y == 1){x = "2.73vw"}
      else if(y == 2){x = "7.23vw"}
      else if(y == 3){x = "11.63vw"}

      var container = document.createElement('div');
      var letter = document.createElement('span');
      var letterText = document.createElement('b');
      letterText.textContent = LETTERS[idx];
      letter.appendChild(letterText);
      container.appendChild(letter);
      main.appendChild(container);
      var animation = container.animate([
        {transform: 'translate3d('+x+',-2.5vh,0)'},
        {transform: 'translate3d('+x+',46.5vh,0)'}
      ], {
        duration: DURATION,
        easing: 'linear',
        fill: 'both'
      });
      
      animations[LETTERS[idx]].splice(0, 0, {animation: animation, element: container});
      //rate = rate + RATE_INTERVAL;
      animation.playbackRate = rate;

      
      //If an animation finishes, we will consider that as a miss, so we will remove it from the active animations array and increment our miss count
      animation.onfinish = function(e) {
        var target = container;
        var char = target.textContent;
                                        
        animations[char].pop();
        target.classList.add('missed');
        handleMisses();
      }
    }
    
    //When a miss is registered, check if we have reached the max number of misses
    function handleMisses() {
      misses++;
      var missedMarker = document.querySelector('.misses:not(.missed)');
      if (missedMarker) {
        missedMarker.classList.add('missed');
      } else {
        gameOver();
      }
    }
    
    //End game and show screen
    this.gameOver = function() {
      gameOn = false;
      clearInterval(cleanupInterval);
      getAllAnimations().forEach(function(anim) {
        anim.pause();
      });
      cleanup();
    }

    function gameOver() {
      playSound("failure",0.5)
      $.post('http://np-thermite/failure', JSON.stringify({}));
      gameOn = false;
      clearInterval(cleanupInterval);
      getAllAnimations().forEach(function(anim) {
        anim.pause();
      });
      cleanup();
    }

    //Periodically remove missed elements, and lower the interval between falling elements
    var cleanupInterval = setInterval(function() {
      timeOffset = timeOffset * 4 / 5;
      //cleanup();
    }, 20000);
    function cleanup() {
      [].slice.call(main.querySelectorAll('.missed')).forEach(function(missed) {
        main.removeChild(missed);
      });

      [].slice.call(document.querySelectorAll('.misses')).forEach(function(missed) {
        missed.classList.remove('missed');
      });
    }
    
    //Firefox 48 supports document.getAnimations as per latest spec, Chrome 52 and polyfill use older spec
    function getAllAnimations() {
      if (document.getAnimations) {
        return document.getAnimations();
      } else if (document.timeline && document.timeline.getAnimations) {
        return document.timeline.getAnimations();
      }
      return [];
    }
    //9218.34164990578
    //9987.113399989903
    //On key press, see if it matches an active animating (falling) letter. If so, pop it from active array, pause it (to keep it from triggering "finish" logic), and add an animation on inner element with random 3d rotations that look like the letter is being kicked away to the distance. Also update score.
    function onPress(e) {
      var char = e.key;
      if (char.length === 1) {
        char = char.toLowerCase();
        if (animations[char] && animations[char].length) {
          var last_element = animations[char][animations[char].length - 1];
          if(last_element.animation.currentTime > 8000.34 && last_element.animation.currentTime < 9387.2)
          {
            var popped = animations[char].pop();
            currentAmount--;
            popped.animation.pause();
            playSound("hit",0.35)
            var target = popped.element.querySelector('b');
            var degs = [(Math.random() * 1000)-500,(Math.random() * 1000)-500,(Math.random() * 2000)-1000];
            target.animate(
            [
              {transform: 'scale(1) rotateX(0deg) rotateY(0deg) rotateZ(0deg)',opacity:1},
              {transform: 'scale(0) rotateX('+degs[0]+'deg) rotateY('+degs[1]+'deg) rotateZ('+degs[2]+'deg)', opacity: 0}
            ], 
            {
              duration: Math.random() * 500 + 850,
              easing: 'ease-out',
              fill: 'both'
            });
            
          } 
        }
      }
    }
    
    document.body.addEventListener('keypress', onPress);

    //start the letters falling... create the element+animation, and setup timeout for next letter to start
    var soundSet = false
    function setupNextLetter() {
      if (gameOn && currentAmount != 0) {
        create();
        setTimeout(function() {
          setupNextLetter();
        }, timeOffset);
      }

      if(currentAmount == 0 && !soundSet)
      {
        soundSet = true
        playSound("success",0.9)
        $.post('http://np-thermite/complete', JSON.stringify({}));
      }
    }
    setupNextLetter();
  }


  function polyfillKey() {
    if (!('KeyboardEvent' in window) ||
          'key' in KeyboardEvent.prototype) {
      return false;
    }
    
    console.log('polyfilling KeyboardEvent.prototype.key')
    var keys = {};
    var letter = '';
    for (var i = 65; i < 91; ++i) {
      letter = String.fromCharCode(i);
      keys[i] = letter.toUpperCase();
    }
    for (var i = 97; i < 123; ++i) {
      letter = String.fromCharCode(i);
      keys[i] = letter.toLowerCase();
    }
    var proto = {
      get: function (x) {
        var key = keys[this.which || this.keyCode];
        console.log(key);
        return key;
      }
    };
    Object.defineProperty(KeyboardEvent.prototype, 'key', proto);
  }



  var gameObject = null

  function openContainer()
  {
    $(".phone-container").css("display", "block");
  }

  function closeContainer()
  {
     $(".phone-container").css("display", "none");
    gameObject.gameOn = false;
    gameObject.misses = 0;
    gameObject.gameOver()
    gameObject = null
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


  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Trigger adding a new message to the log and create its display
    // Open & Close main phone window
    if(item.openPhone === true) {
      openContainer();
    }

    if(item.openSection == "playgame") {
      gameObject = new playGame(item.amount,item.letterSet,item.speed,item.interval);
    }

    if(item.openPhone === false) {
      closeContainer();
    }
  });


  document.onkeyup = function (data) {
      if (data.which == 27 ) {
        $.post('http://np-thermite/close', JSON.stringify({}));
      }
    };


});
