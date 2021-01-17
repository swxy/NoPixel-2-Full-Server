local activeCallsByNumber = {}
local activeCallsBySource = {}

RegisterServerEvent("tcm_voice:server:phone:startCall")
AddEventHandler("tcm_voice:server:phone:startCall", function(phoneNumber, receiverID)
    local src = source
    startCall(phoneNumber, src, receiverID)
end)

RegisterServerEvent("tcm_voice:server:phone:endCall")
AddEventHandler("tcm_voice:server:phone:endCall", function(phoneNumber)
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
        TriggerClientEvent('tcm_voice:phone:call:start', callerID, phoneNumber, receiverID)
        TriggerClientEvent('tcm_voice:phone:call:start', receiverID, phoneNumber, callerID)
    end
end

function endCall(phoneNumber)
    local data = activeCallsByNumber[phoneNumber]
    if data.caller then
        TriggerClientEvent('tcm_voice:phone:call:end', data.caller, data.receiver, phoneNumber)
    end

    if data.receiver then
        TriggerClientEvent('tcm_voice:phone:call:end', data.receiver, data.caller, phoneNumber)
    end

end