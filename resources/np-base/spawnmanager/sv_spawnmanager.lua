NPX.SpawnManager = {}

RegisterServerEvent('np-base:spawnInitialized')
AddEventHandler('np-base:spawnInitialized', function()
    local src = source
    TriggerClientEvent('np-base:spawnInitialized', src)
end)