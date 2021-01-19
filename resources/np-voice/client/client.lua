Transmissions, Targets, Channels, Settings = Context:new(), Context:new(), Context:new(), {}
CurrentTarget, CurrentInstance, CurrentProximity, CurrentVoiceChannel, Player, PlayerCoords, PreviousCoords, VoiceEnabled = 2, 0, 1, 0
_myServerId = nil
_isDead = false
isVoiceActive = false


AddEventHandler("syd:isdead",function(isdead)
    _isDead = isDead
end)

Citizen.CreateThread(function()
    RegisterKeyMapping('+cycleProximity', "Cambia Volume Voce", 'keyboard', Config.cycleProximityHotkey)
    RegisterCommand('+cycleProximity', CycleVoiceProximity, false)
    RegisterCommand('-cycleProximity', function() end, false)

    -- while not exports['es_extended']:hasPlayerLoaded() do
    --     Wait(1000)
    -- end

    for i = 1, 4 do
        MumbleClearVoiceTarget(i)
    end

    if Config.enableGrids then
        LoadGridModule()
    end

    if Config.enableRadio then
        LoadRadioModule()
    end

    if Config.enablePhone then
        LoadPhoneModule()
    end

    if Config.enableCar then
        LoadCarModule()
    end

    SetVoiceProximity(2)
    TriggerEvent("np:voice:ready")

    _myServerId = GetPlayerServerId(PlayerId())
    voiceCheck()
    voiceThread()
end)

function voiceCheck()
    Citizen.CreateThread(function()
        local toggle = false
        while true do
            local idle = 500
            Player = PlayerPedId()
            --PlayerCoords = GetEntityCoords(Player)
            isVoiceActive = GetConvar('profile_voiceEnable', 0) == '1' 
    
            if isVoiceActive and not VoiceEnabled then
                TriggerEvent('np:voice:state', true)
            elseif not isVoiceActive and VoiceEnabled then
                TriggerEvent('np:voice:state', false)
            elseif not toggle and not isVoiceActive and not VoiceEnabled then
                TriggerEvent('np:voice:state', false)
                toggle = true
            end
    
            Citizen.Wait(idle)
        end
    end)
end


function voiceThread()
    --local id = PlayerId()
    local toggle = false
    Citizen.CreateThread(function()
        while true do
            local idle = 250

            if isVoiceActive and NetworkIsPlayerTalking(PlayerId()) then
                if not toggle then
                    TriggerEvent('yeahlol:ofc', true)
                    toggle = true
                end
            elseif isVoiceActive and toggle then
                toggle = false
                TriggerEvent('yeahlol:ofc', false)
            end
    
            Citizen.Wait(idle)
        end
    end)
end


AddEventHandler('np:voice:state', function(state)
    VoiceEnabled = state

    -- exports['tcm_hud']:toggleMumbleWarning(state)

    TriggerServerEvent("np:voice:connection:state", state)

    if VoiceEnabled then
        _myServerId = GetPlayerServerId(PlayerId())
        while MumbleGetVoiceChannelFromServerId(_myServerId) == 0 do
            NetworkSetVoiceChannel(CurrentVoiceChannel)
            Citizen.Wait(100)
        end

        SetVoiceProximity(2)
        MumbleClearVoiceTarget(CurrentTarget) -- Reset voice target
        MumbleSetVoiceTarget(CurrentTarget)
        RefreshTargets()
    end
end)

function RegisterModuleContext(context, priority)
    Transmissions:registerContext(context)
    Targets:registerContext(context)
    Channels:registerContext(context)
    Transmissions:setContextData(context, "priority", priority)

    Debug("[Main] Context Added | ID: %s | Priority: %s", context, priority)
end

function ChangeVoiceTarget(targetID)
    CurrentTarget = targetID
    MumbleSetVoiceTarget(targetID)
end

function SetVoiceChannel(channelID)
   -- MumbleAddVoiceTargetChannel(CurrentTarget, channelID)
    NetworkSetVoiceChannel(channelID)
    Debug("[Main] Current Channel: %s | Previous: %s | Target: %s ", channelID, CurrentVoiceChannel, CurrentTarget)
    CurrentVoiceChannel = channelID
end

function IsPlayerInTargetChannel(serverID)
    local found = false

    if Config.enableGrids then
        local gridChannel = GetGridChannel(GetPlayerCoords(serverID), Config.gridSize)
        found = Channels:targetHasAnyActiveContext(gridChannel) == true
    end

    return found
end

function SetVoiceTargets(targetID)
    local players, channels = {}, {}

    if Config.enableCar and _inVeh then
        for serverID, _ in pairs(_passengers) do
            addTargetTest(serverID, "car")
            MumbleSetVolumeOverrideByServerId(serverID, Config.settings['vehicleVolume']) --test
        end
    end

    Targets:contextIterator(function(serverID)
        if not players[serverID] then --
            players[serverID] = true
           -- print(serverID)
            MumbleAddVoiceTargetPlayerByServerId(targetID, serverID)
        end
    end)

    -- Channels:contextIterator(function(channel)
    --     print("!tes3t")
    --     if not channels[channel] then
    --         channels[channel] = true
    --         MumbleAddVoiceTargetChannel(targetID, channel)
    --     end
    -- end)
end

function RefreshTargets()
    --local voiceTarget = _C(CurrentTarget == 1, 2, 1)
    --MumbleClearVoiceTarget(voiceTarget)
    MumbleClearVoiceTargetPlayers(CurrentTarget)
    SetVoiceTargets(CurrentTarget)
    --ChangeVoiceTarget(voiceTarget)
end


function AddPlayerToTargetList(serverID, context, transmit)
    if not Targets:targetContextExist(serverID, context) then

        if transmit then
            TriggerServerEvent("np:voice:transmission:state", serverID, context, true, false)
        end

        if not Targets:targetHasAnyActiveContext(serverID) and _myServerId ~= serverID then --and not IsPlayerInTargetChannel(serverID) TEST
            MumbleAddVoiceTargetPlayerByServerId(CurrentTarget, serverID)
        end

        Targets:add(serverID, context)

        Debug("[Main] Target Added | Player: %s | Context: %s ", serverID, context)
    end
end

function addTargetTest(serverID, context)
    if not Targets:targetContextExist(serverID, context) then
        if not Targets:targetHasAnyActiveContext(serverID) and _myServerId ~= serverID then
            MumbleAddVoiceTargetPlayerByServerId(CurrentTarget, serverID)
        end

        Targets:add(serverID, context)

        Debug("[Main] Target Added | Player: %s | Context: %s ", serverID, context)
    end
end

function removeTargetTest(serverID, context)
    if Targets:targetContextExist(serverID, context) then
        Targets:remove(serverID, context)
        Debug("[Main] Target Removed | Player: %s | Context: %s ", serverID, context)
    end
end

function RemovePlayerFromTargetList(serverID, context, transmit, refresh)
    if Targets:targetContextExist(serverID, context) then
        Targets:remove(serverID, context)

        if transmit then
            TriggerServerEvent("np:voice:transmission:state", serverID, context, false, false)
        end

        if refresh then
            RefreshTargets()
        end

        Debug("[Main] Target Removed | Player: %s | Context: %s ", serverID, context)
    end
end

function AddGroupToTargetList(group, context)
    if not Targets:contextExists(context) then return end

    for serverID, active in pairs(group) do
        if active then
            AddPlayerToTargetList(serverID, context, false)
        end
    end

    TriggerServerEvent("np:voice:transmission:state", group, context, true, true)
end

function RemoveGroupFromTargetList(group, context)
    if not Targets:contextExists(context) then return end

    for serverID, active in pairs(group) do
        if active then
            RemovePlayerFromTargetList(serverID, context, false, false)
        end
    end

    RefreshTargets()

    TriggerServerEvent("np:voice:transmission:state", group, context, false, true)
end

function AddChannelToTargetList(channel, context)
    MumbleAddVoiceTargetChannel(CurrentTarget, channel)
    if not Channels:targetContextExist(channel, context) then
        Channels:add(channel, context)

        Debug("[Main] Channel Added | ID: %s | Context: %s ", channel, context)
    end
end

function RemoveChannelFromTargetList(channel, context, refresh)
    if Channels:targetContextExist(channel, context) then
        Channels:remove(channel, context)

        --MumbleRemoveVoiceChannelListen(channel)
        -- if refresh then
        --     RefreshTargets()
        -- end

        Debug("[Main] Channel Removed | ID: %s | Context: %s ", channel, context)
    end
end

function AddChannelGroupToTargetList(group, context)
    if not Channels:contextExists(context) then return end

    for _, channel in pairs(group) do
        AddChannelToTargetList(channel, context)
    end
end

function RemoveChannelGroupFromTargetList(group, context)
    if not Channels:contextExists(context) then return end

    for _, channel in pairs(group) do
        RemoveChannelFromTargetList(channel, context, false)
    end

    --MumbleClearVoiceTargetChannels(CurrentTarget)
    --RefreshTargets()
end

function CycleVoiceProximity()
    local newProximity = CurrentProximity + 1

    local proximity = _C(Config.voiceRanges[newProximity] ~= nil, newProximity, 1)

    SetVoiceProximity(proximity)
end

function SetVoiceProximity(proximity)
    local voiceProximity = Config.voiceRanges[proximity]

    MumbleSetAudioInputDistance(voiceProximity.range)
    CurrentProximity = proximity
    TriggerEvent("np-hud:changeRange", proximity)
    Debug("[Main] Proximity Range | Proximity: %s | Range: %s", voiceProximity.name, voiceProximity.range)
end

function GetTransmissionVolume(serverID)
    local _, contexts = Transmissions:getTargetContexts(serverID)

    local volume = -1.0

    for _, context in pairs(contexts) do
        if context.volume and context.volume > volume then
            volume = context.volume
        end
    end

    return volume
end

function GetPriorityContextData(serverID)
    local _, contexts = Transmissions:getTargetContexts(serverID)

    local context = { volume = -1.0, priority = 0 }

    for _, ctx in pairs(contexts) do
        if ctx.priority >= context.priority and (ctx.volume == -1 or ctx.volume >= context.volume) then
            context = ctx
        end
    end

    return context
end

function UpdateContextVolume(context, volume)
    Transmissions:setContextData(context, "volume", volume)

    Transmissions:contextIterator(function(targetID, tContext)
        if tContext == context then
            local context = GetPriorityContextData(targetID)

            MumbleSetVolumeOverrideByServerId(targetID, context.volume)
        end
    end)
end

function SetSettings(settings)
    Settings = settings["tokovoip"]
    if Settings then
        RadioVolume = Settings.radioVolume * 1.0
        UpdateHudSettings(Settings)
     --   UpdateContextVolume("phone", Settings.phoneVolume * 1.0)
    end
end

RegisterNetEvent("np:voice:transmission:state")
AddEventHandler("np:voice:transmission:state", function(serverID, context, transmitting)

    if not Transmissions:contextExists(context) then
        return
    end

    if transmitting then
        Transmissions:add(serverID, context)
    else
        Transmissions:remove(serverID, context)
    end

    local data = GetPriorityContextData(serverID)

    if not transmitting then
        MumbleSetVolumeOverrideByServerId(serverID, data.volume)
        Citizen.Wait(0)
    end

    if context == "radio" and IsRadioOn then
        PlayRemoteRadioClick(transmitting)
    end

    if transmitting then
        Citizen.Wait(0)
        MumbleSetVolumeOverrideByServerId(serverID, data.volume)
    end

    if (Config.enableFilters.phone or Config.enableFilters.radio) and CanUseFilter(transmitting, context) then
        SetTransmissionFilters(serverID, data)
    end

    Debug("[Main] Transmission | Origin: %s | Vol: %s | Ctx: %s | Active: %s", serverID, data.volume, context, transmitting)
end)

RegisterNetEvent('np:voice:targets:player:add')
AddEventHandler('np:voice:targets:player:add', AddPlayerToTargetList)

RegisterNetEvent('np:voice:targets:player:remove')
AddEventHandler('np:voice:targets:player:remove', RemovePlayerFromTargetList)

Citizen.CreateThread(function()
    RegisterKeyMapping('+cycleProximity', "Cycle Proximity Range", 'keyboard', Config.cycleProximityHotkey)
    RegisterCommand('+cycleProximity', CycleVoiceProximity, false)
    RegisterCommand('-cycleProximity', function() end, false)

    RegisterKeyMapping('mumble', "Reset Mumble VOIP", 'keyboard', "")

    for i = 1, 4 do
        MumbleClearVoiceTarget(i)
    end

    if Config.enableSubmixes then
        RegisterContextSubmix('default')
    end

    if Config.enableGrids then
        LoadGridModule()
    end

    if Config.enableRadio then
        LoadRadioModule()
    end

    if Config.enableToko then
        LoadTokoModule()
    end

    if Config.enablePhone then
        LoadPhoneModule()
    end

    SetVoiceProximity(2)

    TriggerEvent("np:voice:ready")

    SetSettings(exports["np-base"]:getModule("SettingsData"):getSettingsTable())
end)

RegisterNetEvent('event:settings:update')
AddEventHandler('event:settings:update', SetSettings)
