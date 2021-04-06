--Citizen.CreateThread(function()
  --  TriggerEvent('deleteAllTweets')
    --TriggerEvent('deleteAllYP')
--end)

-- Herrow Calling #PixelRez 2021 

local callID = nil

--[[ Twitter Stuff ]]
RegisterNetEvent('GetTweets')
AddEventHandler('GetTweets', function(onePlayer)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM (SELECT * FROM tweets ORDER BY `time` DESC LIMIT 50) sub ORDER BY time ASC', {}, function(tweets) 
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
    TriggerClientEvent("chatMessage", -1, tweetinfo, 2, message)
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
    exports.ghmattimysql:execute("INSERT INTO user_messages (`receiver`, `sender`, `message`) VALUES (@receiver, @sender, @msg)",
    {['receiver'] = tonumber(receiver), ['sender'] = tonumber(sender), ['msg'] = message}, function(rowsChanged)
        exports.ghmattimysql:execute("SELECT id FROM user_messages WHERE receiver = @receiver AND sender = @sender AND message = @msg",
    {['receiver'] = tonumber(receiver), ['sender'] = tonumber(sender), ['msg'] = message}, function(result) if callback then callback(result) end end)
    end)
end

function getContacts(identifier, callback)
    exports.ghmattimysql:execute("SELECT name,number FROM user_contacts WHERE identifier = @identifier ORDER BY name ASC", {
        ['identifier'] = identifier
    }, function(result) callback(result) end)
end

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
    local penis
    exports.ghmattimysql:execute("SELECT phone_number FROM characters WHERE id = @identifier", {
        ['identifier'] = identifier
    }, function(result)
        if result[1] ~= nil then
            penis = result[1].phone_number
        else
            penis = nil
        end
    end)
    Wait(200)
    if penis ~= nil then
        return penis
    else
        return nil
    end
end

function getIdentifierByPhoneNumber(phone_number)
    local prick
    exports.ghmattimysql:execute("SELECT id FROM characters WHERE phone_number = @phone_number", {
        ['phone_number'] = phone_number
    }, function(result)
        if result[1] ~= nil then
            prick = result[1].id
        else
            prick = nil
        end
    end)
    Wait(200)
    if prick ~= nil then
        return prick
    else
        return nil
    end
end

RegisterServerEvent('requestPing')
AddEventHandler('requestPing', function(target, x,y,z, pIsAnon)
    local src = source
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

RegisterNetEvent('phone:callContact')
AddEventHandler('phone:callContact', function(cid, targetnumber, toggle)
    local src = source
    local targetid = 0
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getVar("character")
    local targetIdentifier = getIdentifierByPhoneNumber(targetnumber)
    local srcPhone = getNumberPhone(cid)

    TriggerClientEvent('phone:initiateCall', src, src)
    
    for _, playerId in ipairs(GetPlayers()) do
        local user = exports["np-base"]:getModule("Player"):GetUser(tonumber(playerId))
        local char = user:getVar("character")
        if char.id == targetIdentifier then
            targetid = playerId
            TriggerClientEvent('phone:receiveCall', targetid, targetnumber, src, srcPhone)
        end
    end
end)

RegisterNetEvent('phone:messageSeen')
AddEventHandler('phone:messageSeen', function(id)
    id = tonumber(id)
    if id ~= nil then
        exports.ghmattimysql:execute("UPDATE user_messages SET seen = 1 WHERE id = @id", {['id'] = tonumber(id)})
    end
end)

RegisterNetEvent('phone:getSMS')
AddEventHandler('phone:getSMS', function(cid)
    local src = source
    exports.ghmattimysql:execute("SELECT phone_number FROM characters WHERE id = @identifier", {['identifier'] = cid}, function(result2)
        local mynumber = result2[1].phone_number
        
        exports.ghmattimysql:execute("SELECT * FROM user_messages WHERE receiver = @mynumber OR sender = @mynumber ORDER BY id DESC", {['mynumber'] = mynumber}, function(result)

            local numbers ={}
            local convos = {}
            local valid
            
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
        end)
    end)
end)

function ReverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

RegisterServerEvent('phone:getServerTime')
AddEventHandler('phone:getServerTime', function()
    local src= source
    TriggerClientEvent('phone:setServerTime', src, os.date('%H:%M:%S', os.time()))
end)

RegisterNetEvent('phone:sendSMS')
AddEventHandler('phone:sendSMS', function(cid, receiver, message)
    local src = source
    local mynumber = getNumberPhone(cid)
    local target = getIdentifierByPhoneNumber(receiver)
    local Players = GetPlayers()
    --if receiver ~= mynumber then
    exports.ghmattimysql:execute('INSERT INTO user_messages (sender, receiver, message) VALUES (@sender, @receiver, @message)', {
        ['sender'] = mynumber,
        ['receiver'] = receiver,
        ['message'] = message
    }, function(result)
    end)
    
    for _, playerId in ipairs(GetPlayers()) do
        local user = exports["np-base"]:getModule("Player"):GetUser(tonumber(playerId))
        local char = user:getVar("character")
        if char.id == target then
            targetid = playerId
            TriggerClientEvent('phone:newSMS', targetid, 1, mynumber,  message, os.time())
            TriggerClientEvent('DoLongHudText', src, "Messege Sent!", 16)
        end
    end
end)

RegisterNetEvent('phone:serverGetMessagesBetweenParties')
AddEventHandler('phone:serverGetMessagesBetweenParties', function(sender, receiver, displayName)
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local characterId = user:getVar("character").id
    local mynumber = getNumberPhone(characterId)
    exports.ghmattimysql:execute("SELECT * FROM user_messages WHERE (sender = @sender AND receiver = @receiver) OR (sender = @receiver AND receiver = @sender) ORDER BY id ASC",
    {['sender'] = sender,
    ['receiver'] = receiver},
    function(result)
        if result ~= nil then
            TriggerClientEvent('phone:clientGetMessagesBetweenParties', src, result, displayName, mynumber)
        end
    end)
end)

RegisterNetEvent('phone:StartCallConfirmed')
AddEventHandler('phone:StartCallConfirmed', function(mySourceID)
    local channel = math.random(10000, 99999)
    local src = source

    TriggerClientEvent('phone:callFullyInitiated', mySourceID, mySourceID, src)
    TriggerClientEvent('phone:callFullyInitiated', src, src, mySourceID)

    TriggerClientEvent('phone:addToCall', source, channel)
    TriggerClientEvent('phone:addToCall', mySourceID, channel)

    TriggerClientEvent('phone:id', src, channel)
    TriggerClientEvent('phone:id', mySourceID, channel)
end)


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

RegisterServerEvent('ReturnHouseKeys')
AddEventHandler('ReturnHouseKeys', function(cid)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local houses = {}
    local shared = {}
    exports.ghmattimysql:execute("SELECT * FROM houses WHERE cid= cid", {['cid'] = char.id}, function(chicken)
        for k, v in pairs(chicken) do
            if v ~= nil then
                if v.housename ~= nil then
                    local random = math.random(1111,9999)
                    houses[random] = {}
                    table.insert(houses[random], {["house_name"] = v.housename, ["model"] = v.model, ["id"] = v.id})
                    TriggerClientEvent('returnPlayerKeys', src, houses)
                end
            end
        end
    end)
    exports.ghmattimysql:execute('SELECT * FROM houses WHERE cid= cid', {['cid'] = char.id}, function(returnData)
        for k, v in pairs(returnData) do
            if v ~= nil then
                if v.housename ~= nil then
                    local random = math.random(1111,9999)
                    shared[random] = {}
                    table.insert(shared[random], {["house_name"] = v.housename, ["model"] = v.house_model, ["id"] = v.house_id})
                    TriggerClientEvent('returnPlayerKeys', src, {}, shared)
                end
            end
        end
    end)
end)

function getOrGeneratePhoneNumber (sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local user = exports["np-base"]:getModule("Player"):GetUser(sourcePlayer)
    local char = user:getVar("character")
    local myPhoneNumber = getNumberPhone(char.id)
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

RegisterNetEvent('phone:getServerTime')
AddEventHandler('phone:getServerTime', function()
    local hours, minutes, seconds = Citizen.InvokeNative(0x50C7A99057A69748, Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt())
    TriggerClientEvent('timeheader', -1, tonumber(hours), tonumber(minutes))
end)

--[[ Yellow Pages ]]

RegisterNetEvent('getYP')
AddEventHandler('getYP', function()
    local source = source
    exports.ghmattimysql:execute('SELECT * FROM phone_yp LIMIT 20', {}, function(yp)
        local deorencoded = json.encode(yp)
        TriggerClientEvent('YellowPageArray', -1, yp)
        TriggerClientEvent('YPUpdatePhone', source)
    end)
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
    local src = source
    exports.ghmattimysql:execute('DELETE FROM phone_yp', {}, function (result) end)
end)

RegisterNetEvent('deleteAllTweets')
AddEventHandler('deleteAllTweets', function()
    local src = source
    exports.ghmattimysql:execute('DELETE FROM tweets', {}, function (result) end)
end)

--Racing
local BuiltMaps = {}
local Races = {}

RegisterServerEvent('racing-global-race')
AddEventHandler('racing-global-race', function(map, laps, counter, reverseTrack, uniqueid, cid, raceName, startTime, mapCreator, mapDistance, mapDescription, street1, street2)
    Races[uniqueid] = { 
        ["identifier"] = uniqueid, 
        ["map"] = map, 
        ["laps"] = laps,
        ["counter"] = counter,
        ["reverseTrack"] = reverseTrack, 
        ["cid"] = cid, 
        ["racers"] = {}, 
        ["open"] = true, 
        ["raceName"] = raceName, 
        ["startTime"] = startTime, 
        ["mapCreator"] = mapCreator, 
        ["mapDistance"] = mapDistance, 
        ["mapDescription"] = mapDescription,
        ["raceComplete"] = false
    }

    TriggerEvent('racing:server:sendData', uniqueid, -1, 'event', 'open')
    local waitperiod = (counter * 1000)
    Wait(waitperiod)
    Races[uniqueid]["open"] = false
    -- if(math.random(1, 10) >= 5) then
    --     TriggerEvent("dispatch:svNotify", {
    --         dispatchCode = "10-94",
    --         firstStreet = street1,
    --         secondStreet = street2,
    --         origin = {
    --             x = BuiltMaps[map]["checkpoints"][1].x,
    --             y = BuiltMaps[map]["checkpoints"][1].y,
    --             z = BuiltMaps[map]["checkpoints"][1].z
    --         }
    -- })
    -- end
    TriggerEvent('racing:server:sendData', uniqueid, -1, 'event', 'close')
end)

RegisterServerEvent('racing-join-race')
AddEventHandler('racing-join-race', function(identifier)
    local src = source
    local player = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = player:getCurrentCharacter()
    local cid = char.id
    local playername = ""..char.first_name.." "..char.last_name..""
    Races[identifier]["racers"][cid] = {["name"] = PlayerName, ["cid"] = cid, ["total"] = 0, ["fastest"] = 0 }
    TriggerEvent('racing:server:sendData', identifier, src, 'event')
end)

RegisterServerEvent('race:completed2')
AddEventHandler('race:completed2', function(fastestLap, overall, sprint, identifier)
    local src = source
    local player = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = player:getCurrentCharacter()
    local cid = char.id
    local playername = ""..char.first_name.." "..char.last_name..""
    Races[identifier]["racers"][cid] = { ["name"] = PlayerName, ["cid"] = cid, ["total"] = overall, ["fastest"] = fastestLap}
    Races[identifier].sprint = sprint
    TriggerEvent('racing:server:sendData', identifier, -1, 'event')

    if not Races[identifier]["raceComplete"] then
        exports.ghmattimysql:execute("UPDATE racing_tracks SET races = races+1 WHERE id = '"..tonumber(Races[identifier].map).."'", function(results)
            if results.changedRows > 0 then
                Races[identifier]["raceComplete"] = true
            end
        end)
    end

    if(Races[identifier].sprint and Races[identifier]["racers"][cid]["total"]) then
        exports.ghmattimysql:execute("UPDATE racing_tracks SET fastest_sprint = "..tonumber(Races[identifier]["racers"][cid]["total"])..", fastest_sprint_name = '"..tostring(PlayerName).."' WHERE id = "..tonumber(Races[identifier].map).." and (fastest_sprint IS NULL or fastest_sprint > "..tonumber(Races[identifier]["racers"][cid]["total"])..")", function(results)
            if results.changedRows > 0 then
            end
        end)
    else
        exports.ghmattimysql:execute("UPDATE racing_tracks SET fastest_lap = "..tonumber(Races[identifier]["racers"][cid]["fastest"])..", fastest_name = '"..tostring(PlayerName).."' WHERE id = "..tonumber(Races[identifier].map).." and (fastest_lap IS NULL or fastest_lap > "..tonumber(Races[identifier]["racers"][cid]["fastest"])..")", function(results)
            if results.changedRows > 0 then
            end
        end)
    end
end)


RegisterServerEvent("racing:server:sendData")
AddEventHandler('racing:server:sendData', function(pEventId, clientId, changeType, pSubEvent)
    local dataObject = {
        eventId = pEventId, 
        event = changeType,
        subEvent = pSubEvent,
        data = {}
    }
    if (changeType =="event") then
        dataObject.data = (pEventId ~= -1 and Races[pEventId] or Races)
    elseif (changeType == "map") then
        dataObject.data = (pEventId ~= -1 and BuiltMaps[pEventId] or BuiltMaps)
    end
    TriggerClientEvent("racing:data:set", -1, dataObject)
end)

function buildMaps(subEvent)
    local src = source
    subEvent = subEvent or nil
    BuiltMaps = {}
    exports.ghmattimysql:execute("SELECT * FROM racing_tracks", {}, function(result)
        for i=1, #result do
            local correctId = tostring(result[i].id)
            BuiltMaps[correctId] = {
                checkpoints = json.decode(result[i].checkpoints),
                track_name = result[i].track_name,
                creator = result[i].creator,
                distance = result[i].distance,
                races = result[i].races,
                fastest_car = result[i].fastest_car,
                fastest_name = result[i].fastest_name,
                fastest_lap = result[i].fastest_lap,
                fastest_sprint = result[i].fastest_sprint, 
                fastest_sprint_name = result[i].fastest_sprint_name,
                description = result[i].description
            }
        end
        local target = -1
        if(subEvent == 'mapUpdate') then
            target = src
        end
        TriggerEvent('racing:server:sendData', -1, target, 'map', subEvent)
    end)
end

RegisterServerEvent('racing-build-maps')
AddEventHandler('racing-build-maps', function()
    buildMaps('mapUpdate')
end)

RegisterServerEvent('racing-map-delete')
AddEventHandler('racing-map-delete', function(deleteID)
    exports.ghmattimysql.execute("DELETE FROM racing_tracks WHERE id = @id", {
        ['id'] = deleteID })
    Wait(1000)
    buildMaps()
end)

RegisterServerEvent('racing-retreive-maps')
AddEventHandler('racing-retreive-maps', function()
    local src = source
    buildMaps('noNUI', src)
end)

RegisterServerEvent('racing-save-map')
AddEventHandler('racing-save-map', function(currentMap,name,description,distanceMap)
    local src = source
    local player = exports['np-base']:getModule("Player"):GetUser(src)
    local char = player:getCurrentCharacter()
    local playername = ""..char.first_name.." "..char.last_name..""

    -- exports.ghmattimysql:execute("INSERT INTO racing_tracks_new ('checkpoints', 'creator', 'track_name', 'distance', 'description') VALUES (@currentMap, @creator, @trackname, @distance, @description)",
    -- {['currentMap'] = json.encode(currentMap), ['creator'] = playername, ['trackname'] = name, ['distance'] = distanceMap, ['description'] = description})

    exports.ghmattimysql:execute("INSERT INTO `racing_tracks` (`checkpoints`, `creator`, `track_name`, `distance`, `description`) VALUES ('"..json.encode(currentMap).."', '"..tostring(playername).."', '"..tostring(name).."', '"..distanceMap.."',  '"..description.."')", function(results)
        Wait(1000)
        buildMaps()
    end)
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

RegisterNetEvent('phone:deleteYP')
AddEventHandler('phone:deleteYP', function(number)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local cid = char.id
    local mynumber = getNumberPhone(cid)
    exports.ghmattimysql:execute('DELETE FROM phone_yp WHERE phoneNumber = @phoneNumber', {
        ['@phoneNumber'] = mynumber
    }, function (result)
        TriggerClientEvent('refreshYP', src)
    end)
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
    end)
end)

RegisterServerEvent("stocks:retrieve")
AddEventHandler("stocks:retrieve", function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()

    exports.ghmattimysql:execute("SELECT stocks FROM characters WHERE id = @id", {['id'] = char.id}, function(result)
        if result[1].stocks then
        TriggerClientEvent("stocks:clientvalueupdate", src, json.decode(result[1].stocks))
        end
    end)
end)

RegisterServerEvent("phone:stockTradeAttempt")
AddEventHandler("phone:stockTradeAttempt", function(index, id, sending)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(tonumber(id))
    local char = user:getCurrentCharacter()

    if user ~= nil then
        TriggerClientEvent("Crypto:GivePixerium", id, sending)
    end
end)

RegisterServerEvent('phone:triggerPager')
AddEventHandler('phone:triggerPager', function()
    TriggerClientEvent('phone:triggerPager', -1)
end)

RegisterNetEvent('message:tome')
AddEventHandler('message:tome', function(messagehueifh)
    local src = source		
    local first = messagehueifh:sub(1, 3)
    local second = messagehueifh:sub(4, 6)
    local third = messagehueifh:sub(7, 11)

    local msg = first .. "-" .. second .. "-" .. third
    TriggerClientEvent('chatMessage', src, 'Phone Number ', 4, msg)
end)

RegisterNetEvent('message:inDistanceZone')
AddEventHandler('message:inDistanceZone', function(somethingsomething, messagehueifh)
    local src = source		
    local first = messagehueifh:sub(1, 3)
    local second = messagehueifh:sub(4, 6)
    local third = messagehueifh:sub(7, 11)

    local msg = first .. "-" .. second .. "-" .. third
    TriggerClientEvent('chatMessage', somethingsomething, 'Phone Number ', 4, msg)
end)

RegisterCommand("pnum", function(source, args, rawCommand)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getVar("character")
    local srcPhone = getNumberPhone(char.id)
    TriggerClientEvent('sendMessagePhoneN', src, srcPhone)
end, false)