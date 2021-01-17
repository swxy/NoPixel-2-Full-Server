RegisterServerEvent('tuner:modify')
AddEventHandler('tuner:modify', function(vehicleTable, vehicleDefaultTable)
    TriggerClientEvent('tuner:setNew', source, vehicleDefaultTable, vehicleTable)
end)