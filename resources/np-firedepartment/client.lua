local holdingSaw = false
local usingSaw = false
local sawModel = "prop_tool_consaw"
local animDict = "weapons@heavy@minigun"
local animName = "idle_2_aim_right_med"
local particleDict = "des_fib_floor"
local particleName = "ent_ray_fbi5a_ramp_metal_imp"
local actionTime = 10
local saw_net = nil

local particles_started = false
local particled_entity_id = nil

local doors = {
    {bone = "door_pside_f", label = "Front Right Door", index = 1},
    {bone = "door_dside_f", label = "Front Left Door", index = 0},
    {bone = "door_pside_r", label = "Back Right Door", index = 3},
    {bone = "door_dside_r", label = "Back Left Door", index = 2}
}

---------------------------------------------------------------------------
-- Toggling Saw --
---------------------------------------------------------------------------
RegisterNetEvent("Saw:ToggleSaw")
AddEventHandler("Saw:ToggleSaw", function()
    if not holdingSaw then
        RequestModel(GetHashKey(sawModel))
        while not HasModelLoaded(GetHashKey(sawModel)) do
            Citizen.Wait(100)
        end

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(100)
        end

        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local sawspawned = CreateObject(GetHashKey(sawModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
        Citizen.Wait(1000)
        local netid = ObjToNet(sawspawned)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(sawspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.095, 0.0, 0.0, 270.0, 170.0, 0.0, 1, 1, 0, 1, 0, 1)
        TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
        TaskPlayAnim(GetPlayerPed(PlayerId()), animDict, animName, 1.0, -1, -1, 50, 0, 0, 0, 0)
        saw_net = netid
        holdingSaw = true
    else
        ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
        DetachEntity(NetToObj(saw_net), 1, 1)
        DeleteEntity(NetToObj(saw_net))
        saw_net = nil
        holdingSaw = false
        usingSaw = false
    end
end)

---------------------------------------------------------------------------
-- Start Particles --
---------------------------------------------------------------------------
RegisterNetEvent("Saw:StartParticles")
AddEventHandler("Saw:StartParticles", function(sawid)
    local entity = NetToObj(sawid)

    RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        Citizen.Wait(100)
    end

    UseParticleFxAssetNextCall(particleDict)
    StartParticleFxNonLoopedOnEntity(particleName, entity, -0.715, 0.005, 0.0, 0.0, 25.0, 25.0, 0.75, 0.0, 0.0, 0.0)
end)

---------------------------------------------------------------------------
-- Stop Particles --
---------------------------------------------------------------------------
RegisterNetEvent("Saw:StopParticles")
AddEventHandler("Saw:StopParticles", function(sawid)
    local entity = NetToObj(sawid)
    RemoveParticleFxFromEntity(entity)
end)

---------------------------------------------------------------------------
-- Get Vehicle Closest Door --
---------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        if holdingSaw then

            local vehicle = GetVehicleInFront()
            if vehicle ~= 0 then
                local boneDistances = {}
            
                for a = 1, #doors do
                    local plyPos = GetEntityCoords(GetPlayerPed(PlayerId()), false)
                    local doorPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, doors[a].bone))
                    local distance = Vdist(plyPos.x, plyPos.y, plyPos.z, doorPos.x, doorPos.y, doorPos.z)
                    local doorNumbers = GetNumberOfVehicleDoors(vehicle)
                    local distCheck = 2.7
                    if doorNumbers > 4 then distCheck = 2.0 end

                    if distance < distCheck then
                        boneDistances[#boneDistances+1]= {index = a, distance = distance}
                    end
                end

                local lowest = nil
                local lowestDistanceIndex = nil

                if #boneDistances > 1 then
                    for b = 1, #boneDistances do
                        if lowest == nil then
                            lowest = boneDistances[b].index
                            lowestDistanceIndex = b
                        else
                            if boneDistances[b].distance < boneDistances[lowestDistanceIndex].distance then
                                lowest = boneDistances[b].index
                            end
                        end
                    end

                    if IsVehicleDoorDamaged(vehicle, doors[lowest].index) == false then
                        local drawCoord = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, doors[lowest].bone))
                        DrawText3DTest(drawCoord.x, drawCoord.y, drawCoord.z, tostring("Press E to cut " .. doors[lowest].label))

                        if IsControlJustPressed(1, 38) and not usingSaw then
                            Timer(vehicle, lowest)
                        end
                    end
                end
            end
        end

        Citizen.Wait(0)
    end
end)

local stuckInCar = false

RegisterNetEvent("firedepartment:forceStop")
AddEventHandler("firedepartment:forceStop", function()
    holdingSaw = false
    ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
    if saw_net ~= nil then
        DetachEntity(NetToObj(saw_net), 1, 1)
        DeleteEntity(NetToObj(saw_net))
    end
    saw_net = nil
    holdingSaw = false
    usingSaw = false
end)

RegisterNetEvent("firedepartment:stuckincar")
AddEventHandler("firedepartment:stuckincar", function(isStuck)
    stuckInCar = isStuck
    TriggerEvent("DoLongHudText","You have had a bad accident, the door's are broken and your legs appear to be stuck.",1)
    TriggerEvent("breaklegs")
    TriggerEvent("stuckincar",true)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)

        local ped = PlayerPedId()
        if stuckInCar then
            Wait(900)
        else
            if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
                Citizen.Wait(100)
                if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
                    local veh = GetVehiclePedIsIn(ped, false)
                    TaskLeaveVehicle(ped, veh, 256)
                end
            end
        end
    end
end)

local lastCar = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if not IsPedInVehicle(PlayerPedId(),vehicle,false) and stuckInCar then
            stuckInCar = false
            TriggerEvent("stuckincar",false)
        end

        if stuckInCar then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if IsPedInVehicle(PlayerPedId(),vehicle,false) then
                local boneDistances = {}
                for a = 1, #doors do
                    local doorNumber = 0
                    if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()  then doorNumber = 2
                    elseif GetPedInVehicleSeat(vehicle, 0) == PlayerPedId() then doorNumber = 1
                    elseif GetPedInVehicleSeat(vehicle, 1) == PlayerPedId() then doorNumber = 4
                    elseif GetPedInVehicleSeat(vehicle, 2) == PlayerPedId() then doorNumber = 3 end

                    local plyPos = GetEntityCoords(GetPlayerPed(PlayerId()), false)
                    local doorPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, doors[doorNumber].bone))
                    local distance = Vdist(plyPos.x, plyPos.y, plyPos.z, doorPos.x, doorPos.y, doorPos.z)

                    if distance < 2 then
                        boneDistances[#boneDistances+1]= {index = doorNumber, distance = distance}
                    end
                end

                local lowest = nil
                local lowestDistanceIndex = nil

                if #boneDistances > 1 then
                    for b = 1, #boneDistances do
                        if lowest == nil then
                            lowest = boneDistances[b].index
                            lowestDistanceIndex = b
                        else
                            if boneDistances[b].distance < boneDistances[lowestDistanceIndex].distance then
                                lowest = boneDistances[b].index
                            end
                        end
                    end

                    if IsVehicleDoorDamaged(vehicle, doors[lowest].index) == false then
                        local drawCoord = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, doors[lowest].bone))
                        if vehicle ~= nil then
                            lastCar = vehicle
                        end
                        SetVehicleDoorsLocked(vehicle,4)
                    else
                        SetVehicleDoorsLocked(vehicle,0)
                        SetVehicleDoorsLocked(lastCar,0)
                    end
                end
            end
        else
            Citizen.Wait(300)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        if usingSaw then
            TriggerServerEvent("Saw:SyncStartParticles", saw_net)
        end
        Citizen.Wait(100)
    end
end)

RegisterNetEvent("firedepartment:removeDoor")
AddEventHandler("firedepartment:removeDoor", function(vehNetId,index)
    repeat
        Wait(500)
    until NetworkGetEntityFromNetworkId(vehNetId) > 0
    local currentVeh = NetworkGetEntityFromNetworkId(vehNetId)
    SetVehicleDoorBroken(currentVeh,index, false)
end)

function Timer(vehicle, index)
    Citizen.CreateThread(function()
        Notification("~r~You are cutting off the door. Please wait...")
        usingSaw = true
        local time = actionTime
        while time > 0 do

            if not holdingSaw or GetVehicleInFront() ~= vehicle then
                usingSaw = false
                TriggerServerEvent("Saw:SyncStopParticles", saw_net)
                Notification("~r~Cutting has been canceled.")
                return
            end
            
            Citizen.Wait(1000)
            time = time - 1
        end
        netid = NetworkGetNetworkIdFromEntity(vehicle)

        SetVehicleDoorBroken(vehicle, doors[index].index, false)
        TriggerServerEvent("Saw:SyncDoorFall",netid,doors[index].index)
        TriggerServerEvent("Saw:SyncStopParticles", saw_net)
        Notification("~g~The vehicles door has been cut off.")
        usingSaw = false
    end)
end

function GetVehicleInFront()
    local plyCoords = GetEntityCoords(GetPlayerPed(PlayerId()), false)
    local plyOffset = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 1.2, 0.0)
    --local rayHandle = StartShapeTestRay(plyCoords.x, plyCoords.y, plyCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, 2, GetPlayerPed(PlayerId()), 1)
    local rayHandle = StartShapeTestCapsule(plyCoords.x, plyCoords.y, plyCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, 0.3, 10, GetPlayerPed(PlayerId()), 7)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)

    return vehicle
end

function DrawText3DTest(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function Notification(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0, 1)
end