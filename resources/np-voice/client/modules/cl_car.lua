_inVeh = false
_currentvehicle = nil
_passengers = {}
local targetSet = false

function LoadCarModule()

    RegisterModuleContext("car", 2)
    UpdateContextVolume("car", -1.0)

    AddEventHandler('baseevents:enteredVehicle',function(currentVehicle, currentSeat, vehicle_name, netId)
        _inVeh = true
        _currentvehicle = currentVehicle
        UpdateContextVolume("car", -1)
        startVehThread()
    end)

    AddEventHandler('baseevents:leftVehicle',function(leftVehicle, netId)

        --if _inVeh then
            Citizen.Wait(1100)
            local count = 0
            while not targetSet and count < 50 do
                Citizen.Wait(100)
                count = count + 1
            end

            for serverID, _ in pairs(_passengers) do
                print("Passenger removed: ".. serverID)
                MumbleSetVolumeOverrideByServerId(serverID, -1.0)
                removeTargetTest(serverID, "car")
            end

            -- local passengerCount, passengers = GetVehiclePassengers(_currentvehicle)

            -- for passenger, _ in pairs(passengers) do
            --     serverID = GetPlayerServerId(NetworkGetPlayerIndexFromPed((passenger)))
            --     if serverID ~= _myServerId and serverID ~= 0 then --not _passengers[serverID] and 
            --         print("Passenger removed: ".. serverID)
            --         MumbleSetVolumeOverrideByServerId(serverID, -1.0)
            --         removeTargetTest(serverID, "car")
            --     end
            -- end

            targetSet = false
            _inVeh = false
            _currentvehicle = nil
            _passengers = {}
            RefreshTargets()
        --end
        -- targetSet = true
        -- _inVeh = false
        -- _currentvehicle = nil
        -- _passengers = {}
        UpdateContextVolume("car", -1.0)
    end)
end

function startVehThread()
    while _inVeh do
        local passengerCount, passengers = GetVehiclePassengers(_currentvehicle)
        local passengerID

        -- for serverID, _ in pairs(_passengers) do
        --     if not passengers[NetworkGetEntityFromNetworkId(serverID)] then
        --         print("Passenger removed: ".. serverID)
        --         MumbleSetVolumeOverrideByServerId(serverID, -1.0)
        --         removeTargetTest(serverID, "car")
        --         _passengers[serverID] = nil
        --         RefreshTargets()
        --     end
        -- end

        local temp = {}
        for p, _ in pairs(passengers) do
            local id = GetPlayerServerId(NetworkGetPlayerIndexFromPed((p)))
            if _passengers[id] and id ~= _myServerId and id ~= 0 then
                temp[id] = p
            end
        end

        for serverID, _ in pairs(_passengers) do
            if not temp[serverID] then
                print("Passenger removed: ".. serverID)
                MumbleSetVolumeOverrideByServerId(serverID, -1.0)
                removeTargetTest(serverID, "car")
                _passengers[serverID] = nil
                RefreshTargets()
            end
        end

        for passenger, _ in pairs(passengers) do
            serverID = GetPlayerServerId(NetworkGetPlayerIndexFromPed((passenger)))
            if not _passengers[serverID] and serverID ~= _myServerId and serverID ~= 0 then
                print("Passenger added: " .. serverID)
                --AddPlayerToTargetList(passengerID, "car", false)
                addTargetTest(serverID, "car")
                --MumbleAddVoiceTargetPlayerByServerId(CurrentTarget, serverID)
                MumbleSetVolumeOverrideByServerId(serverID, Config.settings['vehicleVolume'])
                _passengers[serverID] = passenger
            end
        end
        targetSet = true
        Citizen.Wait(500)
    end
end


function GetVehiclePassengers(vehicle)
	local passengers = {}
	local passengerCount = 0
	local seatCount = GetVehicleNumberOfPassengers(vehicle)

	for seat = -1, seatCount do
		if not IsVehicleSeatFree(vehicle, seat) then
			passengers[GetPedInVehicleSeat(vehicle, seat)] = true
			passengerCount = passengerCount + 1
		end
	end

	return passengerCount, passengers
end

RegisterCommand("getp", function()
    local passengerCount, passengers = GetVehiclePassengers(_currentvehicle)
    print(DumpTable(passengers))
    --print(DumpTable(GetVehiclePassengers(_currentvehicle)))
end)


function addPassenger(serverID)

end

function removePassenger(serverID, refresh)

end