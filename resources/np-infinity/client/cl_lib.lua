function IsPlayerActive(pServerId)
    return exports['np-infinity']:IsPlayerActive(pServerId)
end

function DoesPlayerExist(pServerId)
    return exports['np-infinity']:DoesPlayerExist(pServerId)
end

function GetPlayerCoords(pServerId)
    return exports['np-infinity']:GetPlayerCoords(pServerId)
end

function GetNetworkedCoords(pType, pNetId)
    return exports['np-infinity']:GetNetworkedCoords(pType, pNetId)
end

function GetLocalEntity(pType, pNetId)
    return exports['np-infinity']:GetLocalEntity(pType, pNetId)
end