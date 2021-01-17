local plateChangesReturn = {}

RegisterServerEvent('carfill:checkmoney')
AddEventHandler('carfill:checkmoney', function(costs, location)
	local src = source
	local player = exports["np-base"]:getModule("Player"):GetUser(src)

	if player:getCash() >= costs then
		TriggerClientEvent("RefuelCarServerReturn", src)
		player:removeMoney(costs)
	else
		moneyleft = costs - player:getCash()
		TrigerClientEvent('DoLongHudText', src, "Requires $" .. costs)
	end
end)

RegisterServerEvent('vehicle:coords')
AddEventHandler('vehicle:coords', function(plate,coords)
	local coords = json.encode(coords)
	local fakePlate = plateChangesReturn[plate]
	if fakePlate ~= nil then
		-- fix fake plates
		plate = plateChangesReturn[plate]
	end
	exports.ghmattimysql:execute("UPDATE characters_cars SET coords=@coords WHERE license_plate = @plate",
		{['coords'] = coords, ['plate'] = plate})
end)

RegisterServerEvent('GPSTrack:Accepted')
AddEventHandler('GPSTrack:Accepted', function(x,y,z,stage)
	local srcid = source
	TriggerClientEvent("GPSTrack:Accepted",-1,x,y,z,srcid,stage)
end)

local max_number_weapons = 55
local cost_radio = 100

RegisterServerEvent('car:spotlight')
AddEventHandler('car:spotlight', function(state)
	local serverID = source
	TriggerClientEvent('car:spotlight', -1, serverID, state)
end)

local locations = {}

RegisterNetEvent("facewear:adjust")
AddEventHandler("facewear:adjust", function(pTargetId, pType, pShouldRemove)
	TriggerClientEvent("facewear:adjust", pTargetId, pType, pShouldRemove)
end)

RegisterCommand("anchor", function(source, args, rawCommand)
    TriggerClientEvent('client:anchor', source)
end)