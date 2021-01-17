window.onload = function(e)
{
    let menuStructure = {};
    let maxMenuItems = 10;

    function toggleMenuContainer(state)
    {
        if(state)
        {
            $("#menu_container").fadeIn("fast", "swing");
        }
        else
        {
            $("#menu_container").fadeOut("fast", "swing");
        }
    }

    function createMenu(menu, heading, subheading)
    {
        menuStructure[menu] = 
        {
            menu: menu,
            heading: heading,
            subheading: subheading,
            selectedItem: 0,
            previousSelectedItemID: null,
            container: "<ul id = 'menu_items' class = '" + menu + "' style = 'display: none; order: 5;'></ul>",
            items: {},
            itemsArray: {}
        }

        $("#menu_container").append(menuStructure[menu].container);
    }

    function destroyMenus()
    {
        for(var k in menuStructure)
        {
            $("." + menuStructure[k].menu).remove();
        }
        
        menuStructure = {}
    }

    function populateMenu(menu, id, item, item2)
    {
        menuStructure[menu].items[id] = 
        {
            id: id,
            item: item,
            item2: item2
        }

        if(item2 == "none")
        {
            $("." + menu).append("<li class = '" + id + "'><span class = 'item1'>" + item + "</span></li>");
        }
        else
        {
            $("." + menu).append("<li class = '" + id + "'><span class = 'item1'>" + item + "</span> <span class = 'item2' style = 'float: right;'>" + item2 + "</span></li>");
        }
    }

    function finishPopulatingMenu(menu)
    {
        menuStructure[menu].itemsArray = $("." + menu + " li").toArray();
    }

    function updateMenuHeading(menu)
    {
        $("#menu_heading span").text(menuStructure[menu].heading);
    }

    function updateMenuSubheading(menu)
    {
        $("#menu_subheading span").text(menuStructure[menu].subheading);
    }

    function updateMenuStatus(text)
    {
        $("#menu_status span").text(text);
    }

    function toggleMenu(state, menu)
    {
        if(state)
        {
            if(menuStructure[menu].selectedItem < maxMenuItems)
            {
                $("." + menu).empty();

                for(var i = 0; i < Object.keys(menuStructure[menu].itemsArray).length; i++)
                {
                    if(i < maxMenuItems)
                    {
                        $("." + menu).append(menuStructure[menu].itemsArray[i]);
                    }
                }

                $("." + menu + " .item_selected").find("i").remove();
                menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
                var currentHTML = $("." + menu + " .item_selected").html();
                $("." + menu + " .item_selected").html("<i class='fas fa-angle-double-right'></i> " + currentHTML);

                var val1 = $("." + menu + " .item_selected").attr("class").split(" ")[0];
                var val2 = $("." + menu + " .item_selected .item1").text();
                var val3 = $("." + menu + " .item_selected .item2").text();
                $.post("http://np-bennys/selectedItem", JSON.stringify({
                    id: val1,
                    item: val2,
                    item2: val3
                }));
            }
            else
            {
                $("." + menu).empty();

                for(var i = 0; i < Object.keys(menuStructure[menu].itemsArray).length; i++)
                {
                    if(i > (menuStructure[menu].selectedItem - maxMenuItems) && i <= (maxMenuItems + (menuStructure[menu].selectedItem - maxMenuItems)))
                    {
                        $("." + menu).append(menuStructure[menu].itemsArray[i]);
                    }
                }

                $("." + menu + " .item_selected").find("i").remove();
                menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
                var currentHTML = $("." + menu + " .item_selected").html();
                $("." + menu + " .item_selected").html("<i class='fas fa-angle-double-right'></i> " + currentHTML);

                var val1 = $("." + menu + " .item_selected").attr("class").split(" ")[0];
                var val2 = $("." + menu + " .item_selected .item1").text();
                var val3 = $("." + menu + " .item_selected .item2").text();
                $.post("http://np-bennys/selectedItem", JSON.stringify({
                    id: val1,
                    item: val2,
                    item2: val3
                }));
            }

            $("." + menu).show();
        }
        else
        {
            $("." + menu).hide();
        }
    }

    function updateItem2TextOnly(menu, id, text)
    {
        $("." + menu + " ." + id + " .item2").text(text);
        $.post("http://np-bennys/updateItem2", JSON.stringify({
            item: text
        }));
    }

    function updateItem2Text(menu, id, text)
    {
        if(menuStructure[menu].previousSelectedItemID == null)
        {
            $("." + menu + " ." + id + " .item2").text(text);

            menuStructure[menu].previousSelectedItemID = id
        }
        else if(id != menuStructure[menu].previousSelectedItemID)
        {
            var prevID = menuStructure[menu].previousSelectedItemID

            $("." + menu + " ." + prevID + " .item2").text(menuStructure[menu].items[prevID].item2);
            menuStructure[menu].itemsArray[prevID + 1].getElementsByClassName("item2")[0].textContent = menuStructure[menu].items[prevID].item2;
            menuStructure[menu].previousSelectedItemID = id;

            $("." + menu + " .item_selected .item2").text(text);
        }
        else
        {
            $("." + menu + " ." + id + " .item2").text(text);

            menuStructure[menu].previousSelectedItemID = null
        }

        $.post("http://np-bennys/updateItem2", JSON.stringify({
            item: text
        }));
    }

    function updateItem2ID(menu, id, text)
    {
        menuStructure[menu].previousSelectedItemID = id
    }

    function scrollMenuFunctionality(direction, menu)
    {
        switch(direction)
        {
            case "down":
                if(menuStructure[menu].selectedItem < (maxMenuItems - 1) && menuStructure[menu].selectedItem < (Object.keys(menuStructure[menu].itemsArray).length - 1))
                {
                    menuStructure[menu].selectedItem++;

                    menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
                    $("." + menu + " .item_selected").find("i").remove();

                    menuStructure[menu].itemsArray[menuStructure[menu].selectedItem - 1].classList.remove("item_selected");
                    var currentHTML = $("." + menu + " .item_selected").html();
                    $("." + menu + " .item_selected").html("<i class='fas fa-angle-double-right'></i> " + currentHTML);

                    var val1 = $("." + menu + " .item_selected").attr("class").split(" ")[0];
                    var val2 = $("." + menu + " .item_selected .item1").text();
                    var val3 = $("." + menu + " .item_selected .item2").text();
                    $.post("http://np-bennys/selectedItem", JSON.stringify({
                        id: val1,
                        item: val2,
                        item2: val3
                    }));
                }
                else if(menuStructure[menu].selectedItem < (Object.keys(menuStructure[menu].itemsArray).length - 1))
                {
                    menuStructure[menu].selectedItem++;

                    $("." + menu).append(menuStructure[menu].itemsArray[menuStructure[menu].selectedItem]);
                    menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
                    $("." + menu + " .item_selected").find("i").remove();

                    menuStructure[menu].itemsArray[menuStructure[menu].selectedItem - 1].classList.remove("item_selected");
                    var currentHTML = $("." + menu + " .item_selected").html();
                    $("." + menu + " .item_selected").html("<i class='fas fa-angle-double-right'></i> " + currentHTML);

                    menuStructure[menu].itemsArray[menuStructure[menu].selectedItem - maxMenuItems].remove();

                    var val1 = $("." + menu + " .item_selected").attr("class").split(" ")[0];
                    var val2 = $("." + menu + " .item_selected .item1").text();
                    var val3 = $("." + menu + " .item_selected .item2").text();
                    $.post("http://np-bennys/selectedItem", JSON.stringify({
                        id: val1,
                        item: val2,
                        item2: val3
                    }));
                }
                else if(menuStructure[menu].selectedItem == (Object.keys(menuStructure[menu].itemsArray).length - 1))
                {
                    menuStructure[menu].selectedItem = 0;

                    $("." + menu + " .item_selected").find("i").remove();
                    $("." + menu).empty();

                    for(var i = 0; i < Object.keys(menuStructure[menu].itemsArray).length; i++)
                    {
                        if(i < maxMenuItems)
                        {
                            $("." + menu).append(menuStructure[menu].itemsArray[i]);
                        }
                    }

                    menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
                    menuStructure[menu].itemsArray[Object.keys(menuStructure[menu].itemsArray).length - 1].classList.remove("item_selected");
                    var currentHTML = $("." + menu + " .item_selected").html();
                    $("." + menu + " .item_selected").html("<i class='fas fa-angle-double-right'></i> " + currentHTML);

                    var val1 = $("." + menu + " .item_selected").attr("class").split(" ")[0];
                    var val2 = $("." + menu + " .item_selected .item1").text();
                    var val3 = $("." + menu + " .item_selected .item2").text();
                    $.post("http://np-bennys/selectedItem", JSON.stringify({
                        id: val1,
                        item: val2,
                        item2: val3
                    }));
                }
            break;

            case "up":
                if(menuStructure[menu].selectedItem == 0)
                {
                    menuStructure[menu].selectedItem = Object.keys(menuStructure[menu].itemsArray).length - 1;

                    $("." + menu + " .item_selected").find("i").remove();
                    $("." + menu).empty();

                    for(var i = 0; i < Object.keys(menuStructure[menu].itemsArray).length; i++)
                    {
                        if(i > (menuStructure[menu].selectedItem - maxMenuItems) && i <= (maxMenuItems + (menuStructure[menu].selectedItem - maxMenuItems)))
                        {
                            $("." + menu).append(menuStructure[menu].itemsArray[i]);
                        }
                    }

                    menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
                    menuStructure[menu].itemsArray[0].classList.remove("item_selected");
                    var currentHTML = $("." + menu + " .item_selected").html();
                    $("." + menu + " .item_selected").html("<i class='fas fa-angle-double-right'></i> " + currentHTML);

                    var val1 = $("." + menu + " .item_selected").attr("class").split(" ")[0];
                    var val2 = $("." + menu + " .item_selected .item1").text();
                    var val3 = $("." + menu + " .item_selected .item2").text();
                    $.post("http://np-bennys/selectedItem", JSON.stringify({
                        id: val1,
                        item: val2,
                        item2: val3
                    }));
                }
                else if(menuStructure[menu].selectedItem < (maxMenuItems) && menuStructure[menu].selectedItem > 0)
                {
                    menuStructure[menu].selectedItem--;

                    menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
                    $("." + menu + " .item_selected").find("i").remove();

                    menuStructure[menu].itemsArray[menuStructure[menu].selectedItem + 1].classList.remove("item_selected");
                    var currentHTML = $("." + menu + " .item_selected").html();
                    $("." + menu + " .item_selected").html("<i class='fas fa-angle-double-right'></i> " + currentHTML);

                    var val1 = $("." + menu + " .item_selected").attr("class").split(" ")[0];
                    var val2 = $("." + menu + " .item_selected .item1").text();
                    var val3 = $("." + menu + " .item_selected .item2").text();
                    $.post("http://np-bennys/selectedItem", JSON.stringify({
                        id: val1,
                        item: val2,
                        item2: val3
                    }));
                }
                else if(menuStructure[menu].selectedItem > (maxMenuItems - 1))
                {
                    menuStructure[menu].selectedItem--;

                    menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
                    $("." + menu + " .item_selected").find("i").remove();

                    menuStructure[menu].itemsArray[menuStructure[menu].selectedItem + 1].classList.remove("item_selected");
                    var currentHTML = $("." + menu + " .item_selected").html();
                    $("." + menu + " .item_selected").html("<i class='fas fa-angle-double-right'></i> " + currentHTML);

                    menuStructure[menu].itemsArray[menuStructure[menu].selectedItem + 1].remove();

                    $("." + menu).prepend(menuStructure[menu].itemsArray[(menuStructure[menu].selectedItem - maxMenuItems) + 1]);

                    var val1 = $("." + menu + " .item_selected").attr("class").split(" ")[0];
                    var val2 = $("." + menu + " .item_selected .item1").text();
                    var val3 = $("." + menu + " .item_selected .item2").text();
                    $.post("http://np-bennys/selectedItem", JSON.stringify({
                        id: val1,
                        item: val2,
                        item2: val3
                    }));
                }
            break;
        }
    }

    function playSoundEffect(soundEffect, volume)
    {
        var audioPlayer = null;

        if(audioPlayer != null)
        {
            audioPlayer.pause();
        }

        audioPlayer = new Howl({src: ["./sounds/" + soundEffect + ".ogg"]});
        audioPlayer.volume(volume);
        audioPlayer.play();
    }

    window.addEventListener("message", function(event)
    {
        var eventData = event.data;

        if(eventData.toggleMenuContainer)
        {
            toggleMenuContainer(eventData.state);
        }

        if(eventData.createMenu)
        {
            createMenu(eventData.menu, eventData.heading, eventData.subheading);
        }

        if(eventData.destroyMenus)
        {
            destroyMenus();
        }

        if(eventData.populateMenu)
        {
            populateMenu(eventData.menu, eventData.id, eventData.item, eventData.item2);
        }

        if(eventData.finishPopulatingMenu)
        {
            finishPopulatingMenu(eventData.menu);
        }

        if(eventData.updateMenuHeading)
        {
            updateMenuHeading(eventData.menu);
        }

        if(eventData.updateMenuSubheading)
        {
            updateMenuSubheading(eventData.menu);
        }

        if(eventData.updateMenuStatus)
        {
            updateMenuStatus(eventData.statusText)
        }

        if(eventData.toggleMenu)
        {
            toggleMenu(eventData.state, eventData.menu);
        }

        if(eventData.updateItem2Text)
        {
            updateItem2Text(eventData.menu, eventData.id, eventData.item2)
        }

        if(eventData.updateItem2TextOnly)
        {
            updateItem2TextOnly(eventData.menu, eventData.id, eventData.item2)
        }

        if(eventData.scrollMenuFunctionality)
        {
            scrollMenuFunctionality(eventData.direction, eventData.menu);
        }

        if(eventData.playSoundEffect)
        {
            playSoundEffect(eventData.soundEffect, eventData.volume);
        }
    });
}