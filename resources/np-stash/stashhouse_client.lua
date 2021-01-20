local gui = false;
local currentlyInGame = false;
local currentStash;
local isInStash = false;
local stashDataLoaded = false;
local closestStashDistance = 10000;
local playerCoords;
local playerId;
local stashShell = {};

local stagePosition = {
    x = 619.5334, 
    y = 622.9099,
    z = -116.9932,
}

local stageGaragePosition = {
    x = 627.9164,
    y = 633.8272,
    z = -113.2648,
}

local maxLoadRetries = 5

local stashPoints = {}

local stashTier = {}
stashTier[1] = `ghost_stash_house_01`
stashTier[2] = `ghost_stash_house_03`

-- Startup code
Citizen.CreateThread( function()
     -- Wait for player spawn to get id
    while not playerId
    do
        Citizen.Wait(1000);
    end;

    -- Update player position
    while true
    do
        playerId = PlayerPedId()
        playerCoords = GetEntityCoords(playerId);
        Citizen.Wait(1000);
    end;
end)

AddEventHandler('playerSpawned', function(spawn)
    local retry = 1
    -- Load Stash Points
    while #stashPoints == 0
    do
        TriggerServerEvent("npstash:RequestStashHouses");
        Citizen.Wait(10000 * retry);
        retry = retry + 1
        if (retry > maxLoadRetries)
        then
            return
        end

    end
    playerId = PlayerPedId();
end)



-- Main code for checking external doors
Citizen.CreateThread(function()
    -- Wait for startup tasks
    while not playerCoords or not playerId
    do
        Citizen.Wait(1000);
    end

    -- Main loop for stash house entrance checks
    while true do
        local distanceToEntrance = 100;
        local distanceToGarage = 100;

        for i = 1, #stashPoints do
            stashHouse = stashPoints[i];
            distanceToEntrance = #(playerCoords - vector3(stashHouse.x, stashHouse.y, stashHouse.z));
            distanceToGarage = GetDistanceBetweenCoords(stashHouse.g_x,stashHouse.g_y,stashHouse.g_z, playerCoords, true)

            if distanceToEntrance < 3 and distanceToEntrance > 0
            then
                closestStashDistance = distanceToEntrance
                if (IsControlJustReleased(1, 38))
                then
                    secureWarehouseAttemptEnter(false)
                end
                break       
            elseif distanceToGarage < 5 then
                closestStashDistance = distanceToGarage
                if IsControlJustReleased(2, 38) then
                    local plyVeh = GetVehiclePedIsIn(playerId, false)
                    if plyVeh ~= 0 and plyVeh ~= nil
                    then
                        local drvPed = GetPedInVehicleSeat(plyVeh, -1)
                        if drvPed == playerId
                        then
                            secureWarehouseAttemptEnter(true)
                        end
                    end
                end
                break
            else
                if distanceToEntrance < closestStashDistance
                then
                    closestStashDistance = distanceToEntrance;
                end
            end
        end
        if closestStashDistance ~= nil and (closestStashDistance > 3)
        then
            Citizen.Wait(closestStashDistance * 20);
        end
        Citizen.Wait(2);
    end
end)

function secureWarehouseAttemptEnter(pUseGarage)
    currentStash = stashHouse;
    currentStash.admin = false;
    currentStash.useGarage = pUseGarage
    TriggerEvent("OpenCodeEntryGUI", {currentStash.owner_pin, currentStash.guest_pin});
    TriggerServerEvent("npstash:log", currentStash.id, "Attempted Secure Warehouse Entry")
end

function secureWarehouseEnter()
    isInStash = true;
    local playerId = PlayerPedId();
    plyObject = currentStash.useGarage and GetVehiclePedIsIn(playerId, false) or playerId
    DoScreenFadeOut(1000);
    while IsScreenFadingOut() do
        Citizen.Wait(100);
    end
 
    TriggerServerEvent("npstash:log", currentStash.id, "Secure Warehouse Ent")

    if plyObject ~= 0 and plyObject ~= nil
    then
        SetEntityCoords(plyObject, stageGaragePosition.x - 29.3069, stageGaragePosition.y + 8.7816, stageGaragePosition.z + 0.1);
        SetEntityHeading(plyObject,270.0);
        FreezeEntityPosition(plyObject, true);
    else
        return;
    end

    Citizen.Wait(1000);
    RequestModel(stashTier[currentStash.tier]);

    while not HasModelLoaded(stashTier[currentStash.tier])
    do
        Citizen.Wait(1000);
    end

    if not IsEntityAnObject(stashShell[currentStash.id])
    then
        stashShell[currentStash.id] = CreateObject((stashTier[currentStash.tier]), currentStash.x, currentStash.y, -55.01, 0, 0, 0);
        FreezeEntityPosition(stashShell[currentStash.id], true);
    end

    if currentStash.useGarage
    then
        SetEntityCoords(plyObject, currentStash.x - 29.3069, currentStash.y + 8.7816, -55.02);
        SetEntityHeading(plyObject,270.0);
    else
        SetEntityCoords(plyObject, currentStash.x + 6.30, currentStash.y - 3.50, -54.54);
        SetEntityHeading(plyObject, 90.0001);
    end

    FreezeEntityPosition(plyObject, false);

    DoScreenFadeIn(2000);
    while IsScreenFadingIn() do
        Citizen.Wait(100);
    end
end

function secureWarehouseExit()
    playerId = PlayerPedId();
    plyObject = currentStash.useGarage and GetVehiclePedIsIn(playerId, false) or playerId

    if currentStash.useGarage
    then
        local plyVeh = GetVehiclePedIsIn(playerId, false)
        if plyVeh == 0 or plyVeh == nil
        then
            return;
        end

        local drvPed = GetPedInVehicleSeat(plyVeh, -1)
        if drvPed ~= playerId
        then
            return;
        end
    end


    DoScreenFadeOut(1000);
    while IsScreenFadingOut() do
        Citizen.Wait(10);
    end
    if currentStash.useGarage
    then
        SetEntityCoords(plyObject, currentStash.g_x, currentStash.g_y, currentStash.g_z);
        SetEntityHeading(plyObject,currentStash.g_h);
    else
        SetEntityCoords(PlayerPedId(), currentStash.x, currentStash.y, currentStash.z - 0.2);
        SetEntityHeading(PlayerPedId(), currentStash.h);
    end
    isInStash = false;
    FreezeEntityPosition(plyObject, false);

    --SetEntityAsNoLongerNeeded(stashShell[currentStash.id]);
    --DeleteObject(stashShell[currentStash.id]);
    Citizen.Wait(500);

    Wait(100);
    DoScreenFadeIn(1000);
    while IsScreenFadingIn() do
        Citizen.Wait(100);
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        while isInStash
        do
            if currentStash.x ~= nil and #(playerCoords - vector3(currentStash.x + 6.72, currentStash.y - 3.92, -55.01)) < 3 then
                if (IsControlJustReleased(1, 38)) then
                    currentStash.useGarage = false
                    secureWarehouseExit()
                    TriggerServerEvent("npstash:log", currentStash.id, "Left Secure Warehouse - Door")
                    break
                end
            elseif currentStash.x ~= nil and #(playerCoords - vector3(currentStash.x - 29.3069, currentStash.y + 8.7816, -55.01)) < 5 then
                if (IsControlJustReleased(2, 38)) then
                    currentStash.useGarage = true
                    secureWarehouseExit()
                    TriggerServerEvent("npstash:log", currentStash.id, "Left Secure Warehouse - Garage")
                    break
                end
            elseif currentStash.x ~= nil and #(playerCoords - vector3(currentStash.x - 6.3043, currentStash.y - 3.87, -54.00)) < 3 then
                if (IsControlJustReleased(1, 38)) then
                    local cid = exports["isPed"]:isPed("cid")
                    if ((cid == currentStash.owner_cid) or (currentStash.admin))
                    then
                        TriggerServerEvent("npstash:log", currentStash.id, "Opened Secure Warehouse Stash")
                        TriggerEvent("server-inventory-open", "1", "securewarehouse" .. currentStash.tier .."-" .. currentStash.id)
                    end
                end             
            end
            Citizen.Wait(10)
        end
    end
end)

RegisterNetEvent("npstash:checkStashId")
AddEventHandler("npstash:checkStashId", function(pStashHouses)
    if (currentStash.id)
    then
        if currentStash.id
        then
            TriggerEvent("DoLongHudText", 'Stash House Id: ' .. currentStash.id, 155)
        else
            TriggerEvent("DoLongHudText", 'You must be in a stash to check the id.', 155)
        end
    end
end)

RegisterNetEvent("npstash:updateStashHouses")
AddEventHandler("npstash:updateStashHouses", function(pStashHouses)
    stashPoints = pStashHouses;
    stashDataLoaded = true;
end)

RegisterNetEvent("npstash:requestPlayerPosition")
AddEventHandler("npstash:requestPlayerPosition", function(pData, pCallBack)
    playerId = PlayerPedId();
    playerCoords = GetEntityCoords(playerId);
    if pCallBack ~= nil
    then
        TriggerServerEvent(pCallBack, playerCoords, GetEntityHeading(playerId), pData);
    else
        TriggerServerEvent("npstash:requestStashCreate", playerCoords, GetEntityHeading(playerId), pData);
    end
end)

local function openCodeGui(pRequiredPin)
    gui = true;
    SetNuiFocus(true, true);
    SendNUIMessage({ openPinPad = true, requiredPins = pRequiredPin });
end

local function CloseGui()
    currentlyInGame = false;
    gui = false;
    SetNuiFocus(false, false);
    SendNUIMessage({ openPinPad = false });
end

AddEventHandler("OpenCodeEntryGUI", function(requiredPin)
    openCodeGui(requiredPin);
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
    CloseGui();
    cb('ok');
end)

RegisterNUICallback('failure', function(data, cb)
    CloseGui();
    cb('ok');
    TriggerEvent("DoLongHudText", 'Incorrect PIN', 155);
end)

RegisterNUICallback('complete', function(data, cb)
    CloseGui();
    cb('ok');
    currentStash.admin = data.owner;
    secureWarehouseEnter();
end)
