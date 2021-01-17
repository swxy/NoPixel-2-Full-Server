function openGui(percent)
    guiEnabled = true
    local msg = "It Seems Quiet"
    if percent > 80 then
        msg = "You hear restlessness"
    elseif percent > 60 then
        msg = "You feel unsure"
    elseif percent > 30 then
        msg = "You feel safe"
    end
    if percent == 0 then
        return
    end
    SendNUIMessage({runProgress = true, Length = percent, Task = msg})
end

function closeGui()
    guiEnabled = false
    SendNUIMessage({closeProgress = true})
end

local lastmessage = false

RegisterNetEvent("robbery:guiupdate")
AddEventHandler("robbery:guiupdate", function(percent)
    if not lastmessage then
        lastmessage = true
        openGui(percent)
        Citizen.Wait(500)
        lastmessage = false
    end      
end)

RegisterNetEvent("robbery:guiclose")
AddEventHandler("robbery:guiclose", function()
    TriggerEvent("robbery:guiupdate",0)
    closeGui()
end)