RadioChannels, IsRadioOn, IsTalkingOnRadio, RadioVolume, CurrentChannel = {}, false, false, Config.settings.radioVolume

local function ConnectToRadio (radioID, subscribers)
    if RadioChannels[radioID] then return end

    local channel = RadioChannel:new(radioID)

    for _, subscriber in ipairs(subscribers) do
        channel:addSubscriber(subscriber)
    end

    RadioChannels[radioID] = channel

    SetRadioChannel(radioID)

    Debug("[Radio] Connected | Radio ID: %s", radioID)
end

local function AddRadioSubscriber(radioID, serverID)
    if not RadioChannels[radioID] then return end

    local channel = RadioChannels[radioID]

    if not channel:subscriberExists(serverID) then
        channel:addSubscriber(serverID)

        if IsTalkingOnRadio and CurrentChannel.id == radioID then
            AddPlayerToTargetList(serverID, "radio", true)
        end

        Debug("[Radio] Subscriber Added | Radio ID: %s | Player: %s ", radioID, serverID)
    end
end


local function RemoveRadioSubscriber(radioID, serverID)
    if not RadioChannels[radioID] then return end

    local channel = RadioChannels[radioID]

    if channel:subscriberExists(serverID) then
        channel:removeSubscriber(serverID)

        if IsTalkingOnRadio and CurrentChannel.id == radioID then
            RemovePlayerFromTargetList(serverID, "radio", true, true)
        end

        Debug("[Radio] Subscriber Removed | Radio ID: %s | Player: %s ", radioID, serverID)
    end
end

local function DisconnectFromRadio(radioID)
    if not RadioChannels[radioID] then return end

    RadioChannels[radioID] = nil

    if CurrentChannel.id == radioID then
        CycleRadioChannels()
    end

    Debug("[Radio] Disconnected | ID %s", radioID)
end

function SetRadioChannel(radioID)
    CurrentChannel = RadioChannels[radioID]

    Debug("[Radio] Channel Changed | Radio ID: %s", radioID)
end

function StartTransmission()
    if not IsRadioOn or not CurrentChannel or Throttled("radio:transmit") or _isDead then return end

    if not IsTalkingOnRadio then
        IsTalkingOnRadio = true

        AddGroupToTargetList(CurrentChannel.subscribers, "radio")

        StartRadioTask()

        PlayLocalRadioClick(true)

        Debug("[Radio] Transmission | Sending: %s | Radio ID: %s", IsTalkingOnRadio, CurrentChannel.id)
    end

    if RadioTimeout then
        RadioTimeout:resolve(false)
    end
end

function StopTransmission(forced)
    if not IsTalkingOnRadio or RadioTimeout then return end

    RadioTimeout = TimeOut(300):next(function (continue)
        RadioTimeout = nil

        if forced ~= true and not continue then return end

        IsTalkingOnRadio = false

        RemoveGroupFromTargetList(CurrentChannel.subscribers, "radio")

        PlayLocalRadioClick(false)

        Throttled("radio:transmit", 300)

        Debug("[Radio] Transmission | Sending: %s | Radio ID: %s", IsTalkingOnRadio, CurrentChannel.id)
    end)

    return RadioTimeout
end

function IncreaseRadioVolume()
  local currentVolume = RadioVolume * 10
  SetRadioVolume(currentVolume + 1)
end

function DecreaseRadioVolume()
  local currentVolume = RadioVolume * 10
  SetRadioVolume(currentVolume - 1)
end

function SetRadioVolume(volume)
    if volume <= 0 then return end

    RadioVolume = _C(volume > 10, 1.0, volume * 0.1)

    if almostEqual(0.0, volume, 0.01) then RadioVolume = 0.0 end

    if IsRadioOn then
      UpdateContextVolume("radio", RadioVolume)
    end

    TriggerEvent("DoLongHudText", "New volume "..RadioVolume, 1)
    print("New volume " .. RadioVolume)

    Debug("[Radio] Volume Changed | Current: %s", RadioVolume)
end

function SetRadioPowerState(state)
    IsRadioOn = state

    local volume = _C(IsRadioOn, RadioVolume, -1.0)

    UpdateContextVolume("radio", volume)

    if not IsRadioOn and IsTalkingOnRadio then
        StopTransmission(true)
    end

    UpdateRadioPowerState(IsRadioOn)

    Debug("[Radio] Power State | Powered On: %s", IsRadioOn)
end

function CycleRadioChannels()
    if not IsRadioOn then return end

    local firstEntry, lastEntry, nextChannel

    if IsTalkingOnRadio then
        Citizen.Await(StopTransmission(true))
    end

    for radioID, _ in pairs(RadioChannels) do
        if firstEntry == nil then
            firstEntry = radioID
        end

        if CurrentChannel == nil then
            nextChannel = radioID
            break
        elseif lastEntry == CurrentChannel.id then
            nextChannel = radioID
            break
        end

        lastEntry = radioID
    end

    local radioID = _C(nextChannel ~= nil, nextChannel, firstEntry)

    if radioID then
        SetRadioChannel(radioID)
    else
        CurrentChannel = nil
    end
end

function StartRadioTask()
    Citizen.CreateThread(function()
        local lib = "random@arrests"
        local anim = "generic_radio_chatter"

        LoadAnimDict("random@arrests")

        while IsTalkingOnRadio do
            if not IsEntityPlayingAnim(Player, lib, anim, 3) then
                TaskPlayAnim(Player, lib, anim, 8.0, 0.0, -1, 49, 0, false, false, false)
            end

            SetControlNormal(0, 249, 1.0)

            Citizen.Wait(0)
        end

        StopAnimTask(Player, lib, anim, 3.0)
    end)
end

function LoadRadioModule()
    RegisterModuleContext("radio", 2)
    UpdateContextVolume("radio", -1.0)

    RegisterKeyMapping('+transmitToRadio', "Radio PTT", 'keyboard', Config.transmitToRadioHotkey)
    RegisterCommand('+transmitToRadio', StartTransmission, false)
    RegisterCommand('-transmitToRadio', StopTransmission, false)

    RegisterKeyMapping('+secondaryTransmitToRadio', "Radio PTT Secondario", 'keyboard', "")
    RegisterCommand('+secondaryTransmitToRadio', StartTransmission, false)
    RegisterCommand('-secondaryTransmitToRadio', StopTransmission, false)

    if Config.enableMultiFrequency then
        RegisterKeyMapping('+cycleChannels', "Cambia Canale Radio", 'keyboard', Config.cycleRadioChannelHotkey)
        RegisterCommand('+cycleChannels', CycleRadioChannels, false)
        RegisterCommand('-cycleChannels', function() end, false)
    end

    RegisterNetEvent("np:voice:radio:connect")
    AddEventHandler("np:voice:radio:connect", ConnectToRadio)

    RegisterNetEvent("np:voice:radio:disconnect")
    AddEventHandler("np:voice:radio:disconnect", DisconnectFromRadio)

    RegisterNetEvent("np:voice:radio:added")
    AddEventHandler("np:voice:radio:added", AddRadioSubscriber)

    RegisterNetEvent("np:voice:radio:removed")
    AddEventHandler("np:voice:radio:removed", RemoveRadioSubscriber)

    RegisterNetEvent("np:voice:radio:power")
    AddEventHandler("np:voice:radio:power", SetRadioPowerState)

    RegisterNetEvent("np:voice:radio:volume")
    AddEventHandler("np:voice:radio:volume", SetRadioVolume)

    exports("SetRadioPowerState", SetRadioPowerState)
    exports("SetRadioVolume", SetRadioVolume)
    exports("IncreaseRadioVolume", IncreaseRadioVolume)
    exports("DecreaseRadioVolume", DecreaseRadioVolume)
    exports("getCurrentChannelId", getCurrentChannelId)

     if Config.enableFilters.radio then
        local filters = {
            { name = "freq_low", value = 100.0 },
            { name = "freq_high", value = 3310.0 },
            { name = "rm_freq", value = 150.0 },
            { name = "rm_mix", value = 0.65 },
            { name = "fudge", value = 4.0 },
            { name = "o_freq_lo", value = 100.0 },
            { name = "o_freq_hi", value = 3310.0 },
        }

         UpdateContextFilter("radio", filters)
     end

    TriggerEvent("np:voice:radio:ready")

    Debug("[Radio] Module Loaded")
end


RegisterCommand("IncreaseRadioVolume", function(src, args, raw)
    IncreaseRadioVolume()
end, true)

RegisterCommand("DecreaseRadioVolume", function(src, args, raw)
    DecreaseRadioVolume()
end, true)

function getCurrentChannelId()
    return CurrentChannel.id
end

RegisterCommand("debuggo", function(src, args, raw)
    print(DumpTable(CurrentChannel))
end, true)

function PlayRemoteRadioClick(transmitting)
    if transmitting and Config.settings.remoteClickOn or not transmitting and Config.settings.remoteClickOff then
        --SendNUIMessage({ type = 'remoteClick', state = transmitting})
        if transmitting then
            TriggerEvent("InteractSound_CL:PlayOnOne","01-on",0.1)
        else
            TriggerEvent("InteractSound_CL:PlayOnOne","01-off",0.1)
        end
    end
end

function PlayLocalRadioClick(transmitting)
    if transmitting and Config.settings.localClickOn or not transmitting and Config.settings.localClickOff then
        --SendNUIMessage({ type = 'localClick', state = transmitting})
        if transmitting then
            TriggerEvent("InteractSound_CL:PlayOnOne","01-on",0.1)
        else
            TriggerEvent("InteractSound_CL:PlayOnOne","01-off",0.1)
        end
        TriggerEvent("hud:voice:transmitting", transmitting)
    end
end

function UpdateRadioPowerState(state)
    --SendNUIMessage({ type = 'radioPowerState', state = state })
    if state then
        TriggerEvent("InteractSound_CL:PlayOnOne","radioon",0.2)
    else
        TriggerEvent("InteractSound_CL:PlayOnOne","radiooff",0.2)
    end
end

function UpdateHudSettings()
    SendNUIMessage({ type = 'settings', settings = Settings })
end