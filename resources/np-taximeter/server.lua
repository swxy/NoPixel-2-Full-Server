-- done ((sway))

RegisterServerEvent('taximeter:freeze')
AddEventHandler('taximeter:freeze', function(plate, boolean)
    TriggerClientEvent('taximeter:FreezePlate', source, plate, boolean)
end)

RegisterServerEvent('taxi:updatemeters')
AddEventHandler('taxi:updatemeters', function(plate, total, perminute, basefare)
    TriggerClientEvent('taximeter:updateFare', -1, plate, total, perminute, basefare)
end)

RegisterServerEvent('taxi:RequestFare')
AddEventHandler('taxi:RequestFare', function()
    TriggerClientEvent('DoLongHudText', source, fare)
end)