RegisterCommand('setBlip', function (src)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)

    if (netId) then
        local blip = EntityBlip:new('entity', netId, {color = 3})
        blip:enable()
    end
end, false)