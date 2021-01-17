intrunk = false
local frontTrunk = {

}

local disabledTrunk = {
    [1] = "penetrator",
    [2] = "vacca",
    [3] = "monroe",
    [4] = "turismor",
    [5] = "osiris",
    [6] = "comet",
    [7] = "ardent",
    [8] = "jester",
    [9] = "nero",
    [10] = "nero2",
    [11] = "vagner",
    [12] = "infernus",
    [13] = "zentorno",
    [14] = "comet2",
    [15] = "comet3",
    [16] = "comet4",
    [17] = "lp700r",
    [18] = "r8ppi",
    [19] = "911turbos",
    [20] = "rx7rb",
    [21] = "fnfrx7",
    [22] = "delsoleg",
    [23] = "s15rb",
    [24] = "gtr",
    [25] = "fnf4r34",
    [26] = "ap2",
    [27] = "bullet",
}


local offsets = {
	[1] = { ["name"] = "taxi", ["yoffset"] = 0.0, ["zoffset"] = -0.5 },
    [2] = { ["name"] = "buccaneer", ["yoffset"] = 0.5, ["zoffset"] = 0.0 },
    [3] = { ["name"] = "peyote", ["yoffset"] = 0.35, ["zoffset"] = -0.15 },
    [4] = { ["name"] = "regina", ["yoffset"] = 0.2, ["zoffset"] = -0.35 },
    [5] = { ["name"] = "pigalle", ["yoffset"] = 0.2, ["zoffset"] = -0.15 },
    [6] = { ["name"] = "pol3", ["yoffset"] = 0.1, ["zoffset"] = -0.2 },
    [7] = { ["name"] = "glendale", ["yoffset"] = 0.0, ["zoffset"] = -0.35 },
}

local cam = 0
function CamTrunk()
    if(not DoesCamExist(cam)) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
        SetCamRot(cam, 0.0, 0.0, 0.0)
        SetCamActive(cam,  true)
        RenderScriptCams(true,  false,  0,  true,  true)
        SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
    end
  --  local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0,-2.5,1.0))
    AttachCamToEntity(cam, PlayerPedId(), 0.0,-2.5,1.0, true)
 --   SetCamCoord(cam, x, y, z)
    SetCamRot(cam, -30.0, 0.0, GetEntityHeading(PlayerPedId()) )
end

function CamDisable()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
end

function TrunkOffset(veh)
    for i=1,#offsets do
        if GetEntityModel(veh) == GetHashKey(offsets[i]["name"]) then
            return i
        end
    end
    return 0
end

function disabledCarCheck(veh)
    for i=1,#disabledTrunk do
        if GetEntityModel(veh) == GetHashKey(disabledTrunk[i]) then
            return true
        end
    end
    return false
end

function frontTrunkCheck(veh)
    for i=1,#frontTrunk do
        if GetEntityModel(veh) == GetHashKey(frontTrunk[i]) then
            return true
        end
    end
    return false
end

local TrunkedPlate = 0
local trunkveh = 0
function PutInTrunk(veh)
    local disabledCar = disabledCarCheck(veh)
    if disabledCar then
        return
    end
    if not DoesVehicleHaveDoor(veh, 6) and DoesVehicleHaveDoor(veh, 5) and IsThisModelACar(GetEntityModel(veh)) then
    	SetVehicleDoorOpen(veh, 5, 1, 1)
        local Player = PlayerPedId()

        local d1,d2 = GetModelDimensions(GetEntityModel(veh))
        if d2["z"] > 1.4 then
            return
        end

        TrunkedPlate = GetVehicleNumberPlateText(veh)
        intrunk = true
        TriggerEvent("ped:intrunk",intrunk)
        local testdic = "fin_ext_p1-7"
        local testanim = "cs_devin_dual-7"
        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) do
            Citizen.Wait(0)
        end

        SetBlockingOfNonTemporaryEvents(Player, true)      
        SetPedSeeingRange(Player, 0.0)     
        SetPedHearingRange(Player, 0.0)        
        SetPedFleeAttributes(Player, 0, false)     
        SetPedKeepTask(Player, true)   
        DetachEntity(Player)
        ClearPedTasks(Player)
        TaskPlayAnim(Player, testdic, testanim, 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
        local OffSet = TrunkOffset(veh)

        if OffSet > 0 then
        	AttachEntityToEntity(Player, veh, 0, -0.1,(d1["y"]+0.85) + offsets[OffSet]["yoffset"],(d2["z"]-0.87) + offsets[OffSet]["zoffset"], 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
        else
        	AttachEntityToEntity(Player, veh, 0, -0.1,d1["y"]+0.85,d2["z"]-0.87, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
        end
        
        trunkveh = veh

       -- TriggerEvent("animation:PlayAnimation","trunk")
        while intrunk do
            
            HandCuffed = exports["isPed"]:isPed("HandCuffed")
            CamTrunk()
            if HandCuffed then
                Citizen.Wait(1)
            else

                Citizen.Wait(1)
                local DropPosition = GetOffsetFromEntityInWorldCoords(veh, 0.0,d1["y"]-0.2,0.0)

                DrawText3DTest(DropPosition["x"],DropPosition["y"],DropPosition["z"],"[G] Open/Close | [F] Climb Out")

                if IsControlJustReleased(0,47) then

                    if GetVehicleDoorAngleRatio(veh, 5) > 0.0 then
                        SetVehicleDoorShut(veh, 5, 1, 0)
                    else
                        SetVehicleDoorOpen(veh, 5, 1, 0)
                    end
                    
                end
                if IsControlJustReleased(0,23) then
                    TriggerEvent("ped:intrunk",false)
                end                
            end

            intrunk = exports["isPed"]:isPed("intrunk")
			if GetVehicleEngineHealth(veh) < 100.0 or not DoesEntityExist(veh) then
		        TriggerEvent("ped:intrunk",false)
		        SetVehicleDoorOpen(trunkveh, 5, 1, 1)
		        trunkveh = 0
		        TrunkedPlate = 0				
			end

			if not IsEntityPlayingAnim(Player, testdic, testanim, 3) then
				TaskPlayAnim(Player, testdic, testanim, 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
			end

        end
        DoScreenFadeOut(10)
        Citizen.Wait(1000)
        CamDisable()

        DetachEntity(Player)

        if DoesEntityExist(veh) then
        	local DropPosition = GetOffsetFromEntityInWorldCoords(veh, 0.0,d1["y"]-0.5,0.0)
	        SetEntityCoords(Player,DropPosition["x"],DropPosition["y"],DropPosition["z"])
	    end
        DoScreenFadeIn(2000)
    end
end
RegisterNetEvent('ped:forceTrunkSelf')
AddEventHandler('ped:forceTrunkSelf', function()
	playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    v = getVehicleInDirection(coordA, coordB)

    local Player = PlayerPedId()
    local d1,d2 = GetModelDimensions(GetEntityModel(v))
    local back = GetOffsetFromEntityInWorldCoords(v, 0.0,d1["y"]-0.5,0.0)
    if #(back - GetEntityCoords(Player))> 1.0 then
        TriggerEvent("DoLongHudText","You must be near the trunk to do this!",2)
        return
    end
    
    if GetVehicleDoorAngleRatio(v, 5) == 0.0 then
        TriggerEvent("DoLongHudText","The trunk is closed?!",2)
        return
    end

    local Driver = GetPedInVehicleSeat(v, -1)
    if DoesEntityExist(Driver) and not IsPedAPlayer(Driver) then
        TriggerEvent("DoLongHudText","The vehicle is locked!",2)
        return
    end

    local lockStatus = GetVehicleDoorLockStatus(v) 
    if lockStatus ~= 1 and lockStatus ~= 0 then 
        TriggerEvent("DoLongHudText","The vehicle is locked!",2)
        return
    end

    PutInTrunk(v)   
end)


RegisterNetEvent('ped:forceTrunk')
AddEventHandler('ped:forceTrunk', function()
	t, distance = GetClosestPlayer()
	if (distance ~= -1 and distance < 7) then
		playerped = PlayerPedId()
        coordA = GetEntityCoords(playerped, 1)
        coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 10.0, 0.0)
        v = getVehicleInDirection(coordA, coordB)
        if DoesEntityExist(v) then

            local Player = PlayerPedId()
            local d1,d2 = GetModelDimensions(GetEntityModel(v))
            local back = GetOffsetFromEntityInWorldCoords(v, 0.0,d1["y"]-0.5,0.0)
            if #(back - GetEntityCoords(Player))> 1.0 then
                TriggerEvent("DoLongHudText","You must be near the trunk to do this!",2)
                return
            end
            local Driver = GetPedInVehicleSeat(v, -1)
            if DoesEntityExist(Driver) and not IsPedAPlayer(Driver) then
                TriggerEvent("DoLongHudText","The vehicle is locked!",2)
                return
            end
            local lockStatus = GetVehicleDoorLockStatus(v) 
            if lockStatus ~= 1 and lockStatus ~= 0 then 
                TriggerEvent("DoLongHudText","The vehicle is locked!",2)
                return
            end
            if GetVehicleDoorAngleRatio(v, 5) == 0.0 then
                TriggerEvent("DoLongHudText","The trunk is closed?!",2)
                return
            end


			--SetEntityAsMissionEntity(v,false,true)
			local netid = NetworkGetNetworkIdFromEntity(v)	
			TriggerServerEvent("ped:forceTrunkAsk", GetPlayerServerId(t))
		else
			TriggerEvent("DoLongHudText", "Face the vehicle from the trunk!",2)
		end
	else
		TriggerEvent("DoLongHudText", "No player near you (maybe get closer)!",2)
	end
end)

RegisterNetEvent('ped:forcedEnteringVeh')
AddEventHandler('ped:forcedEnteringVeh', function(sender)
	local vehicleHandle = NetworkGetEntityFromNetworkId(sender)
    if vehicleHandle ~= nil then
      	PutInTrunk(vehicleHandle)
    end
end)

RegisterNetEvent('ped:releaseTrunkCheck')
AddEventHandler('ped:releaseTrunkCheck', function()

    playerped = PlayerPedId()


    local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)

    local curplate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))

    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
    if not isInVeh and GetVehicleDoorAngleRatio(targetVehicle, 5) > 0.0 then

        curplate = GetVehicleNumberPlateText(targetVehicle, false)
    else
        TriggerEvent("DoLongHudText","No vehicle found or trunk is closed",2)
        return
    end  

    if curplate then
        TriggerServerEvent("ped:trunkAccepted",curplate)
    end

end)

RegisterNetEvent('ped:releaseTrunkCheckSelf')
AddEventHandler('ped:releaseTrunkCheckSelf', function()
	local HandCuffed = exports["isPed"]:isPed("HandCuffed")
	local dead = exports["isPed"]:isPed("dead")
	local intrunk = exports["isPed"]:isPed("intrunk")
    if not HandCuffed and not dead and intrunk then
	    TriggerServerEvent("ped:trunkAccepted",TrunkedPlate)
	end
end)

RegisterNetEvent('ped:releaseTrunk')
AddEventHandler('ped:releaseTrunk', function(licensePlate)
    if licensePlate == TrunkedPlate then
        TriggerEvent("ped:intrunk",false)
        SetVehicleDoorOpen(trunkveh, 5, 1, 1)
        trunkveh = 0
        TrunkedPlate = 0
    end
end)