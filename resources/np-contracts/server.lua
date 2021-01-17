RegisterServerEvent('server:contractsend')
AddEventHandler('server:contractsend', function(target, amount, info)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local target = exports["np-base"]:getModule("Player"):GetUser(target)
    local char = user:getCurrentCharacter()
    local targetchar = target:getCurrentCharacter()

    if user then
        if amount and type(tonumber(amount)) == 'number' then
            TriggerClientEvent("contract:requestaccept", target.source, amount, info, src)
            exports.ghmattimysql:execute("INSERT INTO contracts (sender, reciever, amount, info, paid) VALUES (@sender, @reciever, @amount, @info, @paid)", {['sender'] = char.id, ['reciever'] = targetchar.id, ['amount'] = amount, ['info'] = info, ['paid'] = false})
        else
            TriggerClientEvent('DoLongHudText', src, 'Invaild contract amount.', 2)
        end
    else
        TriggerClientEvent('DoLongHudText', src, 'Invalid Citizen.', 2)
    end
end)

RegisterServerEvent("contract:accept")
AddEventHandler("contract:accept", function(price,strg,target,accepted)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local target = exports["np-base"]:getModule("Player"):GetUser(target)
    local char = user:getCurrentCharacter()
    local targetchar = target:getCurrentCharacter()

    if accepted then
        if user:getCash() >= tonumber(price) then
            TriggerClientEvent('DoLongHudText', target, 'The citizen accepted your contract and paid $' .. price .. '.', 1)
            user:removeMoney(price)
            target:addMoney(price)
            exports.ghmattimysql:execute("UPDATE contracts SET paid = @paid WHERE sender = @sender and reciever = @reciever", {['paid'] = true, ['sender'] = char.id, ['reciever'] = targetchar.id})
        else
            TriggerClientEvent('DoLongHudText', src, 'You dont have enough money.', 2)
        end
    else
        TriggerClientEvent('DoLongHudText', target, 'The citizen denied your contract.', 2)
    end
end)