local inside = {}
local spawnedxd = false

RegisterServerEvent('request:spawn')
AddEventHandler('request:spawn', function()
    local src = source
    if not spawnedxd then
        spawnedxd = true
        TriggerClientEvent("accept:vinewoodspawn",src,true)
    else
        TriggerClientEvent("accept:vinewoodspawn",src,false)
    end
    inside[#inside+1] = src
end)