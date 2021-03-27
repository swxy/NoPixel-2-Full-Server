local menuOpen = false
local setDate = 0
local spawnAlreadyInit = false

local function sendMessage(data)
    SendNUIMessage(data)
end

local function openMenu()
    if spawnAlreadyInit then
        return
    end
    menuOpen = true
    sendMessage({open = true})
    SetNuiFocus(true, true)
    TriggerEvent("resetinhouse")
    TriggerEvent("loading:disableLoading")
    Citizen.CreateThread(function()
        while menuOpen do
            Citizen.Wait(0)
            HideHudAndRadarThisFrame()
            DisableAllControlActions(0)
            TaskSetBlockingOfNonTemporaryEvents(PlayerPedId(), true)
            
        end
    end)
    spawnAlreadyInit = true
end

local function closeMenu()
    menuOpen = false
    EnableAllControlActions(0)
    TaskSetBlockingOfNonTemporaryEvents(PlayerPedId(), false)
    SetNuiFocus(false, false)
end

local function disconnect()
    TriggerServerEvent("np-login:disconnectPlayer")
end

local function nuiCallBack(data)
    Citizen.Wait(60)
    local events = exports["np-base"]:getModule("Events")

    if data.close then closeMenu() end
    if data.disconnect then disconnect() end
    --if data.showcursor or data.showcursor == false then SetNuiFocus(true, data.showcursor) end
    if data.setcursorloc then SetCursorLocation(data.setcursorloc.x, data.setcursorloc.y) end
    
    if data.fetchdata then
        events:Trigger("np-base:loginPlayer", nil, function(data)
            if type(data) == "table" and data.err then
                sendMessage({err = data})
                return
            end

            sendMessage({playerdata = data})
        end)
        if data.showcursor or data.showcursor == false then SetNuiFocus(true, data.showcursor) end
    end

    if data.newchar then
        if not data.chardata then return end

        events:Trigger("np-base:createCharacter", data.chardata, function(created)
            if not created then
                created = {
                    err = true,
                    msg = "There was an error while creating your character, value returned nil or false. Contact an administrator if this persists."
                }

                sendMessage({err = created})
                return
            end

            if type(created) == "table" and created.err then
                sendMessage({err = created})
                return
            end

            sendMessage({createCharacter = created})
        end)
    end

    if data.fetchcharacters then
        events:Trigger("np-base:fetchPlayerCharacters", nil, function(data)
            if data.err then
                sendMessage({err = data})
                return
            end

            -- why the fuck do I have to do this???
            for k,v in ipairs(data) do
                data["char" .. k] = data[k]
                data[k] = nil
            end

            sendMessage({playercharacters = data})
           
        end)
    end

    if data.deletecharacter then
        if not data.deletecharacter then return end

        events:Trigger("np-base:deleteCharacter", data.deletecharacter, function(deleted)
            sendMessage({reload = true})
        end)
    end

    if data.selectcharacter then
        events:Trigger("np-base:selectCharacter", data.selectcharacter, function(data)
           
            if not data.loggedin or not data.chardata then sendMessage({err = {err = true, msg = "There was a problem logging in as that character, if the problem persists, contact an administrator <br/> Cid: " .. tostring(data.selectcharacter)}}) return end

            local LocalPlayer = exports["np-base"]:getModule("LocalPlayer")
            LocalPlayer:setCurrentCharacter(data.chardata)
            local cid = LocalPlayer:getCurrentCharacter().id
            TriggerEvent('updatecid', cid)
            
            sendMessage({close = true})

            SetPlayerInvincible(PlayerPedId(), true)

            TriggerEvent("np-base:firstSpawn")
            closeMenu()
            Citizen.Wait(5000)
            TriggerEvent("Relog")
            Citizen.Wait(1000)
            SetPlayerInvincible(PlayerPedId(), false)
        end)
    end
end

RegisterNUICallback("nuiMessage", nuiCallBack)

RegisterNetEvent("np-base:spawnInitialized")
AddEventHandler("np-base:spawnInitialized", function()
    -- Citizen.Wait(3000)
    openMenu()
end)

--[[
RegisterCommand("kapat", function()
    local LocalPlayer = exports["np-base"]:getModule("LocalPlayer")
    local cid = LocalPlayer:getCurrentCharacter().id
    TriggerEvent('updatecid', cid)
    -- TriggerEvent("hotel:createroom")
    -- TriggerEvent("raid_clothes:defaultReset")
    -- DoScreenFadeIn(500)
end)

RegisterCommand("hotel", function()
    TriggerEvent("hotel:createroom")
end)
--]]
RegisterNetEvent("updateTimeReturn")
AddEventHandler("updateTimeReturn", function()
    setDate = "" .. 0 .. ""
    sendMessage({date = setDate})
end)
--[[
RegisterCommand("open", function()
    openMenu()
end)
--]]