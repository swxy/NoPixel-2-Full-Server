var cursorEnabled = false;
var debug = false;

$(function()
{
    listen();

    if (debug){
        $("body").css("background", "url('https://images6.alphacoders.com/553/553248.jpg')")

        openMenu();
        $("*").css("cursor", "auto")
    }
})

function sendNuiMessage(data){
    $.post("http://np-admin/nuiMessage", JSON.stringify(data));
}

function receivedNuiMessage(event){
    var data = event.data;

    if (data.open) {
        openMenu();
    }

    if (data.textEntry) {
        showTextEntry(data.title, data.submsg);
    }
}

function openMenu(){
    showCursor(true);
    $("#main").css("display", "block");
    showCursor(true);
}

function closeMenu(){
    $("#main").css("display", "none");
    sendNuiMessage({close: true});
    showCursor(false);
}

function showCursor(toggle){
    if (toggle) {
        sendNuiMessage({showcursor: true});
        cursorEnabled = true;
        sendNuiMessage({setcursorloc: {x: 0.5, y: 0.5}});
    } else {
        sendNuiMessage({showcursor: false});
        cursorEnabled = false;
    }
}

function showTextEntry(title, subMsg, cancel, submit){
    if (cancel) {
        $("#textEntry").css("display", "none");

        sendNuiMessage({textEntry: true, cancel: true});
        closeMenu();
        return;
    }

    if (submit) {
        var text = $("textArea").val();
        
        if (!text) {
            sendNuiMessage({textEntry: true, cancel: true});
            return;
        }

        sendNuiMessage({textEntry: true, submit: true, text: text});
        closeMenu();

        text = null;

        $("#textEntry").css("display", "none");

        return;
    }

    $("textArea").val("");
    $("#textEntry .title").html(title);
    $("#textEntry .subMsg").html(subMsg)
    $("#textEntry").css("display", "block");
    $("textArea").focus();
}

function listen(){
    window.addEventListener("message", receivedNuiMessage);
    window.onkeyup = listenInput;

    $("textArea").live("keydown", function(e) {
        if ($("#textEntry").css("display") == "block"){
            if (e.which == 13){
                showTextEntry(null, null, false, true);
                e.preventDefault();
                return false;
            }
        }
    });
}

function listenInput(e){
    var key = e.keyCode ? e.keyCode : e.which;

    if (key == 27) {
        closeMenu();
    }
}