RegisterServerEvent('e-blips:updateBlips')
AddEventHandler('e-blips:updateBlips', function(job, name)
    local src = source
    local data = {
        netId = src,
        job = job,
        callsign = name
    }
    TriggerClientEvent('e-blips:addHandler', src, data)
end)