local BlipHandlers = {}

Citizen.CreateThread(function()
	while true do
		if NetworkIsSessionStarted() then
			DecorRegister("EmergencyType", 3)
			DecorSetInt(PlayerPedId(), "EmergencyType", 0)
			return
		end
	end
end)

--[[
	Emergency Type Decor:
		1 = police
		2 = ems
]]

function IsDOC(pCallSign)
	if pCallSign then
		local sign = string.sub(pCallSign, 1, 1)
		return sign == '7'
	else
		return false
	end
end

function GetBlipSettings(pJobId, pCallSign)
	local settings = {}

	settings.short = true
	settings.sprite = 1
	settings.category = 7

	if pJobId == 'police' then
		settings.color = 3
		settings.heading =  true
		settings.text = ('Officer | %s'):format(pCallSign)
	elseif pJobId == 'doc' then
		settings.color = 2
		settings.heading =  true
		settings.text = ('DOC | %s'):format(pCallSign)
	elseif pJobId == 'ems' then
		settings.color = 23
		settings.heading =  true
		settings.text = ('Paramedic | %s'):format(pCallSign)
	end

	return settings
end

function CreateBlipHandler(pServerId, pJob, pCallSign)
	local serverId = pServerId
	local callsign = pCallSign
	local job = pJob

	if job == 'police' and IsDOC(callsign) then
		job = 'doc'
	end

	local settings = GetBlipSettings(job, callsign)

	local handler = EntityBlip:new('player', serverId, settings)

	handler:enable(true)

	BlipHandlers[serverId] = handler
end

function DeleteBlipHandler(pServerId)
	BlipHandlers[pServerId]:disable()
	BlipHandlers[pServerId] = nil
end

RegisterNetEvent('e-blips:setHandlers')
AddEventHandler('e-blips:setHandlers', function(pHandlers)
	for _, pData in pairs(pHandlers) do
		if pData then
			CreateBlipHandler(pData.netId, pData.job, pData.callsign)
		end
	end
end)

RegisterNetEvent('e-blips:deleteHandlers')
AddEventHandler('e-blips:deleteHandlers', function()
	for serverId, pData in pairs(BlipHandlers) do
		if pData then
			DeleteBlipHandler(serverId)
		end
	end

	BlipHandlers = {}
end)

RegisterNetEvent('e-blips:addHandler')
AddEventHandler('e-blips:addHandler', function(pData)
	if pData then
		CreateBlipHandler(pData.netId, pData.job, pData.callsign)
	end
end)

RegisterNetEvent('e-blips:removeHandler')
AddEventHandler('e-blips:removeHandler', function(pServerId)
	if BlipHandlers[pServerId] then
		DeleteBlipHandler(pServerId)
	end
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
	if job == "police" then
		DecorSetInt(PlayerPedId(), "EmergencyType", 1)
	elseif job == "ems" then
		DecorSetInt(PlayerPedId(), "EmergencyType", 2)
	else
		DecorSetInt(PlayerPedId(), "EmergencyType", 0)
	end

	TriggerServerEvent('e-blips:updateBlips', source, job, name)
end)


RegisterNetEvent("e-blips:updateAfterPedChange")
AddEventHandler("e-blips:updateAfterPedChange", function(job)
	if job == "police" then
		DecorSetInt(PlayerPedId(), "EmergencyType", 1)
	elseif job == "ems" then
		DecorSetInt(PlayerPedId(), "EmergencyType", 2)
	else
		DecorSetInt(PlayerPedId(), "EmergencyType", 0)
	end

	TriggerServerEvent('e-blips:updateBlips', source, job)
end)

RegisterNetEvent('np:infinity:player:coords')
AddEventHandler('np:infinity:player:coords', function (pCoords)
	for serverId, handler in pairs(BlipHandlers) do
		if handler and handler.mode == 'coords' and pCoords[serverId] then
			handler:onUpdateCoords(pCoords[serverId])

			if handler:entityExistLocally() then
				handler:onModeChange('entity')
			end
		end
	end
end)

RegisterNetEvent('onPlayerJoining')
AddEventHandler('onPlayerJoining', function(player)
	if BlipHandlers[player] then
		BlipHandlers[player]['inScope'] = true
		Citizen.Wait(1000)
		if BlipHandlers[player]['inScope'] then
			BlipHandlers[player]:onModeChange('entity')
		end
	end
end)

RegisterNetEvent('onPlayerDropped')
AddEventHandler('onPlayerDropped', function(player)
	if BlipHandlers[player] then
		BlipHandlers[player]['inScope'] = false
		BlipHandlers[player]:onModeChange('coords')
	end
end)

local function setDecor()
	local type = 0

	TriggerEvent("nowIsCop", function(_isCop)
		TriggerEvent("nowIsEMS", function(_isMedic)
			type = _isCop and 1 or 0
			type = (type == 0 and _isMedic) and 2 or type
			DecorSetInt(PlayerPedId(), "EmergencyType", type)
		end)
	end)
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		if not DecorExistOn(PlayerPedId(), "EmergencyType") then setDecor() end -- Decors don't stick with players when their ped changes, currently only works with police.
	end
end)