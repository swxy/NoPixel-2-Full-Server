
-----Power Tracking---

local City_Power_State = true -- main city's power plate    
local Prison_Power_State =  true
local Paleto_Power_State = true
local total = 0

------------------------

local VaultDoor = false

-----Prison Break Tracking-------
local Prison_Electric_State = true
local Prison_Physical_State = true
---------------------------------

----------Alarm Tracking---------

local alarms = {["CPower"] = false, ["PPower"] = false, ["prison"] = false, ["bank"] = false, ["PApaleto"] = false, ["paleto"] = false}

-----------------------------------

---------Reset Tracking------------

local areaReset = {["bank"] = false, ["Prision"] = false, ["PPower"] = false, ["CPower"] = false, ["PApaleto"] = false, ["paleto"] = false }

-----------------------------------

Area_Prision = "prisionArea"
Area_PowerCity = "cityArea"
Area_PowerPrision = "powPrisonArea"
Area_Bank = "mainBankArea"
Area_Paleto = "paletBank"
Area_Jewl = "jewlArea"

-- local markers = {}

local markers = {
    [1]  = { attachedDoor = 74, dropChance = 0, toolType = "physicalPick", group = "mainBank", zone = "pacific", pos =  vector3(256.5196, 219.7890, 106.28), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 5, [2] = 1, [3] = 3, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [2]  = { attachedDoor = 76, dropChance = 0, toolType = "cardedlock2", group = "mainBank", zone = "pacific", pos =  vector3(261.7722, 223.3470, 106.28), difficulty = {kit = {[1] = 5, [2] = 15}, thermite = {[1] = 5, [2] = 1, [3] = 3, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [3]  = { attachedDoor = nil, dropChance = 0, toolType = "cardedlock2", group = "mainBank", zone = "pacific", pos =  vector3(253.5149, 228.3643, 101.68), difficulty = {kit = {[1] = 5, [2] = 15}, thermite = {[1] = 5, [2] = 1, [3] = 3, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [4]  = { attachedDoor = nil, dropChance = 0, toolType = "cardedlock", group = "mainBank", zone = "pacific", pos =  vector3(254.1452, 225.7106, 101.87), difficulty = {kit = {[1] = 5, [2] = 15}, thermite = {[1] = 5, [2] = 1, [3] = 3, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [5]  = { attachedDoor = 77, dropChance = 0, toolType = "physicalThermite", group = "mainBank", zone = "pacific", pos =  vector3(252.9976, 221.5834, 101.68), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 5, [2] = 1, [3] = 3, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [6]  = { attachedDoor = 78, dropChance = 1, toolType = "airLock", group = "mainBank", zone = "pacific", pos =  vector3(257.8968, 214.5024, 101.68), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 5, [2] = 1, [3] = 3, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [7]  = { attachedDoor = nil, dropChance = 1, toolType = "airLock", group = "mainBank", zone = "pacific", pos =  vector3(259.3956, 218.0461, 101.68), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 5, [2] = 1, [3] = 3, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [8]  = { attachedDoor = nil, dropChance = 0, toolType = "physicalThermite", group = "mainBank", zone = "pacific", pos =  vector3(260.9788, 215.2981, 101.68), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 5, [2] = 1, [3] = 3, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [9]  = { attachedDoor = nil, dropChance = 1, toolType = "airLock", group = "mainBank", zone = "pacific", pos =  vector3(264.5987, 215.9601, 101.68), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 5, [2] = 1, [3] = 3, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [10] = { attachedDoor = nil, dropChance = 1, toolType = "airLock", group = "mainBank", zone = "pacific", pos =  vector3(265.9152, 213.6485, 101.68), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 5, [2] = 1, [3] = 3, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [11] = { attachedDoor = nil, dropChance = 1, toolType = "airLock", group = "mainBank", zone = "pacific", pos =  vector3(263.5963, 212.2665, 101.68), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 5, [2] = 1, [3] = 3, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    -- up stairs, 
    [12] = { attachedDoor = 75, dropChance = 0, toolType = "physicalPick", group = "mainBank", zone = "pacific", pos =  vector3(265.6708, 216.8966, 110.28), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 5, [2] = 1, [3] = 3, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    -- ^^ bank

    [13]  = { attachedDoor = nil, dropChance = 0, toolType = "physicalThermite", group = "Prison_Power", zone = "power", pos = vector3(2752.080, 1465.003, 49.05), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 5, [2] = 1, [3] = 3, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [14]  = { attachedDoor = nil, dropChance = 0, toolType = "physicalThermite", group = "Prison_Power", zone = "power", pos = vector3(2792.160, 1482.197, 24.53), difficulty = {kit = {[1] = 5, [2] = 5}, thermite = {[1] = 4, [2] = 1, [3] = 4, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [15]  = { attachedDoor = nil, dropChance = 0, toolType = "physicalThermite", group = "Prison_Power", zone = "power", pos = vector3(2800.542, 1513.992, 24.53), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 6, [2] = 1, [3] = 4, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [16]  = { attachedDoor = nil, dropChance = 0, toolType = "physicalThermite", group = "Prison_Power", zone = "power", pos = vector3(2809.443, 1547.166, 24.53), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 3, [2] = 2, [3] = 5, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [17]  = { attachedDoor = nil, dropChance = 0, toolType = "physicalThermite", group = "Prison_Power", zone = "power", pos = vector3(2862.568, 1510.230, 24.56), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 4, [2] = 2, [3] = 5, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [18]  = { attachedDoor = nil, dropChance = 0, toolType = "physicalThermite", group = "Prison_Power", zone = "power", pos = vector3(2744.313, 1505.682, 45.29), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 6, [2] = 2, [3] = 6, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    -- ^^ Power Plant
    [19] = { attachedDoor = 10, dropChance = 0, toolType = "electricLock", group = "prisonGates", zone = "prison-gate", pos = vector3(1847.178, 2604.627, 45.580), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 6, [2] = 2, [3] = 6, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [20] = { attachedDoor = 11, dropChance = 0, toolType = "electricLock", group = "prisonGates", zone = "prison-gate", pos = vector3(1820.380, 2604.660, 45.577), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 6, [2] = 2, [3] = 6, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [21] = { attachedDoor = nil, dropChance = 0, toolType = "physicalThermite", group = "prisonGates", zone = "Prison_Power", pos = vector3(1773.5163574219,2677.4765625,45.609825134277), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 6, [2] = 2, [3] = 6, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [22] = { attachedDoor = nil, dropChance = 0, toolType = "physicalThermite", group = "prisonGates", zone = "Prison_Power", pos = vector3(1711.0855712891,2695.517578125,45.617862701416), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 6, [2] = 2, [3] = 6, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [23] = { attachedDoor = nil, dropChance = 0, toolType = "physicalThermite", group = "prisonGates", zone = "Prison_Power", pos = vector3(1650.7602539063,2669.0627441406,45.621654510498), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 6, [2] = 2, [3] = 6, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    [24] = { attachedDoor = nil, dropChance = 0, toolType = "electricLock", group = "prisonGates", zone = "prison-gate", pos = vector3(1643.7260742188,2585.3349609375,45.564884185791), difficulty = {kit = {[1] = 1, [2] = 1}, thermite = {[1] = 6, [2] = 2, [3] = 6, [4] = 400}, lockpicking = {[1] = 1, [2] = 1, [3] = 1, [4] = 1}}},
    -- 24 de ai:isJailBreak triggerliyor -1 için
}

-------------------------------------
local flags = {}
local CURRENT_CARD_PALETO = 1
local CURRENT_CARD_CITY = 1

function generateFlags()
    for k,v in pairs(markers) do
        flags[k] = {}
        flags[k].isFinished = false
        flags[k].toolUsed = 0
        flags[k].inUse = false
        flags[k].time = os.time()

    end
    CURRENT_CARD_PALETO = math.random(1,5)
    CURRENT_CARD_CITY = math.random(1,5)
end
generateFlags()

RegisterServerEvent('robbery:lolo2')
AddEventHandler('robber:lolo2', function()
    TriggerClientEvent('robbery:sendMarkers', -1, markers)
end)

Citizen.CreateThread(function()
    while true do
        TriggerClientEvent('robbery:sendMarkers', -1, markers)
        Citizen.Wait(10000)
    end
end)


RegisterNetEvent('robbery:spawnaids')
AddEventHandler('robbery:spawnaids', function()
    TriggerClientEvent('robbery:aids', -1)
end)

RegisterNetEvent('robbery:triggerItemUsedServer')
AddEventHandler('robbery:triggerItemUsedServer', function(itemid)
   -- print("used "..itemid)
    local activePolice = 5
    local src = source
    TriggerClientEvent('robbery:triggerItemUsed',src,itemid,activePolice)
end)

RegisterNetEvent('robbery:inUse')
AddEventHandler('robbery:inUse', function(locationID, state)
    flags[locationID].inUse = state
    TriggerClientEvent('robbery:sendFlags', -1, flags)
end)

RegisterNetEvent('inv:playerSpawnedTest')
AddEventHandler('inv:playerSpawnedTest', function()
    local src = source
    TriggerClientEvent('robbery:sendMarkers', src, markers, particlePos,markerDifficult)
    TriggerClientEvent('robbery:sendFlags', src, flags)
end)

RegisterNetEvent('robbery:robberyFailed')
AddEventHandler('robbery:robberyFailed', function(locationID, itemid)

    flags[locationID].toolUsed = itemsid
    flags[locationID].inUse = false
    flags[locationID].isFinished = false

    TriggerClientEvent('robbery:sendFlags', -1, flags)
end)

-- RegisterCommand('fuck', function()
--     TriggerClientEvent('robbery:sendServerFlags', -1, Prison_Electric_State,Prison_Physical_State,false,Prison_Power_State,true,Paleto_Power_State,CityCard,PaletoCard)
-- end)



RegisterCommand('setstate', function()
    TriggerClientEvent('robbery:sendServerFlags', -1, false,Prison_Physical_State,false,false,door,false,false,false)
    end)

RegisterNetEvent("robbery:robberyFinished")
AddEventHandler("robbery:robberyFinished", function(locationID, ToolType, itemid)
    local src = source

        print(locationID)

    marker = markers[locationID]

    flags[locationID].toolUsed = itemid
    flags[locationID].inUse = false
    flags[locationID].isFinished = true
    flags[locationID].time = os.time()
    if marker.connected ~= nil and marker.connected ~= 0 then
        flags[marker.connected].inUse = false
        flags[marker.connected].isFinished = true
        flags[marker.connected].time = os.time()
    end
    TriggerClientEvent('robbery:sendFlags',-1,flags)


    print(locationID)

    ----checking over end state function

   -- print("door id: "..marker.attachedDoor)
    if marker.attachedDoor ~= nil and marker.attachedDoor ~= 0 and marker.attachedDoor ~= -22 then 
       -- print("i am about to unlock the door rn bud")
        print('should be opening vault')
        TriggerEvent('np-doors:ForceLockState', marker.attachedDoor, 0) end
    if marker.attachedDoor ~= nil and marker.attachedDoor == -22 then end
    if locationID > 36 and locationID < 40 then
        TriggerClientEvent("player:receiveItem",src,"markedbills",math.random(10,50))
        if math.random(100) > 70 then
            TriggerClientEvent("player:receiveItem",src,"Gruppe6Card22", 1)
        end
        return
    end
    if locationID == 4 then
        TriggerClientEvent("robbery:sendServerFlags",-1,Prison_Electric_State,Prison_Physical_State,City_Power_State,Prison_Power_State,true,Paleto_Power_State,CityCard,PaletoCard)
        return
    end
    if marker.dropChance ~= 0 or marker.dropChance ~= 0 then
        if math.random(2) == 2 then
            TriggerClientEvent("player:receiveItem",src,"markedbills", math.random(10,50))
        else
            TriggerClientEvent("player:receiveItem",src,"inkedmoneybag", math.random(1,2))
        end


        if marker.group == "Prison_Power" or marker.group == CITY_POWER or marker.group == PALETO_POWER then end
        if marker.group == "PRISON_PHYSICAL" or marker.group == "Prison_Electric" then updatePrisonBreak() end
        if locationID == 36 then 
          --  print("all done")
            TriggerEvent("ai:startPrisonBreak", src) end
    end
end)

function updatePrisonBreak()
    local isElectric = true
    local isPhysical = true
    
    for k,v in pairs(markers) do
        if v.group == "Prison_Power" then
            if not flags[k].isFinished then isElectric = false end
        end

        if v.group == "Prison_Physical" then
            if not flags[k].isFinished then isPhysical = false end
        end

        if k >= 27 and k <= 36 then
            if flags[k].isFinished then
                lockdown()
            end
        end
    end

    Prison_Electric_State = isElectric
    Prison_Physical_State = isPhysical
    TriggerClientEvent("robbery:sendServerFlags",-1,Prison_Electric_State,Prison_Physical_State,City_Power_State,Prison_Power_State,door,Paleto_Power_State,CityCard,PaletoCard)
end

function updatePower()
    local isPrisonValid = true
    local isCityValid = true
    local isPaletoValid = true
    
    for k,v in pairs(markers) do
        if v.group == "Prison_Power" then
            if not flags[k].isFinished then isPrisonValid = false end
        end

        if v.group == "City_Power" then
            if not flags[k].isFinished then isCityValid = false end
        end

        if v.group == "Paleto_Electric" then
            if not flags[k].isFinished then isPaletoValid = false end
        end
    end
end

function electricDisable(GroupType)
    for k,v in pairs(markers) do
        if v.group == GroupType and v.ToolType == ELECTRICAL_LOCK then
            flags[k].isFinished = true
            flags[k].toolUsed = 0
            flags[k].inUse = false
            if v.attachedDoor ~= nil and v.attachedDoor ~= -22 and v.attachedDoor ~= 0 then
                TriggerClientEvent("np-doors:ForceLockState",v.attachedDoor,0)
            end
        end
    end
end

function lockdown()
    TriggerClientEvent("jail:lockdown", -1, true)
    TriggerEvent("np-doors:ForceLockState",211,1)
    TriggerEvent("np-doors:ForceLockState",212,1)
    TriggerEvent("np-doors:ForceLockState",213,1)
    TriggerEvent("np-doors:ForceLockState",214,1)
end

function endLockdown()
    TriggerClientEvent("jail:lockdown", -1, false)
    TriggerEvent("np-doors:ForceLockState",211,0)
    TriggerEvent("np-doors:ForceLockState",212,0)
    TriggerEvent("np-doors:ForceLockState",213,0)
    TriggerEvent("np-doors:ForceLockState",214,0)
end

function CheckLargeBanks()
    for k,v in pairs(markers) do
        if v.attachedDoor ~= nil and v.attachedDoor ~= -22 and v.attachedDoor ~= 0 then
            if not flags[k].isFinished and not exports["np-doors"]:isDoorLocked(v.attachedDoor) then
                TriggerEvent("np-doors:ForceLockState", v.attachedDoor,1)
            end
        end
        if flags[k].time ~= 0 and (os.time() - flags[k].time) > 5400 then
           resetArea(k)
        end
    end

    TriggerClientEvent('robbery:sendFlags', -1, flags)
    TriggerClientEvent('robbery:sendServerFlags',-1,Prison_Electric_State,Prison_Physical_State,City_Power_State,Prison_Power_State,door,Paleto_Power_State,CityCard,PaletoCard)
    areaReset = {["bank"] = false, ["Prision"] = false, ["PPower"] = false, ["CPower"] = false, ["PApaleto"] = false, ["paleto"] = false }
    SetTimeout(1200000, CheckLargeBanks)
end
  
SetTimeout(18000, CheckLargeBanks)

function resetArea(locationID)
    if locationID >= prisonIndexStart or locationID <= prisonIndexEnd then
        endLockDown()
    end
end

-- RegisterServerEvent('np-robbery:checkflag')
-- AddEventHandler('np-robbery:checkflag', function(data)
--     -- Prison_Power
--     local check = false
--     local marker = markers[data]
--     if marker.group == "Prison_Power" then
--         for k, v in pairs(markers) do
--             if v.group == "PrisonPower" and flags[data].isFinished == false then
--                 check = true
--                 print("it was true")
--             end
--         end
--         if not check then
--             Prison_Power_State = false
--             TriggerClientEvent("robbery:sendServerFlags",-1,Prison_Electric_State,Prison_Physical_State,City_Power_State,Prison_Power_State,door,Paleto_Power_State,CityCard,PaletoCard)
--         end
--     end
-- end)

RegisterServerEvent('np-robbery:checkflag')
AddEventHandler('np-robbery:checkflag', function()
    -- Prison_Power
   total = total + 1
  -- print(total)

   if total == 6 then
   -- print(total)
    Prison_Power_State = false
    TriggerClientEvent("robbery:sendServerFlags",-1,Prison_Electric_State,Prison_Physical_State,City_Power_State,Prison_Power_State,door,Paleto_Power_State,CityCard,PaletoCard)
   end

   if total >= 12 then
        TriggerClientEvent("ai:isJailBreak", -1)
    end
end)


RegisterServerEvent('robbery:alarmTrigger')
AddEventHandler('robbery:alarmTrigger', function(locationID)
    local src = source
    local marker = markers[locationID]
    if marker.group == "Prison_Power" then
        -- print('cuck')
        TriggerClientEvent('powerplant:alert', src)
        alarms["PPower"] = true
    elseif marker.group == "mainBank" then
        TriggerClientEvent('vault:alert', src)
        -- TriggerEvent('OfficerEMSDown')
        -- TriggerClientEvent('dispatch:clNotify',-1,{ dispatchCode = "10-90", callSign = data.callSign, dispatchMessage = "Disturbance at the Power Plant", firstStreet = 'Power Plant', recipientList = recipientList, playSound = false, soundName = "10-1314", isImportant = false, priority = 3, origin = data.origin, blipSprite = blipSprite, blipColor = blipColor})
    end
end)

function resetArea(locationID)
    local marker = markers[locationID]

    local resetArea = ""
    local resetLockdown = false

    if marker.group == MAIN_BANK and not areaReset["bank"] then
        resetArea = "bank"
        CURRENT_CARD_PALETO = math.random(1,5)
    elseif marker.group == CITY_POWER and not areaReset["CPower"] then
        resetArea = "CPower"
    elseif marker.group == PALETO_POWER and not areaReset["PApaleto"] then
        resetArea = "PApaleto"
    elseif marker.group == PALETO_BANK and not areaReset["paleto"] then
        resetArea = "paleto"
        CURRENT_CARD_CITY = math.random(1,5)
    elseif marker.group == "Prison_Power" and not areaReset["PPower"] then
        resetArea = "PPower"
    elseif (marker.group == PRISON_GATES or marker.group == PRISON_ELECTRIC or marker.group == "Prison_Physical" or marker.group == PRISON_FINAL) and not areaReset["Prision"] then
        resetArea = "Prision"
    else
        return
    end

    for k,v in pairs(markers) do
        local resetFlags = false
        if resetArea == "bank" and v.group == MAIN_BANK then resetFlags = true VaultDoor = false end
        if resetArea == "CPower" and v.group == CITY_POWER then resetFlags = true City_Power_State = true end
        if resetArea == "PPower" and v.group == "Prison_Power" then resetFlags = true Prison_Power_State = true end
        if resetArea == "PApaleto" and v.group == PALETO_POWER then resetFlags = true Paleto_Power_State = true end

        if resetFlags == "paleto" and v.group == PALETO_BANK then resetFlags = true end

        if resetArea == "Prision" and (v.group == PRISON_GATES or v.group == PRISON_ELECTRIC or v.group == "Prison_Physical" or v.group == PRISON_FINAL) then
            resetFlags = true
            Prison_Electric_State = false
            Prison_Physical_State = false
            if not resetLockdown then
            endLockDown()
            reseLockdown = true
            end
        end

        if resetFlags then
            flags[k].isFinished = false
            flags[k].toolUsed = 0
            flags[k].inUse = false
            flags[k].time = os.time()

        end
    end

    resetLockdown = false
    areaReset[resetArea] = true
end