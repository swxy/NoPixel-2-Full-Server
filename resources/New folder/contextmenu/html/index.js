$(function () {

    var objectType = null;
    var contextElement = document.getElementById("context-menu");
    var myJob  = "unemployed";
    var isAdmin = false;
    var isPlayer = false;
    // -- 0 = no entity  
    // -- 1 = ped  
    // -- 2 = vehicle  
    // -- 3 = object
    let policeMenu = ["escort","seat nearest", "frisk", "search", "remove mask", "check license", "seize cash"];
    let doorMenu = ["front left", "front right", "back left", "back right", "hood", "trunk"];
    let towMenu = ["impound", "tow"];

    function display(bool) {
        if (bool) {
            $("#container").show();
            $("#close").show();
        } else {
            $("#container").hide();
            $("#close").hide();
        }
    }

    display(false)
    
    //Called from "function SetDisplay(bool)" in lua .. sends the NUI status.
    //Called from "function SendObjectData()" in lua .. Sent the corrisponding data in this JS. 
    window.addEventListener('message', function(event) {
        var item = event.data;
        if (event.data.type == "openGeneral") {
            $('.container').css('visibility', 'visible')
      }
        //Initial called to show NUI
        if (item.type === "ui") 
        {
            if (item.status == true) 
            {
                display(true)
            } 
            else 
            {
                display(false)
            }
        }
        //Called after NUI is SHOWN
        if (item.type === "objectData") 
        {
            clearContextmenu();
            //Is a player
            if(item.isPly == true)
            {
                isPlayer = true;
            }
            else
            {
                isPlayer = false;
            }
            //Object type
            objectType = item.objectType;             
            //Set the job
            myJob = item.job;
            //admin
            isAdmin = item.admin;
            populateContextMenu();
        }
    })

    // if the person uses the escape or Z key, it will exit the resource
    //Does a Callback to the lua to CLOSE the NUI.
    //27 = ESC , 90 = Z
    document.onkeyup = function (data) {
        if (data.which == 27 || data.which == 90) 
        {
            document.getElementById("context-menu").classList.remove("active");
            clearObjectData();
            clearContextmenu();
            $.post('https://contextmenu/exit', JSON.stringify({}));
            return
        }
    };
    //Callbacks to contextmenu-c.lua
    //e.target.id is the <div> id = "XXXXXXXX" </div> on the element
    //-----------------------------------------------------------------
    // $.post('https://contextmenu/use', JSON.stringify({}));
    // return
    //- Calls back the specific function in the lua script -> RegisterNUICallback("use", function(data) ............. end) etc.
    //-----------------------------------------------------------------
    //Add NEW cases for any NEW menu items that are created so they can do Callbacks to the LUA.
    document.addEventListener("click", (e) => {
        // -- doorIndex:  
        // -- 0 = Front Left Door  
        // -- 1 = Front Right Door  
        // -- 2 = Back Left Door  
        // -- 3 = Back Right Door  
        // -- 4 = Hood  
        // -- 5 = Trunk  
        // -- 6 = Back  
        // -- 7 = Back2
        switch(e.target.id)
        {
            case "frontleft":
                passDoorIndex(0);
                break;
            case "frontright":
                passDoorIndex(1);
                break;
            case "backleft":
                passDoorIndex(2);
                break;
            case "backright":
                passDoorIndex(3);
                break;
            case "hood":
                passDoorIndex(4);
                break;
            case "trunk":
                passDoorIndex(5);
                break;
            case "use":
                $.post('https://contextmenu/use', JSON.stringify({})); //General options
                break;
            case "examine":
                $.post('https://contextmenu/examine', JSON.stringify({})); //General options
                break;
            case "close":
                $.post('https://contextmenu/exit', JSON.stringify({})); //General options
                break;
            case "tow":
                $.post('https://contextmenu/tow', JSON.stringify({})); //Tow options 
                break;
            case "impound":
                $.post('https://contextmenu/impound', JSON.stringify({})); //Tow options 
                break;
            case "escort":
                $.post('https://contextmenu/escort', JSON.stringify({})); //Police options
                break;
            case "seatnearest":
                $.post('https://contextmenu/seatnearest', JSON.stringify({})); //Police options
                break;
            case "frisk":
                $.post('https://contextmenu/frisk', JSON.stringify({})); //Police options 
                break;
            case "search":
                $.post('https://contextmenu/search', JSON.stringify({})); //Police options
                break;
            case "removemask":
                $.post('https://contextmenu/removemask', JSON.stringify({})); //Police options
                break;
            case "check-license":
                $.post('https://contextmenu/checklicense', JSON.stringify({})); //Police options
                break;
            case "seizecash":
                $.post('https://contextmenu/seizecash', JSON.stringify({})); //Police options
                break;
            case "steal":
                $.post('https://contextmenu/steal', JSON.stringify({})); //Illegal options
                break;
            case "lockpick":
                $.post('https://contextmenu/lockpick', JSON.stringify({})); //Illegal options
                break;
            case "export-entity-data":
                $.post('https://contextmenu/export', JSON.stringify({})); //Admin/Utility options
                break;
        }
        clearObjectData();
    })
    function passDoorIndex(doorIndex)
    {
        $.post('https://contextmenu/doors', JSON.stringify({index: doorIndex}));
        return
    }
    //Context menu -- right click
    window.addEventListener("contextmenu",function(event){
        event.preventDefault();
        $.post('https://contextmenu/rightclick', JSON.stringify({}));
        contextElement.style.top = event.offsetY + "px";
        contextElement.style.left = event.offsetX + "px";
        $('.containereye').css('visibility', 'visible')
    });
    window.addEventListener("click",function(){
        document.getElementById("context-menu").classList.remove("active");
    });
    //clears the object data on menu exit
    function clearObjectData()
    {
        objectType = null;
        doorIndex = null;
    }
    //-------------------------------------------
    //-------Where the menu is generated---------
    //-------------------------------------------
    function populateContextMenu()
    {
        createMenuItem("Use", "use");
        createMenuItem("Examine", "examine");
        checkIfVehicle();
        checkJob();
        createIllegalActions();
        checkIfAdmin();
        createMenuItem("Close", "close");
        contextElement.classList.add("active");
    }
    //Clears the menu on exit or new generated menu so the elements dont persist through new menus (stacking menus infinitely)
    function clearContextmenu()
    {
        var item = document.getElementById("context-menu");
        item.innerHTML = ''; //<--- Look into a CLEANER option.
    }
    //---------------------------------------------
    //Creates menu items
    //param 1: Name of the menu item. This will be displayed ON the menu.
    //param 2: ID of the item for CALLING it when intereacted with (clicked).
    function createMenuItem(name, id)
    {
        var node;
        var textnode
        if (id == "close" || id == "export-entity-data")
        {
            node = document.createElement("hr");
            document.getElementById("context-menu").appendChild(node);
        }
        node = document.createElement("div");
        textnode = document.createTextNode(name);
        node.setAttribute("id", id);
        node.setAttribute("class", "menu-item");
        node.appendChild(textnode);
        document.getElementById("context-menu").appendChild(node);
    }
    //---------------------------------------------
    //Creates sub menu items
    //param 1: The Id of the sub menu for reference to attach the sub menu items.
    //param 2: the parent node (door-menu, police-menu etc.) of which the sub menu should attach to.
    function createSubMenu(subMenu, parentNode)
    {
        var node = document.createElement("div");
        node.setAttribute("id", subMenu);
        document.getElementById(parentNode).appendChild(node);
    }
    //---------------------------------------------
    //Creates sub menu items
    //param 1: Takes an Array of strings of which individual menus are created.
    //param 2: Which sub menu item it should add these to -> door-menu, police-menu etc.
    function createSubMenuItems(str, submenu)
    {
        var node;
        var textnode;
        for (i = 0; i < str.length; ++i)
        {
            node = document.createElement("div");
            textnode = document.createTextNode(upperCaseFirstLetter(str[i]));
            node.setAttribute("id", str[i].replace(/\s/g, ""));
            node.setAttribute("class", "menu-item");
            node.appendChild(textnode);
            document.getElementById(submenu).appendChild(node);
        }
    }
    //Checks if the selected object is a car and generates the SUB MENU with door options.
    function checkIfVehicle()
    {
        if(objectType == 2)
        {
            createMenuItem("Doors", "door-menu"); //Creates the Initial Menu option.
            createSubMenu("door-sub-menu","door-menu"); //Adds the ID handles to a Sub menu element
            createSubMenuItems(doorMenu, "door-sub-menu"); //Adds the Menu options to the specific Sub menu.
        }
    }
    //Adds SUB MENUS based on which type of job the ped currently has.
    function checkJob()
    {
        //For populating Sub menus with JOB related options.(E.g jobs like EMS would also be here)
        //objectType == 2 is a vehicle. isPlayer is a Bool that is either TRUE or FALSE depending on the Entity is a player.
        if(myJob == "tow" && objectType == 2)
        {
            createMenuItem("Tow", "tow-menu");
            createSubMenu("tow-sub-menu","tow-menu");
            createSubMenuItems(towMenu, "tow-sub-menu");
        }
        else if(myJob == "police" && isPlayer)
        {
            createMenuItem("Police", "police-menu");
            createSubMenu("police-sub-menu","police-menu");
            createSubMenuItems(policeMenu, "police-sub-menu");
        }
    }
    //Adds the illegal actions to the menu
    function createIllegalActions()
    {
        //Checks if the Entity type is a PED and a Player.
        if(objectType == 1 && isPlayer)
        {
            createMenuItem("Steal", "steal");
        }
        if(objectType == 2)
        {
            createMenuItem("Lockpick", "lockpick");
        }
    }
    //Adds the Export Entity option on the Menu.
    function checkIfAdmin()
    {
        if(isAdmin)
        {
            createMenuItem("Export Entity", "export-entity-data");
        }
    }
    //Makes the first letter in a string Uppercase.
    function upperCaseFirstLetter(string) 
    {
        return string.charAt(0).toUpperCase() + string.slice(1);
    }
    //Not used
    function sleep(milliseconds) {
        const date = Date.now();
        let currentDate = null;
        do {
            currentDate = Date.now();
        } while (currentDate - date < milliseconds);
    }
})