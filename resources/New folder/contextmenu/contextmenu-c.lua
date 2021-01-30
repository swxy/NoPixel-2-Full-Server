--Context menu Ideas
--General
--Use -> on Entities such as Phonebooths, ATMs, chairs, benches .. etc. E.g. Right click on Chair, Sit Option -> forces sit anim on said chair or bench.
--(ATMs / Payphones would prompt another UI.)
--On vehicles - Doors -> Prompts side menu of all doors. Press one to toggle the door of your choice on selected Vehicle.
--Examine -> Can be used to give specific info of the selected Entity.
--Steal(illegal, tinted red) -> Steals money / items from current selected Ped. (Possibly steal shoes or other things as well)
--Lockpick(illegal, tinted red) -> Can be used on vehicles or possibly houses.
--
--Police
--Sub Menu option labled "Police"(tinted blue)
--Check licenses of selected target.
--Check banking.
--Remove licenses.
--Seize peds cash.
--Actions such as Escort, seat/unseat (vehicle), cuff/uncuff.
--Possible other options: impound, request tow.
--
--EMS
--Sub menu option Labled "EMS"(tinted pink?)
--Examine target -> prompts Enjuries, status effects.
--Heal -> heals the target.
--Revive -> puts a ped back on their feet.
--Escort, seat/unseat, impound
--
--Tow truck
--Sub menu option Labled "Tow"
--tow -> tows selected vehicle onto the flatbed.
--impound -> impounds the car when at the impound lot.

--Call order:
--Toggle NUI (Z default) -> index.js
--index.js contextmenu event click (right click) -> contextmenu-c.lua toggle the raytrace
--Raytrace grabs entity data, stores it locally, sends the TYPE of entity BACK to -> index.js
--index.js builds menu based of TYPE of object passed through (e.g. adds a Door submenu if the Entity is a Vehicle).
--Based on menu element selected -> contextmenu-c.lua (e.g. RegisterNUICallback("doors", function(data), sets the state of the vehicle doors)

--From Simu https://pastebin.com/ti27ZBxw
--Taso helping out with JavaScript

local entityType = 0
local toIgnore = 0
local flags = 30
local raycastLength = 50.0
local abs = math.abs
local cos = math.cos
local sin = math.sin
local pi = math.pi
local player
local playerCoords
local display = false
local z_key = 20
local startRaycast = false
-- police, tow, ems etc.
local myJob = "police" --Update this based on your own job system. This gets sent to the Javascript to add the appropriate menu items.
local isAdmin = true --Allows for the Export option which write entity data to a txt file.
local entity =
{
    target, --Entity itself
    type, --Type: Ped, vehicle, object, 0 1 2 3
    hash, --Hash of the object
    modelName, --model name
    isPlayer, --if the entity is a player = true else = false
    coords, --In world coords
    heading, --Which way the entity is Heading/facing
    rotation -- Entity rotation
}

RegisterCommand("nui", function(source, args)
    SetDisplay(not display)
end)

--Toggles the NUI
function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

--Sends over the object data(type, job, admin, isplayer) to the Javascript to determine what menus should be added to the contextmenu on creation.
function SendObjectData()
    startRaycast = false
    SendNUIMessage({
        type = "objectData",
        objectType = entity.type,
        job = myJob,
        admin = isAdmin,
        isPly = entity.isPlayer
    })
end

--These are called from the Javascript via .. $.post('http://ContextMenu/rigthclick', JSON.stringify({}));
RegisterNUICallback("rightclick", function(data)
    --toggle raycast
    startRaycast = true
end)

RegisterNUICallback("use", function(data)
    --Can be used on entities such as chairs, ATMs, phonebooths etc.
    --Grab the entity.hash compare it to a specific Object or list of objects hashes
    --If entity.hash == 94293294294 then -> open bank UI
    --EXAMPLE--
    if entity.hash == 506770882 then
        print("ATM")
        --exports["t-notify-master"]:SendTextAlert("error", "This is an ATM.", 2500, true)
    elseif entity.hash == 1158960338 then
        print("payphone")
        --exports["t-notify-master"]:SendTextAlert("error", "This is a payphone.", 2500, true)
    end
    -----------------------
    --IF entity is a player one could play an animation such as.
    if IsPedAPlayer(entity.target) then 
        local animDict = "rcmepsilonism8"
        local animName = "security_greet"
        RequestAnimDict(animDict)
        TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 0.8, 0.8, -1, 0, 0, 0, 0, 0)
    end
    -----------------------
    clearEntityData()
    SetDisplay(false)
end)

--Can be used to give info about an object such as "This trash can looks dirty."(if the object hash equals to the object hash of a trashcan / bin)
RegisterNUICallback("examine", function(data)
    if IsEntityAVehicle(entity.target) then
        chat("This is a nice car", {0,255,0})
    elseif entity.type == 1 then
        chat("That is a person :)", {0,255,0})
    elseif entity.type == 3 then 
        chat("Thats an Object :)", {0,255,0})
    end
    print(entity.modelName,entity.hash)
    clearEntityData()
    SetDisplay(false)
end)

--Only called if the object in question is a vehicle.
RegisterNUICallback("doors", function(data)
    -- doorIndex:  
    -- 0 = Front Left Door  
    -- 1 = Front Right Door  
    -- 2 = Back Left Door  
    -- 3 = Back Right Door  
    -- 4 = Hood  
    -- 5 = Trunk  
    -- 6 = Back  
    -- 7 = Back2  
    if IsEntityAVehicle(entity.target) then
        if GetVehicleDoorAngleRatio(entity.target, data.index) ~= 0 then
            if #(playerCoords - entity.coords) > 3 then
                print("to far away")
            else
                SetVehicleDoorShut(entity.target, data.index, 1)
            end
        else
            if #(playerCoords - entity.coords) > 3 then
                print("to far away")
            else
                SetVehicleDoorOpen(entity.target, data.index, 0, 1)
            end
        end
    end
    clearEntityData()
    SetDisplay(false)
end)

--Tow related
RegisterNUICallback("tow", function(data)
    --Call which ever tow scripts you have via export as an example.
    --exports["my-towscript"]:TowVehicle(entity.target) <--- example
    --Possibly trigger an Animation
    print("Towing vehicle!")
    clearEntityData()
    SetDisplay(false)
end)
RegisterNUICallback("impound", function(data)
    --Call your impound script via export.
    --exports["my-towscript"]:TowVehicle(entity.target) <--- example
    --Play an animation when impounding / towing.
    local animDict = "random@arrests"
    local animName = "generic_radio_chatter"
    RequestAnimDict(animDict)
    TaskPlayAnim(player, animDict, animName, 0.8, 0.8, -1, 0, 0, 0, 0, 0)
    print("Deleting -- ", entity.target)
    DeleteEntity(entity.target)
    clearEntityData()
    SetDisplay(false)
end)

--Police related
RegisterNUICallback("escort", function(data)
    --Call your script / code. Maybe via Exports.
    --Look at "steal" Callback. Server event to grab the player.
    --exports["my-police-script]:EscortPlayer(entity.target) <-- Example
    print("escorting")
    clearEntityData()
    SetDisplay(false)
end)
RegisterNUICallback("seatnearest", function(data)
    --Call your script / code. Maybe via Exports.
    --Look at "steal" Callback. Server event to grab the player.
    print("seat nearest")
    clearEntityData()
    SetDisplay(false)
end)
RegisterNUICallback("frisk", function(data)
    --Call your script / code. Maybe via Exports.
    --Look at "steal" Callback. Server event to grab the player.
    print("frisk")
    clearEntityData()
    SetDisplay(false)
end)
RegisterNUICallback("search", function(data)
    --Call your script / code. Maybe via Exports.
    --Look at "steal" Callback. Server event to grab the player.
    print("search")
    clearEntityData()
    SetDisplay(false)
end)
RegisterNUICallback("removemask", function(data)
    --Call your script / code. Maybe via Exports.
    --Look at "steal" Callback. Server event to grab the player.
    print("removing mask")
    clearEntityData()
    SetDisplay(false)
end)
RegisterNUICallback("checklicense", function(data)
    --Call your script / code. Maybe via Exports.
    --Look at "steal" Callback. Server event to grab the player.
    print("checking licenses")
    clearEntityData()
    SetDisplay(false)
end)
RegisterNUICallback("seizecash", function(data)
    --Call your script / code. Maybe via Exports.
    --Look at "steal" Callback. Server event to grab the player.
    print("seizing cash")
    clearEntityData()
    SetDisplay(false)
end)

--Illegal related
RegisterNUICallback("steal", function(data)
    --Call your stealing script / code. Maybe via Exports.
    --This will only be visible on PLAYER peds. AI peds dont have the steal option.
    if #(playerCoords - entity.coords) < 0.2 then
        print("close enough")
        TriggerServerEvent("stealing", entity.coords)
    end
    clearEntityData()
    SetDisplay(false)
end)
RegisterNUICallback("lockpick", function(data)
    --Call your lockpicking script / code. Maybe via Exports.
    print("lockpicking")
    clearEntityData()
    SetDisplay(false)
end)

--Utility
RegisterNUICallback("export", function(data)
    --Export entity data to a txt file.
    --Trigger server event in contextmenu-s.lua to store entity in a .txt file for copy pasta.
    TriggerServerEvent(
        "exportEntity",
        entity.target,
        entity.type,
        entity.hash,
        entity.modelName,
        entity.coords,
        entity.heading,
        entity.rotation)
    clearEntityData()
    SetDisplay(false)
end)

--very important cb 
RegisterNUICallback("exit", function(data)
    clearEntityData()
    chat("exited", {0,255,0})
    SetDisplay(false)
    startRaycast = false
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        player = GetPlayerPed(-1, false)
        playerCoords = GetEntityCoords(player, 1)
        --Toggle the mouse / NUI via Z key. Can be changed to what ever.
        
        if IsControlJustReleased(1, z_key) then
            display = not display
            SetDisplay(display)
            SendNUIMessage({
                type = "openGeneral"
            })
        end
        --Disable controls when NUI is active
        if display then
            DisableControlAction(0, 1, display) -- LookLeftRight
            DisableControlAction(0, 2, display) -- LookUpDown
            DisableControlAction(0, 142, display) -- MeleeAttackAlternate
            DisableControlAction(0, 18, display) -- Enter
            DisableControlAction(0, 322, display) -- ESC
            DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
        end
        --Is true when NUI is open and the cursor has be RIGHT CLICKED
        --Shoots a ray from the ped to the cursors position in 3D space
        if startRaycast then
            local hit, endCoords, surfaceNormal, entityHit, entityType, direction = ScreenToWorld(flags, toIgnore)
            --Sets the object and type for the Global variables.
            if entityHit == 0 then --When the ray trace hit the ground or sky it wouldnt clear the type. Ground/sky is target 0. 
                entityType = 0
            end
            entity.target = entityHit
            entity.type = entityType
            entity.hash = GetEntityModel(entityHit)
            entity.coords = GetEntityCoords(entityHit, 1)
            entity.heading = GetEntityHeading(entityHit)
            entity.rotation = GetEntityRotation(entityHit)
            entity.modelName = exports["hashtoname"]:objectNameFromHash(entity.hash)
            if IsPedAPlayer(entityHit) then --IsPedAPlayer returns false or 1 NOT true or false .. weirdly
                entity.isPlayer = true
            else
                entity.isPlayer = false
            end
            SendObjectData()
            --Maybe get state of door and send over to JS to add a icon next to the door menu items to show if they are open or closed.

            --For debugging, Line color changes depending on the TYPE of entity.
            --Also change startRaycast to false for when the right click has happen so it doesnt raycast endlessly
            -- 0 = no entity  
            -- 1 = ped  
            -- 2 = vehicle  
            -- 3 = object              
            -- if hit <= 0 then -- No entity
            --     DrawLine(playerCoords, direction, 255, 255, 255, 120)
            --     startRaycast = false
            -- elseif hit and entityType == 0 then
            --     DrawLine(playerCoords, endCoords, 255, 255, 255, 120)
            --     startRaycast = false
            -- elseif entityType == 1 then -- PED
            --     DrawLine(playerCoords, endCoords, 255, 255, 0, 150)
            --     startRaycast = false
            -- elseif IsEntityAVehicle(entityHit) then --OR hit and entityType == 2 <- Vehicle
            --     DrawLine(playerCoords, endCoords, 255, 0, 0, 150)
            --     startRaycast = false
            -- elseif entityType == 3 then -- Object
            --     DrawLine(playerCoords, endCoords, 0, 255, 0, 150)
            --     startRaycast = false
            -- end
            --print(entityHash, entityHit, entityType, endCoords)
        end
    end
end)

--Clearing the entity data to make sure its overwriten on the next menu call.
function clearEntityData()
    entity.target = nil
    entity.type = nil
    entity.hash = nil
    entity.coords = nil
    entity.heading = nil
    entity.rotation = nil
end

--Call chat("Insert text here", {0,255,0}) to get it shown in chat.
function chat(str, color)
    TriggerEvent(
        'chat:addMessage',
        {
            color = color,
            multiline = true,
            args = {str}
        }
    )
end
--Get closest player
--For anything related to other players the only way to interact with other players using this menu
--is to compare coords with the entity ingame as anything Entity related has nothing to do with other players just a projection of their model/entity.
--E.g If the entity.type is a PED do a coord comparison vs all the players on the server. Then find the closest within maybe a small margin of error.
--IS entity.coords == GetEntityCoords(GetPlayerPed(X), 0) (X being the a player from the GetPlayers() list)
function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(target, 0)
            --local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            local distance = #(targetCoords - plyCoords)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

--Lots of math stuff i have no idea how works but its awesome :)
function ScreenToWorld(flags, toIgnore)
    local camRot = GetGameplayCamRot(0)
    local camPos = GetGameplayCamCoord()
    local posX = GetControlNormal(0, 239)
    local posY = GetControlNormal(0, 240)
    local cursor = vector2(posX, posY)
    local cam3DPos, forwardDir = ScreenRelToWorld(camPos, camRot, cursor)
    local direction = camPos + forwardDir * raycastLength
    local rayHandle = StartShapeTestRay(cam3DPos, direction, flags, toIgnore, 0)
    local _, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    if entityHit >= 1 then
        entityType = GetEntityType(entityHit)
    end
    return hit, endCoords, surfaceNormal, entityHit, entityType, direction
end
 
function ScreenRelToWorld(camPos, camRot, cursor)
    local camForward = RotationToDirection(camRot)
    local rotUp = vector3(camRot.x + 1.0, camRot.y, camRot.z)
    local rotDown = vector3(camRot.x - 1.0, camRot.y, camRot.z)
    local rotLeft = vector3(camRot.x, camRot.y, camRot.z - 1.0)
    local rotRight = vector3(camRot.x, camRot.y, camRot.z + 1.0)
    local camRight = RotationToDirection(rotRight) - RotationToDirection(rotLeft)
    local camUp = RotationToDirection(rotUp) - RotationToDirection(rotDown)
    local rollRad = -(camRot.y * pi / 180.0)
    local camRightRoll = camRight * cos(rollRad) - camUp * sin(rollRad)
    local camUpRoll = camRight * sin(rollRad) + camUp * cos(rollRad)
    local point3DZero = camPos + camForward * 1.0
    local point3D = point3DZero + camRightRoll + camUpRoll
    local point2D = World3DToScreen2D(point3D)
    local point2DZero = World3DToScreen2D(point3DZero)
    local scaleX = (cursor.x - point2DZero.x) / (point2D.x - point2DZero.x)
    local scaleY = (cursor.y - point2DZero.y) / (point2D.y - point2DZero.y)
    local point3Dret = point3DZero + camRightRoll * scaleX + camUpRoll * scaleY
    local forwardDir = camForward + camRightRoll * scaleX + camUpRoll * scaleY
    return point3Dret, forwardDir
end
 
function RotationToDirection(rotation)
    local x = rotation.x * pi / 180.0
    --local y = rotation.y * pi / 180.0
    local z = rotation.z * pi / 180.0
    local num = abs(cos(x))
    return vector3((-sin(z) * num), (cos(z) * num), sin(x))
end
 
function World3DToScreen2D(pos)
    local _, sX, sY = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z)
    return vector2(sX, sY)
end