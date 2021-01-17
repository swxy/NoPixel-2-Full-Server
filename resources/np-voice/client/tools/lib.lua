local Throttles = {}

function Debug(msg, ...)
    if not Config.enableDebug then return end

    local params = {}

    for _, param in ipairs({ ... }) do
        if type(param) == "table" then
            param = json.encode(param)
        end

        table.insert(params, param)
    end

    print((msg):format(table.unpack(params)))
end

function Throttled(name, time)
    if not Throttles[name] then
        if time then
            Throttles[name] = true
            Citizen.SetTimeout(time, function() Throttles[name] = false end)
        end

        return false
    end

    return true
end

function IsDifferent(current, old)
    if #current ~= #old then
        return true
    else
        for i = 1, #current, 1 do
            if current[i] ~= old[i] then
                return true
            end
        end
    end
end

function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
end

function table.exist(table, val)
    for key, value in pairs(table) do
        local exist

        if type(val) == "function" then
            exists = val(value, key, table)
        else
            exist = val == value
        end

        if exist then
            return true, key
        end
    end

    return false
end

function _C(condition, trueExpr, falseExpr)
    if condition then
        return trueExpr
    else
        return falseExpr
    end
end

-- Required for floating point precision
function almostEqual(pFloat1, pFloat2, pThreshold)
  return math.abs(pFloat1 - pFloat2) <= pThreshold
end

function MakeObject(data)
	local d = msgpack.pack(data)
	return string.pack('<T', #d) .. d
end

function GetDefaultSettings()
    return {
        ["releaseDelay"] = Config.settings.releaseDelay,
        ["stereoAudio"] = Config.settings.stereoAudio,
        ["localClickOn"] = Config.settings.localClickOn,
        ["localClickOff"] = Config.settings.localClickOff,
        ["remoteClickOn"] = Config.settings.remoteClickOn,
        ["remoteClickOff"] = Config.settings.remoteClickOff,
        ["clickVolume"] = Config.settings.clickVolume,
        ["radioVolume"] = Config.settings.radioVolume,
        ["phoneVolume"] = Config.settings.phoneVolume
    }
end

function TimeOut(time)
    local p = promise:new()

    Citizen.SetTimeout(time, function ()
        p:resolve(true)
    end)

    return p
end

function DumpTable(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. DumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end


RegisterCommand("mumble", function()
    local str = [[
        ----------------------------
        Version: %s
        Connected: %s
        Channel: %s
        Target: %s
        Grid: %s
        Neighbor Grids: %s
        Active Grids: %s
        Radio Status: %s
        Radio Transmission: %s
        Remote Transmissions: %s
        ----------------------------
    ]]
    local channel = MumbleGetVoiceChannelFromServerId(GetPlayerServerId(PlayerId()))
    local grid = GetGridChannel(PlayerCoords)
    local neighbors = json.encode(GetTargetChannels(PlayerCoords, Config.gridEdge))
    local channels = json.encode(Channels["contexts"]["grid"])
    local radio = json.encode(Transmissions["contexts"]["radio"])
    print((str):format(Config.version, VoiceEnabled, channel, CurrentTarget, grid, neighbors, channels, IsRadioOn, IsTalkingOnRadio, radio))
end)

-- RegisterNetEvent('event:settings:update')
-- AddEventHandler('event:settings:update', SetSettings)

-- function SetSettings(settings)
--     Settings = settings["tokovoip"]
--     if Settings then
--         RadioVolume = Settings.radioVolume * 1.0
--         UpdateHudSettings(Settings)
--         UpdateContextVolume("phone", Settings.phoneVolume * 1.0)
--     end
-- end