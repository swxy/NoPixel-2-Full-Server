-- FiveM Heli Cam by davwheat and mraes edit for nopixel by Nikez
-- Version 2.0 05-11-2018 (DD-MM-YYYY)
RegisterServerEvent("heli:spotlight_on")
RegisterServerEvent("heli:spotlight_off")
RegisterServerEvent("heli:spotlight_update")

AddEventHandler("heli:spotlight_on", function(playerId)
    TriggerClientEvent("heli:spotlight_on", -1, playerId, 0)
end)

AddEventHandler("heli:spotlight_off", function(playerId)
    TriggerClientEvent("heli:spotlight_off", -1, playerId, 0)
end)

AddEventHandler("heli:spotlight_update", function(playerId, data)
    TriggerClientEvent("heli:spotlight_update", -1, playerId, data)
end)