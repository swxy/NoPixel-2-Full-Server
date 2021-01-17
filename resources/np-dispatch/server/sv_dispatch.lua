local dispatchMapping = {}
local notifId = 0

local calls = {}
local pings = {}
local units = {}
local unitAssignments = {}
local playerCoords = {}

local function currentId()
    notifId = notifId + 1
    return notifId
end

local function updateDispatch()
    TriggerClientEvent("np-dispatch:updateClientData", -1, units, pings, calls)
end

local function createNotification(pNotificationData)
    if pNotificationData ~= nil then
      --  if dispatchMapping[pNotificationData.dispatchCode] ~= nil then
            -- local dispatchData = dispatchMapping[pNotificationData.dispatchCode]
            -- pNotificationData.dbId = dispatchMapping[pNotificationData.dispatchCode].dbId
            -- pNotificationData.priority = dispatchMapping[pNotificationData.dispatchCode].priority
            -- pNotificationData.dispatchMessage = dispatchData.description
            -- pNotificationData.isImportant = dispatchData.isImportant
            -- pNotificationData.callSign = pNotificationData.callSign
            -- pNotificationData.recipientList = dispatchMapping[pNotificationData.dispatchCode].recipientList
            -- pNotificationData.storeDB = true
            -- pNotificationData.playSound = dispatchMapping[pNotificationData.dispatchCode].playSound
            -- pNotificationData.soundName = dispatchMapping[pNotificationData.dispatchCode].soundName
            -- pNotificationData.blipSprite = dispatchMapping[pNotificationData.dispatchCode].blipSprite
            -- pNotificationData.blipColor = dispatchMapping[pNotificationData.dispatchCode].blipColor
            -- pNotificationData.extraData = pNotificationData.extraData
            -- if pNotificationData.relatedCode ~= nil then
            --     pNotificationData.blipSprite = dispatchMapping[pNotificationData.dispatchCode].blipSprite
            --     pNotificationData.dispatchMessage = dispatchMapping[pNotificationData.dispatchCode].description
            --     pNotificationData.displayCode = dispatchMapping[pNotificationData.relatedCode].displayCode
            --     pNotificationData.isImportant = dispatchMapping[pNotificationData.relatedCode].isImportant
            --     pNotificationData.priority = dispatchMapping[pNotificationData.relatedCode].priority
            --     pNotificationData.recipientList = dispatchMapping[pNotificationData.relatedCode].recipientList
            --     pNotificationData.blipColor = dispatchMapping[pNotificationData.relatedCode].blipColor
            --     pNotificationData.storeDB = false
            -- else
            --     pNotificationData.dispatchCode = dispatchData.displayCode
            -- end
            -- pNotificationData.senderId = src
            -- local now = os.time()
            -- local tz_offset = os.difftime(now, os.time(os.date(":*t", now)))
            -- local epoch = os.time(os.date("!*t"))
            -- local ytc = epoch + tz_offset
            -- pNotificationData.timestamp = math.floor(utc)
            -- pNotificationData.ctxId = currentId()
            -- addDispatchEventToDatabase(pNotificationData)
            -- pings[#pings + 1] = pNotificationData
            pNotificationData.recipientList = 
            TriggerClientEvent('dispatch:clNotify', -1, pNotificationData)
       -- end
    else
        print("Nikez better frick add proper logging later")
    end
end

function addDispatchEventToDatabase(pNotificationData)
    if pNotificationData.model ~= nil and pNotificationData.eventId ~= nil then
        exports.ghmattimysql:execute("insert ignore into dispatch_vehicle(model, first_color, second_color, plate, heading, event_id) values (@model, @first_color, @second_color, @plate, @heading, @event_id)",
            {
                ['model'] = pNotificationData.model,
                ['first_color'] = pNotificationData.firstColor,
                ['second_color'] = pNotificationData.secondColor,
                ['plate'] = pNotificationData.plate,
                ['heading'] = pNotificationData.heading,
                ['event_id'] = pNotificationData.eventId
            }, function(vehicleResults)
                print("stored vehicle!")
        end)
    end
    if pNotificationData.storeDB then
        exports.ghmattimysql:execute("insert into dispatch_log(dispatch_id, first_street, second_street, gender, event_id, origin_x, origin_y, origin_z, cid) values (@dispatch_id, @first_street, @second_street, @gender, @event_id, @origin_x, @origin_y, @origin_z, @cid)",
        {
            ['first_street'] = pNotificationData.firstStreet,
            ['second_street'] = pNotificationData.secondStreet,
            ['gender'] = pNotificationData.gender,
            ['event_id'] = pNotificationData.eventId,
            ['origin_x'] = pNotificationData.origin.x,
            ['origin_y'] = pNotificationData.origin.y,
            ['origin_z'] = pNotificationData.origin.z,
            ['cid'] = pNotificationData.cid,
            ['dispatch_id'] = pNotificationData.dbId
        }, function(logResults)
            print("stored!")
        end)
    end
end

local lastExplosion = 0

AddEventHandler('explosionEvent', function(sender, ev)
    print(GetPlayerName(sender), json.encode(ev))
    if ev and ev.explosionType == 9 then
    
    end
end)

RegisterServerEvent('dispatch:svNotify')
AddEventHandler('dispatch:svNotify', createNotification)

-- AddEventHandler("onResourceStart", function(resource)
--     local _r = 0
--     local _rMax = 5
--     local _re = GetCurrentResourceName()
--     local query = [[ 
--         SELECT * FROM dispatch_code
--     ]]

--     if resource == _re then
--         Wait(2500)
--         while _r < _rMax do
--             local dispatchData = Await(SQL.execute(query))
--             if #dispatchData > 0 then
--                 for k,v in pairs(dispatchData) do
--                     dispatchMapping[v.code] = {
--                         dbId = v.id,
--                         displayCode = v.display_code,
--                         description = v.description,
--                         isImportant = v.is_important,
--                         priority = v.priority,
--                         playSound = v.playsound,
--                         soundName = v.soundname,
--                         blipSprite = v.blip_color,
--                         recipientList = {
--                             ["police"] = v.is_police,
--                             ["ems"] = v.is_ems,
--                             ["news"] = v.is_news
--                         }
--                     }
--                 end
--                 break
--             else
--                 print(("[%s] Attempt %s/%s at getting data From DB"):format(_re, _r + 1, _rMax))
--                 _r = _r + 1
--                 Wait(2500)
--             end
--         end
--     end
-- end)

-- 3.0
AddEventHandler("np-dispatch:onDuty", function(pServerId, pJob, pCallSign, pCharacter)
    units[#units + 1] = {
        callSign = pCallSign,
        job = pJob,
        name = pCharacter.first_name .. " " .. pCharacter.last_name,
        serverId = pServerId,
        vehicle = 'car',
    }
    TriggerClientEvent("np-dispatch:updateUnits", -1, pServerId, true)
end)

AddEventHandler("np-dispatch:offDuty", function(pServerId)
    local callSign = 0
    for k, v in ipairs(units) do
        if v.serverId == pServerId then
            callSign = v.callSign
            units[k] = nil
        end
    end
    for k, v in ipairs(units) do
        if v.attachedTo == callSign then
            v.attachedTo = nil
        end
    end
    TriggerClientEvent("np-dispatch:updateUnits", -1, units, pServerId, false)
    Wait(32)
    TriggerClientEvent("np-dispatch:updateDispatch", -1, { action = "removeUnit", data = { serverId = pServerId } })
end)

AddEventHandler("np-dispatch:playerCoords", function(pPlayerCoords)
    local blastCoords = {}
    for k, v in pairs(units) do
        blastCoords[#blastCoords + 1] = {
            serverId = v.serverId,
            coords = playerCoords[v.serverId],
        } 
    end
    TriggerClientEvent("np-dispatch:updateUnitCoords", -1, blastCoords)
end)
-- RPC.register("np-dispatch:dismissPing", function(source, ctxId)
--     for k, v in ipairs(pings) do
--         if v.ctxId == ctxId then
--             ping[k] = nil
--         end
--     end
--     TriggerClientEvent("np-dispatch:updateDispatch", -1, { action = "delPing", data = { ctxId = ctxId } })
-- end)
-- RPC.register("np-dispatch:createCall", function(source, ctxId)
--     local ping = nil
--     for k,v in ipars(pings) do
--         if v.ctxId == ctxId then
--             ping = v
--         end
--     end
--     calls[#calls + 1] = ping
--     TriggerClientEvent("np-dispatch:updateDispatch", -1, { action = "addCall", data = ping })
-- end)
-- RPC.register("np-dispatch:dismissCall", function(source, ctxId)
--     for k, v in ipairs(calls) do
--         if v.ctxId == ctxId then
--             calls[k] = nil
--         end
--     end
--     TriggerClientEvent("np-dispatch:updateDispatch", -1, { action = "delCall", data = { ctxId = ctxId } })
-- end)
-- RPC.register("np-dispatch:toggleUnitAssignment", function(source, ctxId, unit)
--     if unitAssignments[unit.callSign] == ctxId then
--         unitAssignments[unit.callSign] = 0
--     else
--         unitAssignments[unit.callSign] = ctxId
--     end
--     TriggerClientEvent("np-dispatch:updateDispatch", -1, { action = "updateUnitAssignments", data = unitAssignments })
-- end)
-- RPC.register("np-dispatch:setUnitVehicle", function(source, data)
--     local serverId = 0
--     for k,v in ipairs(units) do
--         if v.callSign == data.unit then
--             v.vehicle = data.vehicle
--             serverId = v.serverId
--         end
--     end
--     TriggerClientEvent("np-dispatch:updateUnits", -1, units)
--     Wait(500)
--     TriggerClientEvent("np-dispatch:updateDispatch", -1,  { action = "removeUnit", data = { serverId = serverId } })
-- end)
-- RPC.register("np-dispatch:setUnitRidingWith", function(source, data)
--     local serverId = nil
--     if not data.parent then
--         for k,v in ipairs(units) do
--             if v.callSign == data.unit.callSign then
--                 v.attachedTo = nil
--             end
--         end
--     else
--         for k, v in ipairs(units) do 
--             if v.attachedTo == data.unit.callSign then
--                 v.attachedTo = nil
--             end
--             if v.callSign == data.unit.callSign then
--                 v.attachedTo = data.parent
--                 serverId = v.serverId
--             end
--         end
--     end
--     TriggerClientEvent("np-dispatch:updateUnits", -1, units)
--     if serverId then
--         Wait(500)
--         TriggerClientEvent("np-dispatch:updateDispatch", -1,  { action = "removeUnity", data = { serverId = serverId } })
--     end
-- end)
-- RPC.register("np-dispatch:getDispatchData", function()
--     return {
--         calls = calls,
--         pings = pings,
--         units = units,
--         unitAssignments = unitAssignments,
--     }
-- end)