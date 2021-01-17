local spikeCoords = {}
local spikeobject = 0
local spikeobject2 = 0
local spikeobject3 = 0
local spikesBlip = nil
local placedSpikes = true
local loadspikes = true
function SetSpikesOnGround(amount)

	TriggerEvent("animation:PlayAnimation","layspike")
	Citizen.Wait(1000)
	local heading = GetEntityHeading(PlayerPedId())

	for i=1,amount do
		local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, -1.5+(3.5*i), 0.15)
		TriggerServerEvent("police:spikesLocation",pos["x"],pos["y"],pos["z"],heading)
	end

    if spikesBlip ~= nil then
    	RemoveBlip(spikesBlip)
    end
    local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 2.5, 0.15)
    spikesBlip = AddBlipForCoord(pos["x"],pos["y"],pos["z"])

    SetBlipSprite(spikesBlip, 238)
	SetBlipScale(spikesBlip, 1.2)
	SetBlipAsShortRange(spikesBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Last Road Spikes")
	EndTextCommandSetBlipName(spikesBlip)
	TriggerEvent("DoLongHudText","You have placed down a spike strip.",1)
end



Citizen.CreateThread(function()
  	while true do
   		Citizen.Wait(1)
	    local ped = PlayerPedId()
	    local veh = GetVehiclePedIsIn(ped, false)
	    local vehCoord = GetEntityCoords(veh)
	    local spikesOut = #spikeCoords
	    if IsPedInAnyVehicle(ped, false) then
	    	local d1,d2 = GetModelDimensions(GetEntityModel(veh))
	    	local driverPed = GetPedInVehicleSeat(veh, -1)
			if spikesOut == 0 or driverPed ~= PlayerPedId() then
				if driverPed ~= PlayerPedId() then
					Citizen.Wait(1000)
				else
					Citizen.Wait(150)
				end
			else
				for i = 1, #spikeCoords do
					local curDst = #(vector3(spikeCoords[i]["x"],spikeCoords[i]["y"],spikeCoords[i]["z"]) - GetEntityCoords(PlayerPedId()))
					if curDst < 35.0 and not spikeCoords[i]["watching"] then
						spikeCoords[i]["watching"] = true
						TriggerEvent("spikes:watchtarget",i)
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
    end
end)

Citizen.CreateThread(function()
  	while true do
   		Citizen.Wait(1000)
	    for k,v in pairs(spikeCoords) do
	    	local curDst = #(vector3(v["x"],v["y"],v["z"]) - GetEntityCoords(PlayerPedId()))
	    	if curDst < 85.0 then
		    	if v["placed"] == false or not DoesEntityExist(v["object"]) then
		    		deRenderSpikes(k)
					RenderSpikes(k)
				end
			else
				if v["placed"] == true or v["object"] ~= nil then
					deRenderSpikes(k)
				end
			end
			Wait(100)
	    end
    end
end)


function RenderSpikes(k)

	if not loadspikes then return end
	if spikeCoords[k].placed == true or spikeCoords[k].object ~= nil then return end
	spikeCoords[k].placed = true
	local spike = `P_ld_stinger_s`

    RequestModel(spike)
    while not HasModelLoaded(spike) do
      Citizen.Wait(1)
    end


	local SpikeObject = CreateObject(spike,spikeCoords[k].x,spikeCoords[k].y,spikeCoords[k].z, 0, 1, 1) -- x+1
    PlaceObjectOnGroundProperly(SpikeObject)
	SetEntityHeading(SpikeObject,spikeCoords[k].h)
	FreezeEntityPosition(SpikeObject,true)

	spikeCoords[k].object = SpikeObject
end

function deRenderSpikes(k)
	local spike = spikeCoords[k].object
	DeleteObject(spike)
  	if DoesEntityExist(spike) then
      	SetEntityAsNoLongerNeeded(spike)
      	DeleteObject(spike)
  	end
  	if not DoesEntityExist(spike) then
	  	spikeCoords[k].placed = false
		spikeCoords[k].object = nil
	end
end

RegisterNetEvent('addSpikes')
AddEventHandler('addSpikes', function(newspikelist,spikeID)
    spikeCoords[spikeID] = newspikelist
end)

RegisterNetEvent('removeSpikes')
AddEventHandler('removeSpikes', function(spikeID)

	local found = false
	local src = GetPlayerServerId(PlayerId())
	if spikeCoords[spikeID].id == src then
		found = true
	end

	if found and DoesBlipExist(spikesBlip) then TriggerEvent("DoLongHudText","Your spike strips were picked up.",1) RemoveBlip(spikesBlip) end

	if spikeCoords[spikeID] ~= nil then
		table.remove(spikeCoords,spikeID)
	end

end)

RegisterNetEvent('c_setSpike')
AddEventHandler('c_setSpike', function()
    local src = GetPlayerServerId(PlayerId())
	local found = false
	for k,v in pairs(spikeCoords) do
		if v.id == src then
			found = true
		end
	end
	if found then TriggerEvent("DoLongHudText","You already have spikes down.",2) return end

    SetSpikesOnGround(3)
end)

RegisterNetEvent('police:spikesup')
AddEventHandler('police:spikesup', function()
	if not loadspikes then
		TriggerEvent("DoLongHudText","You are already picking up spikes you little bitch.",2)
		return
	end
	loadspikes = false
	local removing = true
	local attempt = 0
	TriggerEvent("animation:PlayAnimation","layspike")

	while removing do
		removeSpikeStanding()
		Citizen.Wait(1000)
		attempt = attempt + 1
		if attempt > 4 then removing = false end
	end

	TriggerEvent("DoLongHudText","You have picked up a spike strip.",1)
	Wait(1000)
	loadspikes = true
end)


function removeSpikeStanding()
  for k,v in pairs(spikeCoords) do
    local curDst = #(vector3(v["x"],v["y"],v["z"]) - GetEntityCoords(PlayerPedId()))
    if curDst < 15.0 then
      local spike = v.object
      DeleteObject(spike)
      SetEntityAsNoLongerNeeded(spike)
      spikeRemoved = false
      TriggerServerEvent("police:removespikes",k)
      return
    end
  end
end

RegisterNetEvent('spikes:watchtarget')
AddEventHandler('spikes:watchtarget', function(watchsent)
	local watching = watchsent
	while true do
		Citizen.Wait(1)
	    local ped = PlayerPedId()
	    local veh = GetVehiclePedIsIn(ped, false)
	    local vehCoord = GetEntityCoords(veh)
	    local d1,d2 = GetModelDimensions(GetEntityModel(veh))
	   	local driverPed = GetPedInVehicleSeat(veh, -1)
	    if not IsPedInAnyVehicle(ped, false) then
	    	return
	    end
	    if driverPed ~= PlayerPedId() then 
	    	return
	    end
		if spikeCoords[watching] == nil then
			return
		end
		
		if #(vector3(spikeCoords[watching]["x"],spikeCoords[watching]["y"],spikeCoords[watching]["z"]) - GetEntityCoords(PlayerPedId())) > 40.0 then
			spikeCoords[watching]["watching"] = false
			return
		end
		if not spikeCoords[watching]["watching"] then
			return
		end
		
		local spikeC = {["x"] = spikeCoords[watching]["x"],["y"] = spikeCoords[watching]["y"],["z"] = spikeCoords[watching]["z"]}
        local leftfront = GetOffsetFromEntityInWorldCoords(veh, d1["x"]-0.25,0.25,0.0)
        local rightfront = GetOffsetFromEntityInWorldCoords(veh, d2["x"]+0.25,0.25,0.0)
        local leftback = GetOffsetFromEntityInWorldCoords(veh, d1["x"]-0.25,-0.85,0.0)
        local rightback = GetOffsetFromEntityInWorldCoords(veh, d2["x"]+0.25,-0.85,0.0)

        local frontlclose = false
        local frontrclose = false
		local backlclose = false
		local backrclose = false

      	if #(vector3(spikeC["x"],spikeC["y"],spikeC["z"]) - leftfront) < 1.5 then
      		frontlclose = true
  			SetVehicleTyreBurst(veh, 0, true, 1000.0)
  			SetVehicleTyreBurst(veh, 1, false, 1000.0)
  			SetVehicleTyreBurst(veh, 2, false, 1000.0)
    	end

      	if #(vector3(spikeC["x"],spikeC["y"],spikeC["z"]) - rightfront) < 1.5 then
      		frontrclose = true
  			SetVehicleTyreBurst(veh, 1, true, 1000.0)
  			SetVehicleTyreBurst(veh, 0, false, 1000.0)
  			SetVehicleTyreBurst(veh, 2, false, 1000.0)
  			SetVehicleTyreBurst(veh, 3, false, 1000.0)
    	end

      	if #(vector3(spikeC["x"],spikeC["y"],spikeC["z"]) - leftback) < 1.5 then
      		backlclose = true
  			SetVehicleTyreBurst(veh, 2, true, 1000.0)
  			SetVehicleTyreBurst(veh, 1, false, 1000.0)
  			SetVehicleTyreBurst(veh, 0, false, 1000.0)
  			SetVehicleTyreBurst(veh, 3, false, 1000.0)			      		
    	end

      	if #(vector3(spikeC["x"],spikeC["y"],spikeC["z"]) - rightback) < 1.5 then
      		backrclose = true
			SetVehicleTyreBurst(veh, 3, true, 1000.0)
			SetVehicleTyreBurst(veh, 4, false, 1000.0)
			SetVehicleTyreBurst(veh, 5, false, 1000.0)
			SetVehicleTyreBurst(veh, 6, false, 1000.0)
			SetVehicleTyreBurst(veh, 7, false, 1000.0)      		
    	end
	end
end)



