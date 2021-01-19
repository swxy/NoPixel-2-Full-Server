local activeCallsByNumber = {}
local activeCallsBySource = {}

RegisterServerEvent("np:voice:server:phone:startCall")
AddEventHandler("np:voice:server:phone:startCall", function(phoneNumber, receiverID)
    local src = source
    startCall(phoneNumber, src, receiverID)
end)

RegisterServerEvent("np:voice:server:phone:endCall")
AddEventHandler("np:voice:server:phone:endCall", function(phoneNumber)
    endCall(phoneNumber)
end)

AddEventHandler('playerDropped', function(pData)
    if activeCallsBySource[pData.source] then
        if activeCallsByNumber[activeCallsBySource[pData.source]].caller == pData.source then
            activeCallsByNumber[activeCallsBySource[pData.source]].caller = nil
        else
            activeCallsByNumber[activeCallsBySource[pData.source]].receiver = nil
        end
        endCall(activeCallsBySource[pData.source])
    end
end)

function startCall(phoneNumber, callerID, receiverID)
    if activeCallsByNumber[phoneNumber] then
        --busy
    else
        activeCallsByNumber[phoneNumber] = {caller = callerID, receiver = receiverID}
        activeCallsBySource[src] = phoneNumber
        activeCallsBySource[receiverID] = phoneNumber
        TriggerClientEvent('np:voice:phone:call:start', callerID, phoneNumber, receiverID)
        TriggerClientEvent('np:voice:phone:call:start', receiverID, phoneNumber, callerID)
    end
end

function endCall(phoneNumber)
    local data = activeCallsByNumber[phoneNumber]
    if data.caller then
        TriggerClientEvent('np:voice:phone:call:end', data.caller, data.receiver, phoneNumber)
    end

    if data.receiver then
        TriggerClientEvent('np:voice:phone:call:end', data.receiver, data.caller, phoneNumber)
    end

end