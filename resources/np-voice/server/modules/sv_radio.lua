local activeChannels = {} --key is channel id, value is table with sub count and list of users in the channel
local channelSubscribers = {} --key is player server id, value is channel id

local function removePlayerFromRadio(sId, channelId)
    --TriggerClientEvent('tcm_voice:radio:disconnect', source, channelId) --move to client

    if not activeChannels[channelId] then return end
    activeChannels[channelId].count = activeChannels[channelId].count - 1
    if activeChannels[channelId].count == 0 then
        activeChannels[channelId] = nil
    else
        activeChannels[channelId].subscribers[sId] = nil
        for k,v in pairs(activeChannels[channelId].subscribers) do
            TriggerClientEvent("tcm_voice:radio:removed", k, channelId, sId)
            --TriggerClientEvent('tcm_voice:targets:player:remove', k, sId, "radio", false)
        end
    end

    channelSubscribers[sId] = nil

    print("Removing player: " .. sId  .. " from channel: " .. channelId)
end


local function addPlayerToRadio(sId, channelId, removeOld)

    if removeOld then
        removePlayerFromRadio(sId, channelSubscribers[sId])
    end

    if activeChannels[channelId] == nil then
        activeChannels[channelId] = {}
        activeChannels[channelId].subscribers = {}
        activeChannels[channelId].count = 0
    end
    activeChannels[channelId].count = activeChannels[channelId].count + 1

    for k,v in pairs(activeChannels[channelId].subscribers) do
        --TriggerClientEvent('tcm_voice:targets:player:add', k, sId, "radio", false)
        TriggerClientEvent("tcm_voice:radio:added", k, channelId, sId)
    end
    channelSubscribers[sId] = channelId
    activeChannels[channelId].subscribers[sId] = sId

    --print(DumpTable(activeChannels[channelId].subscribers))
    TriggerClientEvent('tcm_voice:radio:connect', sId, channelId, activeChannels[channelId].subscribers)
    print("Adding player: " .. sId  .. " to channel: " .. channelId)
end


RegisterNetEvent("tcm_voice:radio:addPlayerToRadio")
AddEventHandler("tcm_voice:radio:addPlayerToRadio", function(channelId, removeOld)
    local sId = source
    addPlayerToRadio(sId, channelId, removeOld)
end)


RegisterNetEvent("tcm_voice:radio:removePlayerFromRadio")
AddEventHandler("tcm_voice:radio:removePlayerFromRadio", function(channelId)
    local sId = source
    removePlayerFromRadio(sId, channelId)
end)


AddEventHandler('playerDropped', function(source, reason)
    if channelSubscribers[source] then
        removePlayerFromRadio(source, channelSubscribers[source])
    end
end)


RegisterCommand('activeChannels', function(src, args, raw)
    print(DumpTable(activeChannels))
end,true)


RegisterCommand('channelSubscribers', function(src, args, raw)
    print(DumpTable(channelSubscribers))
end,true)
