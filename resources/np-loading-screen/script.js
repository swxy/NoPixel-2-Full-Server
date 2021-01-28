
var count = 0;

const gstate = {
  elems: [],
  log: []
};


const technicalNames = ["INIT_BEFORE_MAP_LOADED", "MAP", "INIT_AFTER_MAP_LOADED", "INIT_SESSION"];
var currentLoadingStage = 0;
var loadingWeights = [1.5 / 10, 4 / 10, 1.5 / 10, 3 / 10];
// These are hardcoded but can be changed easily
// If # changes it's not the biggest deal; most important is which of the bars you are on (and that is unaffected by these numbers)
// Make #debug window visible and you can quickly see #s of each
// Just make sure you do it after restarting your FiveM client as client caches a lot in memory after first join
var loadingTotals = [70, 70, 70, 220];
var registeredTotals = [0, 0, 0, 0];
var stageVisible = [false, false, false, false];

var currentProgress = [0.0, 0.0, 0.0, 0.0];
var currentLoadingCount = 0;


const totalWidth = 99.1;
var progressPositions = [];
var progressMaxLengths = [];
progressPositions[0] = 0.0;



/*
 Functions below : Vue object
 Descipition: controls and handles vue components 

*/

let v = new Vue({
  el: '#app',
  data: {
    showLog: false,
    lastbackground: -1,
  },
  methods: {


    doProgress(stage) {
      var idx = technicalNames.indexOf(stage);
      if (idx >= 0) {
        registeredTotals[idx]++;
        if (idx > currentLoadingStage) {
          while (currentLoadingStage < idx) {
            currentProgress[currentLoadingStage] = 1.0;
            currentLoadingStage++;
          }
          currentLoadingCount = 1;
        }
        else
          currentLoadingCount++;
        currentProgress[currentLoadingStage] = Math.min(currentLoadingCount / loadingTotals[idx], 1.0);
        this.updateProgress();
      }
    },

    updateProgress() {
      document.querySelector('#debug').innerHTML = '';
      var i = 0;
      while (i <= currentLoadingStage) {
        if ((currentProgress[i] > 0 || !currentProgress[i - 1]) && !stageVisible[i]) {

          document.querySelector("#" + technicalNames[i] + "-bar").style.display = 'inline-block';
          stageVisible[i] = true;
        }
        document.querySelector("#" + technicalNames[i] + "-bar").style.width = currentProgress[i] * progressMaxLengths[i] + '%';
        document.querySelector("#" + technicalNames[i] + "-label").style.width = progressMaxLengths[i] + '%';
        document.querySelector('#debug').innerHTML += String.format('{0}: {1}<br />', technicalNames[i], currentProgress[i]);
        i++;
      }
    },

    printLog(type, str) {
      gstate.log.push({ type: type, str: str });
    },

    keypress(e) {
      var code = e.keyCode
      if (code == 71) {
        this.showLog = !this.showLog
      }
    },

    getRandomInt(max) {
      return Math.floor(Math.random() * Math.floor(max));
    },

    randomBackground(length) {

      var index = this.getRandomInt(length)
      if (index == this.lastbackground) {
        index = this.getRandomInt(length)
        this.lastbackground = index
      }
      else {
        this.lastbackground = index
      }

      return index
    },

  },

  created: function () {
    document.addEventListener('keydown', this.keypress);
  }
})


Vue.config.devtools = true;


/*
 Functions below : Utility functions
 Descipition: came with the loading screen , unsure exactly 

*/



if (!String.format) {
  String.format = function (format) {
    var args = Array.prototype.slice.call(arguments, 1);
    return format.replace(/{(\d+)}/g, function (match, number) {
      return typeof args[number] != 'undefined'
        ? args[number]
        : match
        ;
    });
  };
}

var i = 0;
while (i < currentProgress.length) {
  progressMaxLengths[i] = loadingWeights[i] * totalWidth;
  progressPositions[i + 1] = progressPositions[i] + progressMaxLengths[i];
  i++;
}


Array.prototype.last = function () {
  return this[this.length - 1];
};


/*
 Functions below : Native and handler functions 
 Descipition: Handle incoming information from the loadingscreen API 

*/


if (!window.invokeNative) {

  var newType = function newType(name) {
    return function () {
      return handlers.startInitFunction({ type: name });
    };
  };
  var newOrder = function newOrder(name, idx, count) {
    return function () {
      return handlers.startInitFunctionOrder({ type: name, order: idx, count: count });
    };
  };
  var newInvoke = function newInvoke(name, func, i) {
    return function () {
      handlers.initFunctionInvoking({ type: name, name: func, idx: i }); handlers.initFunctionInvoked({ type: name });
    };
  };
  var startEntries = function startEntries(count) {
    return function () {
      return handlers.startDataFileEntries({ count: count });
    };
  };
  var addEntry = function addEntry() {
    return function () {
      return handlers.onDataFileEntry({ name: 'meow', isNew: true });
    };
  };
  var stopEntries = function stopEntries() {
    return function () {
      return handlers.endDataFileEntries({});
    };
  };

  var newTypeWithOrder = function newTypeWithOrder(name, count) {
    return function () {
      newType(name)(); newOrder(name, 1, count)();
    };
  };

  const demoFuncs = [
    newTypeWithOrder('MAP', 5),
    newInvoke('MAP', 'meow1', 1),
    newInvoke('MAP', 'meow2', 2),
    newInvoke('MAP', 'meow3', 3),
    newInvoke('MAP', 'meow4', 4),
    newInvoke('MAP', 'meow5', 5),
    newOrder('MAP', 2, 2),
    newInvoke('MAP', 'meow1', 1),
    newInvoke('MAP', 'meow2', 2),
    startEntries(6),
    addEntry(),
    addEntry(),
    addEntry(),
    addEntry(),
    addEntry(),
    addEntry(),
    stopEntries(),
    newTypeWithOrder('INIT_SESSION', 4),
    newInvoke('INIT_SESSION', 'meow1', 1),
    newInvoke('INIT_SESSION', 'meow2', 2),
    newInvoke('INIT_SESSION', 'meow3', 3),
    newInvoke('INIT_SESSION', 'meow4', 4),
  ];

  setInterval(function () { demoFuncs.length && demoFuncs.shift()(); }, 350);
}


const handlers = {
  startInitFunction(data) {
    gstate.elems.push({
      name: data.type,
      orders: []
    });

    v.printLog(1, String.format('Running {0} init functions', data.type));
    if (data.type) v.doProgress(data.type);
  },
  startInitFunctionOrder(data) {
    count = data.count;
    v.printLog(1, String.format('[{0}] Running functions of order {1} ({2} total)', data.type, data.order, data.count));
    if (data.type) v.doProgress(data.type);
  },

  initFunctionInvoking(data) {
    v.printLog(3, String.format('Invoking {0} {1} init ({2} of {3})', data.name, data.type, data.idx, count));
    if (data.type) v.doProgress(data.type);
  },

  initFunctionInvoked(data) {
    if (data.type) v.doProgress(data.type);
  },

  endInitFunction(data) {
    v.printLog(1, String.format('Done running {0} init functions', data.type));
    if (data.type) v.doProgress(data.type);
  },

  startDataFileEntries(data) {
    count = data.count;

    v.printLog(1, 'Loading map');
    if (data.type) v.doProgress(data.type);
  },

  onDataFileEntry(data) {
    v.printLog(3, String.format('Loading {0}', data.name));
    v.doProgress(data.type);
    if (data.type) v.doProgress(data.type);
  },

  endDataFileEntries() {
    v.printLog(1, 'Done loading map');
  },

  performMapLoadFunction(data) {
    v.doProgress('MAP');
  },

  onLogLine(data) {
    v.printLog(3, data.message);
  }
};



// Windows event handler and interval for keep log up to date 


setInterval(function () { if (v.showLog) { document.querySelector('#log').innerHTML = gstate.log.slice(-10).map(function (e) { return String.format("[{0}] {1}", e.type, e.str) }).join('<br />'); } }, 100);

window.addEventListener('message', function (e) {
  (handlers[e.data.eventName] || function () { })(e.data);
});


/*
 Functions below : Background elements
 Descipition: handles the transition of backgrounds and the end and start of animation of backgrounds

*/

var usedIndices = [];
function generateBackground() {
  var images = document.querySelectorAll("#background img");

  if (usedIndices.length === images.length) {
    usedIndices = [];
  }

  var rnd = v.randomBackground(images.length)
  while (usedIndices.indexOf(rnd) !== -1) {
    rnd = v.randomBackground(images.length)
  }

  for (var i = images.length - 1; i >= 0; i--) {
    if (i == rnd) {
      document.getElementById("bak" + i).style.opacity = 1;
      TriggerAnimation("bak" + i)
    }
    else {
      document.getElementById("bak" + i).style.opacity = 0;
    }
  }
}

var el = document.getElementById("background");

function TriggerAnimation(elID) {
  var targert = document.getElementById(elID)
  targert.style.animation = 'none';
  targert.offsetHeight; /* trigger reflow */
  targert.style.animation = null;
}

//  Starting functions
setInterval(() => {
  generateBackground();
}, 9000);

generateBackground();
v.updateProgress();
