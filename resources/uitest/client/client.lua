local guiEnabled = false
local firstOpen = false


imdead = 0
isMedic = false
isDoctor = false
isCop = false
isNews = false
isInService = false
handCuffed = false
handCuffedWalking = false
isJudge = false
isInstructorMode = false
myJob = "Unemployed"

shop = false
isBuy = 0
lockStatus = 0
isExit = false

function CloseGui()
    firstOpen = false
    SetNuiFocus(false)
    guiEnabled = false

    SendNUIMessage({
        type = "enableui",
        enable = false
    })
    SendNUIMessage({type = "endOfCurrentMenu",isEnd = false})
end





function EnableGui()
    TriggerEvent("stripclub:stressLoss",false)
    SetNuiFocus(true, true)
    --SetCursorLocation(0.55, 0.5)
    SendNUIMessage({
        type = "enableui",
        enable = true
    })
    guiEnabled = true
end

function FeedGui(name,functionname,buttonType)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "addButton",
        name = name,
        functionname = functionname,
        buttonType = buttonType
    })
end

function FeedGui3(name,functionname)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "addButton3",
        name = name,
        functionname = functionname
    })
end

-- { {text: "Name of Button", value: function){text: "Name of Button", value: function},{text: "Name of Button", value: function}, }
RegisterNetEvent('sendToGui')
AddEventHandler('sendToGui', function(arg1,arg2,arg3)
    if (guiEnabled) then
        FeedGui(arg1,arg2,arg3)
    else
        EnableGui()
        Citizen.Wait(70)
        FeedGui(arg1,arg2,arg3)
    end

end)
local runningfunction = false
RegisterNUICallback('runfunction', function(data, cb)
    if not runningfunction then
         runningfunction = true
        if data.functionset == "openSubMenu" then
            TriggerEvent('' .. data.functionset .. '',data.name)
        elseif data.buttonType == "shop" or data.buttonType == "tool" or data.buttonType == "hair" or data.buttonType == "hair2" or data.buttonType == "hairnextprev" then
            TriggerEvent('' .. data.functionset .. '')
            if data.buttonType == "shop" then Wait(300) end
        else
            CloseGui()
            TriggerEvent('' .. data.functionset .. '')
        end
        Citizen.Wait(750)
        runningfunction = false
    end
    cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
    CloseGui()
    cb('ok')
end)

-- used for hairdresser only ATM
RegisterNUICallback('left', function(data, cb)
    TriggerEvent("prevBlemishes")
    cb('ok')
end)
RegisterNUICallback('right', function(data, cb)
    TriggerEvent("nextBlemishes")
    cb('ok')
end)

RegisterNUICallback('up', function(data, cb)
    TriggerEvent("dC21")
    cb('ok')
end)

RegisterNUICallback('down', function(data, cb)
    TriggerEvent("dC22")
    cb('ok')
end)

RegisterNetEvent('FeedEnableGUI')
AddEventHandler('FeedEnableGUI', function()
    EnableGui()
    Citizen.Wait(70)
end)

RegisterNetEvent('FeedMenuGUI')
AddEventHandler('FeedMenuGUI', function(buttonName,buttonFunction)
    FeedGui3( buttonName, buttonFunction )
end)

RegisterNetEvent('closeMenu')
AddEventHandler('closeMenu', function()
    CloseGui()
end)
local buttons = {}

function setMenu()
buttons = {


    --Phone / Wallet



    -- Race Options

    {"$50 Race", 'race:50','Race Options',"normal"},
    {"$500 Race", 'race:500','Race Options',"normal"},
    {"$5000 Race", 'race:5000','Race Options',"normal"},
    {"$50000 Race", 'race:50000','Race Options',"normal"},
    {"Pink Slip Race", 'race:pinkslips','Race Options',"normal"},

    -- K9 Menu

    {"Spawn", 'K9:Create',"K9 Menu","police"},
    {"Delete", 'K9:Delete' ,"K9 Menu","police"},
    {"Follow", 'K9:Follow' ,"K9 Menu","police"},
    {"Vehicle K9", 'K9:Vehicle',"K9 Menu","police"},
    {"Sit", 'K9:Sit',"K9 Menu","police"},
    {"Lay", 'K9:Lay',"K9 Menu","police"},
    {"Stand", 'K9:Stand',"K9 Menu","police"},
    {"Sniff Person", 'K9:Sniff',"K9 Menu","police"},
    {"Sniff Vehicle", 'sniffVehicle',"K9 Menu","police"},
    {"Hunt Nearest", 'K9:Huntfind',"K9 Menu","police"},


    -- main menu

    -- weed
    {'Request Status' , 'weed:currentStatusServer',"openMainMenu","weed"},
    {'Remove A Crate' , 'weed:weedCrate',"openMainMenu","weed"},

    -- launder
    {'Request Status' , 'launder:currentStatusServer',"openMainMenu","launder"},
    {'Remove A Crate' , 'launder:launderCrate',"openMainMenu","launder"},

    -- meth
    {'Request Status' , 'cocaine:currentStatusServer',"openMainMenu","meth"},
    {'Remove A Crate' , 'cocaine:methCrate',"openMainMenu","meth"},

    -- gun runner
    {'Request Status' , 'gunrunner:currentStatusServer',"openMainMenu","gun"},
    {'Remove A Crate' , 'gunrunner:takeCrate',"openMainMenu","gun"},

     -- impound
    {'Impound Vehicle' , 'fullimpoundVehicle',"openMainMenu","impound"},
    {'Flip Vehicle' , 'FlipVehicle',"openMainMenu","impound"},

    -- when dead
    {'10-14','police:tenForteen',"openMainMenu","dead"},
    {'10-13','police:tenThirteen',"openMainMenu","dead"},

    -- leo actions
    --{'TestAction','furniture:Start',"openMainMenu","normal"},
    {'LEO Actions','openSubMenu',"openMainMenu","police"},
    {'Cuff Actions','police:AttemptCuffFromInventory',"openMainMenu","handcuffer"},
     --Blips
    {'Toggle Gas Stations','CarPlayerHud:ToggleGas',"Toggle Blips","normal"},
    {'Toggle Train Stations','Trains:ToggleTainsBlip',"Toggle Blips","normal"},
    {'Toggle Garages','Garages:ToggleGarageBlip',"Toggle Blips","normal"},
    {'Toggle Barber Shop','hairDresser:ToggleHair',"Toggle Blips","normal"},
    {'Toggle Tattoo Shop','tattoo:ToggleTattoo',"Toggle Blips","normal"},

        -- News
    {'News: Camera','camera:setCamera',"News","news"},
    {'News: Microphone','camera:setMic',"News","news"},
    {'News: Boom','camera:setBoom',"News","news"},

    {'News','openSubMenu',"openMainMenu","news"},

        -- Judge
    {'Judge Actions','openSubMenu',"openMainMenu","judge"},

        -- gang
    {'Gang Actions','openSubMenu',"openMainMenu","gang"},

        -- ems
    {'Ems Menu','ems:bounce',"openMainMenu","medic"},

        --phone

        --veh
    {'Vehicle','veh:options',"openMainMenu","veh"},






    {'General','openSubMenu',"openMainMenu","normal"},

    {'Driving School','openSubMenu',"openMainMenu","driving"},

    -- End Of Main Menu

    -- General
    {'Check Over Self','Evidence:CurrentDamageList',"General","normal"},

    {'Check Target States','requestWounds',"General","normal"},

    {'Check Vehicle','towgarage:annoyedBouce',"General","normal"},


    {"Escort", 'escortPlayer',"General","general"},
    {"Put In Veh", 'police:forceEnter',"General","general"},
    {"Unseat Nearest", 'unseatPlayer',"General","general"},
    {"Remove Mask / Hat", 'police:remmask',"General","general"},
    {'Flip Vehicle' , 'FlipVehicle',"General","general"},

    {'Phone','phoneGui',"General","normal"},

     {"Anim Sets","openSubMenu","General","normal"},
     {"Prop Attach","openSubMenu","General","normal"},
     {'Emotes',"emotes:OpenMenu","General","normal"},
     {'Give Car Key',"keys:give","General","normal"},
     {'Give Business Key',"apart:giveKey","General","normal"},

     {'Toggle Blips',"openSubMenu","General","normal"},


    {'Request Train',"AskForTrain","General","train"},

    --goverment help desk


    --{"Buy Drivers License (3k)", 'police:selfgrantDriver',"Govt Helpdesk","normal"},
    --{"Buy Business License (3k)", 'police:selfgrantBusiness',"Govt Helpdesk","normal"},
    --{"Buy Weapons License (10k)", 'police:selfgrantWeapon',"Govt Helpdesk","normal"},


    {"Tax Settings", 'openSubMenu',"General","mayor"},
    {"Pay Settings", 'openSubMenu',"General","mayor"},

    --Tax settings
    {"Set Tax 0", 'settax0',"Tax Settings","mayor"},
    {"Set Tax 5", 'settax5',"Tax Settings","mayor"},
    {"Set Tax 10", 'settax10',"Tax Settings","mayor"},
    {"Set Tax 15", 'settax15',"Tax Settings","mayor"},


    -- Pay Settings
    {"Set EMS 0", 'setEMS0',"Pay Settings","mayor"},
    {"Set EMS 50", 'setEMS50',"Pay Settings","mayor"},
    {"Set EMS 100", 'setEMS100',"Pay Settings","mayor"},
    {"Set EMS 200", 'setEMS200',"Pay Settings","mayor"},
    {"Set Police 0", 'setPolice0',"Pay Settings","mayor"},
    {"Set Police 50", 'setPolice50',"Pay Settings","mayor"},
    {"Set Police 100", 'setPolice100',"Pay Settings","mayor"},
    {"Set Police 200", 'setPolice200',"Pay Settings","mayor"},
    {"Set Civilian 0", 'setCivilian0',"Pay Settings","mayor"},
    {"Set Civilian 50", 'setCivilian50',"Pay Settings","mayor"},
    {"Set Civilian 100", 'setCivilian100',"Pay Settings","mayor"},

    -- Judge Actions
    {"Toggle Cuff", 'police:cuffFromMenu',"Judge Actions","judge"},
    {"Escort", 'escortPlayer' ,"Judge Actions","judge"},
    {"Searching", 'openSubMenu' ,"Judge Actions","judge"},
    {"Licenses", 'openSubMenu' ,"Judge Actions","judge"},
    {"Warrant MDT", 'warrantsGui' ,"Judge Actions","judge"},
    {"Arrest and Ticket", 'arrestGui' ,"Judge Actions","judge"},
    {'Delete Crimes',"police:deletecrimesciv","Judge Actions","judge"},
    {"Check Bank","police:checkBank","Judge Actions","judge"},


    -- Judge Licenses
    {"Search Licenses ", 'police:checkLicenses',"Licenses","judge"},
    {"Grant Drivers", 'police:grantDriver',"Licenses","judge"},
    {"Grant Business", 'police:grantBusiness',"Licenses","judge"},
    {"Grant Weapons", 'police:grantWeapon',"Licenses","judge"},
    {"Grant House", 'police:grantHouse',"Licenses","judge"},
    {"Grant BAR", 'police:grantBar',"Licenses","judge"},
    {"Grant DA", 'police:grantDA',"Licenses","judge"},
    {"Remove Drivers", 'police:removeDriver',"Licenses","judge"},
    {"Remove Business", 'police:removeBusiness',"Licenses","judge"},
    {"Remove Weapons", 'police:removeWeapon',"Licenses","judge"},
    {"Remove House", 'police:removeHouse',"Licenses","judge"},
    {"Remove BAR", 'police:removeBar',"Licenses","judge"},
    {"Remove DA", 'police:removeDA',"Licenses","judge"},
    {"Deny Weapon", 'police:denyWeapon',"Licenses","judge"},
    {"Deny Driver", 'police:denyDriver',"Licenses","judge"},
    {"Deny Business", 'police:denyBusiness',"Licenses","judge"},
    {"Deny House", 'police:denyHouse',"Licenses","judge"},








    -- Police licenses
    {"Search Licenses", 'police:checkLicenses',"Licenses Police","police"},

    {"Remove Weapons", 'police:removeWeapon',"Licenses Police","police"},

        -- Police Actions

    {"Escort", 'escortPlayer' ,"LEO Actions","police"},
    {"Revive", 'revive' ,"LEO Actions","police"},
    {"Vehicle", 'openSubMenu' ,"LEO Actions","police"},
    {"Warrant MDT", 'warrantsGui' ,"LEO Actions","police"},
    {"Toggle Cuff", 'police:cuffFromMenu',"LEO Actions","police"},
    {"Searching", 'openSubMenu' ,"LEO Actions","police"},
    {"Arrest and Ticket", 'arrestGui' ,"LEO Actions","police"},
    {"Licenses Police", 'openSubMenu' ,"LEO Actions","police"},
    {'Check Target States','requestWounds',"LEO Actions","police"},
    {"K9 Menu", 'openSubMenu' ,"LEO Actions","police"},
    {"Check Bank","police:checkBank","LEO Actions","police"},

    {"Swab Clothes",'item:getPlayerClothes',"LEO Actions","police"},
    {"Remove Mask / Hat", 'police:remmask',"LEO Actions","police"},

    {"Warrant MDT", 'warrantsGui' ,"openMainMenu","DA"},
    -- Police Searching
    {"Search Person", 'police:checkInventory',"Searching","police"},
    {"GSR Test", 'police:gsr',"Searching","police"},
    {"Dna swab", 'evidence:dnaSwab',"Searching","police"},

    -- Police Veh
    {"Run Plate", 'clientcheckLicensePlate',"Vehicle","police"},
    {"Toggle Radar", "startSpeedo","Vehicle","police"},
    {"Put In Veh", 'police:forceEnter',"Vehicle","police"},
    {"Unseat Nearest", 'unseatPlayer',"Vehicle","police"},

    -- HandCuff Actions
    {"Put In Veh", 'police:forceEnter',"handcuffer","normal"},
    {"Cuff", 'civ:cuffFromMenu',"handcuffer","normal"},
    {"Uncuff", 'police:uncuffMenu',"handcuffer","normal"},
    {"Remove Mask / Hat", 'police:remmask',"handcuffer","normal"},
    {"Search Person", 'police:checkInventory',"handcuffer","normal"},
    {"Unseat Nearest", 'unseatPlayerCiv',"handcuffer","normal"},
    {"Read Phone", 'police:checkPhone',"handcuffer","normal"},

    -- gang Actions
    {"Toggle Cuff", 'police:cuffFromMenu',"Gang Actions","normal"},
    {"Escort", 'escortPlayer',"Gang Actions","normal"},
    {"Searching Gang", 'openSubMenu',"Gang Actions","normal"},
    {"Vehicle Gang", 'openSubMenu',"Gang Actions","normal"},

    -- gang veh actions
    {"Run Plate", 'clientcheckLicensePlate',"Vehicle Gang","normal"},
    {"Put In Veh", 'police:forceEnter',"Vehicle Gang","normal"},
    {"Unseat Nearest", 'unseatPlayer',"Vehicle Gang","normal"},

    --gang search options
    {"Search Person", 'police:checkInventory',"Searching Gang","normal"},
    {"Frisk Person", 'police:frisk',"Searching Gang","normal"},
    {"Remove Weapons", 'police:remweapons',"Searching Gang","normal"},
    {"Remove Mask / Hat", 'police:remmask',"Searching Gang","normal"},
    {"Read Phone", 'police:checkPhone',"Searching Gang","normal"},

    -- Ems 1
    {"Escort", 'escortPlayer',"ems1","medic"},
    {"Revive", 'revive' ,"ems1","medic"},
    {"Put In Veh", 'police:forceEnter',"ems1","medic"},
    {"Unseat Nearest", 'unseatPlayer',"ems1","medic"},
    {"Check Over Target", 'requestWounds' ,"ems1","medic"},

    --Ems 2
    {"Escort", 'escortPlayer',"ems2","medic"},
    {"Revive", 'revive' ,"ems2","medic"},
    {"Unseat Nearest", 'unseatPlayer',"ems2","medic"},
    {"Check Over Target", 'requestWounds' ,"ems2","medic"},


    --Amim Sets
    {"Anim Set Brave", 'AnimSet:Brave',"Anim Sets","animSets"},
    {"Anim Set Business", 'AnimSet:Business' ,"Anim Sets","animSets"},
    {"Anim Set Tipsy", 'AnimSet:Tipsy' ,"Anim Sets","animSets"},
    {"Anim Set Injured", 'AnimSet:Injured' ,"Anim Sets","animSets"},
    {"Anim Set Tough", 'AnimSet:ToughGuy' ,"Anim Sets","animSets"},
    {"Anim Set Sassy", 'AnimSet:Sassy' ,"Anim Sets","animSets"},
    {"Anim Set Sad", 'AnimSet:Sad' ,"Anim Sets","animSets"},
    {"Anim Set Posh", 'AnimSet:Posh' ,"Anim Sets","animSets"},
    {"Anim Set Alien", 'AnimSet:Alien' ,"Anim Sets","animSets"},
    {"Anim Set NonChalant", 'AnimSet:NonChalant' ,"Anim Sets","animSets"},
    {"Anim Set Hobo", 'AnimSet:Hobo' ,"Anim Sets","animSets"},
    {"Anim Set Money", 'AnimSet:Money' ,"Anim Sets","animSets"},
    {"Anim Set Swagger", 'AnimSet:Swagger' ,"Anim Sets","animSets"},


    {"Anim Set Shady", 'AnimSet:Shady' ,"Anim Sets","animSets"},


    {"Anim Set ManEater", 'AnimSet:ManEater' ,"Anim Sets","animSets"},
    {"Anim Set ChiChi", 'AnimSet:ChiChi' ,"Anim Sets","animSets"},
    {"Anim Set Default", 'AnimSet:default' ,"Anim Sets","animSets"},


   -- {"test", 'attach:test' ,"Prop Attach","normal"},
    {"Remove All", 'attach:removeall' ,"Prop Attach","normal"},
    



    --Appartments
    {"Exit Property", 'Appartment:Visiter2',"apartment","exit"},
    {"Enter Property", 'Appartment:Visiter',"apartment","enter"},
    {"Judge Apartment Actions", 'openSubMenu',"apartment","judge"},

        --Judge
    {"Check Owner", 'Appartment:CheckOwner',"Judge Apartment Actions","judge"},
    {"Seize All Content", 'Appartment:SeizeAll',"Judge Apartment Actions","judge"},
    {"Take Cash", 'Appartment:TakeCash',"Judge Apartment Actions","judge"},
    {"Take Marked Bills", 'Appartment:TakeDM',"Judge Apartment Actions","judge"},

        -- buy
    {"Buy Property", 'Appartment:Acheter',"apartment","buy"},

        --buy 2
    {"Manage Property", 'openSubMenu',"apartment","buy2"},

    {"Check Upkeep Cost", 'Appartment:CheckRent',"apartment","buy2"},
    {"Pay 5 Days Upkeep", 'Appartment:PayRent',"apartment","buy2"},

        --buy 3
    {"Buy Property", 'Appartment:Acheter',"apartment","buy3"},

        -- buy 4
    {"Manage Property", 'openSubMenu',"apartment","buy4"},

    {"Rob Property", 'AppRobberies:currentlyrobbing',"apartment","apartRob"},
    {"Close Menu", 'global:closegui',"apartment","normal"},




        -- Manage property
    {"Sell Property", 'Appartment:Vendre',"Manage Property","buy2"},
    {"Lock Property", 'Appartment:lock',"Manage Property","normal"},
    {"Unlock Property", 'Appartment:unlock',"Manage Property","normal"},

        -- Manage inventory
    {"Stash Cash", 'Appartment:StashCash',"Manage Inventory","normal"},
    {"Stash Marked Bills", 'Appartment:StashDM',"Manage Inventory","normal"},
    {"Take Cash", 'Appartment:TakeCash',"Manage Inventory","normal"},
    {"Take Marked Bills", 'Appartment:TakeDM',"Manage Inventory","normal"},


    -- hairdresser


    {"Purchase", 'Blemishes:checkMoney',"hairdresser","hairclose"},
    {"Remove All", 'removeBlemishes',"hairdresser","hairclose"},

    {"Close", 'CloseBlemishes',"hairdresser","haircloseaids"},

    {"Next", 'nextBlemishes',"hairdresser","hairnextprev"},
    {"Previous", 'prevBlemishes',"hairdresser","hairnextprev"},

    {"Structure Down", 'dC22',"hairdresser","hair"},
    {"Structure UP", 'dC21',"hairdresser","hair"},



    {"Parent 1", 'dC14',"hairdresser","hair"},
    {"Parent 2", 'dC15',"hairdresser","hair"},
    {"Parent 3", 'dC16',"hairdresser","hair"},
    {"Parent 1 Blend", 'dC17',"hairdresser","hair"},
    {"Parent 2 Blend", 'dC19',"hairdresser","hair"},
    {"Skin Blend", 'dC18',"hairdresser","hair"},
    {"Blemishes", 'dC1',"hairdresser","hair"},
    {"Facial Hair", 'dC2',"hairdresser","hair"},
    {"Eyebrows", 'dC3',"hairdresser","hair"},
    {"Ageing", 'dC4',"hairdresser","hair"},
    {"Makeup", 'dC5',"hairdresser","hair"},
    {"Blush", 'dC6',"hairdresser","hair"},
    {"Complexion", 'dC7',"hairdresser","hair"},
    {"Sun Damage", 'dC8',"hairdresser","hair2"},
    {"Lipstick", 'dC9',"hairdresser","hair2"},
    {"Chest Hair", 'dC11',"hairdresser","hair2"},
    {"Body Blemishes", 'dC12',"hairdresser","hair2"},

    {"Prev Eyebrow Color", "dC28","hairdresser","hair2"},
    {"Next Eyebrow Color", "dC29","hairdresser","hair2"},
    {"Next Makeup Color", 'dC24',"hairdresser","hair2"},
    {"Prev Makeup Color", 'dC26',"hairdresser","hair2"},
    {"Next Hair Color", 'dC25',"hairdresser","hair2"},
    {"Prev Hair Color", 'dC27',"hairdresser","hair2"},

    -- Tattoo Shop


     {"Previous Tattoo", 'prevTattoo',"tattoo","tattoo"},
     {"Next Tattoo", 'nextTattoo',"tattoo","tattoo"},
     {"Beach Tattoos", 'tC1',"tattoo","tattoo"},
     {"Business Tattoos", 'tC2',"tattoo","tattoo"},
     {"Hipster Tattoos", 'tC3',"tattoo","tattoo"},
     {"Purchase", 'tattoo:checkMoney',"tattoo","tattoo"},
     {"Remove All", 'removeTattoos',"tattoo","tattoo"},
     {"Close", 'CloseTattoo',"tattoo","tattoo"},

     -- Driving Instructor Shop
     {"Driving Test", 'drivingInstructor:testToggle',"Driving School","driving"},
     {"Submit Test", 'drivingInstructor:submitTest',"Driving School","driving"},

}
end


function getPrice(price)
    local endPrice  = 0
    endPrice = (price*0.20)
    endPrice = endPrice+price
    endPrice = math.ceil(endPrice)
    return endPrice
end

gangNum = 0
RegisterNetEvent('enablegangmember')
AddEventHandler('enablegangmember', function(gangNumInput)
    gangNum = gangNumInput
end)

RegisterNetEvent('openSubMenu')
AddEventHandler('openSubMenu', function(buttonName)

    if not firstOpen then
        firstOpen = true
        EnableGui()
    end

    Citizen.Wait(70)

    playerped = nil
    coordA = nil
    coordB = nil
    --targetVehicle = nil

    weed = false
    launder = false
    meth = false
    gun = false

    if buttonName == "openMainMenu" then
        playerped = PlayerPedId()
        coordA = GetEntityCoords(playerped, 1)
        coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
        --targetVehicle = getVehicleInDirection(coordA, coordB)

        TriggerEvent("turnoffsitting")

        TriggerEvent("OxyMenu")
        TriggerEvent("checkganglocks")
    end

    for i,v in ipairs(buttons) do
        if v[3] == buttonName then
            if v[4] ~= "normal" and v[4] ~= "dead" and imdead == 0 then
                local veh = GetVehiclePedIsUsing(PlayerPedId())
                if v[4] == "mayor" and Mayor then
                    FeedGui(v[1],v[2],v[4])

                elseif v[4] == "handcuffer" then
                    if exports["np-inventory"]:hasEnoughOfItem("cuffs",1,false) then
                        FeedGui(v[1],v[2],v[4])
                    end
                elseif v[4] == "police" then
                    if isCop or isJudge then
                        FeedGui(v[1],v[2],v[4])
                    end
                elseif v[4] == "ems" and isCop then
                    FeedGui(v[1],v[2],v[4])

                elseif v[4] == "weed" and gangNum == 4 then
                    if #(GetEntityCoords(PlayerPedId()) - vector3(1044.5784912109,-3194.9165039063,-38.157917022705)) < 1.599 then
                        FeedGui(v[1],v[2],v[4])
                        weed = true
                    end
                elseif v[4] == "launder" and gangNum == 3 then
                    if #(GetEntityCoords(PlayerPedId()) - vector3(1129.4552001953,-3194.1286621094,-40.396289825439)) < 1.599 then
                        FeedGui(v[1],v[2],v[4])
                        launder = true
                    end
                elseif v[4] == "meth" and gangNum == 2 then
                    if #(GetEntityCoords(PlayerPedId()) - vector3(1087.3937988281,-3194.2138671875,-38.993473052979)) < 1.599 then
                        FeedGui(v[1],v[2],v[4])
                        meth = true
                    end
                elseif v[4] == "gun" and gangNum == 1 then
                    if #(GetEntityCoords(PlayerPedId()) - vector3(1116.024414062,-3160.901611328,-36.87049865722)) < 1.599 then
                        FeedGui(v[1],v[2],v[4])
                        gun = true
                    end
                elseif v[4] == "impound" and nearImpound() then
                        if (isJudge or isCop) then
                            FeedGui(v[1],v[2],v[4])
                        else
                            TriggerEvent("tow:checkIfOnDuty")
                        end

                elseif v[4] == "inv" and not handCuffed and not handCuffedWalking then
                    if v[1] == "Inventory" then
                        FeedGui(v[1],v[2],v[4])
                    elseif DoesEntityExist(targetVehicle) then
                        FeedGui(v[1],v[2],v[4])
                    end
                elseif v[4] == "hair" then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "hair2" then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "hairnextprev" then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "hairclose" then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "haircloseaids" then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "tattoo" then
                    FeedGui(v[1],v[2],v[4])

                elseif v[4] == "news" and isNews then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "judge" and isJudge then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "gang" and GangMember then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "gang2" and gangNum == 2 then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "medic" and (isMedic or isDoctor) and not isCop and not isJudge then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "veh" then
                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        FeedGui(v[1],v[2],v[4])
                    end
                elseif v[4] == "seat" and IsPedInAnyVehicle(PlayerPedId(), false) then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "general" and not handCuffed and GetPedInVehicleSeat(veh, -1) ~= PlayerPedId() then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "mayor" and Mayor then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "animSets" then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "shop" then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "burgershot" then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "exit" then
                    if not shop then
                        if isJudge or isCop then
                            if isExit then
                                FeedGui(v[1],v[2],v[4])
                            end
                        elseif isBuy ~= 0 and isExit then
                            if lockStatus == 0 then
                                FeedGui(v[1],v[2],v[4])
                            end
                        end
                    end
                elseif v[4] == "enter" then
                    if not shop then
                        if isJudge or isCop then
                            if not isExit then
                                FeedGui(v[1],v[2],v[4])
                            end
                        elseif isBuy ~= 0 and not isExit then
                            if lockStatus == 0 then
                                FeedGui(v[1],v[2],v[4])
                            end
                        end
                    end
                elseif v[4] == "DA" and exports["np-base"]:getModule("LocalPlayer"):getVar("job") == "district attorney" then
                    FeedGui(v[1],v[2],v[4])
                elseif v[4] == "buy" then
                    if isBuy ~= 2 and isBuy ~= 3 and isBuy ~= 4 then
                        FeedGui(v[1],v[2],v[4])
                    end
                elseif v[4] == "buy2" then
                    if isBuy == 2 then
                        FeedGui(v[1],v[2],v[4])
                    end
                elseif v[4] == "buy3" then
                    if isBuy == 3 then
                        FeedGui(v[1],v[2],v[4])
                    end
                 elseif v[4] == "buy4" then
                    if isBuy == 4 then
                        FeedGui(v[1],v[2],v[4])
                    end

                elseif v[4] == "apartRob" then
                    if not isExit then
                        FeedGui(v[1],v[2],v[4])
                    end
                elseif v[4] == "train" then
                    local hasTain = false
                    for _,d in ipairs(trainstations) do
                        CoordC = GetEntityCoords(PlayerPedId())
                        if #(vector3(d[1],d[2],d[3]) - CoordC) < 25 and not hasTain then
                            hasTain = true
                            FeedGui(v[1],v[2],v[4])
                        end
                    end
                elseif v[4] == "driving" and isInstructorMode then
                    FeedGui(v[1],v[2],v[4])
                end
            elseif v[4] == "dead" and imdead == 1 then
                if v[1] == "10-13" then
                    if isCop or isJudge then
                        FeedGui(v[1],v[2],v[4])
                    end
                elseif v[1] == "10-14" then
                    if isMedic then
                        FeedGui(v[1],v[2],v[4])
                    end
                elseif v[1] == "Phone / Wallet" then
                    FeedGui(v[1],v[2],v[4])
                end
            elseif v[4] ~= "dead" and imdead == 0 then
                FeedGui(v[1],v[2],v[4])
            end
        end
    end

    if weed then TriggerEvent("weed:checkCurrentTask") end
    if launder then TriggerEvent("launder:checkCurrentTask") end
    if meth then TriggerEvent("meth:checkCurrentTask") end
    if gun then TriggerEvent("gunrunner:checkCurrentTask") end

    SendNUIMessage({type = "endOfCurrentMenu",isEnd = true})
end)

--[[
RegisterNetEvent('voipGui')
AddEventHandler('voipGui', function()
    EnableGui()
    Citizen.Wait(70)

    FeedGui( "Whisper", 'pv:voip1' )
    FeedGui( "Normal", 'pv:voip2' )
    FeedGui( "Yell", 'pv:voip3' )
    FeedGui( "Back", 'openMainMenu')
end)
]]


RegisterNetEvent('openMainMenu')
AddEventHandler('openMainMenu', function()
    TriggerEvent("openSubMenu","openMainMenu")
end)

RegisterNetEvent('openApartmentMenu')
AddEventHandler('openApartmentMenu', function(storeX,buy,lock,exit)
    shop = storeX
    isBuy = buy
    lockStatus = lock
    isExit = exit
    TriggerEvent("openSubMenu","apartment")
end)

RegisterNetEvent('checkmayorname')
AddEventHandler('checkmayorname', function()
    TriggerServerEvent("checkmayorname")
end)

RegisterNetEvent('checkmayortaxtest')
AddEventHandler('checkmayortaxtest', function()
    local currenttax = exports["np-votesystem"]:getTax()
    TriggerEvent("DoLongHudText","Current tax is:" .. currenttax .. "!",1)
end)

RegisterNetEvent('global:closegui')
AddEventHandler('global:closegui', function()
    CloseGui()
end)

RegisterNetEvent('ems:bounce')
AddEventHandler('ems:bounce', function()
    TriggerServerEvent("police:emsUICheck")
end)

RegisterNetEvent('ems:loadactions')
AddEventHandler('ems:loadactions', function()
    TriggerEvent("openSubMenu","ems1")
end)

RegisterNetEvent('ems:loadactions2')
AddEventHandler('ems:loadactions2', function()
    TriggerEvent("openSubMenu","ems2")
end)

Citizen.CreateThread(function()
    while true do
        if guiEnabled then


            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end

            if IsControlJustReleased(0, 18) or IsDisabledControlJustReleased(0, 18) then -- ENTER
                SendNUIMessage({
                    type = "enter"
                })
            end

            if IsControlJustReleased(0, 172) or IsDisabledControlJustReleased(0, 172) then -- UP
                SendNUIMessage({
                    type = "up"
                })
            end

            if IsControlJustReleased(0, 173) or IsDisabledControlJustReleased(0, 173) then -- DOWN
                SendNUIMessage({
                    type = "down"
                })
            end
        end
        Citizen.Wait(0)
    end
end)



PayOpened = false
cashtype = 0
functiontype = 0
dirty = false

RegisterNetEvent("maddcash")
AddEventHandler("maddcash", function()
    TriggerEvent("mayorcashtype",1)
end)

RegisterNetEvent("mtakecash")
AddEventHandler("mtakecash", function()
    TriggerEvent("mayorcashtype",2)
end)

RegisterNetEvent("mayorcashtype")
AddEventHandler("mayorcashtype", function(cashtype2)
    TriggerEvent("DoLongHudText", "Enter Amount",1)
    PayOpened = true
    cashtype = cashtype2
    functiontype = 1
    DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
end)

--TriggerEvent("mayorcashtype",1 or 2)
-- 1 IS ADD, 2 IS REMOVED

RegisterNetEvent("civcashtype")
AddEventHandler("civcashtype", function(cashtype2,dirty2)
    TriggerEvent("DoLongHudText", "Enter Amount",1)
    PayOpened = true
    cashtype = cashtype2
    functiontype = 2
    dirty = dirty2
    DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
end)

Citizen.CreateThread(function()
    CloseGui()
    Wait(900)
    setMenu()
    while true do
        if PayOpened then
            if UpdateOnscreenKeyboard() == 3 then
                --PayOpened = false
            elseif UpdateOnscreenKeyboard() == 1 then
                local giveAmount = tonumber(GetOnscreenKeyboardResult())
                if giveAmount and giveAmount > 0 then
                    if functiontype == 1 then
                        TriggerServerEvent("MayorCashAdjust", giveAmount, cashtype)
                    end
                    if functiontype == 2 then
                        TriggerEvent("PropertyCashAdjust", giveAmount, cashtype, dirty)
                    end
                else
                    TriggerEvent("DoLongHudText", "You must insert a number amount to give",2)
                end
                PayOpened = false
            elseif UpdateOnscreenKeyboard() == 2 then
                --PayOpened = false
            end
        end
        Citizen.Wait(0)
    end
end)

Mayor = false
RegisterNetEvent('setMayor')
AddEventHandler('setMayor', function()
    Mayor = true
    TriggerEvent("DoLongHudText","Hello Mayor, welcome to the city!",1)
end)

function nearImpound()
    if #(GetEntityCoords(PlayerPedId()) - vector3(549.47796630859, -55.197559356689, 71.069190979004)) < 10.599 then
        return true
    end
    return false
end