local chopshop = {}
local myChop = 0
chopshop["x"] = 0
chopshop["y"] = 0
chopshop["z"] = 0
local locationset = false
local plateshop = {}
plateshop["x"] = 0
plateshop["y"] = 0
plateshop["z"] = 0
local lockedplates = {}
local chopshopowner = 9999999

local randstrng = {
  [1] = "Just got another hot vehicle, taking it to the garage near ",
  [2] = "Bringing the stolen car to ",
  [3] = "We just moved the shop, anyone listening its near ",
  [4] = "Cops got close, we moved the shop to ",
  [5] = "We need cars delivered to "
}

local randstrng2 = {
  [1] = "Got some tools, taking it to the garage near ",
  [2] = "Bringing the parts to ",
  [3] = "We just moved the parts shop, anyone listening its near ",
  [4] = "Cops got close, we moved the parts shop to ",
  [5] = "We need parts delivered to "
}

local values = {
  [1] = { ["text"] = "Engine Parts", ["factor"] = "fInitialDriveMaxFlatVel", ["min"] = 0, ["max"] = 400, ["sales"] = 0, ["item"] = 'EnginePart' },
  [2] = { ["text"] = "Suspension Parts", ["factor"] = "fSuspensionForce", ["min"] = 0, ["max"] = 5, ["sales"] = 0, ["item"] = 'SuspensionPart'  },
  [3] = { ["text"] = "Dampener Parts", ["factor"] = "fSuspensionCompDamp", ["min"] = 0, ["max"] = 2, ["sales"] = 0, ["item"] = 'DampenerPart' },
  [4] = { ["text"] = "Tyre Parts", ["factor"] = "fSteeringLock", ["min"] = 18, ["max"] = 40, ["sales"] = 0, ["item"] = 'TyrePart' },
  [5] = { ["text"] = "Metal Parts", ["factor"] = "fMass", ["min"] = 0, ["max"] = 3300, ["sales"] = 0 , ["item"] = 'MetalPart' },
  [6] = { ["text"] = "Aerodynamics", ["factor"] = "fDownforceModifier", ["min"] = 0, ["max"] = 2, ["sales"] = 0, ["item"] = 'AerodynamicsPart' },
  [7] = { ["text"] = "Braking Parts", ["factor"] = "fBrakeForce", ["min"] = 0, ["max"] = 1, ["sales"] = 0, ["item"] = 'BrakingPart' },
  [8] = { ["text"] = "Gearbox Parts", ["factor"] = "fClutchChangeRateScaleUpShift", ["min"] = 0, ["max"] = 7, ["sales"] = 0, ["item"] = 'GearboxPart' },  
}

local partCoords = {
	[1] = { ["x"] = 962.96600341797, ["y"] = -2992.7954101563, ["z"] = -39.646957397461 },
	[2] = { ["x"] = 959.38641357422, ["y"] = -2991.6372070313, ["z"] = -39.646957397461 },
	[3] = { ["x"] = 959.38641357422, ["y"] = -2991.6372070313, ["z"] = -39.646957397461 },
	[4] = { ["x"] = 954.32318115234, ["y"] = -3005.0522460938, ["z"] = -39.646957397461 },
	[5] = { ["x"] = 986.08941650391, ["y"] = -2990.4270019531, ["z"] = -39.646957397461 },
	[6] = { ["x"] = 1009.0650024414, ["y"] = -3012.1428222656, ["z"] = -39.646942138672 },
	[7] = { ["x"] = 986.30316162109, ["y"] = -3015.3999023438, ["z"] = -39.646953582764 },
	[8] = { ["x"] = 977.38861083984, ["y"] = -2988.9206542969, ["z"] = -39.646953582764 }
}

blipparts = 0
blipchop = 0
local streetnamesentc = "none"
local streetnamesentp = "none"
RegisterNetEvent("chopshop:updatePlateLocation")
AddEventHandler("chopshop:updatePlateLocation", function(x,y,z)

	local rank = GroupRank("parts_shop")
	if rank > 1 then

		RemoveBlip(blipparts)
		blipparts = AddBlipForCoord(x, y, z)
		SetBlipSprite(blipparts, 52)
		SetBlipScale(blipparts, 0.7)
		SetBlipColour(blipparts, 14)
		SetBlipAsShortRange(blipparts, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Parts Shop")
		EndTextCommandSetBlipName(blipparts)


		local dist = #(vector3(x,y,z) - GetEntityCoords(PlayerPedId()))
		if dist > 2000.0 then
			return
		end

	    plateshop["x"],plateshop["y"],plateshop["z"] = x,y,z
		local streetnamesentPP = GetStreetNameAtCoord(plateshop["x"],plateshop["y"],plateshop["z"])
		streetnamesentPP = GetStreetNameFromHashKey(streetnamesentPP)
		
	    locationset = true
		local radiocount = exports["np-inventory"]:getQuantity("scanner")

		if radiocount > 0 and streetnamesentp ~= streetnamesentPP then
			streetnamesentp = streetnamesentPP
			TriggerEvent("chatMessage", "SCANNER : ", {255, 0, 0}, randstrng2[math.random(#randstrng2)] .. "" .. streetnamesentp)
		end
	end

end)

local toupdateValues = {}

RegisterNetEvent("chopshop:owner")
AddEventHandler("chopshop:owner", function(newowner)

end)

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

RegisterNetEvent("chopshop:updateLocation")
AddEventHandler("chopshop:updateLocation", function(x,y,z,valuesSent,cidowner)

	local cid = exports["isPed"]:isPed("cid")
	local rank = GroupRank("chop_shop")

	if tonumber(rank) > 1 then

		RemoveBlip(blipchop)
		blipchop = AddBlipForCoord(x, y, z)
		SetBlipSprite(blipchop, 52)
		SetBlipScale(blipchop, 0.7)
		SetBlipColour(blipchop, 14)
		SetBlipAsShortRange(blipchop, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Chop Shop")
		EndTextCommandSetBlipName(blipchop)


		local dist = #(vector3(x,y,z) - GetEntityCoords(PlayerPedId()))
		if dist > 2000.0 then
			return
		end
	    chopshop["x"],chopshop["y"],chopshop["z"] = x,y,z

	    locationset = true

		values = valuesSent

	end

end)

RegisterNetEvent("chopshop:currentValues")
AddEventHandler("chopshop:currentValues", function()
	for i = 1, #values do
		local stockvalue = 100 - values[i]["sales"]
		local str = values[i]["text"] .. " stock drive " .. stockvalue .. "%"
		TriggerEvent("DoLongHudText",str,i)
	end
end)

RegisterNetEvent("chopshop:valueVehicle")
AddEventHandler("chopshop:valueVehicle", function()
	valueVehicle()
end)

function valueVehicle()

	local iAmHorrible = {}

	local totalValue = 0

	for i = 1, #values do
		local factor = values[i]["factor"]
		local text = values[i]["text"]
		local sales = values[i]["sales"]
		local min = values[i]["min"]
		local max = values[i]["max"]
		local value = GetVehicleHandlingFloat(myChop, 'CHandlingData', factor)
		if value > max then
			value = max
		end
		value = ((value / max) * 400)
		value = math.ceil(value)	
		Citizen.Trace(factor .. " = " .. value .. " - " .. sales)
		toupdateValues[i] = { ["value"] = math.ceil(value), ["factor"] = factor, ["sales"] = sales }
		value = value - sales
		value = value / 2.5
		if value > 1000 then
			value = 1000
		end
		totalValue = math.ceil(totalValue + value)

		TriggerEvent("DoLongHudText", text .. " valued at $" .. value,1 )
	end

	TriggerServerEvent("server:GroupPayment","chop_shop",totalValue)
	
	TriggerEvent("DoLongHudText", "Total Parts Value: " .. totalValue,1 )
	deductValuesTotal(toupdateValues,totalValue)

end

function getKeysSortedByValue(tbl, sortFunction)

	local keys = {}
	for key in pairs(tbl) do
	keys[#keys+1]= key
	end

	table.sort(keys, function(a, b)
	return sortFunction(tbl[a], tbl[b])
	end)

	local penis = -4
	for _, key in ipairs(keys) do
		Citizen.Trace(key)
		local cocks = values[key]["sales"]
		values[key]["sales"] = cocks + penis
		Citizen.Trace(values[key]["factor"] .. " new value is now " .. values[key]["sales"])
		penis = penis + 1
		if penis == 0 then
			penis = 1
		end
	end

	return values
end

function chopDeliveryAvailable()
	local activeTasks = exports["isPed"]:isPed("tasks")
	local taskavailable = false
	for i = 1, #activeTasks do
		if activeTasks[i] ~= nil then
		  if activeTasks[i]["Group"] == "chop_shop" and (activeTasks[i]["TaskState"] == 1 or activeTasks[i]["TaskState"] == 2) then
		    taskavailable = true
		  end
		end
	end
	return taskavailable
end

function deductValuesTotal(toupdateValues,totalValue)
	local newvalues = getKeysSortedByValue(toupdateValues, function(a, b) return a["value"] < b["value"] end)
	TriggerServerEvent("chop:ServerCompleteCar",newvalues,totalValue)
end

function DrawText3DTest(x,y,z, text, dicks,power)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if onScreen then
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
end

taskNumber = 1
inprocess = false
carrying = false
local zz = false

local hotPlates = {}
local hotPlatesReason = {}
RegisterNetEvent("updateHotPlates")
AddEventHandler("updateHotPlates", function(newPlates,newReasons)
	hotPlates = newPlates
	hotPlatesReason = newReasons
end)
RegisterNetEvent("updateHotPlatesSingle")
AddEventHandler("updateHotPlatesSingle", function(newPlate,newReason)
	hotPlates[#hotPlates+1] = newPlate
	hotPlatesReason[#hotPlatesReason+1] = newReason
end)



function isHotVehicle(plate)
    if hotPlates[string.upper(plate)] ~= nil or hotPlates[string.lower(plate)] ~= nil or hotPlates[plate] ~= nil then
        return true
    else
        return false
    end
end

RegisterNetEvent("chopshop:taskItem")
AddEventHandler("chopshop:taskItem", function(z)
	
	zz = z
	Citizen.Trace("doing item stuffs heh")
	if zz then

		RequestAnimDict('anim@heists@box_carry@')
		while not HasAnimDictLoaded("anim@heists@box_carry@") do
			Citizen.Wait(0)
		end

		TriggerEvent("attachItemChop",values[taskNumber]["item"])

		while zz do

			Citizen.Wait(1)

			if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then
				TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
			end

		end		

	else
		TriggerEvent("attachRemoveChopShop")
		Citizen.Wait(100)
		ClearPedTasksImmediately(PlayerPedId())
	end			
end)

local front = 0
local back = 0

Citizen.CreateThread(function()

	--SetEntityCoords(PlayerPedId(),976.81365966797,-3001.3740234375,-39.603717803955)
	while true do
		Wait(1)
		local pos = GetEntityCoords( PlayerPedId() )
		if #(vector3(194.74269104004,-1005.3385620117,-98.999961853027) - pos) < 1 then
			TriggerEvent("DoShortHudText", "Please Move.",2)
			Citizen.Wait(2000)
		end

		if locationset then

			local playerPed = PlayerPedId()
			local currentVehicle = GetVehiclePedIsIn(playerPed, false)
			local driverPed = GetPedInVehicleSeat(currentVehicle, -1)
			local pos = GetEntityCoords( PlayerPedId() )
			local posChop = GetEntityCoords( myChop )
			local pltcheck = "none"
			


		if taskNumber < 9 and myChop ~= 0 and #(vector3(976.81365966797,-3001.3740234375,-39.603717803955) - pos) < 100.0 then	
			if not IsPedInVehicle(PlayerPedId(),currentVehicle,false) then	
				local postup = GetOffsetFromEntityInWorldCoords(myChop, 0.0, 2.5, 0.0)	
				local postback = GetOffsetFromEntityInWorldCoords(myChop, 0.0, -2.5, 0.0)	
				local distance = #(postup - pos)	
				local distanceb = #(postback - pos)	
				local carDir = GetEntityHeading(myChop)	
				local myDir = GetEntityHeading(PlayerPedId())	
			


				if distance < 1.5 and not inprocess and front == 0 then	
					if isOppositeDir(carDir,myDir) then	
						DrawText3DTest(postup["x"],postup["y"],postup["z"], "Press E to remove " .. values[taskNumber]["text"], 255,true)	
						if IsControlJustReleased(2, 38) then	
							inprocess = true	
							playDrill()	
							Citizen.Wait(200)	
						end	
					else	
						DrawText3DTest(postup["x"],postup["y"],postup["z"], "Face the vehicle to work on it.", 255,true)	
					end	
				else	
					if distance < 5.5 and not inprocess then	
						DrawText3DTest(postup["x"],postup["y"],postup["z"], "Move to the vehicle to work on it.", 255,true)	
					end	
				end	

				local distance = #(vector3(partCoords[taskNumber]["x"], partCoords[taskNumber]["y"], partCoords[taskNumber]["z"]) - pos)	
				if inprocess and distance < 55.0 then	
					-- search and draw task location	
					DrawText3DTest(partCoords[taskNumber]["x"], partCoords[taskNumber]["y"], partCoords[taskNumber]["z"], "Press E to place your " .. values[taskNumber]["text"], 255,true)	
					if IsControlJustReleased(2, 38) and distance < 5.0 then	
						inprocess = false	
						TriggerEvent("chopshop:taskItem",false)	
						taskNumber = taskNumber + 1	
						if taskNumber > 8 then	
							valueVehicle()	

							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(myChop))	
							DeleteVehicle(myChop)	
							SetEntityCoords(myChop,0.0,0.0,-90.0)	
						end	
						Citizen.Wait(200)	
					end	
				end	
			end	
		end




			if IsPedInVehicle(PlayerPedId(),currentVehicle,false) and ( IsThisModelABike( GetEntityModel(currentVehicle) ) or IsThisModelACar( GetEntityModel(currentVehicle) ) ) then
				if #(vector3(chopshop["x"],chopshop["y"],chopshop["z"]) - pos) < 12 and locationset and playerPed == driverPed then
					local distance = #(vector3(chopshop["x"],chopshop["y"],chopshop["z"]) - pos)
					DrawMarker(27,chopshop["x"],chopshop["y"],chopshop["z"],0,0,0,0,0,0,3.001,3.0001,0.9001,0,155,255,50,0,0,0,0)
					
					pltcheck = GetVehicleNumberPlateText(currentVehicle)

					local hotVehicle =  isHotVehicle(pltcheck)
					local selfstolen = false

					if lockedplates["plt"..pltcheck] ~= nil then
						selfstolen = true
					end

					if hotVehicle or selfstolen then
						if selfstolen then
							DrawText3DTest(chopshop["x"],chopshop["y"],chopshop["z"], "We wont take this vehicle, your prints are on it!", 255,true)
						else
							DrawText3DTest(chopshop["x"],chopshop["y"],chopshop["z"], "That vehicle is too hot, get out of here!", 255,true)
						end
					else

						local cid = exports["isPed"]:isPed("cid")
						local rank = GroupRank("chop_shop")
						if chopshopowner == 99999 then
							DrawText3DTest(chopshop["x"],chopshop["y"],chopshop["z"], "Press E to claim the Chopshop", 255,true)
						elseif chopshopowner == cid or rank > 0 then
							DrawText3DTest(chopshop["x"],chopshop["y"],chopshop["z"], "Press E to enter the Chopshop", 255,true)
						end

						if IsControlJustReleased(2, 38) and #(vector3(chopshop["x"],chopshop["y"],chopshop["z"]) - GetEntityCoords(PlayerPedId())) < 5 then
							local caisseo = GetClosestVehicle(976.81365966797,-3001.3740234375,-39.603717803955, 4.000, 0, 70)
							if DoesEntityExist(caisseo) then
								TriggerEvent("DoLongHudText", "They're busy!",2 )
								Citizen.Wait(2000)
							else
								if chopshopowner == 99999 then
									TriggerServerEvent("request:chopshop",cid)
								elseif rank > 0 then
									SetEntityCoords(currentVehicle,976.81365966797,-3001.3740234375,-39.603717803955)
									if not chopDeliveryAvailable() then
										myChop = currentVehicle
									else
										TriggerEvent("DoLongHudText","We cant do this vehicle, there is parts needing delivery.",2)
									end
									Citizen.Wait(2000)
								else
									SetEntityCoords(currentVehicle,976.81365966797,-3001.3740234375,-39.603717803955)
									Citizen.Wait(2000)
								end
							end
		   				end
					end
				end

				if #(vector3(plateshop["x"],plateshop["y"],plateshop["z"]) - pos) < 12 and locationset and playerPed == driverPed then
					local distance = #(vector3(plateshop["x"],plateshop["y"],plateshop["z"]) - pos)
					DrawMarker(27,plateshop["x"],plateshop["y"],plateshop["z"]-1,0,0,0,0,0,0,3.001,3.0001,0.9001,0,155,255,50,0,0,0,0)
					if hotVehicle then
						local rank = GroupRank("parts_shop")
						if rank > 0 then
							DrawText3DTest(plateshop["x"],plateshop["y"],plateshop["z"], "That vehicle is too hot, get out of here!", 255,true)
						end	
					else
						front = 0
						back = 0
						local rank = GroupRank("parts_shop")
						if rank > 0 then
							DrawText3DTest(plateshop["x"],plateshop["y"],plateshop["z"], "Press E to enter the Parts Shop", 255,true)
						end
						
						if IsControlJustReleased(2, 38) and #(vector3(plateshop["x"],plateshop["y"],plateshop["z"]) - GetEntityCoords(PlayerPedId())) < 5 then
							local caisseo = GetClosestVehicle(194.74269104004,-1005.3385620117,-98.999961853027, 4.000, 0, 70)
							if DoesEntityExist(caisseo) then
								TriggerEvent("DoLongHudText", "They're busy!",2 )
								Citizen.Wait(2000)
							else
								SetEntityCoords(currentVehicle,194.74269104004,-1005.3385620117,-98.999961853027)
								myChop = currentVehicle

								TriggerEvent("DoLongHudText", "Move your car.",2 )
								Citizen.Wait(2000)
							end							
		   				end
					end
				end

			end


			-- if #(vector3(204.9,-995.11,-98.99) - pos) < 10 then
			-- 	local rank = GroupRank("parts_shop")
			-- 	if rank > 0 then
			-- 		DrawText3DTest(204.9,-995.11,-98.99, "Press H to craft", 255,true)
			-- 		if(IsControlJustPressed(1,74)) then
			-- 			TriggerEvent("CraftOpen")   
			-- 		end
			-- 	end
		    --  end






			if #(vector3(964.42156982422,-3003.5859375,-39.639896392822) - pos) < 5 then
		        local distance = #(vector3(964.42156982422,-3003.5859375,-39.639896392822) - pos)
				DrawText3DTest(964.42156982422,-3003.5859375,-39.639896392822, "Press E to view City Stock Values", 255,true)
				DrawMarker(27,964.42156982422,-3003.5859375,-40.539896392822,0,0,0,0,0,0,1.001,1.0001,0.9001,50,115,155,50,0,0,0,0)
				if IsControlJustReleased(2, 38) and #(vector3(964.42156982422,-3003.5859375,-39.639896392822) - pos) < 3 then
					TriggerEvent("chopshop:currentValues")
					Citizen.Wait(8000)
   				end
   			end



			if #(vector3(970.81,-2989.2,-39.64) - pos) < 5 then
		        local distance = #(vector3(970.81,-2989.2,-39.64) - pos)
				DrawText3DTest(970.81,-2989.2,-39.64, "Press E to leave", 255,true)
				DrawMarker(27,970.81,-2989.2,-39.64,0,0,0,0,0,0,1.001,1.0001,0.9001,50,115,155,50,0,0,0,0)
				if IsControlJustReleased(2, 38) and #(vector3(970.81,-2989.2,-39.64) - pos) < 3 then
					
					if IsPedInVehicle(PlayerPedId(),currentVehicle,false) then
						SetEntityCoords(currentVehicle,chopshop["x"],chopshop["y"],chopshop["z"])
					else
						SetEntityCoords(PlayerPedId(),chopshop["x"],chopshop["y"],chopshop["z"])
					end	

					endVars()
					Citizen.Wait(2000)
   				end
   			end


			if #(vector3(201.28433227539,-1004.8858032227,-98.999961853027) - pos) < 5 then
		        local distance = #(vector3(201.28433227539,-1004.8858032227,-98.999961853027) - pos)
				DrawText3DTest(201.28433227539,-1004.8858032227,-98.999961853027, "Press E to leave", 255,true)
				DrawMarker(27,201.28433227539,-1004.8858032227,-98.999961853027,0,0,0,0,0,0,1.001,1.0001,0.9001,50,115,155,50,0,0,0,0)
				if IsControlJustReleased(2, 38) and #(vector3(201.28433227539,-1004.8858032227,-98.999961853027) - pos) < 3 then
					
					if IsPedInVehicle(PlayerPedId(),currentVehicle,false) then
						SetEntityCoords(currentVehicle,plateshop["x"],plateshop["y"],plateshop["z"])
					else
						SetEntityCoords(PlayerPedId(),plateshop["x"],plateshop["y"],plateshop["z"])
					end	

					endVars()
					Citizen.Wait(2000)
   				end
   			end

		else
			Wait(10000)
		end
	end
end)

RegisterNetEvent("chopshop:requestpassupdate")
AddEventHandler("chopshop:requestpassupdate", function()
	local rank = GroupRank("chop_shop")
	if rank > 0 then
		TriggerServerEvent("updatePasses")
	end
end)

RegisterNetEvent("partshop:requestpassupdate")
AddEventHandler("partshop:requestpassupdate", function()
	local rank = GroupRank("parts_shop")
	if rank > 0 then
		TriggerServerEvent("updatePasses")
	end
end)

RegisterNetEvent("chop:plateoff")
AddEventHandler("chop:plateoff", function(newplate)
	if lockedplates["plt"..newplate] == nil then
		lockedplates["plt"..newplate] = true
	end
end)

RegisterNetEvent("chopshop:closed")
AddEventHandler("chopshop:closed", function()
	local pos = GetEntityCoords( PlayerPedId() )
	if #(vector3(976.81365966797,-3001.3740234375,-39.603717803955) - pos) < 70 then
		TriggerEvent("DoLongHudText","Chop Shop is shut, its too hot here - check your radio shortly.")
		TaskLeaveVehicle(PlayerPedId(), myChop, 0)
		Citizen.Wait(10)		

		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(myChop))	
		DeleteVehicle(myChop)	
		SetEntityCoords(myChop,0.0,0.0,-90.0)	
		SetEntityCoords(PlayerPedId(),chopshop["x"],chopshop["y"],chopshop["z"])
		endVars()
	end
end)

function endVars()
	taskNumber = 1
	inprocess = false
	carrying = false
	zz = false
	myChop = 0
	back = 0
	front = 0
end

function animCar()
	RequestAnimDict('mp_car_bomb')
	while not HasAnimDictLoaded("mp_car_bomb") do
		Citizen.Wait(0)
	end
	if not IsEntityPlayingAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3) then
		TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 8.0, -8, -1, 49, 0, 0, 0, 0)
	end
	Citizen.Wait(2200)  
	ClearPedTasks(PlayerPedId())
end

function playDrill2()
	FreezeEntityPosition(PlayerPedId(), true)
	animCar()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'impactdrill', 0.5)
	animCar()
	animCar()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'impactdrill', 0.5)
	animCar()
	animCar()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'impactdrill', 0.5)
	animCar()
	animCar()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'impactdrill', 0.5)
	animCar()
	animCar()
	front = math.random(11111111,99999999)
	FreezeEntityPosition(PlayerPedId(), false)
end

function playDrill3()
	FreezeEntityPosition(PlayerPedId(), true)
	animCar()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'impactdrill', 0.5)
	animCar()
	animCar()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'impactdrill', 0.5)
	animCar()
	animCar()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'impactdrill', 0.5)
	animCar()
	animCar()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'impactdrill', 0.5)
	animCar()
	animCar()
	back = front
	FreezeEntityPosition(PlayerPedId(), false)
	SetVehicleNumberPlateText(myChop, back)
	TriggerEvent("keys:addNew",myChop,back)
end

function playDrill()
	FreezeEntityPosition(PlayerPedId(),true)
	animCar()
	for i = 1, 6 do
		SetVehicleDoorOpen(myChop, i, 0, 0)
	end
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'impactdrill', 0.5)
	animCar()
	animCar()
	TriggerEvent("chopshop:taskItem",true)
	FreezeEntityPosition(PlayerPedId(),false)
end

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