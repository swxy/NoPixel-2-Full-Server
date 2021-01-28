--[[Register]]--

RegisterNetEvent("garages:getVehicles")
RegisterNetEvent('garages:SpawnVehicle')
RegisterNetEvent('garages:StoreVehicle')
RegisterNetEvent('garages:SelVehicle')
--

local markerColor = 
{
	["Red"] = 222,
	["Green"] = 50,
	["Blue"] = 50
}
local garagesRunning = false

local garages = {
	[1] = { loc = {484.77066040039,-77.643089294434,77.600166320801}, spawn = {469.40374755859,-65.764274597168,76.935157775879}, garage = "A"},
	[2] = { loc = {-331.96115112305,-781.52337646484,33.964477539063}, spawn = {-334.75921630859,-777.63739013672,33.965934753418}, garage = "B"},

	[3] = { loc = {-451.37295532227,-794.06591796875,30.543809890747}, spawn = {-453.78579711914,-799.77722167969,30.544193267822}, garage = "C"},
	[4] = { loc = {399.51190185547,-1346.2742919922,31.121940612793}, spawn = {404.08923339844,-1340.2329101563,31.123672485352}, garage = "D"},

	[5] = { loc = {598.77319335938,90.707237243652,92.829048156738}, spawn = {604.99200439453,90.680313110352,92.638885498047}, garage = "E"},
	[6] = { loc = {641.53442382813,205.42562866211,97.186958312988}, spawn = {643.27648925781,200.49697875977,96.490730285645}, garage = "F"},

	[7] = { loc = {82.359413146973,6418.9575195313,31.479639053345}, spawn = {68.428749084473,6394.8129882813,31.233980178833}, garage = "G"},

	[8] = { loc = {-794.578125,-2020.8499755859,8.9431390762329}, spawn = {-773.12854003906,-2034.2691650391,8.8856906890869}, garage = "H"},

	[9] = { loc = {-669.15631103516,-2001.7552490234,7.5395741462708}, spawn = {-666.11407470703,-1993.1220703125,6.9599323272705}, garage = "I"},

	[10] = { loc = {-606.86322021484,-2236.7624511719,6.0779848098755}, spawn = {-617.38104248047,-2228.3828125,6.0075860023499}, garage = "J"},

	[11] = { loc = {-166.60482788086,-2143.9333496094,16.839847564697}, spawn = {-166.0227355957,-2150.9533691406,16.704912185669}, garage = "K"},

	[12] = { loc = {-38.922565460205,-2097.2663574219,16.704851150513}, spawn = {-42.358554840088,-2106.9069824219,16.704837799072}, garage = "L"},

	[13] = { loc = {-70.179389953613,-2004.4139404297,18.016941070557}, spawn = {-66.245826721191,-2012.8634033203,18.016965866089}, garage = "M"},

	[14] = { loc = {549.47796630859,-55.197559356689,71.069190979004}, spawn = {549.47796630859,-55.197559356689,71.069190979004}, garage = "Impound Lot"},

	[15] = { loc = {364.27685546875,297.84490966797,103.49515533447}, spawn = {370.07534790039,291.43197631836,103.33471679688}, garage = "O"},

	[16] = { loc = {-338.31619262695,266.79782104492,85.741966247559}, spawn = {-334.42706298828,278.54644775391,85.945793151855}, garage = "P"},

	[17] = { loc = {273.66683959961,-343.83737182617,44.919876098633}, spawn = {272.68188476563,-334.81295776367,44.919876098633}, garage = "Q"},

	[18] = { loc = {66.215492248535,13.700443267822,69.047248840332}, spawn = {61.096534729004,24.754076004028,69.682136535645}, garage = "R"},

	[19] = { loc = {-791.79,-191.7,37.29}, spawn = {-791.79,-191.7,37.29}, garage = "Imports"},

	[20] = { loc = {286.67013549805,79.613700866699,94.362899780273}, spawn = {282.82489013672,76.622230529785,94.36026763916}, garage = "S"},

	[21] = { loc = {211.79,-808.38,30.833}, spawn = {212.04,-800.325,30.89}, garage = "T"},

	[22] = { loc = {447.65,-1021.23,28.45}, spawn = {447.65,-1021.23,28.45}, garage = "Police Department"},
	

	[23] = { loc = {-25.59,-720.86,32.62}, spawn = {-25.59,-720.86,32.22}, garage = "House"},
	[24] = { loc = {570.81,2729.85,42.07}, spawn = {570.81,2729.85,42.07}, garage = 'Harmony Garage'},

	[25] = { loc = {-1287.1, 293.02, 64.82}, spawn = {-1287.1, 293.02, 64.82}, garage = 'Richman Garage'},
	[26] = { loc = {-1579.01,-889.11,9.38,}, spawn = {-1579.01,-889.11,9.38,}, garage = 'Pier Garage'},
	[27] = { loc = {-277.52,-890.0,30.47}, spawn = {-277.52,-890.0,30.47}, garage = '24/7 Garage'},

	[28] =  { loc = {986.28, -208.47, 70.46}, spawn = {986.28, -208.47, 70.46}, garage = 'Run Down Hotel' },

	[29] =  { loc = {847.36, -3219.15, 5.97}, spawn = {847.36, -3219.15, 5.97}, garage = 'Docks' },

	[30] =  { loc = {-1479.6,-666.556,28.4}, spawn = {-1479.6,-666.556,28.4}, garage = 'Q' },
	
	[31] =  { loc = {-208.41,307.5,96.95}, spawn = {-208.41,307.5,96.95}, garage = 'Rooster Cab'},
	[32] =  { loc = {-836.93,-1273.09,5.01}, spawn = {-836.93,-1273.09,5.01}, garage = 'U' },
	[33] =  { loc = {-1563.23,-257.64,48.28}, spawn = {-1563.23,-257.64,48.28}, garage = 'V' },
	[34] =  { loc = {-1327.67,-927.44,11.21}, spawn = {-1327.67,-927.44,11.21}, garage = 'W' },
}


function DefaultGarages()
	 garages = {
	[1] = { loc = {484.77066040039,-77.643089294434,77.600166320801}, spawn = {469.40374755859,-65.764274597168,76.935157775879}, garage = "A"},
	[2] = { loc = {-331.96115112305,-781.52337646484,33.964477539063}, spawn = {-334.75921630859,-777.63739013672,33.965934753418}, garage = "B"},

	[3] = { loc = {-451.37295532227,-794.06591796875,30.543809890747}, spawn = {-453.78579711914,-799.77722167969,30.544193267822}, garage = "C"},
	[4] = { loc = {399.51190185547,-1346.2742919922,31.121940612793}, spawn = {404.08923339844,-1340.2329101563,31.123672485352}, garage = "D"},

	[5] = { loc = {598.77319335938,90.707237243652,92.829048156738}, spawn = {604.99200439453,90.680313110352,92.638885498047}, garage = "E"},
	[6] = { loc = {641.53442382813,205.42562866211,97.186958312988}, spawn = {643.27648925781,200.49697875977,96.490730285645}, garage = "F"},

	[7] = { loc = {82.359413146973,6418.9575195313,31.479639053345}, spawn = {68.428749084473,6394.8129882813,31.233980178833}, garage = "G"},

	[8] = { loc = {-794.578125,-2020.8499755859,8.9431390762329}, spawn = {-773.12854003906,-2034.2691650391,8.8856906890869}, garage = "H"},

	[9] = { loc = {-669.15631103516,-2001.7552490234,7.5395741462708}, spawn = {-666.11407470703,-1993.1220703125,6.9599323272705}, garage = "I"},

	[10] = { loc = {-606.86322021484,-2236.7624511719,6.0779848098755}, spawn = {-617.38104248047,-2228.3828125,6.0075860023499}, garage = "J"},

	[11] = { loc = {-166.60482788086,-2143.9333496094,16.839847564697}, spawn = {-166.0227355957,-2150.9533691406,16.704912185669}, garage = "K"},

	[12] = { loc = {-38.922565460205,-2097.2663574219,16.704851150513}, spawn = {-42.358554840088,-2106.9069824219,16.704837799072}, garage = "L"},

	[13] = { loc = {-70.179389953613,-2004.4139404297,18.016941070557}, spawn = {-66.245826721191,-2012.8634033203,18.016965866089}, garage = "M"},

	[14] = { loc = {549.47796630859,-55.197559356689,71.069190979004}, spawn = {549.47796630859,-55.197559356689,71.069190979004}, garage = "Impound Lot"},

	[15] = { loc = {364.27685546875,297.84490966797,103.49515533447}, spawn = {370.07534790039,291.43197631836,103.33471679688}, garage = "O"},

	[16] = { loc = {-338.31619262695,266.79782104492,85.741966247559}, spawn = {-334.42706298828,278.54644775391,85.945793151855}, garage = "P"},

	[17] = { loc = {273.66683959961,-343.83737182617,44.919876098633}, spawn = {272.68188476563,-334.81295776367,44.919876098633}, garage = "Q"},

	[18] = { loc = {66.215492248535,13.700443267822,69.047248840332}, spawn = {61.096534729004,24.754076004028,69.682136535645}, garage = "R"},

	[19] = { loc = {3.3330917358398,-1680.7877197266,29.170293807983}, spawn = {3.3330917358398,-1680.7877197266,29.170293807983}, garage = "Imports"},

	[20] = { loc = {286.67013549805,79.613700866699,94.362899780273}, spawn = {282.82489013672,76.622230529785,94.36026763916}, garage = "S"},

	[21] = { loc = {211.79,-808.38,30.833}, spawn = {212.04,-800.325,30.89}, garage = "T"},

	[22] = { loc = {447.65,-1021.23,28.45}, spawn = {447.65,-1021.23,28.45}, garage = "Police Department"},

	[23] = { loc = {-25.59,-720.86,32.65}, spawn = {-25.59,-720.86,32.65}, garage = "House"},

	[24] = { loc = {570.81,2729.85,42.07}, spawn = {570.81,2729.85,42.07}, garage = 'Harmony Garage'},

	[25] = { loc = {-1287.1, 293.02, 64.82}, spawn = {-1287.1, 293.02, 64.82}, garage = 'Richman Garage'},
	[26] = { loc = {-1579.01,-889.11,9.38,}, spawn = {-1579.01,-889.11,9.38,}, garage = 'Pier Garage'},
	[27] = { loc = {-277.52,-890.0,30.47}, spawn = {-277.52,-890.0,30.47}, garage = '24/7 Garage'},
	[28] =  { loc = {986.28, -208.47, 70.46}, spawn = {986.28, -208.47, 70.46}, garage = 'Run Down Hotel' },
	[29] =  { loc = {847.36, -3219.15, 5.97}, spawn = {847.36, -3219.15, 5.97}, garage = 'Docks' },
	[30] =  { loc = {-1479.6,-666.556,28.4}, spawn = {-1479.6,-666.556,28.4}, garage = 'Q' },
	[31] =  { loc = {-208.41,307.5,96.95}, spawn = {-208.41,307.5,96.95}, garage = 'Rooster Cab'},
	[32] =  { loc = {-836.93,-1273.09,5.01}, spawn = {-836.93,-1273.09,5.01}, garage = 'U' },
	[33] =  { loc = {-1563.23,-257.64,48.28}, spawn = {-1563.23,-257.64,48.28}, garage = 'V' },
	[34] =  { loc = {-1327.67,-927.44,11.21}, spawn = {-1327.67,-927.44,11.21}, garage = 'W' },
}
end


RegisterNetEvent("checkifbike")
AddEventHandler("checkifbike", function(vehicle, veh_id)
	local bicycle = IsThisModelABicycle( GetHashKey(vehicle) )
	if bicycle then
		TriggerServerEvent( "garages:CheckForSpawnVeh2", veh_id)
	else
		TriggerEvent( "DoLongHudText", "No License.",2 )
	end
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--[[Local/Global]]--

--["garage"..table_id] = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["table_id"] = table_id },
local mygarages = {}
local scannedPOIs = {}


function DeleteSpawnedHouse()

	TriggerEvent("inhouse",false)
    local playerped = PlayerPedId()
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(vector3(plycoords["x"], plycoords["y"], (plycoords["z"])) - pos)
        if distance < 35.0 and ObjectFound ~= playerped then
        	if not IsEntityAPed(ObjectFound) then
        		DeleteObject(ObjectFound)
        	end            
        end
        success, ObjectFound = FindNextObject(handle)
    until not success
    EndFindObject(handle)
end


function hasKey(id) 
	local myhousekeys = exports["isPed"]:isPed("myhousekeys")
	for i = 1, #myhousekeys do
		if tonumber(myhousekeys[i]) == id then
			return true
		end
	end
	return false
end


-- this is called if we get a new key
RegisterNetEvent("RequestKeyUpdate")
AddEventHandler("RequestKeyUpdate", function()
	TriggerServerEvent("ReturnHouseKeys")
end)

-- this is called if a key is altered, we request new ones if one of ours is.
RegisterNetEvent("CheckForKeyUpdate")
AddEventHandler("CheckForKeyUpdate", function(id)
	if hasKey(id) then
		TriggerServerEvent("ReturnHouseKeys")
	end
end)


RegisterNetEvent("UpdateCurrentHouseSpawns")
AddEventHandler("UpdateCurrentHouseSpawns", function(id,house_poi)

	local id = tonumber(id)
	if hasKey(id) then
		TriggerServerEvent("GarageData")
	end

end)

RegisterNetEvent("house:garagelocations")
AddEventHandler("house:garagelocations", function(sentmygarages)
	mygarages = {}
	scannedPOIs = {}
	DefaultGarages()
	mygarages = sentmygarages
	garagesRunning = false
	TriggerEvent("RecreateGarages")	
end)

local entering = false
RegisterNetEvent("house:entering")
AddEventHandler("house:entering", function(entering)
	entering = true
	Citizen.Wait(10000)
	entering = false
end)


RegisterNetEvent("house:garagechanges")
AddEventHandler("house:garagechanges", function(table_id)
	if scannedPOIs["garage"..table_id] ~= nil then
		Citizen.Wait(math.random(1000,5000))
		TriggerEvent("house:entering")
		TriggerServerEvent("GarageData")
	end
end)


Citizen.CreateThread(function()
	--TriggerServerEvent("GarageData")
	
	while true do
		Citizen.Wait(1)
		local closest = 500.0
		if garagesRunning then
			for i,row in pairs(mygarages) do
				local dist = #(vector3(row["x"],row["y"],row["z"]) - GetEntityCoords(PlayerPedId()))
				if dist < 40.0 and scannedPOIs["garage"..row["table_id"]] == nil and not resetting then
					scannedPOIs["garage"..row["table_id"]] = row
					CreateHouseGarages(row)

				elseif scannedPOIs["garage"..row["table_id"]] ~= nil and dist > 150.0 and not entering then
					scannedPOIs["garage"..row["table_id"]] = nil
					RemoveHouseGarages(row)
				end
				Citizen.Wait(1000)
			end
		end
		Citizen.Wait(math.ceil(closest * 20))
	end

end)

local addedGarages = {}
function CreateHouseGarages(currentRow)

	for x,row in pairs(currentRow["house_poi"]["garages"]) do

		local currentGarage = row
		local garageName = currentRow["house_name"] .. " #" .. x

		for _, g in ipairs(garages) do
			if g.garage == garageName and g.disabled then
				addedGarages[garageName] = true
				g.disabled = false
			end
		end

		if addedGarages[garageName] == nil then
			garages[#garages+1] =
			{ 
				loc = { currentGarage["x"],currentGarage["y"],currentGarage["z"],currentGarage["h"] },
				spawn = { currentGarage["x"],currentGarage["y"],currentGarage["z"],currentGarage["h"] }, 
				garage = garageName
			}
		end

	end

	garagesRunning = false
	TriggerEvent("RecreateGarages")
end

function RemoveHouseGarages(currentRow)
	
	local todelete = {}

	for x,row in pairs(currentRow["house_poi"]["garages"]) do
		local currentGarage = row
		local garageName = currentRow["house_name"] .. " #" .. x
		for i = 1, #garages do
			if garageName == garages[i].garage and not garages[i].disabled then
				garages[i].disabled = true
			end
		end
	end

	garagesRunning = false
	TriggerEvent("RecreateGarages")	
end
local nearClothing = false
Citizen.CreateThread(function()

	while true do

		Citizen.Wait(1)
		local plyId = LocalPed()
		local plyCoords = GetEntityCoords(plyId)
		for x,row in pairs(scannedPOIs) do

			if row["house_poi"] ~= nil then

				local garages = row["house_poi"]["garages"]
				local backdooroutside = row["house_poi"]["backdooroutside"]
				local backdoorinside = row["house_poi"]["backdoorinside"]
				local clothing = row["house_poi"]["clothing"]
				local storage = row["house_poi"]["storage"]



				if backdooroutside["x"] ~= 0.0 then
					if #(vector3(backdooroutside["x"],backdooroutside["y"],backdooroutside["z"]-0.3) - plyCoords) < 3.0 then
						DrawMarker(20,backdooroutside["x"],backdooroutside["y"],backdooroutside["z"]-0.3,0,0,0,0,0,0,0.701,1.0001,0.3001,markerColor.Red,markerColor.Green, markerColor.Blue,11,0,0,0,0)
					end
					if #(vector3(backdooroutside["x"],backdooroutside["y"],backdooroutside["z"]-0.3) - plyCoords) < 1.5 then
						DrawText3Ds( backdooroutside["x"],backdooroutside["y"],backdooroutside["z"] , '~g~E~s~ to enter house.')
						
						if IsControlJustReleased(2, 38) then
							TriggerServerEvent("house:enterhousebackdoor",row["house_id"],row["house_model"],false,backdoorinside["x"],backdoorinside["y"],backdoorinside["z"],backdoorinside["h"])
							Citizen.Wait(3000)
						end
					end	
				end

				if backdoorinside["x"] ~= 0.0 then
					if #(vector3(backdoorinside["x"],backdoorinside["y"],backdoorinside["z"]-0.3) - plyCoords) < 3.0 then
						DrawMarker(20,backdoorinside["x"],backdoorinside["y"],backdoorinside["z"]-0.3,0,0,0,0,0,0,0.701,1.0001,0.3001,markerColor.Red,markerColor.Green, markerColor.Blue,11,0,0,0,0)
					end
					if #(vector3(backdoorinside["x"],backdoorinside["y"],backdoorinside["z"]-0.3) - plyCoords) < 1.5 then
						DrawText3Ds( backdoorinside["x"],backdoorinside["y"],backdoorinside["z"] , '~g~E~s~ to leave house.')
						if IsControlJustReleased(2, 38) then
							TriggerEvent("housing:exit:backdoor",backdooroutside["x"],backdooroutside["y"],backdooroutside["z"],backdooroutside["h"])
							Citizen.Wait(3000)
						end
					end	
				end
				if clothing["x"] ~= 0.0 then
					if #(vector3(clothing["x"],clothing["y"],clothing["z"]-0.3) - plyCoords) < 1.5 then
						nearClothing = true
						DrawText3Ds( clothing["x"],clothing["y"],clothing["z"] , 'Press G to relog or use /outfits to change clothing' )
						if IsControlJustReleased(2,47) then
							DeleteSpawnedHouse()

							logout()
							TriggerEvent("inhouse",false)
						end
					else
						nearClothing = false
					end
				end

				if storage["x"] ~= 0.0 then
					if #(vector3(storage["x"],storage["y"],storage["z"]-0.3) - plyCoords) < 1.5 then
						DrawText3Ds( storage["x"],storage["y"],storage["z"] , 'Press ~g~E~s~ to open your stash.')
						if IsControlJustReleased(2, 38) then
							--TriggerServerEvent('hotel:GetInteract',1500,row["house_name"])
							TriggerEvent("server-inventory-open", "1", "house-"..row["house_name"])

						end
					end
				end	

			end

		end

	end

end)

function logout()
	TransitionToBlurred(500)
	DoScreenFadeOut(500)
	Citizen.Wait(1000)
	Citizen.Wait(1000)   
	TriggerEvent("np-base:clearStates")
	exports["np-base"]:getModule("SpawnManager"):Initialize()
	Citizen.Wait(1000)
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



local myroomtype = 0
local showGarages = false
local blips = {
	{469.40374755859,-65.764274597168,76.935157775879,"A"},
	{-331.96115112305,-781.52337646484,33.964477539063,"B"},
	{-451.37295532227,-794.06591796875,30.543809890747,"C"},
	{399.51190185547,-1346.2742919922,31.121940612793,"D"},
	{598.77319335938,90.707237243652,92.829048156738,"E"},
	{641.53442382813,205.42562866211,97.186958312988,"F"},
	{82.359413146973,6418.9575195313,31.479639053345,"G"},
	{-794.578125,-2020.8499755859,8.9431390762329,"H"},
	{-669.15631103516,-2001.7552490234,7.5395741462708,"I"},
	{-606.86322021484,-2236.7624511719,6.0779848098755,"J"},
	{-166.60482788086,-2143.9333496094,16.839847564697,"K"},
	{-38.922565460205,-2097.2663574219,16.704851150513,"L"},
	{-70.179389953613,-2004.4139404297,18.016941070557,"M"},
	{549.47796630859,-55.197559356689,71.069190979004,"Impound Lot"},
	{364.27685546875,297.84490966797,103.49515533447,"O"},
	{-338.31619262695,266.79782104492,85.741966247559,"P"},
	{273.66683959961,-343.83737182617,44.919876098633,"Q"},
	{66.215492248535,13.700443267822,69.047248840332,"R"},
	{3.3330917358398,-1680.7877197266,29.170293807983,"Imports"},
	{286.67013549805,79.613700866699,94.362899780273,"S"},
	{211.79,-808.38,30.833,"T"},
	{447.65,-1021.23,28.45,"Police Department"},
	{-25.59,-720.86,32.62, "Highrise Garage"},
	{570.81,2729.85,42.07,'Harmony Garage'},

	{ -1287.1, 293.02, 64.82, ' Richman Garage' },
	{ -1579.01,-889.11,9.38, ' Pier Garage' },
	{ -277.52,-890.0,30.47, '24/7 Garage' },
	{ 986.28, -208.47, 70.46, 'Run Down Hotel' },
	{847.36, -3219.15, 5.97, 'Docks' },

	{-1479.6,-666.556,28.4, 'Q' },
	{-836.93,-1273.09,5.01, 'U'},
	{-1561.26,-244.46,48.28, 'V'},
	{-1327.67,-927.44,11.21, 'W' },
}




RegisterNetEvent('Garages:ToggleGarageBlip')
AddEventHandler('Garages:ToggleGarageBlip', function()
    showGarages = not showGarages
    local what = 1
   for _, item in pairs(blips) do
        if not showGarages then
            if item.blip ~= nil then
                RemoveBlip(item.blip)
            end
        else
            item.blip = AddBlipForCoord(item[1], item[2], item[3])
            SetBlipSprite(item.blip, 357)


	
			if what == 14 then
				AddTextComponentString('Impound Lot')
				SetBlipColour(item.blip, 5)
			else
				SetBlipColour(item.blip, 3)
				AddTextComponentString('Garage ' .. item[4])
			end
			what = what + 1



			SetBlipScale(item.blip, 0.75)
			SetBlipAsShortRange(item.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Garage " .. item[4])
			EndTextCommandSetBlipName(item.blip)
        end
    end
end)

Citizen.CreateThread(function()
	showGarages = false
	TriggerEvent('Garages:ToggleGarageBlip')
end)






--





VEHICLES = {}
local vente_location = {-45.228, -1083.123, 25.816}
local inrangeofgarage = false
local currentlocation = nilwaaaaaaaaaa
local garage = {title = "garage", currentpos = nil, marker = { r = 0, g = 155, b = 255, a = 200, type = 1 }}
local selectedGarage = false


--[[Functions]]--

function MenuGarage()
	
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Store Vehicle","RentrerVehicule",nil)
    Menu.addButton("Vehicle List","ListeVehicule",nil)
    Menu.addButton("Close Menu","CloseMenu",nil) 
end

function RentrerVehicule()
	TriggerServerEvent('garages:CheckForVeh',source)
	CloseMenu()
end
carCount = 0
firstCar = 0



function doCarDamages(eh, bh, Fuel, veh)
	smash = false
	damageOutside = false
	damageOutside2 = false 
	local engine = eh + 0.0
	local body = bh + 0.0
	if engine < 200.0 then
		engine = 200.0
	end

	if body < 150.0 then
		body = 150.0
	end
	if body < 950.0 then
		smash = true
	end

	if body < 920.0 then
		damageOutside = true
	end

	if body < 920.0 then
		damageOutside2 = true
	end

	local currentVehicle = (veh and IsEntityAVehicle(veh)) and veh or GetVehiclePedIsIn(PlayerPedId(), false)

	Citizen.Wait(100)
	SetVehicleEngineHealth(currentVehicle, engine)
	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(currentVehicle, 985.0)
	end
	DecorSetInt(currentVehicle, "CurrentFuel", Fuel)


end


local myspawnedhousecars = {}
nearHouseGarage = false
local currentGarage = GetEntityCoords(PlayerPedId())
RegisterNetEvent('Garages:SpawnHouseGarage')
AddEventHandler('Garages:SpawnHouseGarage', function(z)
	currentGarage = z

	ListeVehicule()

end)
local dntdelete = "none"
RegisterNetEvent('Garages:HouseRemoveVehicle')
AddEventHandler('Garages:HouseRemoveVehicle', function(veh)
	for i = 1, #myspawnedhousecars do
		if myspawnedhousecars[i] == veh then
			table.remove(myspawnedhousecars,i)
		end
	end

	local plate = GetVehicleNumberPlateText(veh)
	SetVehicleHasBeenOwnedByPlayer(veh,true)
	
	local id = NetworkGetNetworkIdFromEntity(veh)
	SetNetworkIdCanMigrate(id, true)
	dntdelete = plate
	TriggerEvent("keys:addNew",veh,plate)
	TriggerServerEvent('garages:SetVehOut', veh, plate)
	TriggerEvent("Garages:ToggleHouse",false)
	TriggerEvent("veh.PlayerOwned",veh)
	Citizen.Wait(1000)
	TriggerServerEvent("garages:CheckGarageForVeh")
end)



RegisterNetEvent('hotel:myroomtype')
AddEventHandler('hotel:myroomtype', function(roomtype)
	myroomtype = roomtype
end)

RegisterNetEvent('Garages:ToggleHouse')
AddEventHandler('Garages:ToggleHouse', function(tg)

	nearHouseGarage = tg
	if nearHouseGarage then

	else
		for i=1,#myspawnedhousecars do
			local plate = GetVehicleNumberPlateText(myspawnedhousecars[i])
			if plate ~= dntdelete then

				--SetEntityAsMissionEntity(myspawnedhousecars[i],false,true)
				--DeleteEntity(myspawnedhousecars[i])
				Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(myspawnedhousecars[i]))
			end
		end
	end

	myspawnedhousecars = {}
	dntdelete = "none"

end)




function AddonsHouseCars(veh,v)
	
	
	SetVehicleOnGroundProperly(veh)
	SetEntityInvincible(veh, false) 

	SetVehicleModKit(veh, 0)
	local plate = v.license_plate
	SetVehicleNumberPlateText(veh, plate)
	local customized = v.data
	local plate = GetVehicleNumberPlateText(vehicle)
	TriggerEvent("chop:plateoff",plate)	


	if customized ~= nil then
		SetVehicleWheelType(veh, customized.wheeltype)
		SetVehicleNumberPlateTextIndex(veh, 3)

		for i = 0, 16 do
			SetVehicleMod(veh, i, customized.mods[tostring(i)])
		end

		for i = 17, 22 do
			ToggleVehicleMod(veh, i, customized.mods[tostring(i)])
		end

		for i = 23, 48 do
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
	--SetEntityAsMissionEntity(veh,false,true)

	TriggerEvent("keys:addNew",veh,plate)
	SetVehicleHasBeenOwnedByPlayer(veh,true)
	

	local id = NetworkGetNetworkIdFromEntity(veh)
	SetNetworkIdCanMigrate(id, true)
	
	if GetEntityModel(veh) == `rumpo4` then
		SetVehicleLivery(veh,0)
	end

	if GetEntityModel(veh) == `rumpo` then
		SetVehicleLivery(veh,0)
	end

	if GetEntityModel(veh) == `taxi` then

		SetVehicleExtra(veh, 8, 1)
		SetVehicleExtra(veh, 9, 1)
		SetVehicleExtra(veh, 6, 0)

	end
	doCarDamages(v.engine_damage, v.body_damage, v.fuel, veh)
	myspawnedhousecars[#myspawnedhousecars+1]=veh
end

function spawnCars(houseCars)
 	myspawnedhousecars = {}
 	local spawnStart = {}
 	spawnStart.x = currentGarage.x-4.1
 	spawnStart.y = currentGarage.y-14.2
 	spawnStart.z = currentGarage.z+1.0
 	local fuckyou = 1
	for i, v in pairs(houseCars) do
		if i < 7 then

	 		RequestModel(v.model)
			while not HasModelLoaded(v.model) do
				Citizen.Wait(1)
			end
	 		local vehicle = CreateVehicle(v.model,spawnStart.x,spawnStart.y + (i*4.5),spawnStart.z,235.0,true,false)
			SetModelAsNoLongerNeeded(v.model)
	 		AddonsHouseCars(vehicle,v)	
	
		else
	 		RequestModel(v.model)
			while not HasModelLoaded(v.model) do
				Citizen.Wait(1)
			end
			SetModelAsNoLongerNeeded(v.model)

	 		if i < 12 then
	 			local vehicle = CreateVehicle(v.model,spawnStart.x+7.7,spawnStart.y + (fuckyou*4.5),spawnStart.z,115.0,true,false)	
	 			AddonsHouseCars(vehicle,v)

	 			fuckyou = fuckyou + 1
	 		end		
		end
	end 

 end


function ListeVehicule()
    ped = PlayerPedId();
    MenuTitle = "My Vehicles :"
    ClearMenu()
    carCount = 0
    for ind, value in pairs(VEHICLES) do
		carCount = carCount + 1
    end 
    
    estimate = 15 * (carCount * carCount * 2)

    if firstCar == 0 then estimate = 0 end


	if nearHouseGarage then
		curGarage = "House"
		local houseCars = {}
	    for ind, v in pairs(VEHICLES) do
	    	enginePercent = v.engine_damage / 10
	    	bodyPercent = v.body_damage / 10
	  		curGarage = v.current_garage

	  		if curGarage == nil then
	  			curGarage = "Any"
	  		end
			if (curGarage == "House") and v.vehicle_state == "In" then
				houseCars[#houseCars+1]= { ["id"] = v.id, ["model"] = v.model, ["name"] = v.name, ["license_plate"] = v.license_plate, ["vehicle_state"] = v.vehicle_state, ["engine_damage"] = v.engine_damage, ["body_damage"] = v.body_damage, ["current_garage"] = v.current_garage, ["data"] = v.data, ["fuel"] = v.fuel }
			end
	    end 
	    spawnCars(houseCars)
	else
	    for ind, value in pairs(VEHICLES) do
	    	enginePercent = value.engine_damage / 10
	    	bodyPercent = value.body_damage / 10
	  		curGarage = value.current_garage

	  		if curGarage == nil then
	  			curGarage = "Any"
	  		end

			if value.vehicle_state == "Standard Impound" then
				Menu.addButton(tostring(value.name), "OptionVehicle", value.id, "Impounded: $500", " Engine %:" .. enginePercent .. "", " Body %:" .. bodyPercent .. "")
			elseif value.vehicle_state == "Police Impound" then
				Menu.addButton(tostring(value.name), "OptionVehicle", value.id, "Impounded: $1500", " Engine %:" .. enginePercent .. "", " Body %:" .. bodyPercent .. "")
			elseif curGarage ~= current_used_garage and curGarage ~= "Any" and value.vehicle_state ~= "Out" then
				Menu.addButton(tostring(value.name), "OptionVehicle", value.id, "Garage " .. curGarage, " Engine %:" .. enginePercent .. "", " Body %:" .. bodyPercent .. "")
			else
				Menu.addButton(tostring(value.name), "OptionVehicle", value.id, tostring(value.vehicle_state) , " Engine %:" .. enginePercent .. "", " Body %:" .. bodyPercent .. "")
			end
	    end    
	end

    TriggerEvent("DoLongHudText", "It will cost $" .. estimate .. " to $" .. estimate + (estimate * 0.15) .. " @ $15 x (carCount x carCount x 2)",1)
		
    Menu.addButton("Return","MenuGarage",nil)
end


RegisterNetEvent('Garages:PhoneUpdate')
AddEventHandler('Garages:PhoneUpdate', function()
	TriggerEvent("phone:Garage",VEHICLES)
end)


function OptionVehicle(vehID)
	local vehID = vehID
    MenuTitle = "Options :"
    ClearMenu()
    Menu.addButton("Take Out", "SortirVehicule", vehID)
	--Menu.addButton("Supprimer", "SupprimerVehicule", vehID)
    Menu.addButton("Return", "ListeVehicule", nil)
end

function SortirVehicule(vehID)

	local vehID = vehID
	if firstCar == 0 then carCount = 0 end
	local impound = false
	local dist = #(vector3(550.09,-55.45,71.08) - GetEntityCoords(LocalPed()))

	local rooster = exports["isPed"]:GroupRank("rooster_academy")

	if dist < 15.0 then
		impound = true
	end
	local garagecount = 1
	for i = 1, #garages do
		if current_used_garage == garages[i] then
			garagecount = i
		end
	end
	local garagefree = false

	if addedGarages[current_used_garage] ~= nil then
		garagefree = true
	end
	for i = 1, #garages do
		if garages[i].garage == "House" then
			garagefree = true
		end
	end

	TriggerServerEvent('garages:CheckForSpawnVeh', vehID, carCount,impound, current_used_garage,garagefree)
	firstCar = 1
	CloseMenu()

end

--[[
function SupprimerVehicule(vehID)
	local vehID = vehID
		TriggerServerEvent('garages:CheckForDelVeh', vehID)
    Menu.addButton("Fermer","CloseMenu",nil) 
end
]]--

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function CloseMenu()
	TriggerEvent("inmenu",false)
    Menu.hidden = true
end

function LocalPed()
	return PlayerPedId()
end

function IsPlayerInRangeOfGarage()
	return inrangeofgarage
end

function Chat(debugg)
    TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
end

isJudge = false
RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
	isJudge = true
end)

RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
    isJudge = false
end)
RegisterNetEvent("car:dopayment")
AddEventHandler("car:dopayment", function(plate)
	local rankCarshop = exports["isPed"]:GroupRank("car_shop")
    local rankImport = exports["isPed"]:GroupRank("illegal_carshop")
    local salesman = false
	if rankCarshop > 0 or rankImport > 0 then
		salesman = true
	end
	TriggerServerEvent('car:dopayment', plate, salesman)
end)

RegisterNetEvent("car:carpaymentsowed")
AddEventHandler("car:carpaymentsowed", function()
    TriggerServerEvent("car:Outstanding")
end)

current_used_garage = "Any"

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	TriggerEvent("RecreateGarages")
end) 

function spawnJudgeCar(model,garage)

		RequestModel(model)
		while not HasModelLoaded(model) do
		  Wait(1)
		end 

		local playerPed = PlayerPedId()
		local spawnPos = garages[garage].spawn
		local spawned_car = CreateVehicle(model, spawnPos[1], spawnPos[2], spawnPos[3], spawnPos[4], true, false)

		local plate = "TRU ".. GetRandomIntInRange(1000, 9000)

		SetVehicleOnGroundProperly(spawned_car)

		SetVehicleNumberPlateText(spawned_car, plate)
		TriggerEvent("keys:addNew",spawned_car,plate)
		TriggerServerEvent('garges:addJobPlate', plate)
		SetModelAsNoLongerNeeded(model)
		SetPedIntoVehicle(playerPed, spawned_car, -1)
		--SetEntityAsMissionEntity(spawned_car,false,true)

end

Controlkey = {["generalUse"] = {38,"E"},["generalUseSecondary"] = {18,"Enter"},["generalUseThird"] = {47,"G"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["generalUse"] = table["generalUse"]
	Controlkey["generalUseSecondary"] = table["generalUseSecondary"]
	Controlkey["generalUseThird"] = table["generalUseThird"]
end)

RegisterNetEvent("RecreateGarages")
AddEventHandler("RecreateGarages", function()
	Citizen.Wait(5000)
	if not garagesRunning then
		garagesRunning = true
		local rooster = exports["isPed"]:GroupRank("rooster_academy")
		for k,v in ipairs(garages) do
			Citizen.CreateThread(function()
				if v.disabled then return end
				local pos = v.loc
				local gar = v.garage
				while garagesRunning do
					Citizen.Wait(1)

					local dist = #(vector3(pos[1],pos[2],pos[3]) - GetEntityCoords(LocalPed()))
					if dist < 35.0 then
						dist = math.floor(200 - (dist * 10))
						if dist < 0 then dist = 0 end
						if myroomtype ~= 3 and gar == "House" then

						else
							if gar == "Rooster Cab" and rooster <= 0 then

							else
								DrawMarker(20,pos[1],pos[2],pos[3],0,0,0,0,0,0,0.701,1.0001,0.3001,markerColor.Red,markerColor.Green, markerColor.Blue,dist,0,0,0,0)
							end
							
						end
					end

					if #(vector3(pos[1],pos[2],pos[3]) - GetEntityCoords(LocalPed())) < 3.0 and IsPedInAnyVehicle(LocalPed(), true) == false then
						if gar == "Rooster Cab" and rooster <= 0 then
						else
							if Menu.hidden then
								current_used_garage = garages[k].garage
							else
								DisplayHelpText('~g~'..Controlkey["generalUse"][2]..'~s~ or ~g~'..Controlkey["generalUseSecondary"][2]..'~s~ Accepts ~g~Arrows~s~ Move ~g~Backspace~s~ Exit')
							end

							if IsControlJustPressed(1, 177) and not Menu.hidden then
							--	MenuCallFunction(Menu.GUI[Menu.selection -1]["func"], Menu.GUI[Menu.selection -1]["args"])
								CloseMenu()
								PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
							end
							if (myroomtype ~= 3 and gar == "House") then

							elseif ( IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1,Controlkey["generalUseSecondary"][1]) ) and Menu.hidden then
								TriggerServerEvent("garages:CheckGarageForVeh")
								Citizen.Wait(150)
								MenuGarage()
								TriggerEvent("inmenu",true)
								selectedGarage = k
								Menu.hidden = not Menu.hidden
							elseif IsControlJustPressed(1,74)  and k == 17 and isJudge then -- H
								spawnJudgeCar("g65amg",k)
							end
							Menu.renderGUI()
						end
					end
					if dist > 200.0 then
						Citizen.Wait(2000)
					end
				end
			end)
		end
	end
end)





Citizen.CreateThread(function()
	local loc = vente_location
	pos = vente_location
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,207)
	SetBlipColour(blip, 2)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Sell Vehicle')
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
	SetBlipScale(blip, 0.7)

	checkgarage = 0
	while true do
		
		Wait(1)

		DrawMarker(27,376.6728515625,-1612.5723876953,28.29195022583,0,0,0,0,0,0,3.001,3.0001,0.5001,0,155,255,50,0,0,0,0)
		if isJudge and #(vector3(376.6728515625,-1612.5723876953,29.29195022583) - GetEntityCoords(LocalPed())) < 5 and IsPedInAnyVehicle(LocalPed(), true) == false then
			DisplayHelpText('Press on ~g~'..Controlkey["generalUse"][2]..'~s~ to sell this vehicle for the state!')		
			if IsControlJustPressed(1,Controlkey["generalUse"][1]) then
				local caissei = GetClosestVehicle(376.6728515625,-1612.5723876953,29.29195022583, 3.000, 0, 70)
				if not DoesEntityExist(caissei) then caissei = GetVehiclePedIsIn(PlayerPedId(), true) end
				if DoesEntityExist(caissei) then
					local plate = GetVehicleNumberPlateText(caissei)
					TriggerServerEvent('garages:SelVehJudge',plate)
					--SetEntityAsMissionEntity(caissei,false,true)
					Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
				else
					TriggerEvent("DoLongHudText","No Vehicle",2)
				end
			end
		end

		wait2 = #(vector3(376.6728515625,-1612.5723876953,29.29195022583) - GetEntityCoords(LocalPed()))
		if wait2 > 50.0 then
			if wait2 then
				Citizen.Wait(math.ceil(wait2) * 10)
			end
		end

	end

end)




currentlyselling = false

AddEventHandler('garages:chopshopVehicle', function()
	if not currentlyselling then
		currentlyselling = true
		Citizen.CreateThread(function()		
			local allowsale = true
			local startTime = GetGameTimer()
			TriggerEvent("DoLongHudText","Attemping Vehicle Sale",1)
			count = 12000
			while count > 0 do
				Citizen.Wait(1)
				local curTime = GetGameTimer()
				if #(vector3(712.51171875,-723.117553710938,25.9337730407715) - GetEntityCoords(LocalPed())) > 15 then	
					allowsale = false
					count = -10	
				end
				 drawTxt(0.89, 1.44, 1.0,1.0,0.6, "Selling Vehicle: " .. math.floor(GetTimeDifference(curTime, startTime)/1000) .. " out of 120 seconds", 255, 255, 255, 255)
				if GetTimeDifference(curTime, startTime) > 120000 then
					count = -1
				end
			end
			local caissei = GetClosestVehicle(215.124, -791.377, 30.836, 3.000, 0, 70)
			if not DoesEntityExist(caissei) then caissei = GetVehiclePedIsIn(PlayerPedId(), true) end
		--	SetEntityAsMissionEntity(caissei,false,true)

			if DoesEntityExist(caissei) and #(vector3(712.51171875,-723.117553710938,25.9337730407715) - GetEntityCoords(LocalPed())) < 15 and allowsale then
				TriggerEvent('keys:remove', GetVehicleNumberPlateText(caissei))
				Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
				TriggerEvent("DoLongHudText","Vehicle sold",1)
				TriggerServerEvent("garages:SelHotVeh")

			else
				TriggerEvent("DoLongHudText","No Vehicle or moved too far..",2)


			end   
			currentlyselling = false

		end)
	else
		TriggerEvent("DoLongHudText","Already selling vehicle",2)
	end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

--[[Events]]--
AddEventHandler("garages:getVehicles", function(THEVEHICLES)
    VEHICLES = {}
	VEHICLES = THEVEHICLES
	TriggerEvent("Garages:PhoneUpdate")
end)

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("garages:CheckGarageForVeh")
end)

AddEventHandler('garages:SpawnVehicle', function(oof, vehicle, plate, customized, state, Fuel)
	local car = GetHashKey(vehicle)
	local customized = json.decode(customized)
	
	Citizen.CreateThread(function()			
		Citizen.Wait(100)

		if coordlocation == nil then
			local loc = garages[selectedGarage].loc
			local caisseo = GetClosestVehicle(loc[1], loc[2], loc[3], 3.000, 0, 70)
			if DoesEntityExist(caisseo) then

				TriggerEvent("DoLongHudText", "The area is crowded",2)
				TriggerServerEvent("garages:CheckGarageForVeh")
				return
			end
		end
		print('this is garage ', oof)
	if oof == garages[selectedGarage].garage then


		if state == "Out" and coordlocation == nil then
			TriggerEvent("DoLongHudText","Not in garage",2)
		else	

			if state == "Normal Impound" then
				TriggerServerEvent('ImpoundLot')
				TriggerEvent("DoLongHudText","This vehicle cost you $100.",1)
			end

			if state == "Police Impound" then
				TriggerEvent("DoLongHudText","This vehicle cost you $1500.",1)
			end

			RequestModel(car)
			while not HasModelLoaded(car) do
			Citizen.Wait(0)
			end

			
			if coordlocation ~= nil then
				veh = CreateVehicle(car, coordlocation[1],coordlocation[2],coordlocation[3], 0.0, true, false)
			else
				local spawnPos = garages[selectedGarage].spawn
				veh = CreateVehicle(car, spawnPos[1], spawnPos[2], spawnPos[3], spawnPos[4], true, false)
			end
 				
			
			SetModelAsNoLongerNeeded(car)
			
			if Fuel < 5 then
				Fuel = 5
			end
			
			DecorSetInt(veh, "CurrentFuel", Fuel)
			DecorSetBool(veh, "PlayerVehicle", true)
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
					local isCustom = customized.mods[tostring(i)]
					if (isCustom == nil or isCustom == "-1" or isCustom == false or isCustom == 0) then
						isSet = false
					else
						isSet = true
					end
					SetVehicleMod(veh, i, customized.mods[tostring(i)], isCustom)
				end

				for i = 23, 48 do
					SetVehicleMod(veh, i, customized.mods[tostring(i)])
				end

				for i = 0, 3 do
					SetVehicleNeonLightEnabled(veh, i, customized.neon[tostring(i)])
				end

				if customized.extras ~= nil then
					for i = 1, 12 do
						local onoff = tonumber(customized.extras[i])
						if onoff == 1 then
							SetVehicleExtra(veh, i, 0)
						else
							SetVehicleExtra(veh, i, 1)
						end
					end
				end

				if customized.oldLiveries ~= nil and customized.oldLiveries ~= 24  then
					SetVehicleLivery(veh, customized.oldLiveries)
				end

				if customized.plateIndex ~= nil and customized.plateIndex ~= 4 then
					SetVehicleNumberPlateTextIndex(veh, customized.plateIndex)
				end

				-- Xenon Colors
				SetVehicleXenonLightsColour(veh, (customized.xenonColor or -1))
				SetVehicleColours(veh, customized.colors[1], customized.colors[2])
				SetVehicleExtraColours(veh, customized.extracolors[1], customized.extracolors[2])
				SetVehicleNeonLightsColour(veh, customized.lights[1], customized.lights[2], customized.lights[3])
				SetVehicleTyreSmokeColor(veh, customized.smokecolor[1], customized.smokecolor[2], customized.smokecolor[3])
				SetVehicleWindowTint(veh, customized.tint)
				SetVehicleInteriorColour(veh, customized.dashColour)
				SetVehicleDashboardColour(veh, customized.interColour)
			else

				SetVehicleColours(veh, 0, 0)
				SetVehicleExtraColours(veh, 0, 0)

			end


			TriggerEvent("keys:addNew",veh,plate)
			SetVehicleHasBeenOwnedByPlayer(veh,true)
			

			local id = NetworkGetNetworkIdFromEntity(veh)
			SetNetworkIdCanMigrate(id, true)
			



			TriggerServerEvent('garages:SetVehOut', veh, plate)

				SetPedIntoVehicle(PlayerPedId(), veh, - 1)

				TriggerServerEvent('veh.getVehicles', plate, veh)
				

			if GetEntityModel(veh) == `rumpo4` then
				SetVehicleLivery(veh,0)
			end
			
			if GetEntityModel(veh) == `rumpo` then
				SetVehicleLivery(veh,0)
			end

			if GetEntityModel(veh) == `taxi` then

				SetVehicleExtra(veh, 8, 1)
				SetVehicleExtra(veh, 9, 1)
				SetVehicleExtra(veh, 6, 0)

			end

		--	SetEntityAsMissionEntity(veh,false,true)
			TriggerEvent("chop:plateoff",plate)
		end
			
		TriggerServerEvent("garages:CheckGarageForVeh")
	else
		TriggerEvent('DoLongHudText', 'Vehicle not in garage', 2)
	end
	end)
end)

AddEventHandler('garages:StoreVehicle', function(plates)
	plates = plates
	local pos = garages[selectedGarage].loc
	Citizen.CreateThread(function()		
		exports.veh:trackVehicleHealth()
		Citizen.Wait(3000)
		local caissei = GetClosestVehicle(pos[1], pos[2], pos[3], 3.000, 0, 70)
		current_used_garage = garages[selectedGarage].garage
		if not DoesEntityExist(caissei) then caissei = GetVehiclePedIsIn(PlayerPedId(), true) end

		if #(vector3(pos[1],pos[2],pos[3]) - GetEntityCoords(caissei)) > 5 then 
			TriggerEvent("DoLongHudText", "No vehicle",2)
			return
		end

		--SetEntityAsMissionEntity(caissei,false,true)		
		local platecaissei = GetVehicleNumberPlateText(caissei)
		local fuel = GetVehicleFuelLevel(caissei)
    	if current_used_garage == "House" then
    		local d1,d2 = GetModelDimensions(GetEntityModel(caissei))

    		if d2["y"] > 3.4 then
    			TriggerEvent("DoLongHudText","This vehicle is too big.",2)
    			return
    		end
		end
		
		if DoesEntityExist(caissei) then
			NetworkRequestControlOfEntity(caissei)

			local timeout = 0

			while timeout < 1000 and not NetworkHasControlOfEntity(caissei) do
				Citizen.Wait(100)
				timeout = timeout + 100
			end

			SetEntityAsMissionEntity(caissei, true, true)
			DeleteVehicle(caissei)
			DeleteEntity(caissei)

			TriggerEvent('keys:remove', platecaissei)

			TriggerServerEvent('garages:SetVehIn', platecaissei, current_used_garage, fuel)
		else
			TriggerEvent("DoLongHudText","No Vehicle",2)
		end   

		Citizen.Wait(5000)
		TriggerServerEvent("garages:CheckGarageForVeh")
	end)
end)

AddEventHandler('garages:SelVehicle', function(vehicle, plate)
	local car = GetHashKey(vehicle)	
	local plate = plate
	Citizen.CreateThread(function()		
		Citizen.Wait(0)
		local caissei = GetClosestVehicle(215.124, -791.377, 30.836, 3.000, 0, 70)
		if not DoesEntityExist(caissei) then caissei = GetVehiclePedIsIn(PlayerPedId(), true) end
		--SetEntityAsMissionEntity(caissei,false,true)
		local platecaissei = GetVehicleNumberPlateText(caissei)
		if DoesEntityExist(caissei) then	
			if plate ~= platecaissei then					
				TriggerEvent("DoLongHudText","It's not your vehicle",2)
			else
				TriggerEvent('keys:remove', platecaissei)
				Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
				TriggerServerEvent('garages:SelVeh', plate)
				TriggerServerEvent("garages:CheckGarageForVeh")
			end
		else
			TriggerEvent("DoLongHudText","No Vehicle",2)
		end   
	end)
end)
waitingForAccept = true
local isWanting = false
local previousPlayer = 0
RegisterNetEvent('garages:SellToPlayer')
AddEventHandler('garages:SellToPlayer', function(price,plate,player)
	if waitingForAccept then
		waitingForAccept = false
		TriggerServerEvent("CancelSale",previousPlayer)
		Citizen.Wait(1000)
	end

	waitingForAccept = true
	price = tonumber(price)
	player = tonumber(player)
	if price <= 0 then return end
	if player <= 0 then return end
	previousPlayer = player
	local car = GetHashKey(vehicle)	
	local plate = plate
	Citizen.CreateThread(function()		
		Citizen.Wait(0)
		local targetPed = GetPlayerFromServerId(player)
		if not DoesPlayerExist(player) or not DoesEntityExist(GetPlayerPed(targetPed)) then
			TriggerEvent("DoLongHudText","No Person",2)
			return
		end
		local pos = GetEntityCoords(PlayerPedId())
		local pos2 = GetEntityCoords(GetPlayerPed(targetPed))
		if #(vector3(pos.x,pos.y,pos.z) - vector3(pos2.x,pos2.y,pos2.z)) < 40 then
			local caissei = GetClosestVehicle(pos.x,pos.y,pos.z, 3.000, 0, 70)
			if not DoesEntityExist(caissei) then caissei = GetVehiclePedIsIn(PlayerPedId(), true) end
			local platecaissei = GetVehicleNumberPlateText(caissei)
			if DoesEntityExist(caissei) then	
				if plate ~= platecaissei then					
					TriggerEvent("DoLongHudText","It's not your vehicle",2)
				else
					TriggerServerEvent('garages:askRequest',player)
					while waitingForAccept do
						Wait(5)
						DisplayHelpText('Waiting for other person to decide.')
					end
					if isWanting then
						TriggerServerEvent('garages:SellToPlayerEnd', plate,player,price)
					else
						TriggerEvent("DoLongHudText","Person has declined.",2)
					end
				end
			else
				TriggerEvent("DoLongHudText","No Vehicle",2)
			end
		else
			TriggerEvent("DoLongHudText","Not close enough.",2)
		end
	end)
end)

local making = false
RegisterNetEvent('CancelNow')
AddEventHandler('CancelNow', function()
	making = false
end)	

RegisterNetEvent('garages:askingForVeh')
AddEventHandler('garages:askingForVeh', function(source)
	making = true
	Citizen.CreateThread(function()	
		while making do	
			Citizen.Wait(3)
			DisplayHelpText('~g~'..Controlkey["generalUse"][2]..'~s~ to Accept Car ,~g~'..Controlkey["generalUseSecondary"][2]..'~s~ to Refuse Car.')

			if ( IsControlJustPressed(1,Controlkey["generalUse"][1])) then
				TriggerServerEvent('garages:askResult',source,true)
				making = false
			elseif IsControlJustPressed(1,Controlkey["generalUseSecondary"][1]) then
				making = false
				TriggerServerEvent('garages:askResult',source,false)
			end
		end
	end)
end)

RegisterNetEvent('garages:clientResult')
AddEventHandler('garages:clientResult', function(result)
	waitingForAccept = false
	isWanting = result
end)

RegisterNetEvent('garages:ClientEnd')
AddEventHandler('garages:ClientEnd', function(plate)
	Citizen.CreateThread(function()		
		Citizen.Wait(0)
		local pos = GetEntityCoords(PlayerPedId())
		local caissei = GetClosestVehicle(pos.x,pos.y,pos.z, 3.000, 0, 70)
		if not DoesEntityExist(caissei) then caissei = GetVehiclePedIsIn(PlayerPedId(), true) end
		local platecaissei = GetVehicleNumberPlateText(caissei)
		if DoesEntityExist(caissei) then
			TriggerEvent('keys:remove', platecaissei)
			TriggerServerEvent("garages:CheckGarageForVeh")
		else
			TriggerEvent("DoLongHudText","No Vehicle",2)
		end   
	end)
end)

RegisterNetEvent('garages:PlayerEnd')
AddEventHandler('garages:PlayerEnd', function(plate)
	Citizen.CreateThread(function()		
		Citizen.Wait(0)
		local pos = GetEntityCoords(PlayerPedId())
		local caissei = GetClosestVehicle(pos.x,pos.y,pos.z, 3.000, 0, 70)
		if not DoesEntityExist(caissei) then caissei = GetVehiclePedIsIn(PlayerPedId(), true) end
		local platecaissei = GetVehicleNumberPlateText(caissei)
		if DoesEntityExist(caissei) then	
			TriggerEvent("keys:addNew",caissei,plate)
			TriggerServerEvent("garages:CheckGarageForVeh")
		else
			TriggerEvent("DoLongHudText","No Vehicle",2)
		end   
	end)
end)

local colorblind = false
RegisterNetEvent('option:colorblind')
AddEventHandler('option:colorblind',function()
	colorblind = not colorblind

	if colorblind then
		markerColor = 
		{
			["Red"] = 200,
			["Green"] = 200,
			["Blue"] = 0
		}
	else 
		markerColor = 
		{
			["Red"] = 222,
			["Green"] = 50,
			["Blue"] = 50
		}
	end
end)

RegisterNetEvent('hotel:outfit')
AddEventHandler('hotel:outfit', function(args,sentType)
	if nearClothing then
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