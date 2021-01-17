local isBroadcasting = false
local takingService = {
	{x=1989.08, y=-1753.94, z=-158.86},
}

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

-- #MarkedForMarker
function isNearTakeService()
	for i = 1, #takingService do
		local ply = PlayerPedId()
		local plyCoords = GetEntityCoords(ply, 0)
		local distance = #(vector3(takingService[i].x, takingService[i].y, takingService[i].z) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
		if(distance < 3.0) then
			DrawText3Ds(takingService[i].x, takingService[i].y, takingService[i].z, "[E] To Broadcast Here ,[F] Stop Broadcasting Here" )
		end
		if(distance < 3.0) then
			return true
		end
	end
end

function isNearBroadcast()
	for i = 1, #takingService do
		local ply = PlayerPedId()
		local plyCoords = GetEntityCoords(ply, 0)
		local distance = #(vector3(takingService[i].x, takingService[i].y, takingService[i].z) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
		if(distance < 30.0) then
			return true
		end
	end
end

RegisterNetEvent('event:control:broadcast')
AddEventHandler('event:control:broadcast', function(useID)
    if useID == 1 then
    	TriggerServerEvent('attemptBroadcast')	
    elseif useID == 2 and isBroadcasting then
    	isBroadcasting = false
		TriggerServerEvent("TokoVoip:removePlayerFromAllRadio",GetPlayerServerId(PlayerId()))
		TriggerServerEvent("jobssystem:jobs", "unemployed")
	    TriggerEvent("DoLongHudText",'You have left the boradcasting job!',1)
	    Wait(1200)
    end
end)


function becomeJob()
	TriggerServerEvent("TokoVoip:addPlayerToRadio",19829, GetPlayerServerId(PlayerId()))
	isBroadcasting = true
end
RegisterNetEvent("broadcast:becomejob");
AddEventHandler("broadcast:becomejob", becomeJob);

-- #MarkedForMarker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isBroadcasting and not isNearBroadcast() then
			isBroadcasting = false
			TriggerServerEvent("TokoVoip:removePlayerFromAllRadio",GetPlayerServerId(PlayerId()))
			TriggerServerEvent("jobssystem:jobs", "unemployed")
		    TriggerEvent("DoLongHudText",'You have left the boradcasting job!',1)
		    Wait(1200)
		end

		if not isNearTakeService() then	
			Wait(1200)
		end
	end
end)
