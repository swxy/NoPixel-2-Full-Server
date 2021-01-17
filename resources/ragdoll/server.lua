RegisterServerEvent('police:isDead')
AddEventHandler('police:isDead', function()
    -- local src = source
	-- local user = exports["np-base"]:getModule("Player"):GetUser(src)
    -- local characterId = user:getVar("character").id
    -- local q = [[SELECT is_dead FROM characters WHERE id = @cid;]]
    -- local v = {
    --     ["isDead"] = newLevel,
    --     ["cid"] = characterId
    -- }
    -- local sex = false
    -- exports.ghmattimysql:execute(q, v, function(result)
    --     if not result[1].is_dead == nil then
    --         TriggerClientEvent('syd:isdead', source, result[1].is_dead)
    --         TriggerClientEvent('updatedead', source, result[1].is_dead)
    --     end
    -- end)
end)

RegisterServerEvent('kill:confirmed')
AddEventHandler('kill:confirmed', function(targetplayer, data)
    -- local src = source
	-- local user = exports["np-base"]:getModule("Player"):GetUser(src)
    -- local characterId = user:getVar("character").id
    -- local q = [[UPDATE characters SET is_dead = @isDead WHERE id = @cid;]]
    -- local v = {
    --     ["isDead"] = data,
    --     ["cid"] = characterId
    -- }
    -- exports.ghmattimysql:execute(q, v, function()
    -- end)
end)

RegisterServerEvent('reviveGranted')
AddEventHandler('reviveGranted', function(t)
	TriggerClientEvent('reviveFunction', t)
end)

RegisterServerEvent('trycpr')
AddEventHandler('trycpr', function()
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local price = 10000
    if user:getCash() >= price then
        user:removeMoney(price)
        TriggerClientEvent('trycpr', source)
    else
        TriggerClientEvent('DoLongHudText', source, "You can't afford that CPR", 2)
    end
end)

RegisterServerEvent('serverCPR')
AddEventHandler('serverCPR', function()
	TriggerClientEvent('revive', source)
end)