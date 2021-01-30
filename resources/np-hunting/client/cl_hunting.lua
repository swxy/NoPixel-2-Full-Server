local validHuntingZones = nil
local animals = nil
local baitDistanceInUnits = nil
local spawnDistanceRadius = nil

local baitLocation = nil
local baitLastPlaced = 0
local targetedEntity = nil

DecorRegister("HuntingMySpawn", 2)
DecorRegister("HuntingIllegal", 2)

Citizen.CreateThread(function()
    local result = RPC.execute("np-hunting:getSettings")
    animals = result.animals
    baitDistanceInUnits = result.baitDistanceInUnits
    spawnDistanceRadius = result.spawnDistanceRadius
    validHuntingZones = result.validHuntingZones
end)

AddEventHandler("np:target:changed", function(pEntity)
    targetedEntity = pEntity
end)

local function isValidZone()
    return validHuntingZones[GetLabelText(GetNameOfZone(GetEntityCoords(PlayerPedId())))] == true
end

local function getSpawnLoc()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local spawnCoords = nil
    while spawnCoords == nil do
        local spawnX = math.random(-spawnDistanceRadius, spawnDistanceRadius)
        local spawnY = math.random(-spawnDistanceRadius, spawnDistanceRadius)
        local spawnZ = baitLocation.z
        local vec = vector3(baitLocation.x + spawnX, baitLocation.y + spawnY, spawnZ)
        if #(playerCoords - vec) > spawnDistanceRadius then
            spawnCoords = vec
        end
    end
    local worked, groundZ, normal = GetGroundZAndNormalFor_3dCoord(spawnCoords.x, spawnCoords.y, 1023.9)
    spawnCoords = vector3(spawnCoords.x, spawnCoords.y, groundZ)
    return spawnCoords
end

local function spawnAnimal(loc)
    local chance = math.random()
    local foundAnimal = false
    for _, animal in pairs(animals) do
        if foundAnimal == false and animal.chance > chance then
            foundAnimal = animal
        end
    end
    local modelName = foundAnimal.model
    RequestModel(modelName)
    while not HasModelLoaded(modelName) do
        Citizen.Wait(0)
    end
    local spawnLoc = getSpawnLoc()
    local spawnedAnimal = CreatePed(28, foundAnimal.hash, spawnLoc, true, true, true)
    DecorSetBool(spawnedAnimal, "HuntingMySpawn", true)
    DecorSetBool(spawnedAnimal, "HuntingIllegal", foundAnimal.illegal)
    SetModelAsNoLongerNeeded(modelName)
    TaskGoStraightToCoord(spawnedAnimal, loc, 1.0, -1, 0.0, 0.0)
    Citizen.CreateThread(function()
        local finished = false
        while not IsPedDeadOrDying(spawnedAnimal) and not finished do
            local spawnedAnimalCoords = GetEntityCoords(spawnedAnimal)
            if #(loc - spawnedAnimalCoords) < 0.5 then
                ClearPedTasks(spawnedAnimal)
                Citizen.Wait(1500)
                TaskStartScenarioInPlace(spawnedAnimal, "WORLD_DEER_GRAZING", 0, true)
                Citizen.SetTimeout(7500, function()
                    finished = true
                end)
            end
            if #(spawnedAnimalCoords - GetEntityCoords(PlayerPedId())) < 15.0 then
                ClearPedTasks(spawnedAnimal)
                TaskSmartFleePed(spawnedAnimal, PlayerPedId(), 600.0, -1)
                finished = true
            end
            Citizen.Wait(1000)
        end
        if not IsPedDeadOrDying(spawnedAnimal) then
            TaskSmartFleePed(spawnedAnimal, PlayerPedId(), 600.0, -1)
        end
    end)
end

local function baitDown()
    Citizen.CreateThread(function()
        while baitLocation ~= nil do
            local coords = GetEntityCoords(PlayerPedId())
            if #(baitLocation - coords) > baitDistanceInUnits then
                if math.random() < 0.15 then
                    spawnAnimal(baitLocation)
                    baitLocation = nil
                end
            end
            Citizen.Wait(5000)
        end
    end)
end

AddEventHandler("np-inventory:itemUsed", function(item)
    if item == "huntingbait" then
        if not isValidZone() then
            TriggerEvent("DoLongHudText", "You can't hunt here...", 2)
            return
        end
        if baitLastPlaced ~= 0 and GetGameTimer() < (baitLastPlaced + 300000) then -- 5 minutes
            TriggerEvent("DoLongHudText", "Your nose can't take it yet...", 2)
            return
        end
        baitLocation = nil
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
        local finished = exports["np-taskbar"]:taskBar(15000, "Placing Bait")
        ClearPedTasks(PlayerPedId())
        if finished ~= 100 then
            baitLocation = nil
        end
        baitLastPlaced = GetGameTimer()
        baitLocation = GetEntityCoords(PlayerPedId())
        TriggerEvent("DoLongHudText", "Wew, pungenty...", 1)
        TriggerEvent("inventory:removeItem", item, 1)
        baitDown()
    end
    if item == "huntingknife" then
        if GetPedType(targetedEntity) ~= 28 or not IsPedDeadOrDying(targetedEntity) then
            TriggerEvent("DoLongHudText", "No animal found", 2)
            return
        end
        local myAnimal = targetedEntity
        TaskTurnPedToFaceEntity(PlayerPedId(), myAnimal, -1)
        Citizen.Wait(1500)
        ClearPedTasksImmediately(PlayerPedId())
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
        local finished = exports["np-taskbar"]:taskBar(30000, "Preparing Animal")
        if finished ~= 100 then
            ClearPedTasksImmediately(PlayerPedId())
            TriggerEvent("DoLongHudText", "Preparing Cancelled", 2)
            return
        end
        local mySpawn = DecorExistOn(myAnimal, "HuntingMySpawn") and DecorGetBool(myAnimal, "HuntingMySpawn")
        local illegalSpawn = DecorExistOn(myAnimal, "HuntingIllegal") and DecorGetBool(myAnimal, "HuntingIllegal")
        local success = RPC.execute("np-hunting:getSkinnedItem", PedToNet(myAnimal), mySpawn, illegalSpawn)
        if not success then
            TriggerEvent("DoLongHudText", "Bruh", 2)
        end
    end
end)
