local stashes = {}
local instash = 0
RegisterNetEvent('np-stash:setInitialState')
AddEventHandler('np-stash:setInitialState', function(stashesp)
    print('loaded')
    stashes = stashesp
    
end)

CreateThread(function()
    TriggerServerEvent("np-stash:fetchInitialState")
end)

RegisterCommand('getnearstash', function(src, args, raw)
    local closestDoorDistance, closestDoorId = 9999.9, -1
    local currentPos = GetEntityCoords(PlayerPedId())
    for id, handle in pairs(stashes) do
        local currentDoorDistance = #(stashes[id].StashEntry - currentPos)
        if handle and currentDoorDistance < closestDoorDistance then
            closestDoorDistance = currentDoorDistance
            closestDoorId = id
            if closestDoorId ~= -1 then
                if stashes[closestDoorId].distance > closestDoorDistance then
                    TriggerEvent('OpenCodeEntryGUI', {stashes[id].RequiredPin}, stashes[id].StashEntry)
                end
            end
        end
    end
end, false)

RegisterNetEvent('np-stash:getnearstash')
AddEventHandler('np-stash:getnearstash', function()
    local closestDoorDistance, closestDoorId = 9999.9, -1
    local currentPos = GetEntityCoords(PlayerPedId())
    for id, handle in pairs(stashes) do
        local currentDoorDistance = #(stashes[id].StashEntry - currentPos)
        if handle and currentDoorDistance < closestDoorDistance then
            closestDoorDistance = currentDoorDistance
            closestDoorId = id
            if closestDoorId ~= -1 then
                if stashes[closestDoorId].distance > closestDoorDistance then
                    print(stashes[closestDoorId])
                    secureWarehouseEnter(stashes[closestDoorId])
                end
            end
        end
    end
end, false)


RegisterCommand('opencodegui', function()
    local owner_pin = 1234
    local guest_pin = 1234
    TriggerEvent('OpenCodeEntryGUI', {owner_pin, guest_pin})
end, false)


local function openCodeGui(pRequiredPin, coords)
    gui = true;
    SetNuiFocus(true, true);
    SendNUIMessage({openPinPad = true, requiredPins = pRequiredPin, coords = coords});
end

local function CloseGui()
    currentlyInGame = false;
    gui = false;
    SetNuiFocus(false, false);
    SendNUIMessage({openPinPad = false});
end

AddEventHandler("OpenCodeEntryGUI", function(requiredPin, coords)
    openCodeGui(requiredPin, coords);
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
    CloseGui();
    cb('ok');
end)

RegisterNUICallback('failure', function(data, cb)
    CloseGui();
    cb('ok');
end)

RegisterNUICallback('complete', function(data, cb)
    CloseGui();
    print(json.encode(data), cb)
    cb('ok');
    TriggerEvent('np-stash:getnearstash')
end)

RegisterCommand('fixblack', function()
    DoScreenFadeIn(1000)
    TriggerServerEvent("npstash:RequestStashHouses");
end)

function secureWarehouseEnter(closeststashid)
    local metd = `stashhouse1_shell`
    RequestModel(metd)
    while not HasModelLoaded(metd) do
        Citizen.Wait(0)
        print('no load')
    end
    print('coords', closeststashid.StashEntry.x, closeststashid.StashEntry.y)
    warehouse = CreateObject(GetHashKey("stashhouse1_shell"), closeststashid.StashEntry.x, closeststashid.StashEntry.y, -72.61, false, false, false)
    FreezeEntityPosition(warehouse, true)
    instash = closeststashid
    isinstash = true
    local targetPed = GetPlayerPed(-1)
    if(IsPedInAnyVehicle(targetPed))then
    targetPed = GetVehiclePedIsUsing(targetPed)
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityHeading(PlayerPedId(), 88.27)
    SetEntityCoordsNoOffset(targetPed, closeststashid.StashEntry.x + 18, closeststashid.StashEntry.y - 0.5, -53.0, 0, 0, 1)
    Wait(1000)
    DoScreenFadeIn(1000)
    else
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), closeststashid.StashEntry.x + 20, closeststashid.StashEntry.y - 0.5, -53.0)
    Wait(1000)
    DoScreenFadeIn(1000)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if isinstash == true then
            local playerPos = GetEntityCoords(PlayerPedId())
            local targetPos = vector3(instash.StashEntry.x - 19.13, instash.StashEntry.y + 1.66, -53.00)
            local distance = #(playerPos - targetPos)
            if distance < 5 then
                DrawText3Ds(instash.StashEntry.x - 19.13, instash.StashEntry.y + 1.66, -53.00, '~g~E~w~ - open stash')
                if IsControlJustReleased(0, 38) then
                    local cid = exports["isPed"]:isPed("cid")
                    TriggerEvent("server-inventory-open", "1", 'StashHouse-' .. instash.ID)
                end
            end
        else
            Wait(5000)
        end
    end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if isinstash == true then
            local playerPos = GetEntityCoords(PlayerPedId())
            local targetPos = vector3(instash.StashEntry.x + 17.95, instash.StashEntry.y + 1, -53.0)
            local distance = #(playerPos - targetPos)
            if distance < 5 then
                DrawText3Ds(instash.StashEntry.x + 20, instash.StashEntry.y - 0.5, -53.0, '~g~E~w~ - leave stash')
                if IsControlJustReleased(0, 38) then
                    local targetPed = GetPlayerPed(-1)
                    if(IsPedInAnyVehicle(targetPed))then
                    targetPed = GetVehiclePedIsUsing(targetPed)
                    DoScreenFadeOut(1000)
                    Wait(1000)
                    SetEntityCoordsNoOffset(targetPed, instash.StashEntry.x, instash.StashEntry.y, instash.StashEntry.z, -53.0, 0, 0, 1)
                    Wait(1000)
                    DoScreenFadeIn(1000)
                    else
                    DoScreenFadeOut(1000)
                    Wait(1000)
                    SetEntityCoords(PlayerPedId(), instash.StashEntry.x, instash.StashEntry.y, instash.StashEntry.z)
                    secureWareHouseleave()
                    Wait(1000)
                    DoScreenFadeIn(1000)
                    end
                end
            end
        else
            Wait(2000)
        end
    end
end)


function secureWareHouseleave()
    isinstash = false
    DeleteObject(warehouse)
    FreezeEntityPosition(warehouse, false)
end

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end


RegisterCommand('stashadd', function(source,args)
    local plycoords = GetEntityCoords(PlayerPedId())
    local pin = args[1]
    local id = args[2]
    local distance = args[3]
    TriggerServerEvent('stashesaddtoconfig', plycoords, pin, id, distance)
end)

-- Chat suggestion
Citizen.CreateThread(function()
    TriggerEvent("chat:addSuggestion", "/stashadd", "Create a stash", {
        {name = "pin", help = "Pin Code"},
        {name = "id", help = "Stash ID"},
        {name = "distance", help = "Distance to click open keypad"},
    })
end)

RegisterKeyMapping('getnearstash', 'Enter', 'keyboard', 'e')