function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function checkPlayerOwnedVehicle(veh)
	return DecorExistOn(veh, "PlayerVehicle")
end

-- Animations
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end



local blips = {
  {name = "Tow Spawn & Drop LS", id = 68, x = 408.957, y = -1638.664, z = 28.81},
  {name = "Tow Spawn & Drop SS", id = 68, x = 1732.1655273438, y = 3307.6025390625, z = 41.22350692749},
  {name = "Tow Spawn & Drop PL", id = 68, x = -195.68403625488, y = 6219.8081054688, z = 31.491077423096},
  {name = "Tow Garage LS", id = 147, x = 1145.3298339844, y = -773.35809326172, z = 56.750310516357}
}

local garage = {
  	{Name = "Tow Garage 1", plate = 0, offsetx = 0, offsety = 0, offsetz = 0, CurrentHead = 0, x = 532.281, y = -176.548 , z = 53.505, xe = 532.281, ye = -176.548, ze = 53.505, he = 0.0, xd = 532.281 , yd = -176.548, zd = 53.505},
    {Name = "Tow Garage 2", plate = 0, offsetx = 0, offsety = 0, offsetz = 0, CurrentHead = 0, x = 968.03, y = -126.64, z = 73.37, xe = 968.03 ,ye = -126.64 , ze = 73.37, he = 0.0, xd = 968.03 , yd = -126.64 , zd = 73.37},
    {Name = "Tow Garage 3", plate = 0, offsetx = 0, offsety = 0, offsetz = 0, CurrentHead = 0, x = 1183.18, y = 2651.66, z = 37.81, xe = 1183.18 ,ye = 2651.66 , ze = 37.81, he = 0.0, xd =1183.18 , yd =  2651.66 , zd = 37.81},
	{Name = "Tow Garage 4", plate = 0, offsetx = 0, offsety = 0, offsetz = 0, CurrentHead = 0, x = 937.1, y = -963.01, z = 39.51, xe = 937.1, ye = -963.01, ze = 39.51, he = 0.0, xd = 937.1, yd = -963.01, zd = 39.51}, -- Tuner Shop
    {Name = "Tow Garage 5", plate = 0, offsetx = 0, offsety = 0, offsetz = 0, CurrentHead = 0, x = 110.91, y = 3614.98, z = 40.27, xe = 110.91, ye = 3614.98, ze = 40.27, he = 0.0, xd = 110.91, yd = 3614.98, zd = 40.27},
}

local currentVeh = nil

-----------------------------------
scrapModify = 10 -- changes percent amount needed for repair eg. with 0.3 , 5 scrap gets a car from 10% to 13.5% 
scrapSellPrice = 15 --selling to to the tow
scrapBuyPrice = 25 -- buying from a ped
repairAmount = 4 -- amount of times the player has to repair the car in order for the repair to take effect
sellBulkAmount = 5 -- amount that can be sold at one time
-----------------------------------

onJob = 0
local lastPlate = nil
local selling = false
local hasPutCarIn = false
local shouldExitRepair = false

function LocalPed()
	return PlayerPedId()
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

RegisterNetEvent("towgarage:notworked")
AddEventHandler("towgarage:notworked", function()
	TriggerEvent("DoLongHudText", "You must be a tow truck driver", 2)
	onJob = 0
end)

RegisterNetEvent("towgarage:worked")
AddEventHandler("towgarage:worked", function()
	onJob = 1
end)

RegisterNetEvent("judge:PayVictim")
AddEventHandler("judge:PayVictim", function(amount)
	TriggerServerEvent("judge:pay",amount)
end)

RegisterNetEvent("towgarage:getScrapModify")
AddEventHandler("towgarage:getScrapModify", function(cb)
	cb(scrapModify)
end)

RegisterNetEvent("towgarage:getScrapSellPrice")
AddEventHandler("towgarage:getScrapSellPrice", function(cb)
	cb(scrapSellPrice)
end)

RegisterNetEvent("towgarage:getScrapBuyPrice")
AddEventHandler("towgarage:getScrapBuyPrice", function(cb)
	cb(scrapBuyPrice)
end)

RegisterNetEvent("towgarage:getPlate")
AddEventHandler("towgarage:getPlate", function(name,cb)	
	local out = 0
	for i,v in ipairs(garage) do
		if garage[i].Name == name then out = garage[i].plate end
	end
	cb(out)
end)

local recentpay = false
RegisterNetEvent("COP:PayTow")
AddEventHandler("COP:PayTow", function()
	if onJob and not recentpay then
		recentpay = true
		TriggerServerEvent("server:givepayJob", "Tow Truck from Police Officer", 1500)
		Citizen.Wait(300000)
		recentpay = false
	else
		TriggerEvent("DoLongHudText","Someone tried to pay you, but, you were paid recently, or are not a Tow Truck Driver.",2)
	end
end)

RegisterNetEvent("COP:PayTow")
AddEventHandler("COP:PayTow", function(amount)


	if amount == nil then
		if not recentpay then
			recentpay = true
			TriggerServerEvent("server:givepayJob", "Government Payment", 1500)
			Citizen.Wait(300000)
			recentpay = false
		else
			TriggerEvent("DoLongHudText","Someone tried to government pay you, but, you were paid recently.",2)
		end
	else
		TriggerServerEvent("server:givepayJob", "Government Payment", amount)
	end



end)


RegisterNetEvent('tow:checkIfOnDuty')
AddEventHandler('tow:checkIfOnDuty', function()
	if onJob == 1 then
		TriggerEvent('sendToGui','Impound Vehicle' , 'impoundVehicle')
		Citizen.Trace("LOL")
	end
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job)

	if job == "taxi" then
		TriggerServerEvent('phone:updatePhoneJob', "Taxi Driver")
	end

	if job == "towtruck" then
		TriggerServerEvent('phone:updatePhoneJob', "Tow Operator")
	end

	if job == "trucker" then
		TriggerServerEvent('phone:updatePhoneJob', "Delivery Driver")
	end

	if job ~= "towtruck" then 
		onJob = 0 return 
	else 
		onJob = 1 
	end

end)

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


function InitMenuVehicules()
	MenuTitle = "Vehicles"
	ClearMenu()
	--Menu.addButton("Flat Bed", "callSE", {"towgarage:flatbed", "flatbed3"},0,nil,0.0,"")
	--Menu.addButton("Tow Truck", "callSE", {"towgarage:flatbed", "towtruck"},0,nil,0.0,"")
	--Menu.addButton("Tow Truck 2", "callSE", {"towgarage:flatbed", "towtruck2"},0,nil,0.0,"")
end

function InitGarage(result,name,resultCheck,bodyDamge,engineDamage)
	MenuTitle = "Repair"
	ClearMenu()
		if resultCheck == true then			
			Menu.addButton("Repair Fuel Injector:", "InitAmount", result,1,result.fuel_injector,0.002,"fuel_injector",name)
			Menu.addButton("Repair transmission:", "InitAmount", result,1,result.transmission,0.003,"transmission",name)
			Menu.addButton("Repair electronics:", "InitAmount", result,1,result.electronics,0.001,"electronics",name)
			Menu.addButton("Repair Fuel Tank:", "InitAmount", result,1,result.fuel_tank,-0.002,"fuel_tank",name)
			Menu.addButton("Repair Radiator:", "InitAmount",result,1,result.radiator,-0.003,"radiator",name)
			Menu.addButton("Repair Breaks:", "InitAmount",result,1,result.breaks,-0.005,"breaks",name)
			Menu.addButton("Repair clutch:", "InitAmount",result,1,result.clutch,-0.007,"clutch",name)
			Menu.addButton("Repair Axle:", "InitAmount",result,1,result.axle,-0.009,"axle",name)
			Menu.addButton("Repair Bodywork:", "body",bodyDamge,4,bodyDamge,0.000,"body",name)
			Menu.addButton("Repair Engine:", "engine",engineDamage,4,engineDamage,-0.004,"engine",name)
		else
			Menu.addButton("Repair Bodywork:", "body",bodyDamge,4,bodyDamge,0.000,"body",name)
			Menu.addButton("Repair Engine:", "engine",engineDamage,4,engineDamage,0.000,"engine",name)			
		end
	
end

function InitDegMenu(isOwned,bodyDamge,engineDamage,isTow,result)
	MenuTitle = "Degredation"
	ClearMenu()
	if isOwned then			
		Menu.addButton("Fuel Injector:", "", 0,5,result.fuel_injector,0.002,"fuel_injector",isTow)
		Menu.addButton("Transmission:", "", 0,5,result.transmission,0.003,"transmission",isTow)
		Menu.addButton("Electronics:", "", 0,5,result.electronics,0.001,"electronics",isTow)
		Menu.addButton("Fuel Tank:", "", 0,5,result.fuel_tank,-0.002,"fuel_tank",isTow)
		Menu.addButton("Radiator:", "",0,5,result.radiator,-0.003,"radiator",isTow)
		Menu.addButton("Breaks:", "",0,5,result.breaks,-0.005,"breaks",isTow)
		Menu.addButton("Clutch:", "",0,5,result.clutch,-0.007,"clutch",isTow)
		Menu.addButton("Axle:", "",0,5,result.axle,-0.009,"axle",isTow)
		Menu.addButton("Bodywork:", "",0,6,bodyDamge,0.000,"body",isTow)
		Menu.addButton("Engine:", "",0,6,engineDamage,-0.004,"engine",isTow)
	else
		Menu.addButton("Bodywork:", "body",bodyDamge,6,bodyDamge,0.000,"body",isTow)
		Menu.addButton("Engine:", "engine",engineDamage,6,engineDamage,-0.004,"engine",isTow)		
	end
end

RegisterNetEvent('towgarage:InitAmount')
AddEventHandler('towgarage:InitAmount', function(degArray,degname,percent,garagename)
	MenuTitle = "Amount"
	ClearMenu()

	local itemname = "Scrap"

	if degname == "breaks" then
		itemname = "Rubber"
	end

	if degname == "fuel_tank" then
		itemname = "Steel"
	end

	if degname == "transmission" then
		itemname = "Aluminium"
	end

	if degname == "fuel_injector" then
		itemname = "Copper"
	end

	if degname == "body" then
		itemname = "Glass"
	end	

	if degname == "electronics" then
		itemname = "Plastic"
	end

	Menu.addButton("Use '1' " .. itemname,percent,1,2,degArray,0.000,degname,garagename)
	Menu.addButton("Use '2' " .. itemname,percent,2,2,degArray,0.000,degname,garagename)
	Menu.addButton("Use '3' " .. itemname,percent,3,2,degArray,0.000,degname,garagename)
	Menu.addButton("Use '4' " .. itemname,percent,4,2,degArray,0.000,degname,garagename)
	Menu.addButton("Use '5' " .. itemname,percent,5,2,degArray,0.000,degname,garagename)

end)

function callSE(args)
	Menu.hidden = not Menu.hidden
	Menu.renderGUI()
	TriggerServerEvent(args[1],args[2])
end



RegisterNetEvent('towgarage:callSE2')
AddEventHandler('towgarage:callSE2', function(amount,degArray,degname,garagename,current)
	Menu.hidden = not Menu.hidden
	Menu.renderGUI()

	local itemname = "Scrap"
	local itemid = 26

	if degname == "electronics" then
		itemid = 27
		itemname = "Plastic"
	end

	if degname == "body" then
		itemid = 28
		itemname = "Glass"
	end	

	if degname == "fuel_tank" then
		itemid = 30
		itemname = "Steel"
	end

	if degname == "transmission" then
		itemid = 31
		itemname = "Aluminium"
	end

	if degname == "breaks" then
		itemid = 33
		itemname = "Rubber"
	end

	if degname == "fuel_injector" then
		itemid = 34
		itemname = "Copper"
	end

	TriggerServerEvent('scrap:towTake',amount,degArray,degname,garagename,current,itemid)

end)



RegisterNetEvent('towgarage:callCE')
AddEventHandler('towgarage:callCE', function(degArray,degname,garagename,current)
	Menu.hidden = not Menu.hidden
	Menu.renderGUI()
	local amount = KeyboardInput("Amount:","",3)
	TriggerServerEvent('scrap:towTake',amount,degArray,degname,garagename,current)
	
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

RegisterNetEvent('returnmechanicmaterials')
AddEventHandler('returnmechanicmaterials', function(materialsTable)

	local itemvalues = {
	    [1] = { ["itemid"] = 26, ["itemname"] = "Scrap", ["amount"] = 0 },
	    [2] = { ["itemid"] = 27, ["itemname"] = "Plastic", ["amount"] = 0 },
	    [3] = { ["itemid"] = 28, ["itemname"] = "Glass", ["amount"] = 0 },
	    [4] = { ["itemid"] = 30, ["itemname"] = "Steel", ["amount"] = 0 },
	    [5] = { ["itemid"] = 31, ["itemname"] = "Aluminium", ["amount"] = 0 },
	    [6] = { ["itemid"] = 33, ["itemname"] = "Rubber", ["amount"] = 0 },
	    [7] = { ["itemid"] = 34, ["itemname"] = "Copper", ["amount"] = 0 },
	}
	-- for x = 1, #itemvalues do
	-- 	local itemid = itemvalues[x]["itemid"]
	-- 	local itemname = itemvalues[x]["itemname"]
		-- local itemcount = materialsTable["itemid"..itemid]["amount"]
		TriggerEvent("chatMessage","Storage",4,materialsTable)
		Citizen.Wait(10)
	-- end
end)


RegisterNetEvent('towgarage:annoyedBouce')
AddEventHandler('towgarage:annoyedBouce', function()
	TriggerServerEvent("towgarage:checkJobBounce",false)
end)


RegisterNetEvent('towgarage:defaultRepairs')
AddEventHandler('towgarage:defaultRepairs', function(name,amount,garagename)
	for i,v in ipairs(garage) do
		if v.Name == garagename then
			if name == "engine" then
				SetVehicleEngineHealth(currentVeh, (amount*10) + 0.0 )
				if amount >= 85 then
					SetVehicleFixed(currentVeh)
					SetVehiclePetrolTankHealth(currentVeh, 4000.0)
				end
			elseif name == "body" then
				SetVehicleBodyHealth(currentVeh, (amount*10) + 0.0 )
				fixWheel(currentVeh)
				if amount >= 85 then
					SetVehicleFixed(currentVeh)
					SetVehiclePetrolTankHealth(currentVeh, 4000.0)
				end
			end
		end
	end	
end)


function fixWheel(targetVehicle)
	SetVehicleTyreFixed(targetVehicle,0)
	SetVehicleTyreFixed(targetVehicle,1)
	SetVehicleTyreFixed(targetVehicle,2)
	SetVehicleTyreFixed(targetVehicle,3)
	SetVehicleTyreFixed(targetVehicle,4)
end

RegisterNetEvent('event:control:towgarage')
AddEventHandler('event:control:towgarage', function(useID)
	local rankCarshop = exports["isPed"]:GroupRank("car_shop")
    local rankImport = exports["isPed"]:GroupRank("illegal_carshop")

    local job = exports["isPed"]:GroupRank("job")
    local allow = false
    if rankCarshop > 0 or rankImport > 0 or job == "judge" or job == "police" then
    	allow = true
	end

	if allow then
		local playerped = PlayerPedId()
		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)		
		if targetVehicle ~= 0 then
			local plate = GetVehicleNumberPlateText(targetVehicle)
			local vehNetId = VehToNet(targetVehicle)
			TriggerServerEvent("repo:car",plate, vehNetId)
			TriggerEvent("DoLongHudText","Checking vehicle information with Government, please hold tight.",2)
		else
			TriggerEvent("DoLongHudText","No vehicle found.",2)
		end
		Citizen.Wait(5000)
	end
end)

-- #MarkedForMarker
Citizen.CreateThread(function()

	while true do

		Citizen.Wait(1)

		if not Menu.hidden then
			Menu.renderGUI()
		end

		local dst = #(vector3(GetEntityCoords(PlayerPedId())) - vector3(400.85, -1632.37, 29.3))

		if dst < 30.0 then

			DrawMarker(27, 401.16, -1631.7, 28.4, 0, 0, 0, 0, 0, 0, 8.001, 8.0001, 0.5001, 0, 155, 255, 70, 0, 0, 0, 0)

			if dst < 15.0 then
				DrawText3Ds(401.16, -1631.7, 28.9,"[".. Controlkey["generalUse"][2] .."] to attempt repo of vehicle.")
			end

		end

	end

end)


RegisterNetEvent('fakeplate:accepted')
AddEventHandler('fakeplate:accepted', function(newplate,isStolen,oldplate)

	local playerped = PlayerPedId()
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)
	local plate = GetVehicleNumberPlateText(targetVehicle)
	if targetVehicle ~= nil  and targetVehicle ~= 0 then
		TriggerEvent("inventory:removeItem","fakeplate", 1)
		if isStolen then
			TriggerEvent("keys:checkandgive",newplate,oldplate)
			TriggerEvent("customNotification","This vehicle is now running with stolen plates")

		else
			TriggerEvent("customNotification","This vehicle now has its default plate")

		end
		TriggerEvent("vehicleMod:resetDowngrade", targetVehicle)
		SetVehicleNumberPlateText(targetVehicle, newplate)
	end
end)

RegisterNetEvent('fakeplate:change')
AddEventHandler('fakeplate:change', function()
	local playerped = PlayerPedId()
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)
	local plate = GetVehicleNumberPlateText(targetVehicle)
	if targetVehicle ~= nil  and targetVehicle ~= 0 then
		loadAnimDict("amb@medic@standing@kneel@base")
		TaskPlayAnim(playerped,"amb@medic@standing@kneel@base","base", 8.0, -8, -1, 0, 0, 0, 0, 0)
		local finished = exports["np-taskbar"]:taskBar(20000,"Changing plates", true)
		if finished == 100 then
			TriggerServerEvent("fakeplate:change",plate)
		end
	else
		TriggerEvent("DoLongHudText","No vehicle close by.", 2)
	end
end)

RegisterNetEvent('towgarage:craft')
AddEventHandler('towgarage:craft', function(res,amount)
	local amount = tonumber(amount)
	if amount == nil then
		amount = 1
	end
	local dst = #(vector3(GetEntityCoords(PlayerPedId())) - vector3(953.16, -977.19, 39.51)) -- Tuner Shop
	local dst2 = #(vector3(GetEntityCoords(PlayerPedId())) - vector3(1183.18, 2651.66, 37.81))
	if dst > 10.0 and dst2 > 10.0 then
		return
	end


	local rank = exports["isPed"]:GroupRank("tuner_carshop")
	local rank2 = exports["isPed"]:GroupRank("repairs_harmony")
	local res = tonumber(res)

	if rank >= 4 or rank2 > 1 then -- Eddie wants rank 4 for crafting

		if not res then
			TriggerEvent("customNotification","1 = Tuner (100 Elect), 2 = Plate (3 Copper), 3 = Nitrous (2 Alu), 4 = Lockpick Set (2 Steel), 5 = Adv Repair Kit (3 Electronics), 6 = Racing Harness (10 Rubber)")
			return
		end
		local finished = exports["np-taskbar"]:taskBar(1000,"Completing Task",false,true)

		if finished ~= 100 then
			return
		end
		if res == 1 and rank > 1 then
			local hasitems = exports["np-inventory"]:hasEnoughOfItem("electronics",100*amount,true)
			if hasitems then
				TriggerEvent("inventory:removeItem","electronics", 100*amount)
				TriggerEvent("player:receiveItem","tuner",amount)
			end
		elseif res == 2 then

			local hasitems = exports["np-inventory"]:hasEnoughOfItem("copper",3*amount,true)
			if hasitems then
				TriggerEvent("inventory:removeItem","copper", 3*amount)
				TriggerEvent("player:receiveItem","fakeplate",amount)
			end
		elseif res == 3 then

			local hasitems = exports["np-inventory"]:hasEnoughOfItem("aluminium",2*amount,true)
			if hasitems then
				TriggerEvent("inventory:removeItem","aluminium", 2*amount)
				TriggerEvent("player:receiveItem","nitrous",amount)
			end
		elseif res == 4 then

			local hasitems = exports["np-inventory"]:hasEnoughOfItem("steel",2*amount,true)
			if hasitems then
				TriggerEvent("inventory:removeItem","steel", 2*amount)
				TriggerEvent("player:receiveItem","lockpick",amount)
			end
		elseif res == 5 then
			local hasitems = exports["np-inventory"]:hasEnoughOfItem("electronics",3*amount,true)
			if hasitems then
				TriggerEvent("inventory:removeItem","electronics", 3*amount)
				TriggerEvent("player:receiveItem","advrepairkit",amount)
			end
		elseif res == 6 and rank > 1 then
			local hasitems = exports["np-inventory"]:hasEnoughOfItem("rubber",10*amount,true)
			if hasitems then
				TriggerEvent("inventory:removeItem","rubber", 10*amount)
				TriggerEvent("player:receiveItem","harness",amount)
			end
		else
			TriggerEvent("customNotification","You do not have the skills to craft this item.")
		end
	end
end)

RegisterNetEvent('repo:success')
AddEventHandler('repo:success', function(netId)
	--SetEntityAsMissionEntity(vehicle,false,true)
	local vehicle = NetToVeh(netId)
	DeleteEntity(vehicle)
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
end)

Controlkey = {["generalUse"] = {38,"E"},["generalUseSecondary"] = {18,"Enter"},["generalUseThird"] = {47,"G"},["generalUseSecondaryWorld"] = {23,"F"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["generalUse"] = table["generalUse"]
	Controlkey["generalUseSecondary"] = table["generalUseSecondary"]
	Controlkey["generalUseThird"] = table["generalUseThird"]
	Controlkey["generalUseSecondaryWorld"] = table["generalUseSecondaryWorld"]
end)


garagedrop = {
	[1] =  { ['x'] = 540.03,['y'] = -196.76,['z'] = 54.49,['h'] = 77.89, ['info'] = ' Garage 1 Sales' },
	[2] =  { ['x'] = 980.4,['y'] = -141.55,['z'] = 74.23,['h'] = 65.56, ['info'] = ' Garage 2 Sales' },
	[3] =  { ['x'] = 1183.18,['y'] = 2651.66,['z'] = 37.81,['h'] = 20.08, ['info'] = ' Garage 3 Sales' },
	[4] =  { ['x'] = 955.83,['y'] = -958.05,['z'] = 40.0,['h'] = 351.64, ['info'] = ' Garage 4 Sales' }, -- Tuner Shop
	[5] =  { ['x'] = 119.16,['y'] = 3596.08,['z'] = 40.27,['h'] = 267.62, ['info'] = ' Garage 5 Sales' },
}

Citizen.CreateThread(function()
	TriggerServerEvent('garage:Update')
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, Keys["Y"]) then
			TriggerServerEvent("towgarage:checkJobBounce",true)
		end

		-- Affiche Marqueur pour faire spawn
		local wait = true

		for i,v in ipairs(garage) do
			if #(vector3(garage[i].x,garage[i].y,garage[i].z) - GetEntityCoords(LocalPed())) < 25 then
				wait = false
				local garageDropDistance = #(vector3(garagedrop[i]["x"],garagedrop[i]["y"],garagedrop[i]["z"]) - GetEntityCoords(LocalPed()))
				if not hasPutCarIn then
					if i == 2 then
						local rank = exports["isPed"]:GroupRank("parts_shop")
						if rank > 0 then
							if garageDropDistance < 5.0 then
								DrawText3Ds(garagedrop[i]["x"],garagedrop[i]["y"],garagedrop[i]["z"],"["..Controlkey["generalUseThird"][2].."] store material ["..Controlkey["generalUseSecondary"][2].."] check materials.")
							end
						end
					elseif i == 3 then
						local rank = exports["isPed"]:GroupRank("repairs_harmony")
						if rank > 0 then
							if garageDropDistance < 5.0 then
								DrawText3Ds(garagedrop[i]["x"],garagedrop[i]["y"],garagedrop[i]["z"],"["..Controlkey["generalUseThird"][2].."] store material ["..Controlkey["generalUseSecondary"][2].."] check materials.")
							end
						end
					elseif i == 4 then
						local rank = exports["isPed"]:GroupRank("tuner_carshop")
						if rank > 0 then
							if garageDropDistance < 5.0 then
								DrawText3Ds(garagedrop[i]["x"],garagedrop[i]["y"],garagedrop[i]["z"],"["..Controlkey["generalUseThird"][2].."] store material ["..Controlkey["generalUseSecondary"][2].."] check materials.")
							end
						end
					elseif i == 5 then
						local rank = exports["isPed"]:GroupRank("lost_mc")
						if rank > 0 then
							if garageDropDistance < 5.0 then
								DrawText3Ds(garagedrop[i]["x"],garagedrop[i]["y"],garagedrop[i]["z"],"["..Controlkey["generalUseThird"][2].."] store material ["..Controlkey["generalUseSecondary"][2].."] check materials.")
							end
						end
					else
						local rank = exports["isPed"]:GroupRank("chop_shop")
						if rank > 0 then
							if garageDropDistance < 5.0 then
								DrawText3Ds(garagedrop[i]["x"],garagedrop[i]["y"],garagedrop[i]["z"],"["..Controlkey["generalUseThird"][2].."] store material ["..Controlkey["generalUseSecondary"][2].."] check materials.")
							end
						end
					end -- If i checks
				end -- If not hasPutCarin

				if IsControlJustPressed(1,Controlkey["generalUseSecondary"][1]) and garageDropDistance < 1.0 then

					local rank = exports["isPed"]:GroupRank("parts_shop")
					local lrank = exports["isPed"]:GroupRank("lost_mc")
					local crank = exports["isPed"]:GroupRank("chop_shop")
					local drank = exports["isPed"]:GroupRank("repairs_harmony")
					local zrank = exports["isPed"]:GroupRank("tuner_carshop")
					if (i == 3 and drank > 0) or (i == 2 and rank > 0) or (i == 1 and crank > 0) or (i == 4 and zrank > 0) or (i == 5 and lrank > 0)  then
						TriggerServerEvent("requestmechanicmaterials","Tow Garage " .. i)
					end

				end

				if IsControlJustPressed(1, Controlkey["generalUseThird"][1]) and garageDropDistance < 1.0 then

					local rank = exports["isPed"]:GroupRank("parts_shop")
					local lrank = exports["isPed"]:GroupRank("lost_mc")
					local crank = exports["isPed"]:GroupRank("chop_shop")
					local drank = exports["isPed"]:GroupRank("repairs_harmony")
					local zrank = exports["isPed"]:GroupRank("tuner_carshop")

					if (i == 3 and drank > 0) or (i == 2 and rank > 0) or (i == 1 and crank > 0) or (i == 4 and zrank > 0) or (i == 5 and lrank > 0) then

						local itemvalues = {
						    [1] = { ["itemid"] = 26, ["itemname"] = "Scrap", ["amount"] = 0,["name"] = "scrapmetal" },
						    [2] = { ["itemid"] = 27, ["itemname"] = "Plastic", ["amount"] = 0 ,["name"] = "plastic" },
						    [3] = { ["itemid"] = 28, ["itemname"] = "Glass", ["amount"] = 0 ,["name"] = "glass" },
						    [4] = { ["itemid"] = 30, ["itemname"] = "Steel", ["amount"] = 0 ,["name"] = "steel" },
						    [5] = { ["itemid"] = 31, ["itemname"] = "Aluminium", ["amount"] = 0 ,["name"] = "aluminium" },
						    [6] = { ["itemid"] = 33, ["itemname"] = "Rubber", ["amount"] = 0 ,["name"] = "rubber" },
						    [7] = { ["itemid"] = 34, ["itemname"] = "Copper", ["amount"] = 0 ,["name"] = "copper" },
						}

						for x = 1, #itemvalues do
							local itemid = itemvalues[x]["itemid"]
							local itemname = itemvalues[x]["itemname"]
							local itemcount = exports["np-inventory"]:getQuantity(itemvalues[x]["name"])

							if itemcount > 0 then
								local finished = exports["np-taskbar"]:taskBar(2000,"Storing " .. itemname)
								if finished == 100 then
									TriggerEvent('inventory:removeItem',itemvalues[x]["name"], itemcount)
									TriggerServerEvent("scrap:processPayment",itemcount,"Tow Garage " .. i,itemid)
									Citizen.Wait(1000)
								end
							end
							Citizen.Wait(100)
						end
					end
				end
			end
		end
		if wait then
			Wait(900)
		end
	end
end)


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

local isInMenu = false

function string:split(delimiter)
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from  )
  end
  table.insert( result, string.sub( self, from  ) )
  return result
end

local degHealth = {
	["breaks"] = 0,-- has neg effect
	["axle"] = 0,	-- has neg effect
	["radiator"] = 0, -- has neg effect
	["clutch"] = 0,	-- has neg effect
	["transmission"] = 0, -- has neg effect
	["electronics"] = 0, -- has neg effect
	["fuel_injector"] = 0, -- has neg effect
	["fuel_tank"] = 0 
}
local engineHealth = 0
local bodyHealth = 0


RegisterNetEvent('towgarage:requestUpdate')
AddEventHandler('towgarage:requestUpdate', function()
	local playerped = PlayerPedId()
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)
	local plate = GetVehicleNumberPlateText(targetVehicle)
	TriggerServerEvent('veh.callDegredation',plate,true)
end)





RegisterNetEvent('towgarage:triggermenu')
AddEventHandler('towgarage:triggermenu', function(degradation)


	local temp = degradation:split(",")
	if(temp[1] ~= nil) then	


		for i,v in ipairs(temp) do
			if i == 1 then
				degHealth.breaks = tonumber(v)
				if degHealth.breaks == nil then
					degHealth.breaks = 0
				end
			elseif i == 2 then
				degHealth.axle = tonumber(v)
			elseif i == 3 then
				degHealth.radiator = tonumber(v)
			elseif i == 4 then
				degHealth.clutch = tonumber(v)
			elseif i == 5 then
				degHealth.transmission = tonumber(v)
			elseif i == 6 then
				degHealth.electronics = tonumber(v)
			elseif i == 7 then
				degHealth.fuel_injector = tonumber(v)
			elseif i == 8 then	
				degHealth.fuel_tank = tonumber(v)
			end
		end
	end

	local playerped = PlayerPedId()
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)



	if targetVehicle ~= nil  and targetVehicle ~= 0 then
		engineHealth = GetVehicleEngineHealth(targetVehicle) 
		bodyHealth = GetVehicleBodyHealth(targetVehicle)
		currentVeh = targetVehicle
		local strng = "\n Brakes (Rubber) - " .. round(degHealth["breaks"] / 10,2) .. "/10.0" .. " \n Axle (Scrap) - " .. round(degHealth["axle"] / 10,2) .. "/10.0" .. " \n Radiator (Scrap) - " .. round(degHealth["radiator"] / 10,2) .. "/10.0" .. " \n Clutch (Scrap) - " .. round(degHealth["clutch"] / 10,2) .. "/10.0" .. " \n Transmission (Aluminium) - " .. round(degHealth["transmission"] / 10,2) .. "/10.0" .. " \n Electronics (Plastic) - " .. round(degHealth["electronics"] / 10,2) .. "/10.0" .. " \n Injector (Copper) - " .. round(degHealth["fuel_injector"] / 10,2) .. "/10.0" .. " \n Fuel (Steel) - " .. round(degHealth["fuel_tank"] / 10,2) .. "/10.0" .. " \n Body (Glass) - " .. round((bodyHealth / 10) / 10,2) .. "/10.0" .. " \n Engine (Scrap) - " .. round((engineHealth / 10) / 10,2) .. "/10.0"
		TriggerEvent("customNotification",strng)

	end
end)


function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

RegisterNetEvent('towgarage:TriggerRepairs')
AddEventHandler('towgarage:TriggerRepairs', function(degname,amount)

	local itemname = "Scrap"
	local itemid = 26
	local garagename = "NAME"
	local notfucked = false
	local current = 100

	if degname == "body" or degname == "Body" then
		itemid = 28
		itemname = "Glass"
		degname = "body"
		notfucked = true
		current = bodyHealth
	end

	if degname == "Engine" or degname == "engine" then
		degname = "engine"
		notfucked = true
		current = engineHealth
	end

	if degname == "brakes" or degname == "Brakes" then
		itemid = 33
		itemname = "Rubber"
		degname = "breaks"
		notfucked = true
		current = degHealth["breaks"]
	end

	if degname == "Axle" or degname == "axle" then
		degname = "axle"
		notfucked = true
		current = degHealth["axle"]
	end

	if degname == "Radiator" or degname == "radiator" then
		degname = "radiator"
		notfucked = true
		current = degHealth["radiator"]
	end

	if degname == "Clutch" or degname == "clutch" then
		degname = "clutch"
		notfucked = true
		current = degHealth["clutch"]
	end

	if degname == "electronics" or degname == "Electronics" then
		degname = "electronics"
		itemid = 27
		itemname = "Plastic"
		notfucked = true
		current = degHealth["electronics"]
	end

	if degname == "fuel" or degname == "Fuel" then
		itemid = 30
		itemname = "Steel"
		degname = "fuel_tank"
		notfucked = true
		current = degHealth["fuel_tank"]
	end

	if degname == "transmission" or degname == "Transmission" then
		itemid = 31
		itemname = "Aluminium"
		degname = "transmission"
		notfucked = true
		current = degHealth["transmission"]
	end

	if degname == "Injector" or degname == "injector" then
		itemid = 34
		itemname = "Copper"
		degname = "fuel_injector"
		notfucked = true
		current = degHealth["fuel_injector"]
	end

	if not notfucked then
		TriggerEvent("customNotification","That part does not exist?",2)
	else

		local garagename = "none?"


		local rank = exports["isPed"]:GroupRank("parts_shop")
		local lrank = exports["isPed"]:GroupRank("lost_mc")
		local crank = exports["isPed"]:GroupRank("chop_shop")
		local drank = exports["isPed"]:GroupRank("repairs_harmony")
		local zrank = exports["isPed"]:GroupRank("tuner_carshop")

		for i,v in ipairs(garage) do	
			if #(vector3(garage[i].x,garage[i].y,garage[i].z) - GetEntityCoords(LocalPed())) < 25 then
				if (i == 3 and drank > 0) or (i == 2 and rank > 0) or (i == 1 and crank > 0) or (i == 4 and zrank > 0) or (i == 5 and lrank > 0) then
					garagename = "Tow Garage " .. i
				end
			end
		end

		if garagename == "none?" then
			return
		end

		local playerped = PlayerPedId()
		RequestAnimDict("mp_car_bomb")
		TaskPlayAnim(playerped,"mp_car_bomb","car_bomb_mechanic",8.0, -8, -1, 49, 0, 0, 0, 0)
		Wait(100)
		TaskPlayAnim(playerped,"mp_car_bomb","car_bomb_mechanic",8.0, -8, -1, 49, 0, 0, 0, 0)

		local finished = exports["np-taskbar"]:taskBar(15000,"Repairing")

		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)

		if garagename == "Tow Garage 5" and not GetVehicleClass(targetVehicle) == 8
		then
			TriggerEvent("customNotification","Only bikes can be repaired here",2)
			return
		end

		if finished == 100 then
			local plate = GetVehicleNumberPlateText(targetVehicle)
			if targetVehicle ~= nil  and targetVehicle ~= 0 then
				TriggerServerEvent('scrap:towTake',amount,0,degname,garagename,current,itemname,plate)
			else
				TriggerEvent("customNotification","No Vehicle")
			end
		else
		end
	end
end)

RegisterNetEvent('towgarage:checkDegMenu')
AddEventHandler('towgarage:checkDegMenu', function(JobCheck,button)
	local isCar = false
	local playerped = PlayerPedId()
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)
	local engineHealth = math.ceil(GetVehicleEngineHealth(targetVehicle))
	local bodyHealth = math.ceil(GetVehicleBodyHealth(targetVehicle))

	local isOwend = false
	if targetVehicle ~= nil  and targetVehicle ~= 0 and not isInMenu then
		if GetVehicleClass(targetVehicle) ~= 13 and GetVehicleClass(targetVehicle) ~= 21 and GetVehicleClass(targetVehicle) ~= 16 and GetVehicleClass(targetVehicle) ~= 15 and GetVehicleClass(targetVehicle) ~= 14 then
			TriggerEvent('veh.isPlayers',targetVehicle,function(result)
				
				if result then
					local plate = GetVehicleNumberPlateText(targetVehicle)
					print("plate: "..plate)

					TriggerServerEvent('veh.callDegredation',plate,true)
				else
					print("cunt")
					isOwend = false
				end
			end)
		else
			TriggerEvent("DoLongHudText", "Cannot check this.",2)
		end
	else
		TriggerEvent("DoLongHudText", "No Vechile targeted.",2)
	end
end)



RegisterNetEvent('towgarage:buyScrap')
AddEventHandler('towgarage:buyScrap', function(amount,garageName)

	local rand = math.random(1,4)
	local selltime = 5000

	if rand == 1 then
		RequestAnimDict("pickup_object")
		TaskPlayAnim(PlayerPedId(),"pickup_object","putdown_low",8.0, -8, -1, 49, 0, 0, 0, 0)
		selltime = 5000
	elseif rand == 2 then
		RequestAnimDict("random@mugging1")
		TaskPlayAnim(PlayerPedId(),"random@mugging1","pickup_low",2.0, -8, 1800, 49, 0, 0, 0, 0)
		selltime = 2200
	elseif rand == 3 then
		RequestAnimDict("missfbi_s4mop")
		TaskPlayAnim(PlayerPedId(),"missfbi_s4mop","plant_bomb_b",8.0, -8, 4000, 49, 0, 0, 0, 0)
		selltime = 4500
	elseif rand == 4 then
		RequestAnimDict("mp_safehousevagos@")
		TaskPlayAnim(PlayerPedId(),"mp_safehousevagos@","package_dropoff",2.0, -8, 4000, 49, 0, 0, 0, 0)
		selltime = 4500
	end
	Wait(selltime)
	ClearPedTasks(LocalPed())
	selling = false
	TriggerServerEvent("scrap:processPayment",amount,garageName)	
	TriggerEvent('inventory:removeItem',"scrapmetal", amount)

end)

RegisterNetEvent('towgarage:flatbed')
AddEventHandler('towgarage:flatbed', function(model)
	Citizen.Wait(0)
	if lastPlate ~= nil then
		TriggerEvent("keys:remove",lastPlate)
	end
	

	local myPed = PlayerPedId()
	local player = PlayerId()
	local vehicle = GetHashKey(model)
	RequestModel(vehicle)
	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

	local plate = "TOW " .. GetRandomIntInRange(1000, 9000)
	local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0)

	local spawned_car = CreateVehicle(vehicle, coords, 25.1887, true, false)

	SetModelAsNoLongerNeeded(vehicle)
	SetVehicleOnGroundProperly(spawned_car)
	SetVehicleNumberPlateText(spawned_car, plate)
	TriggerEvent("keys:addNew",spawned_car,plate)
  	TriggerServerEvent('garges:addJobPlate', plate)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
	lastPlate = plate
	

	--SetEntityAsMissionEntity(spawned_car,false,true)
	Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
end)

local isRepair = false
local curplate = "NONE123"

RegisterNetEvent('towgarage:startRepair')
AddEventHandler('towgarage:startRepair', function(garageName,amount,part,current)
	for i,v in ipairs(garage) do
		if v.Name == garageName then
			isRepair = true


			local offsetMark = {
			GetOffsetFromEntityInWorldCoords(currentVeh, 1.9, 0.0, 0.0),
			GetOffsetFromEntityInWorldCoords(currentVeh, -1.9, 0.0, 0.0),
			GetOffsetFromEntityInWorldCoords(currentVeh, 0.0, 2.5, 0.0),
			GetOffsetFromEntityInWorldCoords(currentVeh, 0.0, -2.5, 0.0),
			}

			local inUse = false	
			local rand = 3

			while isRepair do
				Citizen.Wait(0)

				DrawMarker(27,offsetMark[rand], 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 0, 212, 175, 55, 0, 0, 0, 0)

				if #(offsetMark[rand] - GetEntityCoords(LocalPed())) < 0.9 then
					DisplayHelpText('Press ~g~E~s~ to start repair')

					if IsControlJustPressed(1, Keys["E"]) then
						if inUse then
							TriggerEvent("DoLongHudText","Repair is currently in use", 2)
						else
							inUse = true

							RequestAnimDict("mp_car_bomb")
							TaskPlayAnim(PlayerPedId(),"mp_car_bomb","car_bomb_mechanic",8.0, -8, -1, 49, 0, 0, 0, 0)
							Wait(100)
							TaskPlayAnim(PlayerPedId(),"mp_car_bomb","car_bomb_mechanic",8.0, -8, -1, 49, 0, 0, 0, 0)
							SetEntityHeading(LocalPed(),v.CurrentHead-180)
							FreezeEntityPosition(LocalPed(),true)
							local finished = exports["np-taskbar"]:taskBar(5000,"Repairing")

							if finished == 100 then
								isRepair = false
							else
								isRepair = true
							end

							inUse = false
							ClearPedTasks(LocalPed())
							FreezeEntityPosition(LocalPed(),false)
						end
					end
				end
			end
			if not shouldExitRepair then
				TriggerServerEvent("scrap:takeMoney",amount,garageName,part,current,curplate)
			end
		end
	end
end)




RegisterNetEvent('pv:putVechile')
AddEventHandler('pv:putVechile', function(garageNum)
		local isCar = false
		local playerped = PlayerPedId()
		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)

	if targetVehicle ~= nil  and targetVehicle ~= 0 then

		if GetVehicleClass(targetVehicle) ~= 13 and GetVehicleClass(targetVehicle) ~= 21 and GetVehicleClass(targetVehicle) ~= 16 and GetVehicleClass(targetVehicle) ~= 15 and GetVehicleClass(targetVehicle) ~= 14 then

					curplate = GetVehicleNumberPlateText(targetVehicle)
					TriggerServerEvent('Towgarage:InUse',true,garageNum)

					SetVehicleDoorShut(targetVehicle,0,false,false)
					SetVehicleDoorShut(targetVehicle,1,false,false)
					SetVehicleDoorShut(targetVehicle,2,false,false)
					SetVehicleDoorShut(targetVehicle,3,false,false)
					SetVehicleDoorShut(targetVehicle,5,false,false)
					SetVehicleDoorOpen(targetVehicle,4,true,true)
					

					SetVehicleDoorsLocked(targetVehicle,2)


					isCar = true
					hasPutCarIn = true
				while isCar do
					Citizen.Wait(0)
					local coords = GetOffsetFromEntityInWorldCoords(targetVehicle, 0, 3.5, 0)

					
						if isRepair == false then
							DrawMarker(27,coords.x,coords.y,coords.z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 212, 175, 55, 0, 0, 0, 0)

							if #(vector3(coords.x,coords.y,coords.z-0.5) - GetEntityCoords(LocalPed())) < 2 then
								DisplayHelpText('Press ~g~H~s~ to start or Press ~g~G~s~ to remove Car')
								if IsControlJustPressed(1, Keys["H"]) then						
									local playerped = PlayerPedId()
									local coordA = GetEntityCoords(playerped, 1)
									local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
									local targetVehicle = getVehicleInDirection(coordA, coordB)
									local plate = GetVehicleNumberPlateText(targetVehicle)
									TriggerServerEvent('veh.callDegredation',plate,true)
								elseif IsControlJustPressed(1, Keys["G"]) then
										Menu.hidden = true
									TriggerEvent('towgarage:vechileExit',targetVehicle,garageNum)
									targetVehicle = nil
								end						
							end
						else
							DrawMarker(27,GetOffsetFromEntityInWorldCoords(targetVehicle, 0.0, 5.0, 0.0), 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 55, 0, 0, 0, 0)
							if #(GetOffsetFromEntityInWorldCoords(targetVehicle, 0.0, 5.0, 0.0) - GetEntityCoords(LocalPed())) < 1.5 then
								DisplayHelpText('Press ~g~G~s~ to remove Car')
								if IsControlJustPressed(1, Keys["G"]) then
										Menu.hidden = true
										shouldExitRepair = true
									TriggerEvent('towgarage:vechileExit',targetVehicle,garageNum)
									targetVehicle = nil
								end
							end
						end
				end
		else
			TriggerEvent("DoLongHudText", "Cannot put this into the garage.",2)
		end
	else
		TriggerEvent("DoLongHudText", "No Vechile targeted.",2)
	end
	updateRepairAmount = 4
end)
RegisterNetEvent('towgarage:vechileExit')
AddEventHandler('towgarage:vechileExit', function(targetVehicle,garageNum)
		hasPutCarIn = false
		SetVehicleDoorShut(targetVehicle,4,false,false)
		currentVeh = nil
		SetVehicleDoorsLocked(targetVehicle,0)


		isRepair = false
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




RegisterNetEvent("towgarage:ClientUpdate")
AddEventHandler("towgarage:ClientUpdate", function(arrayGarage)
	garage = arrayGarage
end)

RegisterNetEvent('towgarage:conformation')
AddEventHandler('towgarage:conformation', function(string,UIType)

	if UIType == 1 then
		TriggerEvent("DoLongHudText",string, 2)
	elseif UIType == 0 then
		TriggerEvent("DoLongHudText",string, 2)
	elseif UIType == 3 then
		TriggerEvent("DoLongHudText",string, 2)
		selling = false
	end
end)
