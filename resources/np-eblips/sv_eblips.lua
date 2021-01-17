RegisterServerEvent('e-blips:updateBlips')
AddEventHandler('e-blips:updateBlips', function(id, job, name)
    local src = source
    local data = {
        netId = id,
        job = job,
        callsign = name
    }
    TriggerClientEvent('e-blips:addHandler', source, data)
end)