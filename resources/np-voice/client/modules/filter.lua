local ActiveChains = {}

function GetDistortionCurve(amount)
    local k = _C(type(amount) == "number", amount, 50)
    local curve = {}

    local deg = math.pi / 180

    for i = 1, 44100 do
        local x = (i - 1) * 2 / 44100 - 1;
        curve[i] = ( 3 + k ) * x * 20 * deg / ( math.pi + k * math.abs(x) );
    end

    return MakeObject(curve)
end

function SetBiquadFilterValues(node, settings)
    if settings.type then
        BiquadfilternodeSetType(node, settings.type)
    end

    if settings.frequency then
        SetAudioParameterValue(GetBiquadFrequency(node), settings.frequency)
    end

    if settings.q then
        SetAudioParameterValue(GetBiquadQuality(node), settings.q)
    end

    if settings.detune then
        SetAudioParameterValue(GetBiquadDetune(node), settings.detune)
    end

    if settings.gain then
        SetAudioParameterValue(GetBiquadGain(node), settings.gain)
    end
end

function SetWaveShaperCurve(node, settings)
    if settings.curve then
        WaveshapernodeSetCurve(node, settings.curve)
    end
end

function CreateBipadFilter(audioContext, filterData)
    local audioNode = AudiocontextCreateBiquadfilternode(audioContext)

    SetBiquadFilterValues(audioNode, filterData)

    return audioNode
end

function CreateWaveShaperFilter(audioContext, filterData)
    local audioNode = AudiocontextCreateWaveshapernode(audioContext)

    SetWaveShaperCurve(audioNode, filterData)

    return audioNode
end

function CreateFilterNode(context, effect)
    local node = nil

    if effect.filterType == "biquad" then
        node = CreateBipadFilter(context, effect)
    elseif effect.filterType == "waveshaper" then
        node = CreateWaveShaperFilter(context, effect)
    end

    return node
end

function CreateContextData(serverID)
    --print(serverID)
    --local playerID = GetPlayerFromServerId(serverID)
    -- print(playerID)
    local context = GetAudiocontextForServerId(serverID)--GetAudiocontextForClient(playerID)
    --local context = GetAudiocontextForClient(playerID)
    --print(context)
    local source = AudiocontextGetSource(context)
   -- print(source)
    local destination = AudiocontextGetDestination(context)
    -- print(destination)

    -- local playerID = GetPlayerFromServerId(serverID)
    -- local context = GetAudiocontextForClient(playerID)
    -- local source = AudiocontextGetSource(context)
    -- local destination = AudiocontextGetDestination(context)

    local data = {
        context = context,
        source = source,
        destination = destination,
        node = destination,
        active = true,
        filters = {},
    }

    return data
end

function CreateFilterChain(serverID, data)
    local audio = CreateContextData(serverID)

    for index, filter in pairs(data.filter) do
        local node = CreateFilterNode(audio.context, filter)

        Wait(200)
        if node then
            if index == 1 then
                Citizen.Wait(0)
                AudiocontextDisconnect(audio.context, audio.destination, audio.source, 0, 0)
                Citizen.Wait(0)
                AudiocontextConnect(audio.context, node, audio.source, 0, 0)
                Citizen.Wait(0)
                AudiocontextConnect(audio.context, audio.destination, node, 0, 0)
                Citizen.Wait(0)
            else
                Citizen.Wait(0)
                AudiocontextDisconnect(audio.context, audio.destination, audio.node, 0, 0)
                Citizen.Wait(0)
                AudiocontextConnect(audio.context, node, audio.node, 0, 0)
                Citizen.Wait(0)
                AudiocontextConnect(audio.context, audio.destination, node, 0, 0)
                Citizen.Wait(0)
            end

            audio.node = node
            audio.filters[#audio.filters + 1] = { node = node, type = filter.filterType }
        end
    end

    return audio
end

function ModifyFilterChain(audio, data)
    for _, filter in pairs(audio.filters) do
        if filter and filter.settings then
            local values = filter.settings

            for _, settings in pairs(data.filter) do
                if values.filterType == settings.filterType and values.type == settings.type then
                    if settings.filterType == "biquad" then
                        SetBiquadFilterValues(filter.node, settings)
                    elseif settings.filterType == "waveshaper" then
                        SetWaveShaperCurve(filter.node, settings)
                    end
                end
            end
        end
    end
end

function DeleteFilterChain(serverID)
    local audio = ActiveChains[serverID]

    ActiveChains[serverID] = nil

    if audio then 
        Debug("[Filter] Chain Deleted | Player: %s ", serverID)
        if audio.active then
            AudiocontextDisconnect(audio.context, audio.destination, audio.node, 0, 0)
            Citizen.Wait(0)
            AudiocontextConnect(audio.context, audio.destination, audio.source, 0, 0)
            Citizen.Wait(100)
        end

        for _, filter in pairs(audio.filters) do
            if filter.type == "biquad" then
                DestroyBiquadFilterNode(filter.node)
            elseif filter.type == "waveshaper" then
                DestroyWaveShaperNode(filter.node)
            end
        end
    end
end

function ConnectFilterChain(audio)
    AudiocontextDisconnect(audio.context, audio.destination, audio.source, 0, 0)

    Citizen.Wait(50) -- 100

    for index, filter in ipairs(audio.filters) do
        if index == 1 then
            AudiocontextConnect(audio.context, filter.node, audio.source, 0, 0)
        else
            AudiocontextConnect(audio.context, filter.node, audio.filters[index - 1]["node"], 0, 0)
        end

        Citizen.Wait(50) --200
    end

    AudiocontextConnect(audio.context, audio.destination, audio.filters[#audio.filters]["node"], 0, 0)

    Citizen.Wait(50) --100
    
    audio.active = true
end

function DisconnectFilterChain(audio)
    local node = audio.filters[#audio.filters].node

    if node then
      AudiocontextDisconnect(audio.context, audio.destination, node, 0, 0)
      Citizen.Wait(100)
      AudiocontextConnect(audio.context, audio.destination, audio.source, 0, 0)
    end

    audio.active = false
end

function SetTransmissionFilters(serverID, data)
    local chain = ActiveChains[serverID]

    if not chain and data.filter then
        --ActiveChains[serverID] = CreateFilterChain(serverID, data)
        Debug("[Filter] Chain Created | Player: %s ", serverID)
    elseif chain and chain.active and data.filter then
        --ModifyFilterChain(chain, data)
        Debug("[Filter] Chain Modified | Player: %s ", serverID)
    elseif chain and not chain.active and data.filter then
        --ConnectFilterChain(chain, data)
        Debug("[Filter] Chain Connected | Player: %s ", serverID)
    elseif chain and chain.active and not data.filter then
      --  DisconnectFilterChain(chain)
        Debug("[Filter] Chain Disconnected | Player: %s ", serverID)
    end
end


function UpdateContextFilter(context, pSettings)
    Transmissions:setContextData(context, "filter", pSettings)

    Transmissions:contextIterator(function(targetID, pContext)
        if pContext == context then
            local context = GetTransmissionFilter(targetID)
            UpdateFilterNodes(targetID, context.filter)
        end
    end)
end

function CanUseFilter(transmitting, context)
    if not VoiceEnabled then
        return false
    elseif transmitting and context == "radio" and not IsRadioOn then
        return false
    end

    return true
end

RegisterNetEvent("np:voice:connection:state")
AddEventHandler("np:voice:connection:state", function (serverID, isConnected)
    if Config.enableFilters.radio and not isConnected then
        DeleteFilterChain(serverID)
        Debug("[Filter] Submix Reset | Player: %s ", serverID)
    end
end)

AddEventHandler('np:voice:state', function (isActive)
    if Config.enableFilters.radio and not isActive then
        for serverID, chain in pairs(ActiveChains) do
            if chain then
                DeleteFilterChain(serverID)
               -- Debug("[Filter] Chain Deleted | Player: %s ", serverID)
            end
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() or not Config.enableFilters.radio then return end
    for serverID, chain in pairs(ActiveChains) do
        if chain then
            DeleteFilterChain(serverID)
        end
    end
end)

RegisterCommand("getc", function(source, args)
    local playerID = GetPlayerFromServerId(serverID)
    --print(playerID)
    local context = GetAudiocontextForClient(playerID)
    print(context)
    --print(DumpTable(GetVehiclePassengers(_currentvehicle)))
end)

RegisterCommand("getc1", function(source, args)
    --local playerID = GetPlayerFromServerId(serverID)
    --print(playerID)
    local context = GetAudiocontextForServerId(tonumber(args[1]))
    print(context)
    --print(DumpTable(GetVehiclePassengers(_currentvehicle)))
end)