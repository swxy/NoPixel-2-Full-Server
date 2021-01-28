local curDoctors = 0
local isTriageEnabled = false

local hspLocs = {
	[1] = { ['x'] = 309.23,['y'] = -593.03,['z'] = 43.36,['h'] = 209.52, ["name"] = "[E] Check In", ["fnc"] = "DrawText3DTest" },
	[2] = { ["x"] = 307.93, ["y"] = -594.99, ["z"] = 43.29, ["h"] = 192.33, ["name"] = "[E] Prescriptions", ["fnc"] = "DrawText3DTest" },

	[3] = { ["x"] = 326.2477722168, ["y"] = -583.00897216797, ["z"] = 43.317371368408, ["h"] = 330.01126098633, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[4] = { ["x"] = 308.50784301758, ["y"] = -596.73718261719, ["z"] = 43.291816711426, ["h"] = 9.658652305603, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[5] = { ["x"] = 305.08477783203, ["y"] = -598.11743164063, ["z"] = 43.291816711426, ["h"] = 74.243743896484, ["name"] = "None", ["fnc"] = "RandomNPC" },

	[6] = { ["x"] = 331.91491699219, ["y"] = -576.86529541016, ["z"] = 43.317203521729, ["h"] = 66.368347167969, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[7] = { ["x"] = 344.10360717773, ["y"] = -586.115234375, ["z"] = 43.315013885498, ["h"] = 143.51832580566, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[8] = { ["x"] = 347.22564697266, ["y"] = -587.91693115234, ["z"] = 43.31504440307, ["h"] = 67.972259521484, ["name"] = "None", ["fnc"] = "RandomNPC" },

	[9] = { ["x"] = 329.59005737305, ["y"] = -581.37854003906, ["z"] = 43.317241668701, ["h"] = 86.95824432373, ["name"] = "None", ["fnc"] = "aiSCAN" },
	[10] = { ["x"] = 315.22637939453, ["y"] = -593.30419921875, ["z"] = 43.291805267334, ["h"] = 115.40777587891, ["name"] = "None", ["fnc"] = "aiSCAN" },
	[11] = { ["x"] = 353.38198852539, ["y"] = -588.38922119141, ["z"] = 43.315010070801, ["h"] = 61.995723724365, ["name"] = "None", ["fnc"] = "aiSCAN" },

	[12] = { ['x'] = 312.3,['y'] = -592.4,['z'] = 43.29,['h'] = 156.45, ["name"] = "[E] Results", ["fnc"] = "DrawText3DTest" },
	[13] = { ['x'] = 343.77,['y'] = -591.44,['z'] = 43.29, ["h"] = 164.47006225586, ["name"] = "[E] Check Up", ["fnc"] = "DrawText3DTest" },

}

RegisterNetEvent('event:control:hospitalization')
AddEventHandler('event:control:hospitalization', function(useID)
	if useID == 1 then
		loadAnimDict('anim@narcotics@trash')
		TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',1.0, 1.0, -1, 1, 0, 0, 0, 0)
		local finished = exports["np-taskbar"]:taskBar(1700,"Checking Credentials")
		if finished == 100 then
			if curDoctors > 0 and not isTriageEnabled then
				TriggerEvent("DoLongHudText","A doctor has been paged. Please take a seat and wait.",2)
				TriggerServerEvent("phone:triggerPager")
			else
				TriggerEvent("bed:checkin")
			end
		end
	elseif useID == 2 then
		DoHospitalCheck(1)
	elseif useID == 3 then
		DoHospitalCheck(2)
	elseif useID == 4 then
		DoHospitalCheck(3)

	end
end)
 
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

-- #MarkedForMarker
local scanned = false
local myspawns = {}
Citizen.CreateThread( function()

	
	local scanwait = 0

	while true do 
		Citizen.Wait(1)
		local hspDist = #(vector3(hspLocs[1]["x"],hspLocs[1]["y"],hspLocs[1]["z"]) - GetEntityCoords(PlayerPedId()))
		local hspDist2 = #(vector3(hspLocs[2]["x"],hspLocs[2]["y"],hspLocs[2]["z"]) - GetEntityCoords(PlayerPedId()))
		local hspDist3 = #(vector3(hspLocs[12]["x"],hspLocs[12]["y"],hspLocs[12]["z"]) - GetEntityCoords(PlayerPedId()))
		local hspDist4 = #(vector3(hspLocs[13]["x"],hspLocs[13]["y"],hspLocs[13]["z"]) - GetEntityCoords(PlayerPedId()))

		--[[
		if hspDist > 50.0 then
			local waitTime = hspDist * 10
			Citizen.Wait(math.ceil(waitTime))
    		if #myspawns > 0 then
    			for i = 1, #myspawns do
    
    				SetEntityAsNoLongerNeeded(myspawns[i],true)
    			end
    		end
    		myspawns = {}
		end
		]]

		if hspDist < 5 then
			--if not scanned then
				--TriggerEvent("SpawnPeds")
			--end
		    local displayText = (curDoctors > 0 and not isTriageEnabled) and 'Press [E] to page a doctor' or hspLocs[1]["name"]
			DrawText3DTest(hspLocs[1]["x"],hspLocs[1]["y"],hspLocs[1]["z"], displayText)
		end
		if hspDist2 < 5 then		
			DrawText3DTest(hspLocs[2]["x"],hspLocs[2]["y"],hspLocs[2]["z"], hspLocs[2]["name"])
		end

		if hspDist3 < 5 then
			DrawText3DTest(hspLocs[12]["x"],hspLocs[12]["y"],hspLocs[12]["z"], hspLocs[12]["name"])
		end
		if hspDist4 < 5 then	
			DrawText3DTest(hspLocs[13]["x"],hspLocs[13]["y"],hspLocs[13]["z"], hspLocs[13]["name"])
		end

		if hspDist > 80.0 then
			Wait(5000)
		end
	end

end)

local checkupCounter = 45 + math.random(10,25)
local hospitalization = {}
local myspawns = {}
local skipCheckup = false
hospitalization.level = 0
hospitalization.illness = "None"
hospitalization.time = 0
--     level,illness,time = getHospitalization(cid)
RegisterNetEvent("client:hospitalization:status")
AddEventHandler("client:hospitalization:status", function(passedVar1,passedVar2,passedVar3)
	hospitalization.level = passedVar1
	hospitalization.illness = passedVar2
	hospitalization.time = passedVar3
	if hospitalization.illness == "icu" and not ICU then
		ICUscreen(false)
		return
	end		

	if hospitalization.illness == "dead" and not ICU then
		ICUscreen(true)
		return
	end	

end)

local mychecktype = 0
function DoHospitalCheck(typeofcheck)
	loadAnimDict('anim@narcotics@trash')
    TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1500, 49, 3.0, 0, 0, 0)
	local finished = exports["np-taskbar"]:taskBar(10000,"Checking Credentials")
    if finished == 100 then
		if hospitalization.level > 0 and skipCheckup and typeofcheck == mychecktype then
			skipCheckup = false
			TriggerEvent("client:newStress",false,math.ceil(math.random(500)))
			local newlvl = hospitalization.level - 1
			hospitalization.level = newlvl
			TriggerServerEvent("stress:illnesslevel",newlvl)
			TriggerEvent("chatMessage", "EMAIL ", 8, "You are looking healthier already! Successful Checkup ")
		else
			TriggerEvent("DoLongHudText","It appears your name isnt on this list? Please wait for a call.",1)
		end
	end
end




function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end


--sounds
--heartmonbeat
--heartmondead
--ventilator
--TriggerEvent("InteractSound_CL:PlayOnOne","heartmonbeat",0.1)
ICU = false
dead = false
local counter = 0
function ICUscreen(dying)
	counter = 0
	ICU = true
	dead = false
	while ICU do
		SetEntityCoords(PlayerPedId(),345.02133178711,-590.51824951172,60.109081268311)
		FreezeEntityPosition(PlayerPedId(),true)	
		SetEntityHealth(PlayerPedId(), 200.0)
		SetEntityInvincible(PlayerPedId(),true)
		Citizen.Wait(2300)
		if math.random(15) > 14 then
			TriggerEvent("changethirst")
			TriggerEvent("changehunger")
		end
		TriggerEvent("InteractSound_CL:PlayOnOne","ventilator",0.2)

		counter = counter + 1

		if counter > 20 then
			dead = true
		end

		if dead then

			if dying then
				TriggerEvent("InteractSound_CL:PlayOnOne","heartmondead",0.5)
				Citizen.Wait(9500)
			end

			ICU = false
			logout()
			return

		end

	end

end

function logout()
	TriggerEvent("np-base:clearStates")
	exports["np-base"]:getModule("SpawnManager"):Initialize()
end

Citizen.CreateThread( function()
	while true do 
		if ICU then
			DrawRect(0,0, 10.0, 10.0, 1, 1, 1, 255)
			DisableControlAction(0, 47, true)
		end
		Citizen.Wait(1)
	end
end)
local checktypes = {
	[1] = "Prescription Pickup",
	[2] = "Result Review",
	[3] = "Injury Checkup"
}
Citizen.CreateThread( function()
	while true do 
		Citizen.Wait(60000)
		if hospitalization.illness == "ICU" and not ICU then
			ICUscreen(false)
		end		
		if hospitalization.illness == "DEAD" and not ICU then
			ICUscreen(true)
		end		
		if checkupCounter > 0 then
			if hospitalization.level > 0 and checkupCounter == 45 and not skipCheckup then
				mychecktype = math.random(1,3)

				TriggerEvent("chatMessage", "EMAIL ", 8, "You are ready for your next " .. checktypes[mychecktype] .. " at the hospital! (Regarding: "..hospitalization.illness..") Failure to report may be bad for your health.")
				skipCheckup = true
			end			
			checkupCounter = checkupCounter - 1
		else
			checkupCounter = 60 + math.random(80)			
			if hospitalization.level > 0 then
				if skipCheckup then
					TriggerEvent("client:newStress",true,math.random(500))
				end
			end
		end
	end
end)

RegisterNetEvent("job:counts")
AddEventHandler("job:counts", function(activePolice,activeEms,activeTaxi,activeTow, activeDoctors)
    curPolice = activePolice
    curEms = activeEms
    curTaxi = activeTaxi
    curTow = activeTow
    curDoctors = activeDoctors
end)

AddEventHandler("playerSpawned", function()
	TriggerServerEvent('doctor:setTriageState')
	TriggerEvent("loading:disableLoading")
end)

RegisterNetEvent("doctor:setTriageState")
AddEventHandler("doctor:setTriageState", function(pState)
	isTriageEnabled = pState
end)

RegisterNetEvent("SpawnPeds")
AddEventHandler("SpawnPeds", function()
	scanned = true
	for i = 3, 9 do
		local pedType = hspLocs[i]["fnc"]

		pedType = 1092080539


		local x = hspLocs[i]["x"]
		local y = hspLocs[i]["y"]
		local z = hspLocs[i]["z"]
		local h = hspLocs[i]["h"]

        RequestModel(pedType)

        while not HasModelLoaded(pedType) do
            Citizen.Wait(0)
        end

        local IsPedNearCoords = exports["isPed"]:IsPedNearCoords(x,y,z)
        if not IsPedNearCoords then

        	if GetPedType(pedType) ~= nil then
				local hospPed = CreatePed(GetPedType(pedType), pedType, x,y,z, h, 1, 1)
				DecorSetBool(hospPed, 'ScriptedPed', true)
				myspawns[#myspawns+1] = hospPed

				TaskStartScenarioAtPosition(hospPed, randomScenario(), x,y,z, h, 0, 0, 1)
				
				SetEntityInvincible(hospPed, true)
				if i < 6 then
		            TaskSetBlockingOfNonTemporaryEvents(hospPed, true)
		        end
	            SetPedFleeAttributes(hospPed, 0, 0)
	            SetPedCombatAttributes(hospPed, 17, 1)

	            SetPedSeeingRange(hospPed, 0.0)
	            SetPedHearingRange(hospPed, 0.0)
	            SetPedAlertness(hospPed, 0)
				SetPedKeepTask(hospPed, true)


			end
		
		end

	end
	Citizen.Wait(10000)
	scanned = false
end)



function randomHspPed()
	local math = math.random(6)
	ret = 1092080539
	if math == 5 then
		ret = 1092080539
	elseif math == 4 then
		ret = 1092080539
	elseif math == 3 then
		ret = 1092080539		
	end
	return ret
end

function randomScenario()
	local math = math.random(10)
	ret = "WORLD_HUMAN_CLIPBOARD"
	if math == 5 then
		ret = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT"
	elseif math < 4 then
		ret = "CODE_HUMAN_MEDIC_TIME_OF_DEATH"
	end

	return ret
end
function findNPC(x,y,z)
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    local pedfound = false
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(vector3(x,y,z) - pos)
        if distance < 11.0 and (distanceFrom == nil or distance < distanceFrom) then
        	pedfound = true
        end
        success, ped = FindNextPed(handle)
    until not success or pedfound
    EndFindPed(handle)
    return pedfound
end