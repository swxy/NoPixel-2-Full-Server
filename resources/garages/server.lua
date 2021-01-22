--[[Register]]
-- RegisterServerEvent('checkLicensePlate')
RegisterServerEvent('garages:CheckForSpawnVeh')
RegisterServerEvent('garages:CheckForSpawnVeh2')
RegisterServerEvent('garages:CheckForVeh')
RegisterServerEvent('garages:SetVehOut')
RegisterServerEvent('garages:SetVehIn')
RegisterServerEvent('garages:PutVehInGarages')
RegisterServerEvent('garages:CheckGarageForVeh')

RegisterServerEvent('garages:CheckForSelVeh')
RegisterServerEvent('garages:SelVeh')
RegisterServerEvent('garages:SelVehJudge')
RegisterServerEvent('garages:SelHotVeh')
RegisterServerEvent('ServerRestart')
RegisterServerEvent('updateVehicle')
RegisterServerEvent('garages:addJobPlate')
RegisterServerEvent('garages:delJobPlate')
RegisterServerEvent('garages:SetVehImpounded')
RegisterServerEvent('garages:getVehicleList')
--[[Local/Global]]--

-- Variables
local jobs = {
	{name="Unemployed"},
	{name="Tow Truck Driver"},
	{name="Taxi Driver"},
	{name="Trucker"},
	{name="EMS"},
	{name="Postal Worker"}, 
	{name="Garbage Worker"},
	{name="Government Worker"},
	{name="Stripper"},
	{name="Doctor"},
	{name="Live Streamer"},
}

local lastnane = 
{
	[1] = "Conda",
	[2] = "Stain",
	[3] = "Francis",
	[4] = "Cockburn",
	[5] = "West",
	[6] = "Brown",
	[7] = "Shields",
	[8] = "Muldoon",
	[9] = "Greyson",
	[10] = "Black",
	[11] = "Dick",
	[12] = "Wong",
	[13] = "Wang",
	[14] = "Swallows",
	[15] = "Ali",
	[16] = "Zechschof",
	[17] = "Focker",
	[18] = "McGee",
	[19] = "Fox",
	[20] = "Tacohashi",
	[21] = "Li",
	[22] = "Dehhed",
}

local platesStore = {}
local curJobPlates = {}

local vehicles = {}
local jobPlates = {}
-- Variables

-- Jobs
AddEventHandler('garages:addJobPlate', function(plate)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local job = user:getVar("job") or "Unemployed"
	local msg = "10-74 (Negative) Name: " .. character.first_name .. " " .. character.last_name .. " Phone #: " .. character.phone_number .. " Job: " .. job
	curJobPlates[plate] = msg
end)

AddEventHandler('garages:getVehicleList', function()
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()
	exports.ghmattimysql:execute('SELECT * FROM characters_cars WHERE cid = @cid', { ['@cid'] = char.id }, function(vehicles)
		local v = vehicles[1]
		TriggerClientEvent('phone:Garage', src, vehicles)
		TriggerClientEvent('garages:getVehicles', src, vehicles)
	end)
end)

AddEventHandler('onResourceStart', function(resourceName)
	exports.ghmattimysql:execute('SELECT * FROM characters_cars', {}, function(vehicles)
		for k, v in ipairs(vehicles) do
			if v.vehicle_state == "Out" then
				exports.ghmattimysql:execute("UPDATE characters_cars SET vehicle_state = @state, current_garage = @garage, coords = @coords WHERE license_plate = @plate", {['garage'] = 'Impound Lot', ['state'] = 'Normal Impound', ['coords'] = nil, ['plate'] = v.license_plate})
			end
		end
	end)
end)

-- Jobs


-- Login
-- RegisterServerEvent('garages:loginKeyRequest')
-- AddEventHandler('garages:loginKeyRequest', function(srcPassed)
-- 	local src = tonumber(srcPassed)
-- 	local user = exports["np-base"]:getModule("Player"):GetUser(src)
-- 	local character = user:getCurrentCharacter()
-- 	local state = "Out"
-- 	exports.ghmattimysql:execute("SELECT license_plate FROM characters_cars WHERE vehicle_state = @state AND cid = @cid",{  ['state'] = state, ["cid"} = character.id}, function(result)
-- 		local myKeys = {}
-- 		if(result)then
-- 			for k,v in ipairs(result) do
-- 				table.insert(myKeys,v.license_plate) 
-- 			end
-- 			if #myKeys > 0 then
-- 				TriggerClientEvent('garages:giveLoginKeys',src,myKeys)
-- 			end
-- 		end
-- 	end)
-- end)
-- Login


-- Player Garage Manager
-- AddEventHandler('garages:PutVehInGarages', function())
-- 	local src = tonumber(srcPassed)
-- 	local user = exports["np-base"]:getModule("Player"):GetUser(src)
-- 	local character = user:getCurrentCharacter()
-- 	local player = user:getVar("hexid")
-- 	local state = "In"

-- 	-- todo
-- end)

-- Fake Plate
RegisterServerEvent('fakeplate:change')
AddEventHandler('fakeplate:change', function(plate)
	local src = source
	if not plateChangesReturn[plate] then
		local newplate = ""
		for i = 1, 8 do 
			local entry = math.random(50) >= 25 and string.char(math.random(65, 90)) or tostring(math.random(0, 9))
			newplate = newplate .. entry
		end
		newplate = string.upper(tostring(newplate))
		plateChanges[plate] = newplate
		TriggerEvent("fakeplates:changed",newplate)
		plateChangesReturn[newplate] = plate
		TriggerEvent("vehicleMod:changePlate", newplate, true, plate)
		TriggerClientEvent("fakeplate:accepted",src,newplate,true,plate)
	else
		local oldPlate = plateChangesReturn[plate]
		TriggerEvent("vehicleMod:changePlate", oldPlate, false)
		TriggerClientEvent("fakeplate:accepted",src,oldPlate,false)
		plateChanges[oldPlate] = nil
		plateChangesReturn[plate] = nil
	end
end)
-- Fake Plate


-- Checks / Updates
RegisterServerEvent('checkVehVin')
AddEventHandler('checkVehVin', function(plate)
	local src = source
	if not plateChangesReturn[plate] then
		TriggerClientEvent("customNotification",src,"This vehicles vin number matches to current plate")
	else
		local oldPlate = plateChangesReturn[plate]
		TriggerClientEvent("customNotification",src,"This vehicles vin number matches to another plate:" .. oldPlate)
	end
end)

RegisterServerEvent('updateHotPlatesServer')
AddEventHandler('updateHotPlatesServer', function(hotPlates2,hotPlatesReason2)
	hotPlates = hotPlates2
	hotPlatesReason = hotPlatesReason2
end)

AddEventHandler('updateVehicle', function(vehicleMods,plate)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	if not user then return end
	local char = user:getCurrentCharacter()
	if not char then return end
	local owner = user:getVar("hexid")
	if not owner then return end
	vehicleMods = json.encode(vehicleMods)
	exports.ghmattimysql:execute("UPDATE characters_cars SET data=@mods WHERE license_plate = @plate",
	{['mods'] = vehicleMods, ['plate'] = plate})
end)

AddEventHandler("garages:CheckGarageForVeh", function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local owner = char.id

    exports.ghmattimysql:execute('SELECT * FROM characters_cars WHERE cid = @cid', { ['@cid'] = owner }, function(vehicles)
		local v = vehicles[1]
        TriggerClientEvent('phone:Garage', src, vehicles)
        TriggerClientEvent('garages:getVehicles', src, vehicles)
    end)
end)

AddEventHandler("garages:SetVehIn",function(plate, garage, fuel)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()
	local owner = char.id
	local state = "In"
	exports.ghmattimysql:execute("UPDATE characters_cars SET vehicle_state = @state, current_garage = @garage, fuel = @fuel, coords = @coords WHERE license_plate = @plate", {['garage'] = garage, ['state'] = state, ['plate'] = plate,  ['fuel'] = fuel, ['coords'] = nil})
end)

AddEventHandler('garages:SetVehOut', function(vehicle, plate)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()
	local owner = char.id
	local state = "Out"
	 exports.ghmattimysql:execute("UPDATE characters_cars SET vehicle_state = @state WHERE license_plate = @plate", {['garage'] = garage, ['state'] = state, ['plate'] = plate})
  end)

  AddEventHandler('garages:CheckForVeh', function()
	local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()
	local state = "Out"

	 
	  exports.ghmattimysql:execute('SELECT * FROM characters_cars WHERE cid = @cid AND vehicle_state = @state', {['@cid'] = char.id, ['@state'] = state, ['@vehicle'] = vehicle}, function(result)
		if result[1] ~= nil then
			local plates = result[1].license_plate
			vehiclse = json.decode(result[1].data)
			vehicle = result[1].model
			fuel = result[1].fuel
			TriggerClientEvent('garages:StoreVehicle', src, plates)
		else
			TriggerClientEvent('DoLongHudText', src, 'You dont own this car', 2)
		end
		
	end)
  end)



AddEventHandler('garages:CheckForSpawnVeh', function(veh_id, garageCost)
	local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()
	local owner = char.id
	local veh_id = veh_id
	print('this is veh_id ', veh_id)
			exports.ghmattimysql:execute('SELECT * FROM characters_cars WHERE id = @id AND cid = @cid', {['@id'] = veh_id, ['@cid'] = char.id}, function(result)
				local res = result[1]
				local currentgarage = res.current_garage
				print('fuck you ', currentgarage)
				vehiclse = json.decode(result[1].data)
				vehicle = vehiclse
				print(res.coords)
				print(res.vehicle_state)
				TriggerClientEvent('garages:SpawnVehicle', src, currentgarage, res.model, res.license_plate, res.data, res.vehicle_state, res.fuel, res.engine_damage, res.body_damage)
			end)
end)


RegisterServerEvent('ImpoundLot')
AddEventHandler('ImpoundLot', function()
local src = source
local user = exports["np-base"]:getModule("Player"):GetUser(src)
local char = user:getCurrentCharacter()
user:removeMoney(100)
end)
-- Checks / Updates

-- Functions
function setVehiclesIn()
	local serverNumber = GetConvarInt("sv_servernumber")
	exports.ghmattimysql:execute("UPDATE characters_cars SET vehicle_state=@in WHERE vehicle_state = @out AND server_number = @serverNumber",
	{["in"] = "In", ["out"] = "Out", ["serverNumber"] = serverNumber})
end

SetTimeout(10000, setVehiclesIn)

function ResetGarageCache()
	lastrun = 0
	SetTimeout(300000, ResetGarageCache)
end
SetTimeout(300000, ResetGarageCache)

function lastPayment(olddate)
	local days = (os.time() - olddate) / 86400
	days = math.ceil(days * 100) / 100
	if days > 15 then days = 15 end return days
end
-- Functions




-- Callbacks
RegisterServerEvent('garages:askRequest')
AddEventHandler('garage:askRequest', function(returnTarget, isWanting)
	TriggerClientEvent('garages:clientResult',returnTarget,isWanting)
end)

RegisterServerEvent('garages:askResult')
AddEventHandler('garage:askResult', function(target)
	local src = source
	TriggerClientEvent('garages:askingForVeh',target,src)
end)
-- Callbacks



-- Car Sales
RegisterServerEvent('CancelSale')
AddEventHandler('CancelSale', function(player)
	local player = tonumber(player)
	TriggerClientEvent("CancelNow",player)
end)

AddEventHandler('garages:SelVehJudge', function(plate)
	local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()
	local owner = char.id
	
	local player = user:getVar("hexid")
	exports.ghmattimysql:execute("SELECT purchase_price FROM characters_cars WHERE license_plate = @plate",{['username'] = player, ['vehicle'] = vehicle}, function(result)

		if(result)then
			for k,v in ipairs(result) do
				price = v.purchase_price
				local price = price / 2
				TriggerClientEvent("DoLongHudText","Vehicle was seized for $" .. price,1)
			end
		end

		exports.ghmattimysql:execute("DELETE from characters_cars WHERE license_plate = @plate AND cid = @cid",
		{['username'] = player, ['plate'] = plate, ["cid"] = character.id})
		TriggerClientEvent("DoLongHudText",src, "Sold",1)
	end)
end)

AddEventHandler('garages:SelHotVeh', function()
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	
	local player = user:getVar("hexid")
	local price = math.random(1550,3400)
	local userDCash = user:getDirtyMoney()
	user:alterDirtyMoney(userDCash + price)

	TriggerClientEvent("DoLongHudText", "Sold vehicle for $" .. price .. "",1)

	local randomchance = math.random(0,100)
	if randomchance > 80 then
		TriggerClientEvent("outlawNotifyGTASALE",-1)
	end

end)

RegisterServerEvent('garages:SellToPlayer')
AddEventHandler('garages:SellToPlayer', function(price,plate,player)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()

	local state = "Out"
	local player = user:getVar("hexid")

	exports.ghmattimysql:execute("SELECT model,license_plate FROM characters_cars WHERE vehicle_state =@state AND license_plate =@plate AND cid = @cid", function(result)
		if(result and result[1] )then
			local vehicle, vehPlate = result[1].model, result[1].license_plate
			TriggerClientEvent('garages:SelVehicleToPlayer', src, vehicle, vehPlate,player,price)
		end
	end)
end)

AddEventHandler('garages:SellVeh', function(plate)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()

	local player = user:getVar("hexid")
	exports.ghmattimysql:execute("SELECT purchase_price FROM characters_cars WHERE license_plate = @plate",{['username'] = player, ['vehicle'] = vehicle, ['plate'] = plate, ["cid"] = character.id}, function(result)
		if (result) then
			for k,v in ipairs(result) do
				price = v.purchase_price
			local price = price / 2
			user:addMoney((price))
			end
		end

		exports.ghmattimysql:execute("DELETE from characters_cars WHERE license_plate = @plate AND cid = @cid",
		{['username'] = player, ['plate'] = plate, ["cid"] = character.id})
		TriggerClientEvent("DoLongHudText",src, "Sold",1)
	end)
end)

RegisterServerEvent('garages:SellToPlayerEnd')
AddEventHandler('garages:SellToPlayerEnd', function(plate,target,price)
	local src = source
	local target = tonumber(target)
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local player = user:getVar("hexid")
	if src == target then return end
	local userTarg = exports["np-base"]:getModule("Player"):GetUser(target)
	local characterTarg = userTarg:getCurrentCharacter()
	local playerID = userTarg:getVar("hexid")
	local targetCid = characterTarg.id

	local phone_number = characterTarg.phone_number .. " | " .. characterTarg.first_name .. " " .. characterTarg.last_name

	if userTarg:getCash() >= price then 
		exports.ghmattimysql:execute("SELECT id FROM characters_cars WHERE license_plate = @plate",{['username'] = player, ['vehicle'] = vehicle, ['plate'] = plate}, function(result)
			if(result[1]) then 
				userTarg:removeMoney(price)
				user:addMoney(price)
				exports.ghmattimysql:execute("UPDATE characters_cars SET cid=@targetcid, phone_number=@phone_number WHERE license_plate = @plate AND cid = @cid",
				{['targetCid'] = targetCid, ['plate'] = plate, ["cid"] = character.id, ['phone_number'] = phune_number })
					exports["np-log"]:AddLog("Vehicle Transfer", user, "Char "..character.id.." Sold a vehicle [" .. plate .. "] to Char" .. targetCid.." for"..price)
					TriggerClientEvent('garages:ClientEnd',src,plate)
					TriggerClientEvent('garages:PlayerEnd',target,plate)
					TriggerClientEvent("DoLongHudText",src, "Sold",1)
			end
		end)
	else
		TriggerClientEvent("DoLongHudText",src, "Person Does not have required Money on them.",2)
	end
end)
-- Car Sales


-- math.randomseed(os.time())
-- p1 = math.random(1,15)
-- p2 = math.random(1,#locations)
-- p3 = math.random(26,#locations)
-- chopshoplocation = locations[p1]
-- plateslocation = locations[p2]
-- mechaniclocation = locations[p3]

-- -- engine upgrades #1 -- based on top speeds // fInitialDriveMaxFlatVel
-- -- suspension #2 -- based on dampaners // fSuspensionForce
-- -- tyres #3 -- based on traction // fTractionLossMult
-- -- metal #4 -- based on weight // fMass
-- -- aerodynamics #5 -- based on downforce // fDownforceMultipier
-- -- breaking systems #6 -- based on break - handbrake force // fBrakeForce
-- -- gearboxes #7 - based on gear count // nInitialDriveGears

local totalsales = 0
local values = {
	[1] = { ["text"] = "Engine Parts", ["factor"] = "fInitialDriveMaxFlatVel", ["min"] = 0, ["max"] = 400, ["sales"] = 0, ["item"] = 'EnginePart' },
	[2] = { ["text"] = "Suspension Parts", ["factor"] = "fSuspensionForce", ["min"] = 0, ["max"] = 5, ["sales"] = 0, ["item"] = 'SuspensionPart' },
	[3] = { ["text"] = "Dampener Parts", ["factor"] = "fSuspensionCompDamp", ["min"] = 0, ["max"] = 2, ["sales"] = 0, ["item"] = 'DampenerPart' },
	[4] = { ["text"] = "Tyre Parts", ["factor"] = "fSteeringLock", ["min"] = 0, ["max"] = 40, ["sales"] = 0, ["item"] = 'TyrePart' },
	[5] = { ["text"] = "Metal Parts", ["factor"] = "fMas", ["min"] = 0, ["max"] = 3300, ["sales"] = 0, ["item"] = 'MetalPart' },
	[6] = { ["text"] = "Aerodynamics", ["factor"] = "fDownforceMultipier", ["min"] = 0, ["max"] = 2, ["sales"] = 0, ["item"] = 'AerodynamicsPart' },
	[7] = { ["text"] = "Braking Parts", ["factor"] = "fBrakeForce", ["min"] = 0, ["max"] = 1, ["sales"] = 0, ["item"] = 'BrakingPart' },
	[1] = { ["text"] = "Gearbox Parts", ["factor"] = "fClutchChangeRateScaleUpShift", ["min"] = 0, ["max"] = 7, ["sales"] = 0, ["item"] = 'GearboxPart' },
}

RegisterServerEvent("request:illegal:upgrades")
AddEventHandler("request:illegal:upgrades", function(plt)
	local src = source
	exports.ghmattimysql:execute("SELECT Extractors,Filter,Suspension,Rollbars,Bored,Carbon,LFront,RFront,LBack,RBack FROM modded_cars WHERE license_plate = @plt", {["plt"] = plt}, function(result)
		if result[1] ~= nil then

			local Extractors = result[1].Extractors
			local Filter = result[1].Filter
			local Suspension = result[1].Suspension
			local Rollbars = result[1].Rollbars
			local Bored = result[1].Bored
			local Carbon = result[1].Carbon
			-- Door Inv Mods
			local LFront = result[1].LFront
			local RFront = result[1].RFront
			local LBack = result[1].LBack
			local RBack = result[1].RBack

			TriggerClientEvent("client:illegal:upgrades",src,Extractors,Filter,Suspension,Rollbars,Bored,Carbon,plt,LFront,RFront,LBack,RBack)
		end
	end)
end)

RegisterServerEvent("upgradeAttempt:illegalparts")
AddEventHandler("upgradeAttempt:illegalparts", function(partnum,Lplate)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)

	if partnum == 1 then
		theVar = "Extractors"
	elseif partnum == 2 then
		theVar = "Filter"
	elseif partnum == 3 then
		theVar = "Suspension"
	elseif partnum == 4 then
		theVar = "Rollbars"
	elseif partnum == 5 then
		theVar = "Bored"
	elseif partnum == 6 then
		theVar = "Carbon"
	elseif partnum == 7 then
		theVar = "LFront"
	elseif partnum == 8 then
		theVar = "RFront"
	elseif partnum == 9 then
		theVar = "LBack"
	elseif partnum == 10 then
		theVar = "RBack"
	end

	exports.ghmattimysql:execute("SELECT " .. theVar .. " FROM modded_cars WHERE license_plate = @plate", {['plate'] = lplate}, function(result)
		if result[1] ~= nil then

			local resFac = result[1][theVar]

			if resFac == 0 or resFac == nil then
				exports.ghmattimysql:execute("UPDATE modded_cars SET " ..theVar.."=@state WHERE license_plate = @plate", {['plate'] = lplate, ['state'] = 1})
				TriggerClientEvent("client:illegal:upgrades:accept",src,lplate,partnum,1)
			else
				exports.ghmattimysql:execute("UPDATE modded_cars SET " ..theVar.."=@state WHERE license_plate = @plate", {['plate'] = lplate, ['state'] = 0})
				TriggerClientEvent("client:illegal:upgrades:accept",src,lplate,partnum,0)
			end

		end
	end)
end)