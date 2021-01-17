onJob = 0
isSignedIn = false
mypayambulance = 0
local lastPatient = nil

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
	if job == "ems" then
		isSignedIn = true
	else
		isSignedIn = false
		StopJob()
	end
end)

AddEventHandler('np-base:playerSessionStarted', function()
	RequestModel(0xC703DB5F)
	while not HasModelLoaded(0xC703DB5F) do
		Wait(1)
	end

	RequestModel(0xe52e126c)
	while not HasModelLoaded(0xe52e126c) do
		Wait(1)
	end
end)

jobs = {peds = {}, flag = {}, blip = {}, cars = {}, coords = {cx={}, cy={}, cz={}}}

function StartJob(jobid)
	if jobid == 1 then -- ambulance
		showLoadingPromt("Loading EMS mission", 2000, 3)
		-- Hospital heal points
		jobs.coords.cx[1],jobs.coords.cy[1],jobs.coords.cz[1] = 363.92,-586.94,28.68
		jobs.coords.cx[2],jobs.coords.cy[2],jobs.coords.cz[2] = -453.97,-339.53,34.36
		jobs.coords.cx[3],jobs.coords.cy[3],jobs.coords.cz[3] = 1843.39,3667.17,33.70
		jobs.coords.cx[4],jobs.coords.cy[4],jobs.coords.cz[4] = -239.13,6334.14,32.35
		jobs.coords.cx[5],jobs.coords.cy[5],jobs.coords.cz[5] = 297.44,-1441.96,29.80
		jobs.coords.cx[6],jobs.coords.cy[6],jobs.coords.cz[6] = -677.92,295.53,82.10
		jobs.coords.cx[7],jobs.coords.cy[7],jobs.coords.cz[7] = 1153.57,-1512.72,34.69
		jobs.coords.cx[8],jobs.coords.cy[8],jobs.coords.cz[8] = -876.66,-295.43,39.77

		--jobs.coords.cx[3],jobs.coords.cy[3],jobs.coords.cz[3] = -449.67, 6331.23, 34.50


		jobs.cars[1] = GetVehiclePedIsUsing(PlayerPedId())
		jobs.flag[1] = 0
		jobs.flag[2] = 259+GetRandomIntInRange(1, 61)
		Wait(2000)
		DrawMissionText("Drive around until you get a ~h~~y~call~w~.", 10000)
		onJob = jobid
	end
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function DrawMissionText(m_text, showtime)
  ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function showLoadingPromt(showText, showTime, showType)
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		N_0xaba17d7ce615adbf("STRING") -- set type
		AddTextComponentString(showText) -- sets the text
		N_0xbd12f8228410d9b4(showType) -- show promt (types = 3)
		Citizen.Wait(showTime) -- show time
		N_0x10d373323e5b9c0d() -- remove promt
	end)
end

function StopJob(jobid)
	if jobid == 1 then
		if DoesEntityExist(jobs.peds[1]) then
			lastPatient = jobs.peds[1]
			local pedb = GetBlipFromEntity(jobs.peds[1])
			if pedb ~= nil and DoesBlipExist(pedb) then
				SetBlipSprite(pedb, 2)
				SetBlipDisplay(pedb, 3)
			end
			SetEntityHealth(jobs.peds[1], GetEntityMaxHealth(jobs.peds[1]))
			ClearPedTasksImmediately(jobs.peds[1])
			if DoesEntityExist(jobs.cars[1]) and IsVehicleDriveable(jobs.cars[1], 0) then
				if IsPedSittingInVehicle(jobs.peds[1], jobs.cars[1]) then
					TaskLeaveVehicle(jobs.peds[1], jobs.cars[1], 0)
				end
			end
			Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))
		end
		if jobs.blip[1] ~= nil and DoesBlipExist(jobs.blip[1]) then
			Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(jobs.blip[1]))
			jobs.blip[1] = nil
		end
		onJob = 0
		jobs.cars[1] = nil
		jobs.peds[1] = nil
		jobs.flag[1] = nil
		jobs.flag[2] = nil
	end
end

RegisterNetEvent('nowIsEMS')
AddEventHandler('nowIsEMS', function(cb)
  cb(onJob > 0)
end)

RegisterNetEvent("nowUnemployed")
AddEventHandler("nowUnemployed", function()
	onJob = 0
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if onJob == 0 and isSignedIn == true then
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()), GetHashKey("ambulance", _r)) then
					StartJob(1)
				end
			end
		elseif onJob == 1 then
			if DoesEntityExist(jobs.cars[1]) and IsVehicleDriveable(jobs.cars[1], 0) then
				if IsPedSittingInVehicle(PlayerPedId(), jobs.cars[1]) then
					if DoesEntityExist(jobs.peds[1]) then
						lastPatient = jobs.peds[1]
						if IsPedFatallyInjured(jobs.peds[1]) then
							Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))
							local pedb = GetBlipFromEntity(jobs.peds[1])
							if pedb ~= nil and DoesBlipExist(pedb) then
								SetBlipSprite(pedb, 2)
								SetBlipDisplay(pedb, 3)
							end
							jobs.peds[1] = nil
							jobs.flag[1] = 0
							jobs.flag[2] = 59+GetRandomIntInRange(1, 90)
							if jobs.blip[1] ~= nil and DoesBlipExist(jobs.blip[1]) then
								Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(jobs.blip[1]))
								jobs.blip[1] = nil
							end
							DrawMissionText("The patient ~r~passed away~w~. Drive around until you get another call.", 5000)
						else
							if jobs.flag[1] == 1 and jobs.flag[2] > 0 then
								Wait(2000)
								jobs.flag[2] = jobs.flag[2]-1
								if jobs.flag[2] == 0 then
									lastPatient = jobs.peds[1]
									local pedb = GetBlipFromEntity(jobs.peds[1])
									if pedb ~= nil and DoesBlipExist(pedb) then
										SetBlipSprite(pedb, 2)
										SetBlipDisplay(pedb, 3)
									end
									SetEntityHealth(jobs.peds[1], 0)
									ClearPedTasksImmediately(jobs.peds[1])
									Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))
									jobs.peds[1] = nil
									DrawMissionText("The patient ~r~passed away~w~ while on route. Drive around until you get another ~h~~y~request~w~.", 5000)
									jobs.flag[1] = 0
									jobs.flag[2] = 259+GetRandomIntInRange(1, 61)
								else
									if IsPedSittingInVehicle(PlayerPedId(), jobs.cars[1]) then
										if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(jobs.peds[1])) < 15.0001 then
											local offs = GetOffsetFromEntityInWorldCoords(GetVehiclePedIsUsing(PlayerPedId()), 1.5, 0.0, 0.0)
											local offs2 = GetOffsetFromEntityInWorldCoords(GetVehiclePedIsUsing(PlayerPedId()), -1.5, 0.0, 0.0)
											if #(vector3(offs['x'], offs['y'], offs['z']) - GetEntityCoords(jobs.peds[1])) < #(vector3(offs2['x'], offs2['y'], offs2['z']) - GetEntityCoords(jobs.peds[1])) then
												TaskEnterVehicle(jobs.peds[1], jobs.cars[1], -1, 2, 2.0001, 1)
											else
												TaskEnterVehicle(jobs.peds[1], jobs.cars[1], -1, 1, 2.0001, 1)
											end
											jobs.flag[1] = 2
											jobs.flag[2] = 30
										end
									end
								end
							end
							if jobs.flag[1] == 2 and jobs.flag[2] > 0 then
								Wait(2000)
								jobs.flag[2] = jobs.flag[2]-1
								if jobs.flag[2] == 0 then
									lastPatient = jobs.peds[1]
									local pedb = GetBlipFromEntity(jobs.peds[1])
									if pedb ~= nil and DoesBlipExist(pedb) then
										SetBlipSprite(pedb, 2)
										SetBlipDisplay(pedb, 3)
									end
									SetEntityHealth(jobs.peds[1], GetEntityMaxHealth(jobs.peds[1]))
									ClearPedTasksImmediately(jobs.peds[1])
									Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))
									jobs.peds[1] = nil
									DrawMissionText("~r~The patient is not going with you~w~. Drive around until you get another ~h~~y~request~w~.", 5000)
									jobs.flag[1] = 0
									jobs.flag[2] = 259+GetRandomIntInRange(1, 61)
								else
									if IsPedSittingInVehicle(jobs.peds[1], jobs.cars[1]) then
										local pedb = GetBlipFromEntity(jobs.peds[1])
										lastPatient = jobs.peds[1]					

										if pedb ~= nil and DoesBlipExist(pedb) then
											SetBlipSprite(pedb, 2)
											SetBlipDisplay(pedb, 3)
										end
										jobs.flag[1] = 3
										jobs.flag[2] = GetRandomIntInRange(1, 8)
										local street = table.pack(GetStreetNameAtCoord(jobs.coords.cx[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]],jobs.coords.cz[jobs.flag[2]]))
										if street[2] ~= 0 and street[2] ~= nil then
											local streetname = string.format("~w~Take me to~y~ %s~w~, nearby~y~ %s", GetStreetNameFromHashKey(street[1]),GetStreetNameFromHashKey(street[2]))
											DrawMissionText(streetname, 5000)
										else
											local streetname = string.format("~w~Take me to the~y~ %s", GetStreetNameFromHashKey(street[1]))
											DrawMissionText(streetname, 5000)
										end
										local location = GetEntityCoords(PlayerPedId(), 0)
										mypayambulance = CalculateTravelDistanceBetweenPoints( location, jobs.coords.cx[jobs.flag[2]], jobs.coords.cy[jobs.flag[2]], jobs.coords.cz[jobs.flag[2]] )
										mypayambulance = mypayambulance * 0.25
										mypayambulance = math.ceil(mypayambulance)

										if mypayambulance > 250 then
											mypayambulance = 250
										end

										jobs.blip[1] = AddBlipForCoord(jobs.coords.cx[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]],jobs.coords.cz[jobs.flag[2]])

										AddTextComponentString(GetStreetNameFromHashKey(street[1]))
										N_0x80ead8e2e1d5d52e(jobs.blip[1])
										SetBlipRoute(jobs.blip[1], 1)
									end
								end
							end
							if jobs.flag[1] == 3 then
								if #(GetEntityCoords(PlayerPedId()) - vector3(jobs.coords.cx[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]],jobs.coords.cz[jobs.flag[2]])) > 2.0001 then
									DrawMarker(27, jobs.coords.cx[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]],jobs.coords.cz[jobs.flag[2]]-1.0001, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
								else
									Wait(500)
									lastPatient = jobs.peds[1]
									if jobs.blip[1] ~= nil and DoesBlipExist(jobs.blip[1]) then
										Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(jobs.blip[1]))
										jobs.blip[1] = nil
									end

									SetEntityHealth(jobs.peds[1], GetEntityMaxHealth(jobs.peds[1]))
									ClearPedTasksImmediately(jobs.peds[1])
									if DoesEntityExist(jobs.cars[1]) then
										if IsPedSittingInVehicle(jobs.peds[1], jobs.cars[1]) then
											TaskLeaveVehicle(jobs.peds[1], jobs.cars[1], 0)
										end
									end
									Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))

									jobs.peds[1] = nil
									Wait(2000)

	                DrawMissionText("~g~You have delivered the patient!", 5000)								    
									local util = exports["np-base"]:getModule("Util")
									util:MissionText("You gained ~g~$"..mypayambulance.."~w~", 5000)
									TriggerServerEvent('mission:completed', mypayambulance)
									Wait(2000)
									DrawMissionText("Drive around until you get another ~h~~y~request~w~.", 10000)
									jobs.flag[1] = 0
									jobs.flag[2] = 59+GetRandomIntInRange(1, 90)
								end
							end
						end
					else
						Wait(20000)
						-- Don't look for jobs if we already have someone in the back
						if isSignedIn == true and (IsVehicleSeatFree(jobs.cars[1], 1) and IsVehicleSeatFree(jobs.cars[1], 2)) and GetRandomIntInRange(0, 100) > 75 then							
							local pos = GetEntityCoords(PlayerPedId())
							local randX = GetRandomIntInRange(35, 155)
							local randY = GetRandomIntInRange(35, 155)
							local randZ = GetRandomIntInRange(35, 55)
							local rped = GetRandomPedAtCoord(pos['x'], pos['y'], pos['z'], randX + .001, randY + .001, randZ + .001, 6, _r)
							if DoesEntityExist(rped) and GetPedType(rped) ~= 28 and lastPatient ~= rped then
								jobs.peds[1] = rped
								jobs.flag[1] = 1
								SetEntityHealth(jobs.peds[1], GetEntityMaxHealth(jobs.peds[1])/2)
								jobs.flag[2] = 19+GetRandomIntInRange(1, 21)
								ClearPedTasksImmediately(jobs.peds[1])
								local randAnim = GetRandomIntInRange(1, 3)
								if randAnim == 1 then
									TaskStartScenarioInPlace(jobs.peds[1], "WORLD_HUMAN_BUM_STANDING", 0, true);
								elseif randAnim == 2 then
									TaskStartScenarioInPlace(jobs.peds[1], "WORLD_HUMAN_BUM_SLUMPED", 0, true);
								elseif randAnim == 3 then
									TaskStartScenarioInPlace(jobs.peds[1], "PROP_HUMAN_STAND_IMPATIENT", 0, true);
								end
								SetBlockingOfNonTemporaryEvents(jobs.peds[1], 1)
								DrawMissionText("The ~g~patient~w~ is waiting for you. Drive nearby", 5000)
								local lblip = AddBlipForEntity(jobs.peds[1])
								SetBlipAsFriendly(lblip, 1)
								SetBlipColour(lblip, 2)
								SetBlipCategory(lblip, 3)
							else
								jobs.flag[1] = 0
								jobs.flag[2] = 59+GetRandomIntInRange(1, 90)
								DrawMissionText("Drive around until you get another ~h~~y~request~w~.", 10000)
							end
						end
					end
				else
					if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(jobs.cars[1])) > 30.0001 then
						StopJob(1)
					else
						DrawMissionText("Get back in your car to ~y~continue~w~. Or go away from the ambulance to ~r~stop~ the mission.", 1)
					end
				end
			else
				StopJob(1)
				DrawMissionText("The ambulance is ~h~~r~destroyed~w~.", 5000)
			end
		end
	end
end)
