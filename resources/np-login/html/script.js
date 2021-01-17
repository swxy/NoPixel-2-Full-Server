var waitingEnter = false;
var waitingData = false;
var waitingCharData = false;
var curLuaTime = 0;
var cursorEnabled = false;
var debug = false;
var hoverClick = null;
var charId = null;

$(function()
{
    listen();

    if (debug){
        $("body").css("background", "url('https://images6.alphacoders.com/553/553248.jpg')")

        openMenu();
        $("*").css("cursor", "auto")
        
        //$("#main").css("display", "block")
        //showCharacterSelect(true);
        //$("#newCharacter").css("display", "block");
    }
})

function sendNuiMessage(data){
    $.post("http://np-login/nuiMessage", JSON.stringify(data));
}

function receivedNuiMessage(event){
    var data = event.data;

    if (data.date){
        curLuaTime = data.date;
    }

    if (data.open){
        openMenu();
    }

    if (data.close){
        closeMenu();
    }

    if (data.playerdata){
        receivedPlayerData(data);
    }

    if (data.err){
        showError("Error", data.err.msg, true, true);
    }

    if (data.createCharacter){
        createdCharacter(data);
    }

    if (data.selectcharacter){
        console.log("trying to select char")
        selectcharacter(id);
    }

    if (data.deleteCharacter){
        deletecharacter(charId);
    }

    if (data.playercharacters){
        receivedCharacterData(data);
    }

    if (data.reload){
        retry(true);
    }
}

function openMenu(){
    clearMenu();

    showCursor(true);

    $("#main").css("display", "block");
    $("#init").css("display", "block");
    $("#changelog").css("display", "block");

    waitingEnter = true;
}

function closeMenu(){
    $("#main").css("display", "none");
    closeWindow(null, true);

    clearMenu();

    sendNuiMessage({close: true});
}

function clearMenu(){
    waitingEnter = false;
    waitingData = false;
    waitingCharData = false;
    charId = null;
    showLoading(false);
    showCursor(false);
    showError(null, null, false, false);
    closeWindow(null, true)
}

function closeWindow(winder, allwinders){
    if (allwinders){
        $(".window").css("display", "none");
        return;
    }

    $("#" + winder).css("display", "none");
}

function showLoading(toggle, msg){
    msg = msg ? msg : "Loading...";

    $("#loading p").html(msg);

    if (toggle){
        $("#loading").css("display", "block");
    }else {
        $("#loading").css("display", "none");
    }
}

function showCursor(toggle){
    if (toggle){
        sendNuiMessage({showcursor: true});
        cursorEnabled = true;
        sendNuiMessage({setcursorloc: {x: 0.5, y: 0.5}});
    } else{
        sendNuiMessage({showcursor: false});
        cursorEnabled = false;
    }
}

function showError(title, msg, killwindows, toggle){
    msg = msg ? msg : "There was an error";
    title = title ? title : "Error";

    if (killwindows){
        closeWindow(null, true);
    }

    showLoading(false)

    $("#error .title").html(title);
    $("#error .errmsg").html(msg);

    if (toggle){
        $("#error").css("display", "block");
        showCursor(true);
    } else{
        $("#error").css("display", "none");
        showCursor(false);
    }
}

function showCharacterSelect(){
    showCursor(true);

    closeWindow(null, true);
    $("#characters").css("display", "flex");
}




function buildCharacterSlots(characters){
    if(debug) {return;}

    $("#characters").html("");
    var slot = 0;

    for (var k in characters){
        slot++;
        var char = characters[k];
        var date = new Date(char.dob);
        date = (date.getMonth() + 1) + "-" + (date.getDate() + 1) + "-" + date.getFullYear();
        curLuaTime = parseInt(curLuaTime);


        var numSlot = "<div id='" + slot + "' class='slot'>";
        var title = "<div class='title'>" + char.first_name + "</div><br><br>";
        var name = "<div class='name'><span class='entry'>Name:</span><br> " + char.first_name + " " + char.last_name + "</div><br><br>";
        var dob = "<div class='dob'><span class='entry'>DOB:</span><br> " + date + "</div><br><br>";
        var gender = "<div class='gender'><span class='entry'>Gender:</span><br> " + (char.gender == 0 ? "Male" : "Female") + "</div><br><br>";
        var phone = "<div class='phone'><span class='entry'>Phone #:</span><br> " + char.phone_number.toString().replace(/(\d{3})(\d{3})(\d{4})/, "$1-$2-$3") + "</div><br><br>";
        var cash = "<div class='cash'><span class='entry'><br />Cash:</span><br> $" + Number(char.cash).toLocaleString() + "</div><br><br>";
        var bank = "<div class='bank'><span class='entry'>Bank:</span><br> $" + Number(char.bank).toLocaleString() + "</div><br><br>";
        var story = "<div class='story' style='word-wrap: break-word;'><span class='entry'><br/>Story: </span><br /> " + char.story + "</div>";
        var buttons = "<div class='buttons'><div class='button' onclick='selectCharacter(" + char.id + ");'><div class='verticalAlign'>Select Character</div></div><div class='button del' onclick='showDeleteCharacter(" + char.id + ");'><div class='verticalAlign'>Delete Character</div></div></div>";

        $("#characters").append(numSlot + title + "<div id='cdata' class='scroll'>" + name + dob + gender + phone + cash + bank + story + "</div>" + buttons + "</div>");
    }
    var emptySlots = 8 - slot;
    var count = emptySlots;
    if (emptySlots > 0){
        for (i = emptySlots; i > 0; i--){
            var numSlot = "<div id='slot" + count + "' class='slot'>";
            var title = "<div class='title'>Empty Slot</div>";
            var cdata = "<div id='cdata' class='scroll'> </div>";
            var buttons = "<div class='buttons'><div class='button' onclick='showCreateCharacter();'><div class='verticalAlign'>New Character</div></div></div>"
            $("#characters").append(numSlot + title + cdata + buttons + "</div>")
            count--;
        }
    }
}

function selectCharacter(id){
    for (var k in characters){
        var char = characters[k];
    }
    clearMenu();
    sendNuiMessage({selectcharacter: id});
}

function showDeleteCharacter(id, cancel, close){
    if (cancel) {
        charId = null;
        $("#deleteCharacter").css("display", "none");
        return;
    }

    if (close) {
        $("#deleteCharacter").css("display", "none");
        showCharacterSelect(true);
        return;
    }

    closeWindow(null, true);
    charId = id;
    $("#deleteCharacter").css("display", "block");
}

function deleteCharacter(){
    if (!charId || charId == null) {return;}

    sendNuiMessage({deletecharacter: charId});

    showDeleteCharacter(null, true);
    showCursor(false);
    showLoading("true", "Deleting Character");

    if (debug) {
        retry(true);
    }
}

function createdCharacter(data){
    if (!debug && data.createCharacter.error){
        showError("Error:", data.createCharacter.msg, true, true)
        return
    }

    closeWindow(null, true);
    showLoading(true, "Fetching new player data");
    setTimeout(function(){
        fetchPlayerData();
    }, 200);
}

function showCreateCharacter(){
    closeWindow(null, true);

    $("#firstname").val("");
    $("#lastname").val("");
    $("#dob").val("");
    $("#gender").val("Male");
    $("#story").val("Character's background, this can be short and simple");
    
    $("#newCharacter").css("display", "block");
}

function newCharacterSubmit(){
    var data = {
        newchar: true,
        chardata: {
            firstname: $("#firstname").val(),
            lastname: $("#lastname").val(),
            dob: $("#dob").val(),
            gender: $("#gender").val() == "Male" ? 0 : 1,
            background: $("#background").val(),
            story: $("#story").val()
        }
    };

    closeWindow(null, true);
    showCursor(false)
    showLoading(true, "Creating Character");

    setTimeout(function(){
        sendNuiMessage(data);

        if (debug) {
            createdCharacter();
        }
    }, 200);
}

function retry(show){
    showError(null, null, null, false);
    closeWindow(null, true);

    if (show){
        fetchPlayerData();
        return;
    }

    showLoading(true, "Retrying");
    setTimeout(function(){
        fetchPlayerData();
    }, 1500);
}

function disconnect(){
    closeMenu();
    sendNuiMessage({disconnect: true});
}

function listen(){
    listenMouse();
    window.addEventListener("message", receivedNuiMessage);
    window.onkeyup = listenInput;

    /*$(".button").mouseenter(function(){
        hoverClick.pause();
        hoverClick.volume = 0.05;
        hoverClick.currentTime = 0;
        hoverClick.play();
    })*/

    $("#characterForm").submit(function(){
        newCharacterSubmit();
    })
}

function fetchPlayerData(){
    waitingEnter = false;
    waitingData = true;
    showLoading(true, "Fetching Player Data");
    closeWindow("init");
    closeWindow("changelog");
    
    setTimeout(function(){
        sendNuiMessage({fetchdata: true});
        if (debug){
            receivedPlayerData({playerdata: {debug: true}});
        }
    }, 1500);
}

function fetchPlayerCharacters(){
    waitingCharData = true;

    setTimeout(function(){
        sendNuiMessage({fetchcharacters: true});

        if (debug){
            receivedCharacterData();
        }
    }, 200);
}

function validateCharacterData(data){
    showLoading(true, "Validating Character Data");

    if (!debug && data.playercharacters["char1"]){
        for (var k in data.playercharacters){
            var char = data.playercharacters[k];

            if (!char || char == undefined || char == null || char == ""){
                showError("Error", "One of your characters returned nil. (cslot: " + k + ")<br/>Contact an administrator if this persists.", true, true);
                return;
            }

            for(var i in char){
                var entry = char[i];
                if (entry != 0 && !entry || entry == undefined || entry == null || entry === ""){
                    showError("Error", "One of your characters has invalid data. Contact an administrator if this persists.<br/> Cid: " + char.id + " Entry: " + i.toString(), true, true);
                    return;
                }
            }
        }
    }

    var chars = debug ? false : data.playercharacters;

    setTimeout(function(){
        showLoading(false);
        buildCharacterSlots(chars);
        showCharacterSelect(true);
    }, 200);
}

function receivedCharacterData(data){
    if (!waitingCharData) {return;}

    waitingCharData = false;

    showLoading(true, "Received Character Data")

    setTimeout(function(){
        validateCharacterData(data);
    }, 200);
}

function validatePlayerData(data){
    showLoading(true, "Validating Player Data");

    setTimeout(function(){
        for (var k in data.playerdata){
            if (!data.playerdata[k] && data.playerdata[k] != 0 || data.playerdata[k] === "" || data.playerdata[k] == undefined || data.playerdata[k] == null && !debug){
                showError("Error", "There was an error validating your data; Couldn't retrieve value '" + k + "'", true, true);
                showLoading(false);
                return;
            }
        }

        showLoading(true, "Fetching Player Characters");

        fetchPlayerCharacters();
    }, 200);
}

function receivedPlayerData(data){
    if (!waitingData) {return;}
    
    waitingData = false;

    if (!data.playerdata){
        showError("Error", "There was a problem fetching your player data, it returned empty", true, true);
        showLoading(false);
        return;
    }

    showLoading(true, "Received Player Data");

    setTimeout(function(){
        validatePlayerData(data);
    }, 200)
}

function listenInput(e){
    var key = e.keyCode ? e.keyCode : e.which;

    if (key == 13 && waitingEnter){
        showCursor(false);
        fetchPlayerData();
    }

    /*if (key == 27){
        closeMenu();
    }*/
}

function listenMouse(){
    window.document.onmousemove = function(e) {
        $("#cursor").css("left", e.pageX);
        $("#cursor").css("top", e.pageY);
	}
}