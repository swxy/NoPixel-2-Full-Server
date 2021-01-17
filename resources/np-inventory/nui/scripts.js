let dragging = false;
let draggingid = "none";
let mousedown = false;
let personalWeight = 0;
let secondaryWeight = 0;
let personalMaxWeight = 250;
let secondaryMaxWeight = 250;
let movementAmount = 0;
let currentInventory = 0;
let weight = 0;
let amount = 0;
let name = 0;
let itemid = 0;
let slotusing = 0;
let inventoryUsedName = "none";
let curGPSLength = 0
let cursorX = 0;
let cursorY = 0;
let purchase = false;
let crafting = false;
let clicking = false;
let userCash = 0;
let userWeaponLicense = true;
let itemList = {}
let exluded = {}
let brought = false;
let isCop = false;
let dateNow = Date.now()

exluded["2578778090"] = true
exluded["1737195953"] = true
exluded["1317494643"] = true
exluded["2508868239"] = true
exluded["1141786504"] = true
exluded["2227010557"] = true
exluded["883325847"] = true
exluded["4192643659"] = true
exluded["2460120199"] = true
exluded["3638508604"] = true
exluded["4191993645"] = true
exluded["3713923289"] = true
exluded["2343591895"] = true
exluded["2484171525"] = true
exluded["419712736"] = true
exluded["-1810795771"] = true
  let shiftHeld = false
  let CtrlHeld = false
$(document).ready(function () {

  document.onmousemove = handleMouseMove;


  document.onkeydown = function(data) {
      if (data.which == 16) {
          shiftHeld = true
      } else if (data.which == 17) {
          CtrlHeld = true
      }
  }
  document.onkeyup = function(data) {
      if (data.which == 73 || data.which == 27) {
          closeInv()
      } else if (data.which == 16) {
          shiftHeld = false
      } else if (data.which == 17) {
          CtrlHeld = false
      }
  }


  function handleMouseMove(event) {
    let dot, eventDoc, doc, body, pageX, pageY;
    event = event || window.event; // IE-ism
    // If pageX/Y aren't available and clientX/Y are,
    // calculate pageX/Y - logic taken from jQuery.
    // (This is to support old IE)
    if (event.pageX == null && event.clientX != null) {
      eventDoc = (event.target && event.target.ownerDocument) || document;
      doc = eventDoc.documentElement;
      body = eventDoc.body;

      event.pageX = event.clientX +
        (doc && doc.scrollLeft || body && body.scrollLeft || 0) -
        (doc && doc.clientLeft || body && body.clientLeft || 0);
      event.pageY = event.clientY +
        (doc && doc.scrollTop || body && body.scrollTop || 0) -
        (doc && doc.clientTop || body && body.clientTop || 0);
    }
    // Use event.pageX / event.pageY here

    if (dragging) {
      cursorX = event.pageX
      cursorY = event.pageY
      /* Move element with the mouse so it looks like we drag it.. */
      document.getElementById('draggedItem').style.left = '' + cursorX - 50 + 'px';
      document.getElementById('draggedItem').style.top = '' + cursorY - 50 + 'px';
    }
  }

  window.addEventListener('message', function (event) {
    let item = event.data;
    // Trigger adding a new message to the log and create its display
    if (item.response == "openGui") {
      dateNow = Date.now()
      $("#UseBar").fadeOut(100);
      document.getElementById('wrapmain').innerHTML = "";
      document.getElementById('wrapsecondary').innerHTML = "";
      $("#app").fadeIn();
      $('#move-amount').focus();
    } else if (item.response == "closeGui") {
      $("#app").fadeOut();
    } else if (item.response == "updateQuality") {
      UpdateQuality(item)
    } else if (item.response == "Populate") {
      DisplayInventoryMultiple(item.playerinventory, item.itemCount, item.invName, item.targetinventory, item.targetitemCount, item.targetinvName, item.cash, item.StoreOwner);
    } else if (item.response == "PopulateSingle") {
      PersonalWeight = 0
      DisplayInventory(item.playerinventory, item.itemCount, item.invName, true)
    } else if (item.response == "cashUpdate") {
      userCash = item.amount
      userWeaponLicense = true
      brought = item.brought
      isCop = item.cop;
    } else if (item.response == "DisableMouse") {
      clicking = false;
      EndDrag(slotusing);
      EndDrag(draggingid)
      dragging = false;
      draggingid = "none";
      document.getElementById('draggedItem').style.opacity = '0.0';
      document.getElementById('draggedItem').innerHTML = "";
    } else if (item.response == "EnableMouse") {
      clicking = true;
    } else if (item.response == "DisplayBar") {
      ToggleBar(item.toggle, item.boundItems, item.boundItemsAmmo)
    } else if (item.response == "UseBar") {
      UseBar(item.itemid, item.text, item.amount)
    } else if (item.response == "SendItemList") {
      itemList = item.list
    } else if (item.response == "GiveItemChecks") {
      if (itemList[item.id]) {
        $.post("http://np-inventory/GiveItem", JSON.stringify([item.id, item.amount, item.generateInformation, true, itemList[item.id].nonStack, item.data]));
      } else {
        $.post("http://np-inventory/GiveItem", JSON.stringify([item.id, item.amount, item.generateInformation, false, itemList[item.id].nonStack, item.data]));
      }
    }
  })

});



let usedBar = 0

function UpdateQuality(data,penis) {

    let inventory = data.inventory

    let divslot = 'secondaryslot' + data.slot
    if (inventory.indexOf("ply-") > -1) {
      divslot = 'playerslot' + data.slot
    }

    let item = document.getElementById(divslot).getElementsByTagName('img')[0];


    let weight = parseInt(item.dataset.weight);

    let name = item.dataset.name;
    let itemcount = parseInt(item.dataset.amount);
    let itemid = item.dataset.itemid
    let image = itemList[itemid].image;
    let inventoryNumber = parseInt(item.dataset.inventory)
    let info = JSON.parse(item.dataset.info)
    let creationDate = parseInt(item.dataset.creationDate)

    let quality = ConvertQuality(itemid,data.creationDate)

    if (quality == undefined) {
      quality = 100
    }

    if (penis != undefined) {
      quality = penis
    }

    if (quality < 0) {
      quality = 0
    }


    let itemMaxed = "class='itemQuality'"

    if (quality == 100) { itemMaxed = "class='perfect'" }

    let qualityText = quality
    let qualityWidth = quality

    if (quality == 0) {
      qualityText = "Destroyed"
      qualityWidth = 100
      itemMaxed = "class='destroyed"
    } else if (quality < 5) {
      qualityText = "Almost Destroyed"
      qualityWidth = 100
      itemMaxed = "class='destroyed"
    } else if (quality < 10) {
      qualityText = "Falling Apart"
      qualityWidth = 100
      itemMaxed = "class='destroyed"
    }

    info = JSON.stringify(info)

    let meta = item.dataset.metainformation
    let item_cost = item.dataset.fwewef
    let slot = item.dataset.currentslot

    let nonStack = true
    let inventoryName = inventory



    let htmlstring = "<div " + itemMaxed + " style='width:" + qualityWidth + "%'> " + qualityText + " </div>  <div class='itemname'> " + name + " </div> <div class='information'>  " + itemcount + " (" + weight + ".00) </div>          <img src='icons/" + image + "' data-info='" + info + "' data-inventory='" + inventoryNumber + "' data-quality='" + quality + "' data-name='" + name + "' data-metainformation='" + meta + "' data-itemid='" + itemid + "' data-fwewef='" + item_cost + "' data-inventory='" + inventoryNumber + "' data-currentslot='" + slot + "' data-stackable='" + nonStack + "' data-amount='" + itemcount + "' data-weight='" + weight + "' data-inventoryname='" + inventoryName + "' class='itemimage'>";

    document.getElementById(divslot).innerHTML = htmlstring;

}

function RandomGen(length) {
    var result = '';
    var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    var charactersLength = characters.length;
    for (var i = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

let fadeOut = 0


function UseBar(itemid, text, amount) {

    if (amount == undefined) { amount = 1 };

    let image = ""
    let name = ""
    let htmlstring = ""
    let id = RandomGen(10)
    fadeOut = id
    image = itemList[itemid].image;
    name = itemList[itemid].displayname;
    htmlstring = " <div class='item2' > <div class='UseBarHead'> " + text + " " + amount + "x  </div> <div class='itemname2'> " + name + " </div> <img src='icons/" + image + "' class='itemimage'>  </div>";

    var p = document.getElementById('UseBar');
    var newElement = document.createElement(id);
    newElement.setAttribute('id', id);
    newElement.innerHTML = htmlstring;
    p.prepend(newElement);

    $("#UseBar").fadeIn(1000);

    setTimeout(() => {
        $(newElement).fadeOut(500);
    }, 2500)

    setTimeout(() => {
        if (fadeOut == id) {
            $("#UseBar").fadeOut(350);
        }
        var element = document.getElementById(id);
        element.parentNode.removeChild(element);

    }, 3000)

}



function ToggleBar(toggle, boundItems, boundItemsAmmo) {
  if (toggle) {

    document.getElementById('ActionBar').innerHTML = "";

    let image = ""
    let name = ""
    let htmlstring = ""

    if (boundItems[1]) {
      image = itemList[boundItems[1]].image;
      name = itemList[boundItems[1]].displayname;

      if (boundItemsAmmo[1]) {
        name = name + " - (" + boundItemsAmmo[1] + ")"
      }

      htmlstring = "<div id='bind1'> 1 </div> <div class='item3' > <div class='itemname3'> " + name + " </div> <img src='icons/" + image + "' class='itemimage'>  </div>";
    } else {

      htmlstring = "<div id='bind1'> 1 </div> <div class='item3' > <div class='itemname3'> unbound </div> <img src='icons/empty.png' class='itemimage'>  </div>";
    }

    for (let i = 2; i < 5; i++) {

      if (boundItems[i]) {
        image = itemList[boundItems[i]].image;
        name = itemList[boundItems[i]].displayname;

        if (boundItemsAmmo[i]) {
          name = name + " - (" + boundItemsAmmo[i] + ")"
        }

        htmlstring = htmlstring + "<div id='bind" + i + "'> " + i + " </div><div class='item3' > <div class='itemname3'> " + name + " </div> <img src='icons/" + image + "' class='itemimage'>  </div>";
      } else {

        htmlstring = htmlstring + "<div id='bind" + i + "'> " + i + " </div><div class='item3' > <div class='itemname3'> unbound </div> <img src='icons/empty.png' class='itemimage'>  </div>";
      }

    }
    document.getElementById('ActionBar').innerHTML = htmlstring;

    $("#ActionBar").fadeIn(500);

  } else {
    $("#ActionBar").fadeOut(500);
  }
}

document.onkeyup = function (data) {
  if (data.which == 27) {
    closeInv()
  }
}

function invStack(targetSlot, moveAmount, targetInventory, originSlot, originInventory, purchase, itemCosts, itemidsent, amountmoving, crafting, weapon, amountRemaining) {
  let arr = [targetSlot, moveAmount, targetInventory, originSlot, originInventory, purchase, itemCosts, itemidsent, amountmoving, crafting, weapon, PlayerStore, amountRemaining];
  $.post("http://np-inventory/stack", JSON.stringify(arr));
};

function invMove(targetSlot, originSlot, targetInventory, originInventory, purchase, itemCosts, itemidsent, amountmoving, crafting, weapon) {
  let arr = [targetSlot, originSlot, targetInventory, originInventory, purchase, itemCosts, itemidsent, amountmoving, crafting, weapon, PlayerStore];
  $.post("http://np-inventory/move", JSON.stringify(arr));
};

function invSwap(targetSlot, targetInventory, originSlot, originInventory) {
  let arr = [targetSlot, targetInventory, originSlot, originInventory];
  $.post("http://np-inventory/swap", JSON.stringify(arr));
};

function removeCraftItems(itemid, moveAmount) {
  let arr = itemList[itemid].craft
  let amount = moveAmount;
  $.post("http://np-inventory/removeCraftItems", JSON.stringify([arr, amount]));
};

function CreateEmptyPersonalSlot(slotLimit) {
  for (i = 1; i < slotLimit + 1; i++) {

    let htmlstring = "<div id='playerslot" + i + "' class='item' > </div>"

    if (i == 1) {
      htmlstring = "<div id='playerslot" + i + "' class='item' > </div> <div id='bind1'> 1 </div> "
    } else if (i == 2) {
      htmlstring = "<div id='playerslot" + i + "' class='item' > </div> <div id='bind2'> 2 </div>  "
    } else if (i == 3) {
      htmlstring = "<div id='playerslot" + i + "' class='item' >  </div> <div id='bind3'> 3 </div> "
    } else if (i == 4) {
      htmlstring = "<div id='playerslot" + i + "' class='item' >  </div> <div id='bind4'> 4 </div> "
    }
    document.getElementById('wrapmain').innerHTML += htmlstring;
  }
}

function CreateEmptySecondarySlot(slotLimit) {
  let classColorName = "default";

  if (TargetInventoryName.indexOf("Glovebox") > -1) {
    classColorName = "lblue";
  } else if (TargetInventoryName.indexOf("Trunk") > -1) {
    classColorName = "lblue";
  } else if (TargetInventoryName.indexOf("hidden") > -1) {
    classColorName = "green";
  } else if (TargetInventoryName.indexOf("Drop") > -1) {
    classColorName = "red";
  }
  for (i = 1; i < slotLimit + 1; i++) {
    let htmlstring = "<div id='secondaryslot" + i + "' class='item " + classColorName + "' > </div>";
    document.getElementById('wrapsecondary').innerHTML += htmlstring;
  }
}

function isEmpty(obj) {
  for (let key in obj) {
    if (obj.hasOwnProperty(key))
      return false;
  }
  return true;
}

function InventoryLog(string) {
  document.getElementById('Logs').innerHTML = string + "<br>" + document.getElementById('Logs').innerHTML;
}

let PlayerInventoryName = "none";
let TargetInventoryName = "none";
let shop = "Shop";
let craft = "Craft";
let slotLimitTarget = 500000000000000;
let MyInventory = {}
let MyItemCount = 0
let StoreOwner = false
let PlayerStore = false
// weights are done here, based on the string of the inventory name
function DisplayInventoryMultiple(playerinventory, itemCount, invName, targetinventory, targetitemCount, targetinvName, cash, Owner) {
  secondaryWeight = 0
  StoreOwner = Owner
  PlayerStore = false
  userCash = parseInt(cash);
  DisplayInventory(playerinventory, itemCount, invName, true)
  MyInventory = playerinventory
  MyItemCount = itemCount

  if (targetinvName.indexOf("Drop") > -1) {
    secondaryMaxWeight = 1000.0
    slotLimitTarget = 30;
  } else if (targetinvName.indexOf("PlayerStore") > -1) {
    secondaryMaxWeight = 1000.0
    slotLimitTarget = 2;
    PlayerStore = true;
  } else if (targetinvName.indexOf("storage") > -1) {
    secondaryMaxWeight = 2000.0
    slotLimitTarget = 200;
  } else if (targetinvName.indexOf("securewarehouse1") > -1) {
    secondaryMaxWeight = 2500.0
    slotLimitTarget = 100;
  } else if (targetinvName.indexOf("securewarehouse2") > -1) {
    secondaryMaxWeight = 3500.0
    slotLimitTarget = 100;
  } else if (targetinvName.indexOf("house") > -1) {
    secondaryMaxWeight = 700.0
    slotLimitTarget = 70;
  } else if (targetinvName.indexOf("motel1") > -1) {
    secondaryMaxWeight = 300.0
    slotLimitTarget = 30;
  } else if (targetinvName.indexOf("motel2") > -1) {
    secondaryMaxWeight = 600.0
    slotLimitTarget = 50;
  } else if (targetinvName.indexOf("motel3") > -1) {
    secondaryMaxWeight = 900.0
    slotLimitTarget = 90;
  } else if (targetinvName.indexOf("Glovebox") > -1) {
    secondaryMaxWeight = 50.0
    slotLimitTarget = 5;
  } else if (targetinvName.indexOf("Trunk") > -1) {
    secondaryMaxWeight = 650.0
    slotLimitTarget = 65;
  } else if (targetinvName.indexOf("Craft") > -1) {
    slotLimitTarget = 50;
  } else if (targetinvName.indexOf("hidden") > -1) {
    secondaryMaxWeight = 2000.0
    slotLimitTarget = 200;
  } else if (targetinvName.indexOf("evidence") > -1) {
    secondaryMaxWeight = 4000.0
    slotLimitTarget = 400;
  } else if (targetinvName.indexOf("Case") > -1) {
    secondaryMaxWeight = 4000.0
    slotLimitTarget = 400;    
  } else if (targetinvName.indexOf("docks") > -1) {
    secondaryMaxWeight = 20000.0
    slotLimitTarget = 2000;
  } else if (targetinvName.indexOf("trash") > -1) {
    secondaryMaxWeight = 4000.0
    slotLimitTarget = 400;
  } else if (targetinvName.indexOf("personal") > -1) {
    secondaryMaxWeight = 250.0
    slotLimitTarget = 5;
  } else {
    secondaryMaxWeight = 250.0
    slotLimitTarget = 40;
  }

  InventoryLog(targetinvName + " | " + invName)
  DisplayInventory(targetinventory, targetitemCount, targetinvName, false)

}

function BuildDrop(brokenSlots) {
  $.post("http://np-inventory/dropIncorrectItems", JSON.stringify({
    slots: brokenSlots
  }));
}

// THIS IS A SHIT COPY PASTE JUST TIO UPDATE BECAUSE I COULDNT BE BOTHERED ADDING A VARIABLE TO LIKE 2 EVENTS :)

// NOPIXEL BTW

function produceInfo(data) {
  let string = ""
  let info = JSON.parse(data.replace(/"{/g, `{`).replace(/}"/g, `}`))

  for (let [key, value] of Object.entries(info)) {
    if (typeof value != 'object') {
      string = string + key + ": " + value + " | "
    }
  }

  return string.replace(/[ | ](?=[^|]*$)/, '');
}

function DisplayInventory(sqlInventory, itemCount, invName, main) {

  clicking = false
  sqlInventory = JSON.parse(sqlInventory)
  let maxWeight = 250
  let slotLimit = 40

  let inventory = {}
  itemCount = parseInt(itemCount);
  //document.getElementById('wrapsecondary').innerHTML += sqlInventory[1].name;
  // this shows inventory name

  if (main) {
    personalWeight = 0
    PlayerInventoryName = invName;
    CreateEmptyPersonalSlot(slotLimit)
  } else {
    TargetInventoryName = invName;
    CreateEmptySecondarySlot(slotLimitTarget)
    slotLimit = slotLimitTarget
  }
  let slot = 0;

  InventoryLog(invName + " is Loading.")

  let inventoryNumber = 1;

  if (!main) {
    inventoryNumber = 2;
  }

  let failure = false;
  let fixSlots = {};
  for (let i = 0; i < itemCount; i++) {
    slot = sqlInventory[i].slot
    if (isEmpty(inventory[slot])) {
      // do something 

      inventory[slot] = {}
      inventory[slot].slot = slot
      inventory[slot].itemid = sqlInventory[i].item_id
      inventory[slot].itemcount = sqlInventory[i].amount
      inventory[slot].inventoryName = sqlInventory[i].name
      inventory[slot].information = sqlInventory[i].information
      inventory[slot].creationDate = sqlInventory[i].creationDate
      inventory[slot].quality = sqlInventory[i].quality



    } else {
      if (sqlInventory[i].item_id != inventory[slot].itemid) {
        if (!fixSlots[invName])
          fixSlots[invName] = []
        failure = true
        fixSlots[invName].push({
          faultySlot: slot,
          faultyItem: sqlInventory[i].item_id
        });

      } else {
        inventory[slot].itemcount = inventory[slot].itemcount + 1
      }
    }
  }

  if (failure) {
    BuildDrop(fixSlots)
    closeInv()
  }

  let inventoryName = invName

  if (itemCount != 0) {
    inventoryName = " Error grabbing item names."
  }

  for (i = 0; i < slotLimit + 1; i++) {

    if (isEmpty(inventory[i])) {

    } else {

      let slot = inventory[i].slot;

      let itemid = "" + inventory[i].itemid + "";
      if (itemList[itemid] !== undefined) {

        let itemcount = inventory[i].itemcount;

        inventoryName = inventory[slot].inventoryName


        let weight = itemList[itemid].weight;
        let item_cost = itemList[itemid].price;

        let nonStack = itemList[itemid].nonStack;
        let image = itemList[itemid].image;

        let name = itemList[itemid].displayname;

        let meta = inventory[i].information;
        let creationDate = inventory[i].creationDate;

        let info = meta;

        if (meta == undefined) {
          meta = ""
        }      

        let quality = inventory[i].quality

        if (itemList[itemid].information) {
          meta = meta + "<br>" + itemList[itemid].information

          if (itemList[itemid].craft !== undefined && !main && invName.indexOf("Craft") > -1) {

            let requirements = itemList[itemid].craft;

            for (let xx = 0; xx < requirements.length; xx++) {
              meta = meta + "<br>" + itemList[requirements[xx].itemid].displayname + ": " + requirements[xx].amount
            }
          }
        } else {

          if (itemList[itemid].craft !== undefined && !main && invName.indexOf("Craft") > -1) {

            let requirements = itemList[itemid].craft;

            for (let xx = 0; xx < requirements.length; xx++) {
              meta = meta + "<br>" + itemList[requirements[xx].itemid].displayname + ": " + requirements[xx].amount
            }
          }
        }

        let stackString = "(nS)"
        if (nonStack) {
          nonStack = 1
        } else {
          nonStack = 0
          stackString = "(S)"
        }

        if (quality == undefined) { quality = 100 }

        let qualityText = quality
        let qualityWidth = quality

        let itemMaxed = "class='itemQuality'"
        
        if (quality > 98) { 
          qualityText = "Perfect"
        }

        if (quality == 0) {
          qualityText = "Destroyed"
          qualityWidth = 100
          itemMaxed = "class='destroyed"
        } else if (quality < 5) {
          qualityText = "Almost Destroyed"
          qualityWidth = 100
          itemMaxed = "class='destroyed"
        } else if (quality < 10) {
          qualityText = "Falling Apart"
          qualityWidth = 100
          itemMaxed = "class='destroyed"
        }

        let htmlstring = "<div " + itemMaxed + " style='width:" + qualityWidth + "%'> " + qualityText + " </div> <div class='itemname'> " + name + " </div> <div class='information'>  " + itemcount + " (" + weight + ".00) </div>          <img src='icons/" + image + "' data-inventory='" + inventoryNumber + "' data-quality='" + quality + "' data-creationDate='" + creationDate + "' data-name='" + name + "' data-info='" + info + "' data-metainformation='" + meta + "' data-itemid='" + itemid + "' data-fwewef='" + item_cost + "' data-inventory='1' data-currentslot='" + slot + "' data-stackable='" + nonStack + "' data-amount='" + itemcount + "' data-weight='" + weight + "' data-inventoryname='" + inventoryName + "' class='itemimage'>";

        if (TargetInventoryName == "Shop" && main === false) {
          if (sqlInventory[i - 1].amount === undefined) {
            itemcount = 10
          } else {
            itemcount = sqlInventory[i - 1].amount
          }
          htmlstring = "<div class='itemQuality' " + itemMaxed + " style='width:" + qualityWidth + "%'> " + qualityText + " </div> <div class='itemname'> " + name + " - $" + item_cost + " </div> <div class='information'>  " + itemcount + " (" + weight + ".00) </div>          <img src='icons/" + image + "' data-inventory='" + inventoryNumber + "' data-creationDate='" + creationDate + "' data-quality='" + quality + "' data-name='" + name + "' data-info='" + info + "' data-metainformation='" + meta + "' data-fwewef='" + item_cost + "' data-itemid='" + itemid + "' data-inventory='2' data-currentslot='" + slot + "' data-stackable='" + nonStack + "' data-amount='" + itemcount + "' data-weight='" + weight + "' data-inventoryname='" + inventoryName + "' class='itemimage'>";
        }

        if ((!StoreOwner && PlayerStore && main === false)) {
          htmlstring = "<div class='itemQuality' " + itemMaxed + " style='width:" + qualityWidth + "%'> " + qualityText + " </div> <div class='itemname'> " + name + " - $" + item_cost + " </div> <div class='information'>  " + itemcount + " (" + weight + ".00) </div>          <img src='icons/" + image + "' data-inventory='" + inventoryNumber + "' data-creationDate='" + creationDate + "' data-quality='" + quality + "' data-name='" + name + "' data-info='" + info + "' data-metainformation='" + meta + "' data-fwewef='" + item_cost + "' data-itemid='" + itemid + "' data-inventory='2' data-currentslot='" + slot + "' data-stackable='" + nonStack + "' data-amount='" + itemcount + "' data-weight='" + weight + "' data-inventoryname='" + inventoryName + "' class='itemimage'>";
        }

        if (TargetInventoryName == "Craft" && main === false) {
          if (sqlInventory[i - 1].amount === undefined) {
            itemcount = 1
          } else {
            itemcount = sqlInventory[i - 1].amount
          }
          htmlstring = "<div class='itemQuality' " + itemMaxed + " style='width:" + qualityWidth + "%'> " + qualityText + " </div> <div class='itemname'> " + name + " </div> <div class='information'>  " + itemcount + " (" + weight + ".00) </div>          <img src='icons/" + image + "' data-inventory='" + inventoryNumber + "' data-creationDate='" + creationDate + "' data-quality='" + quality + "' data-name='" + name + "' data-info='" + info + "' data-metainformation='" + meta + "' data-fwewef='" + item_cost + "' data-itemid='" + itemid + "' data-inventory='2' data-currentslot='" + slot + "' data-stackable='" + nonStack + "' data-amount='" + itemcount + "' data-weight='" + weight + "' data-inventoryname='" + inventoryName + "' class='itemimage'>";
        }

        if (main) {
          document.getElementById('playerslot' + slot).innerHTML = htmlstring;

          personalWeight = personalWeight + (weight * itemcount)


        } else {
          if (slot != 0) {
            document.getElementById('secondaryslot' + slot).innerHTML = htmlstring;

            secondaryWeight = secondaryWeight + (weight * itemcount)
          }

        }
      }

    }

  }

  InventoryLog("Loaded " + inventoryName + " without recorded Error.")
  UpdateSetWeights()
  clicking = true
}


const TimeAllowed = 1000 * 60 * 40320; // 28 days, 

function ConvertQuality(itemID,creationDate) {
    let StartDate = new Date(creationDate).getTime()
    let DecayRate = itemList[itemID].decayrate
    let TimeExtra = (TimeAllowed * DecayRate)
    let percentDone = 100 - Math.ceil((((dateNow - StartDate) / TimeExtra) * 100))

    if (DecayRate == 0.0) { percentDone = 100 }
    if (percentDone < 0) { percentDone = 0 }
    return percentDone
}





function UpdateSetWeights() {
  document.getElementById('wrapPersonalWeight').innerHTML = "<h2>" + PlayerInventoryName + " </h2> Weight: " + personalWeight.toFixed(2) + " / " + personalMaxWeight.toFixed(2);
  document.getElementById('wrapSecondaryWeight').innerHTML = "<h2>" + TargetInventoryName + " </h2> Weight: " + secondaryWeight.toFixed(2) + " / " + secondaryMaxWeight.toFixed(2);

  let meh = personalWeight.toFixed(2)
  $.post("http://np-inventory/Weight", JSON.stringify({
    weight: meh
  }));
}

document.onmousedown = function (eventHandler, mEvent) {
  let x = event.clientX,
    y = event.clientY,
    element = document.elementFromPoint(x, y);

  if (element.id === "CurrentInformation" || element.id === "Logs" || element.id === "wrapPersonalWeight" || element.id === "wrapSecondaryWeight" || element.id === "wrapmain" || element.id === "wrapsecondary") {
    return;
  }

  if (element.id === "CloseInv") {
    closeInv()
    return;
  } else if (element.id === "Use") {
    useitem();
  } else if (element.id === "Drop") {
    if (draggingid != "none") {
      AttemptDropInEmptySlot(draggingid, true);
    }
  }

  let isImg = (element.nodeName.toLowerCase() === 'img');

  if (isImg == true) {
    element = element.parentNode.id;
    DisplayInformation(element);

    if (eventHandler.which === 2) {
        DragToggle(element,true);
        useitem();
        return
    } else {
        DragToggle(element,false);
    }



  } else {
    DragToggle(element.id,false);
  }
}

document.onmouseover = function (e) {
  element = e.target;

  let isImg = (element.nodeName.toLowerCase() === 'img');

  if (isImg == true && !dragging) {
    element = element.parentNode.id;
    DisplayInformation(element);
    document.getElementById('CurrentInformation').style.opacity = '1';
  } else {

    if (!dragging) {
      document.getElementById('CurrentInformation').style.opacity = '0';
    }

  }
};

function DragToggle(slot,using) {
  if (!clicking) {
    return;
  }

  let moveAmount = parseInt(document.getElementById("move-amount").value);

  if (!moveAmount) {
    if (TargetInventoryName == "Shop" || TargetInventoryName == "Craft" || PlayerStore) {
      document.getElementById("move-amount").value = 1;
      moveAmount = 1;
    } else {
      document.getElementById("move-amount").value = 0;
      moveAmount = 0;
    }
  }


  if (slot) {
    /* draggingid = Current dragged element(if dragging), slot = what we are attempting to drop in or pick up from */
    /* Here we confirm that the image exists that holds the information for the item(s). */
    let c = document.getElementById(slot).children.length;

    let occupiedslot = false;
    if (c > 0) {
      /* Here we declare if there is already an item in the slot we are dragging too by checking if there is an existing child node. */
      occupiedslot = true;
    }
    if (occupiedslot == true && dragging == false) {
      /* We are declaring that we just clicked our mouse button and are dragging a new object here. */



      dragging = true;
      draggingid = slot;

      $.post("http://np-inventory/SlotInuse", JSON.stringify(parseInt(draggingid.replace(/\D/g, ''))));

      startCSSDrag();
      if (shiftHeld == true && !using) {
          FindEmptySlotAndMove(true)
      } else if (CtrlHeld == true && !using) {
          FindEmptySlotAndMove(false)
      }



    } else if (occupiedslot == true && dragging == true && !using) {
      /* Here we are trying to drop an item in an already filled slot, so, we swap the item current. */
      /* We will need to do a check to see if the item is the same, if its stackable and if so, we stack the item on top of the current stack and do not replace.. */
      AttemptDropInFilledSlot(slot);
    } else if (occupiedslot == false && dragging == true && !using) {
      $.post("http://np-inventory/SlotInuse", JSON.stringify(parseInt(draggingid.replace(/\D/g, ''))));
      /* Here we are droping an item to an open slot - I guess we should check waits etc to confirm this is allowed before doing so. */
      AttemptDropInEmptySlot(slot, false);
    } else if (occupiedslot == false && dragging == false && !using) {
      /* I guess we reset here?. */
      dragging = false;
      draggingid = "none";
    }
  }
}


function FindEmptySlotAndMove(half) {
    let clickedInventory = document.getElementById(draggingid).parentElement.className;;
    let moveToSlotName = "playerslot";
    let slotCounter = 40
    if (clickedInventory == "wrapmain") {
        moveToSlotName = "secondaryslot";
        slotCounter = slotLimitTarget
    }

    for (let i = 1; i < slotCounter; i++) {
        let foundSlot = moveToSlotName + i
        let c = document.getElementById(foundSlot).children.length;
        if (c == 0) {
            $.post("http://np-inventory/SlotInuse", JSON.stringify(parseInt(draggingid.replace(/\D/g, ''))));
            AttemptDropInEmptySlot(foundSlot, false, half);
            return
            // EndDragging(foundSlot)
        }
    }
    //EndDragging(draggingid)
}




function startCSSDrag() {
  let draggedItemHtml = document.getElementById(draggingid).innerHTML;
  document.getElementById('draggedItem').innerHTML = draggedItemHtml;
  document.getElementById('draggedItem').style.left = 'cursorX-50';
  document.getElementById('draggedItem').style.top = 'cursorY-50';
  document.getElementById('draggedItem').style.opacity = '0.5';
  //document.getElementById('draggedItem').fadeIn(200); 
}


function searchUpdate() {
  let searchInput = $("#search-text").val();
  $(".wrapmain").find("div[class*='itemname']").each(function (i, el) {

    let parent = el.parentElement.id;

    document.getElementById(parent).style.backgroundColor = 'rgba(40,20,40,0.1)';

    curGPSLength = searchInput.length
    let dataSearched = el.innerHTML;
    let reg = new RegExp('(.*)' + searchInput + '(.*)', 'ig');

    if (reg.test(dataSearched) && searchInput != "") {
      document.getElementById(parent).style.backgroundColor = 'rgba(40,110,40,0.5)';
    }

  });
  // this will need converting to search proper.
  searchInput = document.getElementById("search-text").value;
  $(".wrapsecondary").find("div[class*='itemname']").each(function (i, el) {

    let parent = el.parentElement.id;
    $("#" + parent).css('background-color', 'rgba(40,20,40,0.1)');
    curGPSLength = searchInput.length
    let dataSearched = el.innerHTML;
    let reg = new RegExp('(.*)' + searchInput + '(.*)', 'ig');

    if (reg.test(dataSearched) && searchInput != "") {
      $("#" + parent).css('background-color', 'rgba(40,110,40,0.5)');
    }

  });

}

function ErrorCheck(startingInventory, inventoryDropName, movementWeight) {

  let sameInventory = true;
  let ErrorReason = "Success"

  if (inventoryDropName == "wrapsecondary" && startingInventory == 1) {
    sameInventory = false;
    //InventoryLog("We are moving an item from Player to Secondary")
  } else if (inventoryDropName == "wrapmain" && startingInventory == 2) {
    sameInventory = false;
    //InventoryLog("We are moving an item from Secondary to Primary")
  }

  if (sameInventory == true) {
    if (startingInventory == 1) {
      // InventoryLog("We are moving stuff in our personal inventory.")
    } else {
      // InventoryLog("We are moving stuff in our secondary inventory.")
    }
  } else {
    // logging the weight changes.

    if (startingInventory == 1) {
      if (movementWeight + secondaryWeight > secondaryMaxWeight) {
        ErrorReason = "Your target weight is too much.";
      }
    } else {
      if (movementWeight + personalWeight > personalMaxWeight) {
        ErrorReason = "The personal weight is too much.";
      }
    }
  }
  return ErrorReason
}

function UpdateTextInformation(slot) {
  if (document.getElementById(slot)) {
    let item = document.getElementById(slot).getElementsByTagName('img')[0];
    if (item) {
      let informationDiv = document.getElementById(slot).getElementsByTagName('div')[2];
      let weight = parseInt(item.dataset.weight);
      let amount = parseInt(item.dataset.amount);
      let stackable = parseInt(item.dataset.stackable);
      if (parseInt(stackable) == 0) {
        stackable = "(S)"
      } else {
        stackable = "(nS)"
      }
      informationDiv.innerHTML = amount + " (" + weight + ".00)";
      // "..itemcount.."x ("..weight..") " .. stackString .. "
    }
  }
}

function DropItem(slot, amountDropped) {
  let item = document.getElementById(slot).getElementsByTagName('img')[0];
  currentInventory = item.dataset.inventory;
  weight = item.dataset.weight;
  amount = item.dataset.amount;

  name = item.dataset.name;
  itemid = item.dataset.itemid;
  inventoryUsedName = item.dataset.inventoryname;
  slotusing = item.dataset.currentslot;

  let inventoryUsedNameText = "Secondary Inventory"
  if (currentInventory == 1) {
    inventoryUsedNameText = "Player Inventory"
  }

  InventoryLog("Dropped: " + name + " x(" + amountDropped + ") from slot " + slotusing + " of " + inventoryUsedNameText)

  // $.post('http://np-inventory/dropitem', JSON.stringify({
  //  currentInventory: currentInventory,
  //  weight: weight,
  //  amount: amount,
  //  name: name,
  //  itemid: itemid,
  //  inventoryUsedName: item.dataset.inventoryname,
  //  slotusing: slotusing,
  //  amountDropped: amountDropped,
  // }));

}

function ErrorMove() {
  // $.post('http://np-inventory/move:fail', JSON.stringify({}));
}

function SuccessMove() {
  // $.post('http://np-inventory/move:success', JSON.stringify({}));
}

// we are splitting items from inv2,slot2,amount2 over to inv1,slot1,amount1
// if amount2 is zero, we moved the entire stack.

function CompileStacks(targetSlot, originSlot, inv1, inv2, originAmount, remainingAmount, targetAmount, purchase, itemCosts, itemidsent, moveAmount) {
  let penis = false
  if (TargetInventoryName == PlayerInventoryName) {
    penis = true;
  }

  $.post("http://np-inventory/SlotJustUsed", JSON.stringify({
    targetslot: targetSlot,
    origin: originSlot,
    itemid: itemidsent,
    move: false,
    MyInvMove: penis
  }));

  if (inv2 == "wrapmain") {
    originInventory = PlayerInventoryName
  } else {
    originInventory = TargetInventoryName
  }

  if (inv1 == "wrapmain") {
    targetInventory = PlayerInventoryName
  } else {
    targetInventory = TargetInventoryName
  }

  var isWeapon = false
  if (itemList[itemidsent].weapon != null && !exluded[itemidsent] && !isCop) {
    brought = true
    isWeapon = itemList[itemidsent].weapon
  }

  invStack(targetSlot, moveAmount, targetInventory, originSlot, originInventory, purchase, itemCosts, itemidsent, moveAmount, crafting, isWeapon, remainingAmount);

  InventoryLog("Changed Slot: " + targetSlot + "(" + targetAmount + ") of " + inv2 + " to " + originSlot + "(" + originAmount + ") of " + inv1 + " ")
  UpdateSetWeights()
  if (crafting) {
    removeCraftItems(itemidsent, moveAmount)
    closeInv()
  }
}

function MoveStack(targetSlot, originSlot, inv1, inv2, purchase, itemCosts, itemidsent, moveAmount) {
  let myInv = false
  if (TargetInventoryName == PlayerInventoryName) {
    myInv = true;
  }

  $.post("http://np-inventory/SlotJustUsed", JSON.stringify({
    targetslot: targetSlot,
    origin: originSlot,
    itemid: itemidsent,
    move: true,
    MyInvMove: myInv
  }));

  if (inv2 == "wrapmain") {
    originInventory = PlayerInventoryName
  } else {
    originInventory = TargetInventoryName
  }

  if (inv1 == "wrapmain") {
    targetInventory = PlayerInventoryName
  } else {
    targetInventory = TargetInventoryName
  }

  var isWeapon = false
  if (itemList[itemidsent].weapon != null && !exluded[itemidsent] && !isCop) {
    brought = true
    isWeapon = itemList[itemidsent].weapon
  }

  invMove(targetSlot, originSlot, targetInventory, originInventory, purchase, itemCosts, itemidsent, moveAmount, crafting, isWeapon);
  InventoryLog("Moved Slot " + targetSlot + " of " + targetInventory + " to " + originSlot + " of " + originInventory + " #" + itemidsent)
  UpdateSetWeights()
  if (crafting) {
    removeCraftItems(itemidsent, moveAmount)
    closeInv()
  }
}

// slot2 is the object being moved originally, slot 1 is the item it is replacing with.
function SwapStacks(targetSlot, originSlot, inv1, inv2) {
  // $.post('http://np-inventory/swapstack', JSON.stringify({
  //   slot1: slot1,
  //   slot2: slot2,
  //   inv1: inv1,
  //   inv2: inv2,
  // }));

  let penis = false
  if (TargetInventoryName == PlayerInventoryName) {
    penis = true;
  }

  RequestItemData()
  $.post("http://np-inventory/SlotJustUsed", JSON.stringify({
    targetslot: targetSlot,
    origin: originSlot,
    itemid: itemid,
    move: false,
    MyInvMove: penis
  }));

  if (inv2 == "wrapmain") {
    originInventory = PlayerInventoryName
  } else {
    originInventory = TargetInventoryName
  }

  if (inv1 == "wrapmain") {
    targetInventory = PlayerInventoryName
  } else {
    targetInventory = TargetInventoryName
  }

  invSwap(targetSlot, targetInventory, originSlot, originInventory);

  InventoryLog("Swapped Slot " + targetSlot + " of " + targetInventory + " and " + originSlot + " of " + originInventory + " ")
  UpdateSetWeights()
}

function closeInv(pIsItemUsed = false) {
  personalWeight = 0;
  secondaryWeight = 0;

  $.post("http://np-inventory/ServerCloseInventory", JSON.stringify({
    name: TargetInventoryName
  }));
  TargetInventoryName = "none";
  $.post("http://np-inventory/Close", JSON.stringify({
    isItemUsed: pIsItemUsed
  }));
}

function CountItems(ItemIdToCheck) {
  let sqlInventory = JSON.parse(MyInventory);
  let amount = 0
  for (let i = 0; i < parseInt(MyItemCount); i++) {
    if (sqlInventory[i].item_id == ItemIdToCheck) {
      amount = amount + sqlInventory[i].amount
    }
  }
  return amount;
}

//itemid, amount, return

function CheckCraftFail(itemid, moveAmount) {
  let requirements = itemList[itemid].craft;

  let itemcheck = false;

  for (let i = 0; i < requirements.length; i++) {

    let requiredAmount = Math.ceil(moveAmount * requirements[i]["amount"])
    let itemNeededId = requirements[i]["itemid"]
    let countedItems = CountItems(itemNeededId)

    if (countedItems < requiredAmount) {
      itemcheck = true
    }

  }

  InventoryLog("We should add " + moveAmount + " of " + itemid)
  return itemcheck;
}

function AttemptDropInFilledSlot(slot) {

  let moveAmount = document.getElementById("move-amount").value;
  if (draggingid == slot) {
    EndDragError(slot);
    return
  }

  let item = document.getElementById(draggingid).getElementsByTagName('img')[0];
  if (item == undefined) {
    EndDragError(slot);
    return
  }
  let itemReturnItem = document.getElementById(slot).getElementsByTagName('img')[0];
  let itemidsent = item.dataset.itemid;

  let currentInventory = parseInt(item.dataset.inventory);
  let weight = parseInt(item.dataset.weight);
  let amount = parseInt(item.dataset.amount);
  let name = item.dataset.name;
  let itemid1 = item.dataset.itemid;
  let stackable = parseInt(item.dataset.stackable);

  let itemid2 = itemReturnItem.dataset.itemid;
  let returnItemInventory = itemReturnItem.dataset.inventory;
  let weightReturnItem = parseInt(itemReturnItem.dataset.weight);
  let amountReturnItem = parseInt(itemReturnItem.dataset.amount);
  let nameReturnItem = itemReturnItem.dataset.name;
  let inventoryDropName = document.getElementById(slot).parentElement.className;
  let inventoryReturnItemDropName = document.getElementById(draggingid).parentElement.className;

  let sameinventory = true;
  purchase = false;
  crafting = false;
  let movementWeight = weight * amount;
  let movementReturnItemWeight = weightReturnItem * amountReturnItem;

  let stacking = false;
  let fullstack = false;

  if (itemid1 == itemid2 && !stackable) {
    // here we are set to 0, which means the number for movement hasnt been changed so we default to try and move the entire stack over.
    if (moveAmount == 0) {
      fullstack = true;
      moveAmount = amount;
    }
    movementWeight = weight * moveAmount;
    movementReturnItemWeight = weightReturnItem * moveAmount;
    stacking = true;
  }

  let result = ErrorCheck(currentInventory, inventoryDropName, movementWeight)
  if (stacking == false) {
    // If the item is being stacked, we do not calculate the return weight here as no item will be returned to the starting inventory.
    result2 = ErrorCheck(returnItemInventory, inventoryReturnItemDropName, movementReturnItemWeight)
  } else {
    // the item was stacked so its automatically successful for return item weight.
    result2 = "Success"
  }

  if (stacking && moveAmount > amount) {
    document.getElementById("move-amount").value = 0;
    result2 = "Warning"
    result = "You do not have that amount!"
  }

  if (inventoryDropName == "wrapsecondary" && TargetInventoryName == "Shop" || (!StoreOwner && PlayerStore && inventoryDropName == "wrapsecondary")) {
    result = "You can not drop items into the shop!";

  }
  if (TargetInventoryName == "Craft") {
    result = "You can not drop items into the craft table or stack items that are crafted!";

  }

  if (result == "Success" && result2 == "Success") {

    // Here we are moving from player inventory to the secondary inventory
    if (currentInventory == 1 && inventoryDropName == "wrapsecondary") {

      item.dataset.inventory = 2;
      itemReturnItem.dataset.inventory = 1;
      if (stacking) {
        personalWeight = personalWeight - movementWeight
        secondaryWeight = secondaryWeight + movementWeight
      } else {
        personalWeight = personalWeight + movementReturnItemWeight - movementWeight
        secondaryWeight = secondaryWeight + movementWeight - movementReturnItemWeight
      }
    }

    // Here we are moving from secondary inventory to the player inventory.
    if (currentInventory == 2 && inventoryDropName == "wrapmain") {

      item.dataset.inventory = 1;
      itemReturnItem.dataset.inventory = 2;
      if (stacking) {
        personalWeight = personalWeight + movementWeight
        secondaryWeight = secondaryWeight - movementWeight
      } else {
        personalWeight = personalWeight + movementWeight - movementReturnItemWeight
        secondaryWeight = secondaryWeight + movementReturnItemWeight - movementWeight
      }
    }

    if (stacking == true) {

      if (inventoryDropName == "wrapmain") {
        itemReturnItem.dataset.inventory = 1;
      } else {
        itemReturnItem.dataset.inventory = 2;
      }

      if (currentInventory == 1) {
        item.dataset.inventory = 1;
      } else {
        item.dataset.inventory = 2;
      }

      let purchaseCost = parseInt(item.dataset.fwewef) * parseInt(moveAmount);

      if (TargetInventoryName == "Shop" || (!StoreOwner && PlayerStore)) {
        InventoryLog("eh: PURCHASE")
        if (purchaseCost > userCash) {
          result = "You cant afford this.!";
          result2 = "You cant afford this.!";
          InventoryLog("Error: " + result)
          EndDragError(slot);
          return
        } else {
          if (itemList[itemidsent].weapon) {
            if (!exluded[itemidsent] && !userWeaponLicense) {
              result = "You do not have a license.!";
              result2 = "You do not have a license.!";
              InventoryLog("Error: " + result)
              EndDragError(slot);
              return
            }

            if (!exluded[itemidsent] && brought && !isCop) {
              result = "You can only buy one gun a day!";
              InventoryLog("Error: " + result)
              EndDragError(slot);
              return
            }
          }

          if (currentInventory == 2 && inventoryDropName == "wrapmain") {
            userCash = userCash - purchaseCost;
            InventoryLog("Purchase Cost: $" + purchaseCost + " you have $" + userCash + " left.")
            purchase = true;
          }
        }
      }

      InventoryLog(item.dataset.fwewef + " | " + purchaseCost + " | " + moveAmount);

      let newAmount = parseInt(amountReturnItem) + parseInt(moveAmount);
      itemReturnItem.dataset.amount = newAmount;
      item.dataset.currentslot = parseInt(slot.replace(/\D/g, ''));
      itemReturnItem.dataset.currentslot = parseInt(draggingid.replace(/\D/g, ''));


      if (fullstack == false) {
        let newAmount2 = parseInt(amount) - parseInt(moveAmount);
        item.dataset.amount = newAmount2;

        if (newAmount2 == 0) {
          document.getElementById(draggingid).innerHTML = "";
        }      

        CompileStacks(parseInt(slot.replace(/\D/g, '')), parseInt(draggingid.replace(/\D/g, '')), inventoryDropName, inventoryReturnItemDropName, newAmount, newAmount2, moveAmount, purchase, purchaseCost, itemidsent, moveAmount)
      } else {

        document.getElementById(draggingid).innerHTML = "";
       
        CompileStacks(parseInt(slot.replace(/\D/g, '')), parseInt(draggingid.replace(/\D/g, '')), inventoryDropName, inventoryReturnItemDropName, newAmount, 0, moveAmount, purchase, purchaseCost, itemidsent, moveAmount)
      }

      let data = {}
      let targetQuality = itemReturnItem.dataset.quality
      let startQuality = item.dataset.quality



      if (startQuality < targetQuality) {

        data.inventory = item.dataset.inventoryname
        data.slot = parseInt(slot.replace(/\D/g, ''))
        data.information = item.dataset.info
        data.information.quality = startQuality
        UpdateQuality(data,startQuality)
      }

    } else {

      if (TargetInventoryName == "Shop" || TargetInventoryName == "Craft" || (!StoreOwner && PlayerStore)) {
        result = "You can not drop items into the shop!";
        EndDragError(slot);
        InventoryLog("Error: " + result2 + " | " + result)
      } else {
        SwapStacks(parseInt(slot.replace(/\D/g, '')), parseInt(draggingid.replace(/\D/g, '')), inventoryDropName, inventoryReturnItemDropName)

        item.dataset.currentslot = parseInt(slot.replace(/\D/g, ''));
        itemReturnItem.dataset.currentslot = parseInt(draggingid.replace(/\D/g, ''));

        let currentdragHTML = document.getElementById(draggingid).innerHTML;
        let currentdropHTML = document.getElementById(slot).innerHTML;

        document.getElementById(draggingid).innerHTML = currentdropHTML;
        document.getElementById(slot).innerHTML = currentdragHTML;
      }
    }

    UpdateSetWeights()

    EndDrag(slot);

  } else {
    // errored?
    EndDragError(slot);
    InventoryLog("Error: " + result2 + " | " + result)
  }
}

function EndDragError(slot) {
  UpdateTextInformation(draggingid);
  UpdateTextInformation(slot);

  document.getElementById('draggedItem').style.opacity = '0.0'
  document.getElementById('draggedItem').innerHTML = "";

  dragging = false;
  draggingid = "none";
}

function EndDrag(slot) {
  UpdateTextInformation(draggingid);
  UpdateTextInformation(slot);
  dragging = false;
  draggingid = "none";
  document.getElementById('draggedItem').style.opacity = '0.0';
  document.getElementById('draggedItem').innerHTML = "";

}

function DisplayInformation(slot) {
  let item = document.getElementById(slot).getElementsByTagName('img')[0];

  let weight = parseInt(item.dataset.weight);
  let amount = parseInt(item.dataset.amount);
  let quality = item.dataset.quality;

  let name = item.dataset.name;
  let metainformation = item.dataset.metainformation;
  let stackable = parseInt(item.dataset.stackable);
  let color = "green"
  if (quality == undefined) {
    quality = 100
  }
  switch (quality) {
    case quality > 75:
      color = "#5FF03C"
      break;
    case quality > 50:
      color = "#74C242"
      break;
    case quality > 25:
      color = "#DEB837"
      break;
    case quality > 0:
      color = "#CC2727"
      break;
  }

  document.getElementById('CurrentInformation').innerHTML = "";

  if (quality != "" && quality != null && quality != "undefined") {
    document.getElementById('CurrentInformation').innerHTML = "<h2> " + name + "</h2> <div class='DispInfo'> " + metainformation + "</div> <br><hr><br><b>Weight</b>: " + weight.toFixed(2) + "<br><b>Amount</b>: " + amount + "" + "<br><b>Quality</b>: <font color=" + color + ">" + quality + "</font>" + "";
  } else {
    document.getElementById('CurrentInformation').innerHTML = "<h2> " + name + "</h2> <div class='DispInfo'> " + metainformation + "</div> <br><hr><br><b>Weight</b>: " + weight.toFixed(2) + "<br><b>Amount</b>: " + amount + "";
  }
}

function AttemptDropInEmptySlot(slot, isDropped, half) {

  let item = document.getElementById(draggingid).getElementsByTagName('img')[0];
  if (item == undefined) {
    EndDragError(slot);
    return
  }


  let currentInventory = item.dataset.inventory;
  let weight = parseInt(item.dataset.weight);
  let amount = parseInt(item.dataset.amount);
  let inventoryReturnItemDropName = document.getElementById(draggingid).parentElement.className;
  let inventoryDropName = document.getElementById(slot).parentElement.className;
  let sameinventory = true;
  let movementWeight = weight * amount;
  purchase = false;
  crafting = false;
  let itemidsent = item.dataset.itemid;

  let moveAmount = parseInt(document.getElementById('move-amount').value);

  if (half && amount > 1) {
      moveAmount = Math.floor(amount / 2)
  }

  let splitMove = false;
  if (moveAmount != 0 && moveAmount != amount) {
    splitMove = true;
    let alteredAmount = moveAmount;
    movementWeight = weight * alteredAmount;
  }
  if (moveAmount == amount) {
    splitMove = false
  }

  let result = ErrorCheck(currentInventory, inventoryDropName, movementWeight)

  if (isDropped && inventoryReturnItemDropName == "wrapsecondary") {
    result = "Error: can not drop a dropped item"
  }

  if (inventoryDropName == "wrapsecondary" && TargetInventoryName == "Shop" || (inventoryDropName == "wrapsecondary" && !StoreOwner && PlayerStore)) {
    result = "You can not drop items into the shop!";
  }
  if (inventoryDropName == "wrapsecondary" && TargetInventoryName == "Craft") {
    result = "You can not drop items into the craft shop!";
  }


  if (inventoryDropName == "wrapsecondary" && PlayerStore) {
    let isWeapon = itemList[itemidsent].weapon;
    if (isWeapon != undefined) {
      result = "You can not move weapons while in player stores!";
    }
  }




  if (moveAmount > amount) {
    document.getElementById("move-amount").value = 0;
    result = "You do not have that amount!";
  }

  if (result == "Success") {

    // moving from player to secondat
    if (currentInventory == 1 && (inventoryDropName == "wrapsecondary" || isDropped)) {
      // tell lua the new location and stuff?
      personalWeight = personalWeight - movementWeight
      if (!isDropped) {
        item.dataset.inventory = 2;
        secondaryWeight = secondaryWeight + movementWeight
      }
    }



    //moving from secondary to player
    if (currentInventory == 2 && (inventoryDropName == "wrapmain" || isDropped)) {
      // tell lua the new location and stuff?
      secondaryWeight = secondaryWeight - movementWeight
      if (!isDropped) {
        item.dataset.inventory = 1;
        personalWeight = personalWeight + movementWeight
      }
    }


    UpdateSetWeights()

    let purchaseCost = parseInt(item.dataset.fwewef) * parseInt(moveAmount);
    InventoryLog(item.dataset.fwewef + " | " + purchaseCost + " | " + moveAmount);
    if (TargetInventoryName == "Shop" || (!StoreOwner && PlayerStore)) {
      InventoryLog("eh: PURCHASE")
      if (purchaseCost > userCash) {
        result = "You cant afford that, bitch!";
        EndDragError(slot);
        InventoryLog("Error: " + result);
        //userCash = userCash - purchaseCost; unsure why we are taking money on not enough money taken
      } else {

        if (itemList[itemidsent].weapon) {
          if (!exluded[itemidsent] && !userWeaponLicense) {
            result = "You do not have a license.!";
            InventoryLog("Error: " + result)
            EndDragError(slot);
            return
          }

          if (!exluded[itemidsent] && brought && !isCop) {
            result = "You can only buy one gun a day!";
            InventoryLog("Error: " + result)
            EndDragError(slot);
            return
          }
        }

        if (currentInventory == 2 && inventoryDropName == "wrapmain") {
          userCash = userCash - purchaseCost;
          InventoryLog("Purchase Cost: $" + purchaseCost + " you have $" + userCash + " left.")
          purchase = true;
        }
      }
    }

    if (TargetInventoryName == "Craft") {
      InventoryLog("eh: Crafting")

      if (CheckCraftFail(itemidsent, moveAmount)) {
        result = "You dont have the required materials.!";
        EndDragError(slot);
        InventoryLog("Error: " + result)
      } else {
        if (currentInventory == 2 && inventoryDropName == "wrapmain") {
          InventoryLog("Attempted to craft item with itemid: " + itemidsent)
          crafting = true;
        }
      }
    }

    if (splitMove) {

      if (!isDropped) {
        document.getElementById(slot).innerHTML = document.getElementById(draggingid).innerHTML;
      }

      let item = document.getElementById(draggingid).getElementsByTagName('img')[0];
      let itemNewItem = document.getElementById(slot).getElementsByTagName('img')[0];
      let startAmount = parseInt(item.dataset.amount);

      itemNewItem.dataset.amount = parseInt(moveAmount);

      if (inventoryDropName == "wrapsecondary") {
        itemNewItem.dataset.inventory = 2;
      } else {
        itemNewItem.dataset.inventory = 1;
      }

      item.dataset.amount = startAmount - parseInt(moveAmount);
      itemNewItem.dataset.currentslot = parseInt(slot.replace(/\D/g, ''));

      let oldDragId = draggingid;

      if (!isDropped) {

        CompileStacks(parseInt(slot.replace(/\D/g, '')), parseInt(oldDragId.replace(/\D/g, '')), inventoryDropName, inventoryReturnItemDropName, moveAmount, item.dataset.amount, moveAmount, purchase, purchaseCost, itemidsent, moveAmount)

        EndDrag(slot);
      } else {
        DropItem(oldDragId, moveAmount);
      }

      if (parseInt(item.dataset.amount) < 1) {
        document.getElementById(oldDragId).innerHTML = "";
      }

      if (!isDropped) {
        item.dataset.inventory = currentInventory;
      }

      EndDrag(oldDragId);

    } else {

      let oldDragId = draggingid;
      if (!isDropped) {

        MoveStack(parseInt(slot.replace(/\D/g, '')), parseInt(oldDragId.replace(/\D/g, '')), inventoryDropName, inventoryReturnItemDropName, purchase, purchaseCost, itemidsent, moveAmount)

        if (inventoryDropName == "wrapsecondary") {
          item.dataset.inventory = 2;
        } else {
          item.dataset.inventory = 1;
        }

        item.dataset.currentslot = parseInt(slot.replace(/\D/g, ''));
        document.getElementById(slot).innerHTML = document.getElementById(draggingid).innerHTML;

        EndDrag(slot);
      } else {
        let item = document.getElementById(draggingid).getElementsByTagName('img')[0];
        item.dataset.amount = 0;
        DropItem(draggingid, amount);
        EndDrag(slot);
      }

      document.getElementById(oldDragId).innerHTML = "";

    }

  } else {
    if (isDropped) {
      CleanEndDrag()
      InventoryLog("Error: " + result)
    } else {
      EndDragError(slot);
      // errored?
      InventoryLog("Error: " + result)
    }
  }
}

function CleanEndDrag() {
  $('#draggedItem').css('opacity', 0.0);
  document.getElementById('draggedItem').innerHTML = "";
  dragging = false;
  draggingid = "none";
}

function DisplayDataSet(slot) {
  let item = document.getElementById(slot).getElementsByTagName('img')[0];
  //Example of displaying dataset information to the image AKA item we are manipulating so we can do w/e the fuck we want with that slot
}

function RequestItemData() {
  let item = document.getElementById(draggingid).getElementsByTagName('img')[0];
  currentInventory = item.dataset.inventory;
  weight = item.dataset.weight;
  amount = item.dataset.amount;
  name = item.dataset.name;
  itemid = item.dataset.itemid;
  inventoryUsedName = item.dataset.inventoryname;
  slotusing = item.dataset.currentslot;
}

function EndDragUsage(type) {
  EndDrag(slot);
  let slot = type

  dragging = false;
  draggingid = "none";

  $('#draggedItem').css('opacity', 0.0);
  document.getElementById('draggedItem').innerHTML = "";
}

function useitem() {
  if (dragging != false) {
    RequestItemData()
    let isWeapon = itemList[itemid].weapon;
    if (isWeapon === undefined) {
      isWeapon = false;
    }
    if (inventoryUsedName == PlayerInventoryName) {
      let arr = [inventoryUsedName, itemid, slotusing, isWeapon]
      $.post("http://np-inventory/invuse", JSON.stringify(arr));
      InventoryLog("Using item: " + name + "(" + amount + ") from " + inventoryUsedName + " | slot " + slotusing)
    }
    EndDrag(slotusing);
    closeInv(true)
  }
}