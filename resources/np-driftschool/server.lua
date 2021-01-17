RegisterServerEvent('np-driftschool:takemoney')
AddEventHandler('np-driftschool:takemoney', function(data)
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    
    if user:getCash() >= data then
    user:removeMoney(data)
    TriggerClientEvent('np-driftschool:tookmoney', source, true)
    else
        TriggerClientEvent('DoLongHudText', source, 'You dont have enough money to do that little bitch.', 2)
    end
end)