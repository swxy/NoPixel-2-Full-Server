var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;

var cursor = document.getElementById("cursor");
var cursorX = documentWidth / 2;
var cursorY = documentHeight / 2;

var btnCount = 0;
var btnSelected = 0;

var currentAmountOfMenus = 1
var buttonHeight = 0

function UpdateCursorPos() {
    cursor.style.left = cursorX;
    cursor.style.top = cursorY;
}

function Click(x, y) {
    var element = $(document.elementFromPoint(x, y));
    element.focus().click();
}

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            $( "#login-form" ).empty();
            btnCount = 0;
            btnSelected = 0;
            cursor.style.display = event.data.enable ? "block" : "none";
            document.body.style.display = event.data.enable ? "block" : "none";
        } else if (event.data.type == "endOfCurrentMenu") {
            if (event.data.isEnd == true)
            {
                if (currentAmountOfMenus > 1)
                {
                    $('.menu'+currentAmountOfMenus).css('left', (-320)+(currentAmountOfMenus*280));
                }
                currentAmountOfMenus++
                buttonHeight = 0
            }
            else if (event.data.isEnd == false)
            {
                currentAmountOfMenus = 0
            }
        } else if (event.data.type == "addButton") {
            
            var f = document.getElementById("login-form");
            var xx = document.getElementById("dialog");
            xx.setAttribute('style',"fixed; top: 50%; left: 50%; transform: translate(-50%, -50%)");
            btnCount++;
            var i = document.createElement("button");
            event.id = btnCount;
            var startingHeight = -170
            var startingLeft = 10
            if(event.data.buttonType == "animSets")
            {
                startingHeight = -470
            }

            if(event.data.buttonType == "tattoo")
            {
                startingLeft = 810
            }


            if(event.data.buttonType == "hair2")
            {
                startingLeft = 810
                startingHeight = -1147
            }

            if(event.data.buttonType == "hair")
            {
                startingLeft = 550
                startingHeight = -560
            }


            if(event.data.buttonType == "hairclose")
            {
                startingLeft = -260
                startingHeight = 420

            }
            if(event.data.buttonType == "haircloseaids")
            {
                startingLeft = 0
                startingHeight = 330                
            }

            if(event.data.buttonType == "hairnextprev")
            {
                startingLeft = 260
                startingHeight = 285
            }


            i.setAttribute('id', 'btn' + btnCount);
            i.setAttribute('class',"button button1 menu"+currentAmountOfMenus);
            i.setAttribute('value',event.data.functionname);
            i.setAttribute('type',"button");
            i.setAttribute('menu',currentAmountOfMenus);
            i.style.left = (startingLeft+(currentAmountOfMenus*280))
            i.style.top = (startingHeight+(buttonHeight*45))
            i.innerHTML = event.data.name;

            if(event.data.buttonType == "police")
            {
                i.style.backgroundImage = "url('nui://uitest/client/html/menuButtonPolice.png')"
            }
            else if (event.data.buttonType == "medic")
            {
                i.style.backgroundImage = "url('nui://uitest/client/html/menuButtonEms.png')"
            }
            else if (event.data.buttonType == "judge")
            {
                i.style.backgroundImage = "url('nui://uitest/client/html/menuButtonJudge.png')"
            }
            else
            {
                i.style.backgroundImage = "url('nui://uitest/client/html/menuButton.png')"
            }

            buttonHeight++
            if (currentAmountOfMenus > 1)
            {
                for (var j = currentAmountOfMenus; j >= 0; j--) {
                    if (j != currentAmountOfMenus)
                    {
                        $('.menu'+j).css('left', (-320)+(j*280));
                    }   
                }
            }
            i.onclick = function () { 
                var menu = $( "#btn" + btnSelected ).attr("menu")
                if (menu == currentAmountOfMenus-1)
                {
                    $.post('http://uitest/runfunction', JSON.stringify({  functionset: event.data.functionname , name: event.data.name, buttonType: event.data.buttonType })); 
                }
                else
                {
                    if (event.data.functionname == "openSubMenu")
                    {
                        if (menu == 0)
                        {   
                            for (var m = currentAmountOfMenus-1; m >= 1; m--) {
                                currentAmountOfMenus--
                                $('.menu'+0).css('left',(10+(0*280)));
                                var element = document.getElementsByClassName("menu"+m), index;
                                if(element !== null)
                                {
                                    for (index = element.length - 1; index >= 0; index--) {
                                      element[index].parentNode.removeChild(element[index]);
                                    }
                                }
                            }
                        }
                        else
                        {
                            var menuStop = currentAmountOfMenus - menu
                            for (var m = currentAmountOfMenus ; m >= menuStop; m--) {
                                currentAmountOfMenus = menuStop
                                var element = document.getElementsByClassName("menu"+m), index;
                                if(element !== null)
                                {
                                    for (index = element.length - 1; index >= 0; index--) {
                                      element[index].parentNode.removeChild(element[index]);
                                    }
                                }
                            }
                        }
                         $.post('http://uitest/runfunction', JSON.stringify({  functionset: event.data.functionname , name: event.data.name, buttonType: event.data.buttonType })); 
                    }
                    else
                    {
                        $.post('http://uitest/runfunction', JSON.stringify({  functionset: event.data.functionname , name: event.data.name, buttonType: event.data.buttonType })); 
                    }
                }
                
            }; 
            i.onmouseover = function () {
                $( "#btn" + btnSelected ).removeClass('selected');
                btnSelected = event.id;
               
            };
            f.appendChild(i);

            if (btnCount == 1) {
                btnSelected = btnCount;
                $( "#btn" + btnSelected ).addClass('selected');
            }

        } else if (event.data.type == "addButton3") {
            var f = document.getElementById("login-form");

            var xx = document.getElementById("dialog");
            xx.setAttribute('style',"fixed; top: 50%; margin-left: 35%; width:35%; transform: translate(-50%, -50%)");

            btnCount++;
            var i = document.createElement("button");
            event.id = btnCount;
            i.setAttribute('id', 'btn' + btnCount);
            i.setAttribute('class',"button button2");
            i.setAttribute('value',event.data.functionname);
            i.setAttribute('type',"button");
            i.innerHTML = event.data.name;
            i.onclick = function () { $.post('http://uitest/runfunction', JSON.stringify({  functionset: event.data.functionname })); }; 
            i.onmouseover = function () {
                $( "#btn" + btnSelected ).removeClass('selected');
                btnSelected = event.id;
                i.addClass('selected');
            };
            f.appendChild(i);

            if (btnCount == 1) {
                btnSelected = btnCount;
                $( "#btn" + btnSelected ).addClass('selected');
            }
        } else if (event.data.type == "click") {
            // Avoid clicking the cursor itself, click 1px to the top/left;
            btnDeSelect();
            Click(cursorX - 1, cursorY - 1);
        } else if (event.data.type == "up") {
            btnUp();
        } else if (event.data.type == "down") {
            btnDown();
        }

    });

    $(document).mousemove(function(event) {
        cursorX = event.pageX;
        cursorY = event.pageY;
        UpdateCursorPos();
        btnDeSelect();
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
           $.post('http://uitest/escape', JSON.stringify({}));
        }
        if (data.which == 113) { // f2
           $.post('http://uitest/escape', JSON.stringify({}));
        }
        if (data.which == 37) { // left
            $.post('http://uitest/left', JSON.stringify({}));
        }
        if (data.which == 39) { // right
            $.post('http://uitest/right', JSON.stringify({}));
        }
        if (data.which == 38) { // Up
            $.post('http://uitest/up', JSON.stringify({}));
        }
        if (data.which == 40) { // Down
            $.post('http://uitest/down', JSON.stringify({}));
        }
        if (data.which == 13) { // Enter
            btnEnter();
        }
    };

    $("#login-form button").click(function (ev) {
        ev.preventDefault(); // cancel form submission

        if ($(this).attr("value") == "close") {
            //do button 1 thing
             $.post('http://uitest/escape', JSON.stringify({}));
        }

    });

    function btnUp() {
        $( "#btn" + btnSelected ).removeClass('selected');
        btnSelected--;
        if (btnSelected <= 0) {
            btnSelected = btnCount;
        }
        $( "#btn" + btnSelected ).addClass('selected');
    }

    function btnDown() {
        $( "#btn" + btnSelected ).removeClass('selected');
        btnSelected++;
        if (btnSelected > btnCount) {
            btnSelected = 1;
        }
        $( "#btn" + btnSelected ).addClass('selected');
    }

    function btnEnter() {
        if (btnSelected > 0) {
            $( "#btn" + btnSelected )[0].onclick();
        }
    }

    function btnDeSelect() {        
        $( "#btn" + btnSelected ).removeClass('selected');
    }

});
