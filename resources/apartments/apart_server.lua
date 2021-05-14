RegisterServerEvent('house:updatespawns')
AddEventHandler('house:updatespawns', function(table, garageswiped, startingGarages)
    local src = source
    TriggerClientEvent('house:spawnpoints', src, table)
end)

-- RegisterServerEvent('house:purchasehouse')
-- AddEventHandler('house:purchasehouse', function(house_id,house_model,price,name,backdoor,x,y,z)
--     exports.ghmattimysql:execute("INSERT INTO houses cid, price, id, model, name, backdoor, coords) VALUE (@cid, @price, @id, @model, @name, @backdoor, @coords)", {
--         ['@cid'] = cid,
--         ['@price'] = price,
--         ['@id'] = house_id,
--         ['@model'] = house_model,
--         ['@name'] = name,
--         ['@backdoor'] = backdoor,
--         ['@coords'] = json.encode(x,y,z)
--     })
-- end)


RegisterServerEvent('ReturnHouseKeys')
AddEventHandler('ReturnHouseKeys', function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    exports.ghmattimysql:execute('SELECT * FROM houses WHERE `cid` = @id', { ['@id'] = char.id }, function(result)
        if result[1] ~= nil then
            for i = 1, #result do
                local lol = json.decode(result[i].data)
                TriggerClientEvent('returnPlayerKeys', src, json.encode(result[i]), json.encode(result[i]))
                -- TriggerClientEvent('house:returnKeys', src, result[1].mykeys, lol["info"])
            end
        else
            print("its nil")
        end
    end)
end)



RegisterServerEvent('housing:attemptsale')
AddEventHandler('housing:attemptsale', function(args,price,hid,model)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local target = exports["np-base"]:getModule("Player"):GetUser(args)
    local targetchar = user:getCurrentCharacter()

    if target:getCash() >= price then
        target:removeMoney(price)
        exports.ghmattimysql:execute("UPDATE houses SET `cid` = @cid, `price` = @price, `model` = @model WHERE `id` = @id", {
            ['@cid'] = targetchar.id,
            ['@price'] = price,
            ['@id'] = hid,
            ['@model'] = model
        })
    else
        TriggerClientEvent('DoShortHudText', args, 'You dont got money pussy', 2)
    end
end)

RegisterServerEvent('housing:requestSpawnTable')
AddEventHandler('housing:requestSpawnTable', function(table, id)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
        exports.ghmattimysql:execute('SELECT * FROM houses WHERE `id` = @id', { ['@id'] = id }, function(result)
            if result[1] ~= nil then
                print('dont do shit bitch')
                    TriggerClientEvent('UpdateCurrentHouseSpawns', src, id, result[1].data)
                    print(json.encode(result[1].data))
            else
                exports.ghmattimysql:execute("INSERT INTO houses (data, id) VALUES (@data, @id)", {
                ['@id'] = id,
                ['@data'] = json.encode(table)
                })
            end
        end)
end)

RegisterServerEvent('house:updatespawns')
AddEventHandler('house:updatespawns', function(info, hid)
local src = source
local table = info
local house_id = hid
    exports.ghmattimysql:execute('SELECT * FROM houses WHERE id = ?', {hid}, function(result)
        exports.ghmattimysql:execute("UPDATE houses SET `data` = @data WHERE `id` = @id", {
            ['@data'] = json.encode(table),
            ['@id'] = house_id
        })
        TriggerClientEvent('UpdateCurrentHouseSpawns', src, hid, json.encode(info))
            -- print(json.encode(table))
            print('lol')
    end)
end)

RegisterServerEvent('house:givekey')
AddEventHandler('house:givekey', function(id, model, target)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local zUser = exports["np-base"]:getModule("Player"):GetUser(target)
    local zchar = user:getCurrentCharacter()
    local tIdentifier = zchar.id
        exports.ghmattimysql:execute("SELECT * FROM houses WHERE id = @id AND model = @model", {
            ['@id'] = id,
            ['@model'] = model
        }, function(result)
            print(result[1].cid)
        if result[1].cid == char.id then  
            local mykeys = json.decode(result[1].mykeys)
            for i= 1, #mykeys do
                if mykeys[i] == tIdentifier then
                    TriggerClientEvent('DoLongHudText', src, 'You already gave key to this person.')
                    TriggerClientEvent('DoLongHudText', target, 'You already received key for this house.')
                    return
                end
            end

            table.insert(mykeys, tIdentifier)
            if result[1].mykeys ~= nil then
                print('giving keys')
                exports.ghmattimysql:execute("UPDATE houses SET `mykeys` = @mykeys WHERE `id` = @id AND `model` = @model", {
                    ['@mykeys'] = json.encode(mykeys),
                    ['@id'] = id,
                    ['@model'] = model
                }, function(result)
                    print(target)
                    TriggerClientEvent('DoLongHudText', target, 'You received key to a house.')
                end)
            end
        else
            TriggerClientEvent('DoLongHudText', src, 'You dont own this house.', 2)
        end
    end)
end)

RegisterServerEvent('CheckFurniture')
AddEventHandler('CheckFurniture', function(house_id, model)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM houses WHERE id = ?', {house_id}, function(result)
        TriggerClientEvent('openFurnitureConfirm', src, house_id, model, json.decode(result[1].furniture))
    end)
end)


RegisterServerEvent('UpdateFurniture')
AddEventHandler('UpdateFurniture', function(hid, model2, objects)
    exports.ghmattimysql:execute("UPDATE houses SET `furniture` = @furniture WHERE `id` = @id AND `model` = @model", {
        ['@furniture'] = json.encode(objects),
        ['@id'] = hid,
        ['@model'] = model2
    })
    print(hid, model2)
    print(json.encode(objects))
    print('updating')
end)


RegisterServerEvent('house:enterhouse')
AddEventHandler('house:enterhouse', function(house_id,house_model,bool)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    exports.ghmattimysql:execute('SELECT * FROM houses WHERE id = ?', {house_id}, function(result)
        local keys = json.decode(result[1].mykeys)
        if result[1].cid == char.id then
            TriggerClientEvent('UpdateCurrentHouseSpawns', src, house_id, result[1].data)
            TriggerClientEvent('house:entersuccess', src, house_id, house_model, json.decode(result[1].furniture))
        else
            TriggerClientEvent('DoLongHudText', src, "You dont have a key for that house", 2)
            print('you dont have a house BUDDY')
        end
        for i = 1,#keys do
            if keys[i] == char.id then
                print(json.encode(result[1].mykeys))
                print(char.id)
                TriggerClientEvent('UpdateCurrentHouseSpawns', src, house_id, result[1].data)
                TriggerClientEvent('house:entersuccess', src, house_id, house_model,json.decode(result[1].furniture))
            end
        end
    end)
end)

RegisterServerEvent('houserobberies:enter')
AddEventHandler('houserobberies:enter', function(robnum, ismansion, flashbang)
    local src = source
	TriggerClientEvent('houserobberies:createhouse', src, robnum, false, flashbang)
	TriggerClientEvent('houserobberies:enterhouse', src, robnum, flashbang)
end)

RegisterServerEvent('houserobberies:exit')
AddEventHandler('houserobberies:exit', function(houseid, ismansion2, backdoor)
    local src = source
	TriggerClientEvent('houserobberies:delete', src, houseid, backdoor)
end)

RegisterServerEvent("houses:PropertyListing")
AddEventHandler("houses:PropertyListing", function()
    -- select houses and send to phone

    exports.ghmattimysql:execute('SELECT * FROM houses WHERE `cid` = @cid', { ['@cid'] = cid }, function(result)
         if result[1] ~= nil then
             for i = 1, #result do
                 local lol = json.decode(result[i].data)
                 -- TriggerClientEvent('returnPlayerKeys', src, result[1].cid, result[1].mykeys, lol["info"], result[1].model, result[1].id)
                TriggerClientEvent("phone:listREproperties", src)
             end
         else
             TriggerClientEvent('houses:retrieveHouseKeys', src)
         end
     end)
end)

-- RegisterServerEvent('house:retrieveKeys')
-- AddEventHandler('house:retrieveKeys', function(house_id, house_model)
--     local src = source
--     local shared = {}
--     exports.ghmattimysql:execute('SELECT * FROM __housekeys WHERE `house_id`= ?', {house_id}, function(data)
--         for k, v in pairs(data) do
--             if v ~= nil then
--                 if v.house_id == house_id then
--                     local random = math.random(1111,9999)
--                     shared[random] = {}
--                     local player = exports['srp-base']:getModule("Player"):getCharacterFromCid(v.cid)
--                     local name = player.first_name .. " " .. player.last_name
--                     table.insert(shared[random], {["sharedHouseName"] = v.housename, ["sharedId"] = v.cid, ["sharedName"] = name})
--                     TriggerClientEvent('house:returnKeys', src, shared)
--                 end
--             end
--         end
--     end)
-- end)

-- RegisterServerEvent('house:removeKey')
-- AddEventHandler('house:removeKey', function(house_id, house_model, target)
--     local src = source
--     local player = exports['srp-base']:getModule("Player"):getCharacterFromCid(target)
--     exports.ghmattimysql:execute('DELETE FROM __housekeys WHERE `house_id`= ? AND `house_model`= ? AND `cid`= ?', {house_id, house_model, target})
--     TriggerClientEvent('DoLongHudText', src, "You removed " .. player.first_name .. " " .. player.last_name .. "'s keys.")
--     TriggerClientEvent('DoLongHudText', player.playerSrc, "Your keys were removed by the home owner.", 2)
-- end)

RegisterServerEvent('aidsarea')
AddEventHandler("audsarea", function(add,x,y,z,h)
    TriggerClientEvent("aidsarea",-1,add,x,y,z,h)
end)
