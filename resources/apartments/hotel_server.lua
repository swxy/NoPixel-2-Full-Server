local roomSV = 0


RegisterServerEvent("hotel:createRoom")
AddEventHandler("hotel:createRoom", function(cid)
    local src = source
    exports.ghmattimysql:execute("INSERT INTO user_apartment cid, roomType, mykeys, ilness, isImprisoned, isClothesSpawn, cash) VALUE (@cid, @roomType, @mykeys, @ilness, @isImprisoned, @isClothesSpawn, @cash)", {
        ['@cid'] = cid,
        ['@roomType'] = 1,
        ['@mykeys'] = true,
        ['@ilness'] = false,
        ['@isImprisoned'] = false,
        ['isClothesSpawn'] = true,
        ['cash'] = 0,
    })
    TriggerEvent('refresh', cid)
end)

RegisterServerEvent('hotel:load')
AddEventHandler('hotel:load', function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
	
	-- Sometimes runs before character is selected
	if not user then 
		return 
	end
	
    local char = user:getCurrentCharacter()
    local charachter = user:getCurrentCharacter()

    local name = charachter.first_name .. ' ' .. charachter.last_name
    exports.ghmattimysql:execute('SELECT * FROM user_apartment WHERE cid = @cid', {["cid"] = char.id}, function(result)
            if(result[1]) then
                    TriggerClientEvent('hotel:createRoomFirst', src, result[1].room, result[1].roomType)
                    TriggerClientEvent('hotel:SetID', src, result[1].room)
                else
                    roomSV = roomSV + 1
                    TriggerClientEvent('hotel:createRoomFirst', src, roomSV, 1)
                    TriggerClientEvent('hotel:SetID', src, roomSV)
            end
    end)
end)





RegisterServerEvent('hotel:updateLockStatus')
AddEventHandler('hotel:updateLockStatus', function(status)
    local src = source
    TriggerClientEvent('hotel:updateLockStatus', src, status)
end)


RegisterServerEvent("hotel:AddCashToHotel")
AddEventHandler('hotel:AddCashToHotel', function(clientcash, cid)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    
    if user:getCash() >= tonumber(clientcash) then
        exports.ghmattimysql:execute("UPDATE user_apartment SET `cash` = cash + @cash WHERE cid = @cid",{
           ['@cash'] = clientcash,
           ['@cid'] = cid
         }, function(data)
            user:removeMoney(clientcash)
            TriggerClientEvent("DoLongHudText", src, "You deposited "..clientcash.."$ to your apartment.", 1)
       end)
    else
        TriggerClientEvent("DoLongHudText", src, "You dont have enough money fuck off.", 2)
    end
end)

RegisterServerEvent("hotel:RemoveCashFromHotel")
AddEventHandler('hotel:RemoveCashFromHotel', function(clientcash, cid)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    
    exports.ghmattimysql:execute("SELECT cash FROM user_apartment WHERE cid = @cid", {['@cid'] = cid}, function (result)
        if tonumber(result[1].cash) >= tonumber(clientcash) then
            exports.ghmattimysql:execute("UPDATE user_apartment SET `cash` = cash - @cash WHERE cid = @cid",{
                ['@cash'] = clientcash,
                ['@cid'] = cid
              }, function(data)
            end)
            user:addMoney(clientcash)
            TriggerClientEvent("DoLongHudText", src, "You took "..clientcash.."$ from your apartment.", 1)
        else
            TriggerClientEvent("DoLongHudText", src, "You dont have that much in your apartmend stooopid.", 2)
        end
    end)
end)

RegisterServerEvent('hotel:CheckCashFromHotel')
AddEventHandler('hotel:CheckCashFromHotel', function(cid)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local money = 0

    exports.ghmattimysql:execute("SELECT cash FROM user_apartment WHERE cid = @cid", {['@cid'] = cid}, function (result)
        if (result) then
          money = result[1].cash
          TriggerClientEvent('DoLongHudText', src, "Current amount in your room: "..tonumber(result[1].cash).."$", 1)
        end
    end)
end)



RegisterServerEvent('hmm')
AddEventHandler('hmm', function(source)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    exports.ghmattimysql:execute('SELECT * FROM user_apartment WHERE cid = @cid', {["cid"] = char.id}, function(result)
    roomSV = result[1].room
    roomSV = (roomSV - 1)
    exports.ghmattimysql:execute("ALTER TABLE user_apartment AUTO_INCREMENT = @cid", {["cid"] = char.id})
        TriggerEvent('hotel:delete', cid)
    end)
end)


RegisterServerEvent('hotel:upgradeApartment')
AddEventHandler('hotel:upgradeApartment', function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    
    if (tonumber(user:getCash()) >= 25000) then
            user:removeMoney(25000)
            exports.ghmattimysql:execute("INSERT INTO user_apartment (cid, roomType, mykeys, ilness, isImprisoned, isClothesSpawn, cash) VALUE (@cid, @roomType, @mykeys, @ilness, @isImprisoned, @isClothesSpawn, @cash)", {
                ['@cid'] = char.id,
                ['@roomType'] = 2,
                ['@mykeys'] = true,
                ['@ilness'] = false,
                ['@isImprisoned'] = false,
                ['isClothesSpawn'] = true,
                ['cash'] = 0,
            })
            exports.ghmattimysql:execute('SELECT * FROM user_apartment WHERE cid = @cid', {["cid"] = char.id}, function(result)
                Citizen.Wait(3000)
                TriggerClientEvent('hotel:createRoomFirst', src, result[1].room, 2)
                TriggerClientEvent('hotel:SetID', src, result[1].room)
            end)
        else
            TriggerClientEvent("DoShortHudText",src, "You need $25000 + Tax.",2)
        end
    end)

RegisterServerEvent('refresh')
AddEventHandler('refresh', function(cid)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM user_apartment WHERE cid = @cid', {["cid"] = cid}, function(result)
        Citizen.Wait(3000)
        TriggerClientEvent('hotel:createRoomFirst', src, result[1].room, result[1].roomType)
        TriggerClientEvent('hotel:SetID', src, result[1].room)
    end)
end)



AddEventHandler('playerDropped', function()
    roomSV = (roomSV - 1)
    if roomSV == -1 then
        roomSV = 0
    end
end)