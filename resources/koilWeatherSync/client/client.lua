kSyncConfigServer={}

daytime = true
primetime = false
lunchtime = false
cracktime = false
cocainetime = false

-- AI Settings 0-1
kSyncConfigServer.traffic = 1.0
kSyncConfigServer.crowd = 1.0
firstspawn = 0
robbing = false
local randomselect = math.random(1,10)
kSyncConfigServer.windSpeed = math.ceil(math.random(0,240))
kSyncConfigServer.windDir = math.ceil(math.random(0,360))
--kSyncConfigServer.weather = kSyncConfigServer.weatherTypes[randomselect]

enableSync = true
insidebuilding = false

function SetEnableSync(enable)
	if enable == nil then enable = not noSync end
	enableSync = enable
end

tempaidsareas = {
	
}
tempaidscount = 120000
trafficblip = {}
local spawning = false
RegisterNetEvent('spawning')
AddEventHandler('spawning', function(whatidoes)
spawning = whatidoes

end)
increaseAI = false
RegisterNetEvent('increaseAI')
AddEventHandler('increaseAI', function(increase)
	increaseAI = increase
end)





RegisterNetEvent('aidsarea')
AddEventHandler('aidsarea', function(add,x,y,z,h)

	if add then
		local counter = #tempaidsareas+1
		local m = math.random(19099219)
		tempaidsareas[counter] = { ["x"] = x,["y"] = y,["z"] = z,["h"] = h, ["marker"] = m }
		tempaidscount = 120000

        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, x, y, z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)

        trafficblip[m] = AddBlipForCoord(x, y, z)
        Citizen.Trace(m)
        SetBlipSprite(trafficblip[m], 305)
		SetBlipScale(trafficblip[m], 0.7)
		SetBlipAsShortRange(trafficblip[m], true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Road Incident")
		EndTextCommandSetBlipName(trafficblip[m])


	else

		local removals = {}
		for i = 1, #tempaidsareas do
			local dst = #(vector3(tempaidsareas[i]["x"],tempaidsareas[i]["y"],tempaidsareas[i]["z"]) - vector3(x,y,z))
	
			if dst < 7.0 then
				removals[#removals+1] = i
				
				local blipid = tempaidsareas[i]["marker"]
				local remblip = trafficblip[blipid]
				RemoveBlip(remblip)
			end
		end
		local count = #removals

		while count > 0 do
			table.remove(tempaidsareas,removals[count])
			count = count - 1
			Citizen.Wait(1)
		end
	end

end)

aidsareas = {
	[1] = { ["x"] = 1822.8262939453, ["y"] = 2248.7468261719, ["z"] = 53.709140777588},
	[2] = { ["x"] = 1704.5872802734, ["y"] = 3506.8410644531, ["z"] = 36.429180145264},
	[3] = { ["x"] = 1726.2159423828, ["y"] = 2536.3801269531, ["z"] = 45.564891815186},
	[4] = { ["x"] = 148.81317138672, ["y"] = 6529.986328125, ["z"] = 31.715270996094},
	[5] = { ["x"] = -383.93887329102, ["y"] = 5997.466796875, ["z"] = 31.456497192383},
	[6] = { ["x"] = 2062.81640625, ["y"] = 3721.5895996094, ["z"] = 33.070247650146},
	[7] = { ["x"] = -216.88275146484, ["y"] = 6320.8959960938, ["z"] = 31.454381942749},
	[8] = { ["x"] = -3100.7924804688, ["y"] = 1186.4498291016, ["z"] = 20.33984375},
	[9] = { ["x"] = -2704.9948730469, ["y"] = 2305.4291992188, ["z"] = 18.006093978882},
	[10] =  { ['x'] = -551.43, ['y'] = 271.11, ['z'] = 82.97 },
	[11] =  { ['x'] = 534.99, ['y'] = -3105.27, ['z'] = 34.56 },
	[12] =  { ['x'] = 2396.26,['y'] = 3112.3,['z'] = 48.15 },
}

function checkAids()

	local plyCoords = GetEntityCoords(PlayerPedId())
	local returninfo = false
	for i = 1, #aidsareas do
		local distance = #(vector3(aidsareas[i]["x"],aidsareas[i]["y"],aidsareas[i]["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
		if distance < 350.0 then
			returninfo = true
		end
	end

	for i = 1, #tempaidsareas do
		local distance = #(vector3(aidsareas[i]["x"],aidsareas[i]["y"],aidsareas[i]["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
		if distance < 350.0 then
			returninfo = true
		end
	end


	return returninfo

end




function canVehBeUsed(ped)
    if ped == nil then
        return false
    end

    if ped == PlayerPedId() then
        return false
    end

    if not DoesEntityExist(ped) then
        return false
    end

    if IsPedAPlayer(ped) then
        return false
    end

    return true
end

local clearStoppedCars = {}
local blockage = false
local alreadyrunning = false
local loop = false
local stoppedHeadings = {}
local headingsCounted = {}

local caradded = {}
function clearStoppedCarsf()
	for i = 1, #clearStoppedCars do
		if DoesEntityExist(clearStoppedCars[i]) then

			TaskVehicleDriveWander(GetPedInVehicleSeat(clearStoppedCars[i], -1), clearStoppedCars[i], 40.0, 1)

			SetPedKeepTask(GetPedInVehicleSeat(clearStoppedCars[i], -1), false)
			SetVehicleEngineOn(clearStoppedCars[i], true, true, 1)
			ClearPedTasks(GetPedInVehicleSeat(veh, -1))
		end
	end
	Citizen.Wait(1000)
	clearStoppedCars = {}
	caradded = {}
end

RegisterNetEvent('stopcarsnow')
AddEventHandler('stopcarsnow', function()

	alreadyrunning = true
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, veh = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom

    repeat
        local pos = GetEntityCoords(veh)
        playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - pos)
        if distance < 65.0 then

        	local vehh = GetEntityHeading(veh)

        	blockaccept = false
        	for i = 1, #headingsCounted do
        		onheading = correctHeading(headingsCounted[i],vehh,35.0)
        		if onheading then
        			blockaccept = true
        		end
        	end

        	if GetPedInVehicleSeat(veh, -1) == 0 or IsPedAPlayer(GetPedInVehicleSeat(veh, -1)) then
        		blockaccept = false
        	end

        	local vpos = GetEntityCoords(veh)
        	local ohfuck = false
        	local front = GetOffsetFromEntityInWorldCoords(veh, 0.0,3.0,0.0)

        	local vehs = GetClosestVehicle(front["x"], front["y"], front["z"], 3.000, 0, 70)
        	local nearpoint = false
        	if caradded[veh] == nil then
        		
        	
	        	for i = 1, #tempaidsareas do
	        		local aidsdist = #(vector3(tempaidsareas[i]["x"],tempaidsareas[i]["y"],tempaidsareas[i]["z"]) - vector3(vpos["x"], vpos["y"], vpos["z"]))
					if aidsdist < 8.0 then
						nearpoint = true
					end
				end
	        	if (vehs ~= veh and DoesEntityExist(vehs)) or nearpoint then
	        		ohfuck = true
	        	end

	        	if blockaccept and ohfuck then
					TaskVehicleTempAction(GetPedInVehicleSeat(veh, -1), veh, 6, 10000.0)
	        		if caradded[veh] == nil then
		        		caradded[veh] = true
		        		clearStoppedCars[#clearStoppedCars+1] = veh
	        		end
	       		elseif blockaccept and GetEntitySpeed(veh) > 6.0 then
	        		SetVehicleForwardSpeed(veh, GetEntitySpeed(veh)-1.5)
	        	end
	        end
        end
        Citizen.Wait(1)
        success, veh = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    alreadyrunning = false

end)

-- 15
-- 345

-- 360%

function oppang( ang )
    return ( ang + 180 ) % 360 
end 

function correctHeading(h1,h2,range)
	local opp = oppang( h1 )
	local resultang = opp - h2
	local negrange = 0 - range
    if ( resultang < range and resultang > negrange ) then 
        return true 
    else
    	return false
    end
	
end





function scaleTwoDec(num)
	num = math.floor(num * 100)
	num = num / 100
	return num
end


function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end
defaultCheck = 50.0
function CountClosestPlayers()
    local players = GetPlayers()
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    local closecount = 1
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            if( distance < defaultCheck) then
                closecount = closecount + 2
            end
        end
    end
    
    return closecount
end




DisabledScenarios = {
	[1]="WORLD_COYOTE_HOWL",
	[2]="WORLD_COYOTE_REST",
	[3]="WORLD_COYOTE_WANDER",
	[4]="WORLD_HUMAN_GUARD_PATROL",
	[5]="WORLD_HUMAN_GUARD_STAND",
	[6]="WORLD_HUMAN_GUARD_STAND_ARMY",
}

DensityMultiplier = 1.0

isAllowedToSpawn = true

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if robbing then
      SetPedDensityMultiplierThisFrame(0.0)
    end
  end
end)

RegisterNetEvent("DensityModifierEnable")
AddEventHandler("DensityModifierEnable",function(newValue)
	isAllowedToSpawn = newValue
end)

RegisterNetEvent('disableCrowd')
AddEventHandler("disableCrowd", function()
--	kSyncConfigServer.traffic = 0.0
--	kSyncConfigServer.crowd = 0.0	
end)
RegisterNetEvent('enableCrowd')
AddEventHandler("enableCrowd", function()
--	kSyncConfigServer.traffic = 0.15
--	kSyncConfigServer.crowd = 0.15	
end)

RegisterNetEvent('kTimeSync')
AddEventHandler("kTimeSync", function( data )
	if not enableSync then return end
	secondOfDay = data
	weatherTimer = 0
end)

AddEventHandler('playerSpawned', function(spawn)
	
	if firstspawn == 0 then
		firstspawn = 1
		TriggerServerEvent("kGetWeather")
		TriggerServerEvent("server:requestNotes")
	end
end)







synctime = {}
secondOfDay = 31800
-- In-game Clock Manipulation Loop
Citizen.CreateThread( function()
	
	local timeBuffer = 0.0
	
	while true do
		Wait( 1000 ) -- (int)(GetMillisecondsPerGameMinute() / 60)
		
		SetWeather()
		SetTimeSync()

		local gameSecond = 10
			
		timeBuffer = timeBuffer + round( 100.0 / gameSecond, 0 )
		if timeBuffer >= 1.0 then
			local skipSeconds = math.floor( timeBuffer )
			
			timeBuffer = timeBuffer - skipSeconds
			secondOfDay = secondOfDay + skipSeconds
			
			if secondOfDay >= 86400 then
				secondOfDay = secondOfDay % 86400
			end
		end
		-- Apply time
		synctime.h = math.floor( secondOfDay / 3600 )
		synctime.m = math.floor( (secondOfDay - (synctime.h * 3600)) / 60 )
		synctime.s = secondOfDay - (synctime.h * 3600) - (synctime.m * 60)
		
		if enableSync and not insidebuilding and not inhotel and not robbing and not inhouse and not spawning then NetworkOverrideClockTime(synctime.h, synctime.m, synctime.s)  TriggerServerEvent('weather:receivefromcl', secondOfDay)end

	end

end)

HudStage = 1
RegisterNetEvent("disableHUD")
AddEventHandler("disableHUD", function(passedinfo)
  HudStage = passedinfo
end)
opacity = 0
fadein = false
GPSActivated = false
RegisterNetEvent("GPSActivated")
AddEventHandler("GPSActivated", function(typesent)
	GPSActivated = typesent
end)

phoneEnabled = false
RegisterNetEvent("phoneEnabled")
AddEventHandler("phoneEnabled", function(typesent)
	phoneEnabled = typesent
end)


function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.0, 0.43)
    SetTextColour(r, g, b, opacity)
    SetTextDropshadow(0, 0, 0, 0, opacity)
    SetTextEdge(1, 0, 0, 0, opacity)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function round( n, precision )
	if precision then
		return math.floor( (n * 10^precision) + 0.5 ) / (10^precision)
	end
	return math.floor( n + 0.5 )
end


RegisterNetEvent('weather:blackout')
AddEventHandler('weather:blackout', function(blackout)
	SetBlackout(blackout)
end)

RegisterNetEvent('weather:setCycle')
AddEventHandler("weather:setCycle", function(cycle)
    SetTimecycleModifier(cycle)
end)

insideWeather = "CLEAR"
curWeather = "CLEAR"
RegisterNetEvent("kWeatherSync")
AddEventHandler("kWeatherSync", function(wfer)
	curWeather = wfer
	-- if curWeather == 'SNOW' then
	-- 	SetForceVehicleTrails(true)
	-- 	SetForcePedFootstepsTracks(true)
	-- 	ForceSnowPass(true)
	-- else
	-- 	SetForceVehicleTrails(false)
	-- 	SetForcePedFootstepsTracks(false)
	-- 	ForceSnowPass(false)
	-- end
end)

RegisterNetEvent("kWeatherSyncForce")
AddEventHandler("kWeatherSyncForce", function(wfer)
	curWeather = wfer
	weatherTimer = -99
	SetWeather()
end)

kSyncConfigServer.weatherTypes = { "XMAS","EXTRASUNNY", "CLEAR", "CLOUDS", "OVERCAST", "CLEAR", "RAIN", "THUNDER", "CLEARING", "NEUTRAL" }

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 175)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

RegisterNetEvent("robbing")
AddEventHandler("robbing", function(status)
	robbing = status
end)

inhouse = false
RegisterNetEvent("inhouse")
AddEventHandler("inhouse", function(status)
	inhouse = status
end)

RegisterNetEvent("inhotel")
AddEventHandler("inhotel", function(status)
	inhotel = status
end)

inhotel = false
oldweather = "none"	
weatherTimer = 0

function SetWeather()
	local coordsply = GetEntityCoords(PlayerPedId())

	if (robbing or insidebuilding or inhotel or inhouse) and not spawning then
		if not robbing then 
			local lights = GetEntityCoords(PlayerPedId())
			--DrawLightWithRange(lights["x"],lights["y"],lights["z"]+3, 255, 197, 143, 100.0, 0.05)
			--DrawLightWithRange(lights["x"],lights["y"],lights["z"]-3, 255, 197, 143, 100.0, 0.05)
			NetworkOverrideClockTime( 23, 0, 0 )
			TriggerEvent("inside:weather",true)
		else
			NetworkOverrideClockTime( 23, 0, 0 )
			TriggerEvent("inside:weather",true)
		end
	end
	if (robbing or insidebuilding or inhouse) then
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(insideWeather)
        SetWeatherTypeNow(insideWeather)
        SetWeatherTypeNowPersist(insideWeather)	
		weatherTimer = 22000

	end

	if (coordsply["z"] < -30 and not insidebuilding and not robbing) or inhotel or inhouse then
		insidebuilding = true
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(insideWeather)
        SetWeatherTypeNow(insideWeather)
        SetWeatherTypeNowPersist(insideWeather)	
        weatherTimer = 22000
        waitSet = true
	else
		if curWeather ~= oldweather or (insidebuilding and coordsply["z"] > -29) then
			SetWeatherTypeOverTime(curWeather, 120.0)
			weatherTimer = 55000
			oldweather = curWeather
			insidebuilding = false
		end
		weatherTimer = weatherTimer - 1
		if weatherTimer < 0 and curWeather == oldweather then
			TriggerEvent("inside:weather",false)
			weatherTimer = 60000
			ClearOverrideWeather()
			ClearWeatherTypePersist()
			SetWeatherTypePersist(curWeather)
			SetWeatherTypeNow(curWeather)
			SetWeatherTypeNowPersist(curWeather)
			SetForceVehicleTrails(curWeather == 'BLIZZARD' or curWeather == 'XMAS')
			SetForcePedFootstepsTracks(curWeather == 'BLIZZARD' or curWeather == 'XMAS')
			ForceSnowPass(curWeather == 'BLIZZARD' or curWeather == 'XMAS' )

		elseif weatherTimer < 0 and (insidebuilding or robbing or inhouse) then
			weatherTimer = 10000
	        ClearOverrideWeather()
	        ClearWeatherTypePersist()
	        SetWeatherTypePersist(insideWeather)
	        SetWeatherTypeNow(insideWeather)
	        SetWeatherTypeNowPersist(insideWeather)	
		end
	end
end


local lastminute = 0

function SetTimeSync()
	local coordsply = GetEntityCoords(PlayerPedId())

	synctime.h = math.floor( secondOfDay / 3600 )
	synctime.m = math.floor( (secondOfDay - (synctime.h * 3600)) / 60 )
	synctime.s = secondOfDay - (synctime.h * 3600) - (synctime.m * 60)

	if (synctime.h > 19 or synctime.h < 7) and daytime then
		daytime = false
		TriggerEvent("daytime",daytime)
	elseif (synctime.h <= 19 and synctime.h >= 7) and not daytime then
		daytime = true
		TriggerEvent("daytime",daytime)
	end

	if (synctime.h > 9 or synctime.h < 17) and not lunchtime then
		lunchtime = true
		TriggerEvent("lunchtime",lunchtime)
	elseif (synctime.h <= 9 and synctime.h >= 17) and lunchtime then
		lunchtime = false
		TriggerEvent("lunchtime",lunchtime)
	end


	if (synctime.h > 21 or synctime.h < 23) and not cocainetime then
		cocainetime = true
		TriggerEvent("cocainetime",cocainetime)
	elseif (synctime.h <= 21 and synctime.h >= 23) and cocainetime then
		cocainetime = false
		TriggerEvent("cocainetime",cocainetime)
	end


	if (synctime.h > 6 or synctime.h < 10) and not cracktime then
		cracktime = true
		TriggerEvent("cracktime",cracktime)
	elseif (synctime.h <= 6 and synctime.h >= 10) and cracktime then
		cracktime = false
		TriggerEvent("cracktime",cracktime)
	end


	if (synctime.h > 15 or synctime.h < 23) and primetime then
		primetime = false
		TriggerEvent("primetime",primetime)
	elseif (synctime.h <= 15 and synctime.h >= 23) and not primetime then
		primetime = true
		TriggerEvent("primetime",primetime)
  end
  
  if synctime.m ~= lastminute then
    lastminute = synctime.m
    TriggerEvent("timeheader",synctime.h,synctime.m)
  end
end