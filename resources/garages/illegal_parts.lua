local mechanic = false
local mechanicshop = {}
mechanicshop = { ['x'] = -338.37,['y'] = -137.28,['z'] = 38.25,['h'] = 68.75, ['info'] = ' jajkaj' }
doorleave = { ['x'] = -338.37,['y'] = -137.28,['z'] = 38.25 }


local blipEn = false

local upgrades = {
	[1] = "Extractors 5 Scrap Metal", -- increase speed 5% -- $1000
	[2] = "Air Filter - 5 Plastic", -- increase speed 2% -- $100
	[3] = "Racing Suspension - 5 Rubber", -- increase handling 3% -- $3000
	[4] = "Racing Rollbars - 10 Rubber", -- increase handling 3% -- $4000
	[5] = "Bored Cyclinders - 5 Scrap Metal", -- increase speed 5% -- $1800
	[6] = "Lightened Panels - 30 Plastic", -- $7000
	[7] = "Front Left Inventory - 20 Plastic", -- $5000
	[8] = "Front Right Inventory - 20 Plastic", -- $5000
	[9] = "Back Left Inventory - 20 Plastic", -- $5000
	[10] = "Back Right Inventory - 20 Plastic", -- $5000
}

local upgradeItems = {
    [1] = { ["itemname"] = "Scrap Metal", ["itemid"] = "scrapmetal", ["count"] = 5},
    [2] = { ["itemname"] = "Plastic", ["itemid"] = "plastic", ["count"] = 5},
    [3] = { ["itemname"] = "Rubber", ["itemid"] = "rubber", ["count"] = 5},
    [4] = { ["itemname"] = "Rubber", ["itemid"] = "rubber", ["count"] = 10},
    [5] = { ["itemname"] = "Scrap Metal", ["itemid"] = "scrapmetal", ["count"] = 5},
    [6] = { ["itemname"] = "Plastic", ["itemid"] = "plastic", ["count"] = 30},
    [7] = { ["itemname"] = "Plastic", ["itemid"] = "plastic", ["count"] = 20},
    [8] = { ["itemname"] = "Plastic", ["itemid"] = "plastic", ["count"] = 20},
    [9] = { ["itemname"] = "Plastic", ["itemid"] = "plastic", ["count"] = 20},
    [10] = { ["itemname"] = "Plastic", ["itemid"] = "plastic", ["count"] = 20},
}

local carsUpgrades = {}
RegisterNetEvent("client:illegal:upgrades")
AddEventHandler("client:illegal:upgrades",function(Extractors,Filter,Suspension,Rollbars,Bored,Carbon,lplate,LFront,RFront,LBack,RBack)
	carsUpgrades[lplate] = {}
	carsUpgrades[lplate][1] = Extractors
	carsUpgrades[lplate][2] = Filter
	carsUpgrades[lplate][3] = Suspension
	carsUpgrades[lplate][4] = Rollbars
	carsUpgrades[lplate][5] = Bored
	carsUpgrades[lplate][6] = Carbon
	carsUpgrades[lplate][7] = LFront
	carsUpgrades[lplate][8] = RFront
	carsUpgrades[lplate][9] = LBack
	carsUpgrades[lplate][10] = RBack
end)

RegisterNetEvent('whitelist:illegal:mechanic')
AddEventHandler('whitelist:illegal:mechanic', function()
	mechanic = not mechanic
end)

RegisterNetEvent('client:illegal:upgrades:accept')
AddEventHandler('client:illegal:upgrades:accept', function(lplate,partnum,resFac)
	carsUpgrades[lplate][partnum] = resFac
end)

enteredcar = 0
usingpart = false
partloc = { ['x'] = -341.31,['y'] = -140.92,['z'] = 39.03,['h'] = 180.83, ['info'] = ' Boxes :)' }

function SelectUpgrade()
	zz = false
	animCar()
end

function GrabParts()
	Citizen.Trace("Grabbing Parts")

	local curplate = GetVehicleNumberPlateText(enteredcar)
	if carsUpgrades[curplate] == nil then
		TriggerEvent("DoShortHudText", "Invalid Vehicle Registration.",2)
		Citizen.Trace("AI car")
		return
	end

	usingpart = true
	for i = 1, 6 do
		SetVehicleDoorOpen(enteredcar, i, 0, 0)
	end
	RequestAnimDict('anim@heists@box_carry@')
	while not HasAnimDictLoaded("anim@heists@box_carry@") do
		Citizen.Wait(0)
	end

	TriggerEvent("attachItemChop",'MetalPart')
	local pos = GetEntityCoords(PlayerPedId())
	local carloc1 = GetOffsetFromEntityInWorldCoords(enteredcar, 0.0, 2.0, 0.0)
	local carloc2 = GetOffsetFromEntityInWorldCoords(enteredcar, 1.0, 1.5, 0.0)
	local carloc3 = GetOffsetFromEntityInWorldCoords(enteredcar, -1.0, -1.5, 0.0)
	local carloc4 = GetOffsetFromEntityInWorldCoords(enteredcar, 1.0, -1.5, 0.0)
	local carloc5 = GetOffsetFromEntityInWorldCoords(enteredcar, -1.0, 1.5, 0.0)

	local carloc6 = GetOffsetFromEntityInWorldCoords(enteredcar, 0.0, -2.0, 0.0)


	--right front
	local carloc7 = GetOffsetFromEntityInWorldCoords(enteredcar, -0.55, 0.8, 0.0)
	--left front
	local carloc8 = GetOffsetFromEntityInWorldCoords(enteredcar, 0.55, 0.8, 0.0)
	-- left back
	local carloc9 = GetOffsetFromEntityInWorldCoords(enteredcar, -0.7, -0.8, 0.0)
	-- right back
	local carloc10 = GetOffsetFromEntityInWorldCoords(enteredcar, 0.7, -0.8, 0.0)

	local zz1 = true
	local pushObj = 0

	while zz1 do

		pos = GetEntityCoords(PlayerPedId())
		local dst1 = #(vector3(carloc1["x"],carloc1["y"],carloc1["z"]) - pos)
		local dst2 = #(vector3(carloc2["x"],carloc2["y"],carloc2["z"]) - pos)
		local dst3 = #(vector3(carloc3["x"],carloc3["y"],carloc3["z"]) - pos)
		local dst4 = #(vector3(carloc4["x"],carloc4["y"],carloc4["z"]) - pos)
		local dst5 = #(vector3(carloc5["x"],carloc5["y"],carloc5["z"]) - pos)
		local dst6 = #(vector3(carloc6["x"],carloc6["y"],carloc6["z"]) - pos)
		local dst7 = #(vector3(partloc["x"],partloc["y"],partloc["z"]) - pos)
		local dst8 = #(vector3(carloc7["x"],carloc7["y"],carloc7["z"]) - pos)
		local dst9 = #(vector3(carloc8["x"],carloc8["y"],carloc8["z"]) - pos)
		local dst10 = #(vector3(carloc9["x"],carloc9["y"],carloc9["z"]) - pos)
		local dst11 = #(vector3(carloc10["x"],carloc10["y"],carloc10["z"]) - pos)

		Citizen.Wait(1)

		if dst7 < 1.5 then

			if IsControlJustReleased(2, Controlkey["generalUseThird"][1]) then
				pushObj = 0
				zz1 = false
			end
			DrawText3DTest(partloc["x"],partloc["y"],partloc["z"], "["..Controlkey["generalUseThird"][2].."] to cancel adding parts!", 255,true)

		elseif dst8 < 1.1 then

			if IsControlJustReleased(2, Controlkey["generalUseThird"][1]) then
				pushObj = 7
				zz1 = false
			end
			if carsUpgrades[curplate][7] == 0 then
				DrawText3DTest(carloc7["x"],carloc7["y"],carloc7["z"], "["..Controlkey["generalUseThird"][2].."] to install " .. upgrades[7] .. "!", 255,true)
			else
				DrawText3DTest(carloc7["x"],carloc7["y"],carloc7["z"], "["..Controlkey["generalUseThird"][2].."] to remove " .. upgrades[7] .. "!", 255,true)
			end

		elseif dst9 < 1.1  then

			if IsControlJustReleased(2, Controlkey["generalUseThird"][1]) then
				pushObj = 8
				zz1 = false
			end
			if carsUpgrades[curplate][8] == 0 then
				DrawText3DTest(carloc8["x"],carloc8["y"],carloc8["z"], "["..Controlkey["generalUseThird"][2].."] to install " .. upgrades[8] .. "!", 255,true)
			else
				DrawText3DTest(carloc8["x"],carloc8["y"],carloc8["z"], "["..Controlkey["generalUseThird"][2].."] to remove " .. upgrades[8] .. "!", 255,true)
			end

		elseif dst10 < 1.1  then
			if GetNumberOfVehicleDoors(enteredcar) >= 5 then
				if IsControlJustReleased(2, Controlkey["generalUseThird"][1]) then
					pushObj = 9
					zz1 = false
				end
				if carsUpgrades[curplate][9] == 0 then
					DrawText3DTest(carloc9["x"],carloc9["y"],carloc9["z"], "["..Controlkey["generalUseThird"][2].."] to install " .. upgrades[9] .. "!", 255,true)
				else
					DrawText3DTest(carloc9["x"],carloc9["y"],carloc9["z"], "["..Controlkey["generalUseThird"][2].."] to remove " .. upgrades[9] .. "!", 255,true)
				end
			end

		elseif dst11 < 1.1  then
			if GetNumberOfVehicleDoors(enteredcar) >= 5 then
				if IsControlJustReleased(2, Controlkey["generalUseThird"][1]) then
					pushObj = 10
					zz1 = false
				end
				if carsUpgrades[curplate][10] == 0 then
					DrawText3DTest(carloc10["x"],carloc10["y"],carloc10["z"], "["..Controlkey["generalUseThird"][2].."] to install " .. upgrades[10] .. "!", 255,true)
				else
					DrawText3DTest(carloc10["x"],carloc10["y"],carloc10["z"], "["..Controlkey["generalUseThird"][2].."] to remove " .. upgrades[10] .. "!", 255,true)
				end
			end

		elseif dst1 < 1.5 then

			if IsControlJustReleased(2, Controlkey["generalUseThird"][1]) then
				pushObj = 1
				zz1 = false
			end
			if carsUpgrades[curplate][1] == 0 then
				DrawText3DTest(carloc1["x"],carloc1["y"],carloc1["z"], "["..Controlkey["generalUseThird"][2].."] to install " .. upgrades[1] .. "!", 255,true)
			else
				DrawText3DTest(carloc1["x"],carloc1["y"],carloc1["z"], "["..Controlkey["generalUseThird"][2].."] to remove " .. upgrades[1] .. "!", 255,true)
			end

		elseif dst2 < 1.5 then

			if IsControlJustReleased(2, Controlkey["generalUseThird"][1]) then
				pushObj = 2
				zz1 = false
			end

			if carsUpgrades[curplate][2] == 0 then
				DrawText3DTest(carloc2["x"],carloc2["y"],carloc2["z"], "["..Controlkey["generalUseThird"][2].."] to install " .. upgrades[2] .. "!", 255,true)
			else
				DrawText3DTest(carloc2["x"],carloc2["y"],carloc2["z"], "["..Controlkey["generalUseThird"][2].."] to remove " .. upgrades[2] .. "!", 255,true)
			end

		elseif dst3 < 1.5 then

			if IsControlJustReleased(2, Controlkey["generalUseThird"][1]) then
				pushObj = 3
				zz1 = false
			end

			if carsUpgrades[curplate][3] == 0 then
				DrawText3DTest(carloc3["x"],carloc3["y"],carloc3["z"], "["..Controlkey["generalUseThird"][2].."] to install " .. upgrades[3] .. "!", 255,true)
			else
				DrawText3DTest(carloc3["x"],carloc3["y"],carloc3["z"], "["..Controlkey["generalUseThird"][2].."] to remove " .. upgrades[3] .. "!", 255,true)
			end

		elseif dst4 < 1.5 then

			if IsControlJustReleased(2, Controlkey["generalUseThird"][1]) then
				pushObj = 4
				zz1 = false
			end

			if carsUpgrades[curplate][4] == 0 then
				DrawText3DTest(carloc4["x"],carloc4["y"],carloc4["z"], "["..Controlkey["generalUseThird"][2].."] to install " .. upgrades[4] .. "!", 255,true)
			else
				DrawText3DTest(carloc4["x"],carloc4["y"],carloc4["z"], "["..Controlkey["generalUseThird"][2].."] to remove " .. upgrades[4] .. "!", 255,true)
			end

		elseif dst5 < 1.5 then

			if IsControlJustReleased(2, Controlkey["generalUseThird"][1]) then
				pushObj = 5
				zz1 = false
			end

			if carsUpgrades[curplate][5] == 0 then
				DrawText3DTest(carloc5["x"],carloc5["y"],carloc5["z"], "["..Controlkey["generalUseThird"][2].."] to install " .. upgrades[5] .. "!", 255,true)
			else
				DrawText3DTest(carloc5["x"],carloc5["y"],carloc5["z"], "["..Controlkey["generalUseThird"][2].."] to remove " .. upgrades[5] .. "!", 255,true)
			end


		elseif dst6 < 1.5 then

			if IsControlJustReleased(2, Controlkey["generalUseThird"][1]) then
				pushObj = 6
				zz1 = false
			end

			if carsUpgrades[curplate][6] == 0 then
				DrawText3DTest(carloc6["x"],carloc6["y"],carloc6["z"], "["..Controlkey["generalUseThird"][2].."] to install " .. upgrades[6] .. "!", 255,true)
			else
				DrawText3DTest(carloc6["x"],carloc6["y"],carloc6["z"], "["..Controlkey["generalUseThird"][2].."] to remove " .. upgrades[6] .. "!", 255,true)
			end

		else
			DrawText3DTest(carloc1["x"],carloc1["y"],carloc1["z"], "Move here to modify " .. upgrades[1] .. "!", 255,true)
			DrawText3DTest(carloc2["x"],carloc2["y"],carloc2["z"], "Move here to modify " .. upgrades[2] .. "!", 255,true)
			DrawText3DTest(carloc3["x"],carloc3["y"],carloc3["z"], "Move here to modify " .. upgrades[3] .. "!", 255,true)
			DrawText3DTest(carloc4["x"],carloc4["y"],carloc4["z"], "Move here to modify " .. upgrades[4] .. "!", 255,true)
			DrawText3DTest(carloc5["x"],carloc5["y"],carloc5["z"], "Move here to modify " .. upgrades[5] .. "!", 255,true)
			DrawText3DTest(carloc6["x"],carloc6["y"],carloc6["z"], "Move here to modify " .. upgrades[6] .. "!", 255,true)
			DrawText3DTest(carloc7["x"],carloc7["y"],carloc7["z"], "Move here to modify " .. upgrades[7] .. "!", 255,true)
			DrawText3DTest(carloc8["x"],carloc8["y"],carloc8["z"], "Move here to modify " .. upgrades[8] .. "!", 255,true)
			if GetNumberOfVehicleDoors(enteredcar) >= 5 then
				DrawText3DTest(carloc9["x"],carloc9["y"],carloc9["z"], "Move here to modify " .. upgrades[9] .. "!", 255,true)
				DrawText3DTest(carloc10["x"],carloc10["y"],carloc10["z"], "Move here to modify " .. upgrades[10] .. "!", 255,true)
			end
		end

		if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then
			TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
		end

	end

	TriggerEvent("attachRemoveChopShop")
	if pushObj ~= 0 then

		print("Attempting to use ".. upgradeItems[pushObj]["itemname"] .. "(".. upgradeItems[pushObj]["count"] ..")")

		local itemcount = exports["np-inventory"]:getQuantity(upgradeItems[pushObj]["itemid"])
		if itemcount < upgradeItems[pushObj]["count"] then
			TriggerEvent("DoLongHudText","You do not have enough ".. upgradeItems[pushObj]["itemname"] .. "(".. upgradeItems[pushObj]["count"] ..")")
			ClearPedTasksImmediately(PlayerPedId())
			usingpart = false
			return
		end

		TriggerEvent("inventory:removeItem", upgradeItems[pushObj]["itemid"], upgradeItems[pushObj]["count"])
		TriggerServerEvent("upgradeAttempt:illegalparts",pushObj,curplate)
		playDrillz()
	end

	ClearPedTasksImmediately(PlayerPedId())
	usingpart = false

end

function animCarz()
	Citizen.Trace("anim car")
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

function playDrillz()
	FreezeEntityPosition(PlayerPedId(),true)
	Citizen.Trace("drilling")
	animCarz()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'impactdrill', 0.5)
	animCarz()
	animCarz()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'impactdrill', 0.5)
	animCarz()
	animCarz()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'impactdrill', 0.5)
	animCarz()
	animCarz()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'impactdrill', 0.5)
	animCarz()
	animCarz()
	FreezeEntityPosition(PlayerPedId(),false)
end


RegisterNetEvent('illegal_carshop:leave')
AddEventHandler('illegal_carshop:leave', function()
	local veh = GetVehiclePedIsIn(PlayerPedId(), false)
	if veh == 0 or veh == nil then
		veh = PlayerPedId()
	end
	SetEntityCoords(veh,mechanicshop["x"],mechanicshop["y"],mechanicshop["z"])
end)

RegisterNetEvent('chopshop:leave')
AddEventHandler('chopshop:leave', function()
	local pos = GetEntityCoords(PlayerPedId())
	local distance2 = #(vector3(-338.37,-137.28,38.25) - pos)
	local veh = GetVehiclePedIsIn(PlayerPedId(), false)
	local driverPed = GetPedInVehicleSeat(veh, -1)

	if distance2 < 30.0 and PlayerPedId() ~= driverPed then
		TaskLeaveVehicle(PlayerPedId(), veh, 0)
		Citizen.Wait(100)
	end
end)



Citizen.CreateThread(function()

	while true do

		Wait(1)

		local pos = GetEntityCoords(PlayerPedId())
		local distance = #(vector3(mechanicshop["x"],mechanicshop["y"],mechanicshop["z"]) - pos)
		local distance2 = #(vector3(-338.37,-137.28,38.25) - pos)

		local distance3 = #(vector3(partloc["x"],partloc["y"],partloc["z"]) - pos)
		local distanceoutdoor = #(vector3(doorleave["x"],doorleave["y"],doorleave["z"]) - pos)

		if distance < 5 and mechanic and enteredcar == 0 then
			if IsControlJustReleased(2, Controlkey["generalUse"][1]) and distance < 5 and GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
				veh = GetVehiclePedIsIn(PlayerPedId(), false)
				enteredcar = veh
				if veh == 0 or veh == nil then
					veh = PlayerPedId()
				end

				SetEntityCoords(veh,-338.37,-137.28,38.25)
				SetEntityHeading(veh,68.75)
				Citizen.Wait(1000)
				FreezeEntityPosition(veh,true)
			end
			DrawText3DTest(mechanicshop["x"],mechanicshop["y"],mechanicshop["z"], "["..Controlkey["generalUse"][2].."] to enter Mechanic Shop!", 255,true)
		end

		if mechanic and enteredcar ~= 0 then
			local rank = exports["isPed"]:GroupRank("illegal_carshop")

			if distance2 < 4 and not usingpart then
				if IsControlJustReleased(2, Controlkey["generalUse"][1]) and GetVehiclePedIsIn(PlayerPedId(), false) ~= 0  then
					veh = GetVehiclePedIsIn(PlayerPedId(), false)

					local driverPed = GetPedInVehicleSeat(veh, -1)
    				if PlayerPedId() == driverPed then
						local plt = GetVehicleNumberPlateText(veh)
						TriggerServerEvent("respawn:illegalpartveh",plt)
					end
					--SetEntityCoords(PlayerPedId(),mechanicshop["x"],mechanicshop["y"],mechanicshop["z"])
					--SetEntityHeading(PlayerPedId(),353.25765991211)
					FreezeEntityPosition(veh,false)
					enteredcar = 0
					Citizen.Wait(1000)
				end
				DrawText3DTest(-338.37,-137.28,38.25, "["..Controlkey["generalUse"][2].."] to leave!", 255,true)
			end



			if distance3 < 1.5 and enteredcar ~= 0 and rank > 3 then
				if IsControlJustReleased(2, Controlkey["generalUseThird"][1]) and not usingpart then
					GrabParts()
					Citizen.Wait(1000)
				end
				DrawText3DTest(partloc["x"],partloc["y"],partloc["z"], "["..Controlkey["generalUseThird"][2].."] to grab upgrade parts!", 255,true)
			end
		end

	end

end)

RegisterNetEvent('illegal_carshop:signon')
AddEventHandler('illegal_carshop:signon', function()
	local rank = exports["isPed"]:GroupRank("illegal_carshop")
	if rank > 2 then
		TriggerServerEvent("server:pass","illegal_carshop")
	end
end)

RegisterNetEvent('illegal_carshop:SpawnVehicle')
AddEventHandler('illegal_carshop:SpawnVehicle', function(vehicle, plate, customized, state, Fuel)
	local customized = json.decode(customized)
	Citizen.CreateThread(function()
		Citizen.Wait(100)

		if Fuel < 5 then
			Fuel = 5
		end

		DecorSetInt(veh, "CurrentFuel", Fuel)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh, false)

		SetVehicleModKit(veh, 0)

		SetVehicleNumberPlateText(veh, plate)

		if customized then
			SetVehicleWheelType(veh, customized.wheeltype)
			SetVehicleNumberPlateTextIndex(veh, 3)

			for i = 0, 16 do
				SetVehicleMod(veh, i, customized.mods[tostring(i)])
			end

			for i = 17, 22 do
				ToggleVehicleMod(veh, i, customized.mods[tostring(i)])
			end

			for i = 23, 24 do
				SetVehicleMod(veh, i, customized.mods[tostring(i)])
			end

			for i = 0, 3 do
				SetVehicleNeonLightEnabled(veh, i, customized.neon[tostring(i)])
			end

			SetVehicleColours(veh, customized.colors[1], customized.colors[2])
			SetVehicleExtraColours(veh, customized.extracolors[1], customized.extracolors[2])
			SetVehicleNeonLightsColour(veh, customized.lights[1], customized.lights[2], customized.lights[3])
			SetVehicleTyreSmokeColor(veh, customized.smokecolor[1], customized.smokecolor[2], customized.smokecolor[3])
			SetVehicleWindowTint(veh, customized.tint)
		else
			SetVehicleColours(veh, 0, 0)
			SetVehicleExtraColours(veh, 0, 0)
		end


		TriggerEvent("keys:addNew",veh,plate)
		SetVehicleHasBeenOwnedByPlayer(veh,true)


		local id = NetworkGetNetworkIdFromEntity(veh)
		SetNetworkIdCanMigrate(id, true)


		if GetEntityModel(vehicle) == `rumpo` then
			SetVehicleLivery(veh,0)
		end

		FreezeEntityPosition(veh,false)
		TriggerServerEvent('garages:SetVehOut', vehicle, plate)
		SetPedIntoVehicle(PlayerPedId(), veh, - 1)
		TriggerServerEvent('veh.getVehicles', plate, veh)
		TriggerServerEvent("garages:CheckGarageForVeh")
		SetEntityAsMissionEntity(veh,false,true)

	end)
end)

