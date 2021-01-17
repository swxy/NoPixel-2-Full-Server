local currentJob = "Unemployed"
local showDispatchLog = false
local isDead = false
local disableNotifications = false
local disableNotificationSounds = false
local currentCallSign = 0

RegisterNetEvent("police:setCallSign")
AddEventHandler("police:setCallSign", function(pCallSign)
	if pCallSign ~= nil then currentCallSign = pCallSign end
end)

local function randomizeBlipLocation(pOrigin)
    local x = pOrigin.x
    local y = pOrigin.y
    local z = pOrigin.z
    local luck = math.random(2)
    y = math.random(25) + y
    if luck == 1 then
        x = math.random(25) + x
    end
    return {x = x, y = y, z = z}
end

local function sendNewsBlip(pNotificationData)
    TriggerEvent("phone:registerBlip", {
        currentJob = currentJob,
        isImportant = pNotificationData.isImportant,
        blipTenCode = pNotificationData.dispatchCode,
        blipDescription = pNotificationData.dispatchMessage,
        blipLocation = pNotificationData.origin,
        blipSprite = pNotificationData.blipSprite,
        blipColor = pNotificationData.blipColor
    })
end

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
end)

RegisterNetEvent('dispatch:clNotify')
AddEventHandler('dispatch:clNotify', function(pNotificationData)
    if pNotificationData ~= nil then
        print("not nil")
        if pNotificationData.recipientList then
            print("list")
            for key, value in pairs(pNotificationData.recipientList) do
                if key == currentJob and value and not disableNotifications then
                    if pNotificationData.origin ~= nil then
                        if pNotificationData.originStatic == nil or not pNotificationData.originStatic then
                            pNotificationData.origin = randomizeBlipLocation(pNotificationData.origin)
                        else
                            pNotificationData.origin = pNotificationData.origin
                        end
                    end

                    if currentJob ~= "news" then
                        SendNUIMessage({
                            mId = "notification",
                            eData = pNotificationData,
                        })
                        sendNewsBlip(pNotificationData)
                    elseif currentJob == "news" then
                        if exports["np-inventory"]:getQuantity("scanner") > 0 then
                            local newsObject = {}
                            newsObject.dispatchMessage = "A 911 call has been picked up on your radio scanner!"
                            newsObject.displayCode = nil
                            newsObject.isImportant = false
                            newsObject.priority = 1

                            SendNUIMessage({
                                mId = "notification",
                                eData = newsObject,
                            })

                            sendNewsBlip(pNotificationData)
                        end
                    end

                    if(pNotificationData.playSound and currentJob ~= "news" and not disableNotificationSounds) then
                        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, pNotificationData.soundName, 0.6)
                    end
                end
            end
        end
    else

    end
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
    currentJob = job
end)

Controlkey = {["showDispatchLog"] = {20, "Z"}}
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["showDispatchLog"] = table["showDispatchLog"]
end)

RegisterNetEvent('dispatch:toggleNotifications')
AddEventHandler('dispatch:toggleNotifications', function(state)
    state = string.lower(state)
    if state == "on" then
        disableNotifications = false
        disableNotificationSounds = false
        TriggerEvent('DoLongHudText', "Dispatch is now enabled.")
    elseif state == "off" then
        disableNotifications = true
        disableNotificationSounds = true
        TriggerEvent('DoLongHudText', "Dispatch is now disabled.")
    elseif state == "mute" then
        disableNotifications = false
        disableNotificationSounds = true
        TriggerEvent('DoLongHudText', "Dispatch is now muted.")
    else
        TriggerEvent('DoLongHudText', "You need to type in 'on', 'off' or 'mute'.")
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        if (IsControlJustReleased(0, Controlkey["showDispatchLog"][1]) and (currentJob == "police" or currentJob == "ems" or currentJob == "news") and not isDead) then
            showDispatchLog = not showDispatchLog
            SetNuiFocus(showDispatchLog, showDispatchLog)
            SetNuiFocusKeepInput(showDispatchLog)
            SendNUIMessage({
                mId = "showDispatchLog",
                eData = showDispatchLog
            })
        end
        if showDispatchLog then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
            DisableControlAction(0, 24, true) -- disable attack
            DisableControlAction(0, 25, true) -- disable aim
            DisableControlAction(0, 47, true) -- disable weapon
            DisableControlAction(0, 58, true) -- disable weapon
            DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
        end
    end
end)

RegisterNUICallback('disableGui', function(data, cb)
    showDispatchLog = not showDispatchLog
    SetNuiFocus(showDispatchLog, showDispatchLog)
    SetNuiFocusKeepInput(showDispatchLog)
end)

RegisterNUICallback('setGPSMarker', function(data, cb)
    SetNewWaypoint(data.gpsMarkerLocation.x, data.gpsMarkerLocation.y)
    TriggerServerEvent("dispatch:svResponder", currentCallSign, data.ctxId, true)
    cb({})
end)

RegisterNUICallback('assignSelf', function(data, cb)
    TriggerServerEvent("dispatch:svResponder", currentCallSign, data.ctxId)
    cb({})
end)

RegisterNetEvent('dispatch:clUpdateResponders')
AddEventHandler('dispatch:clUpdateResponders', function(responders)
    SendNUIMessage({
        mId = "callSignAdd",
        eData = responders
    })
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)

-- test dispatch
-- local idx = 0
-- function gcr()
--     idx = idx + 1
--     return idx
-- end
-- RegisterCommand("svmake", function()
--     TriggerServerEvent("dispatch:svNotify", {
--         priority = 1,
--         gender = 'Male',
--         dispatchCode = '10-32',
--         callSign = 'some bs ' .. gcr()
--     })
-- end)
