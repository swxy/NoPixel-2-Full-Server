RegisterServerEvent('keys:send')
AddEventHandler('keys:send', function(player, data)
    TriggerClientEvent('keys:received', player, data)
end)