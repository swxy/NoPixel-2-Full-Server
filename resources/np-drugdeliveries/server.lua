RegisterServerEvent('oxydelivery:server')
AddEventHandler('oxydelivery:server', function(money)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(source)

	if user:getCash() >= money then
        user:removeMoney(money)

		TriggerClientEvent("oxydelivery:startDealing", source)
    else
        TriggerClientEvent('notification', source, 'You dont have enough money little stupid fucking bitch.', 2)
	end
end)

RegisterServerEvent('drugdelivery:server')
AddEventHandler('drugdelivery:server', function(money)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(source)

	if user:getCash() >= money then
        user:removeMoney(money)
		
		TriggerClientEvent("drugdelivery:startDealing", source)
    else
        TriggerClientEvent('notification', source, 'You dont have enough money.', 2)
	end
end)

local counter = 0
RegisterServerEvent('delivery:status')
AddEventHandler('delivery:status', function(status)
    if status == -1 then
        counter = 0
    elseif status == 1 then
        counter = 2
    end
    TriggerClientEvent('delivery:deliverables', -1, counter, math.random(1,14))
end)