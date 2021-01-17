local steamIds = {
    ["steam:11000013218ef32"] = true, --syd
    ["steam:1100001113b37ba"] = true, --syd
}

RegisterServerEvent('np-doors:alterlockstate2')
AddEventHandler('np-doors:alterlockstate2', function()
    NPX.DoorCoords[10]["lock"] = 0
    NPX.DoorCoords[11]["lock"] = 0
    NPX.DoorCoords[12]["lock"] = 0
    NPX.DoorCoords[39]["lock"] = 0
    NPX.DoorCoords[40]["lock"] = 0
    NPX.DoorCoords[41]["lock"] = 0
    NPX.DoorCoords[42]["lock"] = 0
    NPX.DoorCoords[44]["lock"] = 0
    NPX.DoorCoords[45]["lock"] = 0
    NPX.DoorCoords[46]["lock"] = 0
    NPX.DoorCoords[47]["lock"] = 0
    NPX.DoorCoords[48]["lock"] = 0
    NPX.DoorCoords[49]["lock"] = 0
    NPX.DoorCoords[50]["lock"] = 0
    NPX.DoorCoords[51]["lock"] = 0
    NPX.DoorCoords[52]["lock"] = 0
    NPX.DoorCoords[53]["lock"] = 0
    NPX.DoorCoords[54]["lock"] = 0
    NPX.DoorCoords[55]["lock"] = 0
    NPX.DoorCoords[56]["lock"] = 0

    TriggerClientEvent('np-doors:alterlockstateclient', source, NPX.DoorCoords)

end)

RegisterServerEvent('np-doors:alterlockstate')
AddEventHandler('np-doors:alterlockstate', function(alterNum)
    NPX.alterState(alterNum)
end)

RegisterServerEvent('np-doors:ForceLockState')
AddEventHandler('np-doors:ForceLockState', function(alterNum, state)
    NPX.DoorCoords[alterNum]["lock"] = state
    TriggerClientEvent('NPX:Door:alterState', -1, alterNum, state)
end)

RegisterServerEvent('np-doors:requestlatest')
AddEventHandler('np-doors:requestlatest', function()
    local src = source 
    local steamcheck = GetPlayerIdentifiers(source)[1]
    if steamIds[steamcheck] then
        TriggerClientEvent('doors:HasKeys',src,true)
    end
    TriggerClientEvent('np-doors:alterlockstateclient', source,NPX.DoorCoords)
end)

function isDoorLocked(door)
    if NPX.DoorCoords[door].lock == 1 then
        return true
    else
        return false
    end
end