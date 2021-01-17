function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function LocalPed()
	return PlayerPedId()
end
function DrawText3Ds(x,y,z, text)
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
function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


-- NEW VERSION
local cmd = {
	["classic"] = { event = 'medicg:s_classic' },
	["classic2"] = { event = 'medicg:s_classic2' },
	["classic3"] = { event = 'medicg:s_classic3' },
	["classic4"] = { event = 'medicg:s_classic4' },			
	["helico"] = { event = 'medicg:s_helico' },
	["firetruk"] = { event = 'medicg:firetruk' },
}

RegisterNetEvent("emsGarage:Menu")
AddEventHandler("emsGarage:Menu", function(isWhitelisted)
	InitMenuVehicules(isWhitelisted)
end)




function InitMenuVehicules(isWhitelisted)
	MenuTitle = "SpawnJobs"
	ClearMenu()
	if isWhitelisted then
		Menu.addButton("Ambulance", "callSE", cmd["classic"].event)
		Menu.addButton("Chief 4WD", "callSE", cmd["ems1"].event)	
		Menu.addButton("Command", "callSE", cmd["ems2"].event)
		Menu.addButton("SCRT", "callSE", cmd["ems3"].event)
		Menu.addButton("SCRT", "callSE", cmd["ems4"].event)
		Menu.addButton("SCRT", "callSE", cmd["ems5"].event)
		Menu.addButton("Fire Truck", "callSE", cmd["firetruk"].event)
	else
		Menu.addButton("Ambulance", "callSE", cmd["classic"].event)
	end
end

function InitMenuHelico()
	MenuTitle = "SpawnJobs"
	ClearMenu()
	Menu.addButton("helicopter", "callSE", cmd["helico"].event)
end

function callSE(evt)
	Menu.hidden = not Menu.hidden
	Menu.renderGUI()
	TriggerServerEvent(evt)
end
isInService = false
local lastPlate = nil

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
	if job == "ems" then isInService = true else isInService = false end
end)

RegisterNetEvent("hasSignedOnEms")
AddEventHandler("hasSignedOnEms", function()
	SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION2`)
	SetPoliceIgnorePlayer(PlayerPedId(),true)
end)

RegisterNetEvent('nowMedic1')
AddEventHandler('nowMedic1', function()
    isInService = true
end)

RegisterNetEvent('nowMedicOff1')
AddEventHandler('nowMedicOff1', function()
    isInService = false
end)

local spawnNumber = 0
local signInLocation = {
	{-475.67788696289,-356.32354736328,34.100078582764},
	{364.68, -590.98, 28.69},
	{218.34973144531,-1637.6884765625,29.425844192505},
	{-1182.3208007813,-1773.2825927734,3.9084651470184},
	{1198.3963623047,-1455.646484375,34.967601776123},
}



RegisterNetEvent('event:control:hospitalGarage')
AddEventHandler('event:control:hospitalGarage', function(useID)
	if useID == 1 then
		TriggerServerEvent('attemptdutym')
	elseif useID == 2 then
		spawnNumber = 2
		TriggerServerEvent("police:emsVehCheck")
		Menu.hidden = not Menu.hidden

	elseif useID == 3 then
		if isInService then
			isInService = false

			TriggerServerEvent("TokoVoip:removePlayerFromAllRadio",GetPlayerServerId(PlayerId()))

			TriggerServerEvent("jobssystem:jobs", "unemployed")
			TriggerServerEvent('myskin_customization:wearSkin')
			TriggerServerEvent('tattoos:retrieve')
			TriggerServerEvent('Blemishes:retrieve')
			TriggerEvent("police:noLongerCop")
			TriggerEvent("logoffmedic")		
			TriggerEvent("loggedoff")					
			TriggerEvent('nowCopDeathOff')
		    TriggerEvent('nowCopSpawnOff')
		    TriggerEvent('nowMedicOff')
		    TriggerServerEvent("TokoVoip:clientHasSelecterCharecter")

		    SetPedRelationshipGroupHash(PlayerPedId(),`PLAYER`)
		    SetPedRelationshipGroupDefaultHash(PlayerPedId(),`PLAYER`)
		    SetPoliceIgnorePlayer(PlayerPedId(),false)
		    TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	    end	
	end
end)

-- #MarkedForMarker
local distancec = 999.0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		distancec = 999.0
		for i,v in ipairs(signInLocation) do
			local dstchk = #(vector3(v[1],v[2],v[3]) - GetEntityCoords(LocalPed()))
			if dstchk < distancec then
				distancec = dstchk
			end
			if dstchk < 12 then
				DrawText3Ds(v[1],v[2],v[3], '[F] for Car [E] to sign on duty [G] to Sign off.' )
			end
		end

		if distancec > 50.0 then
			Citizen.Wait(math.ceil(distancec))
		end
		
		Menu.renderGUI()
	end
end)

RegisterNetEvent('medicg:firetruk')
AddEventHandler('medicg:firetruk', function()
	Citizen.Wait(0)
	local closest = GetClosestVehicle(signInLocation[spawnNumber][1],signInLocation[spawnNumber][2],signInLocation[spawnNumber][3], 3.000, 0, 70)
	if DoesEntityExist(closest) then
		TriggerEvent("DoLongHudText", "The area is crowded",2)
		return
	end

	if lastPlate ~= nil then
		TriggerEvent("keys:remove",lastPlate)
	end
	

	local myPed = PlayerPedId()
	local player = PlayerId()
	local vehicle = `firetruk`
	RequestModel(vehicle)
	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

  local plate = "EMS ".. GetRandomIntInRange(1000, 9000)
	local spawned_car = CreateVehicle(vehicle, signInLocation[spawnNumber][1],signInLocation[spawnNumber][2],signInLocation[spawnNumber][3], -20.0, true, false)

	--SetVehicleOnGroundProperly(spawned_car)
	SetVehicleNumberPlateText(spawned_car, plate)
  TriggerEvent("keys:addNew",spawned_car,plate)
  TriggerServerEvent('garages:addJobPlate', plate)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
	lastPlate = plate
	
	
  Wait(250)
  TriggerEvent('car:engine')
end)

RegisterNetEvent('medicg:c_classic')
AddEventHandler('medicg:c_classic', function()
	Citizen.Wait(0)
	local closest = GetClosestVehicle(signInLocation[spawnNumber][1],signInLocation[spawnNumber][2],signInLocation[spawnNumber][3], 3.000, 0, 70)
	if DoesEntityExist(closest) then
		TriggerEvent("DoLongHudText", "The area is crowded",2)
		return
	end

	if lastPlate ~= nil then
		TriggerEvent("keys:remove",lastPlate)
	end
	

	local myPed = PlayerPedId()
	local player = PlayerId()
	local vehicle = `ambulance`
	RequestModel(vehicle)
	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

  local plate = "EMS ".. GetRandomIntInRange(1000, 9000)
	local spawned_car = CreateVehicle(vehicle, signInLocation[spawnNumber][1],signInLocation[spawnNumber][2],signInLocation[spawnNumber][3], -20.0, true, false)

	--SetVehicleOnGroundProperly(spawned_car)
	SetVehicleNumberPlateText(spawned_car, plate)
  TriggerEvent("keys:addNew",spawned_car,plate)
  TriggerServerEvent('garages:addJobPlate', plate)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
	lastPlate = plate
	
	
  Wait(250)
  TriggerEvent('car:engine')
end)

RegisterNetEvent('medicg:c_classic2')
AddEventHandler('medicg:c_classic2', function()
	Citizen.Wait(0)
	local closest = GetClosestVehicle(signInLocation[spawnNumber][1],signInLocation[spawnNumber][2],signInLocation[spawnNumber][3], 3.000, 0, 70)
	if DoesEntityExist(closest) then
		TriggerEvent("DoLongHudText", "The area is crowded",2)
		return
	end

	if lastPlate ~= nil then
		TriggerEvent("keys:remove",lastPlate)
	end
	

	local myPed = PlayerPedId()
	local player = PlayerId()
	local vehicle = `emschief`
	RequestModel(vehicle)
	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

  local plate = "EMS ".. GetRandomIntInRange(1000, 9000)
	local spawned_car = CreateVehicle(vehicle, signInLocation[spawnNumber][1],signInLocation[spawnNumber][2],signInLocation[spawnNumber][3], -20.0, true, false)

	--SetVehicleOnGroundProperly(spawned_car)
	SetVehicleNumberPlateText(spawned_car, plate)
	TriggerEvent("keys:addNew",spawned_car,plate)
	TriggerServerEvent('garages:addJobPlate', plate)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
	lastPlate = plate
	
	
	Wait(250)
	TriggerEvent('car:engine')
end)

RegisterNetEvent('medicg:c_classic3')
AddEventHandler('medicg:c_classic3', function()
	Citizen.Wait(0)
	local closest = GetClosestVehicle(signInLocation[spawnNumber][1],signInLocation[spawnNumber][2],signInLocation[spawnNumber][3], 3.000, 0, 70)
	if DoesEntityExist(closest) then
		TriggerEvent("DoLongHudText", "The area is crowded",2)
		return
	end

	if lastPlate ~= nil then
		TriggerEvent("keys:remove",lastPlate)
	end
	

	local myPed = PlayerPedId()
	local player = PlayerId()
	local vehicle = `emscommand`
	RequestModel(vehicle)
	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

  local plate = "EMS ".. GetRandomIntInRange(1000, 9000)
	local spawned_car = CreateVehicle(vehicle, signInLocation[spawnNumber][1],signInLocation[spawnNumber][2],signInLocation[spawnNumber][3], -20.0, true, false)

	--SetVehicleOnGroundProperly(spawned_car)
	SetVehicleNumberPlateText(spawned_car, plate)
  TriggerEvent("keys:addNew",spawned_car,plate)
  TriggerServerEvent('garages:addJobPlate', plate)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
	lastPlate = plate
	
	
  Wait(250)
  TriggerEvent('car:engine')
end)

RegisterNetEvent('medicg:c_classic4')
AddEventHandler('medicg:c_classic4', function()
	Citizen.Wait(0)
	local closest = GetClosestVehicle(signInLocation[spawnNumber][1],signInLocation[spawnNumber][2],signInLocation[spawnNumber][3], 3.000, 0, 70)
	if DoesEntityExist(closest) then
		TriggerEvent("DoLongHudText", "The area is crowded",2)
		return
	end

	if lastPlate ~= nil then
		TriggerEvent("keys:remove",lastPlate)
	end
	

	local myPed = PlayerPedId()
	local player = PlayerId()
	local vehicle = `emscrt`
	RequestModel(vehicle)
	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

  local plate = "EMS ".. GetRandomIntInRange(1000, 9000)
	local spawned_car = CreateVehicle(vehicle, signInLocation[spawnNumber][1],signInLocation[spawnNumber][2],signInLocation[spawnNumber][3], -20.0, true, false)

	--SetVehicleOnGroundProperly(spawned_car)
	SetVehicleNumberPlateText(spawned_car, plate)
  TriggerEvent("keys:addNew",spawned_car,plate)
  TriggerServerEvent('garages:addJobPlate', plate)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
	lastPlate = plate
	
	
  Wait(250)
  TriggerEvent('car:engine')
end)



RegisterNetEvent('medicg:c_helico')
AddEventHandler('medicg:c_helico', function()
	if lastPlate ~= nil then
		TriggerEvent("keys:remove",lastPlate)
	end
	

	local myPed = PlayerPedId()
	local player = PlayerId()
	local vehicle = `maverick`
	RequestModel(vehicle)
	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

  local plate = "EMS ".. GetRandomIntInRange(1000, 9000)
	local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 5.0, 0)
	local spawned_car = CreateVehicle(vehicle, coords, signInLocation[spawnNumber][1],signInLocation[spawnNumber][2],signInLocation[spawnNumber][3], true, false)

	--SetVehicleOnGroundProperly(spawned_car)
	SetVehicleNumberPlateText(spawned_car, plate)
  TriggerEvent("keys:addNew",spawned_car,plate)
  TriggerServerEvent('garages:addJobPlate', plate)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
	lastPlate = plate
	
	
end)
