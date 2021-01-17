local stresslevel = 0
local isBlocked = false

RegisterNetEvent("client:updateStress")
AddEventHandler("client:updateStress",function(newStress)
    stresslevel = newStress
end)

RegisterNetEvent("client:blockShake")
AddEventHandler("client:blockShake",function(isBlockedInfo)
    isBlocked = isBlockedInfo
end)


RegisterNetEvent("np-admin:currentDevmode")
AddEventHandler("np-admin:currentDevmode", function(devmode)
    isBlocked = devmode
end)

Citizen.CreateThread(function()
    while true do
        if not isBlocked then
            if stresslevel > 7500 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
            elseif stresslevel > 4500 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.07)
            elseif stresslevel > 2000 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)
            end
        end 
        Citizen.Wait(2000)
    end
end)


