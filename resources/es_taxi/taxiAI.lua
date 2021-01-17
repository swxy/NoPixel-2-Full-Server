lastTaxi = false
taskveh = 0
ped = 0

function SetTaxiExtras(veh)
	SetVehicleExtra(entity, 1, 1)
	SetVehicleExtra(entity, 2, 1)
	SetVehicleExtra(entity, 3, 1)
	SetVehicleExtra(entity, 4, 1)
	SetVehicleExtra(entity, 5, 1)
	SetVehicleExtra(entity, 6, 1)
	SetVehicleExtra(entity, 7, 1)
	SetVehicleExtra(entity, 7, 1)
	SetVehicleExtra(entity, 7, 1)
	SetVehicleExtra(entity, 8, 0)
	SetVehicleExtra(entity, 9, 0)
end

function FindEndPointCar2(x,y) 

    local randomPool = 10.0
    local tryneg = false
    while true do
        if (randomPool > 2900) then
            randomPool = 50.0
            tryneg = true
        end
        local vehSpawnResult = {}
        if tryneg then
        vehSpawnResult["x"] = x-randomPool
        vehSpawnResult["y"] = y-randomPool
        else
        vehSpawnResult["x"] = x+randomPool
        vehSpawnResult["y"] = y+randomPool
        end

        vehSpawnResult["z"] = 0.0

        roadtest, vehSpawnResult, outHeading = GetClosestVehicleNode(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"],  0, 999.0, 999.0)

        Citizen.Wait(1000)   

        if vehSpawnResult["z"] ~= 0.0 then
            local caisseo = GetClosestVehicle(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], 20.000, 0, 70)
            if not DoesEntityExist(caisseo) then
 
                return vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], outHeading
            end
            
        end


        randomPool = randomPool + 10.0
    end

    --endResult["x"], endResult["y"], endResult["z"]

end

function FindEndPointCar(x,y)   
    local randomPool = 250.0
    while true do
        if (randomPool > 2900) then
            randomPool = 50.0
        end
        local vehSpawnResult = {}
        vehSpawnResult["x"] = 0.0
        vehSpawnResult["y"] = 0.0
        vehSpawnResult["z"] = 30.0
        vehSpawnResult["x"] = x + math.random(randomPool - (randomPool * 2),randomPool) + 1.0  
        vehSpawnResult["y"] = y + math.random(randomPool - (randomPool * 2),randomPool) + 1.0  
        roadtest, vehSpawnResult, outHeading = GetClosestVehicleNode(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"],  0, 55.0, 55.0)

        Citizen.Wait(1000)        
        if vehSpawnResult["z"] ~= 0.0 then
            local caisseo = GetClosestVehicle(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], 20.000, 0, 70)
            if not DoesEntityExist(caisseo) then

                return vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], outHeading
            end
        end

        randomPool = randomPool + 50.0
    end
    --endResult["x"], endResult["y"], endResult["z"]
end
insideTaxi = false


function ReturnNearTaxi()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, vehicle = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(vehicle)
        local distance = #(playerCoords - pos)
        if distance < 45.0 and GetEntityModel(vehicle) == `taxi` and not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1)) then
            distanceFrom = distance
            rped = vehicle
        end
        success, vehicle = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return rped
end
local hailing = false
RegisterNetEvent("taxi:slownearest")
AddEventHandler("taxi:slownearest", function()

    if hailing then
        return
    end
    hailing = true
    local taxi = ReturnNearTaxi()
    if taxi ~= nil then

        TaskVehicleTempAction(GetPedInVehicleSeat(taxi, -1), taxi, 27, 25.0)
        Citizen.Wait(1500)
        local timer = 15000
        while timer > 0 do
            Citizen.Wait(1)
            SetVehicleForwardSpeed(taxi, math.ceil(GetEntitySpeed(taxi)*0.9 ))
            timer = timer - 1
            if IsPedInAnyVehicle(PlayerPedId(), true) then

                timer = 0
            end
        end
    end
    Citizen.Wait(1000)

    hailing = false
end)

RegisterNetEvent("leavetaxinow")
AddEventHandler("leavetaxinow", function(plt)
    if plt == GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)) then
        TaskLeaveVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 0)
        TriggerEvent("DoLongHudText","Ride Over!",1)
    end
end)
local enteredtaxi = false
RegisterNetEvent("startAITaxi")
AddEventHandler("startAITaxi", function(passedInside)

    if passedInside ~= nil then
        insideTaxi = passedInside
    end

	if lasttaxi and not insideTaxi then 

        local coords = GetEntityCoords(PlayerPedId())
        local mycoords = GetEntityCoords(taskveh)
        local bDist = #(vector3(coords["x"], coords["y"],coords["z"]) - vector3(mycoords["x"],mycoords["y"],mycoords["z"]))      

        TaskVehicleDriveToCoord(GetPedInVehicleSeat(taskveh, -1), taskveh, mycoords["x"], mycoords["y"],mycoords["z"], 8.0, 1, `taxi`, 786603, 15.0, true)
        TriggerEvent("DoLongHudText","You must wait! Your current taxi is " .. math.ceil(bDist) .. " metres away!",2)
        return 
    end

    if lasttaxi then
        TriggerEvent("DoLongHudText","You must wait!",2)
        return
    end

    lasttaxi = true
    if not insideTaxi then

    	TriggerEvent("DoLongHudText","Taxi Enroute!",1)
        car = `taxi`
        RequestModel(car)

        while not HasModelLoaded(car) do
            Citizen.Wait(0)
        end
        plycoords = GetEntityCoords(PlayerPedId())
        vehSpawnResult = {}    
        vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], outHeading = FindEndPointCar(plycoords["x"],plycoords["y"])
        taskveh = CreateVehicle(car, vehSpawnResult["x"],vehSpawnResult["y"],vehSpawnResult["z"], outHeading, true, false)
        SetEntityInvincible(taskveh, true) 
        SetVehicleOnGroundProperly(taskveh)
        SetVehicleModKit(taskveh, 0)
        SetVehicleHasBeenOwnedByPlayer(taskveh,true)
        local id = NetworkGetNetworkIdFromEntity(taskveh)
        SetNetworkIdCanMigrate(id, true)

        local pedmodel = `s_m_m_trucker_01`

        RequestModel(pedmodel)
        while not HasModelLoaded(pedmodel) do
            RequestModel(pedmodel)
            Citizen.Wait(100)
        end
        ped = CreatePedInsideVehicle(taskveh, 4, pedmodel, -1, 1, 0.0)
        DecorSetBool(ped, 'ScriptedPed', true)
        SetModelAsNoLongerNeeded(pedmodel)
        SetModelAsNoLongerNeeded(car)
        TaskVehicleDriveToCoord(GetPedInVehicleSeat(taskveh, -1), taskveh, plycoords["x"], plycoords["y"],plycoords["z"], 8.0, 1, car, 786603, 15.0, true)
        SetPedKeepTask(GetPedInVehicleSeat(taskveh, -1), true)
    else
        taskveh = GetVehiclePedIsUsing(PlayerPedId())
        ped = GetPedInVehicleSeat(taskveh, -1)
    end

    if not DoesEntityExist(taskveh) or not DoesEntityExist(ped) or IsPedAPlayer(ped) then
        return
    end

    count = 400000
    enroute = false
    Citizen.Wait(1000)
    SetEntityInvincible(taskveh, false) 
    SetWaypointOff()
    local dropoff = {}
    local checkifclose = false
    local firstWaypoint = true
    local speedCity = true

    while count > 0 and not IsPedDeadOrDying(ped, true) and DoesEntityExist(ped) do
        Citizen.Wait(1)
	    local coords = GetEntityCoords(ped)
	    local mycoords = GetEntityCoords(PlayerPedId())
        local cityDistance = #(vector3(-241.29,-1039.44,28.06) - vector3(mycoords["x"],mycoords["y"],mycoords["z"]))
	    local bDist = #(vector3(coords["x"], coords["y"],coords["z"]) - vector3(mycoords["x"],mycoords["y"],mycoords["z"]))

        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
        local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
        currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
        local highway = false

        if currentStreetName == "Los Santos Freeway" or currentStreetName == "Senora Fwy" or currentStreetName == "Palomino Fwy" or currentStreetName == "Great Ocean Hwy" then
            highway = true
        end


	    count = count - 1

	    if not enroute and GetVehiclePedIsIn(PlayerPedId(), false) ~= taskveh then
			if bDist < 25.5 then
                DrawText3Ds(coords["x"], coords["y"],coords["z"], "Your Taxi!")
                SetVehicleForwardSpeed(taskveh, math.ceil(GetEntitySpeed(taskveh)*0.75 ))
                TaskVehicleTempAction(GetPedInVehicleSeat(taskveh, -1), taskveh, 27, 25.0)
	        else
	        	DrawText3Ds(coords["x"], coords["y"],coords["z"], "Taxi")
	        end
	    end
       
        if GetVehiclePedIsIn(PlayerPedId(), false) == taskveh then
            local ownerped = GetPedInVehicleSeat(taskveh, 1)
            Citizen.Wait(1200)
            if not IsControlPressed(0,23) and not IsControlJustReleased(0,23) and enteredtaxi then
                  SetPedIntoVehicle(PlayerPedId(), taskveh, 2)
                  SetPedIntoVehicle(PlayerPedId(), taskveh, 1)  
            end

            if IsControlPressed(0,23) and IsControlJustReleased(0,23) and enteredtaxi then
                count = 0
            end

            if not enteredtaxi then
                enteredtaxi = true
                SetPedIntoVehicle(PlayerPedId(), taskveh, 2)
                SetPedIntoVehicle(PlayerPedId(), taskveh, 1)
            end

            local curCoord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, Waypoint, Citizen.ResultAsVector()) 

        	if enroute and not IsWaypointActive() and ownerped == PlayerPedId() then
               local endDist = #(vector3(coords["x"], coords["y"],coords["z"]) - vector3(dropoff["x"], dropoff["y"], dropoff["z"]))
                if endDist > 250.0 then 
                    enroute = false 
                end
            elseif not enroute and not IsWaypointActive() and ownerped ~= PlayerPedId() then
                TriggerEvent("DoLongHudText","Mark destination on GPS",1)
            end
	        	--DrawText3Ds(coords["x"], coords["y"],coords["z"], "Enroute,")              
            if enroute and speedCity and highway and ownerped == PlayerPedId() then
                speedCity = false
                TaskVehicleDriveToCoordLongrange(GetPedInVehicleSeat(taskveh, -1), taskveh, dropoff["x"], dropoff["y"], dropoff["z"], 28.0, 786603, 55.0)
                SetPedKeepTask(GetPedInVehicleSeat(taskveh, -1), true)                   
            end

            if enroute and not speedCity and not highway and ownerped == PlayerPedId() then
                speedCity = true
                TaskVehicleDriveToCoordLongrange(GetPedInVehicleSeat(taskveh, -1), taskveh, dropoff["x"], dropoff["y"], dropoff["z"], 14.0, 786603, 55.0)
                SetPedKeepTask(GetPedInVehicleSeat(taskveh, -1), true)                   
            end

        	if not enroute and IsWaypointActive() and ownerped == PlayerPedId() then
                local Waypoint = GetFirstBlipInfoId(8)
                local StoredCoord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, Waypoint, Citizen.ResultAsVector())                      
                dropoff["x"], dropoff["y"], dropoff["z"], outHeading = FindEndPointCar2(StoredCoord["x"],StoredCoord["y"])
                enroute = true
                if cityDistance > 1500.0 then 
                    TaskVehicleDriveToCoordLongrange(GetPedInVehicleSeat(taskveh, -1), taskveh, dropoff["x"], dropoff["y"], dropoff["z"], 28.0, 786603, 55.0)
                    SetPedKeepTask(GetPedInVehicleSeat(taskveh, -1), true) 
                    speedCity = false   
                else
                    TaskVehicleDriveToCoordLongrange(GetPedInVehicleSeat(taskveh, -1), taskveh, dropoff["x"], dropoff["y"], dropoff["z"], 14.0, 786603, 55.0)
                    SetPedKeepTask(GetPedInVehicleSeat(taskveh, -1), true)
                    speedCity = true
                end
            end

	        if enroute and ownerped == PlayerPedId() then

	        	local endDist = #(vector3(coords["x"], coords["y"],coords["z"]) - vector3(dropoff["x"], dropoff["y"], dropoff["z"]))

	        	if (endDist < 150.0 or count < 100) then

                    while GetEntitySpeed(taskveh) > 1.0 and endDist > 10.0 do
                        endDist = #(vector3(coords["x"], coords["y"],coords["z"]) - vector3(dropoff["x"], dropoff["y"], dropoff["z"]))
				       Citizen.Wait(1000)
                        if not IsControlPressed(0,23) and not IsControlJustReleased(0,23) then
                              SetPedIntoVehicle(PlayerPedId(), taskveh, 2)
                              SetPedIntoVehicle(PlayerPedId(), taskveh, 1)  
                        else
                            endDist = 1.0
                        end
				    end  

                    while GetEntitySpeed(taskveh) > 1.0 do
                        SetVehicleForwardSpeed(taskveh, math.ceil(GetEntitySpeed(taskveh)*0.75 ))
                        TaskVehicleTempAction(GetPedInVehicleSeat(taskveh, -1), taskveh, 27, 25.0)
                       Citizen.Wait(1)
                   end

                    SetPedKeepTask(GetPedInVehicleSeat(taskveh, -1), false)
                    SetPedAsNoLongerNeeded(ped)         
                    SetVehicleAsNoLongerNeeded(taskveh)
                    FreezeEntityPosition(taskveh,true)
                    local plt = GetVehicleNumberPlateText(taskveh)
                    TriggerServerEvent("taskleavetaxi", plt)
                    Citizen.Wait(1000)

                    SetBlockingOfNonTemporaryEvents(ped, true)        
                    SetPedSeeingRange(ped, 0.0)       
                    SetPedHearingRange(ped, 0.0)      
                    SetPedFleeAttributes(ped, 0, false)       
                    SetPedKeepTask(ped, true) 
                    
				    FreezeEntityPosition(taskveh,false)
                    TaskVehicleDriveWander(GetPedInVehicleSeat(taskveh, -1), ped, 10.0, 786603)
                    count = 0

                end

                if not IsWaypointActive() then
                    enroute = false
                end

	        end

        else
            enteredtaxi = false
        end

	end

    insideTaxi = false
    SetPedKeepTask(GetPedInVehicleSeat(taskveh, -1), false)
    SetPedAsNoLongerNeeded(ped)         
    SetVehicleAsNoLongerNeeded(taskveh)
    taskveh = 0
    ped = 0
	lasttaxi = false
    enteredtaxi = false
end)

function DrawText3Ds(x,y,z, text)
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

--local Waypoint = GetFirstBlipInfoId(8)
--local Coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, Waypoint, Citizen.ResultAsVector())