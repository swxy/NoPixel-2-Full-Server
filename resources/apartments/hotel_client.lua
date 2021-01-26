local buildingSpawn = { x = 175.09986877441 , y = -904.7946166992, z = -98.999984741211}
local ingarage = false
--Max X = 190 Min X = ?
-- Max Z = 30 Min Z = -98
local garageNumber = 0
local curRoom = { x = 1420.0, y = 1420.0, z = -900.0 }
local centerPos = { x = 343.01187133789, y = -950.25201416016, z = -99.0 }
local myroomcoords = { x = 175.09986877441 , y = -904.7946166992, z = -98.999984741211 }
local currentRoom = {}
local CurrentForced = {x = 0.0,y = 0.0,z=0.0}
local insideApartment = false
local showhelp = false
currentselection = 1
curappartmentnumber = 0
forcedID = 0


local selectedspawnposition = nil

RegisterNetEvent('Relog')
AddEventHandler('Relog', function()
	currentselection = 1
	TriggerServerEvent('isVip')
	TriggerEvent('rehab:changeCharecter')
	TriggerServerEvent('checkTypes')
	TriggerEvent("resetinhouse")
	TriggerEvent("fx:clear")
	TriggerServerEvent('tattoos:retrieve')
	TriggerServerEvent('Blemishes:retrieve')
	TriggerServerEvent("currentconvictions")
	TriggerServerEvent("GarageData")
    TriggerServerEvent("Evidence:checkDna")
	TriggerEvent("banking:viewBalance")
	TriggerServerEvent("police:getLicensesCiv")
	TriggerServerEvent('np-doors:requestlatest')
	TriggerServerEvent("item:UpdateItemWeight")
	TriggerServerEvent("np-weapons:getAmmo")
	TriggerServerEvent("ReturnHouseKeys")
	TriggerServerEvent("requestOffices")
    Wait(500)
    TriggerServerEvent("Police:getMeta")
   	-- Anything that might need to wait for the client to get information, do it here.
	Wait(3000)
	TriggerServerEvent("bones:server:requestServer")
	TriggerEvent("apart:GetItems")
	TriggerServerEvent("TokoVoip:clientHasSelecterCharecter")
	
	Wait(4000)
	TriggerServerEvent('np-base:sv:player_control')
	TriggerServerEvent('np-base:sv:player_settings')
end)
apartments1 = {
	[1] = { ["x"] = 312.96966552734,["y"] = -218.2705078125, ["z"] = 54.221797943115},
	[2] = { ["x"] = 311.27377319336,["y"] = -217.74626159668, ["z"] = 54.221797943115},
	[3] = { ["x"] = 307.63830566406,["y"] = -216.43359375, ["z"] = 54.221797943115}, 
	[4] = { ["x"] = 307.71112060547,["y"] = -213.40884399414, ["z"] = 54.221797943115}, 
	[5] = { ["x"] = 309.95989990234,["y"] = -208.48258972168, ["z"] = 54.221797943115},
	[6] = { ["x"] = 311.78106689453,["y"] = -203.50025939941, ["z"] = 54.221797943115}, 
	[7] = { ["x"] = 313.72155761719,["y"] = -198.6107635498, ["z"] = 54.221797943115},
	[8] = { ["x"] = 315.5329284668,["y"] = -195.24925231934, ["z"] = 54.226440429688},
	[9] = { ["x"] = 319.23147583008,["y"] = -196.4300994873, ["z"] = 54.226451873779},
	[10] = { ["x"] = 321.08117675781,["y"] = -197.23593139648, ["z"] = 54.226451873779},
	[11] = { ["x"] = 312.98037719727,["y"] = -218.36080932617, ["z"] = 58.019248962402},
	[12] = { ["x"] = 311.10736083984,["y"] = -217.64399719238, ["z"] = 58.019248962402},
	[13] = { ["x"] = 307.37707519531,["y"] = -216.34501647949, ["z"] = 58.019248962402},
	[14] = { ["x"] = 307.76007080078,["y"] = -213.59916687012, ["z"] = 58.019248962402},
	[15] = { ["x"] = 309.76248168945,["y"] = -208.25439453125, ["z"] = 58.019248962402},
	[16] = { ["x"] = 311.48220825195,["y"] = -203.75033569336, ["z"] = 58.019248962402},
	[17] = { ["x"] = 313.65570068359,["y"] = -198.22790527344, ["z"] = 58.019248962402},
	[18] = { ["x"] = 315.47378540039,["y"] = -195.19331359863, ["z"] = 58.019248962402},
	[19] = { ["x"] = 319.39694213867,["y"] = -196.58866882324, ["z"] = 58.019248962402},
	[20] = { ["x"] = 321.19458007813,["y"] = -197.31185913086, ["z"] = 58.019248962402},
	[21] = { ["x"] = 329.49240112305,["y"] = -224.92803955078, ["z"] = 54.221771240234},
	[22] = { ["x"] = 331.33309936523,["y"] = -225.56880187988, ["z"] = 54.221771240234},
	[23] = { ["x"] = 335.18447875977,["y"] = -227.14477539063, ["z"] = 54.221771240234},
	[24] = { ["x"] = 336.71957397461,["y"] = -224.66767883301, ["z"] = 54.221771240234},
	[25] = { ["x"] = 338.79501342773,["y"] = -219.11264038086, ["z"] = 54.221771240234},
	[26] = { ["x"] = 340.43829345703,["y"] = -214.78857421875, ["z"] = 54.221771240234},
	[27] = { ["x"] = 342.28509521484,["y"] = -209.32579040527, ["z"] = 54.221771240234},
	[28] = { ["x"] = 344.39224243164,["y"] = -204.4561920166, ["z"] = 54.221881866455},
	[29] =  { ['x'] = 346.75,['y'] = -197.52,['z'] = 54.23 },
	[30] = { ["x"] = 329.7096862793,["y"] = -224.65902709961, ["z"] = 58.019248962402}, 
	[31] = { ["x"] = 331.52966308594,["y"] = -225.52110290527, ["z"] = 58.019248962402}, 
	[32] = { ["x"] = 335.16506958008,["y"] = -227.07464599609, ["z"] = 58.019248962402},
	[33] = { ["x"] = 336.35406494141,["y"] = -224.58212280273, ["z"] = 58.019245147705}, 
	[34] = { ["x"] = 338.56127929688,["y"] = -219.3408203125, ["z"] = 58.019245147705},

	[35] = { ["x"] = 340.46,["y"] = -214.74, ["z"] = 58.019245147705},
	[36] = { ["x"] = 342.46,["y"] = -209.41, ["z"] = 58.019245147705},
	[37] = { ["x"] = 344.41,["y"] = -204.83, ["z"] = 58.019245147705}, 

	[38] =  { ['x'] = -1498.02,['y'] = -664.59,['z'] = 33.39,['h'] = 128.87, ['info'] = ' Bay City Ave / App 36' , ['apt'] = 1 },
	[39] =  { ['x'] = -1489.69,['y'] = -671.15,['z'] = 33.39,['h'] = 134.21, ['info'] = ' Bay City Ave / App 69' , ['apt'] = 1 },
	[40] =  { ['x'] = -1493.46,['y'] = -668.06,['z'] = 33.39,['h'] = 141.4, ['info'] = ' Bay City Ave / App 37' , ['apt'] = 1 },
	[41] =  { ['x'] = -1461.53,['y'] = -641.04,['z'] = 33.39,['h'] = 304.53, ['info'] = ' Bay City Ave / App 18' , ['apt'] = 1 },
	[42] =  { ['x'] = -1458.35,['y'] = -645.91,['z'] = 33.39,['h'] = 308.11, ['info'] = ' Bay City Ave / App 19' , ['apt'] = 1 },
	[43] =  { ['x'] = -1456.04,['y'] = -648.95,['z'] = 33.39,['h'] = 306.76, ['info'] = ' Bay City Ave / App 20' , ['apt'] = 1 },
	[44] =  { ['x'] = -1452.73,['y'] = -653.47,['z'] = 33.39,['h'] = 301.36, ['info'] = ' Bay City Ave / App 21' , ['apt'] = 1 },
	[45] =  { ['x'] = -1454.63,['y'] = -655.6,['z'] = 33.39,['h'] = 215.46, ['info'] = ' Bay City Ave / App 22' , ['apt'] = 1 },
	[46] =  { ['x'] = -1459.41,['y'] = -658.81,['z'] = 33.39,['h'] = 213.78, ['info'] = ' Bay City Ave / App 23' , ['apt'] = 1 },
	[47] =  { ['x'] = -1463.32,['y'] = -661.53,['z'] = 33.39,['h'] = 210.0, ['info'] = ' Bay City Ave / App 24' , ['apt'] = 1 },
	[48] =  { ['x'] = -1467.84,['y'] = -665.24,['z'] = 33.39,['h'] = 189.07, ['info'] = ' Bay City Ave / App 25' , ['apt'] = 1 },
	[49] =  { ['x'] = -1471.78,['y'] = -668.02,['z'] = 33.39,['h'] = 214.32, ['info'] = ' Bay City Ave / App 26' , ['apt'] = 1 },
	[40] =  { ['x'] = -1476.37,['y'] = -671.31,['z'] = 33.39,['h'] = 216.08, ['info'] = ' Bay City Ave / App 27' , ['apt'] = 1 },
	[41] =  { ['x'] = -1464.99,['y'] = -639.7,['z'] = 33.39,['h'] = 35.06, ['info'] = ' Bay City Ave / App 28' , ['apt'] = 1 },
	[42] =  { ['x'] = -1469.15,['y'] = -643.43,['z'] = 33.39,['h'] = 35.14, ['info'] = ' Bay City Ave / App 29' , ['apt'] = 1 },
	[43] =  { ['x'] = -1473.23,['y'] = -646.27,['z'] = 33.39,['h'] = 32.85, ['info'] = ' Bay City Ave / App 30' , ['apt'] = 1 },
	[44] =  { ['x'] = -1477.85,['y'] = -649.78,['z'] = 33.39,['h'] = 32.61, ['info'] = ' Bay City Ave / App 31' , ['apt'] = 1 },
	[45] =  { ['x'] = -1481.81,['y'] = -652.67,['z'] = 33.39,['h'] = 33.91, ['info'] = ' Bay City Ave / App 32' , ['apt'] = 1 },
	[46] =  { ['x'] = -1486.47,['y'] = -655.77,['z'] = 33.39,['h'] = 36.38, ['info'] = ' Bay City Ave / App 33' , ['apt'] = 1 },
	[47] =  { ['x'] = -1490.7,['y'] = -658.4,['z'] = 33.39,['h'] = 33.02, ['info'] = ' Bay City Ave / App 34' , ['apt'] = 1 },
	[48] =  { ['x'] = -1495.22,['y'] = -661.82,['z'] = 33.39,['h'] = 38.31, ['info'] = ' Bay City Ave / App 35' , ['apt'] = 1 },

	[49] =  { ['x'] = -1481.97,['y'] = -652.46,['z'] = 29.59,['h'] = 31.19, ['info'] = ' Bay City Ave / App 6' , ['apt'] = 1 },
	[50] =  { ['x'] = -1477.95,['y'] = -649.54,['z'] = 29.59,['h'] = 32.3, ['info'] = ' Bay City Ave / App 7' , ['apt'] = 1 },
	[51] =  { ['x'] = -1473.36,['y'] = -646.2,['z'] = 29.59,['h'] = 26.38, ['info'] = ' Bay City Ave / App 8' , ['apt'] = 1 },
	[52] =  { ['x'] = -1469.31,['y'] = -643.41,['z'] = 29.59,['h'] = 29.38, ['info'] = ' Bay City Ave / App 8' , ['apt'] = 1 },
	[53] =  { ['x'] = -1464.75,['y'] = -640.1,['z'] = 29.59,['h'] = 33.84, ['info'] = ' Bay City Ave / App 10' , ['apt'] = 1 },
	[54] =  { ['x'] = -1461.78,['y'] = -641.4,['z'] = 29.59,['h'] = 303.51, ['info'] = ' Bay City Ave / App 11' , ['apt'] = 1 },
	[55] =  { ['x'] = -1452.58,['y'] = -653.29,['z'] = 29.59,['h'] = 300.87, ['info'] = ' Bay City Ave / App 12' , ['apt'] = 1 },
	[56] =  { ['x'] = -1454.68,['y'] = -655.64,['z'] = 29.59,['h'] = 213.03, ['info'] = ' Bay City Ave / App 13' , ['apt'] = 1 },
	[57] =  { ['x'] = -1459.3,['y'] = -658.86,['z'] = 29.59,['h'] = 228.02, ['info'] = ' Bay City Ave / App 14' , ['apt'] = 1 },
	[58] =  { ['x'] = -1463.37,['y'] = -661.72,['z'] = 29.59,['h'] = 214.95, ['info'] = ' Bay City Ave / App 15' , ['apt'] = 1 },
	[59] =  { ['x'] = -1468.05,['y'] = -664.9,['z'] = 29.59,['h'] = 214.39, ['info'] = ' Bay City Ave / App 16' , ['apt'] = 1 },
	[60] =  { ['x'] = -1471.96,['y'] = -667.82,['z'] = 29.59,['h'] = 213.94, ['info'] = ' Bay City Ave / App 17' , ['apt'] = 1 },
	[61] =  { ['x'] = -1497.83,['y'] = -664.47,['z'] = 29.03,['h'] = 137.35, ['info'] = ' Bay City Ave / App 2' , ['apt'] = 1 },
	[62] =  { ['x'] = -1495.04,['y'] = -661.92,['z'] = 29.03,['h'] = 30.17, ['info'] = ' Bay City Ave / App 3' , ['apt'] = 1 },
	[63] =  { ['x'] = -1490.48,['y'] = -658.73,['z'] = 29.03,['h'] = 29.52, ['info'] = ' Bay City Ave / App 4' , ['apt'] = 1 },
	[64] =  { ['x'] = -1486.45,['y'] = -655.88,['z'] = 29.59,['h'] = 37.15, ['info'] = ' Bay City Ave / App 5' , ['apt'] = 1 },

	[65] =  { ['x'] = 485.3,['y'] = 213.35,['z'] = 108.31},
	[66] =  { ['x'] = 525.38,['y'] = 207.42,['z'] = 104.75},
	[67] =  { ['x'] = 527.99,['y'] = 213.69,['z'] = 104.75},
	[68] =  { ['x'] = 531.07,['y'] = 222.29,['z'] = 104.75},
	[69] =  { ['x'] = 526.89,['y'] = 225.87,['z'] = 104.75},
	[70] =  { ['x'] = 519.51,['y'] = 228.31,['z'] = 104.75},
	[71] =  { ['x'] = 510.99,['y'] = 231.24,['z'] = 104.75},
	[72] =  { ['x'] = 504.31,['y'] = 233.97,['z'] = 104.75},
	[73] =  { ['x'] = 497.27,['y'] = 237.05,['z'] = 104.75},
	[74] =  { ['x'] = 490.52,['y'] = 227.01,['z'] = 104.75},
	[75] =  { ['x'] = 487.98,['y'] = 221.05,['z'] = 104.75},
	[76] =  { ['x'] = 485.06,['y'] = 212.41,['z'] = 104.75},
	[77] =  { ['x'] = 482.71,['y'] = 206.25,['z'] = 104.75},
	[78] =  { ['x'] = 486.53,['y'] = 201.95,['z'] = 104.75},
	[79] =  { ['x'] = 508.32,['y'] = 194.19,['z'] = 104.75},
	[80] =  { ['x'] = 515.06,['y'] = 191.39,['z'] = 104.75},
	[81] =  { ['x'] = 520.08,['y'] = 192.44,['z'] = 104.75},
	[82] =  { ['x'] = 522.32,['y'] = 198.72,['z'] = 104.75},
	[83] =  { ['x'] = 508.17,['y'] = 193.98,['z'] = 108.31},
	[84] =  { ['x'] = 515.18,['y'] = 191.49,['z'] = 108.31},
	[85] =  { ['x'] = 520.42,['y'] = 193.04,['z'] = 108.31},
	[86] =  { ['x'] = 522.46,['y'] = 199.33,['z'] = 108.31},
	[87] =  { ['x'] = 486.13,['y'] = 201.89,['z'] = 108.31},
	[88] =  { ['x'] = 482.3,['y'] = 205.83,['z'] = 108.31},
}


myRoomNumber = 1
myRoomLock = true
curRoomType = 1
myRoomType = 1
hid = 0 
isForced = false

function inRoom()
	if #(vector3(myroomcoords.x,myroomcoords.y,myroomcoords.z) - GetEntityCoords(PlayerPedId())) < 40.0 then
		return true
	else
		return false
	end
end


RegisterNetEvent("np-base:spawnInitialized")
AddEventHandler("np-base:spawnInitialized", function(newData)
	local cid = exports["isPed"]:isPed("cid")
	TriggerServerEvent('hotel:load')
	TriggerServerEvent('refresh', cid)
end)


RegisterNetEvent('hotel:forceOut')
AddEventHandler('hotel:forceOut', function(roomNumber,roomtype)
	isForced = false
	returnCurrentRoom(roomtype,roomNumber)
	if #(vector3(CurrentForced.x, CurrentForced.y, CurrentForced.z) - GetEntityCoords(PlayerPedId())) < 90.0 then
		CleanUpArea()
		if roomNumber == 2 then
			SetEntityCoords(PlayerPedId(),267.48132324219,-638.818359375,42.020294189453)
		elseif roomNumber == 3 then
			SetEntityCoords(PlayerPedId(),160.26762390137,-641.96905517578,47.073524475098)
		end
	end
	if myRoomNumber == roomNumber then
		CleanUpArea()
		if #(vector3(CurrentForced.x, CurrentForced.y, CurrentForced.z) - GetEntityCoords(PlayerPedId())) < 90.0 then
			if roomNumber == 2 then
				SetEntityCoords(PlayerPedId(),267.48132324219,-638.818359375,42.020294189453)
			elseif roomNumber == 3 then
				SetEntityCoords(PlayerPedId(),160.26762390137,-641.96905517578,47.073524475098)
			end
		end
	end
end)

RegisterNetEvent('hotel:AttemptUpgrade')
AddEventHandler('hotel:AttemptUpgrade', function()
	if myRoomType < 2 then
		if #(vector3(260.46502685547,-375.28936767578,-44.137680053711) - GetEntityCoords(PlayerPedId())) < 3.0 then
			TriggerServerEvent('hotel:upgradeApartment')
			TriggerEvent("hotel:myroomtype",myRoomType)
		end	
	else
		TriggerEvent('DoLongHudText', 'You already have a motel at integrity', 2)
	end
end)


RegisterCommand("hidecash", function(source, args, rawCommand)
	if args[1] ~= nil then
		TriggerEvent('hotel:AddCashToHotel', args[1])
	end
end)

RegisterCommand("takecash", function(source, args, rawCommand)
	if args[1] ~= nil then
		TriggerEvent('hotel:RemoveCashFromHotel', args[1])
	end
end)

RegisterCommand("checkbed", function(source, args, rawCommand)

TriggerEvent('hotel:CheckCashFromHotel')

end)

RegisterNetEvent('hotel:AddCashToHotel')
AddEventHandler('hotel:AddCashToHotel', function(amount)
	if inRoom() then
		TriggerServerEvent('hotel:AddCashToHotel', amount)
		Citizen.Wait(555)
		TriggerServerEvent("hotel:getInfo")
	end
end)

RegisterNetEvent('hotel:SetID')
AddEventHandler('hotel:SetID', function(hidX)
	hid = hidX
end)
RegisterNetEvent('hotel:SetID2')
AddEventHandler('hotel:SetID2', function(hidX)
	hid = hidX
	forcedID = hidX
end)


RegisterNetEvent('hotel:RemoveCashFromHotel')
AddEventHandler('hotel:RemoveCashFromHotel', function(amount)
	if inRoom() then
		TriggerServerEvent('hotel:RemoveCashFromHotel', amount)
		Citizen.Wait(555)
		TriggerServerEvent("hotel:getInfo")
	end		
end)

RegisterNetEvent('hotel:CheckCashFromHotel')
AddEventHandler('hotel:CheckCashFromHotel', function()
	if inRoom() then
		TriggerServerEvent('hotel:CheckCashFromHotel')
		Citizen.Wait(555)
		TriggerServerEvent("hotel:getInfo")
	end		
end)

RegisterNetEvent('hotel:AddDMToHotel')
AddEventHandler('hotel:AddDMToHotel', function(amount)
	if inRoom() then
		TriggerServerEvent('hotel:AddDMToHotel', amount)
		Citizen.Wait(555)
		TriggerServerEvent("hotel:getInfo")
	end		
end)

RegisterNetEvent('hotel:RemoveDMFromHotel')
AddEventHandler('hotel:RemoveDMFromHotel', function(amount)
	if inRoom() then
		TriggerServerEvent('hotel:RemoveDMFromHotel', amount)
		Citizen.Wait(555)
		TriggerServerEvent("hotel:getInfo")
	end		
end)

RegisterNetEvent("hotel:forceEnter")
AddEventHandler("hotel:forceEnter", function(roomNumber,roomtype)
	roomNumber = tonumber(roomNumber)
	roomtype = tonumber(roomtype)
	isForced = true
	returnCurrentRoom(roomtype,roomNumber)
end)

function returnCurrentRoom(roomtype,roomNumber)
	if roomtype == 3 then
		local generator = { x = -265.68209838867 , y = -957.06573486328, z = 145.824577331543}
		if roomNumber > 0 and roomNumber < 7 then
			--generator = { x = -143.16976928711 , y = -596.31140136719, z = 61.95349121093}
			--generator.z = (61.9534912) + ((roomNumber * 11.0) * roomType)
			generator = { x = 131.0290527343, y = -644.0509033203, z = 68.025619506836}
			generator.z = (68.0534912) + ((roomNumber * 11.0))
		end

		if roomNumber > 6 and roomNumber < 14 then
			generator = { x = -134.43560791016 , y = -638.13916015625, z = 68.953491210938}
			roomNumber = roomNumber - 6
			generator.z = (61.9534912) + ((roomNumber * 11.0))
		end

		if roomNumber > 13 and roomNumber < 20 then
			generator = { x = -181.440234375 , y = -584.04815673828, z = 68.95349121093}
			roomNumber = roomNumber - 13
			generator.z = (61.9534912) + ((roomNumber * 11.0))
		end

		if roomNumber > 19 and roomNumber < 26 then
			generator = { x = -109.9752227783, y = -570.272351074, z = 61.9534912}
			roomNumber = roomNumber - 19
			generator.z = (61.9534912) + ((roomNumber * 11.0))
		end

		if roomNumber > 25 and roomNumber < 38 then
			generator = { x = -3.9463002681732, y = -693.2456665039, z = 103.0334701538}
			roomNumber = roomNumber - 25
			generator.z = (103.0534912) + ((roomNumber * 11.0))
		end

		if roomNumber > 37 and roomNumber < 49 then
			generator = { x = 140.0758819580, y = -748.12322998, z = 87.0334701538}
			roomNumber = roomNumber - 37
			generator.z = (87.0534912) + ((roomNumber * 11.0))
		end

		if roomNumber > 48 and roomNumber < 60 then
			generator = { x = 131.0290527343, y = -644.0509033203, z = 68.025619506836}
			roomNumber = roomNumber - 48
			generator.z = (68.0534912) + ((roomNumber * 11.0))
		end

		CurrentForced = generator

	elseif roomtype == 2 then 
		local generator = { x = 175.09986877441 , y = -904.7946166992, z = -98.999984741211}
		generator.x = (175.09986877441) + ((roomNumber * 25.0))
		generator.y = (-904.7946166992) - ((roomNumber * 25.0))
		CurrentForced = generator
	end
end


RegisterNetEvent('doApartHelp')
AddEventHandler('doApartHelp', function()
	showhelp = true
end)

RegisterNetEvent('hotel:updateLockStatus')
AddEventHandler('hotel:updateLockStatus', function(newStatus)
	myRoomLock = newStatus
end)

RegisterNetEvent('refocusent')
AddEventHandler('refocusent', function()
	TriggerEvent("DoLongHudText","Refocusing entity - abuse of this will result in a ban",2)
	ClearFocus()
end)

RegisterNetEvent('hotel:createRoomFirst')
AddEventHandler('hotel:createRoomFirst', function(numMultiplier,roomType, keys)
	myRoomNumber = numMultiplier
	myRoomType = roomType
	TriggerEvent("hotel:myroomtype",myRoomType)
	-- TriggerEvent('hotel:createRoom', myRoomType, myRoomNumber)
end)


local disablespawn = false
RegisterNetEvent('disablespawn')
AddEventHandler('disablespawn', function(selke)
	disablespawn = selke
end)




local myspawnpoints = {}
local spawning = false
 

RegisterNetEvent('hotel:createRoom')
AddEventHandler('hotel:createRoom', function(source, isImprisoned, isClothesSpawn)

	TriggerServerEvent('hotel:load')
	Citizen.Wait(250)

	local isinprison
	isinprison = isImprisoned
	
	spawning = false
	TriggerEvent("spawning",true)
	FreezeEntityPosition(PlayerPedId(),true)
	SetEntityCoords(PlayerPedId(), 152.09986877441 , -1004.7946166992, -98.999984741211)
	SetEntityInvincible(PlayerPedId(),true)
	myRoomNumber = myRoomNumber
	myRoomType = myRoomType

	myspawnpoints  = {
		[1] =  { ['x'] = -204.93,['y'] = -1010.13,['z'] = 29.55,['h'] = 180.99, ['info'] = ' Altee Street Train Station', ["typeSpawn"] = 1 },
		[2] =  { ['x'] = 272.16,['y'] = 185.44,['z'] = 104.67,['h'] = 320.57, ['info'] = ' Vinewood Blvd Taxi Stand', ["typeSpawn"] = 1 },
		[3] =  { ['x'] = -1833.96,['y'] = -1223.5,['z'] = 13.02,['h'] = 310.63, ['info'] = ' The Boardwalk', ["typeSpawn"] = 1 },
		[4] =  { ['x'] = 145.62,['y'] = 6563.19,['z'] = 32.0,['h'] = 42.83, ['info'] = ' Paleto Gas Station', ["typeSpawn"] = 1 },
		[5] =  { ['x'] = -214.24,['y'] = 6178.87,['z'] = 31.17,['h'] = 40.11, ['info'] = ' Paleto Bus Stop', ["typeSpawn"] = 1 },
		[6] =  { ['x'] = 1122.11,['y'] = 2667.24,['z'] = 38.04,['h'] = 180.39, ['info'] = ' Harmony Motel', ["typeSpawn"] = 1 },
		[7] =  { ['x'] = 453.29,['y'] = -662.23,['z'] = 28.01,['h'] = 5.73, ['info'] = ' LS Bus Station', ["typeSpawn"] = 1 },
		[8] =  { ['x'] = -1266.53,['y'] = 273.86,['z'] = 64.66,['h'] = 28.52, ['info'] = ' The Richman Hotel', ["typeSpawn"] = 1 },
	}


	local devspawn = exports["storage"]:tryGet("vector4","devspawn")
	if devspawn then
		myspawnpoints[#myspawnpoints + 1] = { ['x'] = devspawn.x,['y'] = devspawn.y,['z'] = devspawn.z,['h'] = devspawn.w, ['info'] = 'Dev Spawn', ["typeSpawn"] = 1 }
	end


	if myRoomType == 1 then
		myspawnpoints[#myspawnpoints + 1] = { ['x'] = 326.38,['y'] = -212.11,['z'] = 54.09,['h'] = 166.11, ['info'] = ' Apartments 1', ["typeSpawn"] = 2 }
	elseif myRoomType == 2 then
		myspawnpoints[#myspawnpoints + 1] = { ['x'] = 262.0,['y'] = -639.15,['z'] = 42.88,['h'] = 67.09, ['info'] = ' Apartments 2', ["typeSpawn"] = 2 }
	else
		myspawnpoints[#myspawnpoints + 1] = { ['x'] = 173.96,['y'] = -631.29,['z'] = 47.08,['h'] = 303.12, ['info'] = ' Apartments 3', ["typeSpawn"] = 2 }
	end


	local rooster = exports["isPed"]:GroupRank("rooster_academy")
	if rooster >= 2 then
		myspawnpoints[#myspawnpoints + 1] = { ['x'] = -172.83,['y'] = 331.17,['z'] = 93.76,['h'] = 266.08, ['info'] = ' Rooster Cab', ["typeSpawn"] = 1 }
	end
	
	if isClothesSpawn then
		local apartmentName = ' Apartments 1'
		if myRoomType == 1 then
			apartmentName = ' Apartments 1'
		elseif myRoomType == 2 then
			apartmentName = ' Apartments 2'
		else
			apartmentName = ' Apartments 3'
		end

		for k,v in pairs(myspawnpoints) do
			if v.info == apartmentName then
				currentselection = k
			end
		end

		confirmSpawning(true)
	else
		if isinprison then
			print('not prisoned bruv')
			SendNUIMessage({
				openSection = "main",
			})

			SetNuiFocus(true,true)
			doSpawn(myspawnpoints)
			DoScreenFadeIn(2500)
			doCamera()
		elseif not isinprison then
			print('prisoned bruv')
			TriggerServerEvent("np-shops:getCharecter")
			DoScreenFadeIn(2500)
			doCamera(true)
			prisionSpawn()
		end
	end
 
 
	

end)

function prisionSpawn()
	spawning = true
	DoScreenFadeOut(100)
	Citizen.Wait(100)


	local x = 1708.443
	local y = 2444.588
	local z = 45.73673
	local h = 108.0


	ClearFocus()
	SetNuiFocus(false,false)
	-- spawn them here.
    
    
	RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
	DestroyCam(cam, false)
	SetEntityCoords(PlayerPedId(),x,y,z)
	SetEntityHeading(PlayerPedId(),h)		

	SetEntityInvincible(PlayerPedId(),false)
	FreezeEntityPosition(PlayerPedId(),false)

	Citizen.Wait(2000)

	TriggerEvent("attachWeapons")
	TriggerEvent("spawning",false)

	TriggerEvent("tokovoip:onPlayerLoggedIn", true)
	Citizen.Wait(2000)
	TriggerServerEvent("request-dropped-items")
	TriggerServerEvent("HOWMUCHCASHUHGOT")
	TriggerServerEvent("server-request-update",exports["isPed"]:isPed("cid"))
	TriggerServerEvent("jail:charecterFullySpawend")
	DestroyCam(cam, false)
	 TriggerServerEvent("stocks:retrieveclientstocks")
	 DoScreenFadeIn(1000)
	 Citizen.Wait(1000)
end

RegisterNUICallback('selectedspawn', function(data, cb)

	if spawning then
		return
	end
    currentselection = data.tableidentifier
    -- altercam
    doCamera()
end)
RegisterNUICallback('confirmspawn', function(data, cb)
	spawning = true
	DoScreenFadeOut(100)
	Citizen.Wait(100)
	SendNUIMessage({
		openSection = "close",
	})	
	startcam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	RenderScriptCams(false, true, 500, true, true)
	SetCamActiveWithInterp(cam, cam2, 3700, true, true)
	SetEntityVisible(PlayerPedId(), true, 0)
	FreezeEntityPosition(PlayerPedId(), false)
    SetPlayerInvisibleLocally(PlayerPedId(), false)
    SetPlayerInvincible(PlayerPedId(), false)

    DestroyCam(startcam, false)
    DestroyCam(cam, false)
    DestroyCam(cam2, false)
    Citizen.Wait(0)
    FreezeEntityPosition(GetPlayerPed(-1), false)
	confirmSpawning(false)
end)

function confirmSpawning(isClothesSpawn)

	local x = myspawnpoints[currentselection]["x"]
	local y = myspawnpoints[currentselection]["y"]
	local z = myspawnpoints[currentselection]["z"]
	local h = myspawnpoints[currentselection]["h"]

	ClearFocus()

	SetNuiFocus(false,false)
	-- spawn them here.
    
	RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
	DestroyCam(cam, false)

	
	if myspawnpoints[currentselection]["typeSpawn"] == 1 then
		SetEntityCoords(PlayerPedId(),x,y,z)
		SetEntityHeading(PlayerPedId(),h)		
	elseif myspawnpoints[currentselection]["typeSpawn"] == 2 then
		defaultSpawn()
	else
	end
	
	TriggerServerEvent("server-request-update")
	SetEntityInvincible(PlayerPedId(),false)
	FreezeEntityPosition(PlayerPedId(),false)

	Citizen.Wait(2000)
	DoScreenFadeIn(4000)
	TriggerEvent("attachWeapons")
	TriggerEvent("spawning",false)


	TriggerEvent("tokovoip:onPlayerLoggedIn", true)
	Citizen.Wait(2000)
	TriggerServerEvent("request-dropped-items")
	 TriggerServerEvent("HOWMUCHCASHUHGOT")
	 TriggerServerEvent("server-request-update",exports["isPed"]:isPed("cid"))
	DestroyCam(cam, false)
	TriggerServerEvent("stocks:retrieveclientstocks")


end

--	mykeys[i] = { ["house_name"] = results[i].house_name, ["house_poi"] = pois,  ["table_id"] = results[i].id, ["owner"] = true, ["house_id"] = results[i].house_id, ["house_model"] = results[i].house_model, ["house_name"] = results[i].house_name }

-- "typeSpawn" 1 = no building, 2 = default housing, 3 = house/offices with address
function doSpawn(array)

	for i = 1, #array do

		SendNUIMessage({
			openSection = "enterspawn",
			textmessage = array[i]["info"],
			tableid = i,
		})
	end
	TriggerServerEvent("np-shops:getCharecter")
	-- /halt script fill html and allow selection.
end

cam = 0
local camactive = false
local killcam = true
function doCamera()
	killcam = true
	if spawning then
		return
	end
	Citizen.Wait(1)
	killcam = false
	local camselection = currentselection
	DoScreenFadeOut(1)
	cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

	local x,y,z,h

		 x = myspawnpoints[currentselection]["x"]
		 y = myspawnpoints[currentselection]["y"]
		 z = myspawnpoints[currentselection]["z"]
		 h = myspawnpoints[currentselection]["h"]
	
	i = 3200
	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	DoScreenFadeIn(1500)
	local camAngle = -90.0
	while i > 1 and camselection == currentselection and not spawning and not killcam do
		local factor = i / 50
		if i < 1 then i = 1 end
		i = i - factor
		SetCamCoord(cam, x,y,z+i)
		if i < 1200 then
			DoScreenFadeIn(600)
		end
		if i < 90.0 then
			camAngle = i - i - i
		end
		SetCamRot(cam, camAngle, 0.0, 0.0)
		Citizen.Wait(1)
	end

end


function defaultSpawn()
	moveToMyHotel(myRoomType)	
	TriggerEvent("hotel:myroomtype",myRoomType)
end


RegisterNetEvent('hotel:teleportRoom')
AddEventHandler('hotel:teleportRoom', function(numMultiplier,roomType)
	local numMultiplier = tonumber(numMultiplier)
	local roomType = tonumber(roomType)
	if (#(vector3(106.11, -647.76, 45.1) - GetEntityCoords(PlayerPedId())) < 5 and roomType == 3) or (#(vector3(160.26762390137,-641.96905517578,47.073524475098) - GetEntityCoords(PlayerPedId())) < 5 and roomType == 3) or (#(vector3(267.48132324219,-638.818359375,42.020294189453) - GetEntityCoords(PlayerPedId())) < 5 and roomType == 2) then
		moveToMultiplierHotel(numMultiplier,roomType)
	elseif (#(vector3(apartments1[numMultiplier]["x"],apartments1[numMultiplier]["y"],apartments1[numMultiplier]["z"]) - GetEntityCoords(PlayerPedId())) < 5 and roomType == 1) then
		moveToMultiplierHotel(numMultiplier,roomType)
	else
		TriggerEvent("DoLongHudText","No Entry Point.",2)
	end
	
end)

				

RegisterNetEvent('attemptringbell')
AddEventHandler("attemptringbell",function(apnm)
	if 
	(#(vector3(160.29, -642.06, 47.08) - GetEntityCoords(PlayerPedId()) < 5)) or
	(#(vector3(267.52, -638.79, 42.02) - GetEntityCoords(PlayerPedId()) < 5)) or
	(#(vector3(313.09, -225.83, 54.23) - GetEntityCoords(PlayerPedId()) < 5))
	then
		TriggerServerEvent("confirmbellring",apnm)
		TriggerEvent("buzzer")
	else
		TriggerEvent("DoLongHudText","You are not near a buzzer point.")
	end
end)

RegisterNetEvent('buzzbuzz')
AddEventHandler("buzzbuzz",function(apartmentnumber)

	if tonumber(apartmentnumber) == 0 then
		return
	end
	if tonumber(curappartmentnumber) == tonumber(apartmentnumber) then
		TriggerEvent('InteractSound_CL:PlayOnOne','doorbell', 0.5)
	end

end)

RegisterNetEvent('buzzer')
AddEventHandler("buzzer",function()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1.0, 'doorbell', 0.5)
end)

function moveToMyHotel(roomType)
	TriggerEvent("resetPhone")
	processBuildType(myRoomNumber,roomType)
end

function moveToMultiplierHotel(numMultiplier,roomType)
	processBuildType(tonumber(numMultiplier),tonumber(roomType))
end

function processBuildType(numMultiplier,roomType)
	DoScreenFadeOut(1)
	insideApartment = true
	TriggerEvent("DensityModifierEnable",false)
	TriggerEvent("inhotel",true)
	SetEntityInvincible(PlayerPedId(), true)
	TriggerEvent("enabledamage",false)
	TriggerEvent("dooranim")	
	if roomType == 1 then
		buildRoom(numMultiplier,roomType)
		if showhelp then
			TriggerEvent("customNotification","Welcome to the Hotel, Press P to open your phone and use the help app for more information!")
			showhelp = false
		end
	elseif roomType == 2 then
		buildRoom2(numMultiplier,roomType)
	elseif roomType == 3 then
		buildRoom3(numMultiplier,roomType)
	end

	curappartmentnumber = numMultiplier

	TriggerEvent('InteractSound_CL:PlayOnOne','DoorClose', 0.7)
	TriggerEvent("dooranim")

	CleanUpPeds()
	--DoScreenFadeIn(100)
	SetEntityInvincible(PlayerPedId(), false)
	FreezeEntityPosition(PlayerPedId(),false)
	TriggerEvent("enabledamage",true)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
end
function CleanUpPeds()
    local playerped = PlayerPedId()
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstPed()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(plycoords - pos)
        if distance < 50.0 and ObjectFound ~= playerped then
    		if IsPedAPlayer(ObjectFound) or IsEntityAVehicle(ObjectFound) then
    		else
    			DeleteEntity(ObjectFound)
    		end            
        end
        success, ObjectFound = FindNextPed(handle)
    until not success
    EndFindPed(handle)
end

function CleanUpArea()
    local playerped = PlayerPedId()
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(plycoords - pos)
        if distance < 50.0 and ObjectFound ~= playerped then
        	if IsEntityAPed(ObjectFound) then
        		if IsPedAPlayer(ObjectFound) then
        		else
        			DeleteObject(ObjectFound)
        		end
        	else
        		if not IsEntityAVehicle(ObjectFound) and not IsEntityAttached(ObjectFound) then
	        		DeleteObject(ObjectFound)
	        	end
        	end            
        end
        success, ObjectFound = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    curappartmentnumber = 0
    TriggerEvent("DensityModifierEnable",true)
	TriggerEvent("inhotel",false)
end

function buildRoom(numMultiplier,roomType)
	-- this coord is the default object location, we use it to spawn in the interior.


	SetEntityCoords(PlayerPedId(), 152.09986877441 , -1004.7946166992, -98.999984741211)

	Citizen.Wait(5000)

	local generator = { x = 175.09986877441 , y = -904.7946166992, z = -98.999984741211}
	generator.x = (175.09986877441) + ((numMultiplier * 12.0))
	
	if numMultiplier == myRoomNumber then
		myroomcoords = generator
	else
		curRoom = generator
	end

	SetEntityCoords(PlayerPedId(), generator.x - 1.6, generator.y - 4, generator.z + 0.6)
	local building = CreateObject(`furnitured_motel`,generator.x,generator.y,generator.z,false,false,false)

	FreezeEntityPosition(building,true)
	Citizen.Wait(100)
	FloatTilSafe(numMultiplier,roomType,building)
	
	CreateObject(`v_49_motelmp_stuff`,generator.x,generator.y,generator.z,false,false,false)
	CreateObject(`v_49_motelmp_bed`,generator.x+1.4,generator.y-0.55,generator.z,false,false,false)
	CreateObject(`v_49_motelmp_clothes`,generator.x-2.0,generator.y+2.0,generator.z+0.15,false,false,false)
	CreateObject(`v_49_motelmp_winframe`,generator.x+0.74,generator.y-4.26,generator.z+1.11,false,false,false)
	CreateObject(`v_49_motelmp_glass`,generator.x+0.74,generator.y-4.26,generator.z+1.13,false,false,false)
	CreateObject(`v_49_motelmp_curtains`,generator.x+0.74,generator.y-4.15,generator.z+0.9,false,false,false)

	CreateObject(`v_49_motelmp_screen`,generator.x-2.21,generator.y-0.6,generator.z+0.79,false,false,false)
	--props
	CreateObject(`v_res_fa_trainer02r`,generator.x-1.9,generator.y+3.0,generator.z+0.38,false,false,false)
	CreateObject(`v_res_fa_trainer02l`,generator.x-2.1,generator.y+2.95,generator.z+0.38,false,false,false)
	local door = CreateObject(`prop_sc1_12_door`,generator.x-1.0,generator.y-4.25,generator.z,false,false,true)
	local sink = CreateObject(`prop_sink_06`,generator.x+1.1,generator.y+4.0,generator.z,false,false,false)
	local chair1 = CreateObject(`prop_chair_04a`,generator.x+2.1,generator.y-2.4,generator.z,false,false,false)
	local chair2 = CreateObject(`prop_chair_04a`,generator.x+0.7,generator.y-3.5,generator.z,false,false,false)
	local kettle = CreateObject(`prop_kettle`,generator.x-2.3,generator.y+0.6,generator.z+0.9,false,false,false)
	local tvCabinet = CreateObject(`Prop_TV_Cabinet_03`,generator.x-2.3,generator.y-0.6,generator.z,false,false,false)
	local tv = CreateObject(`prop_tv_06`,generator.x-2.3,generator.y-0.6,generator.z+0.7,false,false,false)
	local toilet = CreateObject(`Prop_LD_Toilet_01`,generator.x+2.1,generator.y+2.9,generator.z,false,false,false)
	local clock = CreateObject(`Prop_Game_Clock_02`,generator.x-2.55,generator.y-0.6,generator.z+2.0,false,false,false)
	local phone = CreateObject(`v_res_j_phone`,generator.x+2.4,generator.y-1.9,generator.z+0.64,false,false,false)
	local ironBoard = CreateObject(`v_ret_fh_ironbrd`,generator.x-1.7,generator.y+3.5,generator.z+0.15,false,false,false)
	local iron = CreateObject(`prop_iron_01`,generator.x-1.9,generator.y+2.85,generator.z+0.63,false,false,false)
	local mug1 = CreateObject(`V_Ret_TA_Mug`,generator.x-2.3,generator.y+0.95,generator.z+0.9,false,false,false)
	local mug2 = CreateObject(`V_Ret_TA_Mug`,generator.x-2.2,generator.y+0.9,generator.z+0.9,false,false,false)
	CreateObject(`v_res_binder`,generator.x-2.2,generator.y+1.3,generator.z+0.87,false,false,false)
	
	FreezeEntityPosition(door, true)
	FreezeEntityPosition(sink,true)
	FreezeEntityPosition(chair1,true)	
	FreezeEntityPosition(chair2,true)
	FreezeEntityPosition(tvCabinet,true)	
	FreezeEntityPosition(tv,true)		
	SetEntityHeading(chair1,GetEntityHeading(chair1)+270)
	SetEntityHeading(chair2,GetEntityHeading(chair2)+180)
	SetEntityHeading(door,GetEntityHeading(door)-180)
	SetEntityHeading(kettle,GetEntityHeading(kettle)+90)
	SetEntityHeading(tvCabinet,GetEntityHeading(tvCabinet)+90)
	SetEntityHeading(tv,GetEntityHeading(tv)+90)
	SetEntityHeading(toilet,GetEntityHeading(toilet)+270)
	SetEntityHeading(clock,GetEntityHeading(clock)+90)
	SetEntityHeading(phone,GetEntityHeading(phone)+220)
	SetEntityHeading(ironBoard,GetEntityHeading(ironBoard)+90)
	SetEntityHeading(iron,GetEntityHeading(iron)+230)
	SetEntityHeading(mug1,GetEntityHeading(mug1)+20)
	SetEntityHeading(mug2,GetEntityHeading(mug2)+230)


	if not isForced then
		TriggerServerEvent('hotel:getID')
	end


	curRoomType = 1

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


-- Citizen.CreateThread(function()
	
--  	while true do
--  		if IsControlJustPressed(1, Controlkey["housingSecondary"][1]) then
-- 			tp =  GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.0, 0.0,-90.0)
-- 			local detector = CreateObject(`xm_detector`,tp.x,tp.y,tp.z,true,true,true)
-- 			FreezeEntityPosition(detector,true)
-- 		end
--  		FreezeEntityPosition(PlayerPedId(),false)
-- 		Citizen.Wait(0)
-- 		DrawMarker(27,-221.544921875,-1012.197265625,29.298439025879, 0, 0, 0, 0, 0, 0, 5.001, 5.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)	
-- 		if #(vector3(-221.544921875,-1012.197265625,29.298439025879) - GetEntityCoords(PlayerPedId())) < 5 then
-- 				DisplayHelpText('Press ~b~H~s~ to teleport to base model , press ~b~'..Controlkey["housingSecondary"][2]..'~s~ to spawn into new model')
-- 			if IsControlJustPressed(1, Controlkey["housingMain"][1]) then
-- 				SetEntityCoords(PlayerPedId(),9000.0,0.0,110.0)
-- 			end
-- 		end
-- 	end
-- end)


function getRotation(input)
	return 360/(10*input)
end

function buildRoom2(numMultiplier,roomType)
	SetEntityCoords(PlayerPedId(),347.04724121094,-1000.2844848633,-99.194671630859)
	FreezeEntityPosition(PlayerPedId(),true)
	Citizen.Wait(5000)
	local generator = { x = 175.09986877441 , y = -904.7946166992, z = -98.999984741211}
	generator.x = (175.09986877441) + ((numMultiplier * 25.0))
	generator.y = (-774.7946166992) -- ((numMultiplier * 25.0))
	currentRoom = generator

	if numMultiplier == myRoomNumber then
		myroomcoords = generator
	else
		curRoom = generator
	end

	SetEntityCoords(PlayerPedId(), 	generator.x + 3.9, generator.y - 11.2, generator.z, generator.h)
	local building = CreateObject(`furnitured_midapart`,generator.x+2.29760700,generator.y-1.33191200,generator.z+1.26253700,false,false,false)
	FreezeEntityPosition(building,true)
	Citizen.Wait(100)
	FloatTilSafe(numMultiplier,roomType,building)
	if not isForced then
		TriggerServerEvent('hotel:getID')
	end
	curRoomType = 2
end

function FloatTilSafe(numMultiplier,roomType,buildingsent)
	SetEntityInvincible(PlayerPedId(),true)
	FreezeEntityPosition(PlayerPedId(),true)
	local plyCoord = GetEntityCoords(PlayerPedId())
	local processing = 3
	local counter = 100
	local building = buildingsent
	while processing == 3 do
		Citizen.Wait(100)
		if DoesEntityExist(building) then

			processing = 2
		end
		if counter == 0 then
			processing = 1
		end
		counter = counter - 1
	end

	if counter > 0 then
		SetEntityCoords(PlayerPedId(),plyCoord)
		CleanUpPeds()
	elseif processing == 1 then
		if roomType == 2 then
			SetEntityCoords(PlayerPedId(),267.48132324219,-638.818359375,42.020294189453)
		elseif roomType == 3 then
			SetEntityCoords(PlayerPedId(),160.26762390137,-641.96905517578,47.073524475098)
		elseif roomType == 1 then
			SetEntityCoords(PlayerPedId(),312.96966552734,-218.2705078125,54.221797943115)
		end
		TriggerEvent("DoLongHudText","Failed to load, please retry.",2)	
	end
	TriggerEvent("reviveFunction")	

end


function renderPropsWhereHouse()
	CreateObject(`ex_prop_crate_bull_sc_02`,1003.63013,-3108.50415,-39.9669662,false,false,false)
	CreateObject(`ex_prop_crate_wlife_bc`,1018.18011,-3102.8042,-40.08757,false,false,false)
	CreateObject(`ex_prop_crate_closed_bc`,1006.05511,-3096.954,-37.7579666,false,false,false)
	CreateObject(`ex_prop_crate_wlife_sc`,1003.63013,-3102.8042,-37.85769,false,false,false)
	CreateObject(`ex_prop_crate_jewels_racks_sc`,1003.63013,-3091.604,-37.8579666,false,false,false)

	CreateObject(`ex_Prop_Crate_Closed_BC`,1013.330000003,-3102.80400000,-35.62896000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1015.75500000,-3102.80400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1015.75500000,-3102.80400000,-39.86697000,false,false,false)


	CreateObject(`ex_Prop_Crate_Jewels_BC`,1018.18000000,-3091.60400000,-39.85885000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3111.38400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_BC`,1003.63000000,-3091.60400000,-39.86697000,false,false,false)

	CreateObject(`ex_Prop_Crate_Jewels_BC`,1026.75500000,-3106.52900000,-39.85903000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3106.52900000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_SC`,1010.90500000,-3108.50400000,-39.86585000,false,false,false)

	CreateObject(`ex_Prop_Crate_Art_BC`,1013.33000000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_BC`,1015.75500000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_SC_02`,1010.90500000,-3096.95400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_SC`,993.35510000,-3111.30400000,-39.84156000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_BC`,993.35510000,-3108.95400000,-39.86697000,false,false,false)

	CreateObject(`ex_Prop_Crate_Gems_SC`,1013.33000000,-3096.95400000,-37.6577600,false,false,false)
	CreateObject(`ex_Prop_Crate_clothing_BC`,1018.180000000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_clothing_BC`,1008.48000000,-3096.95400000,-39.83868000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1003.63000000,-3108.50400000,-35.61234000,false,false,false)
	CreateObject(`ex_Prop_Crate_Narc_BC`,1026.75500000,-3091.59400000,-37.65797000,false,false,false)

	CreateObject(`ex_Prop_Crate_Narc_BC`,1026.75500000,-3091.59400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_SC`,1008.48000000,-3108.50400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Tob_SC`,1018.18000000,-3096.95400000,-37.78240000,false,false,false)
	CreateObject(`ex_Prop_Crate_Wlife_BC`,1018.18000000,-3091.60400000,-35.74857000,false,false,false)
	CreateObject(`ex_Prop_Crate_Med_BC`,1008.48000000,-3091.60400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_SC`,1013.33000000,-3108.50400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3108.88900000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_biohazard_BC`,1010.90500000,-3102.80400000,-39.86461000,false,false,false)
	CreateObject(`ex_Prop_Crate_Wlife_BC`,1015.75500000,-3091.60400000,-35.74857000,false,false,false)
	CreateObject(`ex_Prop_Crate_biohazard_BC`,1003.63000000,-3108.50400000,-37.65561000,false,false,false)

	CreateObject(`ex_Prop_Crate_Elec_BC`,1008.48000000,-3096.954000000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,1006.05500000,-3108.50400000,-39.86242000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_RW`,1013.33000000,-3091.60400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Narc_SC`,1026.75500000,-3094.014000000,-37.65684000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_BC`,1015.75500000,-3108.50400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1010.90500000,-3096.95400000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Ammo_BC`,1013.33000000,-3102.80400000,-37.65427000,false,false,false)

	CreateObject(`ex_Prop_Crate_Money_BC`,1003.63000000,-3096.95400000,-39.86638000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1003.63000000,-3096.95400000,-37.65187000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1010.90500000,-3091.60400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_BC`,1013.33000000,-3091.60400000,-35.74885000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_BC`,1026.75500000,-3091.59400000,-35.74885000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_BC`,1026.75500000,-3094.0140000,-35.74885000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_BC`,1026.75500000,-3096.43400000,-35.74885000,false,false,false)
	CreateObject(`ex_Prop_Crate_clothing_SC`,1013.33000000,-3091.604000000,-39.86540000,false,false,false)
	CreateObject(`ex_Prop_Crate_biohazard_SC`,1006.05500000,-3108.50400000,-37.65576000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,993.35510000,-3106.60400000,-35.60529000,false,false,false)

	CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3111.38400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,1026.75500000,-3096.4340000,-39.86242000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1015.75500000,-3096.95400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_HighEnd_pharma_BC`,1003.63000000,-3091.60400000,-35.62571000,false,false,false)
	CreateObject(`ex_Prop_Crate_HighEnd_pharma_SC`,1015.75500000,-3091.60400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_BC`,1013.330000000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_SC`,1018.18000000,-3102.80400000,-37.65776000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_BC`,1013.33000000,-3108.50400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1018.18000000,-3108.50400000,-37.64234000,false,false,false)
	CreateObject(`ex_Prop_Crate_Tob_BC`,1010.90500000,-3108.50400000,-35.75240000,false,false,false)

	CreateObject(`ex_Prop_Crate_Med_SC`,1026.75500000,-3108.88900000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Money_SC`,1010.90500000,-3091.60400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Med_SC`,1008.48000000,-3091.60400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_BC`,1018.180000000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_SC_02`,1008.48000000,-3108.50400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_BC`,993.35510000,-3106.60400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1008.480000000,-3102.804000000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,993.35510000,-3111.30400000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_HighEnd_pharma_BC`,1018.18000000,-3091.60400000,-37.65572000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1015.75500000,-3102.80400000,-37.64234000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_racks_BC`,1003.63000000,-3102.80400000,-39.85903000,false,false,false)
	CreateObject(`ex_Prop_Crate_Money_SC`,1006.05500000,-3096.95400000,-39.86697000,false,false,false)

	CreateObject(`ex_Prop_Crate_Closed_BC`,1003.630000000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_SC`,1006.05500000,-3102.80400000,-37.78544000,false,false,false)
	CreateObject(`ex_Prop_Crate_Expl_bc`,1010.90500000,-3102.80400000,-37.63982000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1006.05500000,-3096.9540000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1006.05500000,-3102.80400000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1010.90500000,-3108.50400000,-37.63529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_BC`,1015.75500000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1010.90500000,-3096.95400000,-37.64234000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1010.90500000,-3102.804000000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1008.48000000,-3102.80400000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,993.35510000,-3106.60400000,-37.65342000,false,false,false)
	CreateObject(`ex_Prop_Crate_Money_SC`,1015.75500000,-3091.604000000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Med_BC`,1026.75500000,-3106.52900000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_SC_02`,1015.75500000,-3096.95400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Tob_SC`,1010.905000000,-3091.60400000,-37.78240000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1006.05500000,-3091.60400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_pharma_SC`,1026.75500000,-3096.43400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1006.05500000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_SC`,1015.75500000,-3108.504000000,-37.65776000,false,false,false)

	CreateObject(`ex_Prop_Crate_Tob_BC`,1018.18000000,-3102.80400000,-35.75240000,false,false,false)
	CreateObject(`ex_Prop_Crate_Tob_BC`,1008.48000000,-3108.50400000,-35.75240000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,993.35510000,-3111.30400000,-37.65342000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_racks_SC`,1026.75500000,-3111.384000000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_SC`,1006.05500000,-3102.80400000,-39.87020000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,1013.33000000,-3096.95400000,-39.86242000,false,false,false)

	CreateObject(`ex_Prop_Crate_Gems_SC`,1013.33000000,1013.33000000,1013.33000000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_BC`,1026.75500000,-3108.889000000,-39.85885000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_SC_02`,993.35510000,-3108.95400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1008.48000000,-3091.60400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_SC`,993.35510000,-3108.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_XLDiam`,1026.75500000,-3094.01400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_watch`,1013.33000000,-3102.80400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_SHide`,1018.18000000,-3096.95400000,-39.87596000,false,false,false)
	CreateObject(`ex_Prop_Crate_Oegg`,1006.05500000,-3091.60400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_MiniG`,1018.18000000,-3108.50400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_FReel`,11008.48000000,-3102.80400000,-39.85903000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_SC`,1006.05500000,-3091.60400000,-37.64985000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,1026.75500000,-3091.59400000,-39.86242000,false,false,false)


	local tool1 = CreateObject(-573669520,1022.6115112305,-3107.1694335938,-39.999912261963,false,false,false)
	local tool2 = CreateObject(-573669520,1022.5317382813,-3095.3305664063,-39.999912261963,false,false,false)
	local tool3 = CreateObject(-573669520,996.60125732422,-3099.2927246094,-39.999923706055,false,false,false)
	local tool4 = CreateObject(-573669520,1002.0411987305,-3108.3645019531,-39.999897003174,false,false,false)


	SetEntityHeading(tool1,GetEntityHeading(tool1)-130)
	SetEntityHeading(tool2,GetEntityHeading(tool2)-40)
	SetEntityHeading(tool3,GetEntityHeading(tool3)+90)
	SetEntityHeading(tool4,GetEntityHeading(tool4)-90)

end

RegisterNetEvent("hotel:loadWarehouse")
AddEventHandler("hotel:loadWarehouse", function()
    renderPropsWhereHouse()
end)

RegisterNetEvent("hotel:clearWarehouse")
AddEventHandler("hotel:clearWarehouse", function()
    CleanUpArea()
end)

isJudge = true
RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
    isJudge = true
end)
RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
    isJudge = false
end)



function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterCommand('changechar', function()
logout()
end)

function logout()
    TransitionToBlurred(500)
    DoScreenFadeOut(500)
    Citizen.Wait(1000)
    CleanUpArea()
    Citizen.Wait(1000)   
		TriggerEvent("np-base:clearStates")
    exports["np-base"]:getModule("SpawnManager"):Initialize()

	Citizen.Wait(1000)
end

local canInteract = true

RegisterNetEvent('hotel:interactState')
AddEventHandler('hotel:interactState', function(state)
	canInteract = state
end)


RegisterNetEvent('newRoomType')
AddEventHandler('newRoomType', function(newRoomType)
	myRoomType = newRoomType
	TriggerEvent("hotel:myroomtype",myRoomType)
end)

local comparedst = 1000
function smallestDist(typeCheck)
	if typeCheck < comparedst then
		comparedst = typeCheck
	end
end

Controlkey = {
	["generalUse"] = {38,"E"},
	["housingMain"] = {38,"E"},
	["housingSecondary"] = {47,"G"}
} 



RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["generalUse"] = table["generalUse"]
	Controlkey["housingMain"] = table["housingMain"]
	Controlkey["housingSecondary"] = table["housingSecondary"]

	if Controlkey["housingSecondary"] == nil or Controlkey["housingMain"] == nil or Controlkey["generalUse"] == nil then
		Controlkey = {["generalUse"] = {38,"E"},["housingMain"] = {74,"H"},["housingSecondary"] = {47,"G"}} 
	end
end)




Citizen.CreateThread(function()

 	while true do
		Citizen.Wait(0)
	
		comparedst = 1000

		local plyId = PlayerPedId()
		local plyCoords = GetEntityCoords(plyId)


		local entryUpgradesDst = #(vector3(260.72366333008,-375.27133178711,-44.137680053711) - plyCoords)
		local entry6th = #(vector3(apartments1[65]["x"],apartments1[65]["y"],apartments1[65]["z"]) - plyCoords)
		local entry5rd = #(vector3(apartments1[50]["x"],apartments1[50]["y"],apartments1[50]["z"]) - plyCoords)
		local entry4rd = #(vector3(4.67, -724.85, 32.18) -  plyCoords)
		local entry3rd = #(vector3(160.26762390137,-641.96905517578,47.073524475098) - plyCoords)
		local entry2nd = #(vector3(267.48132324219,-638.818359375,42.020294189453) - plyCoords)
		local entry1st = #(vector3(apartments1[1]["x"],apartments1[1]["y"],apartments1[1]["z"]) - plyCoords)
		local payTicketsDst = #(vector3(235.91, -416.43, -118.16) - plyCoords)
		
		smallestDist(payTicketsDst)
		smallestDist(entryUpgradesDst)
		smallestDist(entry6th)
		smallestDist(entry5rd)
		smallestDist(entry4rd)
		smallestDist(entry3rd)
		smallestDist(entry2nd)
		smallestDist(entry1st)

		if insideApartment or comparedst < 100 then

			if payTicketsDst < 5.0 then
				if payTicketsDst < 1.0 then
					DrawText3Ds(235.91, -416.43, -118.16, "Public Records")
					if IsControlJustReleased(1,Controlkey["generalUse"][1]) then
						TriggerEvent("phone:publicrecords")
						Citizen.Wait(2500)
					end	
				end

				if #(vector3(236.51, -414.43, -118.16) - plyCoords) < 1.0 then
					DrawText3Ds(236.51, -414.43, -118.16, "Property Records")
					if IsControlJustReleased(1, Controlkey["generalUse"][1]) then
						TriggerServerEvent("houses:PropertyListing")
						Citizen.Wait(2500)
					end	
				end

			end


			if entryUpgradesDst < 1.0 then
				DrawText3Ds(260.72366333008,-375.27133178711,-44.137680053711, "~g~"..Controlkey["generalUse"][2].."~s~ Upgrade Housing (25k for tier 2.")
				if IsControlJustReleased(1,Controlkey["generalUse"][1]) then
					TriggerEvent("hotel:AttemptUpgrade")
					Citizen.Wait(2500)
				end		
			end

			if (entry4rd < 5 and myRoomType == 3) or (entry3rd < 5 and myRoomType == 3) or (entry1st < 35.0 and myRoomType == 1) or (entry5rd < 65.0 and myRoomType == 1) or (entry2nd < 5 and myRoomType == 2) or (entry6th < 81.0 and myRoomType == 1) then
				if myRoomType == 1 then
					local myappdist = #(vector3(apartments1[myRoomNumber]["x"],apartments1[myRoomNumber]["y"],apartments1[myRoomNumber]["z"]) - plyCoords)
					if myappdist < 15.0 then
						DrawMarker(20,apartments1[myRoomNumber]["x"],apartments1[myRoomNumber]["y"],apartments1[myRoomNumber]["z"], 0, 0, 0, 0, 0, 0, 0.701,1.0001,0.3001, 0, 155, 255, 200, 0, 0, 0, 0)
						if myappdist < 3.0 then
							if myRoomLock then
								DrawText3Ds(apartments1[myRoomNumber]["x"],apartments1[myRoomNumber]["y"],apartments1[myRoomNumber]["z"], "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~b~"..Controlkey["housingSecondary"][2].."~s~ to unlock (" .. myRoomNumber .. ")")
							else
								DrawText3Ds(apartments1[myRoomNumber]["x"],apartments1[myRoomNumber]["y"],apartments1[myRoomNumber]["z"], "~g~H~s~ to enter ~g~b~s~ to lock (" .. myRoomNumber .. ")")
							end
						end
					end
				end

				if myRoomType == 2 then
					DrawMarker(27,267.48132324219,-638.818359375,41.020294189453, 0, 0, 0, 0, 0, 0, 7.001, 7.0001, 0.3001, 0, 155, 255, 200, 0, 0, 0, 0)
					if myRoomLock then
						DrawText3Ds(267.48132324219,-638.818359375,42.020294189453, "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~g~"..Controlkey["housingSecondary"][2].."~s~ to unlock (" .. myRoomNumber .. ")")
					else
						DrawText3Ds(267.48132324219,-638.818359375,42.020294189453, "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~g~"..Controlkey["housingSecondary"][2].."~s~ to lock (" .. myRoomNumber .. ")")
					end
				end

				if myRoomType == 3 then
					if entry4rd < 5 then
						DrawMarker(27,4.67, -724.85, 32.18, 0, 0, 0, 0, 0, 0, 7.001, 7.0001, 0.3001, 0, 155, 255, 200, 0, 0, 0, 0)
						if myRoomLock then
							DrawText3Ds(4.67, -724.85, 32.18, "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~g~"..Controlkey["housingSecondary"][2].."~s~ to unlock (" .. myRoomNumber .. ")")
						else
							DrawText3Ds(4.67, -724.85, 32.18, "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~g~"..Controlkey["housingSecondary"][2].."~s~ to lock (" .. myRoomNumber .. ")")
						end
					else
						DrawMarker(27,160.26762390137,-641.96905517578,47.073524475098, 0, 0, 0, 0, 0, 0, 7.001, 7.0001, 0.3001, 0, 155, 255, 200, 0, 0, 0, 0)
						if myRoomLock then
							DrawText3Ds(160.26762390137,-641.96905517578,47.073524475098, "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~g~"..Controlkey["housingSecondary"][2].."~s~ to unlock (" .. myRoomNumber .. ")")
						else
							DrawText3Ds(160.26762390137,-641.96905517578,47.073524475098, "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~g~"..Controlkey["housingSecondary"][2].."~s~ to lock (" .. myRoomNumber .. ")")
						end
					end

				end

				if IsControlJustReleased(1,Controlkey["housingSecondary"][1]) then
					if #(vector3(apartments1[myRoomNumber]["x"],apartments1[myRoomNumber]["y"],apartments1[myRoomNumber]["z"]) - plyCoords) < 5 and myRoomType == 1 then	
						TriggerEvent("dooranim")
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'keydoors', 0.4)
						if myRoomLock == false then
						TriggerServerEvent("hotel:updateLockStatus",true)
				
						Citizen.Wait(500)
						else
							TriggerServerEvent("hotel:updateLockStatus",false)
						end
					elseif myRoomType ~= 1 then
						TriggerEvent("dooranim")
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'keydoors', 0.4)
						if myRoomLock == false then
							TriggerServerEvent("hotel:updateLockStatus",true)
					
							Citizen.Wait(500)
							else
						
								TriggerServerEvent("hotel:updateLockStatus",false)
							end
						Citizen.Wait(500)
					end
				end


				if IsControlJustReleased(1,Controlkey["housingMain"][1]) then
					TriggerEvent("DoLongHudText","Please wait!",1)

					Citizen.Wait(300)
					TriggerEvent("dooranim")
					TriggerEvent('InteractSound_CL:PlayOnOne','DoorOpen', 0.7)

					if #(vector3(apartments1[myRoomNumber]["x"],apartments1[myRoomNumber]["y"],apartments1[myRoomNumber]["z"]) - plyCoords) < 5 and myRoomType == 1 then	
						processBuildType(myRoomNumber,myRoomType)
						TriggerServerEvent("hotel:getInfo")
						Citizen.Wait(500)
					elseif (#(vector3(160.26762390137,-641.96905517578,47.073524475098) - plyCoords) < 5 and myRoomType == 3) or entry4rd < 5 then
						processBuildType(myRoomNumber,myRoomType)
						TriggerServerEvent("hotel:getInfo")
						Citizen.Wait(500)					
					elseif #(vector3(267.48132324219,-638.818359375,42.020294189453) - plyCoords) < 5 and myRoomType == 2 then
						processBuildType(myRoomNumber,myRoomType)
						TriggerServerEvent("hotel:getInfo")
						Citizen.Wait(500)
					else
						TriggerEvent("DoLongHudText","Moved too far away!",2)
					end			
				end
			end

			if #(vector3(myroomcoords.x-2, myroomcoords.y + 2.5, myroomcoords.z+1.5) - plyCoords) < 3.0 and curRoomType == 1 then
				DrawText3Ds(myroomcoords.x-2, myroomcoords.y + 2.5, myroomcoords.z+1.5, '~g~ G ~s~ to Logout.')
				if IsControlJustReleased(1,Controlkey["housingSecondary"][1]) then
					logout()
				end
			elseif #(vector3(myroomcoords.x+8, myroomcoords.y + 4, myroomcoords.z+0.4) - plyCoords) < 3.0 and curRoomType == 2 then
				DrawText3Ds(myroomcoords.x+8.3, myroomcoords.y + 8, myroomcoords.z+2.4, '~g~ G ~s~ to Logout.')
				if IsControlJustReleased(1, Controlkey["housingSecondary"][1]) then
					logout()
				end
			end	
			if 	(#(vector3(myroomcoords.x - 14.3, myroomcoords.y - 02.00, myroomcoords.z + 7.02) - plyCoords) < 3.0 and curRoomType == 3) or 
				(#(vector3(myroomcoords.x +  4.3, myroomcoords.y - 11.7,myroomcoords.z+2.42) - plyCoords) < 3.0 and curRoomType == 2) or 

				(#(vector3(myroomcoords.x - 2.00, myroomcoords.y - 04.00, myroomcoords.z) - plyCoords) < 3.0 and curRoomType == 1) 
			then
				
				if curRoomType == 2 then
	
					DrawText3Ds(myroomcoords.x + 4.3,myroomcoords.y - 11.7,myroomcoords.z+2.42, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave')
							
				elseif curRoomType == 1 then
					DrawText3Ds(myroomcoords.x - 1.15,myroomcoords.y - 4.2,myroomcoords.z+1.20, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave')
				end

				if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
					TriggerEvent("dooranim")
					TriggerEvent('InteractSound_CL:PlayOnOne','DoorOpen', 0.7)
					Wait(330)
					CleanUpArea()
					isForced = false
					TriggerEvent("enabledamage",false)
					if curRoomType == 2 then
						SetEntityCoords(PlayerPedId(),267.48132324219,-638.818359375,42.020294189453)
					elseif curRoomType == 3 then
						SetEntityCoords(PlayerPedId(),160.26762390137,-641.96905517578,47.073524475098)
					elseif curRoomType == 1 then
						SetEntityCoords(PlayerPedId(),apartments1[myRoomNumber]["x"],apartments1[myRoomNumber]["y"],apartments1[myRoomNumber]["z"])
					end
					TriggerEvent("enabledamage",true)
					insideApartment = false
					Citizen.Wait(100)
					TriggerEvent("dooranim")
					TriggerEvent('InteractSound_CL:PlayOnOne','DoorClose', 0.7)
					curRoom = { x = 1420.0, y = 1420.0, z = -900.0 }
					TriggerEvent("attachWeapons")
				end

				if IsControlJustReleased(1, Controlkey["housingSecondary"][1]) and curRoomType == 3 then
					TriggerEvent("dooranim")
					TriggerEvent('InteractSound_CL:PlayOnOne','DoorOpen', 0.7)
					Wait(330)
					isForced = false
					insideApartment = false
					CleanUpArea()
					DoScreenFadeOut(1)
					buildGarage()
					Citizen.Wait(4500)
					DoScreenFadeIn(1)
				end
 
			end

			if 	(#(vector3(myroomcoords.x - 1.6, myroomcoords.y + 1.20, myroomcoords.z + 1.00) - plyCoords) < 5.0 and curRoomType == 1) or 
				(#(vector3(myroomcoords.x+ 9.5, myroomcoords.y + 2.8, myroomcoords.z + 0.15) - plyCoords) < 5.0 and curRoomType == 2) or 
				(#(vector3(myroomcoords.x + 1.5, myroomcoords.y + 8.00, myroomcoords.z + 1.00) - plyCoords) < 5.0 and curRoomType == 3) 
				and canInteract 
			then
				if curRoomType == 2 then
					DrawText3Ds(myroomcoords.x+9.5, myroomcoords.y + 2.8, myroomcoords.z+2.15, '~g~'..Controlkey["housingMain"][2]..'~s~ to interact')
		
				elseif curRoomType == 1 then
					DrawText3Ds(myroomcoords.x - 1.6,myroomcoords.y + 1.2, myroomcoords.z+1, '~g~'..Controlkey["housingMain"][2]..'~s~ to interact')
				end

				if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
					if inRoom() then
						canInteract = false
						TriggerEvent('InteractSound_CL:PlayOnOne','StashOpen', 0.6)
						maxRoomWeight = 100.0 * (curRoomType * 2)
						local cid = exports["isPed"]:isPed("cid")
						if not isForced then
							TriggerServerEvent('hotel:getID')
						end
						TriggerEvent("server-inventory-open", "1", "motel"..curRoomType.."-"..cid)

						TriggerEvent("actionbar:setEmptyHanded")
					else
						TriggerEvent("DoLongHudText","This is not your stash!",2)
					end
					Citizen.Wait(1900)
				end
			end

		if 	(#(vector3(curRoom.x - 1.6, curRoom.y + 1.20, curRoom.z + 1.00) - plyCoords) < 2.0 and curRoomType == 1) or 
			(#(vector3(curRoom.x + 9.5, curRoom.y + 2.8, curRoom.z + 0.15) - plyCoords) < 2.0 and curRoomType == 2) or 
			(#(vector3(curRoom.x + 1.5, curRoom.y + 8.00, curRoom.z + 1.00) - plyCoords) < 2.0 and curRoomType == 3) and 
			canInteract 
		then

			if curRoomType == 2 then
				DrawText3Ds(curRoom.x+ 9.5, curRoom.y +  2.8, curRoom.z+2.15, '~g~'..Controlkey["housingMain"][2]..'~s~ to interact')

			elseif curRoomType == 1 then
				DrawText3Ds(curRoom.x - 1.6,curRoom.y + 1.2, curRoom.z+1, '~g~'..Controlkey["housingMain"][2]..'~s~ to interact')
			end

			if IsControlJustReleased(1, Controlkey["housingMain"][1]) then

				local myJob = exports["isPed"]:isPed("myJob")
				local LEO = false
				if myJob == "police" or myJob == "judge" then
					LEO = true
				end

				if LEO then
					canInteract = false
					TriggerEvent('InteractSound_CL:PlayOnOne','StashOpen', 0.6)
					maxRoomWeight = 500.0 * curRoomType
					TriggerServerEvent('hotel:getID')
					--TriggerServerEvent('hotel:GetInteract',maxRoomWeight,forcedID)

					TriggerEvent("server-inventory-open", "1", "motel"..curRoomType.."-"..forcedID)

				else
					TriggerEvent("DoLongHudText","This is not your stash!",2)
				end
				Citizen.Wait(1900)
			end

		end



	
		if 	(#(vector3(curRoom.x - 14.3,curRoom.y - 2,curRoom.z+7.02) - plyCoords) < 3.0 and curRoomType == 3) or 
			(#(vector3(curRoom.x +  4.3, curRoom.y - 11.7,curRoom.z+2.42) - plyCoords) < 3.0 and curRoomType == 2) or 
			(#(vector3(curRoom.x - 2,curRoom.y - 4,curRoom.z) - plyCoords) < 3.0 and curRoomType == 1) 
		then
				if curRoomType == 2 then
					DrawText3Ds(myroomcoords.x + 4.3,myroomcoords.y - 11.7,myroomcoords.z+2.42, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave')
				
				elseif curRoomType == 1 then
					DrawText3Ds(curRoom.x - 1.15,curRoom.y - 4.2,curRoom.z+1.20, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave')
				end

				if IsControlJustReleased(1, Controlkey["housingSecondary"][1]) and curRoomType == 3 then
					TriggerEvent("dooranim")
					TriggerEvent('InteractSound_CL:PlayOnOne','DoorOpen', 0.7)
					Wait(330)
					isForced = false
					insideApartment = false
					CleanUpArea()
					DoScreenFadeOut(1)
					buildGarage()
					Citizen.Wait(4500)
					DoScreenFadeIn(1)
				end


				if IsControlJustReleased(1, Controlkey["housingMain"][1]) then

					Wait(200)
					CleanUpArea()

					if curRoomType == 2 then
						SetEntityCoords(PlayerPedId(),267.48132324219,-638.818359375,42.020294189453)
					elseif curRoomType == 3 then
						SetEntityCoords(PlayerPedId(),160.26762390137,-641.96905517578,47.073524475098)
					elseif curRoomType == 1 then
						SetEntityCoords(PlayerPedId(),313.2561340332,-227.30776977539,54.221176147461)
					end

					Citizen.Wait(2000)
					curRoom = { x = 1420.0, y = 1420.0, z = -900.0 }
					TriggerEvent("attachWeapons")
				end

			end
		else
			if ingarage then
				if #(vector3(currentGarage.x+9.5 , currentGarage.y-12.7, currentGarage.z+1.0) - plyCoords) < 3.0 then
					DrawText3Ds(currentGarage.x+9.5, currentGarage.y-12.7, currentGarage.z+1.0, '~g~'..Controlkey["housingMain"][2]..'~s~ to Room ~g~'..Controlkey["housingSecondary"][2]..'~s~ to Garage Door')
					if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
						TriggerEvent("Garages:ToggleHouse",false)
						Wait(200)
						CleanUpArea()
						processBuildType(garageNumber,3)
						ingarage = false
						TriggerEvent("attachWeapons")
					end
					if IsControlJustReleased(1, Controlkey["housingSecondary"][1]) then
						TriggerEvent("Garages:ToggleHouse",false)
						Wait(200)
						CleanUpArea()
						SetEntityCoords(PlayerPedId(),4.67, -724.85, 32.18)
						ingarage = false
						TriggerEvent("attachWeapons")
					end
				else
					DisplayHelpText('Press ~g~'..Controlkey["housingSecondary"][2]..'~s~ while in a vehicle to spawn it.')
					if IsControlJustReleased(1, Controlkey["housingSecondary"][1]) then
						if IsPedInAnyVehicle(PlayerPedId(), false) then
							local carcarbroombrooms = GetClosestVehicle(-41.43, -716.53, 32.54, 3.000, 0, 70)

							if not DoesEntityExist(carcarbroombrooms) then
								local vehmove = GetVehiclePedIsIn(PlayerPedId(), true)
								
								SetEntityCoords(vehmove,-41.43, -716.53, 32.54)
								SetEntityHeading(vehmove,170.0)
								Wait(200)
								CleanUpArea()
								SetPedIntoVehicle(PlayerPedId(), vehmove, - 1)
								TriggerEvent("Garages:HouseRemoveVehicle",vehmove)
								ingarage = false
								
							else
								TriggerEvent("DoLongHudText","Vehicle on spawn.",2)
							end

							--leaveappartment
						else
							TriggerEvent("DoLongHudText","Enter Vehicle First", 2)
						end
					end
				end
				local lights = plyCoords
				DrawLightWithRange(lights["x"],lights["y"],lights["z"]+3, 255, 197, 143, 100.0, 0.45)
				DrawLightWithRange(lights["x"],lights["y"],lights["z"]-3, 255, 197, 143, 100.0, 0.45)
			else
				Citizen.Wait(math.ceil(comparedst * 10))
			end
			
		end
	end
end)


function nearClothingMotel()
	if #(vector3(myroomcoords.x, myroomcoords.y + 3, myroomcoords.z) - GetEntityCoords(PlayerPedId())) < 5.5 and curRoomType == 1 then
		return true
	end
	if #(vector3(myroomcoords.x + 10, myroomcoords.y + 6, myroomcoords.z) - GetEntityCoords(PlayerPedId())) < 5.5 and curRoomType == 2 then
		return true
	end	
	if #(vector3(myroomcoords.x - 3, myroomcoords.y - 7, myroomcoords.z) - GetEntityCoords(PlayerPedId())) < 55.5 and curRoomType == 3 then
		return true
	end		

	if #(vector3(1782.86, 2494.95, 50.43) - GetEntityCoords(PlayerPedId())) < 8.5 then
		return true
	end	

	local myjob = exports["isPed"]:isPed("myjob")
	--missionrow locker room
	if myjob == "police" then
		return true
	end

	if myjob == "ems" then
		return true
	end

	if myjob == "doctor" then
		return true
	end
	return false
end

RegisterNetEvent('hotel:listSKINSFORCYRTHESICKFUCK')
AddEventHandler('hotel:listSKINSFORCYRTHESICKFUCK', function(skincheck)
	for i = 1, #skincheck do
		TriggerEvent("DoLongHudText", skincheck[i].slot .. " | " .. skincheck[i].name,i)
	end
end)

RegisterNetEvent('hotel:outfit')
AddEventHandler('hotel:outfit', function(args,sentType)

	if nearClothingMotel() then
		if sentType == 1 then
			local id = args[2]
			table.remove(args, 1)
			table.remove(args, 1)
			strng = ""
			for i = 1, #args do
				strng = strng .. " " .. args[i]
			end
			TriggerEvent("raid_clothes:outfits", sentType, id, strng)
		elseif sentType == 2 then
			local id = args[2]
			TriggerEvent("raid_clothes:outfits", sentType, id)
		elseif sentType == 3 then
			local id = args[2]
			TriggerEvent('item:deleteClothesDna')
			TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
			TriggerEvent("raid_clothes:outfits", sentType, id)
		else
			TriggerServerEvent("raid_clothes:list_outfits")
		end
	end
end)



robberycoordsMansions = {
	[1] =  { ['x'] = -7.22,['y'] = 409.2,['z'] = 120.13,['h'] = 76.61, ['info'] = ' Didion Drive 1', ["office"] = 2 },
	[2] =  { ['x'] = -73.12,['y'] = 427.51,['z'] = 113.04,['h'] = 157.75, ['info'] = ' Didion Drive 2', ["office"] = 2 },
	[3] =  { ['x'] = -166.83,['y'] = 425.11,['z'] = 111.8,['h'] = 15.34, ['info'] = ' Didion Drive 3', ["office"] = 2 },
	[4] =  { ['x'] = 38.08,['y'] = 365.11,['z'] = 116.05,['h'] = 221.39, ['info'] = ' Didion Drive 4', ["office"] = 2 },
	[5] =  { ['x'] = -214.09,['y'] = 399.86,['z'] = 111.31,['h'] = 13.43, ['info'] = ' Didion Drive 5', ["office"] = 2 },
	[6] =  { ['x'] = -239.04,['y'] = 381.64,['z'] = 112.62,['h'] = 111.63, ['info'] = ' Didion Drive 6', ["office"] = 2 },
	[7] =  { ['x'] = -297.74,['y'] = 380.3,['z'] = 112.1,['h'] = 11.17, ['info'] = ' Didion Drive 7', ["office"] = 2 },
	[8] =  { ['x'] = -328.28,['y'] = 369.99,['z'] = 110.01,['h'] = 20.95, ['info'] = ' Didion Drive 8', ["office"] = 2 },
	[9] =  { ['x'] = -371.8,['y'] = 344.28,['z'] = 109.95,['h'] = 3.39, ['info'] = ' Didion Drive 9', ["office"] = 2 },
	[10] =  { ['x'] = -408.92,['y'] = 341.67,['z'] = 108.91,['h'] = 274.84, ['info'] = ' Didion Drive 10', ["office"] = 2 },
	[11] =  { ['x'] = -444.27,['y'] = 343.86,['z'] = 105.39,['h'] = 184.95, ['info'] = ' Didion Drive 11', ["office"] = 2 },
	[12] =  { ['x'] = -468.94,['y'] = 329.99,['z'] = 104.49,['h'] = 241.99, ['info'] = ' Didion Drive 12', ["office"] = 2 },
	[13] =  { ['x'] = -305.22,['y'] = 431.56,['z'] = 110.31,['h'] = 10.16, ['info'] = ' Cox Way 1', ["office"] = 0 },
	[14] =  { ['x'] = -371.86,['y'] = 408.06,['z'] = 110.6,['h'] = 115.71, ['info'] = ' Cox Way 2', ["office"] = 0 },
	[15] =  { ['x'] = -400.54,['y'] = 427.2,['z'] = 112.35,['h'] = 246.04, ['info'] = ' Cox Way 3', ["office"] = 0 },
	[16] =  { ['x'] = -451.53,['y'] = 395.61,['z'] = 104.78,['h'] = 85.78, ['info'] = ' Cox Way 4', ["office"] = 0 },
	[17] =  { ['x'] = -477.33,['y'] = 413.03,['z'] = 103.13,['h'] = 185.61, ['info'] = ' Cox Way 5', ["office"] = 0 },
	[18] =  { ['x'] = -500.49,['y'] = 398.66,['z'] = 98.15,['h'] = 54.31, ['info'] = ' Cox Way 6', ["office"] = 0 },
	[19] =  { ['x'] = -516.95,['y'] = 433.19,['z'] = 97.81,['h'] = 130.67, ['info'] = ' Cox Way 7', ["office"] = 0 },
	[20] =  { ['x'] = -561.08,['y'] = 403.19,['z'] = 101.81,['h'] = 17.43, ['info'] = ' Milton Road 1', ["office"] = 2 },
	[21] =  { ['x'] = -595.7,['y'] = 393.54,['z'] = 101.89,['h'] = 3.1, ['info'] = ' Milton Road 2', ["office"] = 2 },
	[22] =  { ['x'] = -615.57,['y'] = 399.15,['z'] = 101.24,['h'] = 5.39, ['info'] = ' Milton Road 3', ["office"] = 2 },
	[23] =  { ['x'] = 223.17,['y'] = 514.43,['z'] = 140.77,['h'] = 38.98, ['info'] = ' Wild Oats Drive 1', ["office"] = 2 },

	[24] =  { ['x'] = -500.27,['y'] = 552.37,['z'] = 120.43,['h'] = 326.56, ['info'] = ' Didion Drive 21', ["office"] = 2 },

	[25] =  { ['x'] = 118.82,['y'] = 494.01,['z'] = 147.35,['h'] = 106.07, ['info'] = ' Wild Oats Drive 3', ["office"] = 2 },
	[26] =  { ['x'] = 106.9,['y'] = 467.73,['z'] = 147.38,['h'] = 2.1, ['info'] = ' Wild Oats Drive 4', ["office"] = 2 },
	[27] =  { ['x'] = 80.21,['y'] = 485.85,['z'] = 148.21,['h'] = 208.96, ['info'] = ' Wild Oats Drive 5', ["office"] = 2 },
	[28] =  { ['x'] = 57.84,['y'] = 450.05,['z'] = 147.04,['h'] = 328.16, ['info'] = ' Wild Oats Drive 6', ["office"] = 2 },
	[29] =  { ['x'] = 42.98,['y'] = 468.72,['z'] = 148.1,['h'] = 169.75, ['info'] = ' Wild Oats Drive 7', ["office"] = 2 },
	[30] =  { ['x'] = -7.79,['y'] = 468.12,['z'] = 145.86,['h'] = 341.41, ['info'] = ' Wild Oats Drive 8', ["office"] = 2 },
	[31] =  { ['x'] = -66.83,['y'] = 490.18,['z'] = 144.89,['h'] = 338.4, ['info'] = ' Wild Oats Drive 9', ["office"] = 2 },
	[32] =  { ['x'] = -109.87,['y'] = 502.01,['z'] = 143.48,['h'] = 347.61, ['info'] = ' Wild Oats Drive 10', ["office"] = 2 },
	[33] =  { ['x'] = -174.76,['y'] = 502.6,['z'] = 137.43,['h'] = 91.98, ['info'] = ' Wild Oats Drive 11', ["office"] = 2 },
	[34] =  { ['x'] = -230.26,['y'] = 488.43,['z'] = 128.77,['h'] = 1.71, ['info'] = ' Wild Oats Drive 12', ["office"] = 2 },
	[36] =  { ['x'] = 232.01,['y'] = 672.55,['z'] = 189.95,['h'] = 38.31, ['info'] = ' Whispymound Drive 1', ["office"] = 2 },
	[37] =  { ['x'] = 216.04,['y'] = 620.57,['z'] = 187.64,['h'] = 71.57, ['info'] = ' Whispymound Drive 2', ["office"] = 2 },
	[38] =  { ['x'] = 184.86,['y'] = 571.73,['z'] = 183.34,['h'] = 284.56, ['info'] = ' Whispymound Drive 3', ["office"] = 2 },
	[39] =  { ['x'] = 128.18,['y'] = 566.05,['z'] = 183.96,['h'] = 3.58, ['info'] = ' Whispymound Drive 4', ["office"] = 2 },
	[40] =  { ['x'] = 84.89,['y'] = 561.77,['z'] = 182.78,['h'] = 1.88, ['info'] = ' Whispymound Drive 5', ["office"] = 2 },
	[41] =  { ['x'] = 45.75,['y'] = 556.64,['z'] = 180.09,['h'] = 18.32, ['info'] = ' Whispymound Drive 6', ["office"] = 2 },
	[42] =  { ['x'] = 8.41,['y'] = 540.01,['z'] = 176.03,['h'] = 332.48, ['info'] = ' Whispymound Drive 7', ["office"] = 2 },
	[43] =  { ['x'] = 228.52,['y'] = 765.89,['z'] = 204.79,['h'] = 59.33, ['info'] = ' Kimble Hill Drive 1', ["office"] = 2 },
	[44] =  { ['x'] = -126.46,['y'] = 588.54,['z'] = 204.72,['h'] = 359.66, ['info'] = ' Kimble Hill Drive 2', ["office"] = 2 },
	[45] =  { ['x'] = -185.28,['y'] = 591.2,['z'] = 197.83,['h'] = 357.1, ['info'] = ' Kimble Hill Drive 3', ["office"] = 2 },
	[46] =  { ['x'] = -189.57,['y'] = 617.86,['z'] = 199.67,['h'] = 190.04, ['info'] = ' Kimble Hill Drive 4', ["office"] = 2 },
	[47] =  { ['x'] = -232.61,['y'] = 589.02,['z'] = 190.54,['h'] = 353.79, ['info'] = ' Kimble Hill Drive 5', ["office"] = 2 },
	[48] =  { ['x'] = -256.67,['y'] = 632.44,['z'] = 187.81,['h'] = 75.18, ['info'] = ' Kimble Hill Drive 6', ["office"] = 2 },
	[49] =  { ['x'] = -293.54,['y'] = 600.83,['z'] = 181.58,['h'] = 348.16, ['info'] = ' Kimble Hill Drive 7', ["office"] = 2 },
	[50] =  { ['x'] = -299.18,['y'] = 635.27,['z'] = 175.69,['h'] = 118.75, ['info'] = ' Kimble Hill Drive 8', ["office"] = 2 },
	[51] =  { ['x'] = -339.79,['y'] = 668.58,['z'] = 172.79,['h'] = 254.73, ['info'] = ' Kimble Hill Drive 9', ["office"] = 2 },
	[52] =  { ['x'] = -340.03,['y'] = 625.84,['z'] = 171.36,['h'] = 57.48, ['info'] = ' Kimble Hill Drive 10', ["office"] = 2 },
	[53] =  { ['x'] = -400.12,['y'] = 664.99,['z'] = 163.84,['h'] = 352.99, ['info'] = ' Kimble Hill Drive 11', ["office"] = 2 },
	[54] =  { ['x'] = -445.88,['y'] = 685.71,['z'] = 152.96,['h'] = 202.25, ['info'] = ' Kimble Hill Drive 12', ["office"] = 2 },
	[55] =  { ['x'] = -476.73,['y'] = 648.15,['z'] = 144.39,['h'] = 14.58, ['info'] = ' Kimble Hill Drive 13', ["office"] = 2 },
	[56] =  { ['x'] = -595.47,['y'] = 530.13,['z'] = 107.76,['h'] = 196.13, ['info'] = ' Picture Perfect Drive 1', ["office"] = 2 },
	[57] =  { ['x'] = -580.6,['y'] = 492.09,['z'] = 108.91,['h'] = 10.17, ['info'] = ' Picture Perfect Drive 2', ["office"] = 2 },
	[58] =  { ['x'] = -622.94,['y'] = 489.34,['z'] = 108.85,['h'] = 5.51, ['info'] = ' Picture Perfect Drive 3', ["office"] = 2 },
	[59] =  { ['x'] = -640.95,['y'] = 519.88,['z'] = 109.69,['h'] = 182.77, ['info'] = ' Picture Perfect Drive 4', ["office"] = 2 },
	[60] =  { ['x'] = -667.47,['y'] = 472.42,['z'] = 114.14,['h'] = 13.3, ['info'] = ' Picture Perfect Drive 5', ["office"] = 2 },
	[61] =  { ['x'] = -679.0,['y'] = 512.16,['z'] = 113.53,['h'] = 197.35, ['info'] = ' Picture Perfect Drive 6', ["office"] = 2 },
	[62] =  { ['x'] = -721.23,['y'] = 490.13,['z'] = 109.39,['h'] = 208.02, ['info'] = ' Picture Perfect Drive 7', ["office"] = 2 },
	[63] =  { ['x'] = -718.16,['y'] = 449.2,['z'] = 106.91,['h'] = 20.93, ['info'] = ' Picture Perfect Drive 8', ["office"] = 2 },
	[64] =  { ['x'] = -784.21,['y'] = 459.01,['z'] = 100.18,['h'] = 212.24, ['info'] = ' Picture Perfect Drive 9', ["office"] = 2 },
	[65] =  { ['x'] = -762.31,['y'] = 431.49,['z'] = 100.2,['h'] = 15.68, ['info'] = ' Picture Perfect Drive 10', ["office"] = 2 },
	[66] =  { ['x'] = -824.95,['y'] = 422.82,['z'] = 92.13,['h'] = 6.05, ['info'] = ' Picture Perfect Drive 11', ["office"] = 2 },
	[67] =  { ['x'] = -559.45,['y'] = 663.99,['z'] = 145.49,['h'] = 337.57, ['info'] = ' Normandy Drive 1', ["office"] = 2 },
	[68] =  { ['x'] = -564.36,['y'] = 684.27,['z'] = 146.42,['h'] = 203.91, ['info'] = ' Normandy Drive 2', ["office"] = 2 },
	[69] =  { ['x'] = -605.93,['y'] = 672.75,['z'] = 151.6,['h'] = 345.9, ['info'] = ' Normandy Drive 3', ["office"] = 2 },
	[70] =  { ['x'] = -708.57,['y'] = 712.76,['z'] = 162.21,['h'] = 272.94, ['info'] = ' Normandy Drive 4', ["office"] = 2 },
	[71] =  { ['x'] = -646.4,['y'] = 740.98,['z'] = 174.29,['h'] = 38.54, ['info'] = ' Normandy Drive 5', ["office"] = 2 },
	[72] =  { ['x'] = -579.87,['y'] = 733.37,['z'] = 184.22,['h'] = 7.9, ['info'] = ' Normandy Drive 6', ["office"] = 2 },
	[73] =  { ['x'] = -597.52,['y'] = 763.76,['z'] = 189.13,['h'] = 210.93, ['info'] = ' Normandy Drive 7', ["office"] = 2 },
	[74] =  { ['x'] = -595.54,['y'] = 780.72,['z'] = 189.12,['h'] = 296.9, ['info'] = ' Normandy Drive 8', ["office"] = 2 },
	[75] =  { ['x'] = -600.0,['y'] = 807.57,['z'] = 191.53,['h'] = 191.89, ['info'] = ' Normandy Drive 9', ["office"] = 2 },
	[76] =  { ['x'] = -655.22,['y'] = 803.0,['z'] = 199.0,['h'] = 357.23, ['info'] = ' Normandy Drive 10', ["office"] = 2 },
	[77] =  { ['x'] = -747.0,['y'] = 808.49,['z'] = 215.04,['h'] = 288.83, ['info'] = ' Normandy Drive 11', ["office"] = 2 },
	[78] =  { ['x'] = -824.35,['y'] = 806.44,['z'] = 202.79,['h'] = 15.32, ['info'] = ' North Sheldon Ave 1', ["office"] = 2 },
	[79] =  { ['x'] = -867.25,['y'] = 785.09,['z'] = 191.94,['h'] = 3.26, ['info'] = ' North Sheldon Ave 2', ["office"] = 2 },
	[80] =  { ['x'] = -912.39,['y'] = 778.25,['z'] = 187.02,['h'] = 2.82, ['info'] = ' North Sheldon Ave 3', ["office"] = 2 },
	[81] =  { ['x'] = -931.8,['y'] = 808.57,['z'] = 184.79,['h'] = 181.85, ['info'] = ' North Sheldon Ave 4', ["office"] = 2 },
	[82] =  { ['x'] = -962.78,['y'] = 813.66,['z'] = 177.57,['h'] = 183.43, ['info'] = ' North Sheldon Ave 5', ["office"] = 2 },
	[83] =  { ['x'] = -998.42,['y'] = 815.67,['z'] = 173.05,['h'] = 224.1, ['info'] = ' North Sheldon Ave 6', ["office"] = 2 },
	[84] =  { ['x'] = -972.8,['y'] = 752.81,['z'] = 176.39,['h'] = 43.1, ['info'] = ' North Sheldon Ave 7', ["office"] = 2 },
	[85] =  { ['x'] = -1067.57,['y'] = 795.05,['z'] = 166.93,['h'] = 183.88, ['info'] = ' North Sheldon Ave 8', ["office"] = 2 },
	[86] =  { ['x'] = -1100.53,['y'] = 797.36,['z'] = 167.26,['h'] = 184.42, ['info'] = ' North Sheldon Ave 9', ["office"] = 2 },
	[87] =  { ['x'] = -1117.75,['y'] = 761.5,['z'] = 164.29,['h'] = 22.96, ['info'] = ' North Sheldon Ave 10', ["office"] = 2 },
	[88] =  { ['x'] = -1165.36,['y'] = 727.02,['z'] = 155.61,['h'] = 320.97, ['info'] = ' North Sheldon Ave 11', ["office"] = 2 },
	[89] =  { ['x'] = -1197.14,['y'] = 693.54,['z'] = 147.43,['h'] = 58.55, ['info'] = ' North Sheldon Ave 12', ["office"] = 2 },
	[90] =  { ['x'] = -1218.75,['y'] = 665.49,['z'] = 144.54,['h'] = 36.9, ['info'] = ' North Sheldon Ave 13', ["office"] = 2 },
	[91] =  { ['x'] = -1241.58,['y'] = 674.09,['z'] = 142.82,['h'] = 163.44, ['info'] = ' North Sheldon Ave 14', ["office"] = 2 },
	[92] =  { ['x'] = -1248.57,['y'] = 643.07,['z'] = 142.7,['h'] = 298.47, ['info'] = ' North Sheldon Ave 15', ["office"] = 2 },
	[93] =  { ['x'] = -1291.69,['y'] = 649.68,['z'] = 141.51,['h'] = 195.36, ['info'] = ' North Sheldon Ave 16', ["office"] = 2 },
	[94] =  { ['x'] = -1277.65,['y'] = 630.03,['z'] = 143.19,['h'] = 126.27, ['info'] = ' North Sheldon Ave 17', ["office"] = 2 },
	[95] =  { ['x'] = -1405.62,['y'] = 526.89,['z'] = 123.84,['h'] = 89.48, ['info'] = ' North Sheldon Ave 18', ["office"] = 2 },
	[96] =  { ['x'] = -1413.54,['y'] = 462.68,['z'] = 109.21,['h'] = 343.64, ['info'] = ' North Sheldon Ave 19', ["office"] = 2 },
	[97] =  { ['x'] = -1371.72,['y'] = 444.01,['z'] = 105.86,['h'] = 77.97, ['info'] = ' North Sheldon Ave 20', ["office"] = 2 },
	[98] =  { ['x'] = -1339.34,['y'] = 471.13,['z'] = 106.41,['h'] = 177.88, ['info'] = ' North Sheldon Ave 21', ["office"] = 2 },
	[99] =  { ['x'] = -1308.17,['y'] = 449.21,['z'] = 100.97,['h'] = 3.49, ['info'] = ' North Sheldon Ave 22', ["office"] = 2 },
	[100] =  { ['x'] = -1258.6,['y'] = 447.05,['z'] = 94.74,['h'] = 311.7, ['info'] = ' North Sheldon Ave 23', ["office"] = 2 },
	[101] =  { ['x'] = -1215.87,['y'] = 458.05,['z'] = 92.07,['h'] = 4.39, ['info'] = ' North Sheldon Ave 24', ["office"] = 2 },
	[102] =  { ['x'] = -1174.82,['y'] = 440.32,['z'] = 86.85,['h'] = 81.56, ['info'] = ' North Sheldon Ave 25', ["office"] = 2 },
	[103] =  { ['x'] = -1158.66,['y'] = 480.9,['z'] = 86.1,['h'] = 183.19, ['info'] = ' North Sheldon Ave 26', ["office"] = 2 },
	[104] =  { ['x'] = -1122.64,['y'] = 485.93,['z'] = 82.17,['h'] = 155.84, ['info'] = ' North Sheldon Ave 27', ["office"] = 2 },
	[105] =  { ['x'] = -1062.21,['y'] = 475.61,['z'] = 81.33,['h'] = 230.89, ['info'] = ' North Sheldon Ave 28', ["office"] = 2 },
	[106] =  { ['x'] = -1094.54,['y'] = 427.26,['z'] = 75.89,['h'] = 264.53, ['info'] = ' North Sheldon Ave 29', ["office"] = 2 },
	[107] =  { ['x'] = -1052.06,['y'] = 432.39,['z'] = 77.21,['h'] = 7.15, ['info'] = ' North Sheldon Ave 30', ["office"] = 2 },
	[108] =  { ['x'] = -1040.23,['y'] = 507.84,['z'] = 84.39,['h'] = 218.27, ['info'] = ' Cockingend Drive 1', ["office"] = 2 },
	[109] =  { ['x'] = -1009.28,['y'] = 479.67,['z'] = 79.42,['h'] = 325.07, ['info'] = ' Cockingend Drive 2', ["office"] = 2 },
	[110] =  { ['x'] = -1007.1,['y'] = 513.14,['z'] = 79.6,['h'] = 192.26, ['info'] = ' Cockingend Drive 3', ["office"] = 2 },
	[111] =  { ['x'] = -987.16,['y'] = 487.53,['z'] = 82.47,['h'] = 12.96, ['info'] = ' Cockingend Drive 4', ["office"] = 2 },
	[112] =  { ['x'] = -967.77,['y'] = 509.88,['z'] = 81.87,['h'] = 147.25, ['info'] = ' Cockingend Drive 5', ["office"] = 2 },
	[113] =  { ['x'] = -968.3,['y'] = 436.62,['z'] = 80.58,['h'] = 243.25, ['info'] = ' Cockingend Drive 6', ["office"] = 2 },
	[114] =  { ['x'] = -951.21,['y'] = 465.01,['z'] = 80.81,['h'] = 103.16, ['info'] = ' Cockingend Drive 7', ["office"] = 2 },
	[115] =  { ['x'] = -881.89,['y'] = 364.08,['z'] = 85.37,['h'] = 47.53, ['info'] = ' South Milton Drive 1', ["office"] = 2 },
	[116] =  { ['x'] = -877.38,['y'] = 306.49,['z'] = 84.16,['h'] = 239.34, ['info'] = ' South Milton Drive 2', ["office"] = 2 },
	[117] =  { ['x'] = -819.44,['y'] = 267.78,['z'] = 86.4,['h'] = 71.66, ['info'] = ' South Milton Drive 3', ["office"] = 2 },
	[118] =  { ['x'] = -1673.21,['y'] = 385.62,['z'] = 89.35,['h'] = 348.67, ['info'] = ' Ace Jones Drive 1', ["office"] = 2 },
	[119] =  { ['x'] = -1733.29,['y'] = 379.28,['z'] = 89.73,['h'] = 26.89, ['info'] = ' Ace Jones Drive 2', ["office"] = 2 },
	[120] =  { ['x'] = -1807.89,['y'] = 333.46,['z'] = 89.57,['h'] = 18.15, ['info'] = ' Ace Jones Drive 3', ["office"] = 2 },
	[121] =  { ['x'] = -1840.12,['y'] = 314.21,['z'] = 90.92,['h'] = 97.64, ['info'] = ' Ace Jones Drive 4', ["office"] = 2 },
	[122] =  { ['x'] = -1896.51,['y'] = 642.31,['z'] = 130.21,['h'] = 136.27, ['info'] = ' North Rockford Drive 1', ["office"] = 0 },
	[123] =  { ['x'] = -1974.69,['y'] = 630.97,['z'] = 122.56,['h'] = 244.46, ['info'] = ' North Rockford Drive 2', ["office"] = 0 },
	[124] =  { ['x'] = -1928.92,['y'] = 595.29,['z'] = 122.48,['h'] = 70.38, ['info'] = ' North Rockford Drive 3', ["office"] = 0 },
	[125] =  { ['x'] = -1995.83,['y'] = 591.1,['z'] = 117.91,['h'] = 255.27, ['info'] = ' North Rockford Drive 4', ["office"] = 0 },
	[126] =  { ['x'] = -1938.06,['y'] = 551.39,['z'] = 114.83,['h'] = 71.14, ['info'] = ' North Rockford Drive 5', ["office"] = 0 },
	[127] =  { ['x'] = -2014.74,['y'] = 499.75,['z'] = 107.18,['h'] = 254.8, ['info'] = ' North Rockford Drive 6', ["office"] = 0 },
	[128] =  { ['x'] = -2010.5,['y'] = 445.16,['z'] = 103.02,['h'] = 287.53, ['info'] = ' North Rockford Drive 7', ["office"] = 0 },
	[129] =  { ['x'] = -1943.04,['y'] = 449.65,['z'] = 102.93,['h'] = 94.15, ['info'] = ' North Rockford Drive 8', ["office"] = 0 },
	[130] =  { ['x'] = -1940.6,['y'] = 387.59,['z'] = 96.51,['h'] = 180.44, ['info'] = ' North Rockford Drive 9', ["office"] = 0 },
	[131] =  { ['x'] = -2008.4,['y'] = 367.49,['z'] = 94.82,['h'] = 271.42, ['info'] = ' North Rockford Drive 10', ["office"] = 0 },
	[132] =  { ['x'] = -1931.9,['y'] = 362.4,['z'] = 93.79,['h'] = 100.74, ['info'] = ' North Rockford Drive 11', ["office"] = 0 },
	[133] =  { ['x'] = -1922.71,['y'] = 298.25,['z'] = 89.29,['h'] = 101.68, ['info'] = ' North Rockford Drive 12', ["office"] = 0 },
	[134] =  { ['x'] = -1995.39,['y'] = 300.71,['z'] = 91.97,['h'] = 194.4, ['info'] = ' North Rockford Drive 13', ["office"] = 0 },
	[135] =  { ['x'] = -1970.35,['y'] = 246.02,['z'] = 87.82,['h'] = 288.31, ['info'] = ' North Rockford Drive 14', ["office"] = 0 },
	[136] =  { ['x'] = -1905.85,['y'] = 252.77,['z'] = 86.46,['h'] = 118.33, ['info'] = ' North Rockford Drive 15', ["office"] = 0 },
	[137] =  { ['x'] = -1960.68,['y'] = 212.18,['z'] = 86.81,['h'] = 292.54, ['info'] = ' North Rockford Drive 16', ["office"] = 0 },
	[138] =  { ['x'] = -1931.54,['y'] = 163.05,['z'] = 84.66,['h'] = 306.94, ['info'] = ' North Rockford Drive 17', ["office"] = 0 },
	[139] =  { ['x'] = -1874.07,['y'] = 201.7,['z'] = 84.3,['h'] = 126.1, ['info'] = ' North Rockford Drive 18', ["office"] = 0 },
	[35] =  { ['x'] = -1898.8,['y'] = 132.56,['z'] = 81.99,['h'] = 304.26, ['info'] = ' North Rockford Drive 19', ["office"] = 0 },

	[140] =  { ['x'] = -1277.93,['y'] = 496.96,['z'] = 97.9,['h'] = 267.14, ['info'] = ' South Milton Drive 4', ["office"] = 2 },
	[141] =  { ['x'] = -1217.77,['y'] = 506.28,['z'] = 95.67,['h'] = 183.16, ['info'] = ' South Milton Drive 5', ["office"] = 2 },
	[142] =  { ['x'] = -1193.24,['y'] = 563.98,['z'] = 100.34,['h'] = 177.86, ['info'] = ' South Milton Drive 6', ["office"] = 2 },
	[143] =  { ['x'] = -1167.09,['y'] = 568.39,['z'] = 101.83,['h'] = 185.02, ['info'] = ' South Milton Drive 7', ["office"] = 2 },
	[144] =  { ['x'] = -1146.44,['y'] = 545.9,['z'] = 101.91,['h'] = 8.29, ['info'] = ' South Milton Drive 8', ["office"] = 2 },
	[145] =  { ['x'] = -1125.53,['y'] = 548.84,['z'] = 102.58,['h'] = 15.51, ['info'] = ' South Milton Drive 9', ["office"] = 2 },
	[146] =  { ['x'] = -1107.35,['y'] = 593.97,['z'] = 104.46,['h'] = 201.56, ['info'] = ' South Milton Drive 10', ["office"] = 2 },
	[147] =  { ['x'] = -1090.59,['y'] = 547.98,['z'] = 103.64,['h'] = 118.25, ['info'] = ' South Milton Drive 11', ["office"] = 2 },
	[148] =  { ['x'] = -1022.79,['y'] = 586.92,['z'] = 103.43,['h'] = 1.01, ['info'] = ' South Milton Drive 12', ["office"] = 2 },
	[149] =  { ['x'] = -974.35,['y'] = 582.06,['z'] = 102.93,['h'] = 348.81, ['info'] = ' South Milton Drive 13', ["office"] = 2 },
	[150] =  { ['x'] = -958.18,['y'] = 606.44,['z'] = 106.06,['h'] = 351.99, ['info'] = ' South Milton Drive 14', ["office"] = 2 },
	[151] =  { ['x'] = -947.7,['y'] = 567.89,['z'] = 101.5,['h'] = 338.32, ['info'] = ' South Milton Drive 15', ["office"] = 2 },
	[152] =  { ['x'] = -924.9,['y'] = 561.31,['z'] = 100.16,['h'] = 336.51, ['info'] = ' South Milton Drive 16', ["office"] = 2 },
	[153] =  { ['x'] = -904.82,['y'] = 587.84,['z'] = 101.19,['h'] = 147.44, ['info'] = ' South Milton Drive 17', ["office"] = 2 },
	[154] =  { ['x'] = -907.28,['y'] = 545.09,['z'] = 100.21,['h'] = 315.89, ['info'] = ' South Milton Drive 18', ["office"] = 2 },
	[155] =  { ['x'] = -873.79,['y'] = 562.75,['z'] = 96.62,['h'] = 128.14, ['info'] = ' South Milton Drive 19', ["office"] = 2 },
	[156] =  { ['x'] = -884.33,['y'] = 517.9,['z'] = 92.45,['h'] = 285.97, ['info'] = ' South Milton Drive 20', ["office"] = 2 },
	[157] =  { ['x'] = -848.74,['y'] = 508.88,['z'] = 90.82,['h'] = 14.95, ['info'] = ' South Milton Drive 21', ["office"] = 2 },
	[158] =  { ['x'] = -875.67,['y'] = 486.18,['z'] = 87.82,['h'] = 9.53, ['info'] = ' South Milton Drive 22', ["office"] = 2 },
	[159] =  { ['x'] = -843.25,['y'] = 466.64,['z'] = 87.6,['h'] = 278.4, ['info'] = ' South Milton Drive 23', ["office"] = 2 },

	[160] =  { ['x'] = -686.06,['y'] = 596.22,['z'] = 143.65,['h'] = 38.28, ['info'] = ' Hillcrest Avenue 1', ["office"] = 2 },
	[161] =  { ['x'] = -704.22,['y'] = 588.97,['z'] = 141.94,['h'] = 0.48, ['info'] = ' Hillcrest Avenue 2', ["office"] = 2 },
	[162] =  { ['x'] = -732.89,['y'] = 593.9,['z'] = 142.24,['h'] = 330.96, ['info'] = ' Hillcrest Avenue 3', ["office"] = 2 },
	[163] =  { ['x'] = -752.6,['y'] = 620.49,['z'] = 142.5,['h'] = 286.32, ['info'] = ' Hillcrest Avenue 4', ["office"] = 2 },
	[164] =  { ['x'] = -765.26,['y'] = 650.61,['z'] = 145.51,['h'] = 290.11, ['info'] = ' Hillcrest Avenue 5', ["office"] = 2 },
	[165] =  { ['x'] = -819.35,['y'] = 696.63,['z'] = 148.11,['h'] = 17.47, ['info'] = ' Hillcrest Avenue 6', ["office"] = 2 },
	[166] =  { ['x'] = -852.97,['y'] = 695.64,['z'] = 148.79,['h'] = 1.41, ['info'] = ' Hillcrest Avenue 7', ["office"] = 2 },
	[167] =  { ['x'] = -884.72,['y'] = 699.56,['z'] = 151.28,['h'] = 67.64, ['info'] = ' Hillcrest Avenue 8', ["office"] = 2 },
	[168] =  { ['x'] = -908.78,['y'] = 693.66,['z'] = 151.44,['h'] = 359.17, ['info'] = ' Hillcrest Avenue 9', ["office"] = 2 },
	[169] =  { ['x'] = -931.55,['y'] = 691.14,['z'] = 153.47,['h'] = 357.54, ['info'] = ' Hillcrest Avenue 10', ["office"] = 2 },
	[170] =  { ['x'] = -973.89,['y'] = 684.48,['z'] = 158.04,['h'] = 171.97, ['info'] = ' Hillcrest Avenue 11', ["office"] = 2 },
	[171] =  { ['x'] = -1032.72,['y'] = 686.05,['z'] = 161.31,['h'] = 88.24, ['info'] = ' Hillcrest Avenue 12', ["office"] = 2 },
	[172] =  { ['x'] = -1065.09,['y'] = 727.52,['z'] = 165.48,['h'] = 2.2, ['info'] = ' Hillcrest Avenue 13', ["office"] = 2 },
	[173] =  { ['x'] = -1056.3,['y'] = 761.4,['z'] = 167.32,['h'] = 261.94, ['info'] = ' Hillcrest Avenue 14', ["office"] = 2 },

	[174] =  { ['x'] = -658.48,['y'] = 886.73,['z'] = 229.25,['h'] = 2.13, ['info'] = ' Milton Road 4', ["office"] = 2 },
	[175] =  { ['x'] = -596.99,['y'] = 851.56,['z'] = 211.47,['h'] = 42.36, ['info'] = ' Milton Road 5', ["office"] = 2 },
	[176] =  { ['x'] = -536.75,['y'] = 818.37,['z'] = 197.52,['h'] = 339.07, ['info'] = ' Milton Road 6', ["office"] = 2 },
	[177] =  { ['x'] = -493.97,['y'] = 795.97,['z'] = 184.34,['h'] = 51.78, ['info'] = ' Milton Road 7', ["office"] = 2 },
	[178] =  { ['x'] = -495.43,['y'] = 738.69,['z'] = 163.04,['h'] = 313.52, ['info'] = ' Milton Road 8', ["office"] = 2 },
	[179] =  { ['x'] = -533.09,['y'] = 709.41,['z'] = 153.16,['h'] = 191.95, ['info'] = ' Milton Road 9', ["office"] = 2 },
	[180] =  { ['x'] = -499.07,['y'] = 682.71,['z'] = 151.57,['h'] = 357.59, ['info'] = ' Milton Road 10', ["office"] = 2 },
	[181] =  { ['x'] = -523.01,['y'] = 628.17,['z'] = 137.98,['h'] = 285.12, ['info'] = ' Milton Road 11', ["office"] = 2 },
	[182] =  { ['x'] = -474.55,['y'] = 586.04,['z'] = 128.69,['h'] = 90.31, ['info'] = ' Milton Road 12', ["office"] = 2 },
	[183] =  { ['x'] = -520.33,['y'] = 594.28,['z'] = 120.84,['h'] = 275.76, ['info'] = ' Milton Road 13', ["office"] = 2 },
	[184] =  { ['x'] = -554.62,['y'] = 540.83,['z'] = 110.71,['h'] = 165.83, ['info'] = ' Milton Road 14', ["office"] = 2 },
	[185] =  { ['x'] = -526.72,['y'] = 517.48,['z'] = 112.94,['h'] = 40.68, ['info'] = ' Milton Road 15', ["office"] = 2 },
	[186] =  { ['x'] = -537.25,['y'] = 477.7,['z'] = 103.2,['h'] = 45.23, ['info'] = ' Milton Road 16', ["office"] = 2 },

	[187] =  { ['x'] = 362.99,['y'] = -711.79,['z'] = 29.28,['h'] = 72.84, ['info'] = ' Office Strawberry Ave 1', ["office"] = 1 },
	[188] =  { ['x'] = 286.51,['y'] = -790.46,['z'] = 29.44,['h'] = 248.43, ['info'] = ' Office Strawberry Ave 2', ["office"] = 1 },
	[189] =  { ['x'] = 253.7,['y'] = -1012.84,['z'] = 29.27,['h'] = 69.39, ['info'] = ' Office Strawberry Ave 3', ["office"] = 1 },
	[190] =  { ['x'] = 243.38,['y'] = -1073.33,['z'] = 29.29,['h'] = 358.96, ['info'] = ' Office Strawberry Ave 4', ["office"] = 1 },
	[191] =  { ['x'] = 185.86,['y'] = -1078.38,['z'] = 29.28,['h'] = 260.31, ['info'] = ' Office Strawberry Ave 5', ["office"] = 1 },
	[192] =  { ['x'] = 113.47,['y'] = -1038.24,['z'] = 29.32,['h'] = 69.47, ['info'] = ' Office Elgin Ave 1', ["office"] = 1 },
	[193] =  { ['x'] = 134.54,['y'] = -859.39,['z'] = 30.78,['h'] = 250.49, ['info'] = ' Office Elgin Ave 2', ["office"] = 1 },
	[194] =  { ['x'] = 143.29,['y'] = -832.4,['z'] = 31.18,['h'] = 293.49, ['info'] = ' Office Elgin Ave 3', ["office"] = 1 },
	[195] =  { ['x'] = 212.58,['y'] = -593.98,['z'] = 43.87,['h'] = 156.54, ['info'] = ' Office Elgin Ave 4', ["office"] = 1 },
	[196] =  { ['x'] = 192.92,['y'] = -584.91,['z'] = 43.87,['h'] = 159.22, ['info'] = ' Office Elgin Ave 5', ["office"] = 1 },
	[197] =  { ['x'] = 213.97,['y'] = -568.45,['z'] = 43.87,['h'] = 326.78, ['info'] = ' Office Elgin Ave 6', ["office"] = 1 },
	[198] =  { ['x'] = 270.54,['y'] = -433.34,['z'] = 45.25,['h'] = 249.71, ['info'] = ' Office Elgin Ave 7', ["office"] = 1 },
	[199] =  { ['x'] = 224.58,['y'] = -441.82,['z'] = 45.25,['h'] = 158.33, ['info'] = ' Office Elgin Ave 8', ["office"] = 1 },
	[200] =  { ['x'] = 195.48,['y'] = -406.31,['z'] = 45.26,['h'] = 68.25, ['info'] = ' Office Elgin Ave 9', ["office"] = 1 },
	[201] =  { ['x'] = 389.19,['y'] = -75.43,['z'] = 68.19,['h'] = 159.97, ['info'] = ' Office Elgin Ave 10', ["office"] = 1 },
	[202] =  { ['x'] = 554.9,['y'] = 151.45,['z'] = 99.26,['h'] = 71.95, ['info'] = ' Office Elgin Ave 11', ["office"] = 1 },
	[203] =  { ['x'] = -286.08,['y'] = 280.58,['z'] = 89.89,['h'] = 176.35, ['info'] = ' Office Eclipse Blvd 1', ["office"] = 1 },
	[204] =  { ['x'] = -354.76,['y'] = 213.25,['z'] = 86.71,['h'] = 340.74, ['info'] = ' Office Eclipse Blvd 2', ["office"] = 1 },
	[205] =  { ['x'] = -640.22,['y'] = 296.87,['z'] = 82.46,['h'] = 173.53, ['info'] = ' Office Eclipse Blvd 3', ["office"] = 1 },
	[206] =  { ['x'] = -680.36,['y'] = 314.17,['z'] = 83.09,['h'] = 175.93, ['info'] = ' Office Eclipse Blvd 4', ["office"] = 1 },
	[207] =  { ['x'] = -715.76,['y'] = 303.66,['z'] = 85.31,['h'] = 162.59, ['info'] = ' Office Eclipse Blvd 5', ["office"] = 1 },
	[208] =  { ['x'] = -773.74,['y'] = 312.33,['z'] = 85.7,['h'] = 255.87, ['info'] = ' Office Eclipse Blvd 6', ["office"] = 1 },
	[209] =  { ['x'] = -742.72,['y'] = 246.4,['z'] = 77.34,['h'] = 203.17, ['info'] = ' Office Eclipse Blvd 7', ["office"] = 1 },
	[210] =  { ['x'] = -686.4,['y'] = 224.09,['z'] = 81.96,['h'] = 19.57, ['info'] = ' Office Eclipse Blvd 8', ["office"] = 1 },

	[211] =  { ['x'] = -312.37,['y'] = 474.56,['z'] = 111.83,['h'] = 121.53, ['info'] = ' Didion Drive 13', ["office"] = 2 },
	[212] =  { ['x'] = -355.63,['y'] = 458.57,['z'] = 117.23,['h'] = 166.56, ['info'] = ' Didion Drive 14', ["office"] = 2 },
	[213] =  { ['x'] = -348.73,['y'] = 514.73,['z'] = 120.63,['h'] = 136.56, ['info'] = ' Didion Drive 15', ["office"] = 2 },
	[214] =  { ['x'] = -386.72,['y'] = 504.36,['z'] = 120.63,['h'] = 336.56, ['info'] = ' Didion Drive 16', ["office"] = 2 },
	[215] =  { ['x'] = -377.98,['y'] = 548.42,['z'] = 124.43,['h'] = 196.56, ['info'] = ' Didion Drive 17', ["office"] = 2 },
	[216] =  { ['x'] = -425.69,['y'] = 535.67,['z'] = 122.83,['h'] = 351.56, ['info'] = ' Didion Drive 18', ["office"] = 2 },
	[217] =  { ['x'] = -406.66,['y'] = 567.19,['z'] = 124.53,['h'] = 171.56, ['info'] = ' Didion Drive 19', ["office"] = 2 },
	[218] =  { ['x'] = -459.33,['y'] = 537.41,['z'] = 121.73,['h'] = 354.06, ['info'] = ' Didion Drive 20', ["office"] = 2 },


	[219] =  { ['x'] = 960.54,['y'] = -669.38,['z'] = 58.45,['h'] = 122.8, ['info'] = ' West Mirror Drive 18', ['office'] = 0 },

	[220] =  { ['x'] = 903.47,['y'] = -615.87,['z'] = 58.46,['h'] = 48.6, ['info'] = ' West Mirror Drive 15', ['office'] = 0 },

	[221] =  { ['x'] = 979.92,['y'] = -627.24,['z'] = 59.24,['h'] = 215.31, ['info'] = ' West Mirror Drive 22', ['office'] = 0 },


	[222] =  { ['x'] = 1302.79,['y'] = -528.61,['z'] = 71.47,['h'] = 339.7, ['info'] = ' Nikola Place 1', ['office'] = 0 },
	[223] =  { ['x'] = 1372.97,['y'] = -555.69,['z'] = 74.69,['h'] = 244.2, ['info'] = ' Nikola Place 4', ['office'] = 0 },
	[224] =  { ['x'] = 1388.3,['y'] = -569.93,['z'] = 74.5,['h'] = 293.08, ['info'] = ' Nikola Place 5', ['office'] = 0 },
	[225] =  { ['x'] = 1385.47,['y'] = -592.93,['z'] = 74.49,['h'] = 231.77, ['info'] = ' Nikola Place 6', ['office'] = 0 },
	[226] =  { ['x'] = 1367.28,['y'] = -605.44,['z'] = 74.72,['h'] = 169.15, ['info'] = ' Nikola Place 7', ['office'] = 0 },
	[227] =  { ['x'] = 1341.63,['y'] = -597.5,['z'] = 74.71,['h'] = 50.55, ['info'] = ' Nikola Place 8', ['office'] = 0 },
	[228] =  { ['x'] = 1323.76,['y'] = -582.45,['z'] = 73.25,['h'] = 154.05, ['info'] = ' Nikola Place 9', ['office'] = 0 }, 
	[229] =  { ['x'] = 1301.24,['y'] = -573.21,['z'] = 71.74,['h'] = 160.82, ['info'] = ' Nikola Place 10', ['office'] = 0 },

	[230] =  { ['x'] = 1347.87,['y'] = -548.01,['z'] = 73.9,['h'] = 336.0, ['info'] = ' Nikola Place 3', ['office'] = 0 },
	[231] =  { ['x'] = 1327.76,['y'] = -535.86,['z'] = 72.45,['h'] = 255.65, ['info'] = ' Nikola Place 2', ['office'] = 0 },

	[232] =  { ['x'] = -604.72,['y'] = -802.51,['z'] = 25.2,['h'] = 271.79, ['info'] = ' Mansion Little Seoul 1' , ['office'] = 0 },
	[233] =  { ['x'] = -603.97,['y'] = -783.37,['z'] = 25.41,['h'] = 186.1, ['info'] = ' Mansion Little Seoul 2' , ['office'] = 0 },
	[234] =  { ['x'] = -604.03,['y'] = -773.97,['z'] = 25.41,['h'] = 0.84, ['info'] = ' Mansion Little Seoul 3' , ['office'] = 0 },
	[235] =  { ['x'] = -580.07,['y'] = -778.66,['z'] = 25.02,['h'] = 273.73, ['info'] = ' Mansion Little Seoul 4' , ['office'] = 0 },


	[236] =  { ['x'] = -70.99,['y'] = -800.66,['z'] = 44.23,['h'] = 164.99, ['info'] = ' Payne & Associates' , ['office'] = 1 },

	[237] =  { ['x'] = -244.64,['y'] = -814.51,['z'] = 30.72,['h'] = 209.61, ['info'] = ' Office Peaceful Street 1', ["office"] = 1 },
	[238] =  { ['x'] = -266.18,['y'] = -735.32,['z'] = 34.42,['h'] = 69.17, ['info'] = ' Office Peaceful Street 2', ["office"] = 1 },
	[239] =  { ['x'] = 101.79,['y'] = -819.41,['z'] = 31.32,['h'] = 155.57, ['info'] = ' Office Elgin Avenue 12', ["office"] = 1 },
	[240] =  { ['x'] = 296.29,['y'] = -1027.42,['z'] = 29.22,['h'] = 352.14, ['info'] = ' Office Strawberry Avenue 6', ["office"] = 1 },
	[241] =  { ['x'] = 561.63,['y'] = 93.55,['z'] = 96.11,['h'] = 339.54, ['info'] = ' Office Vinewood Blvd 1', ["office"] = 1 },
	[242] =  { ['x'] = 359.48,['y'] = 88.7,['z'] = 100.43,['h'] = 250.02, ['info'] = ' Office Vinewood Blvd 2', ["office"] = 1 },
	[243] =  { ['x'] = -1016.09,['y'] = -265.7,['z'] = 39.05,['h'] = 240.41, ['info'] = ' Office South Blvd Del Perro 1', ["office"] = 1 },
	[244] =  { ['x'] = -769.01,['y'] = -355.94,['z'] = 37.34,['h'] = 155.54, ['info'] = ' Office Dorset Dr 1', ["office"] = 1 },
	[245] =  { ['x'] = -1366.01,['y'] = 56.62,['z'] = 54.1,['h'] = 271.73, ['info'] = ' Richman Meadows Golf', ["office"] = 1 },
	
	[246] =  { ['x'] = -188.82,['y'] = 978.75,['z'] = 236.14,['h'] = 267.51, ['info'] = ' Vinewood Hills 1' , ['office'] = 2 },
	[247] =  { ['x'] = -112.98,['y'] = 986.14,['z'] = 235.76,['h'] = 288.75, ['info'] = ' Vinewood Hills 2' , ['office'] = 2 },
	[248] =  { ['x'] = -151.76,['y'] = 910.59,['z'] = 235.66,['h'] = 228.29, ['info'] = ' Vinewood Hills 3' , ['office'] = 2 },
	[249] =  { ['x'] = -85.6,['y'] = 834.8,['z'] = 235.93,['h'] = 275.3, ['info'] = ' Vinewood Hills 4' , ['office'] = 2 },

	[250] =  { ['x'] = 201.87,['y'] = -239.06,['z'] = 53.97,['h'] = 118.21, ['info'] = ' White Widow', ['office'] = 1 },
	[251] =  { ['x'] = 443.67,['y'] = -1900.2,['z'] = 31.74,['h'] = 43.19, ['info'] = ' Little Bighorn Ave 1', ['office'] = 1 },
	[252] =  { ['x'] = -1804.93,['y'] = 437.09,['z'] = 128.71,['h'] = 178.84, ['info'] = ' Payne Manor', ["office"] = 0 },
	[253] =  { ['x'] = -2587.8,['y'] = 1910.86,['z'] = 167.5,['h'] = 187.73, ['info'] = ' Buen Vino Rd 1', ['office'] = 2 },
	[254] =  { ['x'] = -1155.84,['y'] = -1543.05,['z'] = 4.45,['h'] = 36.8, ['info'] = ' Los Santos Wrestling Federation HQ' , ['office'] = 1 },
	[255] =  { ['x'] = -767.73,['y'] = -751.83,['z'] = 27.88,['h'] = 80.93, ['info'] = ' Dream Tower 1', ['office'] = 0 },
	[256] =  { ['x'] = -780.29,['y'] = -753.82,['z'] = 27.88,['h'] = 263.71, ['info'] = ' Dream Tower 2', ['office'] = 0 },
	[257] =  { ['x'] = -780.27,['y'] = -784.25,['z'] = 27.88,['h'] = 269.11, ['info'] = ' Dream Tower 3', ['office'] = 0 },
	[258] =  { ['x'] = -809.55,['y'] = -978.32,['z'] = 14.23,['h'] = 307.74, ['info'] = ' Ginger St South 1', ['office'] = 0 },
	[259] =  { ['x'] = -715.32,['y'] = -996.49,['z'] = 18.34,['h'] = 296.68, ['info'] = ' Ginger St South 3', ['office'] = 0 },
	[260] =  { ['x'] = -98.33,['y'] = 367.49,['z'] = 113.28,['h'] = 337.13, ['info'] = ' Gentry Ln Office #1' , ['office'] = 1 },
	[261] =  { ['x'] = 813.48,['y'] = -2982.51,['z'] = 6.03,['h'] = 98.76, ['info'] = ' Dock Office #1' , ['office'] = 1 },
	[262] =  { ['x'] = -143.76,['y'] = 229.72,['z'] = 94.94,['h'] = 178.75, ['info'] = ' Office Eclipse Blvd 9', ['office'] = 1 },
	[263] =  { ['x'] = -1356.6,['y'] = -791.17,['z'] = 20.25,['h'] = 311.43, ['info'] = ' Office Bay City Ave #1 ', ['office'] = 1 },
	[264] =  { ['x'] = 288.13,['y'] = -1095.02,['z'] = 29.42,['h'] = 85.8, ['info'] = 'Office Fantastic Place #1' , ['office'] = 1 },
}

robberycoords = {
	[1] =  { ['x'] = 1061.04,['y'] = -378.61,['z'] = 68.24,['h'] = 37.87, ['info'] = ' West Mirror Drive 1', ['apt'] = 2 },
	[2] =  { ['x'] = 1029.42,['y'] = -408.96,['z'] = 65.95,['h'] = 38.91, ['info'] = ' West Mirror Drive 2', ['apt'] = 2 },
	[3] =  { ['x'] = 1011.27,['y'] = -422.89,['z'] = 64.96,['h'] = 121.8, ['info'] = ' West Mirror Drive 3', ['apt'] = 2 },
	[4] =  { ['x'] = 988.2,['y'] = -433.74,['z'] = 63.9,['h'] = 34.72, ['info'] = ' West Mirror Drive 4', ['apt'] = 2 },
	[5] =  { ['x'] = 967.9,['y'] = -452.62,['z'] = 62.41,['h'] = 32.83, ['info'] = ' West Mirror Drive 5', ['apt'] = 2 },
	[6] =  { ['x'] = 943.26,['y'] = -463.9,['z'] = 61.4,['h'] = 299.36, ['info'] = ' West Mirror Drive 6', ['apt'] = 2 },
	[7] =  { ['x'] = 922.18,['y'] = -478.69,['z'] = 61.09,['h'] = 22.83, ['info'] = ' West Mirror Drive 7', ['apt'] = 2 },
	[8] =  { ['x'] = 906.58,['y'] = -489.69,['z'] = 59.44,['h'] = 29.93, ['info'] = ' West Mirror Drive 8', ['apt'] = 2 },
	[9] =  { ['x'] = 878.99,['y'] = -498.51,['z'] = 57.88,['h'] = 46.17, ['info'] = ' West Mirror Drive 9', ['apt'] = 2 },
	[10] =  { ['x'] = 862.28,['y'] = -509.58,['z'] = 57.33,['h'] = 48.03, ['info'] = ' West Mirror Drive 10', ['apt'] = 2 },
	[11] =  { ['x'] = 851.09,['y'] = -532.73,['z'] = 57.93,['h'] = 84.22, ['info'] = ' West Mirror Drive 11', ['apt'] = 2 },
	[12] =  { ['x'] = 844.37,['y'] = -563.77,['z'] = 57.84,['h'] = 15.0, ['info'] = ' West Mirror Drive 12', ['apt'] = 2 },
	[13] =  { ['x'] = 861.92,['y'] = -582.26,['z'] = 58.16,['h'] = 170.48, ['info'] = ' West Mirror Drive 13', ['apt'] = 2 },
	[14] =  { ['x'] = 887.43,['y'] = -607.54,['z'] = 58.22,['h'] = 133.7, ['info'] = ' West Mirror Drive 14', ['apt'] = 2 },
	[15] =  { ['x'] = 11.5,['y'] = 6578.22,['z'] = 33.08,['h'] = 223.29, ['info'] = ' Paleto Blvd 2', ['apt'] = 2 },
	[16] =  { ['x'] = 929.51,['y'] = -639.12,['z'] = 58.25,['h'] = 139.34, ['info'] = ' West Mirror Drive 16', ['apt'] = 2 },
	[17] =  { ['x'] = 943.4,['y'] = -653.71,['z'] = 58.43,['h'] = 36.32, ['info'] = ' West Mirror Drive 17', ['apt'] = 2 },
	[18] =  { ['x'] = -14.72,['y'] = 6557.54,['z'] = 33.25,['h'] = 311.79, ['info'] = ' Paleto Blvd 3', ['apt'] = 2 },
	[19] =  { ['x'] = 970.9,['y'] = -701.41,['z'] = 58.49,['h'] = 168.31, ['info'] = ' West Mirror Drive 19', ['apt'] = 2 },
	[20] =  { ['x'] = 979.49,['y'] = -715.95,['z'] = 58.22,['h'] = 131.16, ['info'] = ' West Mirror Drive 20', ['apt'] = 2 },
	[21] =  { ['x'] = 997.52,['y'] = -729.0,['z'] = 57.82,['h'] = 128.93, ['info'] = ' West Mirror Drive 21', ['apt'] = 2 },
	[22] =  { ['x'] = -374.77,['y'] = 6190.77,['z'] = 31.73,['h'] = 223.2, ['info'] = ' Paleto Blvd 5', ['apt'] = 2 },
	[23] =  { ['x'] = 892.79,['y'] = -540.7,['z'] = 58.51,['h'] = 295.06, ['info'] = ' West Mirror Drive 23', ['apt'] = 2 },
	[24] =  { ['x'] = 924.02,['y'] = -525.3,['z'] = 59.58,['h'] = 208.51, ['info'] = ' West Mirror Drive 24', ['apt'] = 2 },
	[25] =  { ['x'] = 946.26,['y'] = -518.79,['z'] = 60.63,['h'] = 122.26, ['info'] = ' West Mirror Drive 25', ['apt'] = 2 },
	[26] =  { ['x'] = 969.57,['y'] = -502.1,['z'] = 62.15,['h'] = 253.28, ['info'] = ' West Mirror Drive 26', ['apt'] = 2 },
	[27] =  { ['x'] = 1014.14,['y'] = -468.72,['z'] = 64.29,['h'] = 214.9, ['info'] = ' West Mirror Drive 27', ['apt'] = 2 },
	[28] =  { ['x'] = 1112.37,['y'] = -390.29,['z'] = 68.74,['h'] = 244.07, ['info'] = ' West Mirror Drive 28', ['apt'] = 2 },
	[29] =  { ['x'] = 1263.96,['y'] = -429.2,['z'] = 69.81,['h'] = 111.8, ['info'] = ' East Mirror Drive 1', ['apt'] = 2 },
	[30] =  { ['x'] = 1266.76,['y'] = -457.85,['z'] = 70.52,['h'] = 97.77, ['info'] = ' East Mirror Drive 2', ['apt'] = 2 },
	[31] =  { ['x'] = 1260.28,['y'] = -479.9,['z'] = 70.19,['h'] = 112.32, ['info'] = ' East Mirror Drive 3', ['apt'] = 2 },
	[32] =  { ['x'] = 1251.86,['y'] = -494.2,['z'] = 69.91,['h'] = 78.13, ['info'] = ' East Mirror Drive 4', ['apt'] = 2 },
	[33] =  { ['x'] = 1251.5,['y'] = -515.63,['z'] = 69.35,['h'] = 75.67, ['info'] = ' East Mirror Drive 5', ['apt'] = 2 },
	[34] =  { ['x'] = 1242.17,['y'] = -565.88,['z'] = 69.66,['h'] = 125.6, ['info'] = ' East Mirror Drive 6', ['apt'] = 2 },
	[35] =  { ['x'] = 1241.1,['y'] = -601.67,['z'] = 69.59,['h'] = 92.86, ['info'] = ' East Mirror Drive 7', ['apt'] = 2 },
	[36] =  { ['x'] = 1251.6,['y'] = -621.98,['z'] = 69.41,['h'] = 26.0, ['info'] = ' East Mirror Drive 8', ['apt'] = 2 },
	[37] =  { ['x'] = 1265.41,['y'] = -647.89,['z'] = 67.93,['h'] = 199.31, ['info'] = ' East Mirror Drive 9', ['apt'] = 2 },
	[38] =  { ['x'] = 1271.13,['y'] = -683.04,['z'] = 66.04,['h'] = 178.05, ['info'] = ' East Mirror Drive 10', ['apt'] = 2 },
	[39] =  { ['x'] = 1265.94,['y'] = -703.52,['z'] = 64.56,['h'] = 61.26, ['info'] = ' East Mirror Drive 11', ['apt'] = 2 },
	[40] =  { ['x'] = -157.31,['y'] = 6409.99,['z'] = 31.92,['h'] = 33.16, ['info'] = ' Procopio Drive 20 / Apt 5', ['apt'] = 1 },
	[41] =  { ['x'] = -105.49,['y'] = 6528.7,['z'] = 30.17,['h'] = 313.4, ['info'] = ' Procopio Drive 21', ['apt'] = 3 },
	[42] =  { ['x'] = -44.43,['y'] = 6582.55,['z'] = 32.18,['h'] = 45.65, ['info'] = ' Procopio Drive 22', ['apt'] = 3 },
	[43] =  { ['x'] = -27.44,['y'] = 6597.89,['z'] = 31.87,['h'] = 47.34, ['info'] = ' Procopio Drive 23', ['apt'] = 3 },
	[44] =  { ['x'] = 1.36,['y'] = 6613.18,['z'] = 31.89,['h'] = 26.34, ['info'] = ' Procopio Drive 24', ['apt'] = 3 },
	[45] =  { ['x'] = 31.22,['y'] = 6596.67,['z'] = 32.83,['h'] = 223.03, ['info'] = ' Paleto Blvd 1', ['apt'] = 3 },
	[46] =  { ['x'] = -167.23,['y'] = 6439.25,['z'] = 31.92,['h'] = 131.66, ['info'] = ' Procopio Drive 20 / Apt 1', ['apt'] = 1 },
	[47] =  { ['x'] = -160.3,['y'] = 6432.18,['z'] = 31.92,['h'] = 130.17, ['info'] = ' Procopio Drive 20 / Apt 2', ['apt'] = 1 },
	[48] =  { ['x'] = -150.38,['y'] = 6422.38,['z'] = 31.92,['h'] = 133.68, ['info'] = ' Procopio Drive 20 / Apt 3', ['apt'] = 1 },
	[49] =  { ['x'] = -150.38,['y'] = 6416.99,['z'] = 31.92,['h'] = 41.43, ['info'] = ' Procopio Drive 20 / Apt 4', ['apt'] = 1 },
	[50] =  { ['x'] = 1437.15,['y'] = -1492.97,['z'] = 63.44,['h'] = 340.13, ['info'] = ' Fudge Lane 1', ['apt'] = 0 },
	[51] =  { ['x'] = 1379.49,['y'] = -1515.41,['z'] = 58.04,['h'] = 28.29, ['info'] = ' Fudge Lane 2', ['apt'] = 0 },
	[52] =  { ['x'] = 1338.24,['y'] = -1524.22,['z'] = 54.59,['h'] = 354.77, ['info'] = ' Fudge Lane 3', ['apt'] = 0 },
	[53] =  { ['x'] = 1316.2,['y'] = -1528.01,['z'] = 51.42,['h'] = 13.96, ['info'] = ' Fudge Lane 4', ['apt'] = 0 },
	[54] =  { ['x'] = 1231.17,['y'] = -1591.76,['z'] = 53.56,['h'] = 31.72, ['info'] = ' Fudge Lane 5', ['apt'] = 0 },
	[55] =  { ['x'] = 1205.91,['y'] = -1607.85,['z'] = 50.54,['h'] = 29.31, ['info'] = ' Fudge Lane 6', ['apt'] = 0 },
	[56] =  { ['x'] = 1192.94,['y'] = -1622.69,['z'] = 45.23,['h'] = 304.06, ['info'] = ' Fudge Lane 7', ['apt'] = 0 },
	[57] =  { ['x'] = 1192.82,['y'] = -1655.06,['z'] = 43.03,['h'] = 211.63, ['info'] = ' Fudge Lane 8', ['apt'] = 0 },
	[58] =  { ['x'] = 1214.11,['y'] = -1643.33,['z'] = 48.65,['h'] = 207.97, ['info'] = ' Fudge Lane 9', ['apt'] = 0 },
	[59] =  { ['x'] = 1244.78,['y'] = -1625.69,['z'] = 53.29,['h'] = 210.54, ['info'] = ' Fudge Lane 10', ['apt'] = 0 },
	[60] =  { ['x'] = 1261.31,['y'] = -1616.26,['z'] = 54.75,['h'] = 210.56, ['info'] = ' Fudge Lane 11', ['apt'] = 0 },
	[61] =  { ['x'] = 1286.4,['y'] = -1603.31,['z'] = 54.83,['h'] = 193.95, ['info'] = ' Fudge Lane 12', ['apt'] = 0 },
	[62] =  { ['x'] = 1327.22,['y'] = -1552.61,['z'] = 54.06,['h'] = 228.68, ['info'] = ' Fudge Lane 13', ['apt'] = 0 },
	[63] =  { ['x'] = 1360.39,['y'] = -1554.92,['z'] = 55.95,['h'] = 190.45, ['info'] = ' Fudge Lane 14', ['apt'] = 0 },
	[64] =  { ['x'] = 1382.68,['y'] = -1544.46,['z'] = 57.11,['h'] = 124.25, ['info'] = ' Fudge Lane 15', ['apt'] = 0 },
	[65] =  { ['x'] = 1365.25,['y'] = -1720.38,['z'] = 65.64,['h'] = 193.47, ['info'] = ' Amarillo Vista 1', ['apt'] = 0 },
	[66] =  { ['x'] = 1315.17,['y'] = -1732.63,['z'] = 54.71,['h'] = 115.0, ['info'] = ' Amarillo Vista 2', ['apt'] = 0 },
	[67] =  { ['x'] = 1295.86,['y'] = -1739.44,['z'] = 54.28,['h'] = 109.9, ['info'] = ' Amarillo Vista 3', ['apt'] = 0 },
	[68] =  { ['x'] = 1258.81,['y'] = -1761.27,['z'] = 49.67,['h'] = 202.25, ['info'] = ' Amarillo Vista 4', ['apt'] = 0 },
	[69] =  { ['x'] = 1251.01,['y'] = -1735.07,['z'] = 52.03,['h'] = 21.33, ['info'] = ' Amarillo Vista 5', ['apt'] = 0 },
	[70] =  { ['x'] = 1289.66,['y'] = -1711.45,['z'] = 55.28,['h'] = 21.9, ['info'] = ' Amarillo Vista 7', ['apt'] = 0 },
	[71] =  { ['x'] = 1316.97,['y'] = -1699.67,['z'] = 57.84,['h'] = 9.87, ['info'] = ' Amarillo Vista 8', ['apt'] = 0 },
	[72] =  { ['x'] = 1355.45,['y'] = -1690.85,['z'] = 60.5,['h'] = 79.86, ['info'] = ' Amarillo Vista 9', ['apt'] = 0 },
	[73] =  { ['x'] = -51.01,['y'] = -1783.87,['z'] = 28.31,['h'] = 314.06, ['info'] = ' Grove Street 1', ['apt'] = 0 },
	[74] =  { ['x'] = -42.56,['y'] = -1792.78,['z'] = 27.83,['h'] = 313.07, ['info'] = ' Grove Street 2', ['apt'] = 0 },
	[75] =  { ['x'] = 20.57,['y'] = -1844.12,['z'] = 24.61,['h'] = 227.62, ['info'] = ' Grove Street 3', ['apt'] = 0 },
	[76] =  { ['x'] = 29.32,['y'] = -1853.94,['z'] = 24.07,['h'] = 226.91, ['info'] = ' Grove Street 4', ['apt'] = 0 },
	[77] =  { ['x'] = 45.32,['y'] = -1864.99,['z'] = 23.28,['h'] = 314.88, ['info'] = ' Grove Street 5', ['apt'] = 0 },
	[78] =  { ['x'] = 54.44,['y'] = -1873.17,['z'] = 22.81,['h'] = 313.76, ['info'] = ' Grove Street 6', ['apt'] = 0 },
	[79] =  { ['x'] = 100.48,['y'] = -1913.0,['z'] = 21.21,['h'] = 331.75, ['info'] = ' Grove Street 7', ['apt'] = 0 },
	[80] =  { ['x'] = 117.81,['y'] = -1920.55,['z'] = 21.33,['h'] = 237.12, ['info'] = ' Grove Street 8', ['apt'] = 0 },
	[81] =  { ['x'] = 126.4,['y'] = -1929.47,['z'] = 21.39,['h'] = 208.24, ['info'] = ' Grove Street 9', ['apt'] = 0 },
	[82] =  { ['x'] = 114.05,['y'] = -1960.69,['z'] = 21.34,['h'] = 201.85, ['info'] = ' Grove Street 10', ['apt'] = 0 },
	[83] =  { ['x'] = 85.31,['y'] = -1959.0,['z'] = 21.13,['h'] = 231.11, ['info'] = ' Grove Street 11', ['apt'] = 0 },
	[84] =  { ['x'] = 76.92,['y'] = -1948.61,['z'] = 21.18,['h'] = 47.14, ['info'] = ' Grove Street 12', ['apt'] = 0 },
	[85] =  { ['x'] = 72.94,['y'] = -1938.5,['z'] = 21.17,['h'] = 134.56, ['info'] = ' Grove Street 13', ['apt'] = 0 },
	[86] =  { ['x'] = 57.03,['y'] = -1922.37,['z'] = 21.92,['h'] = 138.82, ['info'] = ' Grove Street 14', ['apt'] = 0 },
	[87] =  { ['x'] = 39.59,['y'] = -1911.99,['z'] = 21.96,['h'] = 48.9, ['info'] = ' Grove Street 15', ['apt'] = 0 },
	[88] =  { ['x'] = 23.75,['y'] = -1895.77,['z'] = 22.78,['h'] = 138.51, ['info'] = ' Grove Street 16', ['apt'] = 0 },
	[89] =  { ['x'] = 4.58,['y'] = -1883.77,['z'] = 23.7,['h'] = 230.16, ['info'] = ' Grove Street 17', ['apt'] = 0 },
	[90] =  { ['x'] = -5.8,['y'] = -1871.52,['z'] = 24.16,['h'] = 231.79, ['info'] = ' Grove Street 18', ['apt'] = 0 },
	[91] =  { ['x'] = -21.18,['y'] = -1858.15,['z'] = 25.4,['h'] = 231.24, ['info'] = ' Grove Street 19', ['apt'] = 0 },
	[92] =  { ['x'] = -33.71,['y'] = -1847.46,['z'] = 26.2,['h'] = 50.24, ['info'] = ' Grove Street 20', ['apt'] = 0 },
	[93] =  { ['x'] = -157.6,['y'] = -1680.11,['z'] = 33.44,['h'] = 48.52, ['info'] = ' Forum Drive 1/Apt1', ['apt'] = 1 },
	[94] =  { ['x'] = -148.39,['y'] = -1688.04,['z'] = 32.88,['h'] = 318.72, ['info'] = ' Forum Drive 1/Apt2', ['apt'] = 1 },
	[95] =  { ['x'] = -147.3,['y'] = -1688.99,['z'] = 32.88,['h'] = 318.81, ['info'] = ' Forum Drive 1/Apt3', ['apt'] = 1 },
	[96] =  { ['x'] = -143.08,['y'] = -1692.38,['z'] = 32.88,['h'] = 277.39, ['info'] = ' Forum Drive 1/Apt4', ['apt'] = 1 },
	[97] =  { ['x'] = -141.89,['y'] = -1693.43,['z'] = 32.88,['h'] = 225.74, ['info'] = ' Forum Drive 1/Apt5', ['apt'] = 1 },
	[98] =  { ['x'] = -141.79,['y'] = -1693.55,['z'] = 36.17,['h'] = 229.58, ['info'] = ' Forum Drive 1/Apt6', ['apt'] = 1 },
	[99] =  { ['x'] = -142.19,['y'] = -1692.69,['z'] = 36.17,['h'] = 321.38, ['info'] = ' Forum Drive 1/Apt7', ['apt'] = 1 },
	[100] =  { ['x'] = -147.39,['y'] = -1688.39,['z'] = 36.17,['h'] = 318.94, ['info'] = ' Forum Drive 1/Apt8', ['apt'] = 1 },
	[101] =  { ['x'] = -148.69,['y'] = -1687.35,['z'] = 36.17,['h'] = 313.56, ['info'] = ' Forum Drive 1/Apt9', ['apt'] = 1 },
	[102] =  { ['x'] = -157.54,['y'] = -1679.61,['z'] = 36.97,['h'] = 354.25, ['info'] = ' Forum Drive 1/Apt10', ['apt'] = 1 },
	[103] =  { ['x'] = -158.86,['y'] = -1680.02,['z'] = 36.97,['h'] = 38.57, ['info'] = ' Forum Drive 1/Apt11', ['apt'] = 1 },
	[104] =  { ['x'] = -160.83,['y'] = -1637.93,['z'] = 34.03,['h'] = 157.6, ['info'] = ' Forum Drive 2/Apt1', ['apt'] = 1 },
	[105] =  { ['x'] = -160.0,['y'] = -1636.41,['z'] = 34.03,['h'] = 324.29, ['info'] = ' Forum Drive 2/Apt2', ['apt'] = 1 },
	[106] =  { ['x'] = -153.87,['y'] = -1641.77,['z'] = 36.86,['h'] = 331.14, ['info'] = ' Forum Drive 2/Apt3', ['apt'] = 1 },
	[107] =  { ['x'] = -159.85,['y'] = -1636.42,['z'] = 37.25,['h'] = 321.05, ['info'] = ' Forum Drive 2/Apt4', ['apt'] = 1 },
	[108] =  { ['x'] = -161.31,['y'] = -1638.13,['z'] = 37.25,['h'] = 142.21, ['info'] = ' Forum Drive 2/Apt5', ['apt'] = 1 },
	[109] =  { ['x'] = -150.79,['y'] = -1625.26,['z'] = 33.66,['h'] = 233.56, ['info'] = ' Forum Drive 2/Apt6', ['apt'] = 1 },
	[110] =  { ['x'] = -150.74,['y'] = -1622.68,['z'] = 33.66,['h'] = 57.73, ['info'] = ' Forum Drive 2/Apt7', ['apt'] = 1 },
	[111] =  { ['x'] = -145.59,['y'] = -1617.88,['z'] = 36.05,['h'] = 222.51, ['info'] = ' Forum Drive 2/Apt8', ['apt'] = 1 },
	[112] =  { ['x'] = -145.84,['y'] = -1614.71,['z'] = 36.05,['h'] = 67.64, ['info'] = ' Forum Drive 2/Apt9', ['apt'] = 1 },
	[113] =  { ['x'] = -152.23,['y'] = -1624.37,['z'] = 36.85,['h'] = 52.69, ['info'] = ' Forum Drive 2/Apt10', ['apt'] = 1 },
	[114] =  { ['x'] = -150.38,['y'] = -1625.5,['z'] = 36.85,['h'] = 233.14, ['info'] = ' Forum Drive 2/Apt11', ['apt'] = 1 },
	[115] =  { ['x'] = -120.58,['y'] = -1575.04,['z'] = 34.18,['h'] = 323.0, ['info'] = ' Forum Drive 3/Apt1', ['apt'] = 1 },
	[116] =  { ['x'] = -114.73,['y'] = -1579.95,['z'] = 34.18,['h'] = 318.74, ['info'] = ' Forum Drive 3/Apt2', ['apt'] = 1 },
	[117] =  { ['x'] = -119.6,['y'] = -1585.41,['z'] = 34.22,['h'] = 231.94, ['info'] = ' Forum Drive 3/Apt3', ['apt'] = 1 },
	[118] =  { ['x'] = -123.81,['y'] = -1590.67,['z'] = 34.21,['h'] = 234.7, ['info'] = ' Forum Drive 3/Apt4', ['apt'] = 1 },
	[119] =  { ['x'] = -139.85,['y'] = -1598.7,['z'] = 34.84,['h'] = 158.58, ['info'] = ' Forum Drive 3/Apt6', ['apt'] = 1 },
	[120] =  { ['x'] = -146.85,['y'] = -1596.64,['z'] = 34.84,['h'] = 69.8, ['info'] = ' Forum Drive 3/Apt7', ['apt'] = 1 },
	[121] =  { ['x'] = -139.49,['y'] = -1588.39,['z'] = 34.25,['h'] = 47.69, ['info'] = ' Forum Drive 3/Apt8', ['apt'] = 1 },
	[122] =  { ['x'] = -133.47,['y'] = -1581.2,['z'] = 34.21,['h'] = 49.62, ['info'] = ' Forum Drive 3/Apt9', ['apt'] = 1 },
	[123] =  { ['x'] = -120.63,['y'] = -1575.05,['z'] = 37.41,['h'] = 320.29, ['info'] = ' Forum Drive 3/Apt10', ['apt'] = 1 },
	[124] =  { ['x'] = -114.71,['y'] = -1580.4,['z'] = 37.41,['h'] = 322.64, ['info'] = ' Forum Drive 3/Apt11', ['apt'] = 1 },
	[125] =  { ['x'] = -119.53,['y'] = -1585.26,['z'] = 37.41,['h'] = 228.33, ['info'] = ' Forum Drive 3/Apt12', ['apt'] = 1 },
	[126] =  { ['x'] = -123.67,['y'] = -1590.39,['z'] = 37.41,['h'] = 223.58, ['info'] = ' Forum Drive 3/Apt13', ['apt'] = 1 },
	[127] =  { ['x'] = -140.08,['y'] = -1598.75,['z'] = 38.22,['h'] = 157.57, ['info'] = ' Forum Drive 3/Apt15', ['apt'] = 1 },
	[128] =  { ['x'] = -145.81,['y'] = -1597.55,['z'] = 38.22,['h'] = 99.24, ['info'] = ' Forum Drive 3/Apt16', ['apt'] = 1 },
	[129] =  { ['x'] = -147.47,['y'] = -1596.26,['z'] = 38.22,['h'] = 55.87, ['info'] = ' Forum Drive 3/Apt17', ['apt'] = 1 },
	[130] =  { ['x'] = -139.77,['y'] = -1587.8,['z'] = 37.41,['h'] = 50.77, ['info'] = ' Forum Drive 3/Apt18', ['apt'] = 1 },
	[131] =  { ['x'] = -133.78,['y'] = -1580.56,['z'] = 37.41,['h'] = 54.61, ['info'] = ' Forum Drive 3/Apt19', ['apt'] = 1 },
	[132] =  { ['x'] = 16.5,['y'] = -1443.77,['z'] = 30.95,['h'] = 336.17, ['info'] = ' Forum Drive 4', ['apt'] = 0 },
	[133] =  { ['x'] = -1.98,['y'] = -1442.55,['z'] = 30.97,['h'] = 1.65, ['info'] = ' Forum Drive 5', ['apt'] = 0 },
	[134] =  { ['x'] = -32.87,['y'] = -1446.34,['z'] = 31.9,['h'] = 269.71, ['info'] = ' Forum Drive 7', ['apt'] = 0 },
	[135] =  { ['x'] = -45.73,['y'] = -1445.58,['z'] = 32.43,['h'] = 274.72, ['info'] = ' Forum Drive 8', ['apt'] = 0 },
	[136] =  { ['x'] = -64.48,['y'] = -1449.57,['z'] = 32.53,['h'] = 99.6, ['info'] = ' Forum Drive 9', ['apt'] = 0 },
	[137] =  { ['x'] = -167.71,['y'] = -1534.71,['z'] = 35.1,['h'] = 320.29, ['info'] = ' Forum Drive 10/Apt1', ['apt'] = 1 },
	[138] =  { ['x'] = -180.71,['y'] = -1553.51,['z'] = 35.13,['h'] = 227.11, ['info'] = ' Forum Drive 10/Apt2', ['apt'] = 1 },
	[139] =  { ['x'] = -187.47,['y'] = -1562.96,['z'] = 35.76,['h'] = 220.56, ['info'] = ' Forum Drive 10/Apt3', ['apt'] = 1 },
	[140] =  { ['x'] = -191.86,['y'] = -1559.4,['z'] = 34.96,['h'] = 124.57, ['info'] = ' Forum Drive 10/Apt4', ['apt'] = 1 },
	[141] =  { ['x'] = -195.55,['y'] = -1556.06,['z'] = 34.96,['h'] = 45.83, ['info'] = ' Forum Drive 10/Apt5', ['apt'] = 1 },
	[142] =  { ['x'] = -183.81,['y'] = -1540.59,['z'] = 34.36,['h'] = 41.2, ['info'] = ' Forum Drive 10/Apt6', ['apt'] = 1 },
	[143] =  { ['x'] = -179.69,['y'] = -1534.66,['z'] = 34.36,['h'] = 44.71, ['info'] = ' Forum Drive 10/Apt7', ['apt'] = 1 },
	[144] =  { ['x'] = -175.06,['y'] = -1529.53,['z'] = 34.36,['h'] = 321.99, ['info'] = ' Forum Drive 10/Apt8', ['apt'] = 1 },
	[145] =  { ['x'] = -167.62,['y'] = -1534.9,['z'] = 38.33,['h'] = 320.46, ['info'] = ' Forum Drive 10/Apt10', ['apt'] = 1 },
	[146] =  { ['x'] = -180.19,['y'] = -1553.89,['z'] = 38.34,['h'] = 232.72, ['info'] = ' Forum Drive 10/Apt11', ['apt'] = 1 },
	[147] =  { ['x'] = -186.63,['y'] = -1562.32,['z'] = 39.14,['h'] = 198.53, ['info'] = ' Forum Drive 10/Apt12', ['apt'] = 1 },
	[148] =  { ['x'] = -188.32,['y'] = -1562.5,['z'] = 39.14,['h'] = 136.16, ['info'] = ' Forum Drive 10/Apt13', ['apt'] = 1 },
	[149] =  { ['x'] = -192.14,['y'] = -1559.64,['z'] = 38.34,['h'] = 136.93, ['info'] = ' Forum Drive 10/Apt14', ['apt'] = 1 },
	[150] =  { ['x'] = -195.77,['y'] = -1555.92,['z'] = 38.34,['h'] = 48.33, ['info'] = ' Forum Drive 10/Apt15', ['apt'] = 1 },
	[151] =  { ['x'] = -184.06,['y'] = -1539.83,['z'] = 37.54,['h'] = 47.47, ['info'] = ' Forum Drive 10/Apt16', ['apt'] = 1 },
	[152] =  { ['x'] = -179.58,['y'] = -1534.93,['z'] = 37.54,['h'] = 48.0, ['info'] = ' Forum Drive 10/Apt17', ['apt'] = 1 },
	[153] =  { ['x'] = -174.87,['y'] = -1529.18,['z'] = 37.54,['h'] = 321.05, ['info'] = ' Forum Drive 10/Apt18', ['apt'] = 1 },
	[154] =  { ['x'] = -208.75,['y'] = -1600.32,['z'] = 34.87,['h'] = 259.54, ['info'] = ' Forum Drive 11/Apt1', ['apt'] = 1 },
	[155] =  { ['x'] = -210.05,['y'] = -1607.17,['z'] = 34.87,['h'] = 259.85, ['info'] = ' Forum Drive 11/Apt2', ['apt'] = 1 },
	[156] =  { ['x'] = -212.05,['y'] = -1616.86,['z'] = 34.87,['h'] = 244.26, ['info'] = ' Forum Drive 11/Apt3', ['apt'] = 1 },
	[157] =  { ['x'] = -213.8,['y'] = -1618.07,['z'] = 34.87,['h'] = 180.98, ['info'] = ' Forum Drive 11/Apt4', ['apt'] = 1 },
	[158] =  { ['x'] = -221.82,['y'] = -1617.45,['z'] = 34.87,['h'] = 88.95, ['info'] = ' Forum Drive 11/Apt5', ['apt'] = 1 },
	[159] =  { ['x'] = -223.06,['y'] = -1601.38,['z'] = 34.89,['h'] = 97.48, ['info'] = ' Forum Drive 11/Apt6', ['apt'] = 1 },
	[160] =  { ['x'] = -222.52,['y'] = -1585.71,['z'] = 34.87,['h'] = 84.43, ['info'] = ' Forum Drive 11/Apt7', ['apt'] = 1 },
	[161] =  { ['x'] = -218.91,['y'] = -1580.06,['z'] = 34.87,['h'] = 47.27, ['info'] = ' Forum Drive 11/Apt8', ['apt'] = 1 },
	[162] =  { ['x'] = -216.48,['y'] = -1577.45,['z'] = 34.87,['h'] = 321.55, ['info'] = ' Forum Drive 11/Apt9', ['apt'] = 1 },
	[163] =  { ['x'] = -206.23,['y'] = -1585.55,['z'] = 34.87,['h'] = 260.2, ['info'] = ' Forum Drive 11/Apt10', ['apt'] = 1 },
	[164] =  { ['x'] = -206.63,['y'] = -1585.8,['z'] = 38.06,['h'] = 275.39, ['info'] = ' Forum Drive 11/Apt12', ['apt'] = 1 },
	[165] =  { ['x'] = -216.05,['y'] = -1576.86,['z'] = 38.06,['h'] = 319.06, ['info'] = ' Forum Drive 11/Apt13', ['apt'] = 1 },
	[166] =  { ['x'] = -218.37,['y'] = -1579.89,['z'] = 38.06,['h'] = 67.83, ['info'] = ' Forum Drive 11/Apt14', ['apt'] = 1 },
	[167] =  { ['x'] = -222.25,['y'] = -1585.37,['z'] = 38.06,['h'] = 96.11, ['info'] = ' Forum Drive 11/Apt15', ['apt'] = 1 },
	[168] =  { ['x'] = -222.26,['y'] = -1600.93,['z'] = 38.06,['h'] = 90.9, ['info'] = ' Forum Drive 11/Apt16', ['apt'] = 1 },
	[169] =  { ['x'] = -222.21,['y'] = -1617.39,['z'] = 38.06,['h'] = 93.88, ['info'] = ' Forum Drive 11/Apt17', ['apt'] = 1 },
	[170] =  { ['x'] = -214.12,['y'] = -1617.62,['z'] = 38.06,['h'] = 218.57, ['info'] = ' Forum Drive 11/Apt18', ['apt'] = 1 },
	[171] =  { ['x'] = -212.29,['y'] = -1617.34,['z'] = 38.06,['h'] = 253.87, ['info'] = ' Forum Drive 11/Apt19', ['apt'] = 1 },
	[172] =  { ['x'] = -210.46,['y'] = -1607.36,['z'] = 38.05,['h'] = 263.82, ['info'] = ' Forum Drive 11/Apt20', ['apt'] = 1 },
	[173] =  { ['x'] = -209.45,['y'] = -1600.57,['z'] = 38.05,['h'] = 269.99, ['info'] = ' Forum Drive 11/Apt21', ['apt'] = 1 },
	[174] =  { ['x'] = -216.64,['y'] = -1673.73,['z'] = 34.47,['h'] = 179.38, ['info'] = ' Forum Drive 12/Apt1', ['apt'] = 1 },
	[175] =  { ['x'] = -224.15,['y'] = -1673.67,['z'] = 34.47,['h'] = 169.52, ['info'] = ' Forum Drive 12/Apt2', ['apt'] = 1 },
	[176] =  { ['x'] = -224.17,['y'] = -1666.14,['z'] = 34.47,['h'] = 82.29, ['info'] = ' Forum Drive 12/Apt3', ['apt'] = 1 },
	[177] =  { ['x'] = -224.32,['y'] = -1649.0,['z'] = 34.86,['h'] = 85.83, ['info'] = ' Forum Drive 12/Apt4', ['apt'] = 1 },
	[178] =  { ['x'] = -216.34,['y'] = -1648.94,['z'] = 34.47,['h'] = 356.29, ['info'] = ' Forum Drive 12/Apt5', ['apt'] = 1 },
	[179] =  { ['x'] = -212.92,['y'] = -1660.54,['z'] = 34.47,['h'] = 256.79, ['info'] = ' Forum Drive 12/Apt6', ['apt'] = 1 },
	[180] =  { ['x'] = -212.95,['y'] = -1667.96,['z'] = 34.47,['h'] = 264.8, ['info'] = ' Forum Drive 12/Apt7', ['apt'] = 1 },
	[181] =  { ['x'] = -216.55,['y'] = -1673.88,['z'] = 37.64,['h'] = 175.17, ['info'] = ' Forum Drive 12/Apt8', ['apt'] = 1 },
	[182] =  { ['x'] = -224.34,['y'] = -1673.79,['z'] = 37.64,['h'] = 175.13, ['info'] = ' Forum Drive 12/Apt9', ['apt'] = 1 },
	[183] =  { ['x'] = -223.99,['y'] = -1666.29,['z'] = 37.64,['h'] = 86.27, ['info'] = ' Forum Drive 12/Apt10', ['apt'] = 1 },
	[184] =  { ['x'] = -224.44,['y'] = -1653.99,['z'] = 37.64,['h'] = 87.81, ['info'] = ' Forum Drive 12/Apt11', ['apt'] = 1 },
	[185] =  { ['x'] = -223.96,['y'] = -1649.16,['z'] = 38.45,['h'] = 353.99, ['info'] = ' Forum Drive 12/Apt12', ['apt'] = 1 },
	[186] =  { ['x'] = -216.44,['y'] = -1649.13,['z'] = 37.64,['h'] = 352.36, ['info'] = ' Forum Drive 12/Apt13', ['apt'] = 1 },
	[187] =  { ['x'] = -212.85,['y'] = -1660.74,['z'] = 37.64,['h'] = 269.04, ['info'] = ' Forum Drive 12/Apt14', ['apt'] = 1 },
	[188] =  { ['x'] = -212.72,['y'] = -1668.23,['z'] = 37.64,['h'] = 272.59, ['info'] = ' Forum Drive 12/Apt15', ['apt'] = 1 },
	[189] =  { ['x'] = 207.81,['y'] = -1894.66,['z'] = 24.82,['h'] = 226.76, ['info'] = ' Covenant Avenue 1', ['apt'] = 0 },
	[190] =  { ['x'] = 192.27,['y'] = -1884.01,['z'] = 24.86,['h'] = 333.42, ['info'] = ' Covenant Avenue 2', ['apt'] = 0 },
	[191] =  { ['x'] = 170.9,['y'] = -1871.29,['z'] = 24.41,['h'] = 238.08, ['info'] = ' Covenant Avenue 3', ['apt'] = 0 },
	[192] =  { ['x'] = 149.69,['y'] = -1865.39,['z'] = 24.6,['h'] = 339.99, ['info'] = ' Covenant Avenue 4', ['apt'] = 0 },
	[193] =  { ['x'] = 130.2,['y'] = -1854.03,['z'] = 25.06,['h'] = 331.31, ['info'] = ' Covenant Avenue 5', ['apt'] = 0 },
	[194] =  { ['x'] = 104.32,['y'] = -1884.78,['z'] = 24.32,['h'] = 143.76, ['info'] = ' Covenant Avenue 6', ['apt'] = 0 },
	[195] =  { ['x'] = 114.95,['y'] = -1887.7,['z'] = 23.93,['h'] = 241.36, ['info'] = ' Covenant Avenue 7', ['apt'] = 0 },
	[196] =  { ['x'] = 127.69,['y'] = -1896.79,['z'] = 23.68,['h'] = 248.34, ['info'] = ' Covenant Avenue 8', ['apt'] = 0 },
	[197] =  { ['x'] = 148.81,['y'] = -1904.41,['z'] = 23.54,['h'] = 155.7, ['info'] = ' Covenant Avenue 9', ['apt'] = 0 },
	[198] =  { ['x'] = -1071.77,['y'] = -1566.08,['z'] = 4.39,['h'] = 99.92, ['info'] = ' Beachside Court 13', ['apt'] = 0 },
	[199] =  { ['x'] = -1073.94,['y'] = -1562.36,['z'] = 4.46,['h'] = 300.25, ['info'] = ' Beachside Court 14', ['apt'] = 0 },
	[200] =  { ['x'] = -1066.23,['y'] = -1545.34,['z'] = 4.91,['h'] = 208.82, ['info'] = ' Beachside Court 15', ['apt'] = 0 },
	[201] =  { ['x'] = -113.52,['y'] = -1478.46,['z'] = 33.83,['h'] = 226.49, ['info'] = ' Carson Avenue 1/Apt1', ['apt'] = 1 },
	[202] =  { ['x'] = -108.04,['y'] = -1473.11,['z'] = 33.83,['h'] = 225.6, ['info'] = ' Carson Avenue 1/Apt2', ['apt'] = 1 },
	[203] =  { ['x'] = -113.89,['y'] = -1468.64,['z'] = 33.83,['h'] = 321.96, ['info'] = ' Carson Avenue 1/Apt3', ['apt'] = 1 },
	[204] =  { ['x'] = -123.05,['y'] = -1460.05,['z'] = 33.83,['h'] = 317.58, ['info'] = ' Carson Avenue 1/Apt4', ['apt'] = 1 },
	[205] =  { ['x'] = -126.68,['y'] = -1456.71,['z'] = 34.57,['h'] = 320.2, ['info'] = ' Carson Avenue 1/Apt5', ['apt'] = 1 },
	[206] =  { ['x'] = -131.8,['y'] = -1463.15,['z'] = 33.83,['h'] = 49.07, ['info'] = ' Carson Avenue 1/Apt6', ['apt'] = 1 },
	[207] =  { ['x'] = -125.47,['y'] = -1473.1,['z'] = 33.83,['h'] = 142.11, ['info'] = ' Carson Avenue 1/Apt7', ['apt'] = 1 },
	[208] =  { ['x'] = -119.61,['y'] = -1478.11,['z'] = 33.83,['h'] = 135.81, ['info'] = ' Carson Avenue 1/Apt8', ['apt'] = 1 },
	[209] =  { ['x'] = -122.98,['y'] = -1460.25,['z'] = 37.0,['h'] = 320.71, ['info'] = ' Carson Avenue 1/Apt9', ['apt'] = 1 },
	[210] =  { ['x'] = -127.02,['y'] = -1457.18,['z'] = 37.8,['h'] = 52.77, ['info'] = ' Carson Avenue 1/Apt10', ['apt'] = 1 },
	[211] =  { ['x'] = -131.92,['y'] = -1463.16,['z'] = 37.0,['h'] = 49.86, ['info'] = ' Carson Avenue 1/Apt11', ['apt'] = 1 },
	[212] =  { ['x'] = -138.15,['y'] = -1470.49,['z'] = 37.0,['h'] = 139.34, ['info'] = ' Carson Avenue 1/Apt12', ['apt'] = 1 },
	[213] =  { ['x'] = -125.48,['y'] = -1473.39,['z'] = 37.0,['h'] = 144.5, ['info'] = ' Carson Avenue 1/Apt13', ['apt'] = 1 },
	[214] =  { ['x'] = -119.87,['y'] = -1477.81,['z'] = 37.0,['h'] = 143.58, ['info'] = ' Carson Avenue 1/Apt14', ['apt'] = 1 },
	[215] =  { ['x'] = -77.1,['y'] = -1515.61,['z'] = 34.25,['h'] = 44.81, ['info'] = ' Carson Avenue 2/Apt1', ['apt'] = 1 },
	[216] =  { ['x'] = -71.74,['y'] = -1508.33,['z'] = 33.44,['h'] = 40.4, ['info'] = ' Carson Avenue 2/Apt2', ['apt'] = 1 },
	[217] =  { ['x'] = -65.73,['y'] = -1513.55,['z'] = 33.44,['h'] = 318.02, ['info'] = ' Carson Avenue 2/Apt3', ['apt'] = 1 },
	[218] =  { ['x'] = -60.39,['y'] = -1517.48,['z'] = 33.44,['h'] = 319.04, ['info'] = ' Carson Avenue 2/Apt4', ['apt'] = 1 },
	[219] =  { ['x'] = -54.1,['y'] = -1523.19,['z'] = 33.44,['h'] = 235.48, ['info'] = ' Carson Avenue 2/Apt5', ['apt'] = 1 },
	[220] =  { ['x'] = -59.84,['y'] = -1530.35,['z'] = 34.24,['h'] = 231.22, ['info'] = ' Carson Avenue 2/Apt6', ['apt'] = 1 },
	[221] =  { ['x'] = -62.18,['y'] = -1532.27,['z'] = 34.24,['h'] = 136.83, ['info'] = ' Carson Avenue 2/Apt7', ['apt'] = 1 },
	[222] =  { ['x'] = -68.86,['y'] = -1526.34,['z'] = 34.24,['h'] = 132.44, ['info'] = ' Carson Avenue 2/Apt8', ['apt'] = 1 },
	[223] =  { ['x'] = -77.3,['y'] = -1515.62,['z'] = 37.42,['h'] = 48.47, ['info'] = ' Carson Avenue 2/Apt9', ['apt'] = 1 },
	[224] =  { ['x'] = -71.37,['y'] = -1508.76,['z'] = 36.63,['h'] = 42.69, ['info'] = ' Carson Avenue 2/Apt10', ['apt'] = 1 },
	[225] =  { ['x'] = -65.85,['y'] = -1513.39,['z'] = 36.63,['h'] = 319.16, ['info'] = ' Carson Avenue 2/Apt11', ['apt'] = 1 },
	[226] =  { ['x'] = -61.03,['y'] = -1517.82,['z'] = 36.63,['h'] = 316.66, ['info'] = ' Carson Avenue 2/Apt12', ['apt'] = 1 },
	[227] =  { ['x'] = -54.23,['y'] = -1523.33,['z'] = 36.63,['h'] = 229.97, ['info'] = ' Carson Avenue 2/Apt13', ['apt'] = 1 },
	[228] =  { ['x'] = -60.03,['y'] = -1530.35,['z'] = 37.42,['h'] = 226.15, ['info'] = ' Carson Avenue 2/Apt14', ['apt'] = 1 },
	[229] =  { ['x'] = -61.53,['y'] = -1532.14,['z'] = 37.42,['h'] = 136.13, ['info'] = ' Carson Avenue 2/Apt15', ['apt'] = 1 },
	[230] =  { ['x'] = -68.59,['y'] = -1526.2,['z'] = 37.42,['h'] = 137.9, ['info'] = ' Carson Avenue 2/Apt16', ['apt'] = 1 },
	[231] =  { ['x'] = -35.11,['y'] = -1554.6,['z'] = 30.68,['h'] = 129.72, ['info'] = ' Strawberry Avenue 1/Apt1', ['apt'] = 1 },
	[232] =  { ['x'] = -44.33,['y'] = -1547.29,['z'] = 31.27,['h'] = 51.34, ['info'] = ' Strawberry Avenue 1/Apt2', ['apt'] = 1 },
	[233] =  { ['x'] = -36.07,['y'] = -1537.29,['z'] = 31.25,['h'] = 47.34, ['info'] = ' Strawberry Avenue 1/Apt3', ['apt'] = 1 },
	[234] =  { ['x'] = -26.48,['y'] = -1544.33,['z'] = 30.68,['h'] = 310.44, ['info'] = ' Strawberry Avenue 1/Apt4', ['apt'] = 1 },
	[235] =  { ['x'] = -20.54,['y'] = -1550.16,['z'] = 30.68,['h'] = 230.04, ['info'] = ' Strawberry Avenue 1/Apt5', ['apt'] = 1 },
	[236] =  { ['x'] = -25.49,['y'] = -1556.28,['z'] = 30.69,['h'] = 224.38, ['info'] = ' Strawberry Avenue 1/Apt6', ['apt'] = 1 },
	[237] =  { ['x'] = -34.37,['y'] = -1566.55,['z'] = 33.03,['h'] = 227.02, ['info'] = ' Strawberry Avenue 1/Apt7', ['apt'] = 1 },
	[238] =  { ['x'] = -35.36,['y'] = -1555.08,['z'] = 33.83,['h'] = 138.59, ['info'] = ' Strawberry Avenue 1/Apt8', ['apt'] = 1 },
	[239] =  { ['x'] = -43.9,['y'] = -1547.83,['z'] = 34.63,['h'] = 50.27, ['info'] = ' Strawberry Avenue 1/Apt9', ['apt'] = 1 },
	[240] =  { ['x'] = -28.52,['y'] = -1560.41,['z'] = 33.83,['h'] = 234.04, ['info'] = ' Strawberry Avenue 1/Apt14', ['apt'] = 1 },
	[241] =  { ['x'] = -14.63,['y'] = -1543.73,['z'] = 33.03,['h'] = 222.98, ['info'] = ' Strawberry Avenue 1/Apt12', ['apt'] = 1 },
	[242] =  { ['x'] = -20.69,['y'] = -1550.0,['z'] = 33.83,['h'] = 225.08, ['info'] = ' Strawberry Avenue 1/Apt13', ['apt'] = 1 },
	[243] =  { ['x'] = -26.96,['y'] = -1544.93,['z'] = 33.83,['h'] = 320.18, ['info'] = ' Strawberry Avenue 1/Apt11', ['apt'] = 1 },
	[244] =  { ['x'] = -35.82,['y'] = -1537.25,['z'] = 34.63,['h'] = 48.69, ['info'] = ' Strawberry Avenue 1/Apt10', ['apt'] = 1 },
	[245] =  { ['x'] = -84.12,['y'] = -1622.47,['z'] = 31.48,['h'] = 230.69, ['info'] = ' Strawberry Avenue 2/Apt1', ['apt'] = 1 },
	[246] =  { ['x'] = -90.44,['y'] = -1629.08,['z'] = 31.51,['h'] = 226.67, ['info'] = ' Strawberry Avenue 2/Apt2', ['apt'] = 1 },
	[247] =  { ['x'] = -97.46,['y'] = -1638.56,['z'] = 32.11,['h'] = 225.22, ['info'] = ' Strawberry Avenue 2/Apt3', ['apt'] = 1 },
	[248] =  { ['x'] = -105.34,['y'] = -1632.48,['z'] = 32.91,['h'] = 137.22, ['info'] = ' Strawberry Avenue 2/Apt4', ['apt'] = 1 },
	[249] =  { ['x'] = -108.73,['y'] = -1629.04,['z'] = 32.91,['h'] = 45.99, ['info'] = ' Strawberry Avenue 2/Apt5', ['apt'] = 1 },
	[250] =  { ['x'] = -96.87,['y'] = -1613.02,['z'] = 32.32,['h'] = 52.37, ['info'] = ' Strawberry Avenue 2/Apt6', ['apt'] = 1 },
	[251] =  { ['x'] = -92.45,['y'] = -1608.14,['z'] = 32.32,['h'] = 47.32, ['info'] = ' Strawberry Avenue 2/Apt7', ['apt'] = 1 },
	[252] =  { ['x'] = -88.5,['y'] = -1602.39,['z'] = 32.32,['h'] = 323.29, ['info'] = ' Strawberry Avenue 2/Apt8', ['apt'] = 1 },
	[253] =  { ['x'] = -81.05,['y'] = -1608.75,['z'] = 31.49,['h'] = 322.94, ['info'] = ' Strawberry Avenue 2/Apt9', ['apt'] = 1 },
	[254] =  { ['x'] = -84.11,['y'] = -1622.43,['z'] = 34.69,['h'] = 229.53, ['info'] = ' Strawberry Avenue 2/Apt10', ['apt'] = 1 },
	[255] =  { ['x'] = -90.11,['y'] = -1629.4,['z'] = 34.69,['h'] = 227.58, ['info'] = ' Strawberry Avenue 2/Apt11', ['apt'] = 1 },
	[256] =  { ['x'] = -96.25,['y'] = -1637.41,['z'] = 35.49,['h'] = 164.78, ['info'] = ' Strawberry Avenue 2/Apt12', ['apt'] = 1 },
	[257] =  { ['x'] = -98.24,['y'] = -1638.72,['z'] = 35.49,['h'] = 139.02, ['info'] = ' Strawberry Avenue 2/Apt13', ['apt'] = 1 },
	[258] =  { ['x'] = -104.94,['y'] = -1632.23,['z'] = 36.29,['h'] = 135.05, ['info'] = ' Strawberry Avenue 2/Apt14', ['apt'] = 1 },
	[259] =  { ['x'] = -108.73,['y'] = -1628.99,['z'] = 36.29,['h'] = 50.81, ['info'] = ' Strawberry Avenue 2/Apt15', ['apt'] = 1 },
	[260] =  { ['x'] = -97.08,['y'] = -1612.9,['z'] = 35.49,['h'] = 50.06, ['info'] = ' Strawberry Avenue 2/Apt16', ['apt'] = 1 },
	[261] =  { ['x'] = -92.88,['y'] = -1607.79,['z'] = 35.49,['h'] = 47.31, ['info'] = ' Strawberry Avenue 2/Apt17', ['apt'] = 1 },
	[262] =  { ['x'] = -88.13,['y'] = -1602.14,['z'] = 35.49,['h'] = 318.46, ['info'] = ' Strawberry Avenue 2/Apt18', ['apt'] = 1 },
	[263] =  { ['x'] = -80.67,['y'] = -1608.63,['z'] = 34.69,['h'] = 317.01, ['info'] = ' Strawberry Avenue 2/Apt19', ['apt'] = 1 },
	[264] =  { ['x'] = 252.35,['y'] = -1671.55,['z'] = 29.67,['h'] = 321.56, ['info'] = ' Brouge Avenue 1', ['apt'] = 0 },
	[265] =  { ['x'] = 241.38,['y'] = -1688.28,['z'] = 29.52,['h'] = 51.92, ['info'] = ' Brouge Avenue 2', ['apt'] = 0 },
	[266] =  { ['x'] = 223.35,['y'] = -1703.33,['z'] = 29.49,['h'] = 37.67, ['info'] = ' Brouge Avenue 3', ['apt'] = 0 },
	[267] =  { ['x'] = 216.83,['y'] = -1717.15,['z'] = 29.48,['h'] = 123.44, ['info'] = ' Brouge Avenue 4', ['apt'] = 0 },
	[268] =  { ['x'] = 198.59,['y'] = -1725.5,['z'] = 29.67,['h'] = 115.99, ['info'] = ' Brouge Avenue 5', ['apt'] = 0 },
	[269] =  { ['x'] = 152.28,['y'] = -1823.45,['z'] = 27.87,['h'] = 234.41, ['info'] = ' Brouge Avenue 6', ['apt'] = 0 },
	[270] =  { ['x'] = 249.48,['y'] = -1730.38,['z'] = 29.67,['h'] = 229.2, ['info'] = ' Brouge Avenue 7', ['apt'] = 0 },
	[271] =  { ['x'] = 257.05,['y'] = -1723.09,['z'] = 29.66,['h'] = 313.23, ['info'] = ' Brouge Avenue 8', ['apt'] = 0 },
	[272] =  { ['x'] = 269.23,['y'] = -1713.34,['z'] = 29.67,['h'] = 318.18, ['info'] = ' Brouge Avenue 9', ['apt'] = 0 },
	[273] =  { ['x'] = 281.13,['y'] = -1694.16,['z'] = 29.26,['h'] = 232.69, ['info'] = ' Brouge Avenue 10', ['apt'] = 0 },
	[274] =  { ['x'] = 332.58,['y'] = -1741.63,['z'] = 29.74,['h'] = 319.91, ['info'] = ' Roy Lowenstein Blvd 1', ['apt'] = 0 },
	[275] =  { ['x'] = 320.66,['y'] = -1759.78,['z'] = 29.64,['h'] = 60.41, ['info'] = ' Roy Lowenstein Blvd 2', ['apt'] = 0 },
	[276] =  { ['x'] = 305.15,['y'] = -1775.86,['z'] = 29.1,['h'] = 49.68, ['info'] = ' Roy Lowenstein Blvd 3', ['apt'] = 0 },
	[277] =  { ['x'] = 299.84,['y'] = -1784.04,['z'] = 28.44,['h'] = 324.93, ['info'] = ' Roy Lowenstein Blvd 4', ['apt'] = 0 },
	[278] =  { ['x'] = 289.25,['y'] = -1791.99,['z'] = 28.09,['h'] = 141.95, ['info'] = ' Roy Lowenstein Blvd 5', ['apt'] = 0 },
	[279] =  { ['x'] = 179.23,['y'] = -1923.86,['z'] = 21.38,['h'] = 322.58, ['info'] = ' Roy Lowenstein Blvd 6', ['apt'] = 0 },
	[280] =  { ['x'] = 165.55,['y'] = -1945.18,['z'] = 20.24,['h'] = 48.7, ['info'] = ' Roy Lowenstein Blvd 7', ['apt'] = 0 },
	[281] =  { ['x'] = 149.99,['y'] = -1961.59,['z'] = 19.08,['h'] = 43.72, ['info'] = ' Roy Lowenstein Blvd 8', ['apt'] = 0 },
	[282] =  { ['x'] = 144.14,['y'] = -1969.72,['z'] = 18.86,['h'] = 332.82, ['info'] = ' Roy Lowenstein Blvd 9', ['apt'] = 0 },
	[283] =  { ['x'] = 140.98,['y'] = -1983.14,['z'] = 18.33,['h'] = 57.43, ['info'] = ' Roy Lowenstein Blvd 10', ['apt'] = 0 },
	[284] =  { ['x'] = 250.07,['y'] = -1934.4,['z'] = 24.51,['h'] = 231.59, ['info'] = ' Roy Lowenstein Blvd 11', ['apt'] = 0 },
	[285] =  { ['x'] = 257.39,['y'] = -1927.69,['z'] = 25.45,['h'] = 312.69, ['info'] = ' Roy Lowenstein Blvd 12', ['apt'] = 0 },
	[286] =  { ['x'] = 269.71,['y'] = -1917.57,['z'] = 26.19,['h'] = 317.5, ['info'] = ' Roy Lowenstein Blvd 13', ['apt'] = 0 },
	[287] =  { ['x'] = 281.88,['y'] = -1898.45,['z'] = 26.88,['h'] = 230.17, ['info'] = ' Roy Lowenstein Blvd 14', ['apt'] = 0 },
	[288] =  { ['x'] = 319.74,['y'] = -1853.49,['z'] = 27.53,['h'] = 227.79, ['info'] = ' Roy Lowenstein Blvd 15', ['apt'] = 0 },
	[289] =  { ['x'] = 328.0,['y'] = -1844.52,['z'] = 27.76,['h'] = 225.99, ['info'] = ' Roy Lowenstein Blvd 16', ['apt'] = 0 },
	[290] =  { ['x'] = 339.22,['y'] = -1829.24,['z'] = 28.34,['h'] = 136.63, ['info'] = ' Roy Lowenstein Blvd 17', ['apt'] = 0 },
	[291] =  { ['x'] = 348.85,['y'] = -1820.62,['z'] = 28.9,['h'] = 142.65, ['info'] = ' Roy Lowenstein Blvd 18', ['apt'] = 0 },
	[292] =  { ['x'] = 405.64,['y'] = -1751.29,['z'] = 29.72,['h'] = 324.51, ['info'] = ' Roy Lowenstein Blvd 19', ['apt'] = 0 },
	[293] =  { ['x'] = 418.53,['y'] = -1735.9,['z'] = 29.61,['h'] = 315.07, ['info'] = ' Roy Lowenstein Blvd 20', ['apt'] = 0 },
	[294] =  { ['x'] = 430.99,['y'] = -1725.5,['z'] = 29.61,['h'] = 310.19, ['info'] = ' Roy Lowenstein Blvd 21', ['apt'] = 0 },
	[295] =  { ['x'] = 442.72,['y'] = -1706.93,['z'] = 29.49,['h'] = 231.07, ['info'] = ' Roy Lowenstein Blvd 22', ['apt'] = 0 },
	[296] =  { ['x'] = 471.16,['y'] = -1561.47,['z'] = 32.8,['h'] = 50.68, ['info'] = ' Roy Lowenstein Blvd 23/Apt1', ['apt'] = 1 },
	[297] =  { ['x'] = 465.83,['y'] = -1567.54,['z'] = 32.8,['h'] = 54.01, ['info'] = ' Roy Lowenstein Blvd 23/Apt2', ['apt'] = 1 },
	[298] =  { ['x'] = 461.39,['y'] = -1573.95,['z'] = 32.8,['h'] = 49.46, ['info'] = ' Roy Lowenstein Blvd 23/Apt3', ['apt'] = 1 },
	[299] =  { ['x'] = 455.53,['y'] = -1579.34,['z'] = 32.8,['h'] = 141.19, ['info'] = ' Roy Lowenstein Blvd 23/Apt4', ['apt'] = 1 },
	[300] =  { ['x'] = 442.13,['y'] = -1569.43,['z'] = 32.8,['h'] = 134.84, ['info'] = ' Roy Lowenstein Blvd 23/Apt5', ['apt'] = 1 },
	[301] =  { ['x'] = 436.5,['y'] = -1563.9,['z'] = 32.8,['h'] = 136.21, ['info'] = ' Roy Lowenstein Blvd 23/Apt6', ['apt'] = 1 },
	[302] =  { ['x'] = 431.15,['y'] = -1558.66,['z'] = 32.8,['h'] = 136.11, ['info'] = ' Roy Lowenstein Blvd 23/Apt7', ['apt'] = 1 },
	[303] =  { ['x'] = 500.25,['y'] = -1697.49,['z'] = 29.79,['h'] = 322.98, ['info'] = ' Jamestown Street 1', ['apt'] = 0 },
	[304] =  { ['x'] = 490.6,['y'] = -1714.39,['z'] = 29.5,['h'] = 70.57, ['info'] = ' Jamestown Street 2', ['apt'] = 0 },
	[305] =  { ['x'] = 479.51,['y'] = -1736.71,['z'] = 29.16,['h'] = 344.06, ['info'] = ' Jamestown Street 3', ['apt'] = 0 },
	[306] =  { ['x'] = 475.44,['y'] = -1757.74,['z'] = 28.9,['h'] = 79.05, ['info'] = ' Jamestown Street 4', ['apt'] = 0 },
	[307] =  { ['x'] = 472.88,['y'] = -1775.22,['z'] = 29.07,['h'] = 86.89, ['info'] = ' Jamestown Street 5', ['apt'] = 0 },
	[308] =  { ['x'] = 440.01,['y'] = -1830.31,['z'] = 28.37,['h'] = 328.16, ['info'] = ' Jamestown Street 6', ['apt'] = 0 },
	[309] =  { ['x'] = 428.12,['y'] = -1841.33,['z'] = 28.47,['h'] = 135.91, ['info'] = ' Jamestown Street 7', ['apt'] = 0 },
	[310] =  { ['x'] = 412.58,['y'] = -1856.23,['z'] = 27.33,['h'] = 137.19, ['info'] = ' Jamestown Street 8', ['apt'] = 0 },
	[311] =  { ['x'] = 399.67,['y'] = -1864.78,['z'] = 26.72,['h'] = 132.43, ['info'] = ' Jamestown Street 9', ['apt'] = 0 },
	[312] =  { ['x'] = 386.04,['y'] = -1882.27,['z'] = 25.79,['h'] = 47.42, ['info'] = ' Jamestown Street 10', ['apt'] = 0 },
	[313] =  { ['x'] = 368.05,['y'] = -1896.76,['z'] = 25.18,['h'] = 317.81, ['info'] = ' Jamestown Street 11', ['apt'] = 0 },
	[314] =  { ['x'] = 324.15,['y'] = -1937.81,['z'] = 25.02,['h'] = 327.68, ['info'] = ' Jamestown Street 12', ['apt'] = 0 },
	[315] =  { ['x'] = 312.81,['y'] = -1956.66,['z'] = 24.43,['h'] = 44.18, ['info'] = ' Jamestown Street 13', ['apt'] = 0 },
	[316] =  { ['x'] = 296.54,['y'] = -1972.44,['z'] = 22.7,['h'] = 43.25, ['info'] = ' Jamestown Street 14', ['apt'] = 0 },
	[317] =  { ['x'] = 291.23,['y'] = -1980.74,['z'] = 21.61,['h'] = 323.31, ['info'] = ' Jamestown Street 15', ['apt'] = 0 },
	[318] =  { ['x'] = 280.23,['y'] = -1993.25,['z'] = 20.81,['h'] = 139.93, ['info'] = ' Jamestown Street 16', ['apt'] = 0 },
	[319] =  { ['x'] = 257.12,['y'] = -2023.84,['z'] = 19.27,['h'] = 55.76, ['info'] = ' Jamestown Street 17', ['apt'] = 0 },
	[320] =  { ['x'] = 251.39,['y'] = -2029.73,['z'] = 18.51,['h'] = 137.79, ['info'] = ' Jamestown Street 18', ['apt'] = 0 },
	[321] =  { ['x'] = 236.5,['y'] = -2045.73,['z'] = 18.38,['h'] = 134.85, ['info'] = ' Jamestown Street 19', ['apt'] = 0 },
	[322] =  { ['x'] = 296.87,['y'] = -2097.86,['z'] = 17.67,['h'] = 285.59, ['info'] = ' Jamestown Street 20/Apt1', ['apt'] = 1 },
	[323] =  { ['x'] = 295.78,['y'] = -2093.31,['z'] = 17.67,['h'] = 291.54, ['info'] = ' Jamestown Street 20/Apt2', ['apt'] = 1 },
	[324] =  { ['x'] = 293.68,['y'] = -2087.92,['z'] = 17.67,['h'] = 287.12, ['info'] = ' Jamestown Street 20/Apt3', ['apt'] = 1 },
	[325] =  { ['x'] = 292.59,['y'] = -2086.38,['z'] = 17.67,['h'] = 290.15, ['info'] = ' Jamestown Street 20/Apt4', ['apt'] = 1 },
	[326] =  { ['x'] = 289.53,['y'] = -2077.1,['z'] = 17.67,['h'] = 291.26, ['info'] = ' Jamestown Street 20/Apt5', ['apt'] = 1 },
	[327] =  { ['x'] = 288.21,['y'] = -2072.75,['z'] = 17.67,['h'] = 288.69, ['info'] = ' Jamestown Street 20/Apt6', ['apt'] = 1 },
	[328] =  { ['x'] = 279.29,['y'] = -2043.26,['z'] = 19.77,['h'] = 232.08, ['info'] = ' Jamestown Street 20/Apt7', ['apt'] = 1 },
	[329] =  { ['x'] = 280.6,['y'] = -2041.64,['z'] = 19.77,['h'] = 224.82, ['info'] = ' Jamestown Street 20/Apt8', ['apt'] = 1 },
	[330] =  { ['x'] = 286.69,['y'] = -2034.4,['z'] = 19.77,['h'] = 231.33, ['info'] = ' Jamestown Street 20/Apt9', ['apt'] = 1 },
	[331] =  { ['x'] = 289.76,['y'] = -2030.74,['z'] = 19.77,['h'] = 231.61, ['info'] = ' Jamestown Street 20/Apt10', ['apt'] = 1 },
	[332] =  { ['x'] = 323.53,['y'] = -1990.66,['z'] = 24.17,['h'] = 229.59, ['info'] = ' Jamestown Street 20/Apt11', ['apt'] = 1 },
	[333] =  { ['x'] = 324.82,['y'] = -1988.95,['z'] = 24.17,['h'] = 226.72, ['info'] = ' Jamestown Street 20/Apt12', ['apt'] = 1 },
	[334] =  { ['x'] = 331.63,['y'] = -1982.15,['z'] = 24.17,['h'] = 233.06, ['info'] = ' Jamestown Street 20/Apt13', ['apt'] = 1 },
	[335] =  { ['x'] = 333.9,['y'] = -1978.33,['z'] = 24.17,['h'] = 241.31, ['info'] = ' Jamestown Street 20/Apt14', ['apt'] = 1 },
	[336] =  { ['x'] = 362.6,['y'] = -1986.24,['z'] = 24.13,['h'] = 159.57, ['info'] = ' Jamestown Street 20/Apt15', ['apt'] = 1 },
	[337] =  { ['x'] = 364.17,['y'] = -1986.78,['z'] = 24.14,['h'] = 160.3, ['info'] = ' Jamestown Street 20/Apt16', ['apt'] = 1 },
	[338] =  { ['x'] = 375.15,['y'] = -1990.66,['z'] = 24.13,['h'] = 157.46, ['info'] = ' Jamestown Street 20/Apt18', ['apt'] = 1 },
	[339] =  { ['x'] = 384.27,['y'] = -1994.33,['z'] = 24.24,['h'] = 162.11, ['info'] = ' Jamestown Street 20/Apt19', ['apt'] = 1 },
	[340] =  { ['x'] = 385.74,['y'] = -1995.01,['z'] = 24.24,['h'] = 162.4, ['info'] = ' Jamestown Street 20/Apt20', ['apt'] = 1 },
	[341] =  { ['x'] = 405.02,['y'] = -2018.35,['z'] = 23.33,['h'] = 67.11, ['info'] = ' Jamestown Street 20/Apt21', ['apt'] = 1 },
	[342] =  { ['x'] = 402.43,['y'] = -2024.68,['z'] = 23.25,['h'] = 64.89, ['info'] = ' Jamestown Street 20/Apt22', ['apt'] = 1 },
	[343] =  { ['x'] = 400.7,['y'] = -2028.47,['z'] = 23.25,['h'] = 64.86, ['info'] = ' Jamestown Street 20/Apt23', ['apt'] = 1 },
	[344] =  { ['x'] = 397.38,['y'] = -2034.67,['z'] = 23.21,['h'] = 62.87, ['info'] = ' Jamestown Street 20/Apt24', ['apt'] = 1 },
	[345] =  { ['x'] = 396.04,['y'] = -2037.9,['z'] = 23.04,['h'] = 66.18, ['info'] = ' Jamestown Street 20/Apt25', ['apt'] = 1 },
	[346] =  { ['x'] = 392.7,['y'] = -2044.32,['z'] = 22.93,['h'] = 64.93, ['info'] = ' Jamestown Street 20/Apt26', ['apt'] = 1 },
	[347] =  { ['x'] = 382.56,['y'] = -2061.38,['z'] = 21.78,['h'] = 52.06, ['info'] = ' Jamestown Street 20/Apt27', ['apt'] = 1 },
	[348] =  { ['x'] = 378.73,['y'] = -2067.02,['z'] = 21.38,['h'] = 52.18, ['info'] = ' Jamestown Street 20/Apt28', ['apt'] = 1 },
	[349] =  { ['x'] = 375.83,['y'] = -2069.96,['z'] = 21.55,['h'] = 52.97, ['info'] = ' Jamestown Street 20/Apt29', ['apt'] = 1 },
	[350] =  { ['x'] = 371.63,['y'] = -2074.86,['z'] = 21.56,['h'] = 47.53, ['info'] = ' Jamestown Street 20/Apt30', ['apt'] = 1 },
	[351] =  { ['x'] = 368.99,['y'] = -2078.37,['z'] = 21.38,['h'] = 49.85, ['info'] = ' Jamestown Street 20/Apt31', ['apt'] = 1 },
	[352] =  { ['x'] = 364.48,['y'] = -2083.31,['z'] = 21.57,['h'] = 55.19, ['info'] = ' Jamestown Street 20/Apt32', ['apt'] = 1 },
	[353] =  { ['x'] = 341.08,['y'] = -2098.49,['z'] = 18.21,['h'] = 110.37, ['info'] = ' Jamestown Street 20/Apt33', ['apt'] = 1 },
	[354] =  { ['x'] = 333.01,['y'] = -2106.72,['z'] = 18.02,['h'] = 38.79, ['info'] = ' Jamestown Street 20/Apt34', ['apt'] = 1 },
	[355] =  { ['x'] = 329.57,['y'] = -2108.85,['z'] = 17.91,['h'] = 31.98, ['info'] = ' Jamestown Street 20/Apt35', ['apt'] = 1 },
	[356] =  { ['x'] = 324.18,['y'] = -2112.44,['z'] = 17.76,['h'] = 46.63, ['info'] = ' Jamestown Street 20/Apt36', ['apt'] = 1 },
	[357] =  { ['x'] = 306.34,['y'] = -2098.09,['z'] = 17.53,['h'] = 17.58, ['info'] = ' Jamestown Street 20/Apt37', ['apt'] = 1 },
	[358] =  { ['x'] = 306.07,['y'] = -2086.4,['z'] = 17.61,['h'] = 103.49, ['info'] = ' Jamestown Street 20/Apt38', ['apt'] = 1 },
	[359] =  { ['x'] = 303.8,['y'] = -2079.71,['z'] = 17.66,['h'] = 108.49, ['info'] = ' Jamestown Street 20/Apt39', ['apt'] = 1 },
	[360] =  { ['x'] = 302.18,['y'] = -2076.06,['z'] = 17.69,['h'] = 99.21, ['info'] = ' Jamestown Street 20/Apt40', ['apt'] = 1 },
	[361] =  { ['x'] = 295.03,['y'] = -2067.07,['z'] = 17.66,['h'] = 190.42, ['info'] = ' Jamestown Street 20/Apt41', ['apt'] = 1 },
	[362] =  { ['x'] = 286.77,['y'] = -2053.13,['z'] = 19.43,['h'] = 52.79, ['info'] = ' Jamestown Street 20/Apt42', ['apt'] = 1 },
	[363] =  { ['x'] = 291.13,['y'] = -2047.6,['z'] = 19.66,['h'] = 44.61, ['info'] = ' Jamestown Street 20/Apt43', ['apt'] = 1 },
	[364] =  { ['x'] = 293.65,['y'] = -2044.56,['z'] = 19.64,['h'] = 39.9, ['info'] = ' Jamestown Street 20/Apt44', ['apt'] = 1 },
	[365] =  { ['x'] = 331.18,['y'] = -2000.79,['z'] = 23.81,['h'] = 47.06, ['info'] = ' Jamestown Street 20/Apt45', ['apt'] = 1 },
	[366] =  { ['x'] = 335.45,['y'] = -1995.13,['z'] = 24.05,['h'] = 47.08, ['info'] = ' Jamestown Street 20/Apt46', ['apt'] = 1 },
	[367] =  { ['x'] = 338.11,['y'] = -1992.45,['z'] = 23.61,['h'] = 40.95, ['info'] = ' Jamestown Street 20/Apt47', ['apt'] = 1 },
	[368] =  { ['x'] = 356.72,['y'] = -1997.29,['z'] = 24.07,['h'] = 336.83, ['info'] = ' Jamestown Street 20/Apt48', ['apt'] = 1 },
	[369] =  { ['x'] = 363.17,['y'] = -1999.61,['z'] = 24.05,['h'] = 336.99, ['info'] = ' Jamestown Street 20/Apt49', ['apt'] = 1 },
	[370] =  { ['x'] = 366.89,['y'] = -2000.92,['z'] = 24.24,['h'] = 334.73, ['info'] = ' Jamestown Street 20/Apt50', ['apt'] = 1 },
	[371] =  { ['x'] = 373.56,['y'] = -2003.08,['z'] = 24.27,['h'] = 340.6, ['info'] = ' Jamestown Street 20/Apt51', ['apt'] = 1 },
	[372] =  { ['x'] = 376.97,['y'] = -2004.75,['z'] = 24.05,['h'] = 334.25, ['info'] = ' Jamestown Street 20/Apt52', ['apt'] = 1 },
	[373] =  { ['x'] = 383.31,['y'] = -2007.28,['z'] = 23.88,['h'] = 331.42, ['info'] = ' Jamestown Street 20/Apt53', ['apt'] = 1 },
	[374] =  { ['x'] = 393.38,['y'] = -2015.4,['z'] = 23.41,['h'] = 241.2, ['info'] = ' Jamestown Street 20/Apt54', ['apt'] = 1 },
	[375] =  { ['x'] = 391.99,['y'] = -2016.96,['z'] = 23.41,['h'] = 242.17, ['info'] = ' Jamestown Street 20/Apt55', ['apt'] = 1 },
	[376] =  { ['x'] = 388.18,['y'] = -2025.47,['z'] = 23.41,['h'] = 236.34, ['info'] = ' Jamestown Street 20/Apt56', ['apt'] = 1 },
	[377] =  { ['x'] = 383.87,['y'] = -2036.12,['z'] = 23.41,['h'] = 243.42, ['info'] = ' Jamestown Street 20/Apt58', ['apt'] = 1 },
	[378] =  { ['x'] = 382.6,['y'] = -2037.41,['z'] = 23.41,['h'] = 243.12, ['info'] = ' Jamestown Street 20/Apt59', ['apt'] = 1 },
	[379] =  { ['x'] = 372.04,['y'] = -2055.52,['z'] = 21.75,['h'] = 221.27, ['info'] = ' Jamestown Street 20/Apt60', ['apt'] = 1 },
	[380] =  { ['x'] = 370.9,['y'] = -2056.9,['z'] = 21.75,['h'] = 226.86, ['info'] = ' Jamestown Street 20/Apt61', ['apt'] = 1 },
	[381] =  { ['x'] = 364.62,['y'] = -2064.18,['z'] = 21.75,['h'] = 226.55, ['info'] = ' Jamestown Street 20/Apt62', ['apt'] = 1 },
	[382] =  { ['x'] = 357.72,['y'] = -2073.24,['z'] = 21.75,['h'] = 231.66, ['info'] = ' Jamestown Street 20/Apt64', ['apt'] = 1 },
	[383] =  { ['x'] = 356.57,['y'] = -2074.62,['z'] = 21.75,['h'] = 227.21, ['info'] = ' Jamestown Street 20/Apt65', ['apt'] = 1 },
	[384] =  { ['x'] = 334.14,['y'] = -2092.86,['z'] = 18.25,['h'] = 209.74, ['info'] = ' Jamestown Street 20/Apt66', ['apt'] = 1 },
	[385] =  { ['x'] = 329.88,['y'] = -2094.65,['z'] = 18.25,['h'] = 208.97, ['info'] = ' Jamestown Street 20/Apt67', ['apt'] = 1 },
	[386] =  { ['x'] = 321.57,['y'] = -2099.85,['z'] = 18.25,['h'] = 208.4, ['info'] = ' Jamestown Street 20/Apt68', ['apt'] = 1 },
	[387] =  { ['x'] = 319.72,['y'] = -2100.29,['z'] = 18.25,['h'] = 207.21, ['info'] = ' Jamestown Street 20/Apt69', ['apt'] = 1 },
	[388] =  { ['x'] = 332.15,['y'] = -2070.86,['z'] = 20.95,['h'] = 321.11, ['info'] = ' Jamestown Street 20/Apt70', ['apt'] = 1 },
	[389] =  { ['x'] = 324.11,['y'] = -2063.77,['z'] = 20.72,['h'] = 327.76, ['info'] = ' Jamestown Street 20/Apt72', ['apt'] = 1 },
	[390] =  { ['x'] = 321.03,['y'] = -2061.05,['z'] = 20.74,['h'] = 319.9, ['info'] = ' Jamestown Street 20/Apt73', ['apt'] = 1 },
	[391] =  { ['x'] = 315.26,['y'] = -2056.94,['z'] = 20.72,['h'] = 321.74, ['info'] = ' Jamestown Street 20/Apt74', ['apt'] = 1 },
	[392] =  { ['x'] = 312.31,['y'] = -2054.58,['z'] = 20.72,['h'] = 320.28, ['info'] = ' Jamestown Street 20/Apt75', ['apt'] = 1 },
	[393] =  { ['x'] = 305.98,['y'] = -2044.77,['z'] = 20.9,['h'] = 229.17, ['info'] = ' Jamestown Street 20/Apt76', ['apt'] = 1 },
	[394] =  { ['x'] = 313.74,['y'] = -2040.53,['z'] = 20.94,['h'] = 140.85, ['info'] = ' Jamestown Street 20/Apt77', ['apt'] = 1 },
	[395] =  { ['x'] = 317.47,['y'] = -2043.3,['z'] = 20.94,['h'] = 139.1, ['info'] = ' Jamestown Street 20/Apt78', ['apt'] = 1 },
	[396] =  { ['x'] = 324.69,['y'] = -2049.25,['z'] = 20.94,['h'] = 139.12, ['info'] = ' Jamestown Street 20/Apt79', ['apt'] = 1 },
	[397] =  { ['x'] = 326.2,['y'] = -2050.54,['z'] = 20.94,['h'] = 139.05, ['info'] = ' Jamestown Street 20/Apt80', ['apt'] = 1 },
	[398] =  { ['x'] = 333.56,['y'] = -2056.94,['z'] = 20.94,['h'] = 136.48, ['info'] = ' Jamestown Street 20/Apt81', ['apt'] = 1 },
	[399] =  { ['x'] = 334.57,['y'] = -2058.3,['z'] = 20.94,['h'] = 143.73, ['info'] = ' Jamestown Street 20/Apt82', ['apt'] = 1 },
	[400] =  { ['x'] = 341.86,['y'] = -2064.11,['z'] = 20.95,['h'] = 143.43, ['info'] = ' Jamestown Street 20/Apt83', ['apt'] = 1 },
	[401] =  { ['x'] = 345.23,['y'] = -2067.37,['z'] = 20.94,['h'] = 139.82, ['info'] = ' Jamestown Street 20/Apt84', ['apt'] = 1 },
	[402] =  { ['x'] = 363.43,['y'] = -2046.13,['z'] = 22.2,['h'] = 318.31, ['info'] = ' Jamestown Street 20/Apt85', ['apt'] = 1 },
	[403] =  { ['x'] = 359.88,['y'] = -2043.38,['z'] = 22.2,['h'] = 320.76, ['info'] = ' Jamestown Street 20/Apt86', ['apt'] = 1 },
	[404] =  { ['x'] = 352.51,['y'] = -2037.24,['z'] = 22.09,['h'] = 318.37, ['info'] = ' Jamestown Street 20/Apt87', ['apt'] = 1 },
	[405] =  { ['x'] = 352.15,['y'] = -2034.96,['z'] = 22.36,['h'] = 318.55, ['info'] = ' Jamestown Street 20/Apt88', ['apt'] = 1 },
	[406] =  { ['x'] = 344.83,['y'] = -2028.81,['z'] = 22.36,['h'] = 319.14, ['info'] = ' Jamestown Street 20/Apt89', ['apt'] = 1 },
	[407] =  { ['x'] = 343.63,['y'] = -2027.94,['z'] = 22.36,['h'] = 320.6, ['info'] = ' Jamestown Street 20/Apt90', ['apt'] = 1 },
	[408] =  { ['x'] = 336.17,['y'] = -2021.61,['z'] = 22.36,['h'] = 318.01, ['info'] = ' Jamestown Street 20/Apt91', ['apt'] = 1 },
	[409] =  { ['x'] = 331.93,['y'] = -2019.28,['z'] = 22.35,['h'] = 332.68, ['info'] = ' Jamestown Street 20/Apt92', ['apt'] = 1 },
	[410] =  { ['x'] = 335.78,['y'] = -2010.93,['z'] = 22.32,['h'] = 219.48, ['info'] = ' Jamestown Street 20/Apt93', ['apt'] = 1 },
	[411] =  { ['x'] = 345.65,['y'] = -2014.72,['z'] = 22.4,['h'] = 156.47, ['info'] = ' Jamestown Street 20/Apt94', ['apt'] = 1 },
	[412] =  { ['x'] = 354.15,['y'] = -2021.71,['z'] = 22.31,['h'] = 161.59, ['info'] = ' Jamestown Street 20/Apt96', ['apt'] = 1 },
	[413] =  { ['x'] = 357.26,['y'] = -2024.55,['z'] = 22.3,['h'] = 138.06, ['info'] = ' Jamestown Street 20/Apt97', ['apt'] = 1 },
	[414] =  { ['x'] = 362.71,['y'] = -2028.26,['z'] = 22.25,['h'] = 146.16, ['info'] = ' Jamestown Street 20/Apt98', ['apt'] = 1 },
	[415] =  { ['x'] = 365.22,['y'] = -2031.53,['z'] = 22.4,['h'] = 229.42, ['info'] = ' Jamestown Street 20/Apt99', ['apt'] = 1 },
	[416] =  { ['x'] = 371.47,['y'] = -2040.7,['z'] = 22.2,['h'] = 48.81, ['info'] = ' Jamestown Street 20/Apt100', ['apt'] = 1 },
	[417] =  { ['x'] = -903.43,['y'] = -1005.12,['z'] = 2.16,['h'] = 210.68, ['info'] = ' Coopenmartha Court 1', ['apt'] = 2 },
	[418] =  { ['x'] = -902.68,['y'] = -997.07,['z'] = 2.16,['h'] = 28.56, ['info'] = ' Coopenmartha Court 2', ['apt'] = 2 },
	[419] =  { ['x'] = -900.17,['y'] = -981.97,['z'] = 2.17,['h'] = 122.33, ['info'] = ' Coopenmartha Court 3', ['apt'] = 2 },
	[420] =  { ['x'] = -913.66,['y'] = -989.39,['z'] = 2.16,['h'] = 206.18, ['info'] = ' Coopenmartha Court 4', ['apt'] = 2 },
	[421] =  { ['x'] = -908.07,['y'] = -976.76,['z'] = 2.16,['h'] = 32.27, ['info'] = ' Coopenmartha Court 5', ['apt'] = 2 },
	[422] =  { ['x'] = -922.48,['y'] = -983.07,['z'] = 2.16,['h'] = 117.2, ['info'] = ' Coopenmartha Court 6', ['apt'] = 2 },
	[423] =  { ['x'] = -927.84,['y'] = -973.27,['z'] = 2.16,['h'] = 215.49, ['info'] = ' Coopenmartha Court 6', ['apt'] = 2 },
	[424] =  { ['x'] = -927.7,['y'] = -949.4,['z'] = 2.75,['h'] = 129.72, ['info'] = ' Coopenmartha Court 8', ['apt'] = 2 },
	[425] =  { ['x'] = -934.92,['y'] = -938.93,['z'] = 2.15,['h'] = 119.33, ['info'] = ' Coopenmartha Court 9', ['apt'] = 2 },
	[426] =  { ['x'] = -947.13,['y'] = -927.75,['z'] = 2.15,['h'] = 118.67, ['info'] = ' Coopenmartha Court 10', ['apt'] = 2 },
	[427] =  { ['x'] = -947.68,['y'] = -910.11,['z'] = 2.35,['h'] = 122.31, ['info'] = ' Coopenmartha Court 11', ['apt'] = 2 },
	[428] =  { ['x'] = -950.41,['y'] = -905.28,['z'] = 2.35,['h'] = 118.74, ['info'] = ' Coopenmartha Court 12', ['apt'] = 2 },
	[429] =  { ['x'] = -986.43,['y'] = -866.38,['z'] = 2.2,['h'] = 208.66, ['info'] = ' Coopenmartha Court 13', ['apt'] = 2 },
	[430] =  { ['x'] = -996.44,['y'] = -875.87,['z'] = 2.16,['h'] = 196.75, ['info'] = ' Coopenmartha Court 14', ['apt'] = 2 },
	[431] =  { ['x'] = -1011.47,['y'] = -880.83,['z'] = 2.16,['h'] = 208.65, ['info'] = ' Coopenmartha Court 15', ['apt'] = 2 },
	[432] =  { ['x'] = -1005.53,['y'] = -897.67,['z'] = 2.55,['h'] = 296.35, ['info'] = ' Coopenmartha Court 16', ['apt'] = 2 },
	[433] =  { ['x'] = -975.57,['y'] = -909.16,['z'] = 2.16,['h'] = 222.04, ['info'] = ' Coopenmartha Court 17', ['apt'] = 2 },
	[434] =  { ['x'] = -1010.99,['y'] = -909.64,['z'] = 2.14,['h'] = 33.62, ['info'] = ' Coopenmartha Court 18', ['apt'] = 2 },
	[435] =  { ['x'] = -1022.89,['y'] = -896.58,['z'] = 5.42,['h'] = 207.75, ['info'] = ' Coopenmartha Court 19', ['apt'] = 2 },
	[436] =  { ['x'] = -1031.35,['y'] = -903.04,['z'] = 3.7,['h'] = 208.79, ['info'] = ' Coopenmartha Court 20', ['apt'] = 2 },
	[437] =  { ['x'] = -1027.9,['y'] = -919.72,['z'] = 5.05,['h'] = 22.53, ['info'] = ' Coopenmartha Court 21', ['apt'] = 2 },
	[438] =  { ['x'] = -1024.41,['y'] = -912.11,['z'] = 6.97,['h'] = 126.42, ['info'] = ' Coopenmartha Court 22', ['apt'] = 2 },
	[439] =  { ['x'] = -1043.03,['y'] = -924.86,['z'] = 3.16,['h'] = 28.04, ['info'] = ' Coopenmartha Court 23', ['apt'] = 2 },
	[440] =  { ['x'] = -1053.82,['y'] = -933.09,['z'] = 3.36,['h'] = 23.91, ['info'] = ' Coopenmartha Court 24', ['apt'] = 2 },
	[441] =  { ['x'] = -1090.89,['y'] = -926.24,['z'] = 3.14,['h'] = 204.58, ['info'] = ' Coopenmartha Court 25', ['apt'] = 2 },
	[442] =  { ['x'] = -1085.1,['y'] = -934.97,['z'] = 3.09,['h'] = 121.56, ['info'] = ' Coopenmartha Court 26', ['apt'] = 2 },
	[443] =  { ['x'] = -1075.69,['y'] = -939.49,['z'] = 2.36,['h'] = 303.99, ['info'] = ' Coopenmartha Court 27', ['apt'] = 2 },
	[444] =  { ['x'] = -1084.41,['y'] = -951.81,['z'] = 2.37,['h'] = 310.7, ['info'] = ' Coopenmartha Court 28', ['apt'] = 2 },
	[445] =  { ['x'] = -989.35,['y'] = -975.21,['z'] = 4.23,['h'] = 117.27, ['info'] = ' Imagination Court 1', ['apt'] = 2 },
	[446] =  { ['x'] = -994.98,['y'] = -966.47,['z'] = 2.55,['h'] = 116.74, ['info'] = ' Imagination Court 2', ['apt'] = 2 },
	[447] =  { ['x'] = -978.21,['y'] = -990.68,['z'] = 4.55,['h'] = 121.89, ['info'] = ' Imagination Court 3', ['apt'] = 2 },
	[448] =  { ['x'] = -1019.04,['y'] = -963.69,['z'] = 2.16,['h'] = 201.18, ['info'] = ' Imagination Court 4', ['apt'] = 2 },
	[449] =  { ['x'] = -1028.21,['y'] = -968.02,['z'] = 2.16,['h'] = 204.49, ['info'] = ' Imagination Court 5', ['apt'] = 2 },
	[450] =  { ['x'] = -1032.18,['y'] = -982.48,['z'] = 2.16,['h'] = 202.74, ['info'] = ' Imagination Court 6', ['apt'] = 2 },
	[451] =  { ['x'] = -1056.67,['y'] = -1001.26,['z'] = 2.16,['h'] = 277.45, ['info'] = ' Imagination Court 7', ['apt'] = 2 },
	[452] =  { ['x'] = -1054.81,['y'] = -1000.95,['z'] = 6.42,['h'] = 307.44, ['info'] = ' Imagination Court 8', ['apt'] = 2 },
	[453] =  { ['x'] = -1055.75,['y'] = -998.78,['z'] = 6.42,['h'] = 305.55, ['info'] = ' Imagination Court 9', ['apt'] = 2 },
	[454] =  { ['x'] = -1042.39,['y'] = -1024.61,['z'] = 2.16,['h'] = 211.23, ['info'] = ' Imagination Court 10', ['apt'] = 2 },
	[455] =  { ['x'] = -1022.48,['y'] = -1022.42,['z'] = 2.16,['h'] = 205.65, ['info'] = ' Imagination Court 11', ['apt'] = 2 },
	[456] =  { ['x'] = -1008.47,['y'] = -1015.29,['z'] = 2.16,['h'] = 208.97, ['info'] = ' Imagination Court 12', ['apt'] = 2 },
	[457] =  { ['x'] = -997.35,['y'] = -1012.6,['z'] = 2.16,['h'] = 302.07, ['info'] = ' Imagination Court 13', ['apt'] = 2 },
	[458] =  { ['x'] = -967.46,['y'] = -1008.5,['z'] = 2.16,['h'] = 218.76, ['info'] = ' Imagination Court 14', ['apt'] = 2 },
	[459] =  { ['x'] = -942.71,['y'] = -1076.35,['z'] = 2.54,['h'] = 29.74, ['info'] = ' Invention Court 1', ['apt'] = 2 },
	[460] =  { ['x'] = -951.94,['y'] = -1078.52,['z'] = 2.16,['h'] = 29.92, ['info'] = ' Invention Court 2', ['apt'] = 2 },
	[461] =  { ['x'] = -982.64,['y'] = -1066.94,['z'] = 2.55,['h'] = 207.21, ['info'] = ' Invention Court 3', ['apt'] = 2 },
	[462] =  { ['x'] = -977.79,['y'] = -1091.85,['z'] = 4.23,['h'] = 132.57, ['info'] = ' Invention Court 4', ['apt'] = 2 },
	[463] =  { ['x'] = -982.64,['y'] = -1083.86,['z'] = 2.55,['h'] = 121.26, ['info'] = ' Invention Court 5', ['apt'] = 2 },
	[464] =  { ['x'] = -991.11,['y'] = -1103.85,['z'] = 2.16,['h'] = 38.51, ['info'] = ' Invention Court 6', ['apt'] = 2 },
	[465] =  { ['x'] = -986.66,['y'] = -1122.15,['z'] = 4.55,['h'] = 301.76, ['info'] = ' Invention Court 7', ['apt'] = 2 },
	[466] =  { ['x'] = -976.25,['y'] = -1140.3,['z'] = 2.18,['h'] = 296.42, ['info'] = ' Invention Court 8', ['apt'] = 2 },
	[467] =  { ['x'] = -978.06,['y'] = -1108.25,['z'] = 2.16,['h'] = 199.34, ['info'] = ' Invention Court 9', ['apt'] = 2 },
	[468] =  { ['x'] = -960.05,['y'] = -1109.07,['z'] = 2.16,['h'] = 202.32, ['info'] = ' Invention Court 11', ['apt'] = 2 },
	[469] =  { ['x'] = -963.15,['y'] = -1110.02,['z'] = 2.18,['h'] = 117.39, ['info'] = ' Invention Court 10', ['apt'] = 2 },
	[470] =  { ['x'] = -948.72,['y'] = -1107.7,['z'] = 2.18,['h'] = 299.33, ['info'] = ' Invention Court 12', ['apt'] = 2 },
	[471] =  { ['x'] = -939.32,['y'] = -1088.27,['z'] = 2.16,['h'] = 273.12, ['info'] = ' Invention Court 13', ['apt'] = 2 },
	[472] =  { ['x'] = -931.12,['y'] = -1100.18,['z'] = 2.18,['h'] = 215.78, ['info'] = ' Invention Court 14', ['apt'] = 2 },
	[473] =  { ['x'] = -921.36,['y'] = -1095.44,['z'] = 2.16,['h'] = 118.76, ['info'] = ' Invention Court 15', ['apt'] = 2 },
	[474] =  { ['x'] = -1176.2,['y'] = -1072.88,['z'] = 5.91,['h'] = 115.96, ['info'] = ' Imagination Court 15', ['apt'] = 2 },
	[475] =  { ['x'] = -1180.93,['y'] = -1056.36,['z'] = 2.16,['h'] = 209.3, ['info'] = ' Imagination Court 16', ['apt'] = 2 },
	[476] =  { ['x'] = -1183.71,['y'] = -1044.88,['z'] = 2.16,['h'] = 125.29, ['info'] = ' Imagination Court 17', ['apt'] = 2 },
	[477] =  { ['x'] = -1188.65,['y'] = -1041.64,['z'] = 2.3,['h'] = 27.41, ['info'] = ' Imagination Court 18', ['apt'] = 2 },
	[478] =  { ['x'] = -1198.67,['y'] = -1023.73,['z'] = 2.16,['h'] = 202.18, ['info'] = ' Imagination Court 19', ['apt'] = 2 },
	[479] =  { ['x'] = -1203.28,['y'] = -1021.27,['z'] = 5.96,['h'] = 121.76, ['info'] = ' Imagination Court 20', ['apt'] = 2 },
	[480] =  { ['x'] = -1098.74,['y'] = -1679.17,['z'] = 4.37,['h'] = 300.45, ['info'] = ' Beachside Avenue 1', ['apt'] = 2 },
	[481] =  { ['x'] = -1097.58,['y'] = -1673.07,['z'] = 8.4,['h'] = 303.36, ['info'] = ' Beachside Avenue 2', ['apt'] = 2 },
	[482] =  { ['x'] = -1349.59,['y'] = -1187.7,['z'] = 4.57,['h'] = 271.19, ['info'] = ' Beachside Avenue 3', ['apt'] = 2 },
	[483] =  { ['x'] = -1347.14,['y'] = -1167.87,['z'] = 4.58,['h'] = 326.75, ['info'] = ' Beachside Avenue 4', ['apt'] = 2 },
	[484] =  { ['x'] = -1350.2,['y'] = -1161.41,['z'] = 4.51,['h'] = 268.7, ['info'] = ' Beachside Avenue 5', ['apt'] = 2 },
	[485] =  { ['x'] = -1347.23,['y'] = -1145.91,['z'] = 4.34,['h'] = 236.95, ['info'] = ' Beachside Avenue 6', ['apt'] = 2 },
	[486] =  { ['x'] = -1336.27,['y'] = -1145.51,['z'] = 6.74,['h'] = 177.62, ['info'] = ' Beachside Avenue 7', ['apt'] = 2 },
	[487] =  { ['x'] = -1374.53,['y'] = -1074.28,['z'] = 4.32,['h'] = 300.62, ['info'] = ' Beachside Avenue 8', ['apt'] = 2 },
	[488] =  { ['x'] = -1376.91,['y'] = -1070.31,['z'] = 4.35,['h'] = 300.36, ['info'] = ' Beachside Avenue 9', ['apt'] = 2 },
	[489] =  { ['x'] = -1379.84,['y'] = -1066.37,['z'] = 4.35,['h'] = 300.43, ['info'] = ' Beachside Avenue 10', ['apt'] = 2 },
	[490] =  { ['x'] = -1381.87,['y'] = -1062.06,['z'] = 4.35,['h'] = 299.36, ['info'] = ' Beachside Avenue 11', ['apt'] = 2 },
	[491] =  { ['x'] = -1384.78,['y'] = -1058.38,['z'] = 4.36,['h'] = 301.37, ['info'] = ' Beachside Avenue 12', ['apt'] = 2 },
	[492] =  { ['x'] = -1386.93,['y'] = -1054.22,['z'] = 4.34,['h'] = 303.25, ['info'] = ' Beachside Avenue 13', ['apt'] = 2 },
	[493] =  { ['x'] = -1370.18,['y'] = -1042.84,['z'] = 4.26,['h'] = 212.96, ['info'] = ' Beachside Avenue 14', ['apt'] = 2 },
	[494] =  { ['x'] = -1366.28,['y'] = -1039.9,['z'] = 4.26,['h'] = 207.39, ['info'] = ' Beachside Avenue 15', ['apt'] = 2 },
	[495] =  { ['x'] = -1362.4,['y'] = -1037.3,['z'] = 4.25,['h'] = 208.56, ['info'] = ' Beachside Avenue 16', ['apt'] = 2 },
	[496] =  { ['x'] = -1358.3,['y'] = -1035.08,['z'] = 4.24,['h'] = 206.68, ['info'] = ' Beachside Avenue 17', ['apt'] = 2 },
	[497] =  { ['x'] = -1754.06,['y'] = -725.21,['z'] = 10.29,['h'] = 315.01, ['info'] = ' Beachside Avenue 18', ['apt'] = 2 },
	[498] =  { ['x'] = -1754.74,['y'] = -708.34,['z'] = 10.4,['h'] = 228.16, ['info'] = ' Beachside Avenue 19', ['apt'] = 2 },
	[499] =  { ['x'] = -1764.34,['y'] = -708.4,['z'] = 10.62,['h'] = 330.2, ['info'] = ' Beachside Avenue 20', ['apt'] = 2 },
	[500] =  { ['x'] = -1777.02,['y'] = -701.53,['z'] = 10.53,['h'] = 321.14, ['info'] = ' Beachside Avenue 21', ['apt'] = 2 },
	[501] =  { ['x'] = -1770.67,['y'] = -677.27,['z'] = 10.38,['h'] = 132.13, ['info'] = ' Beachside Avenue 22', ['apt'] = 2 },
	[502] =  { ['x'] = -1765.69,['y'] = -681.05,['z'] = 10.29,['h'] = 141.89, ['info'] = ' Beachside Avenue 23', ['apt'] = 2 },
	[503] =  { ['x'] = -1791.69,['y'] = -683.89,['z'] = 10.65,['h'] = 322.32, ['info'] = ' Beachside Avenue 24', ['apt'] = 2 },
	[504] =  { ['x'] = -1793.69,['y'] = -663.88,['z'] = 10.6,['h'] = 313.3, ['info'] = ' Beachside Avenue 25', ['apt'] = 2 },
	[505] =  { ['x'] = -1803.64,['y'] = -662.45,['z'] = 10.73,['h'] = 10.28, ['info'] = ' Beachside Avenue 26', ['apt'] = 2 },
	[506] =  { ['x'] = -1813.82,['y'] = -657.05,['z'] = 10.89,['h'] = 57.95, ['info'] = ' Beachside Avenue 27', ['apt'] = 2 },
	[507] =  { ['x'] = -1819.73,['y'] = -650.15,['z'] = 10.98,['h'] = 36.31, ['info'] = ' Beachside Avenue 28', ['apt'] = 2 },
	[508] =  { ['x'] = -1834.74,['y'] = -642.54,['z'] = 11.48,['h'] = 288.8, ['info'] = ' Beachside Avenue 29', ['apt'] = 2 },
	[509] =  { ['x'] = -1836.49,['y'] = -631.61,['z'] = 10.76,['h'] = 260.79, ['info'] = ' Beachside Avenue 30', ['apt'] = 2 },
	[510] =  { ['x'] = -1838.56,['y'] = -629.2,['z'] = 11.25,['h'] = 76.98, ['info'] = ' Beachside Avenue 31', ['apt'] = 2 },
	[511] =  { ['x'] = -1872.51,['y'] = -604.06,['z'] = 11.89,['h'] = 50.69, ['info'] = ' Beachside Avenue 32', ['apt'] = 2 },
	[512] =  { ['x'] = -1874.66,['y'] = -593.01,['z'] = 11.89,['h'] = 50.96, ['info'] = ' Beachside Avenue 33', ['apt'] = 2 },
	[513] =  { ['x'] = -1883.28,['y'] = -578.94,['z'] = 11.82,['h'] = 138.0, ['info'] = ' Beachside Avenue 34', ['apt'] = 2 },
	[514] =  { ['x'] = -1901.72,['y'] = -586.55,['z'] = 11.88,['h'] = 300.26, ['info'] = ' Beachside Avenue 35', ['apt'] = 2 },
	[515] =  { ['x'] = -1913.45,['y'] = -574.22,['z'] = 11.44,['h'] = 317.93, ['info'] = ' Beachside Avenue 36', ['apt'] = 2 },
	[516] =  { ['x'] = -1917.79,['y'] = -558.82,['z'] = 11.85,['h'] = 274.38, ['info'] = ' Beachside Avenue 37', ['apt'] = 2 },
	[517] =  { ['x'] = -1924.05,['y'] = -559.33,['z'] = 12.07,['h'] = 45.74, ['info'] = ' Beachside Avenue 38', ['apt'] = 2 },
	[518] =  { ['x'] = -1918.64,['y'] = -542.55,['z'] = 11.83,['h'] = 145.81, ['info'] = ' Beachside Avenue 39', ['apt'] = 2 },
	[519] =  { ['x'] = -1947.03,['y'] = -544.07,['z'] = 11.87,['h'] = 54.28, ['info'] = ' Beachside Avenue 40', ['apt'] = 2 },
	[520] =  { ['x'] = -1947.95,['y'] = -531.65,['z'] = 11.83,['h'] = 44.17, ['info'] = ' Beachside Avenue 41', ['apt'] = 2 },
	[521] =  { ['x'] = -1968.27,['y'] = -532.39,['z'] = 12.18,['h'] = 317.83, ['info'] = ' Beachside Avenue 42', ['apt'] = 2 },
	[522] =  { ['x'] = -1968.36,['y'] = -523.33,['z'] = 11.85,['h'] = 52.01, ['info'] = ' Beachside Avenue 43', ['apt'] = 2 },
	[523] =  { ['x'] = -1980.0,['y'] = -520.54,['z'] = 11.9,['h'] = 316.92, ['info'] = ' Beachside Avenue 44', ['apt'] = 2 },
	[524] =  { ['x'] = -1070.57,['y'] = -1653.81,['z'] = 4.41,['h'] = 306.97, ['info'] = ' Beachside Court 1', ['apt'] = 2 },
	[525] =  { ['x'] = -1076.09,['y'] = -1645.79,['z'] = 4.51,['h'] = 313.53, ['info'] = ' Beachside Court 2', ['apt'] = 2 },
	[526] =  { ['x'] = -1082.93,['y'] = -1631.47,['z'] = 4.74,['h'] = 303.72, ['info'] = ' Beachside Court 3', ['apt'] = 2 },
	[527] =  { ['x'] = -1088.77,['y'] = -1623.08,['z'] = 4.74,['h'] = 299.0, ['info'] = ' Beachside Court 4', ['apt'] = 2 },
	[528] =  { ['x'] = -1092.39,['y'] = -1607.42,['z'] = 8.47,['h'] = 124.17, ['info'] = ' Beachside Court 5', ['apt'] = 2 },
	[529] =  { ['x'] = -1106.29,['y'] = -1596.34,['z'] = 4.6,['h'] = 228.18, ['info'] = ' Beachside Court 6', ['apt'] = 2 },
	[530] =  { ['x'] = -1038.86,['y'] = -1609.53,['z'] = 5.0,['h'] = 152.83, ['info'] = ' Beachside Court 7', ['apt'] = 2 },
	[531] =  { ['x'] = -1029.29,['y'] = -1603.62,['z'] = 4.97,['h'] = 129.41, ['info'] = ' Beachside Court 8', ['apt'] = 2 },
	[532] =  { ['x'] = -1032.69,['y'] = -1582.77,['z'] = 5.14,['h'] = 24.53, ['info'] = ' Beachside Court 9', ['apt'] = 2 },
	[533] =  { ['x'] = -1043.47,['y'] = -1580.43,['z'] = 5.04,['h'] = 235.83, ['info'] = ' Beachside Court 10', ['apt'] = 2 },
	[534] =  { ['x'] = -1041.27,['y'] = -1591.25,['z'] = 4.99,['h'] = 31.37, ['info'] = ' Beachside Court 11', ['apt'] = 2 },
	[535] =  { ['x'] = -1057.06,['y'] = -1587.44,['z'] = 4.61,['h'] = 40.1, ['info'] = ' Beachside Court 12', ['apt'] = 2 },
	[536] =  { ['x'] = -1058.16,['y'] = -1540.21,['z'] = 5.05,['h'] = 217.14, ['info'] = ' Beachside Court 16', ['apt'] = 2 },

	[537] =  { ['x'] = 35.27,['y'] = 6662.8,['z'] = 32.2,['h'] = 160.32, ['info'] = ' Procopio Drive 1', ['apt'] = 2 },
	[538] =  { ['x'] = -9.75,['y'] = 6654.15,['z'] = 31.7,['h'] = 201.74, ['info'] = ' Procopio Drive 2', ['apt'] = 2 },
	[539] =  { ['x'] = -41.3,['y'] = 6636.99,['z'] = 31.09,['h'] = 209.76, ['info'] = ' Procopio Drive 3', ['apt'] = 2 },
	[540] =  { ['x'] = -130.1,['y'] = 6551.49,['z'] = 29.53,['h'] = 220.17, ['info'] = ' Procopio Drive 4', ['apt'] = 2 },
	[541] =  { ['x'] = -229.77,['y'] = 6445.18,['z'] = 31.2,['h'] = 139.3, ['info'] = ' Procopio Drive 5', ['apt'] = 2 },
	[542] =  { ['x'] = -238.37,['y'] = 6423.4,['z'] = 31.46,['h'] = 215.07, ['info'] = ' Procopio Drive 6', ['apt'] = 2 },
	[543] =  { ['x'] = -272.14,['y'] = 6400.61,['z'] = 31.51,['h'] = 207.46, ['info'] = ' Procopio Drive 7', ['apt'] = 2 },
	[544] =  { ['x'] = -359.51,['y'] = 6334.64,['z'] = 29.85,['h'] = 218.99, ['info'] = ' Procopio Drive 8', ['apt'] = 2 },
	[545] =  { ['x'] = -407.22,['y'] = 6314.12,['z'] = 28.95,['h'] = 215.74, ['info'] = ' Procopio Drive 9', ['apt'] = 2 },
	[546] =  { ['x'] = -447.9,['y'] = 6271.69,['z'] = 33.34,['h'] = 64.01, ['info'] = ' Procopio Drive 10', ['apt'] = 2 },
	[547] =  { ['x'] = -467.97,['y'] = 6206.18,['z'] = 29.56,['h'] = 358.01, ['info'] = ' Procopio Drive 11', ['apt'] = 2 },
	[548] =  { ['x'] = -379.73,['y'] = 6253.05,['z'] = 31.86,['h'] = 310.69, ['info'] = ' Procopio Drive 12', ['apt'] = 3 },
	[549] =  { ['x'] = -370.91,['y'] = 6267.2,['z'] = 31.88,['h'] = 35.56, ['info'] = ' Procopio Drive 13', ['apt'] = 3 },
	[550] =  { ['x'] = -302.07,['y'] = 6327.4,['z'] = 32.89,['h'] = 36.31, ['info'] = ' Procopio Drive 14', ['apt'] = 3 },
	[551] =  { ['x'] = -280.62,['y'] = 6350.84,['z'] = 32.61,['h'] = 42.88, ['info'] = ' Procopio Drive 15', ['apt'] = 1 },
	[552] =  { ['x'] = -247.88,['y'] = 6369.98,['z'] = 31.85,['h'] = 45.41, ['info'] = ' Procopio Drive 16', ['apt'] = 3 },
	[553] =  { ['x'] = -227.7,['y'] = 6377.93,['z'] = 31.76,['h'] = 44.42, ['info'] = ' Procopio Drive 17', ['apt'] = 3 },
	[554] =  { ['x'] = -213.86,['y'] = 6396.5,['z'] = 33.09,['h'] = 42.81, ['info'] = ' Procopio Drive 18', ['apt'] = 3 },
	[555] =  { ['x'] = -189.07,['y'] = 6409.72,['z'] = 32.3,['h'] = 41.25, ['info'] = ' Procopio Drive 19', ['apt'] = 3 },

	[556] =  { ['x'] = 1535.30,['y'] = 2231.90,['z'] = 77.7,['h'] = 133.7, ['info'] = ' Grand Senora Path 1', ['apt'] = 2 },

	[557] =  { ['x'] = 248.3,['y'] = -1489.9,['z'] = 29.3,['h'] = 224.51, ['info'] = ' Strawberry Shop 1' , ['apt'] = 4 },
	[558] =  { ['x'] = 243.9,['y'] = -1492.9,['z'] = 29.3,['h'] = 45.95, ['info'] = ' Strawberry Shop 2' , ['apt'] = 4 },
	[559] =  { ['x'] = 224.62,['y'] = -1510.77,['z'] = 29.3,['h'] = 235.2, ['info'] = ' Strawberry Shop 3' , ['apt'] = 4 },
	[560] =  { ['x'] = 216.01,['y'] = -1523.44,['z'] = 29.3,['h'] = 142.05, ['info'] = ' Strawberry Shop 4' , ['apt'] = 4 },
	[561] =  { ['x'] = 218.7,['y'] = -1530.97,['z'] = 29.3,['h'] = 9.86, ['info'] = ' Strawberry Shop 5' , ['apt'] = 4 },
	[562] =  { ['x'] = 225.64,['y'] = -1539.46,['z'] = 29.32,['h'] = 311.3, ['info'] = ' Strawberry Shop 6' , ['apt'] = 4 },
	[563] =  { ['x'] = 168.19,['y'] = -1506.32,['z'] = 29.26,['h'] = 317.63, ['info'] = ' Strawberry Shop 7' , ['apt'] = 4 },
	[564] =  { ['x'] = 84.11,['y'] = -1551.83,['z'] = 29.6,['h'] = 218.89, ['info'] = ' Strawberry Shop 8' , ['apt'] = 4 },
	[565] =  { ['x'] = 68.14,['y'] = -1569.61,['z'] = 29.6,['h'] = 233.82, ['info'] = ' Strawberry Shop 9' , ['apt'] = 4 },
	[566] =  { ['x'] = 60.41,['y'] = -1579.4,['z'] = 29.6,['h'] = 214.56, ['info'] = ' Strawberry Shop 10' , ['apt'] = 4 },
	[567] =  { ['x'] = 47.73,['y'] = -1593.67,['z'] = 29.6,['h'] = 230.48, ['info'] = ' Strawberry Shop 11' , ['apt'] = 4 },
	[568] =  { ['x'] = 86.88,['y'] = -1670.51,['z'] = 29.17,['h'] = 262.58, ['info'] = ' Strawberry Shop 12' , ['apt'] = 4 },
	[569] =  { ['x'] = 95.75,['y'] = -1682.63,['z'] = 29.26,['h'] = 306.06, ['info'] = ' Strawberry Shop 13' , ['apt'] = 4 },
	[570] =  { ['x'] = 105.27,['y'] = -1689.97,['z'] = 29.3,['h'] = 323.28, ['info'] = ' Strawberry Shop 14' , ['apt'] = 4 },
	[571] =  { ['x'] = 100.21,['y'] = -1661.96,['z'] = 29.3,['h'] = 217.67, ['info'] = ' Strawberry Shop 15' , ['apt'] = 4 },
	[572] =  { ['x'] = 107.2,['y'] = -1657.47,['z'] = 29.3,['h'] = 220.76, ['info'] = ' Strawberry Shop 16' , ['apt'] = 4 },
	[573] =  { ['x'] = 106.22,['y'] = -1658.4,['z'] = 29.3,['h'] = 269.44, ['info'] = ' Strawberry Shop 17' , ['apt'] = 4 },
	[574] =  { ['x'] = 118.34,['y'] = -1649.77,['z'] = 29.3,['h'] = 226.06, ['info'] = ' Strawberry Shop 18' , ['apt'] = 4 },
	[575] =  { ['x'] = 121.92,['y'] = -1647.5,['z'] = 29.3,['h'] = 215.09, ['info'] = ' Strawberry Shop 19' , ['apt'] = 4 },
	[576] =  { ['x'] = 129.64,['y'] = -1642.64,['z'] = 29.3,['h'] = 116.08, ['info'] = ' Strawberry Shop 20' , ['apt'] = 4 },
	[577] =  { ['x'] = 138.0,['y'] = -1639.45,['z'] = 29.31,['h'] = 219.64, ['info'] = ' Strawberry Shop 21' , ['apt'] = 4 },
	[578] =  { ['x'] = 53.3,['y'] = -1478.84,['z'] = 29.29,['h'] = 7.7, ['info'] = ' Strawberry Shop 22' , ['apt'] = 4 },
	[579] =  { ['x'] = 65.74,['y'] = -1467.38,['z'] = 29.3,['h'] = 203.15, ['info'] = ' Strawberry Shop 23' , ['apt'] = 4 },
	[580] =  { ['x'] = 76.03,['y'] = -1455.81,['z'] = 29.3,['h'] = 38.31, ['info'] = ' Strawberry Shop 24' , ['apt'] = 4 },
	[581] =  { ['x'] = 99.55,['y'] = -1419.21,['z'] = 29.43,['h'] = 63.13, ['info'] = ' Strawberry Shop 25' , ['apt'] = 4 },
	[582] =  { ['x'] = 89.92,['y'] = -1411.31,['z'] = 29.43,['h'] = 125.59, ['info'] = ' Strawberry Shop 26' , ['apt'] = 4 },
	[583] =  { ['x'] = 84.87,['y'] = -1404.89,['z'] = 29.42,['h'] = 68.34, ['info'] = ' Strawberry Shop 27' , ['apt'] = 4 },
	[584] =  { ['x'] = 122.82,['y'] = -1347.74,['z'] = 29.3,['h'] = 306.79, ['info'] = ' Strawberry Shop 28' , ['apt'] = 4 },
	[585] =  { ['x'] = 170.37,['y'] = -1336.82,['z'] = 29.3,['h'] = 357.49, ['info'] = ' Strawberry Shop 29' , ['apt'] = 4 },
	[586] =  { ['x'] = 186.94,['y'] = -1310.53,['z'] = 29.33,['h'] = 45.29, ['info'] = ' Strawberry Shop 30' , ['apt'] = 4 },
	[587] =  { ['x'] = 195.63,['y'] = -1291.18,['z'] = 29.33,['h'] = 167.31, ['info'] = ' Strawberry Shop 31' , ['apt'] = 4 },
	[588] =  { ['x'] = 198.27,['y'] = -1276.41,['z'] = 29.33,['h'] = 26.43, ['info'] = ' Strawberry Shop 32' , ['apt'] = 4 },
	[589] =  { ['x'] = 199.61,['y'] = -1269.29,['z'] = 29.18,['h'] = 55.9, ['info'] = ' Strawberry Shop 33' , ['apt'] = 4 },
	[590] =  { ['x'] = 98.58,['y'] = -1308.83,['z'] = 29.28,['h'] = 122.82, ['info'] = ' Strawberry Shop 34' , ['apt'] = 4 },
	[591] =  { ['x'] = 87.92,['y'] = -1294.48,['z'] = 29.21,['h'] = 122.01, ['info'] = ' Strawberry Shop 35' , ['apt'] = 4 },
	[592] =  { ['x'] = 51.76,['y'] = -1317.47,['z'] = 29.29,['h'] = 124.75, ['info'] = ' Strawberry Shop 36' , ['apt'] = 4 },
	[593] =  { ['x'] = -39.17,['y'] = -1387.48,['z'] = 30.3,['h'] = 183.53, ['info'] = ' Strawberry Shop 37' , ['apt'] = 4 },
	[594] =  { ['x'] = -47.99,['y'] = -1385.35,['z'] = 29.5,['h'] = 355.74, ['info'] = ' Strawberry Shop 38' , ['apt'] = 4 },
	[595] =  { ['x'] = -82.25,['y'] = -1385.8,['z'] = 29.5,['h'] = 184.22, ['info'] = ' Strawberry Shop 39' , ['apt'] = 4 },
	[596] =  { ['x'] = -128.09,['y'] = -1394.33,['z'] = 29.55,['h'] = 182.09, ['info'] = ' Strawberry Shop 40' , ['apt'] = 4 },
	[597] =  { ['x'] = -160.18,['y'] = -1432.03,['z'] = 31.28,['h'] = 186.3, ['info'] = ' Strawberry Shop 41' , ['apt'] = 4 },
	[598] =  { ['x'] = -163.55,['y'] = -1439.71,['z'] = 31.43,['h'] = 142.48, ['info'] = ' Strawberry Shop 42' , ['apt'] = 4 },
	[599] =  { ['x'] = -171.21,['y'] = -1449.62,['z'] = 31.64,['h'] = 326.49, ['info'] = ' Strawberry Shop 43' , ['apt'] = 4 },

	[600] =  { ['x'] = -1489.69,['y'] = -671.15,['z'] = 33.39,['h'] = 134.21, ['info'] = ' Bay City Ave / App 69' , ['apt'] = 1 },
	[601] =  { ['x'] = -1493.46,['y'] = -668.06,['z'] = 33.39,['h'] = 141.4, ['info'] = ' Bay City Ave / App 37' , ['apt'] = 1 },
	[602] =  { ['x'] = -1497.83,['y'] = -664.47,['z'] = 29.03,['h'] = 137.35, ['info'] = ' Bay City Ave / App 2' , ['apt'] = 1 },
	[603] =  { ['x'] = -1495.04,['y'] = -661.92,['z'] = 29.03,['h'] = 30.17, ['info'] = ' Bay City Ave / App 3' , ['apt'] = 1 },
	[604] =  { ['x'] = -1490.48,['y'] = -658.73,['z'] = 29.03,['h'] = 29.52, ['info'] = ' Bay City Ave / App 4' , ['apt'] = 1 },
	[605] =  { ['x'] = -1486.45,['y'] = -655.88,['z'] = 29.59,['h'] = 37.15, ['info'] = ' Bay City Ave / App 5' , ['apt'] = 1 },
	[606] =  { ['x'] = -1481.97,['y'] = -652.46,['z'] = 29.59,['h'] = 31.19, ['info'] = ' Bay City Ave / App 6' , ['apt'] = 1 },
	[607] =  { ['x'] = -1477.95,['y'] = -649.54,['z'] = 29.59,['h'] = 32.3, ['info'] = ' Bay City Ave / App 7' , ['apt'] = 1 },
	[608] =  { ['x'] = -1473.36,['y'] = -646.2,['z'] = 29.59,['h'] = 26.38, ['info'] = ' Bay City Ave / App 8' , ['apt'] = 1 },
	[609] =  { ['x'] = -1469.31,['y'] = -643.41,['z'] = 29.59,['h'] = 29.38, ['info'] = ' Bay City Ave / App 8' , ['apt'] = 1 },
	[610] =  { ['x'] = -1464.75,['y'] = -640.1,['z'] = 29.59,['h'] = 33.84, ['info'] = ' Bay City Ave / App 10' , ['apt'] = 1 },
	[611] =  { ['x'] = -1461.78,['y'] = -641.4,['z'] = 29.59,['h'] = 303.51, ['info'] = ' Bay City Ave / App 11' , ['apt'] = 1 },
	[612] =  { ['x'] = -1452.58,['y'] = -653.29,['z'] = 29.59,['h'] = 300.87, ['info'] = ' Bay City Ave / App 12' , ['apt'] = 1 },
	[613] =  { ['x'] = -1454.68,['y'] = -655.64,['z'] = 29.59,['h'] = 213.03, ['info'] = ' Bay City Ave / App 13' , ['apt'] = 1 },
	[614] =  { ['x'] = -1459.3,['y'] = -658.86,['z'] = 29.59,['h'] = 228.02, ['info'] = ' Bay City Ave / App 14' , ['apt'] = 1 },
	[615] =  { ['x'] = -1463.37,['y'] = -661.72,['z'] = 29.59,['h'] = 214.95, ['info'] = ' Bay City Ave / App 15' , ['apt'] = 1 },
	[616] =  { ['x'] = -1468.05,['y'] = -664.9,['z'] = 29.59,['h'] = 214.39, ['info'] = ' Bay City Ave / App 16' , ['apt'] = 1 },
	[617] =  { ['x'] = -1471.96,['y'] = -667.82,['z'] = 29.59,['h'] = 213.94, ['info'] = ' Bay City Ave / App 17' , ['apt'] = 1 },
	[618] =  { ['x'] = -1461.53,['y'] = -641.04,['z'] = 33.39,['h'] = 304.53, ['info'] = ' Bay City Ave / App 18' , ['apt'] = 1 },
	[619] =  { ['x'] = -1458.35,['y'] = -645.91,['z'] = 33.39,['h'] = 308.11, ['info'] = ' Bay City Ave / App 19' , ['apt'] = 1 },
	[620] =  { ['x'] = -1456.04,['y'] = -648.95,['z'] = 33.39,['h'] = 306.76, ['info'] = ' Bay City Ave / App 20' , ['apt'] = 1 },
	[621] =  { ['x'] = -1452.73,['y'] = -653.47,['z'] = 33.39,['h'] = 301.36, ['info'] = ' Bay City Ave / App 21' , ['apt'] = 1 },
	[622] =  { ['x'] = -1454.63,['y'] = -655.6,['z'] = 33.39,['h'] = 215.46, ['info'] = ' Bay City Ave / App 22' , ['apt'] = 1 },
	[623] =  { ['x'] = -1459.41,['y'] = -658.81,['z'] = 33.39,['h'] = 213.78, ['info'] = ' Bay City Ave / App 23' , ['apt'] = 1 },
	[624] =  { ['x'] = -1463.32,['y'] = -661.53,['z'] = 33.39,['h'] = 210.0, ['info'] = ' Bay City Ave / App 24' , ['apt'] = 1 },
	[625] =  { ['x'] = -1467.84,['y'] = -665.24,['z'] = 33.39,['h'] = 189.07, ['info'] = ' Bay City Ave / App 25' , ['apt'] = 1 },
	[626] =  { ['x'] = -1471.78,['y'] = -668.02,['z'] = 33.39,['h'] = 214.32, ['info'] = ' Bay City Ave / App 26' , ['apt'] = 1 },
	[627] =  { ['x'] = -1476.37,['y'] = -671.31,['z'] = 33.39,['h'] = 216.08, ['info'] = ' Bay City Ave / App 27' , ['apt'] = 1 },
	[628] =  { ['x'] = -1464.99,['y'] = -639.7,['z'] = 33.39,['h'] = 35.06, ['info'] = ' Bay City Ave / App 28' , ['apt'] = 1 },
	[629] =  { ['x'] = -1469.15,['y'] = -643.43,['z'] = 33.39,['h'] = 35.14, ['info'] = ' Bay City Ave / App 29' , ['apt'] = 1 },
	[630] =  { ['x'] = -1473.23,['y'] = -646.27,['z'] = 33.39,['h'] = 32.85, ['info'] = ' Bay City Ave / App 30' , ['apt'] = 1 },
	[631] =  { ['x'] = -1477.85,['y'] = -649.78,['z'] = 33.39,['h'] = 32.61, ['info'] = ' Bay City Ave / App 31' , ['apt'] = 1 },
	[632] =  { ['x'] = -1481.81,['y'] = -652.67,['z'] = 33.39,['h'] = 33.91, ['info'] = ' Bay City Ave / App 32' , ['apt'] = 1 },
	[633] =  { ['x'] = -1486.47,['y'] = -655.77,['z'] = 33.39,['h'] = 36.38, ['info'] = ' Bay City Ave / App 33' , ['apt'] = 1 },
	[634] =  { ['x'] = -1490.7,['y'] = -658.4,['z'] = 33.39,['h'] = 33.02, ['info'] = ' Bay City Ave / App 34' , ['apt'] = 1 },
	[635] =  { ['x'] = -1495.22,['y'] = -661.82,['z'] = 33.39,['h'] = 38.31, ['info'] = ' Bay City Ave / App 35' , ['apt'] = 1 },
	[636] =  { ['x'] = -1498.02,['y'] = -664.59,['z'] = 33.39,['h'] = 128.87, ['info'] = ' Bay City Ave / App 36' , ['apt'] = 1 },

	[637] =  { ['x'] = -668.34,['y'] = -971.1,['z'] = 22.35,['h'] = 3.05, ['info'] = ' Lindsay Circus Apartment 1' , ['apt'] = 2 },
	[638] =  { ['x'] = -672.99,['y'] = -981.21,['z'] = 22.35,['h'] = 0.87, ['info'] = ' Lindsay Circus Apartment 2' , ['apt'] = 2 },
	[639] =  { ['x'] = -673.83,['y'] = -999.55,['z'] = 18.24,['h'] = 107.35, ['info'] = ' Lindsay Circus Apartment 3' , ['apt'] = 2 },
	[640] =  { ['x'] = -699.55,['y'] = -1032.33,['z'] = 16.22,['h'] = 293.78, ['info'] = ' Lindsay Circus Apartment 4' , ['apt'] = 2 },
	[641] =  { ['x'] = -702.95,['y'] = -1023.57,['z'] = 16.23,['h'] = 310.37, ['info'] = ' Lindsay Circus Apartment 5' , ['apt'] = 2 },
	[642] =  { ['x'] = -712.02,['y'] = -1028.62,['z'] = 16.43,['h'] = 136.07, ['info'] = ' Lindsay Circus Apartment 6' , ['apt'] = 2 },
	[643] =  { ['x'] = -705.84,['y'] = -1036.18,['z'] = 16.3,['h'] = 117.55, ['info'] = ' Little Seoul Apartment 1' , ['apt'] = 1 },
	[644] =  { ['x'] = -670.55,['y'] = -888.9,['z'] = 24.5,['h'] = 1.22, ['info'] = ' Little Seoul Apartment 2' , ['apt'] = 1 },
	[645] =  { ['x'] = -690.52,['y'] = -893.1,['z'] = 24.71,['h'] = 92.39, ['info'] = ' Little Seoul Apartment 3' , ['apt'] = 1 },
	[646] =  { ['x'] = -683.56,['y'] = -876.24,['z'] = 24.5,['h'] = 1.54, ['info'] = ' Little Seoul Apartment 4' , ['apt'] = 1 },
	[647] =  { ['x'] = -676.0,['y'] = -884.98,['z'] = 24.46,['h'] = 273.5, ['info'] = ' Little Seoul Apartment 5' , ['apt'] = 1 },

	[648] =  { ['x'] = -1253.91,['y'] = -1140.81,['z'] = 8.57,['h'] = 17.5, ['info'] = ' Bay City Ave Upper 1' , ['apt'] = 2 },
	[649] =  { ['x'] = -1252.75,['y'] = -1144.26,['z'] = 8.52,['h'] = 194.39, ['info'] = ' Bay City Ave Upper 2', ['apt'] = 2 },
	[650] =  { ['x'] = -1221.37,['y'] = -1232.13,['z'] = 11.03,['h'] = 199.21, ['info'] = ' Bay City Ave Lower 1', ['apt'] = 1 },
	[651] =   { ['x'] = -1229.69,['y'] = -1235.39,['z'] = 11.03,['h'] = 198.65, ['info'] = ' Bay City Ave Lower 2', ['apt'] = 1 },
	[652] =  { ['x'] = -1237.59,['y'] = -1238.56,['z'] = 11.03,['h'] = 199.9, ['info'] = ' Bay City Ave Lower 3', ['apt'] = 1 },
	[653] =  { ['x'] = -1244.02,['y'] = -1240.64,['z'] = 11.03,['h'] = 202.08, ['info'] = ' Bay City Ave Lower 4', ['apt'] = 1 },
	[654] =  { ['x'] = -1226.14,['y'] = -1207.35,['z'] = 8.28,['h'] = 103.63, ['info'] = ' Bay City Ave Upper 4', ['apt'] = 2 },
	[655] =  { ['x'] = -1232.89,['y'] = -1191.83,['z'] = 11.26,['h'] = 16.83, ['info'] = ' Bay City Ave Average 1', ['apt'] = 3 },
	[656] =  { ['x'] = -35.69,['y'] = 2871.22,['z'] = 59.6,['h'] = 250.51, ['info'] = ' Shitville', ['apt'] = 3 },
	[657] =  { ['x'] = -766.11,['y'] = -916.99,['z'] = 21.08,['h'] = 90.73, ['info'] = ' Ginger St 1', ['apt'] = 3 },
	[658] =  { ['x'] = 2.24,['y'] = -241.06,['z'] = 47.67,['h'] = 342.2, ['info'] = ' Occupation Ave 1 / Apt 1', ['apt'] = 3 },
	[659] =  { ['x'] = 8.78,['y'] = -243.28,['z'] = 47.67,['h'] = 337.63, ['info'] = ' Occupation Ave 1 / Apt 2', ['apt'] = 3 },
	[660] =  { ['x'] = 2.35,['y'] = -241.02,['z'] = 51.87,['h'] = 339.63, ['info'] = ' Occupation Ave 1 / Apt 3', ['apt'] = 3 },
	[661] =  { ['x'] = 8.81,['y'] = -243.33,['z'] = 51.87,['h'] = 339.04, ['info'] = ' Occupation Ave 1 / Apt 4', ['apt'] = 3 },
	[662] =  { ['x'] = 2.28,['y'] = -240.88,['z'] = 55.87,['h'] = 336.6, ['info'] = ' Occupation Ave 1 / Apt 5', ['apt'] = 3 },
	[663] =  { ['x'] = 8.79,['y'] = -243.66,['z'] = 55.87,['h'] = 340.11, ['info'] = ' Occupation Ave 1 / Apt 6', ['apt'] = 3 },
	[664] =  { ['x'] = 352.86,['y'] = -142.13,['z'] = 66.69,['h'] = 162.06, ['info'] = ' Spanish Ave 1', ['apt'] = 2 },
	[665] =  { ['x'] = 216.15,['y'] = -147.07,['z'] = 59.16,['h'] = 259.15, ['info'] = ' Power Street 1', ['apt'] = 3 },
	[666] =  { ['x'] = 213.47,['y'] = -154.84,['z'] = 59.16,['h'] = 250.24, ['info'] = ' Power Street 2', ['apt'] = 3 },
	[667] =  { ['x'] = 280.21,['y'] = 32.47,['z'] = 88.61,['h'] = 337.36, ['info'] = ' Power Street 10', ['apt'] = 3 },
	[668] =  { ['x'] = 283.99,['y'] = 31.14,['z'] = 88.61,['h'] = 340.55, ['info'] = ' Power Street 11', ['apt'] = 3 },
	[669] =  { ['x'] = 283.83,['y'] = 47.66,['z'] = 92.67,['h'] = 65.03, ['info'] = ' Power Street 12', ['apt'] = 0 },
	[670] =  { ['x'] = 283.83,['y'] = 47.31,['z'] = 96.69,['h'] = 51.9, ['info'] = ' Power Street 13', ['apt'] = 0 },
	[671] =  { ['x'] = -1363.31,['y'] = -137.24,['z'] = 49.58,['h'] = 357.94, ['info'] = ' Cougar Ave 1', ['apt'] = 0 },
	[672] =  { ['x'] = -1359.18,['y'] = -138.06,['z'] = 49.58,['h'] = 356.25, ['info'] = ' Cougar Ave 2', ['apt'] = 0 },
	[673] =  { ['x'] = -1348.59,['y'] = -140.0,['z'] = 49.58,['h'] = 352.37, ['info'] = ' Cougar Ave 3', ['apt'] = 0 },
	[674] =  { ['x'] = -1344.6,['y'] = -140.8,['z'] = 49.58,['h'] = 348.0, ['info'] = ' Cougar Ave 4', ['apt'] = 0 },
	[675] =  { ['x'] = -1342.67,['y'] = -130.66,['z'] = 49.91,['h'] = 174.54, ['info'] = ' Cougar Ave 5', ['apt'] = 3 },
	[676] =  { ['x'] = -1346.72,['y'] = -129.88,['z'] = 49.99,['h'] = 174.31, ['info'] = ' Cougar Ave 6', ['apt'] = 3 },
	[677] =  { ['x'] = -1357.28,['y'] = -128.07,['z'] = 49.85,['h'] = 168.92, ['info'] = ' Cougar Ave 7', ['apt'] = 3 },
	[678] =  { ['x'] = -1361.52,['y'] = -127.29,['z'] = 49.85,['h'] = 175.05, ['info'] = ' Cougar Ave 8', ['apt'] = 3 },

	[679] =  { ['x'] = 798.39,['y'] = -158.81,['z'] = 74.9,['h'] = 57.07, ['info'] = ' Bridge Street 1', ['apt'] = 2 },
	[680] =  { ['x'] = 808.69,['y'] = -163.68,['z'] = 75.88,['h'] = 327.28, ['info'] = ' Bridge Street 2', ['apt'] = 0 },
	[681] =  { ['x'] = 820.7,['y'] = -156.28,['z'] = 80.76,['h'] = 62.13, ['info'] = ' Bridge Street 3', ['apt'] = 2 },
	[682] =  { ['x'] = 840.78,['y'] = -182.27,['z'] = 74.59,['h'] = 235.74, ['info'] = ' Bridge Street 4', ['apt'] = 2 },
	[683] =  { ['x'] = 846.1,['y'] = -173.19,['z'] = 78.47,['h'] = 237.25, ['info'] = ' Bridge Street 5', ['apt'] = 2 },
	[684] =  { ['x'] = 2727.85,['y'] = 4142.37,['z'] = 44.29,['h'] = 245.38, ['info'] = ' East Joshua Rd 3', ['trailer'] = 1, ['apt'] = 0 },
	[685] =  { ['x'] = 1880.43,['y'] = 3920.61,['z'] = 33.22,['h'] = 285.0, ['info'] = ' Niland Ave 1', ['apt'] = 0 },
	[686] =  { ['x'] = 1845.76,['y'] = 3914.55,['z'] = 33.47,['h'] = 101.96, ['info'] = ' Niland Ave 2', ['apt'] = 3 },
	[687] =  { ['x'] = 1661.35,['y'] = 3819.93,['z'] = 35.47,['h'] = 124.13, ['info'] = ' Mountain View Drive 1', ['trailer'] = 1, ['apt'] = 0 },
	[688] =  { ['x'] = 1859.47,['y'] = 3865.11,['z'] = 33.06,['h'] = 102.35, ['info'] = ' Niland Ave 3', ['apt'] = 3 },
	[689] =  { ['x'] = 1902.37,['y'] = 3866.89,['z'] = 33.07,['h'] = 26.71, ['info'] = ' Algonquin Blvd 1', ['trailer'] = 1, ['apt'] = 0  },
	[690] =  { ['x'] = 1925.05,['y'] = 3824.73,['z'] = 32.44,['h'] = 26.06, ['info'] = ' Niland Ave 4', ['apt'] = 0  },
	[691] =  { ['x'] = 1880.63,['y'] = 3810.42,['z'] = 32.78,['h'] = 116.47, ['info'] = ' Niland Ave 5', ['trailer'] = 1, ['apt'] = 0 },
	[692] =  { ['x'] = 1781.64,['y'] = 3911.24,['z'] = 34.92,['h'] = 200.61, ['info'] = ' Marina Drive 1', ['trailer'] = 1, ['apt'] = 0 },
	[693] =  { ['x'] = 1915.83,['y'] = 3909.24,['z'] = 33.45,['h'] = 57.4, ['info'] = ' Marina Drive 2', ['trailer'] = 1, ['apt'] = 0 },
	[694] =  { ['x'] = 1777.52,['y'] = 3799.98,['z'] = 34.53,['h'] = 300.82, ['info'] = ' Armadillo Ave 1', ['trailer'] = 1, ['apt'] = 0 },
	[695] =  { ['x'] = 115.67,['y'] = -1685.63,['z'] = 33.5,['h'] = 48.01, ['info'] = ' Carson Ave/ Apt 1', ['apt'] = 1 },
	[696] =  { ['x'] = 1425.71,['y'] = 3669.59,['z'] = 34.83,['h'] = 197.82, ['info'] = ' Marina Dr 12', ['trailer'] = 1 },
	[697] =  { ['x'] = 1809.93,['y'] = 3907.17,['z'] = 33.81,['h'] = 299.31, ['info'] = ' Cholla Springs Ave 1', ['apt'] = 3 },
	[698] =  { ['x'] = 1936.66,['y'] = 3891.56,['z'] = 32.75,['h'] = 35.61, ['info'] = ' Algonquin Blvd 2', ['trailer'] = 1 },
	[699] =  { ['x'] = 1832.66,['y'] = 3868.5,['z'] = 34.3,['h'] = 294.36, ['info'] = ' Cholla Springs Ave 2', ['trailer'] = 1 },
	[700] =  { ['x'] = 1813.66,['y'] = 3854.0,['z'] = 34.36,['h'] = 202.61, ['info'] = ' Cholla Springs Ave 3', ['trailer'] = 1 },
	[701] =  { ['x'] = 1763.76,['y'] = 3823.56,['z'] = 34.77,['h'] = 213.05, ['info'] = ' Cholla Springs Ave 4', ['trailer'] = 1 },
	[702] =  { ['x'] = 1728.46,['y'] = 3851.8,['z'] = 34.79,['h'] = 39.05, ['info'] = ' Cholla Springs Ave 5', ['apt'] = 2 },
	[703] =  { ['x'] = 1733.6,['y'] = 3808.7,['z'] = 35.12,['h'] = 211.81, ['info'] = ' Cholla Springs Ave 6', ['apt'] = 2 },
	[704] =  { ['x'] = 98.15,['y'] = -1307.23,['z'] = 35.39,['h'] = 300.53, ['info'] = ' VU Pimphouse', ['apt'] = 1 },
	[705] =  { ['x'] = -728.48,['y'] = -879.92,['z'] = 22.72,['h'] = 268.36, ['info'] = ' Ginger St 2', ['apt'] = 3  },
	[706] =  { ['x'] = -719.15,['y'] = -897.76,['z'] = 20.68,['h'] = 92.46, ['info'] = ' Ginger St 3', ['apt'] = 3  },
	[707] =  { ['x'] = -716.42,['y'] = -864.73,['z'] = 23.21,['h'] = 82.5, ['info'] = ' Ginger St 4', ['apt'] = 3  },
	[708] =  { ['x'] = -731.71,['y'] = -693.62,['z'] = 30.38,['h'] = 266.73, ['info'] = ' Ginger St 5', ['apt'] = 3 },
	[709] =  { ['x'] = -714.65,['y'] = -676.31,['z'] = 30.63,['h'] = 179.89, ['info'] = ' Ginger St 6', ['apt'] = 3 },
	[710] =  { ['x'] = -710.91,['y'] = -724.23,['z'] = 28.8,['h'] = 66.07, ['info'] = ' Ginger St 7', ['apt'] = 3 },
	[711] =  { ['x'] = -691.48,['y'] = -722.75,['z'] = 33.93,['h'] = 356.44, ['info'] = ' Ginger St 6B', ['apt'] = 3 },
	[712] =  { ['x'] = -714.95,['y'] = -712.73,['z'] = 29.28,['h'] = 1.12, ['info'] = ' Ginger St 5B', ['apt'] = 3 },
	[713] =  { ['x'] = 3310.85,['y'] = 5176.43,['z'] = 19.62,['h'] = 53.41, ['info'] = ' La Casa De Jubilación #1',['apt'] = 3 },
	[714] =  { ['x'] = -1354.14,['y'] = -777.16,['z'] = 20.68,['h'] = 218.44, ['info'] = ' Bay City Ave #1',['apt'] = 0 },

	[715] =  { ['x'] = 1203.24,['y'] = -1670.67,['z'] = 42.99,['h'] = 37.37, ['info'] = ' Innocence Blvd #1' ,['apt'] = 0 },
	[716] =  { ['x'] = 1220.24,['y'] = -1658.75,['z'] = 48.65,['h'] = 31.29, ['info'] = ' Innocence Blvd #2' ,['apt'] = 0 },
	[717] =  { ['x'] = 1252.8,['y'] = -1638.49,['z'] = 53.18,['h'] = 31.61, ['info'] = ' Innocence Blvd #3' ,['apt'] = 0 },
	[718] =  { ['x'] = 1276.43,['y'] = -1628.83,['z'] = 54.74,['h'] = 35.35, ['info'] = ' Innocence Blvd #4' ,['apt'] = 0 },
	[719] =  { ['x'] = 1297.21,['y'] = -1618.03,['z'] = 54.58,['h'] = 19.41, ['info'] = ' Innocence Blvd #5' ,['apt'] = 0 },
}


robbablesMansion = {
	[1] = { ["x"] = -5.67645700, ["y"] = 9.23738900, ["z"] = 4.58609800, ["name"] = "bed table" },
	[2] = { ["x"] = -1.28456500, ["y"] = -1.86961300, ["z"] = 0.92229600, ["name"] = "jewel box" },
	[3] = { ["x"] = -0.82748790, ["y"] = -0.20085050, ["z"] = 5.66071400, ["name"] = "jewel box" },
	[4] = { ["x"] = 2.19403800, ["y"] = 6.81445700, ["z"] = 0.98931310, ["name"] = "jewel box" },
	[5] = { ["x"] = 14.36221000, ["y"] = 6.14473800, ["z"] = 1.44332300, ["name"] = "cupboard" },
	[6] = { ["x"] = -2.89582400, ["y"] = 9.22972300, ["z"] = 4.58609800, ["name"] = "bed table" },
	[7] = { ["x"] = 13.48880000, ["y"] = 9.39807700, ["z"] = 1.50317400, ["name"] = "cupboard" },
	[8] = { ["x"] = 9.14163700, ["y"] = 9.39807700, ["z"] = 1.50319300, ["name"] = "cupboard" },
	[9] = { ["x"] = 5.60166200, ["y"] = -7.84856600, ["z"] = 5.57709100, ["name"] = "jewel box" },
	[10] = { ["x"] = 6.33438800, ["y"] = -7.96820100, ["z"] = 4.57700000, ["name"] = "drawers" },
	[11] = { ["x"] = 3.50600100, ["y"] = -3.73348200, ["z"] = 4.57736500, ["name"] = "bed table" },	
	[12] = { ["x"] = 0.53466320, ["y"] = -7.69714400,["z"] = 5.40757800, ["name"] = "table" },	
	[13] = { ["x"] = -2.72426300, ["y"] = -4.61612700,["z"] = 4.70186500, ["name"] = "clutter" },	
	[14] = { ["x"] = -1.77334100, ["y"] = -3.80492700,["z"] = 4.60178600, ["name"] = "under bed" },		
}
robbables2 = {
	[1] = { ["x"] = 1.90339700, ["y"] = -3.80026800, ["z"] = 1.29917900, ["name"] = "fridge" },
	[2] = { ["x"] = -3.50363200, ["y"] = -6.55289400, ["z"] = 1.30625800, ["name"] = "drawers" },
	[3] = { ["x"] = -3.50712600, ["y"] = -4.13621600, ["z"] = 1.29625800, ["name"] = "table" },
	[4] = { ["x"] = 8.47819500, ["y"] = -2.50979300, ["z"] = 1.19712300, ["name"] = "storage" },
	[5] = { ["x"] = 9.75982700, ["y"] = -1.35874100, ["z"] = 1.29625800, ["name"] = "storage" },
	[6] = { ["x"] = 8.46626300, ["y"] = 4.53223600, ["z"] = 1.19425800, ["name"] = "wardrobe" },
	[7] = { ["x"] = 5.84416200, ["y"] = 2.57377400, ["z"] = 1.22089100, ["name"] = "table" },
	[8] = { ["x"] = 3.04164100, ["y"] = 0.31671810, ["z"] = 3.58363900, ["name"] = "jewelry" },
	[9] = { ["x"] = 6.86376900, ["y"] = 1.20651200, ["z"] = 1.36589100, ["name"] = "under bed" },
	[10] = { ["x"] = 2.03442400, ["y"] = -5.61585100, ["z"] = 3.30395600, ["name"] = "cupboards" },
	[11] = { ["x"] = -5.53120400, ["y"] = 0.76299670, ["z"] = 1.77236000, ["name"] = "cabinet" },
	[12] = { ["x"] = -1.24716200, ["y"] = 1.07820500, ["z"] = 1.69089300, ["name"] = "coffee table" },
	[13] = { ["x"] = 2.91325400, ["y"] = -4.2783510, ["z"] = 1.82746400, ["name"] = "table" },
}

-- 1-7 rare, 42-44 very rare
itemdrops = {
	[1] = { ["id"] = 1, ["info"] = {"Weed Ounce",350,0.25,"i",false,false} },
	[2] = { ["id"] = 38, ["info"] = {"Gun Part",1800,4.4,"i",false,false} },
	[3] = { ["id"] = 7, ["info"]= {"Cocaine Bag",350,0.25,"i",false,false} },
	[4] = { ["id"] = 9, ["info"]= {"Money Ink Set",350,0.25,"i",false,false} },
	[5] = { ["id"] = 22, ["info"] = {"Hand Cuffs",250,1,"i",false,false} },
	[6] = { ["id"] = 24, ["info"] = {"Oxygen Tank",300,1,"i",false,false} },
    -- White pearl used as Money trade in , cannot find another use as of yet
	[7] = { ["id"] = 25, ["info"] = {"White Pearl",0,1,"m",false,true} },
    -- All Meterials Currently 
	[8] = { ["id"] = 4, ["info"]= {"Gold Bar",21,2,"m",false,true} },
	[9] = { ["id"] = 5, ["info"]= {"Wood",15,2,"m",false,true} },
	[10] = { ["id"] = 26, ["info"] = {"Scrap Metal",250,2,"m",false,true} },
	[11] = { ["id"] = 27, ["info"] = {"Plastic",11,1,"m",false,true} },
	[12] = { ["id"] = 28, ["info"] = {"Glass",12,1,"m",false,true} },
	[13] = { ["id"] = 30, ["info"] = {"Steel",45,5.5,"m",false,true} },
	[14] = { ["id"] = 31, ["info"] = {"Aluminium",50,2.0,"m",false,true} },
	[15] = { ["id"] = 32, ["info"] = {"Dye",20,0.6,"m",false,true} },
	[16] = { ["id"] = 33, ["info"] = {"Rubber",20,1.2,"m",false,true} },
	[17] = { ["id"] = 34, ["info"] = {"Copper",25,1.6,"m",false,true} },
	[18] = { ["id"] = 35, ["info"] = {"Electronics",25,0.8,"m",false,true} },
	[19] = { ["id"] = 70, ["info"] = {"Cleaning goods",500,3.0,"i",false,true} },
	[20] = { ["id"] = 72, ["info"] = {"Pistol Ammo x30",25,3.0,"i",false,true} },
	[21] = { ["id"] = 73, ["info"] = {"Rifle Ammo x30",100,7.0,"i",false,false} },
	[22] = { ["id"] = 74, ["info"] = {"Shotgun Ammo x30",100,7.0,"i",false,false} },
	[23] = { ["id"] = 45, ["info"] = {"Oil",300,1.3,"i",false,false} }, -- Shop
	[24] = { ["id"] = 46, ["info"] = {"Nitrous Oxide",300,10.0,"i",false,false} },
	[25] = { ["id"] = 47, ["info"] = {"Iron Oxide",200,3.5,"m",false,false} }, -- Gang task A / 10% chance of spawn
	[26] = { ["id"] = 48, ["info"] = {"Aluminium Oxide",200,1.5,"m",false,false} }, -- Gang task B / 14% chance of spawn
	[27] = { ["id"] = 49, ["info"] = {"Fuse",30,0.1,"i",false,false} }, -- Crafting
	[28] = { ["id"] = 50, ["info"] = {"Clutch",350,5.0,"i",false,false} }, -- Gang task A / 35% chance of spawn
	[29] = { ["id"] = 51, ["info"] = {"Drill Bit",100,2.0,"i",false,false} }, -- Gang task C / 40% chance of spawn
	[30] = { ["id"] = 52, ["info"] = {"Battery",10,1.0,"i",false,false} },    -- Gang Task B / 60% chance of spawn
	[31] = { ["id"] = 53, ["info"] = {"Breadboard",60,0.6,"i",false,false} }, -- Gang Task B / 60% chance of spawn
	[32] = { ["id"] = 69, ["info"] = {"Food goods",500,3.0,"i",false,true} },
	[33] = { ["id"] = 57, ["info"] = {"Green Cow Energy Drink",1200,3.0,"i",false,true} },
	[34] = { ["id"] = 58, ["info"] = {"Chest Armor",1200,30.0,"i",false,true} },
	[35] = { ["id"] = 59, ["info"] = {"Radio Scanner",1500,15.0,"i",false,true} },
	[36] = { ["id"] = 60, ["info"] = {"Advanced Lock Pick",500,3.0,"i",false,false} }, -- crafted
	[37] = { ["id"] = 62, ["info"] = {"Cigarette",10,0.2,"i",false,true} },
	[38] = { ["id"] = 75, ["info"] = {"Sub-Machinegun Ammo x30",100,5.0,"i",false,false} },
	[39] = { ["id"] = 66, ["info"] = {"Mobile Phone",1000,1.0,"i",false,true} },
	[40] = { ["id"] = 67, ["info"] = {"Radio",1000,3.0,"i",false,true} },
	[41] = { ["id"] = 68, ["info"] = {"Umbrella",500,3.0,"i",false,true} },
	[42] = { ["id"] = 76, ["info"] = {"Unknown USB Device",300,1.0,"i",false,true} },
	[43] = { ["id"] = 78, ["info"] = {"Decrypter MK 1",300,3.0,"i",false,true} },
	[44] = { ["id"] = 79, ["info"] = {"Decrypter MK 2",300,3.0,"i",false,true} },
}  


robberyExitCoordsMansions = {
	[1] = { ['x'] = 9.24863, ['y'] = 396.906, ['z'] = 120.289, ['h'] = 214.0 },
	[2] = { ['x'] = -102.626, ['y'] = 452.67, ['z'] = 117.883, ['h'] = 346.0 },
	[3] = { ['x'] = -163.974, ['y'] = 404.316, ['z'] = 111.423, ['h'] = 190.0 },
	[4] = { ['x'] = 33.3112, ['y'] = 382.784, ['z'] = 116.509, ['h'] = 38.0 },
	[5] = { ['x'] = -200.356, ['y'] = 382.65, ['z'] = 109.492, ['h'] = 191.0 },
	[6] = { ['x'] = -238.975, ['y'] = 364.382, ['z'] = 110.832, ['h'] = 133.0 },
	[7] = { ['x'] = -296.969, ['y'] = 360.887, ['z'] = 109.746, ['h'] = 187.0 },
	[8] = { ['x'] = -320.307, ['y'] = 354.927, ['z'] = 110.016, ['h'] = 197.0 },
	[9] = { ['x'] = -369.133, ['y'] = 330.685, ['z'] = 109.943, ['h'] = 178.0 },
	[10] = { ['x'] = -407.714, ['y'] = 324.684, ['z'] = 108.718, ['h'] = 182.0 },
	[11] = { ['x'] = -446.425, ['y'] = 328.708, ['z'] = 104.823, ['h'] = 198.0 },
	[12] = { ['x'] = -484.874, ['y'] = 345.783, ['z'] = 104.146, ['h'] = 66.0 },
	[13] = { ['x'] = -310.648, ['y'] = 420.123, ['z'] = 109.883, ['h'] = 189.0 },
	[14] = { ['x'] = -344.39, ['y'] = 400.142, ['z'] = 110.593, ['h'] = 208.0 },
	[15] = { ['x'] = -412.903, ['y'] = 437.12, ['z'] = 112.406, ['h'] = 154.0 },
	[16] = { ['x'] = -447.822, ['y'] = 378.629, ['z'] = 108.869, ['h'] = 184.0 },
	[17] = { ['x'] = -477.176, ['y'] = 424.709, ['z'] = 103.122, ['h'] = 8.0 },
	[18] = { ['x'] = -504.334, ['y'] = 388.046, ['z'] = 97.4062, ['h'] = 61.0 },
	[19] = { ['x'] = -498.749, ['y'] = 437.544, ['z'] = 97.2872, ['h'] = 316.0 },
	[20] = { ['x'] = -561.359, ['y'] = 386.162, ['z'] = 101.289, ['h'] = 193.0 },
	[21] = { ['x'] = -597.38, ['y'] = 375.935, ['z'] = 97.8495, ['h'] = 180.0 },
	[22] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[23] = { ['x'] = 219.274, ['y'] = 491.756, ['z'] = 140.697, ['h'] = 263.0 },
	[24] = { ['x'] = -497.476, ['y'] = 524.18, ['z'] = 116.763, ['h'] = 165.0 },
	[25] = { ['x'] = 119.764, ['y'] = 504.062, ['z'] = 155.148, ['h'] = 319.0 },
	[26] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[27] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[28] = { ['x'] = 39.6699, ['y'] = 435.325, ['z'] = 146.775, ['h'] = 155.0 },
	[29] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[30] = { ['x'] = -26.6184, ['y'] = 455.283, ['z'] = 141.731, ['h'] = 162.0 },
	[31] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[32] = { ['x'] = -106.436, ['y'] = 491.2, ['z'] = 137.031, ['h'] = 169.0 },
	[33] = { ['x'] = -166.133, ['y'] = 477.207, ['z'] = 133.878, ['h'] = 195.0 },
	[34] = { ['x'] = -225.175, ['y'] = 477.398, ['z'] = 128.427, ['h'] = 205.0 },
	[35] = { ['x'] = -1908.72, ['y'] = 129.682, ['z'] = 82.4507, ['h'] = 125.0 },
	[36] = { ['x'] = 233.686, ['y'] = 643.62, ['z'] = 186.399, ['h'] = 226.0 },
	[37] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[38] = { ['x'] = 163.086, ['y'] = 552.949, ['z'] = 182.342, ['h'] = 183.0 },
	[39] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[40] = { ['x'] = 99.6028, ['y'] = 550.055, ['z'] = 181.498, ['h'] = 190.0 },
	[41] = { ['x'] = 52.7842, ['y'] = 544.641, ['z'] = 175.853, ['h'] = 195.0 },
	[42] = { ['x'] = 21.9587, ['y'] = 535.863, ['z'] = 170.628, ['h'] = 114.0 },
	[43] = { ['x'] = 232.407, ['y'] = 747.157, ['z'] = 203.702, ['h'] = 230.0 },
	[44] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[45] = { ['x'] = -186.877, ['y'] = 570.392, ['z'] = 189.77, ['h'] = 179.0 },
	[46] = { ['x'] = -199.5, ['y'] = 636.61, ['z'] = 199.639, ['h'] = 1.0 },
	[47] = { ['x'] = -231.478, ['y'] = 574.81, ['z'] = 185.658, ['h'] = 178.0 },
	[48] = { ['x'] = -233.508, ['y'] = 621.67, ['z'] = 187.81, ['h'] = 316.0 },
	[49] = { ['x'] = -281.694, ['y'] = 580.345, ['z'] = 177.738, ['h'] = 173.0 },
	[50] = { ['x'] = -293.924, ['y'] = 650.211, ['z'] = 175.694, ['h'] = 285.0 },
	[51] = { ['x'] = -346.269, ['y'] = 687.07, ['z'] = 172.539, ['h'] = 350.0 },
	[52] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[53] = { ['x'] = -400.021, ['y'] = 640.22, ['z'] = 159.466, ['h'] = 182.0 },
	[54] = { ['x'] = -443.234, ['y'] = 696.243, ['z'] = 153.229, ['h'] = 297.0 },
	[55] = { ['x'] = -483.217, ['y'] = 633.964, ['z'] = 144.384, ['h'] = 193.0 },
	[56] = { ['x'] = -609.038, ['y'] = 540.864, ['z'] = 111.321, ['h'] = 15.0 },
	[57] = { ['x'] = -599.729, ['y'] = 481.132, ['z'] = 109.014, ['h'] = 101.0 },
	[58] = { ['x'] = -624.838, ['y'] = 470.603, ['z'] = 108.858, ['h'] = 186.0 },
	[59] = { ['x'] = -638.839, ['y'] = 540.722, ['z'] = 109.716, ['h'] = 8.0 },
	[60] = { ['x'] = -657.619, ['y'] = 462.883, ['z'] = 110.39, ['h'] = 193.0 },
	[61] = { ['x'] = -677.575, ['y'] = 522.413, ['z'] = 110.316, ['h'] = 16.0 },
	[62] = { ['x'] = -741.65, ['y'] = 506.696, ['z'] = 110.182, ['h'] = 22.0 },
	[63] = { ['x'] = -710.481, ['y'] = 440.604, ['z'] = 107.049, ['h'] = 202.0 },
	[64] = { ['x'] = -788.291, ['y'] = 465.12, ['z'] = 100.172, ['h'] = 30.0 },
	[65] = { ['x'] = -747.262, ['y'] = 410.115, ['z'] = 96.0174, ['h'] = 197.0 },
	[66] = { ['x'] = -833.23, ['y'] = 406.064, ['z'] = 91.5597, ['h'] = 187.0 },
	[67] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[68] = { ['x'] = -545.023, ['y'] = 694.791, ['z'] = 146.074, ['h'] = 305.0 },
	[69] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[70] = { ['x'] = -714.705, ['y'] = 696.683, ['z'] = 158.031, ['h'] = 186.0 },
	[71] = { ['x'] = -657.472, ['y'] = 728.777, ['z'] = 174.285, ['h'] = 191.0 },
	[72] = { ['x'] = -601.678, ['y'] = 712.455, ['z'] = 180.007, ['h'] = 177.0 },
	[73] = { ['x'] = -609.017, ['y'] = 771.849, ['z'] = 188.51, ['h'] = 164.0 },
	[74] = { ['x'] = -608.857, ['y'] = 771.678, ['z'] = 188.51, ['h'] = 166.0 },
	[75] = { ['x'] = -578.085, ['y'] = 812.272, ['z'] = 191.547, ['h'] = 283.0 },
	[76] = { ['x'] = -668.206, ['y'] = 797.354, ['z'] = 198.998, ['h'] = 91.0 },
	[77] = { ['x'] = -746.083, ['y'] = 796.373, ['z'] = 214.571, ['h'] = 188.0 },
	[78] = { ['x'] = -818.364, ['y'] = 796.103, ['z'] = 202.586, ['h'] = 200.0 },
	[79] = { ['x'] = -859.517, ['y'] = 767.31, ['z'] = 191.822, ['h'] = 182.0 },
	[80] = { ['x'] = -907.07, ['y'] = 753.177, ['z'] = 182.161, ['h'] = 184.0 },
	[81] = { ['x'] = -931.321, ['y'] = 826.367, ['z'] = 184.337, ['h'] = 354.0 },
	[82] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[83] = { ['x'] = -1008.68, ['y'] = 831.368, ['z'] = 172.451, ['h'] = 43.0 },
	[84] = { ['x'] = -954.28, ['y'] = 736.54, ['z'] = 175.559, ['h'] = 222.0 },
	[85] = { ['x'] = -1052.7, ['y'] = 818.676, ['z'] = 166.991, ['h'] = 4.0 },
	[86] = { ['x'] = -1097.35, ['y'] = 823.841, ['z'] = 168.638, ['h'] = 12.0 },
	[87] = { ['x'] = -1107.22, ['y'] = 738.891, ['z'] = 159.916, ['h'] = 201.0 },
	[88] = { ['x'] = -1144.9, ['y'] = 719.063, ['z'] = 155.671, ['h'] = 226.0 },
	[89] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[90] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[91] = { ['x'] = -1255.31, ['y'] = 667.106, ['z'] = 142.822, ['h'] = 203.0 },
	[92] = { ['x'] = -1233.95, ['y'] = 636.047, ['z'] = 142.745, ['h'] = 202.0 },
	[93] = { ['x'] = -1283.25, ['y'] = 663.324, ['z'] = 144.849, ['h'] = 285.0 },
	[94] = { ['x'] = -1271.38, ['y'] = 628.783, ['z'] = 143.23, ['h'] = 305.0 },
	[95] = { ['x'] = -1381.39, ['y'] = 528.401, ['z'] = 123.017, ['h'] = 248.0 },
	[96] = { ['x'] = -1409.06, ['y'] = 446.177, ['z'] = 112.22, ['h'] = 166.0 },
	[97] = { ['x'] = -1347.08, ['y'] = 442.319, ['z'] = 100.994, ['h'] = 260.0 },
	[98] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[99] = { ['x'] = -1332.54, ['y'] = 490.902, ['z'] = 102.448, ['h'] = 357.0 },
	[100] = { ['x'] = -1253.12, ['y'] = 433.049, ['z'] = 95.1852, ['h'] = 219.0 },
	[101] = { ['x'] = -1224.66, ['y'] = 439.9, ['z'] = 85.6166, ['h'] = 177.0 },
	[102] = { ['x'] = -1161.01, ['y'] = 435.339, ['z'] = 86.6364, ['h'] = 265.0 },
	[103] = { ['x'] = -1161.58, ['y'] = 499.77, ['z'] = 86.0938, ['h'] = 1.0 },
	[104] = { ['x'] = -1113.44, ['y'] = 504.418, ['z'] = 82.2875, ['h'] = 345.0 },
	[105] = { ['x'] = -1066.33, ['y'] = 482.486, ['z'] = 85.3016, ['h'] = 59.0 },
	[106] = { ['x'] = -1105.3, ['y'] = 429.796, ['z'] = 75.88, ['h'] = 84.0 },
	[107] = { ['x'] = -1036.75, ['y'] = 443.469, ['z'] = 72.8639, ['h'] = 278.0 },
	[108] = { ['x'] = -1059.73, ['y'] = 515.632, ['z'] = 84.3811, ['h'] = 38.0 },
	[109] = { ['x'] = -1013.72, ['y'] = 457.103, ['z'] = 79.3645, ['h'] = 239.0 },
	[110] = { ['x'] = -1007.25, ['y'] = 531.34, ['z'] = 79.7712, ['h'] = 68.0 },
	[111] = { ['x'] = -984.774, ['y'] = 476.088, ['z'] = 82.4608, ['h'] = 184.0 },
	[112] = { ['x'] = -956.359, ['y'] = 526.95, ['z'] = 81.6716, ['h'] = 322.0 },
	[113] = { ['x'] = -983.267, ['y'] = 442.307, ['z'] = 79.9715, ['h'] = 108.0 },
	[114] = { ['x'] = -933.096, ['y'] = 472.269, ['z'] = 85.1206, ['h'] = 284.0 },
	[115] = { ['x'] = -873.866, ['y'] = 353.771, ['z'] = 85.2853, ['h'] = 180.0 },
	[116] = { ['x'] = -889.402, ['y'] = 310.611, ['z'] = 84.1299, ['h'] = 55.0 },
	[117] = { ['x'] = -806.847, ['y'] = 253.298, ['z'] = 82.7961, ['h'] = 274.0 },
	[118] = { ['x'] = -1673.47, ['y'] = 372.078, ['z'] = 85.119, ['h'] = 166.0 },
	[119] = { ['x'] = -1742.07, ['y'] = 365.231, ['z'] = 88.7283, ['h'] = 125.0 },
	[120] = { ['x'] = -1771.36, ['y'] = 342.321, ['z'] = 89.3714, ['h'] = 205.0 },
	[121] = { ['x'] = -1861.27, ['y'] = 310.455, ['z'] = 89.1144, ['h'] = 104.0 },
	[122] = { ['x'] = -1878.02, ['y'] = 652.328, ['z'] = 130.0, ['h'] = 310.0 },
	[123] = { ['x'] = -1994.22, ['y'] = 639.763, ['z'] = 122.536, ['h'] = 61.0 },
	[124] = { ['x'] = -1917.27, ['y'] = 592.333, ['z'] = 122.125, ['h'] = 243.0 },
	[125] = { ['x'] = -2009.59, ['y'] = 591.366, ['z'] = 118.102, ['h'] = 72.0 },
	[126] = { ['x'] = -1923.6, ['y'] = 544.192, ['z'] = 114.82, ['h'] = 248.0 },
	[127] = { ['x'] = -2036.74, ['y'] = 496.19, ['z'] = 107.012, ['h'] = 69.0 },
	[128] = { ['x'] = -2018.15, ['y'] = 434.141, ['z'] = 102.674, ['h'] = 191.0 },
	[129] = { ['x'] = -1932.08, ['y'] = 452.521, ['z'] = 102.703, ['h'] = 269.0 },
	[130] = { ['x'] = -1931.59, ['y'] = 398.633, ['z'] = 96.5071, ['h'] = 275.0 },
	[131] = { ['x'] = -2020.42, ['y'] = 370.051, ['z'] = 94.5785, ['h'] = 56.0 },
	[132] = { ['x'] = -1918.7, ['y'] = 367.626, ['z'] = 93.9763, ['h'] = 266.0 },
	[133] = { ['x'] = -1907.1, ['y'] = 294.036, ['z'] = 88.6077, ['h'] = 175.0 },
	[134] = { ['x'] = -1998.72, ['y'] = 313.762, ['z'] = 91.5606, ['h'] = 10.0 },
	[135] = { ['x'] = -1981.31, ['y'] = 244.1, ['z'] = 87.6132, ['h'] = 105.0 },
	[136] = { ['x'] = -1895.16, ['y'] = 261.188, ['z'] = 86.4532, ['h'] = 294.0 },
	[137] = { ['x'] = -1974.5, ['y'] = 198.575, ['z'] = 86.5972, ['h'] = 113.0 },
	[138] = { ['x'] = -1944.15, ['y'] = 150.87, ['z'] = 84.6527, ['h'] = 127.0 },
	[139] = { ['x'] = -1846.05, ['y'] = 203.009, ['z'] = 84.4393, ['h'] = 123.0 },
	[140] = { ['x'] = -1289.04, ['y'] = 500.734, ['z'] = 97.5598, ['h'] = 69.0 },
	[141] = { ['x'] = -1201.08, ['y'] = 503.266, ['z'] = 98.9964, ['h'] = 229.0 },
	[142] = { ['x'] = -1201.09, ['y'] = 581.729, ['z'] = 100.13, ['h'] = 359.0 },
	[143] = { ['x'] = -1164.33, ['y'] = 588.457, ['z'] = 101.833, ['h'] = 9.0 },
	[144] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[145] = { ['x'] = -1124.08, ['y'] = 531.423, ['z'] = 98.3818, ['h'] = 195.0 },
	[146] = { ['x'] = -1123.09, ['y'] = 600.907, ['z'] = 104.36, ['h'] = 23.0 },
	[147] = { ['x'] = -1069.0, ['y'] = 561.994, ['z'] = 102.73, ['h'] = 294.0 },
	[148] = { ['x'] = -1032.63, ['y'] = 565.741, ['z'] = 100.515, ['h'] = 183.0 },
	[149] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[150] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[151] = { ['x'] = -957.953, ['y'] = 549.023, ['z'] = 101.701, ['h'] = 154.0 },
	[152] = { ['x'] = -940.313, ['y'] = 540.878, ['z'] = 103.581, ['h'] = 147.0 },
	[153] = { ['x'] = -887.68, ['y'] = 584.497, ['z'] = 101.192, ['h'] = 232.0 },
	[154] = { ['x'] = -921.383, ['y'] = 535.617, ['z'] = 96.014, ['h'] = 136.0 },
	[155] = { ['x'] = -856.906, ['y'] = 563.557, ['z'] = 96.6216, ['h'] = 312.0 },
	[156] = { ['x'] = -898.491, ['y'] = 518.151, ['z'] = 92.2289, ['h'] = 103.0 },
	[157] = { ['x'] = -832.574, ['y'] = 512.656, ['z'] = 94.6172, ['h'] = 280.0 },
	[158] = { ['x'] = -866.953, ['y'] = 457.584, ['z'] = 88.2811, ['h'] = 190.0 },
	[159] = { ['x'] = -829.663, ['y'] = 477.961, ['z'] = 90.1653, ['h'] = 273.0 },
	[160] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[161] = { ['x'] = -717.107, ['y'] = 564.141, ['z'] = 142.386, ['h'] = 173.0 },
	[162] = { ['x'] = -745.863, ['y'] = 589.555, ['z'] = 142.615, ['h'] = 60.0 },
	[163] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[164] = { ['x'] = -789.09, ['y'] = 650.316, ['z'] = 139.264, ['h'] = 125.0 },
	[165] = { ['x'] = -809.564, ['y'] = 674.579, ['z'] = 147.29, ['h'] = 199.0 },
	[166] = { ['x'] = -855.745, ['y'] = 669.56, ['z'] = 152.451, ['h'] = 178.0 },
	[167] = { ['x'] = -886.418, ['y'] = 672.841, ['z'] = 151.101, ['h'] = 175.0 },
	[168] = { ['x'] = -914.792, ['y'] = 669.017, ['z'] = 155.282, ['h'] = 183.0 },
	[169] = { ['x'] = -944.247, ['y'] = 666.458, ['z'] = 153.573, ['h'] = 173.0 },
	[170] = { ['x'] = -970.132, ['y'] = 663.949, ['z'] = 158.228, ['h'] = 89.0 },
	[171] = { ['x'] = -1021.61, ['y'] = 664.754, ['z'] = 161.294, ['h'] = 182.0 },
	[172] = { ['x'] = -1058.51, ['y'] = 712.582, ['z'] = 165.594, ['h'] = 111.0 },
	[173] = { ['x'] = -1069.84, ['y'] = 749.546, ['z'] = 168.047, ['h'] = 87.0 },
	[174] = { ['x'] = -643.332, ['y'] = 874.418, ['z'] = 224.594, ['h'] = 307.0 },
	[175] = { ['x'] = -611.887, ['y'] = 847.493, ['z'] = 211.502, ['h'] = 139.0 },
	[176] = { ['x'] = -539.926, ['y'] = 801.903, ['z'] = 197.51, ['h'] = 151.0 },
	[177] = { ['x'] = -489.479, ['y'] = 783.344, ['z'] = 180.535, ['h'] = 169.0 },
	[178] = { ['x'] = -498.507, ['y'] = 753.593, ['z'] = 170.835, ['h'] = 14.0 },
	[179] = { ['x'] = -525.429, ['y'] = 722.415, ['z'] = 161.594, ['h'] = 1.0 },
	[180] = { ['x'] = -498.978, ['y'] = 700.691, ['z'] = 151.259, ['h'] = 3.0 },
	[181] = { ['x'] = -542.253, ['y'] = 627.312, ['z'] = 137.855, ['h'] = 118.0 },
	[182] = { ['x'] = -450.872, ['y'] = 587.372, ['z'] = 128.069, ['h'] = 268.0 },
	[183] = { ['x'] = -542.395, ['y'] = 577.358, ['z'] = 117.316, ['h'] = 89.0 },
	[184] = { ['x'] = -556.578, ['y'] = 552.617, ['z'] = 110.522, ['h'] = 348.0 },
	[185] = { ['x'] = -510.427, ['y'] = 503.413, ['z'] = 112.439, ['h'] = 220.0 },
	[186] = { ['x'] = -532.621, ['y'] = 464.72, ['z'] = 103.194, ['h'] = 149.0 },
	[187] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[188] = { ['x'] = 259.575, ['y'] = -782.76, ['z'] = 30.518, ['h'] = 53.0 },
	[189] = { ['x'] = 260.99, ['y'] = -1004.99, ['z'] = 61.6346, ['h'] = 153.0 },
	[190] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[191] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[192] = { ['x'] = 123.852, ['y'] = -1039.64, ['z'] = 29.2118, ['h'] = 161.0 },
	[193] = { ['x'] = 83.8308, ['y'] = -855.085, ['z'] = 30.7698, ['h'] = 69.0 },
	[194] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[195] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[196] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[197] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[198] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[199] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[200] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[201] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[202] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[203] = { ['x'] = -289.411, ['y'] = 303.25, ['z'] = 90.7184, ['h'] = 358.0 },
	[204] = { ['x'] = -348.406, ['y'] = 179.068, ['z'] = 87.918, ['h'] = 178.0 },
	[205] = { ['x'] = -623.207, ['y'] = 311.88, ['z'] = 83.9285, ['h'] = 255.0 },
	[206] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[207] = { ['x'] = -729.856, ['y'] = 321.271, ['z'] = 86.78, ['h'] = 84.0 },
	[208] = { ['x'] = -784.225, ['y'] = 351.657, ['z'] = 87.9982, ['h'] = 359.0 },
	[209] = { ['x'] = -753.214, ['y'] = 275.973, ['z'] = 85.7562, ['h'] = 96.0 },
	[210] = { ['x'] = -669.732, ['y'] = 214.22, ['z'] = 81.9552, ['h'] = 289.0 },
	[211] = { ['x'] = -286.839, ['y'] = 482.213, ['z'] = 113.201, ['h'] = 299.0 },
	[212] = { ['x'] = -369.282, ['y'] = 468.074, ['z'] = 112.462, ['h'] = 100.0 },
	[213] = { ['x'] = -337.886, ['y'] = 529.252, ['z'] = 120.149, ['h'] = 316.0 },
	[214] = { ['x'] = -401.036, ['y'] = 491.448, ['z'] = 120.299, ['h'] = 151.0 },
	[215] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[216] = { ['x'] = -440.16, ['y'] = 519.96, ['z'] = 122.159, ['h'] = 131.0 },
	[217] = { ['x'] = -408.427, ['y'] = 583.4, ['z'] = 124.627, ['h'] = 330.0 },
	[218] = { ['x'] = -471.6, ['y'] = 524.021, ['z'] = 125.728, ['h'] = 175.0 }
}




robberyExitCoords = {
	[1] = { ['x'] = 1050.16, ['y'] = -369.431, ['z'] = 68.2395, ['h'] = 36.0 },
	[2] = { ['x'] = 1021.07, ['y'] = -414.099, ['z'] = 66.1394, ['h'] = 127.0 },
	[3] = { ['x'] = 1003.1, ['y'] = -423.892, ['z'] = 65.3468, ['h'] = 135.0 },
	[4] = { ['x'] = 976.419, ['y'] = -436.9, ['z'] = 63.7452, ['h'] = 32.0 },
	[5] = { ['x'] = 962.334, ['y'] = -445.739, ['z'] = 62.6005, ['h'] = 302.0 },
	[6] = { ['x'] = 940.967, ['y'] = -452.002, ['z'] = 61.2523, ['h'] = 301.0 },
	[7] = { ['x'] = 918.33, ['y'] = -464.81, ['z'] = 61.0837, ['h'] = 14.0 },
	[8] = { ['x'] = 899.699, ['y'] = -474.118, ['z'] = 59.4362, ['h'] = 17.0 },
	[9] = { ['x'] = 869.233, ['y'] = -496.407, ['z'] = 57.6431, ['h'] = 39.0 },
	[10] = { ['x'] = 854.784, ['y'] = -516.325, ['z'] = 57.3284, ['h'] = 135.0 },
	[11] = { ['x'] = 834.426, ['y'] = -534.352, ['z'] = 57.5249, ['h'] = 87.0 },
	[12] = { ['x'] = 832.439, ['y'] = -561.425, ['z'] = 57.7079, ['h'] = 7.0 },
	[13] = { ['x'] = 850.473, ['y'] = -588.86, ['z'] = 57.9599, ['h'] = 138.0 },
	[14] = { ['x'] = 879.462, ['y'] = -609.731, ['z'] = 58.4422, ['h'] = 130.0 },
	[15] = { ['x'] = 891.181, ['y'] = -625.312, ['z'] = 58.2605, ['h'] = 133.0 },
	[16] = { ['x'] = 918.145, ['y'] = -648.733, ['z'] = 58.0587, ['h'] = 137.0 },
	[17] = { ['x'] = 939.002, ['y'] = -661.203, ['z'] = 58.014, ['h'] = 128.0 },
	[18] = { ['x'] = 944.432, ['y'] = -678.173, ['z'] = 58.4498, ['h'] = 115.0 },
	[19] = { ['x'] = 959.017, ['y'] = -704.345, ['z'] = 58.477, ['h'] = 121.0 },
	[20] = { ['x'] = 982.211, ['y'] = -726.873, ['z'] = 58.0258, ['h'] = 220.0 },
	[21] = { ['x'] = 987.213, ['y'] = -734.519, ['z'] = 57.8157, ['h'] = 126.0 },
	[22] = { ['x'] = 993.753, ['y'] = -620.756, ['z'] = 59.0431, ['h'] = 305.0 },
	[23] = { ['x'] = 906.134, ['y'] = -536.564, ['z'] = 58.5069, ['h'] = 285.0 },
	[24] = { ['x'] = 932.317, ['y'] = -530.707, ['z'] = 59.3417, ['h'] = 199.0 },
	[25] = { ['x'] = 952.696, ['y'] = -524.033, ['z'] = 60.6436, ['h'] = 212.0 },
	[26] = { ['x'] = 972.118, ['y'] = -514.475, ['z'] = 62.1361, ['h'] = 212.0 },
	[27] = { ['x'] = 1023.54, ['y'] = -472.679, ['z'] = 64.0556, ['h'] = 218.0 },
	[28] = { ['x'] = 1123.57, ['y'] = -390.138, ['z'] = 68.5005, ['h'] = 240.0 },
	[29] = { ['x'] = 1257.39, ['y'] = -437.555, ['z'] = 69.5674, ['h'] = 108.0 },
	[30] = { ['x'] = 1250.28, ['y'] = -461.362, ['z'] = 70.2796, ['h'] = 91.0 },
	[31] = { ['x'] = 1249.19, ['y'] = -473.534, ['z'] = 70.183, ['h'] = 85.0 },
	[32] = { ['x'] = 1244.66, ['y'] = -502.716, ['z'] = 69.7121, ['h'] = 166.0 },
	[33] = { ['x'] = 1241.05, ['y'] = -510.333, ['z'] = 69.3491, ['h'] = 69.0 },
	[34] = { ['x'] = 1230.21, ['y'] = -561.59, ['z'] = 69.6558, ['h'] = 86.0 },
	[35] = { ['x'] = 1234.31, ['y'] = -597.905, ['z'] = 69.7801, ['h'] = 88.0 },
	[36] = { ['x'] = 1239.3, ['y'] = -623.331, ['z'] = 69.3586, ['h'] = 27.0 },
	[37] = { ['x'] = 1257.57, ['y'] = -660.436, ['z'] = 67.9229, ['h'] = 214.0 },
	[38] = { ['x'] = 1259.65, ['y'] = -687.33, ['z'] = 66.0316, ['h'] = 87.0 },
	[39] = { ['x'] = 1259.6, ['y'] = -711.274, ['z'] = 64.5067, ['h'] = 146.0 },
	[40] = { ['x'] = 1309.37, ['y'] = -511.344, ['z'] = 71.4607, ['h'] = 333.0 },
	[41] = { ['x'] = 1335.48, ['y'] = -522.574, ['z'] = 72.2481, ['h'] = 343.0 },
	[42] = { ['x'] = 1355.02, ['y'] = -531.362, ['z'] = 73.8917, ['h'] = 343.0 },
	[43] = { ['x'] = 1380.56, ['y'] = -542.445, ['z'] = 74.493, ['h'] = 336.0 },
	[44] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[45] = { ['x'] = 1399.29, ['y'] = -603.883, ['z'] = 74.4855, ['h'] = 234.0 },
	[46] = { ['x'] = 1367.04, ['y'] = -623.296, ['z'] = 74.7109, ['h'] = 180.0 },
	[47] = { ['x'] = 1330.79, ['y'] = -608.409, ['z'] = 74.5081, ['h'] = 144.0 },
	[48] = { ['x'] = 1315.91, ['y'] = -598.107, ['z'] = 73.2464, ['h'] = 153.0 },
	[49] = { ['x'] = 1295.77, ['y'] = -590.212, ['z'] = 71.7323, ['h'] = 164.0 },
	[50] = { ['x'] = 1446.63, ['y'] = -1482.28, ['z'] = 63.6212, ['h'] = 338.0 },
	[51] = { ['x'] = 1391.01, ['y'] = -1508.39, ['z'] = 58.4358, ['h'] = 33.0 },
	[52] = { ['x'] = 1344.81, ['y'] = -1513.26, ['z'] = 54.5857, ['h'] = 357.0 },
	[53] = { ['x'] = 1311.69, ['y'] = -1515.27, ['z'] = 51.8117, ['h'] = 4.0 },
	[54] = { ['x'] = 1228.41, ['y'] = -1577.24, ['z'] = 53.5565, ['h'] = 30.0 },
	[55] = { ['x'] = 1203.95, ['y'] = -1594.63, ['z'] = 50.7435, ['h'] = 26.0 },
	[56] = { ['x'] = 1184.0, ['y'] = -1611.2, ['z'] = 45.2209, ['h'] = 36.0 },
	[57] = { ['x'] = 1203.27, ['y'] = -1670.63, ['z'] = 42.9817, ['h'] = 215.0 },
	[58] = { ['x'] = 1220.14, ['y'] = -1658.76, ['z'] = 48.6416, ['h'] = 208.0 },
	[59] = { ['x'] = 1252.63, ['y'] = -1638.55, ['z'] = 53.2072, ['h'] = 207.0 },
	[60] = { ['x'] = 1276.36, ['y'] = -1628.96, ['z'] = 54.543, ['h'] = 212.0 },
	[61] = { ['x'] = 1297.1, ['y'] = -1618.03, ['z'] = 54.5775, ['h'] = 192.0 },
	[62] = { ['x'] = 1330.81, ['y'] = -1559.66, ['z'] = 54.0515, ['h'] = 223.0 },
	[63] = { ['x'] = 1361.84, ['y'] = -1568.36, ['z'] = 56.3538, ['h'] = 193.0 },
	[64] = { ['x'] = 1389.98, ['y'] = -1546.35, ['z'] = 57.1072, ['h'] = 34.0 },
	[65] = { ['x'] = 1369.06, ['y'] = -1735.37, ['z'] = 65.6303, ['h'] = 188.0 },
	[66] = { ['x'] = 1321.22, ['y'] = -1745.97, ['z'] = 54.7014, ['h'] = 197.0 },
	[67] = { ['x'] = 1300.47, ['y'] = -1752.43, ['z'] = 54.2713, ['h'] = 104.0 },
	[68] = { ['x'] = 1263.03, ['y'] = -1773.29, ['z'] = 49.6573, ['h'] = 201.0 },
	[69] = { ['x'] = 1244.19, ['y'] = -1722.22, ['z'] = 52.0243, ['h'] = 24.0 },
	[70] = { ['x'] = 1283.76, ['y'] = -1699.89, ['z'] = 55.4751, ['h'] = 25.0 },
	[71] = { ['x'] = 1315.03, ['y'] = -1684.94, ['z'] = 58.2329, ['h'] = 15.0 },
	[72] = { ['x'] = 1337.64, ['y'] = -1688.8, ['z'] = 60.5184, ['h'] = 81.0 },
	[73] = { ['x'] = -46.3021, ['y'] = -1771.48, ['z'] = 28.0876, ['h'] = 48.0 },
	[74] = { ['x'] = -29.7425, ['y'] = -1787.78, ['z'] = 27.8203, ['h'] = 300.0 },
	[75] = { ['x'] = 29.7196, ['y'] = -1832.62, ['z'] = 24.6007, ['h'] = 323.0 },
	[76] = { ['x'] = 39.525, ['y'] = -1845.02, ['z'] = 24.0588, ['h'] = 218.0 },
	[77] = { ['x'] = 56.9605, ['y'] = -1853.58, ['z'] = 23.2871, ['h'] = 315.0 },
	[78] = { ['x'] = 64.8814, ['y'] = -1864.15, ['z'] = 22.7985, ['h'] = 306.0 },
	[79] = { ['x'] = 105.383, ['y'] = -1900.98, ['z'] = 21.4066, ['h'] = 332.0 },
	[80] = { ['x'] = 122.743, ['y'] = -1910.01, ['z'] = 21.3163, ['h'] = 324.0 },
	[81] = { ['x'] = 138.976, ['y'] = -1921.69, ['z'] = 21.3808, ['h'] = 292.0 },
	[82] = { ['x'] = 118.249, ['y'] = -1974.3, ['z'] = 21.3223, ['h'] = 204.0 },
	[83] = { ['x'] = 75.7193, ['y'] = -1970.01, ['z'] = 21.1252, ['h'] = 128.0 },
	[84] = { ['x'] = 67.9144, ['y'] = -1960.05, ['z'] = 21.1675, ['h'] = 136.0 },
	[85] = { ['x'] = 64.0576, ['y'] = -1948.15, ['z'] = 21.3685, ['h'] = 126.0 },
	[86] = { ['x'] = 47.1782, ['y'] = -1932.79, ['z'] = 21.9035, ['h'] = 141.0 },
	[87] = { ['x'] = 30.4997, ['y'] = -1923.88, ['z'] = 21.9569, ['h'] = 139.0 },
	[88] = { ['x'] = 16.3038, ['y'] = -1906.7, ['z'] = 22.9652, ['h'] = 138.0 },
	[89] = { ['x'] = 3.05277, ['y'] = -1893.08, ['z'] = 23.6959, ['h'] = 210.0 },
	[90] = { ['x'] = -10.4963, ['y'] = -1883.65, ['z'] = 24.1416, ['h'] = 230.0 },
	[91] = { ['x'] = -29.2414, ['y'] = -1869.56, ['z'] = 25.3351, ['h'] = 231.0 },
	[92] = { ['x'] = -42.6142, ['y'] = -1859.04, ['z'] = 26.1948, ['h'] = 132.0 },
	[93] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[94] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[95] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[96] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[97] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[98] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[99] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[100] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[101] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[102] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[103] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[104] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[105] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[106] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[107] = { ['x'] = -158.121, ['y'] = -1629.52, ['z'] = 37.4674, ['h'] = 48.0 },
	[108] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[109] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[110] = { ['x'] = -165.35, ['y'] = -1614.55, ['z'] = 34.0912, ['h'] = 55.0 },
	[111] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[112] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[113] = { ['x'] = -165.686, ['y'] = -1615.24, ['z'] = 37.382, ['h'] = 65.0 },
	[114] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[115] = { ['x'] = -118.701, ['y'] = -1564.27, ['z'] = 34.5801, ['h'] = 321.0 },
	[116] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[117] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[118] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[119] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[120] = { ['x'] = -157.778, ['y'] = -1595.88, ['z'] = 34.9205, ['h'] = 52.0 },
	[121] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[122] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[123] = { ['x'] = -119.017, ['y'] = -1563.91, ['z'] = 37.4142, ['h'] = 329.0 },
	[124] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[125] = { ['x'] = -103.274, ['y'] = -1577.19, ['z'] = 37.4142, ['h'] = 327.0 },
	[126] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[127] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[128] = { ['x'] = -157.547, ['y'] = -1595.3, ['z'] = 37.8084, ['h'] = 58.0 },
	[129] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[130] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[131] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[132] = { ['x'] = 21.0753, ['y'] = -1432.44, ['z'] = 30.9509, ['h'] = 335.0 },
	[133] = { ['x'] = 3.37753, ['y'] = -1430.26, ['z'] = 30.9557, ['h'] = 352.0 },
	[134] = { ['x'] = -32.3522, ['y'] = -1432.79, ['z'] = 31.8826, ['h'] = 266.0 },
	[135] = { ['x'] = -48.0192, ['y'] = -1430.98, ['z'] = 32.4209, ['h'] = 4.0 },
	[136] = { ['x'] = -66.8769, ['y'] = -1436.29, ['z'] = 32.526, ['h'] = 96.0 },
	[137] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[138] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[139] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[140] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[141] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[142] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[143] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[144] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[145] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[146] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[147] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[148] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[149] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[150] = { ['x'] = -204.159, ['y'] = -1549.78, ['z'] = 37.9307, ['h'] = 52.0 },
	[151] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[152] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[153] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[154] = { ['x'] = -198.45, ['y'] = -1598.19, ['z'] = 34.9031, ['h'] = 263.0 },
	[155] = { ['x'] = -201.04, ['y'] = -1612.09, ['z'] = 34.9031, ['h'] = 250.0 },
	[156] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[157] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[158] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[159] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[160] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[161] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[162] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[163] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[164] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[165] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[166] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[167] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[168] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[169] = { ['x'] = -232.055, ['y'] = -1620.07, ['z'] = 38.1289, ['h'] = 97.0 },
	[170] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[171] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[172] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[173] = { ['x'] = -200.6, ['y'] = -1605.18, ['z'] = 38.3317, ['h'] = 258.0 },
	[174] = { ['x'] = -212.476, ['y'] = -1683.01, ['z'] = 34.8503, ['h'] = 174.0 },
	[175] = { ['x'] = -231.161, ['y'] = -1683.01, ['z'] = 34.8503, ['h'] = 173.0 },
	[176] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[177] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[178] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[179] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[180] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[181] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[182] = { ['x'] = -231.232, ['y'] = -1683.02, ['z'] = 37.6224, ['h'] = 179.0 },
	[183] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[184] = { ['x'] = -233.191, ['y'] = -1649.58, ['z'] = 38.002, ['h'] = 76.0 },
	[185] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[186] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[187] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[188] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[189] = { ['x'] = 213.806, ['y'] = -1884.49, ['z'] = 24.813, ['h'] = 323.0 },
	[190] = { ['x'] = 197.061, ['y'] = -1871.88, ['z'] = 25.057, ['h'] = 335.0 },
	[191] = { ['x'] = 176.333, ['y'] = -1857.69, ['z'] = 24.3915, ['h'] = 331.0 },
	[192] = { ['x'] = 156.55, ['y'] = -1852.71, ['z'] = 24.5839, ['h'] = 338.0 },
	[193] = { ['x'] = 135.818, ['y'] = -1842.49, ['z'] = 25.2339, ['h'] = 333.0 },
	[194] = { ['x'] = 94.7125, ['y'] = -1895.32, ['z'] = 24.3114, ['h'] = 141.0 },
	[195] = { ['x'] = 112.932, ['y'] = -1900.37, ['z'] = 23.9315, ['h'] = 233.0 },
	[196] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 233.0 },
	[197] = { ['x'] = 128.334, ['y'] = -1906.1, ['z'] = 23.6723, ['h'] = 242.0 },
	[198] = { ['x'] = -1084.46, ['y'] = -1559.07, ['z'] = 4.78279, ['h'] = 31.0 },
	[199] = { ['x'] = -1076.89, ['y'] = -1554.03, ['z'] = 4.6303, ['h'] = 46.0 },
	[200] = { ['x'] = -1063.67, ['y'] = -1557.76, ['z'] = 5.14176, ['h'] = 126.0 },
	[201] = { ['x'] = -108.55, ['y'] = -1488.05, ['z'] = 34.1594, ['h'] = 229.0 },
	[202] = { ['x'] = -96.661, ['y'] = -1473.85, ['z'] = 34.1594, ['h'] = 217.0 },
	[203] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[204] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[205] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[206] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[207] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[208] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[209] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[210] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[211] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[212] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[213] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[214] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[215] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[216] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[217] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[218] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[219] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[220] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[221] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[222] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[223] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[224] = { ['x'] = 1404.48, ['y'] = -563.109, ['z'] = 74.4965, ['h'] = 294.0 },
	[225] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[226] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[227] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[228] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[229] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[230] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[231] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[232] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[233] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[234] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[235] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[236] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[237] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[238] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[239] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[240] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[241] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[242] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[243] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[244] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[245] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[246] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[247] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[248] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[249] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[250] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[251] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[252] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[253] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[254] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[255] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[256] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[257] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[258] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[259] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[260] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[261] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[262] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[263] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[264] = { ['x'] = 240.807, ['y'] = -1662.47, ['z'] = 29.6646, ['h'] = 45.0 },
	[265] = { ['x'] = 230.935, ['y'] = -1678.15, ['z'] = 29.6922, ['h'] = 48.0 },
	[266] = { ['x'] = 220.447, ['y'] = -1689.27, ['z'] = 29.6923, ['h'] = 39.0 },
	[267] = { ['x'] = 208.595, ['y'] = -1706.14, ['z'] = 29.678, ['h'] = 131.0 },
	[268] = { ['x'] = 192.676, ['y'] = -1711.92, ['z'] = 29.6651, ['h'] = 20.0 },
	[269] = { ['x'] = 158.095, ['y'] = -1835.94, ['z'] = 27.8559, ['h'] = 229.0 },
	[270] = { ['x'] = 259.607, ['y'] = -1740.49, ['z'] = 29.6612, ['h'] = 228.0 },
	[271] = { ['x'] = 269.065, ['y'] = -1728.61, ['z'] = 29.6455, ['h'] = 317.0 },
	[272] = { ['x'] = 278.521, ['y'] = -1715.2, ['z'] = 29.6664, ['h'] = 321.0 },
	[273] = { ['x'] = 291.901, ['y'] = -1701.82, ['z'] = 29.6479, ['h'] = 221.0 },
	[274] = { ['x'] = 320.765, ['y'] = -1732.7, ['z'] = 29.7216, ['h'] = 54.0 },
	[275] = { ['x'] = 310.893, ['y'] = -1750.29, ['z'] = 29.6304, ['h'] = 45.0 },
	[276] = { ['x'] = 295.449, ['y'] = -1767.43, ['z'] = 29.1026, ['h'] = 35.0 },
	[277] = { ['x'] = 288.206, ['y'] = -1775.43, ['z'] = 28.4192, ['h'] = 54.0 },
	[278] = { ['x'] = 285.535, ['y'] = -1783.77, ['z'] = 28.086, ['h'] = 323.0 },
	[279] = { ['x'] = 170.703, ['y'] = -1924.1, ['z'] = 21.1857, ['h'] = 143.0 },
	[280] = { ['x'] = 155.193, ['y'] = -1935.35, ['z'] = 20.23, ['h'] = 57.0 },
	[281] = { ['x'] = 139.872, ['y'] = -1952.64, ['z'] = 19.4581, ['h'] = 44.0 },
	[282] = { ['x'] = 131.66, ['y'] = -1961.68, ['z'] = 18.859, ['h'] = 58.0 },
	[283] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[284] = { ['x'] = 260.212, ['y'] = -1945.14, ['z'] = 24.7021, ['h'] = 226.0 },
	[285] = { ['x'] = 269.755, ['y'] = -1932.84, ['z'] = 25.4362, ['h'] = 323.0 },
	[286] = { ['x'] = 279.145, ['y'] = -1919.32, ['z'] = 26.1697, ['h'] = 320.0 },
	[287] = { ['x'] = 292.825, ['y'] = -1906.21, ['z'] = 27.2702, ['h'] = 232.0 },
	[288] = { ['x'] = 329.382, ['y'] = -1864.37, ['z'] = 27.5042, ['h'] = 230.0 },
	[289] = { ['x'] = 340.672, ['y'] = -1849.81, ['z'] = 27.7638, ['h'] = 328.0 },
	[290] = { ['x'] = 348.393, ['y'] = -1839.2, ['z'] = 28.3365, ['h'] = 134.0 },
	[291] = { ['x'] = 360.685, ['y'] = -1829.24, ['z'] = 28.8903, ['h'] = 230.0 },
	[292] = { ['x'] = 416.187, ['y'] = -1759.95, ['z'] = 29.7091, ['h'] = 321.0 },
	[293] = { ['x'] = 430.605, ['y'] = -1741.27, ['z'] = 29.604, ['h'] = 307.0 },
	[294] = { ['x'] = 440.203, ['y'] = -1728.01, ['z'] = 29.6002, ['h'] = 314.0 },
	[295] = { ['x'] = 453.512, ['y'] = -1714.6, ['z'] = 29.7097, ['h'] = 225.0 },
	[296] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[297] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[298] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[299] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[300] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[301] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[302] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[303] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[304] = { ['x'] = 478.025, ['y'] = -1710.32, ['z'] = 29.7062, ['h'] = 72.0 },
	[305] = { ['x'] = 465.601, ['y'] = -1731.92, ['z'] = 29.1523, ['h'] = 71.0 },
	[306] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 233.0 },
	[307] = { ['x'] = 465.432, ['y'] = -1748.54, ['z'] = 29.0851, ['h'] = 67.0 },
	[308] = { ['x'] = 429.443, ['y'] = -1820.18, ['z'] = 28.3583, ['h'] = 43.0 },
	[309] = { ['x'] = 417.937, ['y'] = -1832.31, ['z'] = 28.4631, ['h'] = 134.0 },
	[310] = { ['x'] = 401.66, ['y'] = -1849.46, ['z'] = 27.3197, ['h'] = 132.0 },
	[311] = { ['x'] = 390.48, ['y'] = -1861.77, ['z'] = 26.7113, ['h'] = 134.0 },
	[312] = { ['x'] = 375.822, ['y'] = -1873.41, ['z'] = 26.035, ['h'] = 39.0 },
	[313] = { ['x'] = 357.387, ['y'] = -1885.69, ['z'] = 25.18, ['h'] = 40.0 },
	[314] = { ['x'] = 315.671, ['y'] = -1937.43, ['z'] = 24.8138, ['h'] = 139.0 },
	[315] = { ['x'] = 302.25, ['y'] = -1946.64, ['z'] = 24.6092, ['h'] = 55.0 },
	[316] = { ['x'] = 286.786, ['y'] = -1963.83, ['z'] = 22.9009, ['h'] = 39.0 },
	[317] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 233.0 },
	[318] = { ['x'] = 279.592, ['y'] = -1971.78, ['z'] = 21.5813, ['h'] = 47.0 },
	[319] = { ['x'] = 250.782, ['y'] = -2011.95, ['z'] = 19.2588, ['h'] = 54.0 },
	[320] = { ['x'] = 240.661, ['y'] = -2021.45, ['z'] = 18.7072, ['h'] = 132.0 },
	[321] = { ['x'] = 224.657, ['y'] = -2036.36, ['z'] = 18.1768, ['h'] = 58.0 },
	[322] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[323] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[324] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[325] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[326] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[327] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[328] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[329] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[330] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[331] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[332] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[333] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[334] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[335] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[336] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[337] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[338] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[339] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[340] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[341] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[342] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[343] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[344] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[345] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[346] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[347] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[348] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[349] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[350] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[351] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[352] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[353] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[354] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[355] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[356] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[357] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[358] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[359] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[360] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[361] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[362] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[363] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[364] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[365] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[366] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[367] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[368] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[369] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[370] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[371] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[372] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[373] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[374] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[375] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[376] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[377] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[378] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[379] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[380] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[381] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[382] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[383] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[384] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[385] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[386] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[387] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[388] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[389] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[390] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[391] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[392] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[393] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[394] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[395] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[396] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[397] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[398] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[399] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[400] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[401] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[402] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[403] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[404] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[405] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[406] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[407] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[408] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[409] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[410] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[411] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[412] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[413] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[414] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[415] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[416] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[417] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[418] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[419] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[420] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[421] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[422] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[423] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[424] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[425] = { ['x'] = -948.239, ['y'] = -951.487, ['z'] = 2.14531, ['h'] = 123.0 },
	[426] = { ['x'] = -960.719, ['y'] = -941.413, ['z'] = 2.14531, ['h'] = 125.0 },
	[427] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[428] = { ['x'] = -975.323, ['y'] = -909.596, ['z'] = 2.34262, ['h'] = 29.0 },
	[429] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[430] = { ['x'] = -987.459, ['y'] = -891.585, ['z'] = 2.15068, ['h'] = 206.0 },
	[431] = { ['x'] = -998.293, ['y'] = -904.541, ['z'] = 2.74627, ['h'] = 201.0 },
	[432] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[433] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[434] = { ['x'] = -1019.74, ['y'] = -895.29, ['z'] = 8.75882, ['h'] = 20.0 },
	[435] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[436] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[437] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[438] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[439] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[440] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[441] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[442] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[443] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[444] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[445] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[446] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[447] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[448] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[449] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[450] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[451] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[452] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[453] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[454] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[455] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[456] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[457] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[458] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[459] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 },
	[460] = { ['x'] = 0.0, ['y'] = 0.0, ['z'] = 0.0, ['h'] = 0.0 }
}