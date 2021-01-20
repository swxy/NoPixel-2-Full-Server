--[[Citizen.CreateThread(function()
    TriggerEvent('deleteAllYP')
end)--]]

local callID = nil

--[[ Twitter Stuff ]]
RegisterNetEvent('GetTweets')
AddEventHandler('GetTweets', function(onePlayer)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM (SELECT * FROM tweets ORDER BY `time` DESC LIMIT 50) sub ORDER BY time ASC', {}, function(tweets) -- Get most recent 100 tweets
        if onePlayer then
            TriggerClientEvent('Client:UpdateTweets', src, tweets)
        else
            TriggerClientEvent('Client:UpdateTweets', src, tweets)
        end
    end)
end)

RegisterNetEvent('Tweet')
AddEventHandler('Tweet', function(handle, data, time)
    local handle = handle
    local src = source
    exports.ghmattimysql:execute('INSERT INTO tweets (handle, message, time) VALUES (@handle, @message, @time)', {['handle'] = handle,['message'] = data,['time'] = time}, function(result)
        
        TriggerEvent('GetTweets', src, true)
    end)
    local newtwat = { ['handle'] = handle, ['message'] = data, ['time'] = time}
    TriggerClientEvent('Client:UpdateTweet', -1, newtwat)
end)

RegisterServerEvent('AllowTweet')
AddEventHandler('AllowTweet', function(tweetinfo, message)
    TriggerClientEvent("chatMessagess", -1, tweetinfo, 2, message)
end)

RegisterNetEvent('Server:GetHandle')
AddEventHandler('Server:GetHandle', function()
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()
    fal = "@" .. char.first_name .. "_" .. char.last_name
    local handle = fal
    TriggerClientEvent('givemethehandle', src, handle)
    TriggerClientEvent('updateNameClient', src, char.first_name, char.last_name)
end)

--[[ Contacts stuff ]]

RegisterNetEvent('phone:addContact')
AddEventHandler('phone:addContact', function(name, number)
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local characterId = user:getVar("character").id
    local handle = handle

    exports.ghmattimysql:execute('INSERT INTO user_contacts (identifier, name, number) VALUES (@identifier, @name, @number)', {
        ['identifier'] = characterId,
        ['name'] = name,
        ['number'] = number
    }, function(result)
        TriggerEvent('getContacts', true, src)
        TriggerClientEvent('refreshContacts', src)
        TriggerClientEvent('phone:newContact', src, name, number)
    end)
end)

RegisterNetEvent('deleteContact')
AddEventHandler('deleteContact', function(name, number)
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local characterId = user:getVar("character").id

    exports.ghmattimysql:execute('DELETE FROM user_contacts WHERE name = @name AND number = @number LIMIT 1', {
        ['name'] = name,
        ['number'] = number
    }, function (result)
        TriggerEvent('getContacts', true, src)
        TriggerClientEvent('refreshContacts', src)
        TriggerClientEvent('phone:deleteContact', src, name, number)
    end)
end)

RegisterNetEvent('phone:getContacts')
AddEventHandler('phone:getContacts', function()
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local characterId = user:getVar("character").id

    if (user == nil) then
        TriggerClientEvent('phone:loadContacts', src, json.encode({}))
    else
        local contacts = getContacts(characterId, function(contacts)
            if (contacts) then
                TriggerClientEvent('phone:loadContacts', src, contacts)
            else
                TriggerClientEvent('phone:loadContacts', src, {})
            end
        end)
    end
end)

function getMessagesBetweenUsers(sender, recipient, callback)
    exports.ghmattimysql:execute("SELECT id, sender, receiver, message, date FROM user_messages WHERE (receiver = @from OR sender = @from) and (receiver = @to or sender = @to)", {
    ['from'] = sender,
    ['to'] = recipient
    }, function(result) callback(result) end)
end

function saveSMS(receiver, sender, message, callback)
    -- Receiver and Sender are phone numbers, not id's or identifier
    exports.ghmattimysql:execute("INSERT INTO user_messages (`receiver`, `sender`, `message`) VALUES (@receiver, @sender, @msg)",
    {['receiver'] = tonumber(receiver), ['sender'] = tonumber(sender), ['msg'] = message}, function(rowsChanged)
        exports.ghmattimysql:execute("SELECT id FROM user_messages WHERE receiver = @receiver AND sender = @sender AND message = @msg",
    {['receiver'] = tonumber(receiver), ['sender'] = tonumber(sender), ['msg'] = message}, function(result) if callback then callback(result) end end)
    end)
end


-- Contact Queries
function getContacts(identifier, callback)
    exports.ghmattimysql:execute("SELECT name,number FROM user_contacts WHERE identifier = @identifier ORDER BY name ASC", {
        ['identifier'] = identifier
    }, function(result) callback(result) end)
end

-- function saveContact(identifier, name, number)
--     execute.ghmattimysql:execute("INSERT INTO user_contacts (`identifier`, `name`, `number) VALUES (@identifier, @name, @number)", 
--     {['identifier'] = identifier, ['name'] = name, ['number'] = tonumber(number)})
-- end



-- function removeContact(identifier, name, number)
--     -- Remove the contact to our users list
--     exports.ghmattimysql:execute("DELETE FROM user_contacts WHERE identifier = @identifier AND name = @name AND number = @number", {['identifier'] = identifier, ['name'] = name, ['number'] = tonumber(number)
--     })
-- end

RegisterNetEvent('getNM')
AddEventHandler('getNM', function(pNumber)
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local characterId = user:getVar("character").id
    local pNumber = getNumberPhone(characterId)
    TriggerClientEvent("client:updatePNumber",src,pNumber)
end)


RegisterNetEvent('phone:deleteYP')
AddEventHandler('phone:deleteYP', function(number)
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local characterId = user:getVar("character").id
    local myNumber = getNumberPhone(characterId)
    exports.ghmattimysql:execute('DELETE FROM phone_yp WHERE phoneNumber = @phoneNumber', {
        ['phoneNumber'] = myNumber
    }, function (result)
        TriggerClientEvent('refreshYP', src)
  
    end)
end)

--[[ Phone calling stuff ]]

function getNumberPhone(identifier)
    local result = exports.ghmattimysql:execute("SELECT phone_number FROM characters WHERE id = @identifier", {
        ['identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end
function getIdentifierByPhoneNumber(phone_number) 
    local result = exports.ghmattimysql:execute("SELECT characters.id FROM characters WHERE characters.phone_number = @phone_number", {
        ['phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].id
    end
    return nil
end

RegisterServerEvent('requestPing')
AddEventHandler('requestPing', function(target, x,y,z, pIsAnon)
    local src = source
    --local player = exports["np-base"]:getModule("Player"):GetUser(src) --getting id xPlayer.GetPlayerID
    --local char = player:getCurrentCharacter()  -- getting character name
    -- local playername = ""..char.firstname.." "..char.last_name"
    TriggerClientEvent('AllowedPing', tonumber(target), x,y,z, src, name, pIsAnon)
end)

RegisterServerEvent('pingAccepted')
AddEventHandler('pingAccepted', function(target)
    local target = tonumber(target)
    TriggerClientEvent('DoLongHudText', target, "You ping was accepted!", 5)
end)

RegisterServerEvent('pingDeclined')
AddEventHandler('pingDeclined', function(target)
    local target = tonumber(target)
    TriggerClientEvent('DoLongHudText', target, "You ping was declined!", 5)
end)


--Calling Taxi /taxi
-- RegisterServerEvent('phone:callAiTaxi')
-- AddEventHandler('phone:callAiTaxi', function(src)
--     local src = tonumber(src)
--     local activeTaxi = exports["np-base"]:getModule("jobManager"):CountJob("taxi")
--     local user = exports["np-base"]:getModule("Player"):GetUser(src)
--     if activeTaxi ~= 0 then
--         if tonumber( user:getCash()) < 250 then
--             TriggerClientEvent("DoLongHudText", src, "You need $250 to do this as a players is logged in as taxi.",2)
--                 return
--             end
--             user:removeMoney(250)
--         end
--         TriggerClientEvent("startAITaxi",src)
-- end)

RegisterNetEvent('phone:callContact')
AddEventHandler('phone:callContact', function(targetnumber, toggle)
    -- hard to do ((sway))
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local targetIdentifier = getIdentifierByPhoneNumber(targetnumber)
    local Players = GetPlayers()
    local srcIdentifier = GetPlayerIdentifiers(src)[1]
    local srcPhone = getNumberPhone(srcIdentifier)

    TriggerClientEvent('phone:initiateCall', src, src)
    
    for i=1, #Players, 1 do
    local People = exports["np-base"]:getModule("Player"):GetUser(Players[i])
        if People then
          if srcIdentifier == targetIdentifier then
            playerID = src
          end
        end
    end
    print('calling trigger here')
    TriggerClientEvent('phone:receiveCall', playerID, targetnumber, src, srcPhone)
end)

RegisterNetEvent('phone:messageSeen')
AddEventHandler('phone:messageSeen', function(id)
    id = tonumber(id)
    if id ~= nil then
        exports.ghmattimysql:execute("UPDATE user_messages SET seen = 1 WHERE id = @id", {['id'] = tonumber(id)})
    end
end)

RegisterNetEvent('phone:getSMS')
AddEventHandler('phone:getSMS', function()
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local characterId = user:getVar("character").id
    local mynumber = getNumberPhone(characterId)

    local result = exports.ghmattimysql:execute("SELECT * FROM user_messages WHERE receiver = @mynumber OR sender = @mynumber ORDER BY id DESC", {['mynumber'] = mynumber})

    local numbers ={}
    local convos = {}
    local valid
    if result ~= nil then
    for k, v in pairs(result) do
        valid = true
        if v.sender == mynumber then
            for i=1, #numbers, 1 do
                if v.receiver == numbers[i] then
                    valid = false
                end
            end
            if valid then
                table.insert(numbers, v.receiver)
            end
        elseif v.receiver == mynumber then
            for i=1, #numbers, 1 do
                if v.sender == numbers[i] then
                    valid = false
                end
            end
            if valid then
                table.insert(numbers, v.sender)
            end
        end
    end
    
    for i, j in pairs(numbers) do
        for g, f in pairs(result) do
            if j == f.sender or j == f.receiver then
                table.insert(convos, {
                    id = f.id,
                    sender = f.sender,
                    receiver = f.receiver,
                    message = f.message,
                    date = f.date
                })
                break
            end
        end
    end

        local data = ReverseTable(convos)
        TriggerClientEvent('phone:loadSMS', src, data, mynumber)
    else

        TriggerClientEvent('phone:loadSMS', src, {}, mynumber)
    end
 
end)

RegisterNetEvent('phone:getSMSOther')
AddEventHandler('phone:getSMSOther', function(player)
	local user = exports["np-base"]:getModule("Player"):GetUser(player)
    local char = user:getVar("character")
    local mynumber = getNumberPhone(char.id)

    local result = exports.ghmattimysql:execute("SELECT * FROM user_messages WHERE receiver = @mynumber OR sender = @mynumber ORDER BY id DESC", {['mynumber'] = mynumber})

    local numbers ={}
    local convos = {}
    local valid
    if result ~= nil then
    for k, v in pairs(result) do
        valid = true
        if v.sender == mynumber then
            for i=1, #numbers, 1 do
                if v.receiver == numbers[i] then
                    valid = false
                end
            end
            if valid then
                table.insert(numbers, v.receiver)
            end
        elseif v.receiver == mynumber then
            for i=1, #numbers, 1 do
                if v.sender == numbers[i] then
                    valid = false
                end
            end
            if valid then
                table.insert(numbers, v.sender)
            end
        end
    end
    
    for i, j in pairs(numbers) do
        for g, f in pairs(result) do
            if j == f.sender or j == f.receiver then
                table.insert(convos, {
                    id = f.id,
                    sender = f.sender,
                    receiver = f.receiver,
                    message = f.message,
                    date = f.date
                })
                break
            end
        end
    end

        local data = ReverseTable(convos)
        TriggerClientEvent('phone:loadSMSOther', src, data, mynumber)
    else

        TriggerClientEvent('phone:loadSMSOther', src, {}, mynumber)
    end
 
end)

function ReverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

-- function getIdentifierFromPhone(number, callback)
--     --Get a users identifier from a phone number
--     exports.ghmattimysql.execute("SELECT identifier FROM users WHERE phone_number = @number", {['number'] = tonumber(number)}, function(result)
--         if #result == 0 then
--             callback(nil)
--         else
--             if(result[1].identifier ~= '') then
--                 callback(result[1].identifier)
--             else
--                 callback(nil)
--             end
--         end
--     end)
-- end

-- function reverse(tbl)
--     for i=1, math.floor(#tbl / 2) do
--         tbl[1], tbl[#tbl - i + 1] - tbl[#tbl - i + 1], tbl[i]
--     end
--     return tbl
-- end

-- SetTimeout(5000, requestStockChangeTable)

-- SetTimeout(600000, stockvalueincrease)

-- local activePhoneNumbers = {

-- }
-- local activeUsers = {}

RegisterServerEvent('phone:getServerTime')
AddEventHandler('phone:getServerTime', function()
    local src= source
    TriggerClientEvent('phone:setServerTime', src, os.date('%H:%M:%S', os.time()))
end)

RegisterNetEvent('phone:sendSMS')
AddEventHandler('phone:sendSMS', function(receiver, message)
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local characterId = user:getVar("character").id
    local mynumber = getNumberPhone(characterId)

    local target = getIdentifierByPhoneNumber(receiver)
    
    local Players = GetActivePlayers()
    --if receiver ~= mynumber then
    exports.ghmattimysql:execute('INSERT INTO user_messages (sender, receiver, message) VALUES (@sender, @receiver, @message)', {
        ['sender'] = mynumber,
        ['receiver'] = receiver,
        ['message'] = message
    }, function(result)
    end)
    for i=1, #Players, 1 do
        local People = exports["np-base"]:getModule("Player"):GetUser(Players[i])
        local PeopleId = People:getVar("character").id
        if People then
            if PeopleId == target then
                local receiverID = People.source
                TriggerClientEvent('phone:newSMS', receiverID, 1, mynumber)
                TriggerClientEvent('DoLongHudText', src, "Messege send.", 16)
            end
        end
    end

end)

RegisterNetEvent('phone:serverGetMessagesBetweenParties')
AddEventHandler('phone:serverGetMessagesBetweenParties', function(sender, receiver, displayName)
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local characterId = user:getVar("character").id
    local mynumber = getNumberPhone(characterId)
    local result = exports.ghmattimysql:execute("SELECT * FROM user_messages WHERE (sender = @sender AND receiver = @receiver) OR (sender = @receiver AND receiver = @sender) ORDER BY id ASC", {['sender'] = sender, ['receiver'] = receiver})

    TriggerClientEvent('phone:clientGetMessagesBetweenParties', src, result, displayName, mynumber)
end)

RegisterNetEvent('phone:StartCallConfirmed')
AddEventHandler('phone:StartCallConfirmed', function(mySourceID)
    local channel = math.random(10000, 99999)
    local src = source

    TriggerClientEvent('phone:callFullyInitiated', mySourceID, mySourceID, src)
    TriggerClientEvent('phone:callFullyInitiated', src, src, mySourceID)

    -- After add them to the same channel or do it from server.
    TriggerClientEvent('phone:addToCall', source, channel)
    TriggerClientEvent('phone:addToCall', mySourceID, channel)

    TriggerClientEvent('phone:id', src, channel)
    TriggerClientEvent('phone:id', mySourceID, channel)
end)

-- local activeCalls = {}

-- local function StartCall(caaler, callee)
--     local callId = caller + 101 --avoid idx 1 - 100
--     TriggerClientEvent('Tokovoip:addPlayerToRadio', caller, callId)
--     TriggerClientEvent('Tokovoip:addPlayerToRadio', callee, callId)
--     TriggerClientEvent('phone:id', caller, callId)
--     TriggerClientEvent('phone:id', callee, callId)
-- end

-- RegisterNetEvent('phone:EndCall')
-- AddEventHandler('phone:EndCall', function(mySourceID, callId)
--     TriggerClientEvent("phone:otherClientEndCall", tonumber(mySourceID))
--     TriggerClientEvent("phone:ResetRadioChannel", source)
-- end)

-- TriggerEvent("ResetRadioChannel")
-- RegisterNetEvent('phone:ResetRadioChannel')
-- AddEventHandler('phone:ResetRadioChannel', function(mySourceID)
--     local pn = tonumber(mySourceID)
--     local src = tonumber(source)

--     StartCall(src, pn)
--     TriggerClientEvent('phone:callFullyInitiated',pn,pn,src)
-- end)

RegisterNetEvent('phone:EndCall')
AddEventHandler('phone:EndCall', function(mySourceID, stupidcallnumberidk, somethingextra)
    local src = source
    TriggerClientEvent('phone:removefromToko', source, stupidcallnumberidk)

    if mySourceID ~= 0 or mySourceID ~= nil then
        TriggerClientEvent('phone:removefromToko', mySourceID, stupidcallnumberidk)
        TriggerClientEvent('phone:otherClientEndCall', mySourceID)
    end

    if somethingextra then
        TriggerClientEvent('phone:otherClientEndCall', src)
    end
end)

RegisterCommand("answer", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('phone:answercall', src)
end, false)

RegisterCommand("a", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('phone:answercall', src)
end, false)

RegisterCommand("h", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('phone:endCalloncommand', src)
end, false)


RegisterCommand("hangup", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('phone:endCalloncommand', src)
end, false)

RegisterCommand("lawyer", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('yellowPages:retrieveLawyersOnline', src, true)
end, false)

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

AddEventHandler('playerSpawned',function(source)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    getOrGeneratePhoneNumber(sourcePlayer, identifier, function (myPhoneNumber)
    end)
end)

function getOrGeneratePhoneNumber (sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)
    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = getIdentifierByPhoneNumber(myPhoneNumber)
        until id == nil
        exports.ghmattimysql:execute("UPDATE users SET phone_number = @myPhoneNumber WHERE identifier = @identifier", {
            ['myPhoneNumber'] = myPhoneNumber,
            ['identifier'] = identifier
        }, function ()
            cb(myPhoneNumber)
        end)
    else
        cb(myPhoneNumber)
    end
end

function getPhoneRandomNumber()
    local numBase0 = 4
    local numBase1 = math.random(10,99)
    local numBase2 = math.random(100,999)
    local numBase3 = math.random(1000,9999)
    local num = string.format(numBase0 .. "" .. numBase1 .. "" .. numBase2 .. "" .. numBase3)
    return num
end

RegisterNetEvent('message:inDistanceZone')
AddEventHandler('message:inDistanceZone', function(somethingsomething, messagehueifh)
    local src = source		
    local first = messagehueifh:sub(1, 3)
    local second = messagehueifh:sub(4, 6)
    local third = messagehueifh:sub(7, 11)

    local msg = first .. "-" .. second .. "-" .. third
	TriggerClientEvent('chat:addMessage', somethingsomething, {
		template = '<div style = "display: inline-block !important;padding: 0.6vw;padding-top: 0.6vw;padding-bottom: 0.7vw;margin: 0.1vw;margin-left: 0.4vw;border-radius: 10px;background-color: #be6112d9;width: fit-content;max-width: 100%;overflow: hidden;word-break: break-word;"><b>Phone</b>: #{1}</div>',
		args = { fal, msg }
	})
end)

RegisterNetEvent('message:tome')
AddEventHandler('message:tome', function(messagehueifh)
    local src = source		
    local first = messagehueifh:sub(1, 3)
    local second = messagehueifh:sub(4, 6)
    local third = messagehueifh:sub(7, 11)

    local msg = first .. "-" .. second .. "-" .. third
	TriggerClientEvent('chat:addMessage', src, {
		template = '<div style = "display: inline-block !important;padding: 0.6vw;padding-top: 0.6vw;padding-bottom: 0.7vw;margin: 0.1vw;margin-left: 0.4vw;border-radius: 10px;background-color: #be6112d9;width: fit-content;max-width: 100%;overflow: hidden;word-break: break-word;"><b>Phone</b>: #{1}</div>',
		args = { fal, msg }
	})
end)


RegisterNetEvent('phone:getServerTime')
AddEventHandler('phone:getServerTime', function()
    local hours, minutes, seconds = Citizen.InvokeNative(0x50C7A99057A69748, Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt())
    TriggerClientEvent('timeheader', -1, tonumber(hours), tonumber(minutes))
end)

-- function getIdentity(target)
-- 	local identifier = GetPlayerIdentifiers(target)[1]
-- 	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
-- 	if result[1] ~= nil then
-- 		local identity = result[1]

-- 		return {
-- 			firstname = identity['firstname'],
-- 			lastname = identity['lastname'],
-- 		}
-- 	else
-- 		return nil
-- 	end
-- end

--[[ Others ]]

RegisterNetEvent('getAccountInfo')
AddEventHandler('getAccountInfo', function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local characterId = user:getVar("character").id
    local money = user:getCash()
    local newmoney = 0
    local inbank = exports.ghmattimysql:execute("SELECT bank FROM characters WHERE id = @identifier", {['@identifier'] = characterId}, function(result) if result[1].bank == nil then return else newmoney = result[1].bank end end)
    local cash = exports.ghmattimysql:execute("SELECT cash FROM characters WHERE id = @identifier", {['@identifier'] = characterId}, function(result) if result[1].bank == nil then return else newcash = result[1].bank end end)
    local newcash = 0
    local licenceTable = {}

    exports.ghmattimysql:execute("SELECT type, status FROM user_licenses WHERE owner = @owner",{['owner'] = characterId}, function(result)
        print(result[1].type, result[1].status)
        for i=1, #result do
            table.insert(licenceTable,{
                type = result[i].type,
                status = result[i].status
            })
        end
    end)

    Citizen.Wait(100)

    print(json.encode(licenceTable))
    
    TriggerClientEvent('getAccountInfo', src, newcash, newmoney, licenceTable)
end)


--[[ Yellow Pages ]]

RegisterNetEvent('getYP')
AddEventHandler('getYP', function()
    local source = source
    exports.ghmattimysql:execute('SELECT * FROM phone_yp LIMIT 30', {}, function(yp)
        local deorencoded = json.encode(yp)
       -- print(json.encode(yp))
        --TriggerClientEvent('YellowPageArray', source, yp)
        TriggerClientEvent('YellowPageArray', -1, yp)
        TriggerClientEvent('YPUpdatePhone', source)
    end)
    --[[
    if userjob == "police" or userjob == "ems" then
        emergencyofficer = true
    end

    YellowPageArray[#YellowPageArray + 1] = {
        ["name"] = name,
        ["job"] = job,
        ["phonenumber"] = phonenumber,
        ["emergencyofficer"] = emergencryoffer,
        ["src"] = src
    }
    TriggerClientEvent('YellowPageArray', -1, YellowPageArray)
    TriggerClientEvent('YPUpdatePhone,src')
    ]]
end)

RegisterNetEvent('getCP')
AddEventHandler('getCP', function()
    local source = source
    exports.ghmattimysql:execute('SELECT * FROM phone_cp LIMIT 30', {}, function(yp)
        local deorencoded = json.encode(yp)
        TriggerClientEvent('CriminalPageArray', source, yp)
    end)
end)
-- hereee
RegisterNetEvent('phone:updatePhoneJob')
AddEventHandler('phone:updatePhoneJob', function(advert)
    --local handle = handle
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local mynumber = char.phone_number

    fal = char.first_name .. " " .. char.last_name

    exports.ghmattimysql:execute('INSERT INTO phone_yp (name, job, phoneNumber) VALUES (@name, @job, @phoneNumber)', {
        ['name'] = fal,
        ['job'] = advert,
        ['phoneNumber'] = mynumber
    }, function(result)
        TriggerClientEvent('refreshYP', src)
    end)
end)

RegisterNetEvent('phone:foundLawyer')
AddEventHandler('phone:foundLawyer', function(name, phoneNumber)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style = "display: inline-block !important;padding: 0.6vw;padding-top: 0.6vw;padding-bottom: 0.7vw;margin: 0.1vw;margin-left: 0.4vw;border-radius: 10px;background-color: #1e2dff9c;width: fit-content;max-width: 100%;overflow: hidden;word-break: break-word;"><b>YP</b>: ⚖️ {0} ☎️ {1}</div>',
        args = { name, phoneNumber }
    })
end)

RegisterNetEvent('phone:foundLawyerC')
AddEventHandler('phone:foundLawyerC', function(name, phoneNumber)
    local src = source
    TriggerClientEvent('chat:addMessage', src, {
        template = '<div style = "display: inline-block !important;padding: 0.6vw;padding-top: 0.6vw;padding-bottom: 0.7vw;margin: 0.1vw;margin-left: 0.4vw;border-radius: 10px;background-color: #1e2dff9c;width: fit-content;max-width: 100%;overflow: hidden;word-break: break-word;"><b>YP</b>: ⚖️ {0} ☎️ {1}</div>',
        args = { name, phoneNumber }
    })
end)

RegisterNetEvent('deleteAllYP')
AddEventHandler('deleteAllYP', function()
    exports.ghmattimysql:execute("DELETE * FROM phone_yp", function() end)
    exports.ghmattimysql:execute("DELETE * FROM tweets", function() end)
end)

--Racing
local BuiltMaps = {}
local Races = {}

RegisterServerEvent('racing-global-race')
AddEventHandler('racing-global-race', function(map,laps,counter,reverseTrack,uniqueid,cid,raceName, startTime, mapCreator, mapDistance, mapDescription, street1, street2)

    print("Starting a race? ", map, laps, counter, uniqueid, cid, raceName)
    Races[uniqueid] = { ["identifier"] = uniqueid, ["map"] = map, ["laps"] = laps, ["counter"] = counter, 
        ["reverseTrack"] = reverseTrack, ["cid"] = cid, ["racer"] = {}, ["open"] = true, ["startTime"] = startTime, 
        ["mapCreator"] = mapCreator, ["mapDistance"] = mapDistance, ["mapDescription"] = mapDescription, ["street1"] = street1, 
        ["street2"] = street2 
    }
    TriggerEvent('racing:server:sendData', uniqueid, -1, 'event', 'open')
    local waitperiod = (counter * 1000)
    Wait(waitperiod)
    Races[uniqueid]["open"] = false
    if(math.random(1,10) >= 5) then
        TriggerEvent("dispatch:svNotify", {
            dispatchCode = "10-94",
            firstStreet = street1,
            secondStreet = street2,
            origin = {
                x = BuiltMaps[map]["checkPoints"][1].x,
                y = BuiltMaps[map]["checkPoints"][1].y,
                z = BuiltMaps[map]["checkPoints"][1].z
            }

        })
    end
    TriggerClientEvent('racing:server:sendData', uniqueid, -1, 'event', 'close')
end)

RegisterServerEvent('racing-join-race')
AddEventHandler('racing-join-race', function(identifier)
    local src = source
    local player = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = player:getCurrentCharacter()
    local cid = char.id
    local playername = ""..char.firstname.." "..char.last_name""
    Races[identifier]["racers"][cid] = { ["name"] = playername, ["cid"] = cid, ["total"] = 0, ["fastest"] = 0}
    TriggerEvent('racing:server:sendData', identifier, src, 'event')
end)

RegisterServerEvent('race:completed2')
AddEventHandler('race:completed2', function(fasterlap, overall, sprint, identifier)
    local src = source
    local player = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = player:getCurrentCharacter()
    local cid = char.id
    local playername = ""..char.firstname.." "..char.last_name""
    Races[identifier]["racers"][cid] = { ["name"] = playername, ["cid"] = cid, ["total"] = overall, ["fastest"] = fastestlap}
    Races[identifier].raceEnding = os.time()+5
    Races[identifier].sprint = sprint
    TriggerEvent('racing:server:sendData', identifier, -1, 'event')
end)

Citizen.CreateThread(function()
    while true do
        for index, race in pairs(Races) do
            if(race.finished == false) then
                local countRacers = #race["racers"]
                local finishedRacers = -1;
                local currFast = -1
                local fastestObject = {}
                for k,v in pairs(race["racers"]) do
                    if(v.total ~= 0 and finishedRacers ~= countRacers) then
                        finishedRacers = finishedRacers + 1
                        local potentialFast = race.sprint and v.total or v.fastest
                        if currFast == -1 or potentialFast < currFast then
                            fastestObject = v
                        end
                    end
                end
                if (countRacers == finishedRacers) then
                    race.finished = true
                    race.fastest = fastestObject
                end
                if(race.finished == false) then
                    if(race.raceEnding ~= nil) then
                        if os.time() >= race.raceEnding then
                            race.finished = true
                            if(race.fastest ~= falase or race.fastest ~= -1) then
                                race.fastest = fastestObject
                            end
                        end
                    end
                end
            elseif(race.finished == true and race.saved == false) then
                if((race.sprint and race.fastest.total ~= 0) or (not race.sprint and race.fastest.fastest ~= 0)) then
                    exports.ghmattimysql:exports("UPDATE racing_tracks SET races = races+1 WHERE id = @id", {
                        ['id'] = race.map
                    })
                    Wait(300)
                    local updateString = "";
                    if(race.sprint) then
                        updateString = "UPDATE racing_tracks SET fastest_sprint = @fastest_lap, fastest_sprint_name = @fastestLapName WHERE id = @id and (fastest_lap = -1 or fatest_lap > @fastestLap)"
                    else
                        updateString = "UPDATE racing_tracks SET fastest_lap = @fastestLap, fastest_name = @fastestLapName WHERE id = @id and (fastest_lap = -1 or fatest_lap > @fastestLap)"
                    end 
                    exports.ghmattimysql:execute(updateString, {
                        ['fastestLap'] = (race.sprint and race.fastest.total or race.fastest.fastest),
                        ['fastestLapName'] = race.fastest.name,
                        ['id'] = race.map
                    })
                end
                race.saved = true 
                end
            end
        Citizen.Wait(10000)
    end
end)

RegisterServerEvent('racing:server:sendData')
AddEventHandler('racing:server:sendData', function(pEventId, clientId, changeType,pSubEvent)
local dataObject = {
    eventId = pEventId,
    event = changeType,
    subEvent = pSubEvent,
    data = {}
}
    if (changeType == "event") then
        dataObject.data = (pEventId == -1 and Races[pEventId] or Races)
    elseif (changeType == "map") then
        dataObject.data = (pEventId == -1 and BuiltMaps[pEventId] or BuiltMaps)
    end
    TriggerClientEvent("racing:data:set", clientId, dataObject)
end)

function buildMaps(subEvent,src)
    local src = source
    print(subEvent)
    subEvent = subEvent or nil
    BuiltMaps = {}
    exports.ghmattimysql:execute("SELECT * FROM racing_tracks", {}, function(result)
      
        for i = 1, #result do
            local correctId = tostring(result[i].id)
            print(correctId)
            BuiltMaps[correctId] = {
                checkPoints = json.decode(result[i].checkPoints),
                track_name = result[i].track_names,
                creator = result[i].creator,
                distance = result[i].distance,
                races = result[i].races,
                fastest_car = result[i].fastest_car,
                fastest_name = result[i].fastest_name,
                fastest_lap = result[i].fastest_lap,
                fastest_sprint = result[i].fastest_sprint,
                fastest_sprint_name = result[i].fastest_sprint_name,
                description = result[i].description,
            }
            print(json.encode(BuiltMaps[correctId]))
        end
        local target = -1
        if(subEvent == 'mapupdate' or subEvent == 'noNUI') then
            target = src
        end
        TriggerEvent('racing:server:sendData', -1, target, 'map', subEvent)
    end)
end

RegisterServerEvent('racing-build-maps')
AddEventHandler('racing-build-maps', function()
    print('print in server')
    local src = source 
    buildMaps('mapUpdate', src)
end)

RegisterServerEvent('racing-map-delete')
AddEventHandler('racing-map-delete', function()
    exports.ghmattimysql:execute("DELETE FROM racing_tracks WHERE id = @id", {
        ['id'] = deleteID
    })
    Wait(1000)
    buildMaps('kevin', src)
end)

RegisterServerEvent('racing-retreive-maps')
AddEventHandler('racing-retreive-maps', function()
    local src = source
    buildMaps('noNUI', src)
end)

RegisterServerEvent('racing-save-map')
AddEventHandler('racing-save-map', function(currentMap, name, description, distanceMap)
    local src = source
    local player = exports['np-base']:getModule("Player"):GetUser(src)
    local char = player:getCurrentCharacter()
    local playername = ""..char.first_name.." "..char.last_name..""

    exports.ghmattimysql:execute("INSERT INTO racing_tracks (`checkPoints`, `creator`, `track_names`, `distance`, `description`) VALUES (@currentMap, @creator, @trackname, @distance, @description)",
        {['currentMap'] = json.encode(currentMap),
        ['creator'] = playername,
        ['trackname'] = name,
        ['distance'] = distanceMap,
        ['description'] = description})

    Wait(1000)
    buildMaps()
end)


RegisterCommand("payphone", function(source, args, raw)
    local src = source
    local pnumber = args[1]
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local cid = char.id
    local mynumber = getNumberPhone(cid)
    if user:getCash() >= 25 then
        TriggerClientEvent('phone:makepayphonecall', src, pnumber)
        user:removeMoney(25)
    else
        TriggerClientEvent('DoShortHudText', _source, 'You dont have $25 for the payphone', 2)
       
    end
end, false)


RegisterServerEvent('phone:RemovePhoneJobSourceSend')
AddEventHandler('phone:RemovePhoneJobSourceSend', function(srcsent)
    local src = srcsent
    for i = 1, #YellowPageArray do
        if YellowPageArray[i]
        then 
          local a = tonumber(YellowPageArray[i]["src"])
          local b = tonumber(src)

          if a == b then
            table.remove(YellowPageArray,i)
          end
        end
    end
    TriggerClientEvent("YellowPageArray", -1 , YellowPageArray)
end)

RegisterServerEvent('phone:RemovePhoneJob')
AddEventHandler('phone:RemovePhoneJob', function()
    local src = srcsent
    for i = 1, #YellowPageArray do
        if YellowPageArray[i]
        then 
          local a = tonumber(YellowPageArray[i]["src"])
          local b = tonumber(src)

          if a == b then
            table.remove(YellowPageArray,i)
          end
        end
    end
    TriggerClientEvent("YellowPageArray", -1 , YellowPageArray)
    TriggerClientEvent("YPUpdatePhone",src)
end)

RegisterServerEvent("stocks:clientvalueupdate")
AddEventHandler("stocks:clientvalueupdate", function(table)
    print("triggered that")
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local tableinsert =  json.encode(table)
    exports.ghmattimysql:execute("UPDATE characters SET stocks = @stock WHERE id = @cid",{
        ['@stock'] = tableinsert,
        ['@cid'] = char.id
      }, function(data)
        -- user:removeMoney(clientcash)
        -- TriggerClientEvent("DoLongHudText", src, "You deposited "..clientcash.."$ to your apartment.", 1)
    end)
end)

RegisterServerEvent("stocks:retrieve")
AddEventHandler("stocks:retrieve", function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser()
    local char = user:getCurrentCharacter()

    exports.ghmattimysql:execute("SELECT stocks FROM characters WHERE id = @id", {['id'] = char.id}, function(result)
        if result[1].stocks then
        TriggerClientEvent("stocks:clientvalueupdate", src, result[1].stocks)
        end
    end)
end)

-- RegisterNetEvent('LoadHouses')
-- AddEventHandler('LoadHouses', function()
--     local src = source
--     MySQL.Async.fetchAll('SELECT * FROM houses_ WHERE failBuy = "false"', {}, function(houses)
--         local deorencoded = json.encode(yp)
--         for i=1, #houses do
--             print(houses[i].price)
--         end
--         TriggerClientEvent('openHouse', -1, houses)
--     end)
-- end)


-- RegisterServerEvent('phone:updatePhoneJob')
-- AddEventHandler('phone:updatePhoneJob', function(job)
--     local job = job
--     if source == nil then
--         return
--     end
--     local src = source
--     local jobout = ""

--     for i = 1, #YellowPageArray do
--         if YellowPageArray[i] ~= nil
--         then
--             if tonumber(YellowPageArray[i]["src"]) == tonumber(src) then
--                 table.remove(YellowPageArray,i)
--             end
--         end

 --   local player = --getting id here
 --  local phonenumbner = get number here
 -- local userjob = false
 -- local name = --name here and last name
 --userjob = -- get job here
 --[[
     if userjob == "police" or userjob == "ems" then
        emergencyofficer = true
    end

    YellowPageArray[#YellowPageArray + 1 ] = {
        ["name"] = name,
        ["name"] = job,
        ["name"] = phonenumber,
        ["name"] = emergencyofficer,
        ["name"] = src
    }

    TriggerClientEvent('YellowPageArray', -1, YellowPageArray)
    TriggerClientEvent('YPUpdatePhone', src)

 ]]
-- end)
