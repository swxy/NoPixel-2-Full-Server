local Promises, PlayerCoords, EntityCoords = {}, {}, {}

TriggerServerEvent("np:infinity:player:ready")

RegisterNetEvent('np:infinity:player:coords')
AddEventHandler('np:infinity:player:coords', function (pCoords)
    PlayerCoords = pCoords
end)

RegisterNetEvent('np:infinity:entity:coords')
AddEventHandler('np:infinity:entity:coords', function (pNetId, pCoords)
    if Promises[pNetId] then
        Promises[pNetId]:resolve(pCoords)
    end
end)

function FetchEntityCoords(pNetId)
    local result = promise:new()
    local timeout = PromiseTimeout(1000)

    Promises[pNetId] = result

    TriggerServerEvent('np:infinity:entity:coords', pNetId)

    local coords = Citizen.Await(promise.first({ timeout, result }))

    EntityCoords[pNetId] = coords

    Citizen.SetTimeout(1000, function()
        EntityCoords[pNetId] = nil
    end)

    Promises[pNetId] = nil

    return coords
end

exports('GetPlayerCoords', function (pServerId)
    return PlayerCoords[tonumber(pServerId)]
end)

exports('DoesPlayerExist', function (pServerId)
    local playerId = GetPlayerFromServerId(tonumber(pServerId))

    if playerId ~= -1 then
        return true
    end
end)

exports('IsPlayerActive', function (pServerId)
    return PlayerCoords[tonumber(pServerId)] ~= nil
end)

exports('GetNetworkedCoords', function (pType, pNetId)
    local coords

    if pType == 'player' then
        local playerIndex = GetPlayerFromServerId(pNetId)
        coords = playerIndex == -1 and PlayerCoords[pNetId] or GetEntityCoords(GetPlayerPed(playerIndex))
    else
        local entity = NetworkGetEntityFromNetworkId(pNetId)

        if DoesEntityExist(entity) then
            coords = GetEntityCoords(entity)
        else
            coords = EntityCoords[pNetId] or FetchEntityCoords(pNetId)
        end
    end

    return coords
end)

exports('GetLocalEntity', function (pType, pNetId)
    local entity

    if pType == 'player' then
        local playerIndex = GetPlayerFromServerId(pNetId)
        entity = playerIndex ~= -1 and GetPlayerPed(playerIndex) or 0
    else
        entity = NetworkGetEntityFromNetworkId(pNetId)
    end

    return entity
end)