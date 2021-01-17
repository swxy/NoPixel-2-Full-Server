local StripClubLocs = {
	[1] = { ["x"] = 129.55972290039, ["y"] = -1284.0889892578, ["z"] = 29.273847579956, ["h"] = 330.01126098633, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[2] = { ["x"] = 110.08145141602, ["y"] = -1288.5372314453, ["z"] = 28.858728408813, ["h"] = 294.58892822266, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[3] = { ["x"] = 118.07534790039, ["y"] = -1285.3544921875, ["z"] = 28.271654129028, ["h"] = 41.357799530029, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[4] = { ["x"] = 118.07534790039, ["y"] = -1285.3544921875, ["z"] = 28.271654129028, ["h"] = 41.357799530029, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[5] = { ["x"] = 110.87651062012, ["y"] = -1302.2821044922, ["z"] = 29.269477844238, ["h"] = 208.04776000977, ["name"] = "None", ["fnc"] = "privDance" },
	[6] = { ["x"] = 114.60884857178, ["y"] = -1304.6392822266, ["z"] = 29.269529342651, ["h"] = 26.301788330078, ["name"] = "None", ["fnc"] = "privDance" },
	[7] = { ["x"] = 112.65658569336, ["y"] = -1301.2724609375, ["z"] = 29.269222259521, ["h"] = 210.32331848145, ["name"] = "None", ["fnc"] = "privDance" },
	[8] = { ["x"] = 116.68322753906, ["y"] = -1303.419921875, ["z"] = 29.269504547119, ["h"] = 27.763551712036, ["name"] = "None", ["fnc"] = "privDance" },
	[9] = { ["x"] = 114.65414428711, ["y"] = -1300.1513671875, ["z"] = 29.268930435181, ["h"] = 202.61317443848, ["name"] = "None", ["fnc"] = "privDance" },
	[10] = { ["x"] = 118.77919006348, ["y"] = -1302.2064208984, ["z"] = 29.269376754761, ["h"] = 23.350383758545, ["name"] = "None", ["fnc"] = "privDance" },
	[11] = { ["x"] = 112.7876739502, ["y"] = -1305.6854248047, ["z"] = 29.264095306396, ["h"] = 27.397647857666, ["name"] = "None", ["fnc"] = "privDance" },
}

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

local StressRelief = false
RegisterNetEvent('stripclub:stressLoss');
AddEventHandler('stripclub:stressLoss', function(switchon)
	local frntDist = #(vector3(130.26553344727,-1301.1790771484,29.232746124268) - GetEntityCoords(PlayerPedId()))
	if frntDist < 50 then
	    if switchon then
	    	TriggerServerEvent("server:pass","strip_club")
	    else
	    	StressRelief = false
	    end
	end
end)
RegisterNetEvent('dostripstress');
AddEventHandler('dostripstress', function()
	StressRelief = true
	Citizen.Trace("no stress")
end)

Citizen.CreateThread( function()

	local scanned = false
	local scanwait = 0

	while true do 

		Citizen.Wait(1)
		if StressRelief then
			if math.random(1000) > 998 then
				TriggerEvent("client:newStress",false,math.random(200,1250))
			end
		end

		local frntDist = #(vector3(130.26553344727,-1301.1790771484,29.232746124268) - GetEntityCoords(PlayerPedId()))
		local bkDist = #(vector3(92.162353515625,-1282.2171630859,29.246534347534) - GetEntityCoords(PlayerPedId()))
		if frntDist > 50.0 then
			local waitTime = frntDist * 10
			Citizen.Wait(math.ceil(waitTime))
			if StressRelief then
				StressRelief = false
			end
		end

		if not scanned then
			scanned = findNPC(110.87651062012,-1302.2821044922,29.269477844238)
			if scanned then
				scanwait = 5000
			else
				if frntDist < 3 or bkDist < 3 then
					SpawnPeds(false)
			        Citizen.Wait(1)
					SpawnPeds(true)
					scanned = true
					scanwait = 5000
				end
			end
		end
	end
end)

function SpawnPeds(skipBar)
	for i = 1, 4 do
		if i == 1 and skipBar then
		else
			local pedType = randomStripClubPed()

			local x = StripClubLocs[i]["x"]
			local y = StripClubLocs[i]["y"]
			local z = StripClubLocs[i]["z"]
			local h = StripClubLocs[i]["h"]
	        RequestModel(pedType)
	        while not HasModelLoaded(pedType) do
	            Citizen.Wait(0)
	        end
	        local IsPedNearCoords = exports["isPed"]:IsPedNearCoords(x,y,z)
	        if not IsPedNearCoords then
	        	if GetPedType(pedType) ~= nil then

					local stripClubPed = CreatePed(GetPedType(pedType), pedType, x,y,z, h, 1, 1)
					DecorSetBool(stripClubPed, 'ScriptedPed', true)
					SetPedDropsWeaponsWhenDead(stripClubPed,false)

					if i == 1 then
						TaskStartScenarioAtPosition(stripClubPed, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", x,y,z, h, 0, 0, 1)
						FreezeEntityPosition(stripClubPed,true)
					else
						TaskWanderInArea(stripClubPed, x, y, z, 4.0, 2.0, 2.0)
					end

					SetPedComponentVariation(stripClubPed, 3, 1, 1, 1)
					SetPedAlertness(stripClubPed, 0)
					SetPedCombatAbility(stripClubPed, 0)
					SetPedCombatRange(stripClubPed, 0)
					SetPedTargetLossResponse(stripClubPed, 1)

			        SetPedSeeingRange(stripClubPed, 0.0)
			        SetPedHearingRange(stripClubPed, 0.0)
			        SetPedAlertness(stripClubPed, 0.0)


					netid = NetworkGetNetworkIdFromEntity(stripClubPed)
					SetNetworkIdCanMigrate(netid, true)
				end
			end
		end
	end
end



function randomStripClubPed()
	local math = math.random(6)
	ret = 695248020
	if math == 5 then
		ret = 1544875514
	elseif math == 4 then
		ret = 1846523796
	elseif math == 3 then
		ret = 1381498905		
	end
	return ret
end

function randomStripClubPed()
	local math = math.random(6)
	ret = 695248020
	if math == 5 then
		ret = 1544875514
	elseif math == 4 then
		ret = 1846523796
	elseif math == 3 then
		ret = 1381498905		
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
        if distance < 20.0 and (distanceFrom == nil or distance < distanceFrom) and isStripper(GetEntityModel(ped)) then
        	if IsEntityDead(ped) then
        		DeleteEntity(ped)
        	else
        		pedfound = true
        	end
        end
        success, ped = FindNextPed(handle)
    until not success or pedfound
    EndFindPed(handle)
    return pedfound
end

function isStripper(model)
	if model == 695248020 then
		return true
	end
	if model == 1544875514 then
		return true
	end
	if model == 1846523796 then
		return true
	end
	if model == 1381498905 then	
		return true
	end	
	return false
end

function privdance(ped)

	ClearPedSecondaryTask(ped)
	SetEntityCollision(ped,false,false)

	loadAnimDict( "mini@strip_club@private_dance@part1" )
	loadAnimDict( "mini@strip_club@private_dance@part2" )
	loadAnimDict( "mini@strip_club@private_dance@part3" )
  	
	TaskPlayAnim( ped, "mini@strip_club@private_dance@part1", "priv_dance_p1", 1.0, -1.0, -1, 0, 1, 0, 0, 0) 
	length = GetAnimDuration("mini@strip_club@private_dance@part1", "priv_dance_p1")
	Citizen.Wait(length)        	
	TaskPlayAnim( ped, "mini@strip_club@private_dance@part2", "priv_dance_p2", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@private_dance@part2", "priv_dance_p2")
	Citizen.Wait(length)  
	TaskPlayAnim( ped, "mini@strip_club@private_dance@part3", "priv_dance_p3", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@private_dance@part3", "priv_dance_p3")
	Citizen.Wait(length)  
	SetEntityCollision(ped,true,true)

end

