local chance = 0
local skillGap = 20

function openGui(sentLength,taskID,namesent,chancesent,skillGapSent)
    guiEnabled = true
    SetNuiFocus(guiEnabled,false)
    print("taskbar started")
    SendNUIMessage({runProgress = true, Length = sentLength, Task = taskID, name = namesent, chance = chancesent, skillGap = skillGapSent})
end
function updateGui(sentLength,taskID,namesent,chancesent,skillGapSent)
    SendNUIMessage({runUpdate = true, Length = sentLength, Task = taskID, name = namesent, chance = chancesent, skillGap = skillGapSent})
end
local activeTasks = 0
function closeGuiFail()
    guiEnabled = false
    SetNuiFocus(guiEnabled,false)
    SendNUIMessage({closeFail = true})
end
function closeGui()
    guiEnabled = false
    SetNuiFocus(guiEnabled,false)
    SendNUIMessage({closeProgress = true})
end

function closeNormalGui()
    guiEnabled = false
    SetNuiFocus(guiEnabled,false)
end
  
RegisterNUICallback('taskCancel', function(data, cb)
  closeGui()
  activeTasks = 2
  FactorFunction(false)
end)

RegisterNUICallback('taskEnd', function(data, cb)
    closeNormalGui()
    if (tonumber(data.taskResult) < (chance + 20) and tonumber(data.taskResult) > (chance))  then
        activeTasks = 3
        --TriggerEvent("notification","Success!")
        factor = 1.0
    else
        FactorFunction(false)
        activeTasks = 2
    end
end)

local factor = 1.0
local taskInProcess = false
local calm = true

function FactorFunction(pos)
    if not pos then
        factor = factor - 0.1
        if factor < 0.1 then
            factor = 0.1
        end
        if factor == 0.5 and calm then
            calm = false
            TriggerEvent("notification","You are frustrated", 2)
        end
        TriggerEvent("factor:restore")        
    else
        if factor > 1.0 or factor == 0.9 then
            if not calm then
                TriggerEvent("notification","You are calm again")
                calm = true
            end            
            factor = 1.0
            return
        end
        factor = factor + 0.1
    end    
end

RegisterNetEvent('factor:restore')
AddEventHandler('factor:restore', function()
    Wait(15000)
    FactorFunction(true)
end)

-- difficulty around 1200 becomes hard on the 4-5th use
-- difficulty around 2500 should never really be a problem - just keeps them focused.

-- skillGap is the width of our current skill, 20 being easy, lower down to 5 is harder, almost impossible with higher speeds.

function taskBar(difficulty,skillGapSent)
    Wait(100)
    skillGap = skillGapSent
    if skillGap < 5 then
        skillGap = 5
    end
    local name = "E"
    local playerPed = PlayerPedId()
    if taskInProcess then
        return 100
    end
    FactorFunction(false)
    chance = math.random(15,90)

    local length = math.ceil(difficulty * factor)

    taskInProcess = true
    local taskIdentifier = "taskid" .. math.random(1000000)
    openGui(length,taskIdentifier,name,chance,skillGap)
    activeTasks = 1

    local maxcount = GetGameTimer() + length
    local curTime

    while activeTasks == 1 do
        Citizen.Wait(1)
        curTime = GetGameTimer()
        if curTime > maxcount then
            activeTasks = 2
        end
        local updater = 100 - (((maxcount - curTime) / length) * 100)
        updater = math.min(100, updater)
        updateGui(updater,taskIdentifier,name,chance,skillGap)
    end

    if activeTasks == 2 then
        closeGui()
        taskInProcess = false
        return 0
    else
        closeGui()
        taskInProcess = false
        return 100
    end 
   
end
