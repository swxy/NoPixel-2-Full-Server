local robbedvehicles = {}
-- done ((Sydres))

RegisterServerEvent('sec:checkRobbed')
AddEventHandler('sec:checkRobbed', function(data)
        if robbedvehicles[data] ~= data then
            TriggerClientEvent('sec:AllowHeist', source)
            table.insert(robbedvehicles, data)
        else
            print("lol dumb this is robbed already fp")
        end
end)