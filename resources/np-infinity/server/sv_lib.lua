
RegisterServerEvent('np:infinity:player:ready')
AddEventHandler('np:infinity:player:ready', function()
    local coords = GetEntityCoords(GetPlayerPed(source))
    
    TriggerClientEvent('np:infinity:player:coords', -1, coords)
end)

RegisterServerEvent('np:infinity:entity:coords')
AddEventHandler('np:infinity:entity:coords', function(netId)
    local coords = GetEntityCoords(GetPlayerPed(netId))
    
    TriggerClientEvent('np:infinity:player:coords', source, coords)
end)
--[[
 Citizen.CreateThread(function()
     while true do
         Citizen.Wait(30000)
         local sexinthetube = GetEntityCoords(GetPlayerPed(source))
         if source == nil then return end
       TriggerClientEvent('np:infinity:player:coords', source, sexinthetube)
         TriggerEvent("np-base:updatecoords", sexinthetube.x, sexinthetube.y, sexinthetube.z)
   print("[^2np-infinity^0]^3 Sync Successful.^0")
     end
 end)

 ---]]