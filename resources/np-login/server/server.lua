RegisterServerEvent('np-login:disconnectPlayer')
AddEventHandler('np-login:disconnectPlayer', function()
    local src = source
    DropPlayer(src, "You have been disconnected from the server")
end)

RegisterServerEvent('np-login:getPlayerInformation')
AddEventHandler('np-login:getPlayerInformation', function()
    local src = source
    --
end)

