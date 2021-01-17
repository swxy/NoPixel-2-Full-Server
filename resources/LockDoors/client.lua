local distanceParam = 5 -- Change this value to change the distance needed to lock / unlock a vehicle
local key = 182 -- Change this value to change the key (List of values below)
local chatMessage = true -- Set to false for disable chatMessage
local playSound = true -- Set to false for disable sound when Lock/Unlock (To change the sounds, follow the instructions here : https://forum.fivem.net/t/release-locksystem/17750/5)

function getVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		
		offset = offset - 1

		if vehicle ~= 0 then break end
	end
	
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	
	if distance > 250 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end
--SetEntityTrafficlightOverride(entity, state)
--SetEntityLights(entity, toggle)
RegisterNetEvent('keys:unlockDoor')
AddEventHandler('keys:unlockDoor', function(targetVehicle, allow)
    if allow then
        local playerped = PlayerPedId()
        inveh = IsPedInAnyVehicle(playerped)
        lockStatus = GetVehicleDoorLockStatus(targetVehicle) 
        TriggerEvent("dooranim")
        if lockStatus == 1 or lockStatus == 0 then 
            
            lockStatus = SetVehicleDoorsLocked(targetVehicle, 2)

            SetVehicleDoorsLockedForPlayer(targetVehicle, PlayerId(), false)
            if playSound then
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lock', 0.4)
            end
            
            if not inveh then
                SetVehicleLights(targetVehicle, 2)

                SetVehicleBrakeLights(targetVehicle, true)
                SetVehicleInteriorlight(targetVehicle, true)
                SetVehicleIndicatorLights(targetVehicle, 0, true)
                SetVehicleIndicatorLights(targetVehicle, 1, true)
                Citizen.Wait(450)

                SetVehicleIndicatorLights(targetVehicle, 0, false)
                SetVehicleIndicatorLights(targetVehicle, 1, false)
                Citizen.Wait(450)
                
                SetVehicleInteriorlight(targetVehicle, true)
                SetVehicleIndicatorLights(targetVehicle, 0, true)
                SetVehicleIndicatorLights(targetVehicle, 1, true)
                Citizen.Wait(450)

                SetVehicleLights(targetVehicle, 0)
                SetVehicleBrakeLights(targetVehicle, false)
                SetVehicleInteriorlight(targetVehicle, false)
                SetVehicleIndicatorLights(targetVehicle, 0, false)
                SetVehicleIndicatorLights(targetVehicle, 1, false)
            end




        else

            lockStatus = SetVehicleDoorsLocked(targetVehicle, 1)

            if playSound then
               TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'unlock', 0.1)
            end

            if not inveh then
                SetVehicleLights(targetVehicle, 2)
                SetVehicleFullbeam(targetVehicle, true)
                SetVehicleBrakeLights(targetVehicle, true)
                SetVehicleInteriorlight(targetVehicle, true)
                SetVehicleIndicatorLights(targetVehicle, 0, true)
                SetVehicleIndicatorLights(targetVehicle, 1, true)
                Citizen.Wait(450)

                SetVehicleIndicatorLights(targetVehicle, 0, false)
                SetVehicleIndicatorLights(targetVehicle, 1, false)
                Citizen.Wait(450)
                
                SetVehicleInteriorlight(targetVehicle, true)
                SetVehicleIndicatorLights(targetVehicle, 0, true)
                SetVehicleIndicatorLights(targetVehicle, 1, true)
                Citizen.Wait(450)

                SetVehicleLights(targetVehicle, 0)
                SetVehicleFullbeam(targetVehicle, false)
                SetVehicleBrakeLights(targetVehicle, false)
                SetVehicleInteriorlight(targetVehicle, false)
                SetVehicleIndicatorLights(targetVehicle, 0, false)
                SetVehicleIndicatorLights(targetVehicle, 1, false)
            end


        end



    end
end)


RegisterNetEvent('event:control:cardoors')
AddEventHandler('event:control:cardoors', function(useID)
    local playerped = PlayerPedId()
    local targetVehicle = GetVehiclePedIsUsing(playerped)

    if not DoesEntityExist(targetVehicle) then
        local coordA = GetEntityCoords(playerped, 1)
        local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 255.0, 0.0)
        targetVehicle = getVehicleInDirection(coordA, coordB)
    end

    if DoesEntityExist(targetVehicle) then
        TriggerEvent("keys:hasKeys", 'doors', targetVehicle)
    end
    Citizen.Wait(500)
end)