 
local currentlyTowedVehicle
local pickUplocation
local mypaytruck = 0

local towVehicles = {
	"towtruck",
	"towtruck2",
	"flatbed",
	"flatbed2",	
	"flatbed3"
}

local function deleteVehicle(vehicle)
	if IsAnEntity(vehicle) and IsEntityAVehicle(vehicle) then
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			SetEntityAsMissionEntity(vehicle,false,true)
			DeleteVehicle(vehicle)
			SetEntityAsNoLongerNeeded(vehicle)
			return
		end)
	end
end

local function isTowVehicle(vehicle)
	for k,v in pairs(towVehicles) do
		if IsVehicleModel(vehicle, GetHashKey(v)) then return v end
	end
	return false
end

local function getVehicleInDirection(coordFrom, coordTo)
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
	
	if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end


function CleanDetachedVehicles()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, vehicleFound = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(vehicleFound)
        local distance = #(playerCoords - pos)
        if distance < 15.0 then

      		if IsEntityAttached(vehicleFound) then
        		DetachEntity(vehicleFound, true, true)
				local drop = GetOffsetFromEntityInWorldCoords(vehicleFound, 0.0,-5.5,0.0)
				DetachEntity(vehicleFound, true, true)
				SetEntityCoords(vehicleFound,drop)
			end
			--SetEntityCoords(vehicleFound,drop)
        end
        success, vehicleFound = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
end



Citizen.CreateThread(function()
	--TriggerEvent("pv:tow")
	CleanDetachedVehicles()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, true)
		local pay = true

		if onJob and onJob == 1 and (isTowVehicle(vehicle) == "towtruck" or isTowVehicle(vehicle) == "towtruck2")  then
			local targetVehicle = GetEntityAttachedToTowTruck(vehicle)

			if currentlyTowedVehicle then
				if GetEntityAttachedToTowTruck(vehicle) ~= currentlyTowedVehicle then currentlyTowedVehicle = nil end
			end

			if targetVehicle ~= 0 or not targetVehicle then
				currentlyTowedVehicle = targetVehicle
				pickUplocation = pickUplocation and pickUplocation or GetEntityCoords(targetVehicle, true)

				local distance = CalculateTravelDistanceBetweenPoints(pickUplocation, 549.47204589844,-55.185947418213,71.188438415527)
				local pickUpToTowYard = Vdist2(pickUplocation, 549.47204589844,-55.185947418213,71.188438415527)
				local distToTowYard = Vdist2(GetEntityCoords(targetVehicle, true), 549.47204589844,-55.185947418213,71.188438415527)

				if pickUpToTowYard < 500.0 then pay = false end

				local payAmt = math.ceil(distance * 0.43)
				if payAmt > 400 then
					payAmt = 400
				end
				if distToTowYard < 120.0 then
					if pay then 
						TriggerServerEvent("server:givepayJob", "Tow Truck Car Delivery Payment", math.random(100,payAmt)) 
					end
					DetachVehicleFromTowTruck(vehicle, targetVehicle)
					SetEntityAsNoLongerNeeded(targetVehicle)
					deleteVehicle(targetVehicle)
					targetVehicle = false
				end
			else
				targetVehicle = false
				currentlyTowedVehicle = false
				pickUplocation = false
				pay = false
				distance = false
			end
		end
	end
end)
local towingProcess = false
RegisterNetEvent('animation:tow')
AddEventHandler('animation:tow', function()
	towingProcess = true
    local lPed = PlayerPedId()
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
    end
    while towingProcess do

        if not IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
            ClearPedSecondaryTask(lPed)
            TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
    end
    ClearPedTasks(lPed)
end)





RegisterNetEvent('pv:tow')
AddEventHandler('pv:tow', function()
	local playerped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerped, true)
	
	local towmodel = `towtruck`
	local isVehicleTow = isTowVehicle(vehicle)
			
	if isVehicleTow then
	
		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)

		if not currentlyTowedVehicle then
			CleanDetachedVehicles()
			local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
			local back = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]-1.0,0.0)

			local aDist = #(back - GetEntityCoords(targetVehicle))
	        
	        if aDist > 3.5 then
	        	local count = 1000
		        while count > 0 do
		            Citizen.Wait(1)
		            count = count - 1
		            DrawText3Ds(back["x"],back["y"],back["z"],"Vehicle must be here to tow.")
		        end
		        return
		    end

		    local aDist = #(back - GetEntityCoords(targetVehicle))

		    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 10.0, 'towtruck', 0.5)
		    TaskTurnPedToFaceEntity(PlayerPedId(), vehicle, 1.0)
		    Citizen.Wait(1000)
		    TriggerEvent("animation:tow")
		    local finished = exports["np-taskbar"]:taskBar(15000,"Hooking up vehicle.")
        	if finished == 100 and aDist < 5.0 then
			
				if targetVehicle ~= 0 then
					TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 10.0, 'towtruck2', 0.5)
					local part2 = exports["np-taskbar"]:taskBar(7000,"Towing Vehicle")
					local driverPed = GetPedInVehicleSeat(targetVehicle, -1)
					if not IsPedInAnyVehicle(playerped, true) and not DoesEntityExist(driverPed) then
						if vehicle ~= targetVehicle and #(GetEntityCoords(targetVehicle) - GetEntityCoords(vehicle)) < 15.0 and GetEntitySpeed(targetVehicle < 3.0) then
		
							SetEntityAsMissionEntity(targetVehicle, true, true)
							NetworkRequestControlOfEntity(targetVehicle)

							local timeout = 0

							while timeout < 1000 and not NetworkHasControlOfEntity(targetVehicle) do
								timeout = timeout + 100
								NetworkRequestControlOfEntity(targetVehicle)
								Citizen.Wait(100)
							end
		
							if isVehicleTow == "flatbed3" then
								AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, 'bodyshell'), 0.0, -3.3, 1.0, 0, 0, 0, 1, 1, 0, 1, 0, 1)
							elseif isVehicleTow == "flatbed2" then
								AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, 'bodyshell'), 0.0, -1.9, 0.5, 0, 0, 0, 1, 1, 0, 1, 0, 1)
							elseif isVehicleTow == "flatbed" then
								AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, 'bodyshell'), -0.25, -2.8, 1.1, 0, 0, 0, 1, 1, 0, 1, 0, 1)
							end 
								
		
							currentlyTowedVehicle = targetVehicle

							local location = GetEntityCoords(targetVehicle, 0)
							mypaytruck = CalculateTravelDistanceBetweenPoints( location, 408.957, -1638.664, 28.81 )

							if CalculateTravelDistanceBetweenPoints( location, 1732.1655273438,3307.6025390625,41.22350692749 ) < mypaytruck then
								mypaytruck = CalculateTravelDistanceBetweenPoints( location, 1732.1655273438,3307.6025390625,41.22350692749 )
							end

							if CalculateTravelDistanceBetweenPoints( location, -195.68403625488,6219.8081054688,31.491077423096 ) < mypaytruck then
								mypaytruck = CalculateTravelDistanceBetweenPoints( location, -195.68403625488,6219.8081054688,31.491077423096 )
							end
						    mypaytruck = mypaytruck * 0.05
						    mypaytruck = math.ceil(mypaytruck)

					    -- Don't pay people who are towing within the tow truck area
							if (CalculateTravelDistanceBetweenPoints( location, 549.47204589844,-55.185947418213,71.188438415527 ) < 155) then
								mypaytruck = 0
							end
							if (CalculateTravelDistanceBetweenPoints( location, 1732.1655273438,3307.6025390625,41.22350692749 ) < 155) then
								mypaytruck = 0
							end
							if (CalculateTravelDistanceBetweenPoints( location, -195.68403625488,6219.8081054688,31.491077423096 ) < 155) then
								mypaytruck = 0
							end

				            if mypaytruck > 300 then
				                mypaytruck = 300
				            end			    

						else
							TriggerEvent("DoLongHudText","You can't tow that vehicle", 2)
						end
					else
						if DoesEntityExist(driverPed) then
							TriggerEvent("DoLongHudText","It appears someone is in the vehicle, you can not do this.", 2)
						end
					end

				else
					TriggerEvent("DoLongHudText","No vehicle found", 2)
				end
			end
		else

			local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
			local back = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]-0.5,0.0)
			local drop = GetOffsetFromEntityInWorldCoords(vehicle, 1.5,d1["y"]-5.5,0.0)
			local aDist = #(back - GetEntityCoords(PlayerPedId()))
	        
	        if aDist > 1.5 then
	        	local count = 1500
		        while count > 0 and aDist > 1.5 do
		        	back = GetOffsetFromEntityInWorldCoords(vehicle, 1.5,d1["y"]-0.5,0.0)
		        	aDist = #(GetEntityCoords(PlayerPedId()) - back)
		            Citizen.Wait(1)
		            count = count - 1
		            DrawText3Ds(back["x"],back["y"],back["z"]," Move here to untow the vehicle.")
		        end
		        if count < 1 then
		        	return
		        end
		    end
		    
		    TaskTurnPedToFaceEntity(PlayerPedId(), vehicle, 1.0)
		    Citizen.Wait(1000)
		    TriggerEvent("animation:tow")
		    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 10.0, 'towtruck', 0.5)
		    local finished = exports["np-taskbar"]:taskBar(7000,"Untowing Vehicle")
        	if finished == 100 and aDist < 2.0 then

        		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 10.0, 'towtruck2', 0.5)
        		local part2 = exports["np-taskbar"]:taskBar(7000,"Unhooking Vehicle")
								

				CleanDetachedVehicles()


				
				local location = GetEntityCoords(playerped, 0)
				calc = CalculateTravelDistanceBetweenPoints( location, 549.47204589844,-55.185947418213,71.188438415527 )

				if CalculateTravelDistanceBetweenPoints( location, 1732.1655273438,3307.6025390625,41.22350692749 ) < calc then
					calc = CalculateTravelDistanceBetweenPoints( location, 1732.1655273438,3307.6025390625,41.22350692749 )
				end

				if CalculateTravelDistanceBetweenPoints( location, -195.68403625488,6219.8081054688,31.491077423096 ) < calc then
					calc = CalculateTravelDistanceBetweenPoints( location, -195.68403625488,6219.8081054688,31.491077423096 )
				end
				print("this far")
			
						print("i should now be paying")
						TriggerServerEvent("paytheuglytowpeople") 
					
					print(currentlyTowedVehicle)
					deleteVehicle(currentlyTowedVehicle)
					currentlyTowedVehicle = nil
				end
			end
		end
	towingProcess = false
end)