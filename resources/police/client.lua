local isInService = false
local rank = "inconnu"
local checkpoints = {}
local existingVeh = nil
local handCuffed = false
local isMedic = false
local isCop = false
local isDoctor = false
local isNews = false
local isDead = false
local canFix = false
local currentCallSign = nil
-- Location to enable an officer service
local takingService = {
{x=457.666809082031, y=-991.062133789063, z=31.6896057128906},
{x=824.968566894531, y=-1290.16088867188, z=29.2406558990479},
{x=1853.36462402344, y=3687.23071289063, z=35.2670822143555},
{x=2112.3696289063, y=2932.1657714844, z=-61.101901245117},

{x=-446.271209716797, y=6014.38037109375, z=32.7163963317871}
 -- {x=850.156677246094, y=-1283.92004394531, z=28.0047378540039},
 -- {x=457.956909179688, y=-992.72314453125, z=30.6895866394043}
 -- {x=1856.91320800781, y=3689.50073242188, z=34.2670783996582},
 -- {x=-450.063201904297, y=6016.5751953125, z=31.7163734436035}
}
local signedonBar = 0
local fixPoints = {
	{428.05,-1020.76,28.92}, -- mrpd
	{1861.26,3672.54,33.88}, -- sandypd
	{-442.02,6033.25,31.34}, -- paleto
	{532.48,-28.83,70.62},
	{545.67,-50.01,70.97},
	{364.7,-591.16,28.69},

	{828.62, -1271.24, 26.27}, -- tunerpd
	{1203.08, -1478.53, 34.86,}, -- mirrorfirestation
	{388.61, -1616.85, 29.3}, -- sspd
	{204.21, -1653.58, 29.81}, -- ssfire
	{-1079.67, -860.32, 5.05}, -- vesppd
	{-570.73, -145.25, 37.73}, -- rockfordpd
	{539.22, -40.58, 70.78}, -- vinewoodpd
	{1803.64, 2606.87, 45.57}, -- prison
}

local stationGarage = {
    {x=452.202728271484, y=-996.407409667969, z=26.7721500396729},
	{x=833.472290039063, y=-1271.86340332031, z=27.2818088531494},
	{x=1863.26916503906, y=3679.23315429688, z=34.6509780883789},
	{x=-474.613647460938, y=6029.98681640625, z=32.3405494689941},
	{x=454.293731689453, y=-1020.38226318359, z=29.3313579559326},
	{x=-474.78530883789, y=-349.97973632813, z=34.358448028564},
	{x=377.30303955078,y=-591.01629638672,z=27.972085189819},
	{x=532.48645019531,y=-28.833206176758,z=70.629531860352},
	{x=292.31979370117,y=-609.703125,z=42.669403839111},
	{x=208.96710205078,y=-1647.5346679688,z=29.803213119507},
	{x=-1172.0729980469,y=-1770.8944091797,z=3.8573622703552},

	--{x=452.115966796875, y=-1018.10681152344, z=28.4786586761475}
}


function DrawText3DVehicle(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


local rankService = 0
RegisterNetEvent('uiTest:setRank')
AddEventHandler('uiTest:setRank', function(result)
	rankService = result
	print(rankService)
end)


Citizen.CreateThread(function()
	local refreshed = false

	while true do
		local dist = #(vector3(448.23,-996.44,30.69) - GetEntityCoords(PlayerPedId()))
		if dist < 100 and not refreshed then
			DisableInterior(137473, false)
			if not IsInteriorReady(137473) then
				LoadInterior(137473)
			else
				RefreshInterior(137473)
			end
			refreshed = true
		end
		if refreshed and dist > 100 then
			DisableInterior(137473, true)
			refreshed = false
		end
		Wait(2000)
	end
end)


Citizen.CreateThread(function()
	while true do
		local coords = GetEntityCoords(PlayerPedId())
		TriggerServerEvent("np-base:updatecoords",coords.x,coords.y,coords.z)
		Wait(13000)
	end
end)

local lawSignOn = { -- #MarkedForMarker
	vector3(249.29,-369.28,-44.13),
	vector3(-1579.71,-580.48,108.53)
}

local evidencelocker = { -- #MarkedForMarker
	vector3(474.799,-994.24,26.23), -- mrpd
    vector3(2059.51,2993.21,-72.70),
	vector3(325.05,-1629.5, -66.78),
	vector3(1848.47,3694.51,34.28), -- sandy
}

local evidencelocker2 = { -- #MarkedForMarker
	vector3(483.13,-992.82,24.23), -- mrpd
}

local trashlocker = {
	vector3(446.84, -996.90, 30.68), -- mrpd
	vector3(1773.814, 2593.880, 49.711), -- jail
	vector3(1851.14,3694.54,34.28), -- sandy
	vector3(-442.0,6005.38,31.72) -- paleto

}

local outfits = {
	vector3(458.52, -999.266, 30.691),
	--vector3(449.8465, -990.204, 30.691),
	--vector3(459.9250, -988.291, 30.691),
	--vector3(1765.041, 2591.543, 49.711)
}

local personalLockers = {
	-- MRPD 
	vector3(474.32, -990.68, 26.27),
	--vector3(450.23, -993.19, 30.69),
	--vector3(458.87, -993.28, 30.69),
	-- sandy
	vector3(1860.99,3691.32,34.28),
	-- paleto
	vector3(-451.61,6016.21,31.72),
	vector3(1763.720, 2592.793, 49.711),
	vector3(1765.674, 2589.165, 49.781),
}


Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local distance = GetDistanceBetweenCoords(pos.x,pos.y,pos.z,481.0489, -995.2978, 30.68964,false)
        if distance <= 1.2 then
            DrawText3DTest(481.0489, -995.2978, 30.68964, "[E] - Open Police Armory")
			if IsControlJustReleased(0, 86) then
			if isCop then
				print(isCop)
                Citizen.Wait(1)
                TriggerEvent("server-inventory-open", "10", "Shop");	
            
            end
        
		end
	end
        Citizen.Wait(5)
    end
end)


-- #MarkedForMarker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local shouldWait = true
		for i,v in ipairs(lawSignOn) do
			local distCheck = #(v - GetEntityCoords(PlayerPedId()))
			if distCheck < 2 then
				if signedonBar == 1 then
					DrawText3DTest(v.x, v.y, v.z,"~r~E~w~ Sign Off law work.")
				else
					DrawText3DTest(v.x, v.y, v.z,"~r~E~w~ Sign On law work.")
				end
			shouldWait = false
			elseif distCheck < 200 then
				shouldWait = false
			end
		end
		if shouldWait then
			Citizen.Wait(9000)
		end
	end
end)

-- #MarkedForMarker
Citizen.CreateThread(function()
	local dstCheck = 100.0
	while true do
		Citizen.Wait(1)
		if isCop then
			
			local nearby = false
			local myCoord = GetEntityCoords(PlayerPedId())
			for i,v in ipairs(evidencelocker) do
				dstCheck = #(v - myCoord)
				if dstCheck < 30 then nearby = true end
				if dstCheck < 0.7 then
				 	DrawText3DTest(v.x, v.y, v.z,"~r~E~w~ Open OLD Evidence Locker - use MDT case# ")
				end
				
			end

			for i,v in ipairs(evidencelocker2) do
				dstCheck = #(v - myCoord)
				if dstCheck < 30 then nearby = true end
				if dstCheck < 2 then
				 	DrawText3DTest(v.x, v.y, v.z,"~r~E~w~ Open Evidence Locker - use /MDT case# ")
				end
			end
			
			for i,v in ipairs(trashlocker) do
				dstCheck = #(v - myCoord)
				if dstCheck < 30 then nearby = true end
				if dstCheck < 2 then
					 DrawText3DTest(v.x, v.y, v.z,"~r~E~w~ Open Trash Locker")
				end
			end

			for i,v in ipairs(outfits) do
				dstCheck = #(v - myCoord)
				if dstCheck < 30 then nearby = true end
				if dstCheck < 1.3 then
					 DrawText3DTest(v.x, v.y, v.z,"~w~ /outfits")
				end
			end

			for i,v in ipairs(personalLockers) do
				dstCheck = #(v - myCoord)
				if dstCheck < 30 then nearby = true end
				if dstCheck < 2 then
					 DrawText3DTest(v.x, v.y, v.z,"~r~E~w~ Open Personal Locker")
				end
			end

			-- Character Switcher
			dstCheck = #(vector3(453.00, -983.803, 30.69) - myCoord)
			if dstCheck < 30 then nearby = true end
			if dstCheck < 3 then
				DrawMarker(25, 453.00, -983.803, 29.69, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.5, 1.5, 1.5, 0, 0, 255, 100, false, true, 2, nil, nil, false)
				if dstCheck < 1 then
					DrawText3DTest(453.00, -983.803, 30.69,"Press ~r~E~w~ to change characters")
					if IsControlJustReleased(1, 38) then
						isCop = false
						TransitionToBlurred(500)
						DoScreenFadeOut(500)
						Wait(1000)
						TriggerEvent("np-base:clearStates")
						exports["np-base"]:getModule("SpawnManager"):Initialize()
						Wait(1000)
					end
				end
			end

			if not nearby then
				Citizen.Wait(dstCheck)
			end
		else
			Citizen.Wait(10000)
		end
	end
end)


RegisterNetEvent('event:control:openpersonalpd')
AddEventHandler('event:control:openpersonalpd', function(useID)
		local cid = exports["isPed"]:isPed("cid")
	if useID == 1 and isCop then
		TriggerEvent("server-inventory-open", "1", "personalMRPD-"..cid)
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'LockerOpen', 0.4)
	elseif useID == 2 and isCop then
		TriggerEvent("server-inventory-open", "1", "personalSandy-"..cid)
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'LockerOpen', 0.4)
	elseif useID == 3 and isCop then
		TriggerEvent("server-inventory-open", "1", "personalPaleto-"..cid)
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'LockerOpen', 0.4)
	end
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
  if not isDead then
    isDead = true
  else
    isDead = false
  end
end)

RegisterNetEvent('evidence:container')
AddEventHandler('evidence:container', function(arg)
	if tonumber(arg) == nil then
		return
	end
		local cid = exports["isPed"]:isPed("cid")
	TriggerServerEvent("server-inventory-open", GetEntityCoords(PlayerPedId()), cid, "1", "Case-"..arg);
end)



RegisterNetEvent('event:control:police')
AddEventHandler('event:control:police', function(useID)
	if useID == 1 then
		TriggerServerEvent('police:checkForBar')

	elseif useID == 2 and isCop then
		TriggerEvent("server-inventory-open", "1", "evidenceLocker")
		TriggerServerEvent('police:viewEvidenceLockup')
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'LockerOpen', 0.4)

	elseif useID == 3 and isCop then
		TriggerEvent("server-inventory-open", "1", "evidenceLocker2")
		TriggerServerEvent('police:viewEvidenceLockup')
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'LockerOpen', 0.4)

	elseif useID == 4 and isCop then 
		TriggerEvent("server-inventory-open", "1", "trash-1")

	elseif useID == 5 and not handCuffed and GetLastInputMethod(2) then 
		TriggerEvent('Police:Radio')

	elseif useID == 6 and not handCuffed and GetLastInputMethod(2) then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if not isInVeh and GetEntitySpeed(PlayerPedId()) > 2.5 then
			TryTackle()
		end

	elseif useID == 7 and not handCuffed and GetLastInputMethod(2) then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if isInVeh then
			TriggerEvent("toggle:cruisecontrol")
		end
	end
end)

local imcollapsed = 0
RegisterNetEvent('collapsecheck')
AddEventHandler('collapsecheck', function()
  if imcollapsed == 0 then 
    imcollapsed = 1
  else
    beingDragged = false
    dragging = false
    imcollapsed = 0
  end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
  TriggerEvent("hud:insidePrompt",true)
  AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
  DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) 
  blockinput = true

  while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
    Citizen.Wait(0)
  end
    
  if UpdateOnscreenKeyboard() ~= 2 then
    local result = GetOnscreenKeyboardResult()
    Citizen.Wait(500)
    blockinput = false
    TriggerEvent("hud:insidePrompt",false)
    return result
  else
    Citizen.Wait(500)
    blockinput = false
    TriggerEvent("hud:insidePrompt",false)
    return nil 
  end
  
end

RegisterNetEvent("police:barCheck")
AddEventHandler("police:barCheck", function(bar)
	if bar == 1 then
		if signedonBar == 0 then
			signedonBar = 1
			TriggerServerEvent("jobssystem:jobs", "defender")
		else
			signedonBar = 0
			TriggerServerEvent("jobssystem:jobs", "unemployed")
		end
	elseif bar == 2 then
		if signedonBar == 0 then
			signedonBar = 1
			TriggerServerEvent("jobssystem:jobs", "district attorney")
		else
			signedonBar = 0
			TriggerServerEvent("jobssystem:jobs", "unemployed")
		end
	else
		TriggerEvent("DoLongHudText","You do not have a BAR license.",2)
	end
end)



function getIsCop()
	return isCop
end

function getIsInService()
	return isCop or isMedic
end

function getIsCuffed()
	return handCuffed
end

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
	if isMedic and job ~= "ems" then isMedic = false isInService = false end
	if isCop and job ~= "police" then isCop = false isInService = false end
	if isNews and job ~= "news" then isNews = false isInService = false end
	if job == "police" then isCop = true TriggerServerEvent('police:getRank',"police") isInService = true end
	if job == "ems" then isMedic = true TriggerServerEvent('police:getRank',"ems") isInService = true end
	if job == "doctor" then isDoctor = true TriggerServerEvent('police:getRank',"doctor") isInService = true end
	if job == "news" then isNews = true isInService = false end
end)

function ChangeToSkinNoUpdatePolice(skin)
	local model = GetHashKey(skin)
	if IsModelInCdimage(model) and IsModelValid(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end
		SetPlayerModel(PlayerId(), model)
		SetPedRandomComponentVariation(PlayerPedId(), true)
		SetModelAsNoLongerNeeded(model)
	else
		TriggerEvent("DoLongHudText","Model not found",2)
	end
end
local scanisokay = false
local scansuccess = false

local recentsearch = 0

Citizen.CreateThread( function()

	while true do 

		Citizen.Wait(100)
		if recentsearch == 0 then
			endDistance = #(vector3(1842.7,2585.9,45.89) - GetEntityCoords(PlayerPedId()))
			endDistance2 = #(vector3(253.04049682617,-367.97076416016,-44.063812255859) - GetEntityCoords(PlayerPedId()))
			if endDistance < 0.7 or endDistance2 < 0.7 then
				recentsearch = 1000
				scansuccess = true
				if endDistance2 < 2.0 then
					TriggerEvent("scanSuccess",true)
				end
				TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'metaldetector', 0.05)
				
				currentWeapons = exports["np-inventory"]:GetCurrentWeapons() 

				if ( #currentWeapons > 0 ) and ( not isCop and not isJudge and not isMedic ) then
					scansuccess = false
					TriggerEvent("weaponcheck:scanner")
					TriggerEvent("scanSuccess",false)
				end
			end
		end

		if recentsearch > 0 or not scansuccess then
			if recentsearch > 0 then
				recentsearch = recentsearch - 1
			end
			if endDistance > 100.0 and endDistance2 > 100.0 then
				Citizen.Wait(10000)
			end
			endDistance3 = #(vector3(2128.45703125,2921.1318359375,-61.901893615723) - GetEntityCoords(PlayerPedId()))
			if endDistance3 < 2.0 then
				currentWeapons = exports["np-inventory"]:GetCurrentWeapons() 
				if #currentWeapons > 0 or not scansuccess then
					TriggerEvent("checkifcop:scanner",1)
				end
			end
			endDistance4 = #(vector3(2119.45703125,2921.1213378906,-61.901893615723) - GetEntityCoords(PlayerPedId()))
			if endDistance4 < 2.0 then
				currentWeapons = exports["np-inventory"]:GetCurrentWeapons() 
				if #currentWeapons > 0 or not scansuccess then			
					TriggerEvent("checkifcop:scanner",2)
				end
			end			
		end

	end
end)

RegisterNetEvent("fire:stopClientFires")
AddEventHandler("fire:stopClientFires", function(x,y,z,rad)
	if #(vector3(x,y,z) - GetEntityCoords(PlayerPedId())) < 100 then
		StopFireInRange(x,y,z,rad)
	end
end)

local lastDamageTrigger = 0

Citizen.CreateThread( function()
	while true do 
		Citizen.Wait(1)
		if IsPedShooting(PlayerPedId()) then
			local name = GetSelectedPedWeapon(PlayerPedId())
        	if name == `WEAPON_FIREEXTINGUISHER` then
        		local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 3.0, 0.0)
        		if GetNumberOfFiresInRange(pos,4.0) > 1 then
        			local rnd = math.random(100)
					if rnd > 40 then
						-- TriggerServerEvent('fire:serverStopFire',pos.x,pos.y,pos.z,4.0) 
					end
        		end


        		if math.random(100) > 40 and GetGameTimer() - lastDamageTrigger >= 2500 then
        			lastDamageTrigger = GetGameTimer()
        			local players, distances, coords = GetClosestPlayers(GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 2.0, 0.0),3.0)
					for k,v in pairs(players) do
						TriggerServerEvent("fire:requestSvrDmg",v)
					end
        		end
        	end
		end
	end
end)


local hasBeenOnFire = 0
local ShouldBeOnFire = 0 
Citizen.CreateThread( function()
	while true do 
		Citizen.Wait(600)
		local player = PlayerPedId()
		local playerPos = GetEntityCoords(player)
		local isInVeh = IsPedInVehicle(player,GetVehiclePedIsIn(player, false),false)
		if not isInVeh then ShouldBeOnFire = 0 end
		if GetNumberOfFiresInRange(playerPos,1.7) > 1 and hasBeenOnFire < 4 then

			local b, closestFire = GetClosestFirePos(playerPos)
			local zDist = math.abs(closestFire.z - playerPos.z)

			if zDist <= 1.0 then
				if isInVeh then
					ShouldBeOnFire = ShouldBeOnFire + 1
					if ShouldBeOnFire >= 7 then
						playerOnFire(player)
					end 
				else
					playerOnFire(player)
				end
			end
		elseif hasBeenOnFire >= 4 then
			ShouldBeOnFire = 0
			hasBeenOnFire = 0
			StopEntityFire(player)
		end
	end
end)

function playerOnFire(player)
	ShouldBeOnFire = 0
	hasBeenOnFire = hasBeenOnFire + 1
	StartEntityFire(player)
	local health = (GetEntityHealth(player) - 25)
	SetEntityHealth(player,health)
end


isDoctor = false
RegisterNetEvent("isDoctor")
AddEventHandler("isDoctor", function()
	TriggerServerEvent("jobssystem:jobs", "doctor")
	isDoctor = true
end)


isTher = false
RegisterNetEvent("isTherapist")
AddEventHandler("isTherapist", function()
	TriggerServerEvent("jobssystem:jobs", "therapist")
	isTher = true
end)

isJudge = false
RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
	TriggerServerEvent("jobssystem:jobs", "judge")
	TriggerServerEvent('police:getRank',"judge")
	isJudge = true
end)

RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
    isJudge = false
end)

RegisterNetEvent("nowIsCop")
AddEventHandler("nowIsCop", function(cb)
	cb(isCop)
end)

RegisterNetEvent('police:noLongerCop')
AddEventHandler('police:noLongerCop', function()
	isCop = false
	isInService = false
	currentCallSign = ""
	
	local playerPed = PlayerPedId()
					
	TriggerServerEvent("myskin_customization:wearSkin")
  	TriggerServerEvent("police:officerOffDuty")
	TriggerServerEvent('tattoos:retrieve')
	TriggerServerEvent('Blemishes:retrieve')
	RemoveAllPedWeapons(playerPed)
	
	TriggerEvent("attachWeapons")
	if(existingVeh ~= nil) then

		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
		existingVeh = nil
	end
end)



RegisterNetEvent('police:checkPhone')
AddEventHandler('police:checkPhone', function()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 5) then
		TriggerServerEvent("phone:getSMSOther",GetPlayerServerId(t))
	else

		TriggerEvent("DoLongHudText", "No player near you!",2)

	end
end)

RegisterNetEvent('police:checkLicenses')
AddEventHandler('police:checkLicenses', function()
	t, distance = GetClosestPlayerIgnoreCar()
	if(distance ~= -1 and distance < 5) then
		TriggerServerEvent("police:getLicenses", GetPlayerServerId(t))
	else

		TriggerEvent("DoLongHudText", "No player near you!",2)

	end
end)

RegisterNetEvent('police:checkLicensePlate')
AddEventHandler('police:checkLicensePlate', function(plate)
	if isCop then
		TriggerServerEvent('checkLicensePlate',plate)
	else
		TriggerEvent("DoLongHudText", "Please take your service first!",2)
	end
end)

RegisterNetEvent('police:checkCrimes')
AddEventHandler('police:checkCrimes', function()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 5) then
		TriggerServerEvent("police:getCrimes", GetPlayerServerId(t))
	else
		TriggerEvent("DoLongHudText", "No player near you!",2)
	end
end)

RegisterNetEvent('police:deletecrimesciv')
AddEventHandler('police:deletecrimesciv', function()
	if(isJudge) then
		t, distance = GetClosestPlayer()
		if(distance ~= -1 and distance < 7) then
			TriggerServerEvent("police:deletecrimes", GetPlayerServerId(t))
		else
			TriggerEvent("DoLongHudText", "No player near you!",2)
		end
	else
		TriggerEvent("DoLongHudText", "Please take your service first!",2)
	end
end)






RegisterNetEvent('police:checkBank')
AddEventHandler('police:checkBank', function()
	t, distance, closestPed = GetClosestPlayer()
	if(distance ~= -1 and distance < 7) then
		TriggerServerEvent("police:targetCheckBank", GetPlayerServerId(t))
	else
		TriggerEvent("DoLongHudText", "No player near you!",2)
	end
end)

RegisterNetEvent('police:checkInventory')
AddEventHandler('police:checkInventory', function(isFrisk)
		if isFrisk == nil then isFrisk = false end
		t, distance, closestPed = GetClosestPlayer()
		if(distance ~= -1 and distance < 5) then
			TriggerServerEvent("police:targetCheckInventory", GetPlayerServerId(t),isFrisk)
		else
			TriggerEvent("DoLongHudText", "No player near you!",2)
		end
end)

RegisterNetEvent("police:rob")
AddEventHandler("police:rob", function()

	
	if not exports["isPed"]:isPed("dead") then
		RequestAnimDict("random@shop_robbery")
		while not HasAnimDictLoaded("random@shop_robbery") do
			Citizen.Wait(0)
		end

		local lPed = PlayerPedId()
		ClearPedTasksImmediately(lPed)

		TaskPlayAnim(lPed, "random@shop_robbery", "robbery_action_b", 8.0, -8, -1, 16, 0, 0, 0, 0)
		local finished = exports["np-taskbar"]:taskBar(3500,"Robbing",false,true)	

		if finished == 100 then
			t, distance, closestPed = GetClosestPlayer()

    if distance ~= -1 and distance < 5 and ( IsEntityPlayingAnim(closestPed, "dead", "dead_a", 3) or IsEntityPlayingAnim(closestPed, "amb@code_human_cower_stand@male@base", "base", 3) or IsEntityPlayingAnim(closestPed, "amb@code_human_cower@male@base", "base", 3) or IsEntityPlayingAnim(closestPed, "random@arrests@busted", "idle_a", 3) or IsEntityPlayingAnim(closestPed, "mp_arresting", "idle", 3) or IsEntityPlayingAnim(closestPed, "random@mugging3", "handsup_standing_base", 3) or IsEntityPlayingAnim(closestPed, "missfbi5ig_22", "hands_up_anxious_scientist", 3) or IsEntityPlayingAnim(closestPed, "missfbi5ig_22", "hands_up_loop_scientist", 3) or IsEntityPlayingAnim(closestPed, "missminuteman_1ig_2", "handsup_base", 3) ) then
				ClearPedTasksImmediately(lPed)
				TriggerServerEvent("police:rob", GetPlayerServerId(t))
				TriggerServerEvent("police:targetCheckInventory", GetPlayerServerId(t), false)
			else
				TriggerEvent("DoLongHudText", "No player near you!",2)
			end
		end
	else
		TriggerEvent("DoLongHudText", "You are dead, you can't rob people you stupid fuck.",2)
	end
end)


RegisterNetEvent("police:seizeCash")
AddEventHandler("police:seizeCash", function()

		t, distance, closestPed = GetClosestPlayer()

		if distance ~= -1 and distance < 5 then
			TriggerServerEvent("police:SeizeCash", GetPlayerServerId(t))
		else
			TriggerEvent("DoLongHudText", "No player near you!",2)
		end

end)

RegisterNetEvent('police:seizeInventory')
AddEventHandler('police:seizeInventory', function()
		t, distance = GetClosestPlayer()
		if(distance ~= -1 and distance < 5) then
			TriggerServerEvent("police:targetseizeInventory", GetPlayerServerId(t))
		else

			TriggerEvent("DoLongHudText", "No player near you!",2)
		end
end)


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 



inanim = false
cancelled = false
RegisterNetEvent( 'KneelHU' )
AddEventHandler( 'KneelHU', function()
    local player = GetPlayerPed( -1 )
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
        loadAnimDict( "random@arrests" )
		loadAnimDict( "random@arrests@busted" )
 			
		TaskPlayAnim( player, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
		local finished = exports["np-taskbar"]:taskBar(2500,"Surrendering")					
		
    
    end
end )







function KneelMedic()
    local player = GetPlayerPed( -1 )
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 

	        loadAnimDict( "amb@medic@standing@tendtodead@enter" )
	        loadAnimDict( "amb@medic@standing@timeofdeath@enter" )
	        loadAnimDict( "amb@medic@standing@tendtodead@idle_a" )
	        loadAnimDict( "random@crash_rescue@help_victim_up" )

			TaskPlayAnim( player, "amb@medic@standing@tendtodead@enter", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (1000)
			TaskPlayAnim( player, "amb@medic@standing@tendtodead@idle_a", "idle_b", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
			Wait (3000)
			TaskPlayAnim( player, "amb@medic@standing@tendtodead@exit", "exit_flee", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (1000)
            TaskPlayAnim( player, "amb@medic@standing@timeofdeath@enter", "enter", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )  
            Wait (500)
            TaskPlayAnim( player, "amb@medic@standing@timeofdeath@enter", "helping_victim_to_feet_player", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )  

    end
end






RegisterNetEvent('revive')
AddEventHandler('revive', function(t)

	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 10) then
		TriggerServerEvent("reviveGranted", GetPlayerServerId(t))
		KneelMedic()
		TriggerServerEvent("take100",GetPlayerServerId(t))
		TriggerServerEvent("job:Pay", "Player Revival", 100)
	else
		TriggerEvent("DoLongHudText", "No player near you (maybe get closer)!",2)
	end

end)

RegisterNetEvent('gangunitloadout')
AddEventHandler('gangunitloadout', function()
    ChangeToSkinNoUpdatePolice("s_m_m_ciasec_01")
	TriggerEvent('policegear');
end)

RegisterNetEvent('SNOWmalecopLoadout')
AddEventHandler('SNOWmalecopLoadout', function()
    ChangeToSkinNoUpdatePolice("s_m_m_snowcop_01")
	TriggerEvent('policegear');
end)

RegisterNetEvent('malecopLoadout')
AddEventHandler('malecopLoadout', function()
	ChangeToSkinNoUpdatePolice("s_m_y_cop_01")

	TriggerEvent('policegear');
end)

RegisterNetEvent('femalesheriffLoadout')
AddEventHandler('femalesheriffLoadout', function()
    ChangeToSkinNoUpdatePolice("s_f_y_sheriff_01")
	TriggerEvent('policegear');
end)

RegisterNetEvent('malehighwaycopLoadout')
AddEventHandler('malehighwaycopLoadout', function()
    ChangeToSkinNoUpdatePolice("s_m_y_hwaycop_01")
	TriggerEvent('policegear');
end)

RegisterNetEvent('malerangerLoadout')
AddEventHandler('malerangerLoadout', function()
    ChangeToSkinNoUpdatePolice("s_m_y_ranger_01")
	TriggerEvent('policegear');
end)

RegisterNetEvent('malesheriffLoadout')
AddEventHandler('malesheriffLoadout', function()
    ChangeToSkinNoUpdatePolice("s_m_y_sheriff_01")
	TriggerEvent('policegear');
end)

RegisterNetEvent('maleswatLoadout')
AddEventHandler('maleswatLoadout', function()
    ChangeToSkinNoUpdatePolice("s_m_y_swat_01")
	TriggerEvent('policegear');
end)

function VehicleInFront()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 3.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

RegisterNetEvent('police:wshotgun')
AddEventHandler('police:wshotgun', function()
	local targetVehicle = VehicleInFront()
    playerped = PlayerPedId()
    Citizen.Trace("?sg")
    if targetVehicle ~= 0 then
    	Citizen.Trace("?sg2")
        local d1,d2 = GetModelDimensions(GetEntityModel(targetVehicle))
        local moveto = GetOffsetFromEntityInWorldCoords(targetVehicle, d1["x"]-0.25,0.25,0.0)
        local dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
        local count = 1000

        while dist > 1.0 and count > 0 do
            dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
            Citizen.Wait(1)
            count = count - 1
            DrawText3DVehicle(moveto["x"],moveto["y"],moveto["z"],"Move here to unrack.")
        end
        Citizen.Trace("?sg3")
        if dist < 1.0 then
        	Citizen.Trace("?sg4")
        	TaskTurnPedToFaceEntity(PlayerPedId(), targetVehicle, 1.0)
			SetVehicleDoorOpen(targetVehicle, 0, 1, 1)
	  		loadAnimDict('anim@narcotics@trash')
			TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1900, 49, 3.0, 0, 0, 0)		
			local finished = exports["np-taskbar"]:taskBar(2000,"Unracking Shotgun")
		  	if finished == 100 then
				TriggerServerEvent("actionclose", GetPlayerServerId(PlayerId()), "Shotgun", GetPlayerServerId(PlayerId()))
				TriggerEvent("GiveWeaponToPed", `WEAPON_PUMPSHOTGUN`, "PD Shotgun")
				TriggerEvent("attachWeapons")
			end
			SetVehicleDoorShut(targetVehicle, 0, 1, 1)	
		end
		ClearPedTasks(PlayerPedId())
	end
end)

RegisterNetEvent('police:wrifle')
AddEventHandler('police:wrifle', function()
	local targetVehicle = VehicleInFront()
    playerped = PlayerPedId()

    if targetVehicle ~= 0 then

        local d1,d2 = GetModelDimensions(GetEntityModel(targetVehicle))
        local moveto = GetOffsetFromEntityInWorldCoords(targetVehicle, d1["x"]-0.25,0.25,0.0)
        local dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
        local count = 1000

        while dist > 1.0 and count > 0 do
            dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
            Citizen.Wait(1)
            count = count - 1
            DrawText3DVehicle(moveto["x"],moveto["y"],moveto["z"],"Move here to unrack.")
        end

        if dist < 1.0 then
        	TaskTurnPedToFaceEntity(PlayerPedId(), targetVehicle, 1.0)
			SetVehicleDoorOpen(targetVehicle, 0, 1, 1)
	  		loadAnimDict('anim@narcotics@trash')
			TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1900, 49, 3.0, 0, 0, 0)
			local finished = exports["np-taskbar"]:taskBar(2000,"Unracking Rifle")
		  	if finished == 100 then
				TriggerServerEvent("actionclose", GetPlayerServerId(PlayerId()), "Carbine Rifle", GetPlayerServerId(PlayerId()))
				TriggerEvent("GiveWeaponToPed", `WEAPON_CARBINERIFLE`, "PD Carbine")
				TriggerEvent("attachWeapons")
			end
			SetVehicleDoorShut(targetVehicle, 0, 1, 1)
		end
		ClearPedTasks(PlayerPedId())
	end
end)

RegisterNetEvent('police:woxy')
AddEventHandler('police:woxy', function()
	local vehFront = VehicleInFront()
	if vehFront > 0 then
  		loadAnimDict('anim@narcotics@trash')
		TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 3800, 49, 3.0, 0, 0, 0)		
		local finished = exports["np-taskbar"]:taskBar(4000,"Grabbing Scuba Gear")
	  	if finished == 100 then
	  		loadAnimDict('anim@narcotics@trash')
    		TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1900, 49, 3.0, 0, 0, 0)	  		
			TriggerEvent("UseOxygenTank")
		end
	end
end)

AddEventHandler('giveRadioToPed', function()
	-- If player doesn't already have a radio (item 67) and has enough inventory room for one, give them the item
	if (not exports["np-inventory"]:hasEnoughOfItem("radio",1,false) ) then
		TriggerEvent("player:receiveItem","radio",1)
	end
end)



AddEventHandler('policegear', function()

	TriggerEvent('nowCopHud');
	TriggerEvent('nowCopDeath')
	TriggerEvent('nowCopSpawn')
	TriggerEvent('giveRadioToPed')

end)

RegisterNetEvent('emsGear')
AddEventHandler('emsGear', function(arg)
	TriggerEvent('giveRadioToPed')
end)

RegisterNetEvent('girlcopLoadout')
AddEventHandler('girlcopLoadout', function()
	ChangeToSkinNoUpdatePolice("s_f_y_cop_02C")
	TriggerEvent('policegear');
end)

RegisterNetEvent('swatcopLoadout')
AddEventHandler('swatcopLoadout', function()
	
    playerped = PlayerPedId()
    targetVehicle = VehicleInFront()

    if targetVehicle ~= 0 then

        local d1,d2 = GetModelDimensions(GetEntityModel(targetVehicle))
        local moveto = GetOffsetFromEntityInWorldCoords(targetVehicle, 0.0,d1["y"]-0.5,0.0)
        local dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
        local count = 1000

        while dist > 1.0 and count > 0 do
            dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
            Citizen.Wait(1)
            count = count - 1
            DrawText3DVehicle(moveto["x"],moveto["y"],moveto["z"],"Move here to equip Shield.")
        end

        if dist < 1.0 then
        	TaskTurnPedToFaceEntity(PlayerPedId(), targetVehicle, 1.0)
			SetVehicleDoorOpen(targetVehicle, 5, 1, 1)
	  		loadAnimDict("oddjobs@basejump@ig_15")
			TaskPlayAnim(PlayerPedId(),"oddjobs@basejump@ig_15", 'puton_parachute',0.9, -8, 2.5, 49, 3.0, 0, 0, 0)
			local finished = exports["np-taskbar"]:taskBar(2500,"Changing to Swat")
	  		if finished == 100 then
				ChangeToSkinNoUpdatePolice("s_m_y_swat_01")		
			end
			ClearPedTasks(PlayerPedId())
			SetVehicleDoorShut(targetVehicle, 5, 1, 1)	
		end
	end
end)

frozenEnabled = false
FreezeEntityPosition(PlayerPedId(), false)
RegisterNetEvent('police:freeze')
AddEventHandler('police:freeze', function(ped)
	if(isCop) then
		ped, distance = GetClosestPlayer()
		if(distance ~= -1 and distance < 5) then
	      	if frozenEnabled then
				FreezeEntityPosition(ped, false)
				SetPlayerInvincible(ped, false)
				SetEntityCollision(ped, true)
				TriggerEvent("DoLongHudText", "Target Unshackled!",1)
				frozenEnabled = false
	      	else 
				SetEntityCollision(ped, false)
				FreezeEntityPosition(ped, true)
				SetPlayerInvincible(ped, true)
				frozenEnabled = true
				TriggerEvent("DoLongHudText", "Target Shackled!",1)
	      	end
	    end
	else
		TriggerEvent("DoLongHudText", "Please take your service first!",2)
	end
end)

function isOppositeDir(a,b)
	local result = 0 
	if a < 90 then
		a = 360 + a
	end
	if b < 90 then
		b = 360 + b
	end	
	if a > b then
		result = a - b
	else
		result = b - a
	end
	if result > 110 then
		return true
	else
		return false
	end
end

RegisterNetEvent('police:remmaskAccepted')
AddEventHandler('police:remmaskAccepted', function()
	TriggerEvent("facewear:adjust", 1, true)
	TriggerEvent("facewear:adjust", 3, true)
	TriggerEvent("facewear:adjust", 4, true)
	--TriggerEvent("facewear:adjust", 5, true)
	TriggerEvent("facewear:adjust", 2, true)
end)





RegisterNetEvent('police:remmask')
AddEventHandler('police:remmask', function(t)
	t, distance = GetClosestPlayer()
	if (distance ~= -1 and distance < 5) then
		if isOppositeDir(GetEntityHeading(t),GetEntityHeading(PlayerPedId())) and not IsPedInVehicle(t,GetVehiclePedIsIn(t, false),false) then
			TriggerServerEvent("police:remmaskGranted", GetPlayerServerId(t))
			AnimSet = "mp_missheist_ornatebank"
			AnimationOn = "stand_cash_in_bag_intro"
			AnimationOff = "stand_cash_in_bag_intro"
			loadAnimDict( AnimSet )
			TaskPlayAnim( PlayerPedId(), AnimSet, AnimationOn, 8.0, -8, -1, 49, 0, 0, 0, 0 )
			Citizen.Wait(500)
			ClearPedTasks(PlayerPedId())						
		end
	else
		TriggerEvent("DoLongHudText", "No player near you (maybe get closer)!",2)
	end
end)

RegisterNetEvent('police:remweapons')
AddEventHandler('police:remweapons', function(t)
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 5) then
		TriggerServerEvent("police:remweaponsGranted", GetPlayerServerId(t))
	else
		TriggerEvent("DoLongHudText", "No player near you (maybe get closer)!",2)
	end
end)

tryingcuff = false
RegisterNetEvent('police:cuff2')
AddEventHandler('police:cuff2', function(t,softcuff)
	if not tryingcuff then

		
		tryingcuff = true

		t, distance, ped = GetClosestPlayer()

		Citizen.Wait(1500)
		if(distance ~= -1 and #(GetEntityCoords(ped) - GetEntityCoords(PlayerPedId())) < 2.5 and GetEntitySpeed(ped) < 1.0) then
			TriggerEvent('police:cuff2')
			TriggerServerEvent("police:cuffGranted2", GetPlayerServerId(t), softcuff)
		else
			ClearPedSecondaryTask(PlayerPedId())
			TriggerEvent("DoLongHudText", "No player near you (maybe get closer)!",2)
		end

		tryingcuff = false

	end
end)

RegisterNetEvent('police:cuff')
AddEventHandler('police:cuff', function(t)
	if not tryingcuff then



		TriggerEvent("Police:ArrestingAnim")
		tryingcuff = true

		t, distance = GetClosestPlayer()
		if(distance ~= -1 and distance < 1.5) then
			TriggerServerEvent("police:cuffGranted", GetPlayerServerId(t))
		else
			TriggerEvent("DoLongHudText", "No player near you (maybe get closer)!",2)
		end


		tryingcuff = false
	end
end)

local cuffstate = false


RegisterNetEvent('civ:cuffFromMenu')
AddEventHandler('civ:cuffFromMenu', function()
	TriggerEvent("police:cuffFromMenu",false)
end)

RegisterNetEvent('police:cuffFromMenu')
AddEventHandler('police:cuffFromMenu', function(softcuff)
	if not cuffstate and not handCuffed and not IsPedRagdoll(PlayerPedId()) and not IsPlayerFreeAiming(PlayerId()) and not IsPedInAnyVehicle(PlayerPedId(), false) then
		cuffstate = true

		t, distance = GetClosestPlayer()
		if(distance ~= -1 and distance < 2 and not IsPedRagdoll(PlayerPedId())) then
			if softcuff then
				TriggerEvent("DoLongHudText", "You soft cuffed a player!",1)
			else
				TriggerEvent("DoLongHudText", "You hard cuffed a player!",1)
			end
			
			TriggerEvent("police:cuff2", GetPlayerServerId(t),softcuff)
		end

		cuffstate = false
	end
end)

RegisterNetEvent('police:gsr')
AddEventHandler('police:gsr', function(t)
	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, 1)
	local finished = exports["np-taskbar"]:taskBar(15000,"GSR Testing")
    if finished == 100 then
		t, distance = GetClosestPlayer()
		if(distance ~= -1 and distance < 7) then
			TriggerServerEvent("police:gsrGranted", GetPlayerServerId(t))
		end
	end
end)

local shotRecently = false

Citizen.CreateThread(function()
	local lastShot = 0
	
	while true do
		Citizen.Wait(1)

		if IsPedShooting(PlayerPedId()) then
			local name = GetSelectedPedWeapon(PlayerPedId())
			if name ~= `WEAPON_STUNGUN` then
				lastShot = GetGameTimer()
				shotRecently = true
			end
		end

		if shotRecently and GetGameTimer() - lastShot >= 1200000 then shotRecently = false end 
	end
end)

RegisterNetEvent("police:hasShotRecently")
AddEventHandler("police:hasShotRecently", function(copId)
	TriggerServerEvent("police:hasShotRecently", shotRecently, copId)
end)

RegisterNetEvent('police:uncuffMenu')
AddEventHandler('police:uncuffMenu', function()
	t, distance = GetClosestPlayer()
	-- error debug fix - syd
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		if(distance ~= -1 and distance < 2) then
			print('uncuff event')
			TriggerServerEvent("falseCuffs", GetPlayerServerId(t))
			TriggerEvent("DoLongHudText", "You uncuffed a player!",1)
		else
			TriggerEvent("DoLongHudText", "No player near you (maybe get closer)!",2)
		end
	end
end)

-- hopefully resolve the death / revive restrain bug.

RegisterNetEvent('resetCuffs')
AddEventHandler('resetCuffs', function()
	ClearPedTasksImmediately(PlayerPedId())
	handcuffType = 49
	handCuffed = false
	handCuffedWalking = false
	TriggerEvent("police:currentHandCuffedState",handCuffed,handCuffedWalking)
	--TriggerEvent("DensityModifierEnable",true)
	TriggerEvent("handcuffed",false)
end)

RegisterNetEvent('falseCuffs')
AddEventHandler('falseCuffs', function()
	ClearPedTasksImmediately(PlayerPedId())
	handcuffType = 49
	handCuffed = false
	handCuffedWalking = false
	TriggerEvent("police:currentHandCuffedState",handCuffed,handCuffedWalking)
	--TriggerEvent("DensityModifierEnable",true)
	TriggerEvent("handcuffed",false)
end)





RegisterNetEvent('police:getArrested2')
AddEventHandler('police:getArrested2', function(cuffer)

	ClearPedTasksImmediately(PlayerPedId())
	CuffAnimation(cuffer)
	
	local cuffPed = GetPlayerPed(GetPlayerFromServerId(tonumber(cuffer)))

	local finished = 0
	if not isDead then
		finished = exports["np-taskbarskill"]:taskBar(1200,7)
	end
	
	if #(GetEntityCoords( PlayerPedId()) - GetEntityCoords(cuffPed)) < 2.5 and finished ~= 100 then
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'handcuff', 0.4)
		handcuffType = 16
		handCuffed = true
		handCuffedWalking = false
		TriggerEvent("police:currentHandCuffedState",handCuffed,handCuffedWalking)
		TriggerEvent("DoLongHudText", "Cuffed!",1)
		TriggerEvent("handcuffed",true)
		TriggerEvent("DensityModifierEnable",false)	
	end	

end)

function CuffAnimation(cuffer)
	loadAnimDict("mp_arrest_paired")
	local cuffer = GetPlayerPed(GetPlayerFromServerId(tonumber(cuffer)))
	local dir = GetEntityHeading(cuffer)
	--TriggerEvent('police:cuffAttach',cuffer)
	SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))
	Citizen.Wait(100)
	SetEntityHeading(PlayerPedId(),dir)
	TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 8.0, -8, -1, 32, 0, 0, 0, 0)
end

RegisterNetEvent('police:cuffAttach')
AddEventHandler('police:cuffAttach', function(cuffer)
	local count = 350
	while count > 0 do
		Citizen.Wait(1)
		count = count - 1
		AttachEntityToEntity(PlayerPedId(), cuffer, 11816, 0.0, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	end
	DetachEntity(PlayerPedId(), true, false)	
end)

RegisterNetEvent('police:cuffTransition')
AddEventHandler('police:cuffTransition', function()
	loadAnimDict("mp_arrest_paired")
	Citizen.Wait(100)
	TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "cop_p2_back_right", 8.0, -8, -1, 48, 0, 0, 0, 0)
	Citizen.Wait(3500)
	ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNetEvent('police:getArrested')
AddEventHandler('police:getArrested', function(cuffer)

		if(handCuffed) then
			Citizen.Wait(3500)
			ClearPedTasksImmediately(PlayerPedId())
			handCuffed = false
			handcuffType = 49
			TriggerEvent("police:currentHandCuffedState",handCuffed,handCuffedWalking)
			TriggerEvent("handcuffed",true)
			TriggerEvent("DensityModifierEnable",true)
		else
			ClearPedTasksImmediately(PlayerPedId())
			CuffAnimation(cuffer) 

			local cuffPed = GetPlayerPed(GetPlayerFromServerId(tonumber(cuffer)))
			if Vdist2( GetEntityCoords( GetPlayerPed(-1) , GetEntityCoords(cuffPed) ) ) < 1.5 then
				handcuffType = 49
				handCuffed = true
				TriggerEvent("police:currentHandCuffedState",handCuffed,handCuffedWalking)
				TriggerEvent("handcuffed",false)
				TriggerEvent("DensityModifierEnable",false)
			end
		end
end)


RegisterNetEvent('police:jailing')
AddEventHandler('police:jailing', function(args)
	Citizen.Trace("Jailing in process.")
	TriggerServerEvent('police:jailGranted', args )
	TriggerServerEvent('updateJailTime', tonumber(args[2]))
end)

RegisterNetEvent('police:payFines')
AddEventHandler('police:payFines', function(amount)
	TriggerServerEvent('bank:withdrawAmende', amount)

	TriggerEvent('chatMessage', "BILL ", {255, 140, 0}, "You were billed for ^2" .. tonumber(amount) .. " ^0dollar(s).")


end)


RegisterNetEvent('startJail')
AddEventHandler('startJail', function(minutes)
	TriggerServerEvent('updateJailTime', tonumber(minutes))
end)

RegisterNetEvent('police:forceEnter')
AddEventHandler('police:forceEnter', function(id)

	ped, distance, t = GetClosestPedIgnoreCar()
	if(distance ~= -1 and distance < 3) then

		local isInVeh = IsPedInAnyVehicle(ped, true)
		if not isInVeh then
			playerped = PlayerPedId()
	        coordA = GetEntityCoords(playerped, 1)
	        coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
	        v = getVehicleInDirection(coordA, coordB)
	        if GetVehicleEngineHealth(v) < 100.0 then
	        	TriggerEvent("DoLongHudText", "That vehicle is too damaged!",2)
	        	return
	        end
			local netid = NetworkGetNetworkIdFromEntity(v)	
			TriggerEvent('forcedEnteringVeh', GetPlayerServerId(t))
			TriggerServerEvent("police:forceEnterAsk", GetPlayerServerId(t), netid)
			TriggerEvent("dr:releaseEscort")
		else
			TriggerEvent("unseatPlayer")
		end

	else
		TriggerEvent("DoLongHudText", "No player near you (maybe get closer)!",2)
	end
end)


RegisterNetEvent('police:forcedEnteringVeh')
AddEventHandler('police:forcedEnteringVeh', function(sender)

	local vehicleHandle = NetworkGetEntityFromNetworkId(sender)
    if vehicleHandle ~= nil then
        Citizen.Trace("22")
      if IsEntityAVehicle(vehicleHandle) then
      	TriggerEvent("respawn:sleepanims")
      	Citizen.Wait(1000)
        for i=1,GetVehicleMaxNumberOfPassengers(vehicleHandle) do
            Citizen.Trace("33")
          if IsVehicleSeatFree(vehicleHandle,i) then
		 	TriggerEvent("unEscortPlayer")
			Citizen.Wait(100)
            SetPedIntoVehicle(PlayerPedId(),vehicleHandle,i)
            
            Citizen.Trace("whatsasdsass")
            return true
          end
        end
	    if IsVehicleSeatFree(vehicleHandle,0) then
	    	TriggerEvent("unEscortPlayer") 
			Citizen.Wait(100)
	        SetPedIntoVehicle(PlayerPedId(),vehicleHandle,0)
	        
	    end
      end
    end
end)

RegisterNetEvent('police:tenThirteenA')
AddEventHandler('police:tenThirteenA', function()
	if(isCop) then
		local pos = GetEntityCoords(PlayerPedId(),  true)
		TriggerServerEvent("dispatch:svNotify", {
			dispatchCode = "10-13A",
			firstStreet = GetStreetAndZone(),
			callSign = currentCallSign,
			cid = exports["isPed"]:isPed("cid"),
			origin = {
				x = pos.x,
				y = pos.y,
				z = pos.z
			  }
		})
	end
end)

RegisterNetEvent('police:tenThirteenB')
AddEventHandler('police:tenThirteenB', function()
	if(isCop) then
		local pos = GetEntityCoords(PlayerPedId(),  true)
		TriggerServerEvent("dispatch:svNotify", {
			dispatchCode = "10-13B",
			firstStreet = GetStreetAndZone(),
			callSign = currentCallSign,
			cid = exports["isPed"]:isPed("cid"),
			origin = {
				x = pos.x,
				y = pos.y,
				z = pos.z
			}
		})
	end
end)

RegisterNetEvent("police:tenForteenA")
AddEventHandler("police:tenForteenA", function()	
	local pos = GetEntityCoords(PlayerPedId(),  true)
	TriggerServerEvent("dispatch:svNotify", {
		dispatchCode = "10-14A",
		firstStreet = GetStreetAndZone(),
		callSign = currentCallSign,
		cid = exports["isPed"]:isPed("cid"),
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z
		}
	})
end)

RegisterNetEvent("police:tenForteenB")
AddEventHandler("police:tenForteenB", function()	
	local pos = GetEntityCoords(PlayerPedId(),  true)
	TriggerServerEvent("dispatch:svNotify", {
		dispatchCode = "10-14B",
		firstStreet = GetStreetAndZone(),
		callSign = currentCallSign,
		cid = exports["isPed"]:isPed("cid"),
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z
		}
	})
end)

RegisterNetEvent("police:setCallSign")
AddEventHandler("police:setCallSign", function(pCallSign)
	if pCallSign ~= nil then currentCallSign = pCallSign end
	TriggerEvent('DoLongHudText', "Set Callsign, ".. currentCallSign..".", 1)
end)

function GetStreetAndZone()
    local plyPos = GetEntityCoords(PlayerPedId(),  true)
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    zone = tostring(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
    local playerStreetsLocation = GetLabelText(zone)
    local street = street1 .. ", " .. playerStreetsLocation
    return street
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

function GetClosestPlayers(targetVector,dist)
	local players = GetPlayers()
	local ply = PlayerPedId()
	local plyCoords = targetVector
	local closestplayers = {}
	local closestdistance = {}
	local closestcoords = {}

	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(distance < dist) then
				valueID = GetPlayerServerId(value)
				closestplayers[#closestplayers+1]= valueID
				closestdistance[#closestdistance+1]= distance
				closestcoords[#closestcoords+1]= {targetCoords["x"], targetCoords["y"], targetCoords["z"]}
				
			end
		end
	end
	return closestplayers, closestdistance, closestcoords
end

function GetClosestPlayerVehicleToo()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		for index,value in ipairs(players) do
			local target = GetPlayerPed(value)
			if(target ~= ply) then
				local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
				local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
				if(closestDistance == -1 or closestDistance > distance) then
					closestPlayer = value
					closestDistance = distance
				end
			end
		end
		return closestPlayer, closestDistance
	else
		TriggerEvent("DoShortHudText","Inside Vehicle.",2)
	end
end

function GetClosestPlayerAny()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)


	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance



end


function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local closestPed = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then

		for index,value in ipairs(players) do
			local target = GetPlayerPed(value)
			if(target ~= ply) then
				local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
				local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
				if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
					closestPlayer = value
					closestPed = target
					closestDistance = distance
				end
			end
		end
		
		return closestPlayer, closestDistance, closestPed

	else
		TriggerEvent("DoShortHudText","Inside Vehicle.",2)
	end

end
function GetClosestPedIgnoreCar()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local closestPlayerId = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = target
				closestPlayerId = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance, closestPlayerId
end
function GetClosestPlayerIgnoreCar()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end


function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(600000)
		if isJudge and exports["isPed"]:isPed("myjob") == "judge" then
			TriggerServerEvent("server:givepayJob", "Judge Payment", 100)
		end

		if isDoctor and exports["isPed"]:isPed("myjob") == "doctor" then
			TriggerServerEvent("server:givepayJob", "Doctor Payment", 150)
		end

		if isTher and exports["isPed"]:isPed("myjob") == "therapist" then
			TriggerServerEvent("server:givepayJob", "Therapist Payment", 125)
		end
	end
end)





local judgetakingService = {
	{ x=457.666809082031, y=-991.062133789063, z=31.6896057128906 },
	{ x=824.968566894531, y=-1290.16088867188, z=29.2406558990479 },
	{ x=1853.36462402344, y=3687.23071289063, z=35.2670822143555 },
	{ x=-446.271209716797, y=6014.38037109375, z=32.7163963317871 },
	{ x=322.99322509766, y=-1586.8887939453, z=-62.021293640137 },
	{ x=-1008.2123413086, y=-475.31707763672, z=50.027187347412 }
}

function isNearTakeService()
	for i = 1, #takingService do
		local ply = PlayerPedId()
		local plyCoords = GetEntityCoords(ply, 0)
		local distance = #(vector3(takingService[i].x, takingService[i].y, takingService[i].z) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
		if(distance < 30.0) then
			DrawMarker(27, takingService[i].x, takingService[i].y, takingService[i].z-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.5, 0, 0, 255, 155, 0, 0, 2, 0, 0, 0, 0)
		end
		if(distance < 3.0) then
			return true
		end
	end
end

function ShowRadarMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

handCuffedWalking = false
RegisterNetEvent('handCuffedWalking')
AddEventHandler('handCuffedWalking', function()

	if handCuffedWalking then
		handCuffedWalking = false
		TriggerEvent("handcuffed",false)
		TriggerEvent("animation:PlayAnimation","cancel")
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'handcuff', 0.4)
		TriggerEvent("police:currentHandCuffedState",false,false)
		return
	end
	
	handCuffedWalking = true
	handCuffed = false
	TriggerEvent("handcuffed",true)

	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'handcuff', 0.4)

	TriggerEvent("police:currentHandCuffedState",handCuffed,handCuffedWalking)

end)

handcuffs = 0
function alterHandcuffs(cuffMode)
	local factor = cuffMode
	if cuffMode then
		local hcmodel = "prop_cs_cuffs_01"
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local handcuffs = CreateObject(GetHashKey(hcmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
		AttachEntityToEntity(handcuffs, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.0, 0.05, 0.0, 0.0, 0.0, 80.0, 1, 0, 0, 0, 0, 1)
	else
		DeleteEntity(handcuffs)
		handcuffs = 0
	end
end


function DrawText3DTest(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

local notified = false
local disabledWeapons = false
RegisterNetEvent("disabledWeapons")
AddEventHandler("disabledWeapons", function(sentinfo)
	SetCurrentPedWeapon(PlayerPedId(), `weapon_unarmed`, 1)
	disabledWeapons = sentinfo
end)

RegisterNetEvent("weaponcheck:scanner")
AddEventHandler("weaponcheck:scanner", function()
	if not disabledWeapons then
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'metaldetected', 0.2)
	end	
end)
Citizen.CreateThread( function()
	while true do 
		Citizen.Wait(1)
		endDistance5 = #(vector3(2136.6552734375,2922.3020019531,-61.901927947998) - GetEntityCoords(PlayerPedId()))
		if endDistance5 < 5.0 then
			if not disabledWeapons then
				DrawText3DTest(2136.6552734375,2922.3020019531,-61.901927947998,"Press [E] to drop all your items here.")
			else
				DrawText3DTest(2136.6552734375,2922.3020019531,-61.901927947998,"Press [E] to pick up your items.")
			end			
		end
		if endDistance5 < 2.0 then
			if IsControlJustReleased(0,38) then
				if not disabledWeapons then
					TriggerEvent("disabledWeapons",true)
				else
					TriggerEvent("disabledWeapons",false)
				end
				
			end
		end
	end
end)

RegisterNetEvent("checkifcop:scanner")
AddEventHandler("checkifcop:scanner", function(notificationNumber)

	if scansuccess or isJudge or isCop or isMedic or handCuffed or handCuffedWalking or escort or beingDragged or disabledWeapons then
		return
	end

	if notificationNumber == 2 then
		TriggerEvent('gangs:setHatredFull')
		Citizen.Wait(20000)
		return
	end

	if notified then
		return
	end
	notified = true
	TriggerEvent("DoLongHudText",'You must drop off your weapons and be scanned - stop or be shot!',2) 
	Citizen.Wait(10000)
	notified = false

end)



Citizen.CreateThread(function() 

  while true do

	Citizen.Wait(1)
	

    if disabledWeapons then
		DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
		DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
    end

    if beingDragged or escort then
		DisableControlAction(1, 23, true)  -- F
		DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
		DisableControlAction(1, 140, true) --Disables Melee Actions
		DisableControlAction(1, 141, true) --Disables Melee Actions
		DisableControlAction(1, 142, true) --Disables Melee Actions	
		DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
		DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
		DisableControlAction(2, 32, true)
		DisableControlAction(1, 33, true)
		DisableControlAction(1, 34, true)
		DisableControlAction(1, 35, true)
		DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
		DisableControlAction(0, 59)
		DisableControlAction(0, 60)
		DisableControlAction(2, 31, true) 
		SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
    end

    if handCuffedWalking or handCuffed then
    	
    	if handCuffed and CanPedRagdoll(PlayerPedId()) then
    		SetPedCanRagdoll(PlayerPedId(), false)
    	end

    	number = 49

    	if handCuffed then 
    		number = 16
		else 
			number = 49
		end

		DisableControlAction(1, 23, true)  -- F
		DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
		DisableControlAction(1, 140, true) --Disables Melee Actions
		DisableControlAction(1, 141, true) --Disables Melee Actions
		DisableControlAction(1, 142, true) --Disables Melee Actions	
		DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
		DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
		local dead = exports["isPed"]:isPed("dead")
		local intrunk = exports["isPed"]:isPed("intrunk")
		if (not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) and not dead and not intrunk) or (IsPedRagdoll(PlayerPedId()) and not dead and not intrunk) then
	    	RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded("mp_arresting") do
				Citizen.Wait(1)
			end
			TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, number, 0, 0, 0, 0)
		end
		if dead or intrunk then
			Citizen.Wait(1000)
		end

    end

	if not handCuffed and not CanPedRagdoll(PlayerPedId()) then
		SetPedCanRagdoll(PlayerPedId(), true)
	end

  end

end)











function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end





 
RegisterNetEvent( 'Police:Radio' )
AddEventHandler( 'Police:Radio', function()
	if isCop then

		local ped = GetPlayerPed( -1 )

	    if ( DoesEntityExist( ped ) and not IsEntityDead( ped )) and imdead ~= 1 then

	   		local curw = GetSelectedPedWeapon(PlayerPedId())
			noweapon = `WEAPON_UNARMED`
			if noweapon == curw then
		    	--if GetPedConfigFlag(ped, 78, 1) then
		    	--	thisanim = "radio_chatter"
		    	--else
		    		thisanim = "generic_radio_enter"	
		    	--end

		        loadAnimDict( "random@arrests" )
		        if ( IsEntityPlayingAnim( ped, "random@arrests", "radio_chatter", 3 ) or IsEntityPlayingAnim( ped, "random@arrests", "generic_radio_enter", 3 ) ) then
						ClearPedSecondaryTask(ped)

						SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
		        else
						-- TaskPlayAnim(ped, "random@arrests", thisanim, 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )

						SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
		        end  
		          
		    end

	    end

	end

end)








intmenuopen = false
handcuffType = 16


local isTargetCuffed = false

function cuffCheck()
	if not handCuffed and not IsPedRagdoll(PlayerPedId()) and not IsPlayerFreeAiming(PlayerId()) and not IsPedInAnyVehicle(PlayerPedId(), false) then
		t, distance = GetClosestPlayer()
		if(distance ~= -1 and distance < 3 and not IsPedRagdoll(PlayerPedId())) then
			TriggerServerEvent("police:IsTargetCuffed", GetPlayerServerId(t)) 
		end
	end
end

RegisterNetEvent('police:isPlayerCuffed')
AddEventHandler('police:isPlayerCuffed', function(requestedID)
	TriggerServerEvent("police:confirmIsCuffed",requestedID,handCuffed)
end)


RegisterNetEvent('police:TargetIsCuffed')
AddEventHandler('police:TargetIsCuffed', function(result)
	isTargetCuffed = result
	if isTargetCuffed then
		TriggerEvent("openSubMenu","handcuffer")
	else
		TriggerEvent("police:cuffFromMenu")
	end
	isTargetCuffed = false
end)

RegisterNetEvent('police:AttemptCuffFromInventory')
AddEventHandler('police:AttemptCuffFromInventory', function()
	cuffCheck()
end)


local inmenus = false
RegisterNetEvent('inmenu')
AddEventHandler('inmenu', function(change)
	inmenus = change
end)


Citizen.CreateThread(function()
 	while true do
    Citizen.Wait(10)

  	-- Run cuff script if police is targeting someone with a weapon and pressed E

		if isCop and not inmenus then

			local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)

			if isInVeh then

				if IsControlJustReleased(0,172) or IsDisabledControlJustReleased(0,172) then
					TriggerEvent("platecheck:frontradar")
					Citizen.Wait(400)
				end

				if IsControlJustReleased(0,173) then
					TriggerEvent("platecheck:rearradar")
					Citizen.Wait(400)
				end

				if IsControlJustReleased(0,174) then
					TriggerEvent("startSpeedo")
					Citizen.Wait(400)
				end
																			
			else

				if IsControlJustReleased(2,172) and not IsControlPressed(0,19) then
					TriggerEvent("police:cuffFromMenu",false)
					Citizen.Wait(400)
				end

				if IsControlJustReleased(2,172) and IsControlPressed(0,19) then
					TriggerEvent("police:cuffFromMenu",true)
					Citizen.Wait(400)
				end

				if IsControlJustReleased(2,173) then
					TriggerEvent("police:uncuffMenu")
					Citizen.Wait(400)
				end
				-- left arrow
				if IsControlJustReleased(2,174) then
					TriggerEvent("escortPlayer")
					Citizen.Wait(400)
				end
				-- right arrow
				if IsControlJustReleased(2,175) then
					TriggerEvent("police:forceEnter")
					Citizen.Wait(400)
				end

			-- end

		end
		if isMedic and not inmenus then
			-- up arrow
			if IsControlJustReleased(2,172) then
				TriggerEvent("revive")
				Citizen.Wait(400)
			end
			-- down arrow
			if IsControlJustReleased(2,173) then
				TriggerEvent("ems:heal")
				Citizen.Wait(400)
			end
			-- left arrow
			if IsControlJustReleased(2,174) then
				TriggerEvent("escortPlayer")
				Citizen.Wait(400)
			end
			-- right arrow
			if IsControlJustReleased(2,175) then
				TriggerEvent("police:forceEnter")
				Citizen.Wait(400)
			end
		end
		if isDoctor and not inmenus then
			-- left arrow
			if IsControlJustReleased(2,174) then
				TriggerEvent("escortPlayer")
				Citizen.Wait(400)
			end
			-- up arrow
			if IsControlJustReleased(2,172) then
				TriggerEvent("ems:heal")
				Citizen.Wait(400)
			end
			-- down arrow
			if IsControlJustReleased(2,173) then
				TriggerEvent("revive")
				Citizen.Wait(400)
			end
			-- right arrow
			if IsControlJustReleased(2,175) then
				TriggerEvent("requestWounds")
				Citizen.Wait(400)
			end
		end
	end
end

end)


gangNum = 0
GangMember = false
RegisterNetEvent('enablegangmember')
AddEventHandler('enablegangmember', function(gangNumInput)
	gangNum = gangNumInput
	if gangNumInput == 1 then
		GangMember = true
	elseif gangNumInput == 2 then
		GangMember = true
	end
end)


RegisterNetEvent('table:enable')
AddEventHandler('table:enable', function()
	TriggerServerEvent("blackjack:table_open",true)
end)

RegisterNetEvent('table:disable')
AddEventHandler('table:disable', function()
	TriggerServerEvent("blackjack:table_open",false)
end)

RegisterNetEvent('requestWounds')
AddEventHandler('requestWounds', function()
	t, distance = GetClosestPlayerAny()
	if t ~= nil and t ~= -1 then
		if(distance ~= -1 and distance < 5) then
			TriggerServerEvent("Evidence:GetWounds", GetPlayerServerId(t))
			print(t)
		end
	end
end)
RegisterNetEvent("ems:heal")
AddEventHandler("ems:heal", function()
	t, distance = GetClosestPlayerAny()
	if t ~= nil and t ~= -1 then
		if(distance ~= -1 and distance < 5) then

			local myjob = exports["isPed"]:isPed("myjob")
			if myjob ~= "ems" and myjob ~= "doctor" then
				local bandages = exports["np-inventory"]:getQuantity("bandage")
				if bandages == 0 then
					return
				else
					TriggerEvent('inventory:removeItem',"bandage", 1)
				end
			end

			TriggerEvent("animation:PlayAnimation","layspike")
			TriggerServerEvent("ems:healplayer", GetPlayerServerId(t))
			print(t)
		end
	end
end)

RegisterNetEvent("ems:stomachpump")
AddEventHandler("ems:stomachpump", function()
	t, distance = GetClosestPlayerAny()
	if t ~= nil and t ~= -1 then
		if(distance ~= -1 and distance < 5) then
			local finished = exports["np-taskbar"]:taskBar(10000,"Inserting stomach pump 🤢", false, true)
			TriggerEvent("animation:PlayAnimation","cpr")
			if finished == 100 then
				local particleDict = "scr_familyscenem"
				local particleName = "scr_trev_amb_puke"
				RequestNamedPtfxAsset(particleDict)
				while not HasNamedPtfxAssetLoaded(particleDict) do Citizen.Wait(0) end
				local endTime = GetCloudTimeAsInt() + 5
				local particleFxHandle = 0
				SetPtfxAssetNextCall(particleDict)
				particleFxHandle = StartParticleFxLoopedOnEntityBone(particleName, GetPlayerPed(t), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(GetPlayerPed(t), 31086), 1.3, 0.0, 0.0, 0.0)
				SetParticleFxLoopedAlpha(particleFxHandle, 10.0)
				TriggerServerEvent("ems:stomachpumptarget", GetPlayerServerId(t))
			end
			TriggerEvent("animation:cancel")
		end
	end
end)

RegisterNetEvent('binoculars:Activate')
AddEventHandler('binoculars:Activate', function()
	if not handCuffed and not handCuffedWalking then
	   TriggerEvent("binoculars:Activate2")
	end
end)

RegisterNetEvent('camera:Activate')
AddEventHandler('camera:Activate', function()
	if not handCuffed and not handCuffedWalking then
	   TriggerEvent("camera:Activate2")
	end
end)

RegisterNetEvent('car:swapseat')
AddEventHandler('car:swapseat', function(num)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	SetPedIntoVehicle(PlayerPedId(),veh,num)
end)


RegisterNetEvent('car:swapdriver')
AddEventHandler('car:swapdriver', function()
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	SetPedIntoVehicle(PlayerPedId(), veh, -1)
end)

RegisterNetEvent('car:swapfp')
AddEventHandler('car:swapfp', function()
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	SetPedIntoVehicle(PlayerPedId(), veh, 0)
end)

RegisterNetEvent('car:swapbl')
AddEventHandler('car:swapbl', function()
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	SetPedIntoVehicle(PlayerPedId(), veh, 1)
end)

RegisterNetEvent('car:swapbr')
AddEventHandler('car:swapbr', function()
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	SetPedIntoVehicle(PlayerPedId(), veh, 2)
end)





imdead = 0
RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
	if imdead == 0 then 
		imdead = 1
	else
		beingDragged = false
		dragging = false
		imdead = 0
	end
    lightbleed = false
    heavybleed = false
    lightestbleed = false
	lasthealth = GetEntityHealth(PlayerPedId())
end)

--TriggerEvent("pNotify:SendNotification", { theme = "gta", text = " This is a test notification, thank you for testing. This is a test notification, thank you for testing. This is a test notification, thank you for testing.", layout = "bottomLeft", type = "info", timeout = 7000 } )

--[[ RegisterNetEvent('customNotification')
AddEventHandler('customNotification', function(msg)
	TriggerEvent("pNotify:SendNotification", { theme = "gta", text = "".. msg .. "", layout = "bottomLeft", type = "info", timeout = 12000, animation = {open = "gta_effects_open_left", close = "gta_effects_close_left"} } )
end)
RegisterNetEvent('customNotification')
AddEventHandler('customNotification', function(msg)
	TriggerEvent("pNotify:SendNotification", { theme = "gta", text = "".. msg .. "", layout = "bottomLeft", type = "info", timeout = 4000, animation = {open = "gta_effects_open_left", close = "gta_effects_close_left"} } )
end) ]]

RegisterNetEvent('checkmyPH')
AddEventHandler('checkmyPH', function()
	TriggerServerEvent("police:showPH")
end)


RegisterNetEvent('police:vin')
AddEventHandler('police:vin', function()
	if isCop then
	  playerped = PlayerPedId()
      coordA = GetEntityCoords(playerped, 1)
      coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
      targetVehicle = getVehicleInDirection(coordA, coordB)
     	targetspeed = GetEntitySpeed(targetVehicle) * 3.6
     	herSpeedMph = GetEntitySpeed(targetVehicle) * 2.236936
      licensePlate = GetVehicleNumberPlateText(targetVehicle)

      if licensePlate == nil then

      	TriggerEvent("DoLongHudText", 'Can not target vehicle',2)

	  else
			TriggerServerEvent('checkVehVin',licensePlate)
		end
	end
end)


RegisterNetEvent('clientcheckLicensePlate')
AddEventHandler('clientcheckLicensePlate', function()
	if isCop then
	  playerped = PlayerPedId()
      coordA = GetEntityCoords(playerped, 1)
      coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
      targetVehicle = getVehicleInDirection(coordA, coordB)
     	targetspeed = GetEntitySpeed(targetVehicle) * 3.6
     	herSpeedMph = GetEntitySpeed(targetVehicle) * 2.236936
      licensePlate = GetVehicleNumberPlateText(targetVehicle)
      local vehicleClass = GetVehicleClass(targetVehicle)

      if licensePlate == nil then

      	TriggerEvent("DoLongHudText", 'Can not target vehicle',2)

      else
			TriggerServerEvent('checkLicensePlate',licensePlate)
		end
	end
end)

RegisterCommand('runplatet', function(source, args)
	if isCop then
		TriggerEvent('clientcheckLicensePlate')
	end
end)

RegisterCommand('runplate', function(source, args)
	if isCop then
		TriggerServerEvent('checkLicensePlate',args[1])
	end
end)


RegisterCommand('pn', function(source, args)
	TriggerServerEvent('police:showPH')
end)

RegisterCommand('911', function(source, args)
TriggerServerEvent('911', args)
end)

RegisterCommand('911r', function(source, args)
	TriggerServerEvent('911r', args)
end)

RegisterCommand('311', function(source, args)
	TriggerServerEvent('311', args)
end)
	
RegisterCommand('311r', function(source, args)
	TriggerServerEvent('311r', args)
end)

RegisterNetEvent('sniffVehicle')
AddEventHandler('sniffVehicle', function()
	if isCop then
	  playerped = PlayerPedId()
      coordA = GetEntityCoords(playerped, 1)
      coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
      targetVehicle = getVehicleInDirection(coordA, coordB)
     	targetspeed = GetEntitySpeed(targetVehicle) * 3.6
     	herSpeedMph = GetEntitySpeed(targetVehicle) * 2.236936
      licensePlate = GetVehicleNumberPlateText(targetVehicle)

      if licensePlate == nil then

      	TriggerEvent("DoLongHudText", 'Can not target vehicle',2)

      else
			TriggerServerEvent('sniffLicensePlateCheck',licensePlate)
		end
	end
end)


-- gestures@f@standing@casual gesture_hello

-- amb@code_human_wander_texting@male@base static


-- ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 


-- nod for a few seconds

RegisterNetEvent('showID')
AddEventHandler('showID', function()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 5) then
		TriggerEvent("DoLongHudText", 'Player Found: ' .. GetPlayerServerId(t) .. ' ID#',1)

		 TriggerServerEvent('gc:showthemIdentity', GetPlayerServerId(t))
    else
    	TriggerEvent("DoLongHudText", 'No Player Found',2)

    end
end)
inanimation = false
RegisterNetEvent('animation:throw')
AddEventHandler('animation:throw', function()

		if not handCuffed then

			local lPed = PlayerPedId()

			RequestAnimDict("anim@amb@prop_human_atm@interior@male@base")
			while not HasAnimDictLoaded("anim@amb@prop_human_atm@interior@male@base") do
				Citizen.Wait(0)
			end
			
			if IsEntityPlayingAnim(lPed, "anim@amb@prop_human_atm@interior@male@base", "base", 3) then
				ClearPedSecondaryTask(lPed)

			else
				TaskPlayAnim(lPed, "anim@amb@prop_human_atm@interior@male@base", "base", 8.0, -8, -1, 49, 0, 0, 0, 0)
				seccount = 3
				while seccount > 0 do
					Citizen.Wait(550)
					seccount = seccount - 0.5

				end
				ClearPedSecondaryTask(lPed)

			end		
		else
			ClearPedSecondaryTask(lPed)
		end

end)

RegisterNetEvent('animation:farm')
AddEventHandler('animation:farm', function()

inanimation = true

		if not handCuffed then

			local lPed = PlayerPedId()

			RequestAnimDict("amb@world_human_gardener_plant@male@base")
			while not HasAnimDictLoaded("amb@world_human_gardener_plant@male@base") do
				Citizen.Wait(0)
			end
			
			if IsEntityPlayingAnim(lPed, "amb@world_human_gardener_plant@male@base", "base", 3) then
				ClearPedSecondaryTask(lPed)

			else
				TaskPlayAnim(lPed, "amb@world_human_gardener_plant@male@base", "base", 8.0, -8, -1, 49, 0, 0, 0, 0)
				seccount = 4
				while seccount > 0 do
					Citizen.Wait(1000)
					seccount = seccount - 1

				end
				ClearPedSecondaryTask(lPed)

			end		
		else
			ClearPedSecondaryTask(lPed)
		end
inanimation = false

end)

local sawProp = 0
local sawModel = "prop_ld_fireaxe"
function createSawProp()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(sawModel)
	while not HasModelLoaded(sawModel) do
		Citizen.Wait(100)
	end
	return CreateObject(sawModel, 1.0, 1.0, 1.0, 1, 1, 0)
end

function removeSawProp()
	DeleteEntity(sawProp)
	sawProp = 0
end

RegisterNetEvent('animation:axeChop')
AddEventHandler('animation:axeChop', function()
inanimation = true

		if not handCuffed then

			local lPed = PlayerPedId()
	    SetCurrentPedWeapon(lPed, 0xA2719263) 
	    local bone = GetPedBoneIndex(lPed, 28422)

			RequestAnimDict("amb@world_human_hammering@male@base")
			while not HasAnimDictLoaded("amb@world_human_hammering@male@base") do
				Citizen.Wait(0)
			end
			
			if IsEntityPlayingAnim(lPed, "amb@world_human_hammering@male@base", "base", 3) then
				ClearPedSecondaryTask(lPed)

			else
      	removeSawProp()
				TaskPlayAnim(lPed, "amb@world_human_hammering@male@base", "base", 8.0, -8, -1, 49, 0, 0, 0, 0)
	      Citizen.Wait(157)
	      sawProp = createSawProp() 
	      AttachEntityToEntity(sawProp, lPed, bone, 0.0, 0.0, -0.6, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
				seccount = 4
				while seccount > 0 do
					Citizen.Wait(1000)
					seccount = seccount - 1
				end
				ClearPedSecondaryTask(lPed)
      	removeSawProp()
			end		
		else
			ClearPedSecondaryTask(lPed)
    	removeSawProp()
		end
inanimation = false
end)

RegisterNetEvent('animation:point')
AddEventHandler('animation:point', function()

		if not handCuffed then

			local lPed = PlayerPedId()

			RequestAnimDict("gestures@f@standing@casual")
			while not HasAnimDictLoaded("gestures@f@standing@casual") do
				Citizen.Wait(1)
			end
			
			if IsEntityPlayingAnim(lPed, "gestures@f@standing@casual", "gesture_point", 3) then
				ClearPedSecondaryTask(lPed)

			else
				TaskPlayAnim(lPed, "gestures@f@standing@casual", "gesture_point", 8.0, -8, -1, 49, 0, 0, 0, 0)
				seccount = 1
				while seccount > 0 do
					Citizen.Wait(1200)
					seccount = seccount - 1

				end
				ClearPedSecondaryTask(lPed)

			end		
		else
			ClearPedSecondaryTask(lPed)
		end

end)

--swimming@first_person@diving dive_run_fwd_45_loop


--GetVehicleModelMaxSpeed(modelHash)
--SetEntityMaxSpeed(entity, speed)

cruisecontrol = false


RegisterNetEvent('toggle:cruisecontrol')
AddEventHandler('toggle:cruisecontrol', function()

	local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local driverPed = GetPedInVehicleSeat(currentVehicle, -1)

	if driverPed == PlayerPedId() then

		if cruisecontrol then
			SetEntityMaxSpeed(currentVehicle, 999.0)
			cruisecontrol = false
			TriggerEvent("DoLongHudText","Speed Limiter Inactive",5)
		else
			speed = GetEntitySpeed(currentVehicle)
			if speed > 15.0 then
			SetEntityMaxSpeed(currentVehicle, speed)
			cruisecontrol = true
				TriggerEvent("DoLongHudText","Speed Limiter Active",5)
			else
				TriggerEvent("DoLongHudText","Speed Limiter can only activate over 35mph",2)
			end
		end

	end
end)
RegisterNetEvent('animation:tacklelol')
AddEventHandler('animation:tacklelol', function()

		if not handCuffed and not IsPedRagdoll(PlayerPedId()) then

			local lPed = PlayerPedId()

			RequestAnimDict("swimming@first_person@diving")
			while not HasAnimDictLoaded("swimming@first_person@diving") do
				Citizen.Wait(1)
			end
			
			if IsEntityPlayingAnim(lPed, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
				ClearPedSecondaryTask(lPed)

			else
				TaskPlayAnim(lPed, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)
				seccount = 3
				while seccount > 0 do
					Citizen.Wait(100)
					seccount = seccount - 1

				end
				ClearPedSecondaryTask(lPed)
				SetPedToRagdoll(PlayerPedId(), 150, 150, 0, 0, 0, 0) 
			end		

		end

end)


RegisterNetEvent('animation:wave')
AddEventHandler('animation:wave', function()

		if not handCuffed then

			local lPed = PlayerPedId()

			RequestAnimDict("friends@frj@ig_1")
			while not HasAnimDictLoaded("friends@frj@ig_1") do
				Citizen.Wait(0)
			end
			
			if IsEntityPlayingAnim(lPed, "friends@frj@ig_1", "wave_a", 3) then
				ClearPedSecondaryTask(lPed)

			else
				TaskPlayAnim(lPed, "friends@frj@ig_1", "wave_a", 8.0, -8, -1, 49, 0, 0, 0, 0)
				seccount = 5
				while seccount > 0 do
					Citizen.Wait(1000)
					seccount = seccount - 1

				end
				ClearPedSecondaryTask(lPed)

			end		
		else
			ClearPedSecondaryTask(lPed)
		end

end)

RegisterNetEvent('animation:nod')
AddEventHandler('animation:nod', function()

		if not handCuffed then

			local lPed = PlayerPedId()

			RequestAnimDict("random@getawaydriver")
			while not HasAnimDictLoaded("random@getawaydriver") do
				Citizen.Wait(0)
			end
			
			if IsEntityPlayingAnim(lPed, "random@getawaydriver", "gesture_nod_yes_hard", 3) then
				ClearPedSecondaryTask(lPed)

			else
				TaskPlayAnim(lPed, "random@getawaydriver", "gesture_nod_yes_hard", 8.0, -8, -1, 49, 0, 0, 0, 0)
				seccount = 10
				while seccount > 0 do
					Citizen.Wait(1000)
					seccount = seccount - 1

				end
				ClearPedSecondaryTask(lPed)
			end		
		else
			ClearPedSecondaryTask(lPed)
		end

end)

RegisterNetEvent('animation:lockpickcar')
AddEventHandler('animation:lockpickcar', function()
	inanimation = true
	local lPed = PlayerPedId()
	ClearPedTasks(IPed)
	if not handCuffed then

		

		RequestAnimDict("mini@repair")
		while not HasAnimDictLoaded("mini@repair") do
			Citizen.Wait(0)
		end
		
		if IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
			ClearPedSecondaryTask(lPed)
			TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
		else
			ClearPedTasksImmediately(IPed)
			TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
		end		
	else
		ClearPedSecondaryTask(lPed)
	end
	inanimation = false
end)

RegisterNetEvent('animation:repaircar')
AddEventHandler('animation:repaircar', function()

inanimation = true

		ClearPedTasksImmediately(IPed)
		if not handCuffed then

			local lPed = PlayerPedId()

			RequestAnimDict("mini@repair")
			while not HasAnimDictLoaded("mini@repair") do
				Citizen.Wait(0)
			end
			
			if IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
				ClearPedSecondaryTask(lPed)
				TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
			else
				ClearPedTasksImmediately(IPed)
				TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
				seccount = 20
				while seccount > 0 do
					Citizen.Wait(1000)
					seccount = seccount - 1

				end
				ClearPedSecondaryTask(lPed)
			end		
		else
			ClearPedSecondaryTask(lPed)
		end
inanimation = false
end)



RegisterNetEvent('animation:phonecall')
AddEventHandler('animation:phonecall', function()
inanimation = true
		if not handCuffed then

			local lPed = PlayerPedId()

			RequestAnimDict("random@arrests")
			while not HasAnimDictLoaded("random@arrests") do
				Citizen.Wait(0)
			end
			
			if IsEntityPlayingAnim(lPed, "random@arrests", "idle_c", 3) then
				ClearPedSecondaryTask(lPed)

			else
				TaskPlayAnim(lPed, "random@arrests", "idle_c", 8.0, -8, -1, 49, 0, 0, 0, 0)
				seccount = 10
				while seccount > 0 do
					Citizen.Wait(1000)
					seccount = seccount - 1

				end
				ClearPedSecondaryTask(lPed)
			end		
		else
			ClearPedSecondaryTask(lPed)
		end
inanimation = false
end)

RegisterNetEvent('animation:facepalm')
AddEventHandler('animation:facepalm', function()

		if not handCuffed then

			local lPed = PlayerPedId()

			RequestAnimDict("random@car_thief@agitated@idle_a")
			while not HasAnimDictLoaded("random@car_thief@agitated@idle_a") do
				Citizen.Wait(0)
			end
			
			if IsEntityPlayingAnim(lPed, "random@car_thief@agitated@idle_a", "agitated_idle_a", 3) then
				ClearPedSecondaryTask(lPed)

			else
				TaskPlayAnim(lPed, "random@car_thief@agitated@idle_a", "agitated_idle_a", 8.0, -8, -1, 49, 0, 0, 0, 0)
				seccount = 6
				while seccount > 0 do
					Citizen.Wait(1000)
					seccount = seccount - 1

				end
				ClearPedSecondaryTask(lPed)
			end		
		else
			ClearPedSecondaryTask(lPed)
		end

end)

RegisterNetEvent('client:takephone')
AddEventHandler('client:takephone', function(t)
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 10) then
		TriggerServerEvent("server:takephone", GetPlayerServerId(t))
		TriggerEvent("DoLongHudText", 'Removed Phone Devices..',1)
	else
		TriggerEvent("DoLongHudText", 'No Player Found',2)
	end
end)

RegisterNetEvent('police:remweapons')
AddEventHandler('police:remweapons', function(t)
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 10) then
		TriggerServerEvent("police:remweaponsGranted", GetPlayerServerId(t))
	else
		TriggerEvent("DoLongHudText", 'No Player Found',1)
	end
end)
	
RegisterNetEvent('unseatPlayer')
AddEventHandler('unseatPlayer', function()
	t, distance = GetClosestPlayerIgnoreCar()
	if(distance ~= -1 and distance < 10) then
		local ped = PlayerPedId()  
		pos = GetEntityCoords(ped,  true)

		TriggerServerEvent('unseatAccepted',GetPlayerServerId(t),pos["x"], pos["y"], pos["z"])
		Citizen.Wait(1000)
		TriggerServerEvent("police:escortAsk", GetPlayerServerId(t))
	else
		TriggerEvent("DoLongHudText", 'No Player Found',1)
	end
end)

RegisterNetEvent("K9:Huntfind")
AddEventHandler("K9:Huntfind", function()

	t, distance = GetClosestPlayer()
	players, distances, coords = GetClosestPlayers(GetEntityCoords(PlayerPedId(), 0),150)
	if(#players > 0) then
		TriggerServerEvent('huntAccepted', players, distances, coords)
		TriggerEvent("DoLongHudText", 'Hunting',1)
	else
		TriggerEvent("DoLongHudText", 'No Scent to pickup on..',2)
	end

end)


RegisterNetEvent("K9:Sniff")
AddEventHandler("K9:Sniff", function()

	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 10) then
		TriggerServerEvent('sniffAccepted',GetPlayerServerId(t))
	else
		TriggerEvent("DoLongHudText", 'No Player Found',2)
	end

end)


TimerEnabled = false

function TryTackle()
		if not TimerEnabled then
			t, distance = GetClosestPlayer()
			if(distance ~= -1 and distance < 2) then
				local maxheading = (GetEntityHeading(PlayerPedId()) + 15.0)
				local minheading = (GetEntityHeading(PlayerPedId()) - 15.0)
				local theading = (GetEntityHeading(t))

				TriggerServerEvent('CrashTackle',GetPlayerServerId(t))
				TriggerEvent("animation:tacklelol") 

				TimerEnabled = true
				Citizen.Wait(4500)
				TimerEnabled = false

			else
				TimerEnabled = true
				Citizen.Wait(1000)
				TimerEnabled = false

			end

		end
--SetPedToRagdoll(PlayerPedId(), 500, 500, 0, 0, 0, 0) 
end

RegisterNetEvent('playerTackled')
AddEventHandler('playerTackled', function()
	SetPedToRagdoll(PlayerPedId(), math.random(8500), math.random(8500), 0, 0, 0, 0) 

	TimerEnabled = true
	Citizen.Wait(1500)
	TimerEnabled = false
end)

RegisterNetEvent('unseatPlayerFinish')
AddEventHandler('unseatPlayerFinish', function(x,y,z)
	local intrunk = exports["isPed"]:isPed("intrunk")
	if not intrunk then
		local ped = PlayerPedId()  
		ClearPedTasksImmediately(ped)
		local veh = GetVehiclePedIsIn(ped, false)
        TaskLeaveVehicle(ped, veh, 256)
		SetEntityCoords(ped, x, y, z)
	end
end)

-- random@shop_robbery robbery_action_a
local lastRob = false

RegisterNetEvent('robPlayer')
AddEventHandler('robPlayer', function()

	local finishedanim = false

	if lastRob and GetGameTimer() - lastRob < 600000 then TriggerEvent("DoLongHudText", "You can only mug once every 10 minutes",2) return end

	if not handCuffed then

		local lPed = PlayerPedId()

		RequestAnimDict("random@shop_robbery")
		while not HasAnimDictLoaded("random@shop_robbery") do
			Citizen.Wait(0)
		end
		
		if IsEntityPlayingAnim(lPed, "random@shop_robbery", "robbery_action_b", 3) then
			ClearPedSecondaryTask(lPed)
			finishedanim = false
		else
			ClearPedTasksImmediately(lPed)
			TaskPlayAnim(lPed, "random@shop_robbery", "robbery_action_b", 8.0, -8, -1, 16, 0, 0, 0, 0)
			local seccount = 7
			while seccount > 0 do
				Citizen.Wait(1200)
				seccount = seccount - 1

			end
			if IsEntityPlayingAnim(lPed, "random@shop_robbery", "robbery_action_b", 3) then
				finishedanim = true
			else
				finishedanim = false
			end
			ClearPedTasksImmediately(lPed)
		end		
	else
		ClearPedSecondaryTask(lPed)
	end

	if not finishedanim then return end

	t, distance = GetClosestPlayer()
	if distance ~= -1 and distance < 5 then

		if IsEntityPlayingAnim ( GetPlayerPed(t), "random@mugging3", "handsup_standing_base", 3) or IsEntityPlayingAnim(GetPlayerPed(t), "random@arrests@busted", "idle_a", 3) or isCop or IsPedRagdoll(GetPlayerPed(t))  then
			TriggerServerEvent("bank:steal", GetPlayerServerId(t))
			lastRob = GetGameTimer()
		else
			TriggerEvent("DoLongHudText", "You can only rob players that have their hands up.",2)
		end

	else
		--TriggerEvent("DoLongHudText","No target found.")
	end

end)

function LoadAnimationDictionary(animationD) -- Simple way to load animation dictionaries to save lines.
	while(not HasAnimDictLoaded(animationD)) do
		RequestAnimDict(animationD)
		Citizen.Wait(1)
	end
end





otherid = 0
escort = false
keystroke = 49
triggerkey = false

dragging = false
beingDragged = false

escortStart = false
shitson = false

RegisterNetEvent('dragPlayer')
AddEventHandler('dragPlayer', function()
	local handcuffed = exports["isPed"]:isPed("handcuffed")
	if handcuffed then
		TriggerEvent("DoLongHudText","You are in handcuffs!",2)
		return
	end
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 1.0) then
		if not beingDragged then
			DetachEntity(PlayerPedId(), true, false)
			TriggerServerEvent("police:dragAsk", GetPlayerServerId(t))
		end
	end
end)

RegisterNetEvent('drag:stopped')
AddEventHandler('drag:stopped', function(sentid)
	if tonumber(sentid) == tonumber(otherid) and beingDragged then
		shitson = false
		beingDragged = false
		DetachEntity(PlayerPedId(), true, false)
		TriggerEvent("deathdrop",beingDragged)
	end
end)

local targetsWeight = 0

RegisterNetEvent('inv:weightConfirmed')
AddEventHandler('inv:weightConfirmed', function(weight)
	targetsWeight = weight
end)


RegisterNetEvent('escortPlayer')
AddEventHandler('escortPlayer', function()
	local handcuffed = exports["isPed"]:isPed("handcuffed")
	if handcuffed then
		TriggerEvent("DoLongHudText","You are in handcuffs!",2)
		return
	end
	t, distance = GetClosestPlayer()
	-- error debug fix - syd
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		if(distance ~= -1 and distance < 5) then
			if not escort then

				TriggerServerEvent("inv:weightAsk", GetPlayerServerId(t))
				Wait(800)
				if targetsWeight > 90 then
					TriggerEvent("DoLongHudText","Cannot Escort Someone who is overburdened.",2)
				else
				TriggerServerEvent("police:escortAsk", GetPlayerServerId(t))
				end
			end
		else
			escorting = false
		end
	end
end)

RegisterNetEvent("unEscortPlayer")
AddEventHandler("unEscortPlayer", function()
	escort = false
	beingDragged = false
	ClearPedTasks(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)


RegisterNetEvent("dr:dragging")
AddEventHandler('dr:dragging', function()
	dragging = not dragging

	if not dragging and IsPedInAnyVehicle(PlayerPedId(), false) then
		return
	end
	
	if not dragging then
		ClearPedTasksImmediately(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
	end
end)

local escorting = false

RegisterNetEvent("dr:releaseEscort")
AddEventHandler("dr:releaseEscort", function()
	escorting = false
end)




RegisterNetEvent("dr:escort")
AddEventHandler('dr:escort', function(pl)
	otherid = tonumber(pl)
	if not escort and IsPedInAnyVehicle(PlayerPedId(), false) then
		return
	end
	escort = not escort
	if not escort then
		TriggerServerEvent("dr:releaseEscort",otherid)
	end

end)

RegisterNetEvent("dr:drag")
AddEventHandler('dr:drag', function(pl)
	otherid = tonumber(pl)
	beingDragged = not beingDragged
	if beingDragged then
		SetEntityCoords(PlayerPedId(),GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(otherid))))
	end
	Citizen.Wait(1000)
	TriggerEvent("deathdrop",beingDragged)
end)





RegisterNetEvent("dr:escortingEnabled")
AddEventHandler('dr:escortingEnabled', function()
	escorting = true
end)




--GetEntityAttachedTo(PlayerPedId())

Citizen.CreateThread(function()
	while true do
		if escorting or dragging then
			if IsPedRunning(PlayerPedId()) or IsPedSprinting(PlayerPedId()) then
				SetPlayerControl(PlayerId(), 0, 0)
				Citizen.Wait(1000)
				SetPlayerControl(PlayerId(), 1, 1)
			end
		else
			Citizen.Wait(1000)
		end
		Citizen.Wait(1)
	end
end)


Citizen.CreateThread(function()
	while true do

		if IsEntityDead(GetPlayerPed(GetPlayerFromServerId(otherid))) and (escort) then 
			DetachEntity(PlayerPedId(), true, false)
			shitson = false	
			escort = false
			local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(GetPlayerFromServerId(otherid)), 0.0, 0.8, 2.8)
			SetEntityCoords(PlayerPedId(),pos)
		end


		if escort or beingDragged then
			local ped = GetPlayerPed(GetPlayerFromServerId(otherid))
			local myped = PlayerPedId()
			if escort then
				x,y,z = 0.54, 0.44, 0.0
			else
				x,y,z = 0.0, 0.44, 0.0
			end
			if not beingDragged then
				AttachEntityToEntity(myped, ped, 11816, x, y, z, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			else
				AttachEntityToEntity(myped, ped, 1, -0.68, -0.2, 0.94, 180.0, 180.0, 60.0, 1, 1, 0, 1, 0, 1)
			end
			
			shitson = true
			--escortStart = true
		else
			if not beingDragged and not escort and shitson then
				DetachEntity(PlayerPedId(), true, false)	
				shitson = false	
				Citizen.Trace("no escort or drag")
				ClearPedTasksImmediately(PlayerPedId())
			end
		end

		if dragging then

			if not IsEntityPlayingAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
				LoadAnimationDictionary( "missfinale_c2mcs_1" ) 
				TaskPlayAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
			end
			local dead = exports["isPed"]:isPed("dead")
			if dead or IsControlJustPressed(0, 38) or (`WEAPON_UNARMED` ~= GetSelectedPedWeapon(PlayerPedId())) then
				dragging = false
				ClearPedTasks(PlayerPedId())
				TriggerServerEvent("dragPlayer:disable")
			end

		end

		if beingDragged then
			if not IsEntityPlayingAnim(PlayerPedId(), "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 3) then
				LoadAnimationDictionary( "amb@world_human_bum_slumped@male@laying_on_left_side@base" ) 
				TaskPlayAnim(PlayerPedId(), "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
			end
		end
		Citizen.Wait(1)
	end
end)



RegisterNetEvent('FlipVehicle')
AddEventHandler('FlipVehicle', function()
	local finished = exports["np-taskbar"]:taskBar(5000,"Flipping Vehicle Over",false,true)	

	if finished == 100 then
		local playerped = PlayerPedId()
	    local coordA = GetEntityCoords(playerped, 1)
	    local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)
		local pPitch, pRoll, pYaw = GetEntityRotation(playerped)
		local vPitch, vRoll, vYaw = GetEntityRotation(targetVehicle)
		SetEntityRotation(targetVehicle, pPitch, vRoll, vYaw, 1, true)
		Wait(10)
		SetVehicleOnGroundProperly(targetVehicle)
	end

end)

function deleteVeh(ent)

	SetVehicleHasBeenOwnedByPlayer(ent, true)
	NetworkRequestControlOfEntity(ent)
	local finished = exports["np-taskbar"]:taskBar(1000,"Impounding",false,true)	
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(ent))
	DeleteEntity(ent)
	DeleteVehicle(ent)
	SetEntityAsNoLongerNeeded(ent)
end

RegisterNetEvent('impoundVehicle')
AddEventHandler('impoundVehicle', function()

	playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
   -- targetVehicle = getVehicleInDirection(coordA, coordB)


    targetVehicle = getVehicleInDirection(coordA, coordB)

	licensePlate = GetVehicleNumberPlateText(targetVehicle)
	TriggerServerEvent("garages:SetVehImpounded",targetVehicle,licensePlate,false)
	TriggerEvent("DoLongHudText","Impounded with retrieval price of $100",1)
	deleteVeh(targetVehicle)
	TriggerServerEvent("policeimpound")


end)



RegisterNetEvent('fullimpoundVehicle')
AddEventHandler('fullimpoundVehicle', function()
	playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    --targetVehicle = getVehicleInDirection(coordA, coordB)
   	targetVehicle = getVehicleInDirection(coordA, coordB)



	licensePlate = GetVehicleNumberPlateText(targetVehicle)
	TriggerServerEvent("garages:SetVehImpounded",targetVehicle,licensePlate,true)
	TriggerEvent("DoLongHudText","Impounded with retrieval price of $1500",1)

	deleteVeh(targetVehicle)
end)


function getVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		
		offset = offset - 1

		if vehicle ~= 0 then break end
	end
	
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	
	if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end



RegisterNetEvent('animation:runtextanim')
AddEventHandler('animation:runtextanim', function(anim)
	if not handCuffed and not IsPedRagdoll(PlayerPedId()) then
		TriggerEvent('animation:runtextanim2',anim)
	end
end)




local emsVehicleListWhite = { 
	{"Ambulance", "emsa"},
	{"Helicopter", "emsair"},
	{"Charger", "emsc"},
	{"F350", "emsf"},
	{"Tahoe", "emst"},
	{"Coroner", "emsv"},
	{"Firetruck", "firetruk"},
	{"Boat", "dinghy4"},
}

local emsVehicleList = { 
	"ambulance"
}

local copVehicleList = { 
	{"LSPD Vic", "POLVIC"},
	{"BCSO/SASP Vic", "POLVIC2"},
	{"Taurus", "POLTAURUS"},
	{"Tahoe", "POLTAH"},
	{"Motorbike", "pol8"},
	{"Raptor", "POLRAPTOR"},
	{"Charger", "POLCHAR"},
	{"SWAT Suburban", "pol10"},
	{"Helicopter", "maverick2"},
	{"Boat", "predator"},
	{"Prison Bus", "pbus2"},
	{"Armored Van", "policet"},
	{"UC Schafter", "polschafter3"},
	{"Mustang", "2015POLSTANG"},
	{"FBI Buffalo", "fbi"},
	{"FBI Granger", "fbi2"},

	{"UC Washington", "ucwashington"},
	{"UC Banshee", "ucbanshee"},
	{"UC Rancher", "ucrancher"},
	{"UC Primo", "ucprimo"},
	{"UC Coquette", "uccoquette"},
	{"UC Buffalo", "ucbuffalo"},
	{"UC Baller", "ucballer"},
	{"UC Comet", "uccomet"},

	--"flatbed2", -- PD tow truck.
}

local pullout = false

local function serviceVehicle(arg, livery, isEmsWhiteListed, cb)
	if not arg then cb("No argument was given") return end

	local function printHelp(list)
		copVehStrList = ""
		for i=1, #list do
			copVehStrList = copVehStrList.."["..i.."] "..list[i][1].."\n"
		end
		TriggerEvent("chatMessage", "SYSTEM ", 2, copVehStrList)
	end
	if arg == "help" then
		print("sv help")
		if exports["isPed"]:isPed("myjob") == "police" then
			printHelp(copVehicleList)
		elseif exports["isPed"]:isPed("myjob") == "ems" then
			printHelp(emsVehicleListWhite)
		end
		return
	end

	arg = tonumber(arg)
	if not arg then cb("Invalid argument") return end


	if isCop then
		if arg > #copVehicleList then arg = 1 end

		selectedSkin = copVehicleList[arg][2]

	else
		if exports["isPed"]:isPed("myjob") == "ems" then
			if arg > #emsVehicleListWhite then arg = 1 end
			selectedSkin = emsVehicleListWhite[arg][2]
		else
			if arg > #emsVehicleList then arg = 1 end
			selectedSkin = emsVehicleList[arg]
		end
	end


	Citizen.CreateThread(function()
		
		if not pullout then
			pullout = true
		else
			--TriggerServerEvent("MayorCashAdjust",250,2,"New Emergency Vehicle")
		end

		local hash = GetHashKey(selectedSkin)

		if not IsModelAVehicle(hash) then cb("Model isn't a vehicle") return end
		if not IsModelInCdimage(hash) or not IsModelValid(hash) then cb("Model doesn't exist") return end

		TriggerEvent("np-admin:runSpawnCommand",selectedSkin, livery)
	end)
end

local policeSkinsList = {"s_m_y_cop_01", "s_f_y_sheriff_01", "s_m_y_hwaycop_01", "s_m_y_ranger_01", "s_m_y_sheriff_01", "s_m_y_swat_01", "s_f_y_cop_02C"}

function GroupRank(groupid)
  local rank = 0
  local mypasses = exports["isPed"]:isPed("passes")
  for i=1, #mypasses do
    if mypasses[i]["pass_type"] == groupid then
      rank = mypasses[i]["rank"]
    end 
  end
  return rank
end

RegisterNetEvent("civilian:van")
AddEventHandler("civilian:van", function(args)

	if tonumber(args[1]) == 1 and GroupRank("carpet_factory") > 0 then
		SetVehicleLivery(sentveh, 1)
	end
	if tonumber(args[1]) == 2 and GroupRank("illegal_carshop") > 0 then
		SetVehicleLivery(sentveh, 2)
	end
	if tonumber(args[1]) == 3 and GroupRank("life_invader") > 0 then
		SetVehicleLivery(sentveh, 3)
	end
	if tonumber(args[1]) == 4 and GroupRank("wine_factory") > 0 then
		SetVehicleLivery(sentveh, 4)
	end
	if tonumber(args[1]) == 5 and GroupRank("strip_club") > 0 then
		SetVehicleLivery(sentveh, 5)
	end
end)

RegisterNetEvent("police:chatCommand")
AddEventHandler("police:chatCommand", function(args, cmd, isVehicleCmd)
	-- remove the cmd itself from the args
	-- table.remove(args, 1)


	
if isCop then


	local function errorMsg(msg)
		TriggerEvent("chatMessage", "Error", {255, 0, 0}, msg)
	end

	--local _isCop = isCop
	--if not _isCop then errorMsg("You must be a police officer to use this command") return end

	if not args[1] and cmd ~= "fix" and cmd ~= "spikes" then errorMsg("No argument was given") return end

	local vehicle

	if isVehicleCmd then
		vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		if vehicle == 0 then errorMsg("No vehicle target was found") return end
		SetVehicleModKit(vehicle, 0)
	end

	if cmd == "tint" then
		SetVehicleWindowTint(vehicle, tonumber(args[1]))
	end

	if cmd == "clean" then
		SetVehicleDirtLevel(vehicle, 0)
	end

	if cmd == "extra" then

		if not args[2] then errorMsg("You are missing a second argument") return end
		if args[2] ~= "true" and args[2] ~= "false" then errorMsg("Invalid arguments") return end
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed, 0)

		for i,v in ipairs(fixPoints) do
			if( #(playerCoords - vector3(fixPoints[i][1], fixPoints[i][2], fixPoints[i][3] )) < 50) then
				canFix = true
			else
				if not canFix then canFix = false end
			end
		end

		if GetVehicleEngineHealth(vehicle) < 1000.0 then
			canFix = false
		end

		if canFix then
			local toggle = args[2] == "true" and 0 or -1
			if args[1] == "all" then 
				for i = 1, 30 do
					SetVehicleExtra(vehicle, i, toggle)
				end
			else				
				SetVehicleExtra(vehicle, tonumber(args[1]), toggle)
			end
		else
			errorMsg("Need To be at Repair Point and your vehicle must be repaired.")
		end

		SetVehiclePetrolTankHealth(vehicle,4000.0)
	end

	if cmd == "livery" then
		SetVehicleLivery(vehicle, tonumber(args[1]))
	end

	if cmd == "color" then
		if not args[2] then errorMsg("You are missing a second argument") return end
		SetVehicleColours(vehicle, tonumber(args[1]), tonumber(args[2]))
	end

	if cmd == "color2" then
		SetVehicleExtraColours(vehicle, tonumber(args[1]), 0)
	end

	if cmd == "rims" then
		SetVehicleWheelType(vehicle, 8)

		local rimList = {-1, 197, 196, 166, 165}
		SetVehicleMod(vehicle, 23, rimList[tonumber(args[1])], false)
	end

	if cmd == "fix" then
		local finished = exports["np-taskbar"]:taskBar(3500,"Completing Task",false,true)	

		if finished == 100 then
			local canFix = false
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed, 0)
			TriggerServerEvent("MayorCashAdjust",250,2,"Emergency Vehicle Repairs")
			if exports["isPed"]:isPed("myjob") == "ems" then
				SetVehicleFixed(vehicle)
				 SetVehiclePetrolTankHealth(vehicle, 4000.0)
			else
				for i,v in ipairs(fixPoints) do
					local dist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, fixPoints[i][1], fixPoints[i][2], fixPoints[i][3])
					if (dist < 75) then
						canFix = true
					end
				end

				if canFix then
					SetVehicleFixed(vehicle)
					SetVehiclePetrolTankHealth(vehicle, 4000.0)
				else
					errorMsg("Need To be at Repair Point")
				end
			end
		end
	end

	if cmd == "sv" then
		serviceVehicle(args[1], args[2], isEmsWhiteListed, errorMsg)
	end

	if cmd == "hat" then
		local arg = tonumber(args[1])
		if not arg then errorMsg("Invalid argument") return end

		if arg == -1 then ClearPedProp(PlayerPedId(), 0) return end

		SetPedPropIndex(PlayerPedId(), 0, arg, false, false)
		TriggerEvent("facewear:update")
	end

	if cmd == "whitelist" then
		if rankService == 10 then
			local arg = args[1]
			local arg2 = tonumber(args[2])
			if not arg then errorMsg("Invalid argument") return end
			if not arg2 then errorMsg("Invalid Second argument") return end

			TriggerServerEvent("police:whitelist",arg2,arg)
		else
			errorMsg("You do not have the rank to do this action")
		end
	end

	if cmd == "remove" then
		if rankService == 10 then
			local arg = args[1]
			local arg2 = tonumber(args[2])
			if not arg then errorMsg("Invalid argument") return end
			if not arg2 then errorMsg("Invalid Second argument") return end

			TriggerServerEvent("police:remove",arg2,arg)
		else
			errorMsg("You do not have the rank to do this action")
		end
	end

	if cmd == "duty" then
		if exports["isPed"]:isPed("myjob") == "ems" then
			local arg = tonumber(args[1])
			TriggerEvent("emsGear",arg)
		else
			local arg = tonumber(args[1])	
			if not arg then errorMsg("Invalid argument") return end
			SkinNoUpdate(arg)
			TriggerEvent("policegear")
			TriggerServerEvent('tattoos:retrieve')
			TriggerServerEvent('Blemishes:retrieve')
		end
		TriggerEvent("facewear:update")
	end

	if cmd == "spikes" then
		TriggerEvent("c_setSpike")
	end
else
end
end)


RegisterCommand("impound", function(source, args)
if isCop then
	TriggerEvent("impoundVehicle")
end
end)


RegisterCommand('callsign', function(source, args)
	if isCop then
		if args[1] == "plate" then
			if currentCallSign == nil then
				TriggerEvent('DoLongHudText', 'You dont have a callsign to set as plate.', 2)
			else
				if IsPedInAnyVehicle(PlayerPedId(), false) then
					local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
					SetVehicleNumberPlateText(vehicle, currentCallSign)
					TriggerEvent("keys:addNew",vehicle,GetVehicleNumberPlateText(vehicle))
				else
					TriggerEvent('DoLongHudText', "You have to be in a vehicle to set your vehicle's plate to your current callsign.", 2)
				end
			end
		else
			TriggerEvent('police:setCallSign', args[1])
		end
	else
		TriggerEvent('DoLongHudText', "You need to be police officer or Master sway to do that.", 2)
	end
end)

RegisterCommand('sv', function(source, args)
	TriggerEvent("police:chatCommand", args, 'sv', false)
end)

RegisterCommand('livery', function(source, args)
	TriggerEvent("police:chatCommand", args, 'livery', true)
end)

RegisterCommand('extra', function(source, args)
	TriggerEvent("police:chatCommand", args, 'extra', true)
end)

RegisterCommand('tint', function(source, args)
	TriggerEvent("police:chatCommand", args, 'tint', true)
end)

RegisterCommand('clean', function(source, args)
	TriggerEvent("police:chatCommand", args, 'clean', true)
end)

RegisterCommand('color', function(source, args)
	TriggerEvent("police:chatCommand", args, 'color', true)
end)

RegisterCommand('color2', function(source, args)
	TriggerEvent("police:chatCommand", args, 'color2', true)
end)

RegisterCommand('fix', function(source, args)
	TriggerEvent("police:chatCommand", args, 'fix', true)
end)


RegisterCommand('whitelist', function(source, args)
	TriggerEvent("police:chatCommand", args, 'whitelist', false)
end)

RegisterCommand('remove', function(source, args)
	TriggerEvent("police:chatCommand", args, 'remove', false)
end)

RegisterCommand('duty', function(source, args)
	TriggerEvent("police:chatCommand", args, 'duty', false)
end)

RegisterCommand('sport', function(source)
TriggerEvent('police:sport')
end)

RegisterCommand('trunkgetin', function(source)
	TriggerEvent('ped:forceTrunkSelf')
end)

--[[
	PED_VARIATION_FACE = 0,
	PED_VARIATION_HEAD = 1,
	PED_VARIATION_HAIR = 2,
	PED_VARIATION_TORSO = 3,
	PED_VARIATION_LEGS = 4,
	PED_VARIATION_HANDS = 5,
	PED_VARIATION_FEET = 6,
	PED_VARIATION_EYES = 7,
	PED_VARIATION_ACCESSORIES = 8,
	PED_VARIATION_TASKS = 9,
	PED_VARIATION_TEXTURES = 10,
	PED_VARIATION_TORSO2 = 11
]]

local copOutfits = {
	
	[1] = {0,0,0,22,25,0,2,8,66,1,0,156,"male",false}, --BCSO 
	[2] = {0,0,0,22,25,0,2,6,57,2,0,24,"male",false}, --BCSO
	[3] = {0,0,0,22,32,0,13,6,57,2,0,24,"male",false}, --BCSO

	[4] = {0,0,0,14,31,0,9,6,32,14,0,91,"female",true}, --BCSO
	[5] = {0,0,0,14,41,0,25,6,34,14,0,91,"female",false}, --BCSO

	[6] = {0,0,0,0,59,0,24,0,44,20,0,93,"male",false}, --LSPD
	[7] = {0,0,0,1,25,0,51,6,57,13,0,26,"male",true}, --SASP
	[8] = {0,0,0,1,32,0,13,6,57,13,0,26,"male",false}, --SASP
	[9] = {0,0,0,0,25,0,51,6,57,13,0,118,"male",true}, --SASP
	[10] = {0,0,0,1,32,0,13,6,57,13,0,118,"male",false}, --SASP
	[11] = {0,0,0,19,33,0,50,6,57,12,0,102,"male",false}, --SASP K9
	[12] = {0,0,0,1,25,0,51,8,122,26,0,103,"male",true}, --SASP

	[13] = {0,0,0,0,35,0,25,8,39,13,0,149,"male",false}, --LSPD
	[14] = {0,0,0,1,35,0,25,8,39,13,0,143,"male",false}, --LSPD
	[15] = {0,0,0,14,31,0,9,8,64,0,0,153,"female",true}, --BCSO
}

local copOutfitColors = {
	[4] = {0,0,0,2,0,0,0,0,0,0,0,0},
	[7] = {0,0,0,1,0,0,0,0,0,0,0,0},
	[9] = {0,0,0,1,0,0,0,0,0,0,0,0},
	[12] = {0,0,0,1,0,0,0,0,0,0,0,0},
	[15] = {0,0,0,0,2,0,0,0,4,0,0,3},
}

function SkinNoUpdate(arg)
	local model
	if copOutfits[arg] then
		if copOutfits[arg][13] == "male" then
			 model = `mp_m_freemode_01`
		else
			 model = `mp_f_freemode_01`
		end
		if IsModelInCdimage(model) and IsModelValid(model) then
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(0)
			end
			local head = GetPedDrawableVariation(PlayerPedId(),0)
			local hair = GetPedDrawableVariation(PlayerPedId(),2)
			local hairC = GetPedTextureVariation(PlayerPedId(),2)


			SetPlayerModel(PlayerId(), model)
			SetModelAsNoLongerNeeded(model)

			for i,v in ipairs(copOutfits[arg]) do
				if copOutfits[arg][14] then
					SetPedComponentVariation(PlayerPedId(),i-1,v,copOutfitColors[arg][i-1],0)
				else
					SetPedComponentVariation(PlayerPedId(),i-1,v,0,0)
				end	
			end

			SetPedComponentVariation(PlayerPedId(),0,head,0,0)
			SetPedComponentVariation(PlayerPedId(),2,hair,hairC,0)
		else
			TriggerEvent("DoLongHudText","Model not found",2)
		end
	else
		TriggerEvent("DoLongHudText","Outfit not found",2)
	end
end

RegisterNetEvent('police:grantHouse')
AddEventHandler('police:grantHouse', function()
    local status = 1
    local typeChange = "House"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)



RegisterNetEvent('police:grantDriver')
AddEventHandler('police:grantDriver', function()
    local status = 1
    local typeChange = "Drivers"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:grantBusiness')
AddEventHandler('police:grantBusiness', function()
    local status = 1
    local typeChange = "Business"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:grantDA')
AddEventHandler('police:grantDA', function()
    local status = 2
    local typeChange = "Law"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:removeDA')
AddEventHandler('police:removeDA', function()
    local status = 0
    local typeChange = "Law"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterCommand('steal', function()
TriggerEvent('police:rob')
end)

RegisterNetEvent('police:grantBar')
AddEventHandler('police:grantBar', function()
    local status = 1
    local typeChange = "Law"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:removeBar')
AddEventHandler('police:removeBar', function()
    local status = 0
    local typeChange = "Law"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:denyWeapon')
AddEventHandler('police:denyWeapon', function()
    local status = 5
    local typeChange = "Weapon"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:denyDriver')
AddEventHandler('police:denyDriver', function()
    local status = 5
    local typeChange = "Drivers"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:denyBusiness')
AddEventHandler('police:denyBusiness', function()
    local status = 5
    local typeChange = "Business"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:denyHouse')
AddEventHandler('police:denyHouse', function()
    local status = 5
    local typeChange = "House"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:grantWeapon')
AddEventHandler('police:grantWeapon', function()
    local status = 1
    local typeChange = "Weapon"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:removeHouse')
AddEventHandler('police:removeHouse', function()
    local status = 0
    local typeChange = "House"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:removeDriver')
AddEventHandler('police:removeDriver', function()
    local status = 0
    local typeChange = "Drivers"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:removeBusiness')
AddEventHandler('police:removeBusiness', function()
    local status = 0
    local typeChange = "Business"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:removeWeapon')
AddEventHandler('police:removeWeapon', function()
    local status = 0
    local typeChange = "Weapon"
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:updateLicenses",GetPlayerServerId(t),status,typeChange)
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)

RegisterNetEvent('police:frisk')
AddEventHandler('police:frisk', function()
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:targetCheckWeapons", GetPlayerServerId(t))
    else
        TriggerEvent("DoLongHudText", "No player near you!",2)
    end
end)