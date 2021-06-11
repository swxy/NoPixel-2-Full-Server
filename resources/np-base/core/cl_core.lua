function NPX.Core.Initialize(self)
    Citizen.CreateThread(function()
        while true do
            if NetworkIsSessionStarted() then
                TriggerEvent("np-base:playerSessionStarted")
                TriggerServerEvent("np-base:playerSessionStarted")
                break
            end
        end
    end)
end
NPX.Core:Initialize()

AddEventHandler("np-base:playerSessionStarted", function()
    NPX.SpawnManager:Initialize()
end)

RegisterNetEvent("np-base:waitForExports")
AddEventHandler("np-base:waitForExports", function()
    if not NPX.Core.ExportsReady then return end

    while true do
        Citizen.Wait(0)
        if exports and exports["np-base"] then
            TriggerEvent("np-base:exportsReady")
            return
        end
    end
end)

RegisterNetEvent("customNotification")
AddEventHandler("customNotification", function(msg, length, type)

	TriggerEvent("chatMessage","SYSTEM",4,msg)
end)