local RecyclePoints = {
	{1015.4642333984,-3110.4521484375,-38.99991607666,["time"] = 0,["used"] = false},  
	{1011.2679443359,-3110.8725585938,-38.99991607666,["time"] = 0,["used"] = false},  
	{1005.8571777344,-3110.6271972656,-38.99991607666,["time"] = 0,["used"] = false},  
	{995.37841796875,-3108.6293945313,-38.99991607666,["time"] = 0,["used"] = false}, 
	{1003.0407104492,-3104.7854003906,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1008.2990112305,-3106.94140625,-38.999881744385,["time"] = 0,["used"] = false},  
	{1010.9890136719,-3104.5573730469,-38.999881744385,["time"] = 0,["used"] = false},  
	{1013.3607788086,-3106.8874511719,-38.999881744385,["time"] = 0,["used"] = false},  
	{1017.8317260742,-3104.5822753906,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1019.0430297852,-3098.9851074219,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1013.7381591797,-3100.9680175781,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1009.3251342773,-3098.8120117188,-38.999881744385,["time"] = 0,["used"] = false},  
	{1005.9111938477,-3100.9387207031,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1003.2393798828,-3093.9182128906,-38.999885559082,["time"] = 0,["used"] = false}, 
	{1008.0280151367,-3093.384765625,-38.999885559082,["time"] = 0,["used"] = false}, 
	{1010.8000488281,-3093.544921875,-38.999885559082,["time"] = 0,["used"] = false}, 
	{1016.1090087891,-3095.3405761719,-38.999885559082,["time"] = 0,["used"] = false},  
	{1018.2312011719,-3093.1293945313,-38.999885559082,["time"] = 0,["used"] = false},  
	{1025.1221923828,-3091.4680175781,-38.999885559082,["time"] = 0,["used"] = false}, 
	{1024.9321289063,-3096.4670410156,-38.999885559082,["time"] = 0,["used"] = false}, 
}

local dropPoints = {
	{1001.375,-3108.3840332031,-38.999900817871},
	{997.32006835938,-3099.3923339844,-38.999900817871},
	{1022.0564575195,-3095.892578125,-38.999855041504},
	{1022.1699829102,-3106.6181640625,-38.999855041504},
}


RegisterNetEvent('missionSystem:updatePoints')
AddEventHandler('missionSystem:updatePoints', function(result)
	RecyclePoints = result
end)
-----------------------------
-- Metal Harvest
-----------------------------
isRunningCrate = false

function runRecycle()
	local daytime = exports["isPed"]:isPed("daytime")
	if not daytime then
		TriggerEvent("DoLongHudText","You can only run the factory 7am-7pm!",2)
		return
	end
	isRunningCrate = true
	local isHolding = false

	TriggerEvent("attachItem","crate01")
    RequestAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(GetPlayerPed(-1),"anim@heists@box_carry@","idle",2.0, -8, 180, 49, 0, 0, 0, 0)
    Wait(1000)
    TaskPlayAnim(GetPlayerPed(-1),"anim@heists@box_carry@","idle",2.0, -8, 180000000, 49, 0, 0, 0, 0)
    
    isHolding = true
    local rnd = math.random(1,4)

    while isHolding do
    	Wait(0)
    	if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),dropPoints[rnd][1],dropPoints[rnd][2],dropPoints[rnd][3], true) <= 40 then
    		DrawText3Ds(dropPoints[rnd][1],dropPoints[rnd][2],dropPoints[rnd][3], "Drop Material")
    		if IsControlJustPressed(1, 38) and IsPedInAnyVehicle(GetPlayerPed(-1), false) ~= 1 then
	    		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),dropPoints[rnd][1],dropPoints[rnd][2],dropPoints[rnd][3], true) <= 3 then
	    			isHolding = false
	    		end
			end
			if IsPedRunning(PlayerPedId()) then
				SetPedToRagdoll(PlayerPedId(),2000,2000, 3, 0, 0, 0)
				Wait(2100)
				TaskPlayAnim(GetPlayerPed(-1),"anim@heists@box_carry@","idle",2.0, -8, 180000000, 49, 0, 0, 0, 0)
			end
    	end
    end

    ClearPedTasks(GetPlayerPed(-1))
    TriggerEvent("destroyProp")
    FreezeEntityPosition(GetPlayerPed(-1),true)
    RequestAnimDict("mp_car_bomb")
    TaskPlayAnim(GetPlayerPed(-1),"mp_car_bomb","car_bomb_mechanic",2.0, -8, 180,49, 0, 0, 0, 0)
    Wait(100)
    TaskPlayAnim(GetPlayerPed(-1),"mp_car_bomb","car_bomb_mechanic",2.0, -8, 1800000,49, 0, 0, 0, 0)
    Wait(3000)
    ClearPedTasks(GetPlayerPed(-1))
    FreezeEntityPosition(GetPlayerPed(-1),false)

    if math.random(3) == 3 then
    	TriggerEvent('player:receiveItem',"recyclablematerial", math.random(5,15))
	end

	TriggerEvent("DoShortHudText","Nice work, keep it up!")
    isRunningCrate = false

end


function getIsOnBoat(PlayerPos)
	if PlayerPos.z > 30.0 then
		return true
	end
	return false
end

isTrading = false
isFishing = false

local JustPickedWeed = false
local JustDriedWeed = false
local JustPackedWeed = false



RegisterNetEvent('weed:spam-prevent')
AddEventHandler('weed:spam-prevent', function(prevent)
	if prevent == "picking" then
		Wait(900000)
		JustPickedWeed = false
	elseif prevent == "drying" then
		Wait(900000)
		JustDriedWeed = false
	else
		Wait(900000)
		JustPackedWeed = false
	end
end)

Citizen.CreateThread(function()
listOn = false
	while true do

		Wait(5)

		local PlayerPos = GetEntityCoords(PlayerPedId())
		
		for k,v in pairs(RecyclePoints) do
			if GetDistanceBetweenCoords(PlayerPos, v[1],v[2],v[3], true) <= 3 and not v.used and not isRunningCrate then
				DrawText3Ds(v[1],v[2],v[3], "Material, Pickup with E")
			end
		end
		
		if GetDistanceBetweenCoords(PlayerPos, 994.38,-3099.98,-38.99, true) <= 4 then
			DrawText3Ds(994.38,-3099.98,-38.99, "Trading, Press E to turn Recyclable Material into Useful Materials")
		end


		if GetDistanceBetweenCoords(PlayerPos, -1171.6, -1572.13, 4.67, true) <= 2 then	
			DrawText3Ds(-1171.6, -1572.13, 4.67, "Sell Weed x5")
		end

		if GetDistanceBetweenCoords(PlayerPos, 5.87, -1601.48, 29.3, true) <= 5 then	
			DrawText3Ds(5.87, -1601.48, 29.3, "Sell Meat x5")
		end		

		if IsControlJustPressed(1, 38) and IsPedInAnyVehicle(GetPlayerPed(-1), false) ~= 1 then


		--	if not playing_femote and getIsOnBoat(PlayerPos) then
		--		if GetDistanceBetweenCoords(PlayerPos,1429.06,4048.65,30.02) < 350 then
		--			local targetspeed = GetEntitySpeed(GetPlayerPed(-1)) * 3.6
		--			if targetspeed < 7 then			
		--				fishingStart()	
		--			end	
		--		else
		--			TriggerEvent("DoShortHudText","Try fishing in the Sandy Shores Lake.")
		--		end
		--	end

			-- HARVEST WEED - START
			if GetDistanceBetweenCoords(PlayerPos, 2221.7973632813,5577.0966796875,53.844783782959, true) <= 10 then		
							
				if JustDriedWeed or JustPackedWeed then
					TriggerEvent("DoLongHudText","You are too tired from a different task, either wait 15 minutes or get help!")
				else
					if not JustPickedWeed then
						JustPickedWeed = true
						TriggerEvent("weed:spam-prevent","picking")
					end
					TriggerEvent("animation:farm")
					TriggerEvent("player:receiveItem","wetbud",math.random(3))
				end
			end		
			-- HARVEST WEED - END			

			if GetDistanceBetweenCoords(PlayerPos, -1171.6, -1572.13, 4.67, true) <= 1 then						
				-- selling bud
				local smallbud = exports["np-inventory"]:hasEnoughOfItem("smallbud",5,false)
				if smallbud then
					TriggerEvent("inventory:removeItem", "smallbud", 5)
					TriggerServerEvent( 'mission:completed', 250 )
				else
					TriggerEvent("DoShortHudText","You need atleast 5 bags to sell here.")
				end

			end	

			if GetDistanceBetweenCoords(PlayerPos, 3818.36, 4441.23, 2.81, true) <= 5 then						
				
				if JustPickedWeed or JustPackedWeed then
					TriggerEvent("DoLongHudText","You are too tired from a different task, either wait 15 minutes or get help!")
				else
					if not JustDriedWeed then
						TriggerEvent("weed:spam-prevent","drying")
						JustDriedWeed = true
					end
					local wetbud = exports["np-inventory"]:hasEnoughOfItem("wetbud",5,false)
					if wetbud then

						local finished = exports["np-taskbar"]:taskBar(10000,"Drying Weed",false,false,playerVeh)
						if (finished == 100) then
							TriggerEvent("inventory:removeItem", "wetbud", 5)
							TriggerEvent("player:receiveItem","driedbud",math.random(10))
						end
					else
						TriggerEvent("DoShortHudText","You need atleast 5 wet buds to dry here.")
					end
				end
			end	
			


			if GetDistanceBetweenCoords(PlayerPos, 3825.82, 4441.26, 2.81, true) <= 5 then						
				
				if JustPickedWeed or JustDriedWeed then
					TriggerEvent("DoLongHudText","You are too tired from a different task, either wait 15 minutes or get help!")
				else
					if not JustPackedWeed then
						TriggerEvent("weed:spam-prevent","packing")
						JustPackedWeed = true
					end
					local wetbud = exports["np-inventory"]:hasEnoughOfItem("driedbud",5,false)
					if wetbud then

						local finished = exports["np-taskbar"]:taskBar(10000,"Packing Weed",false,false,playerVeh)
						if (finished == 100) then
							TriggerEvent("inventory:removeItem", "driedbud", 5)
							TriggerEvent("player:receiveItem","smallbud",math.random(10))
						end
					else
						TriggerEvent("DoShortHudText","You need atleast 5 dried buds to package here.")
					end
				end
			end	

			if GetDistanceBetweenCoords(PlayerPos, 5.87, -1601.48, 29.3, true) <= 5 then						
				-- selling bud
				
				local smallbud = exports["np-inventory"]:hasEnoughOfItem("freshmeat",5,false)
				if smallbud then
					TriggerEvent("inventory:removeItem", "freshmeat", 5)
					TriggerServerEvent( 'mission:completed', 250 )
				else
					TriggerEvent("DoShortHudText","You need atleast 5 to sell here.")
				end
			end	

			-- HARVEST Metals - START
			for k,v in pairs(RecyclePoints) do
				if GetDistanceBetweenCoords(PlayerPos, v[1],v[2],v[3], true) <= 2 then
					if not v.used and not isRunningCrate then
						v.used = true
						TriggerServerEvent('missionSystem:UpdateClients',RecyclePoints,k)
						runRecycle()
					end
				end
			end

			if GetDistanceBetweenCoords(PlayerPos, 994.38,-3099.98,-38.99, true) <= 3 and not isTrading then
				TriggerEvent("server-inventory-open", "141", "Craft"); 
			end
			
			Wait(2500)

		end

	end

end)


searchlocs = {
	[1] = { ["x"] = 3201.2182617188, ["y"] = -391.48400878906, ["z"] = -23.259761810303},
	[2] = { ["x"] = 3196.9177246094, ["y"] = -408.05932617188, ["z"] = -27.876317977905},
	[3] = { ["x"] = 3215.7932128906, ["y"] = -407.1276550293, ["z"] = -44.167171478271},
	[4] = { ["x"] = 3206.1162109375, ["y"] = -375.3466796875, ["z"] = -36.000392913818},
	[5] = { ["x"] = 3200.2814941406, ["y"] = -379.67575073242, ["z"] = -34.961269378662},
	[6] = { ["x"] = 3187.3615722656, ["y"] = -332.20944213867, ["z"] = -29.669620513916},
	[7] = { ["x"] = 3179.2360839844, ["y"] = -312.16946411133, ["z"] = -25.496395111084},
	[8] = { ["x"] = 3172.1965332031, ["y"] = -317.11364746094, ["z"] = -27.636051177979},
	[9] = { ["x"] = 3174.7990722656, ["y"] = -302.24227905273, ["z"] = -23.497297286987},
	[10] = { ["x"] = 3171.578125, ["y"] = -296.20367431641, ["z"] = -13.480889320374},
	[11] = { ["x"] = 3154.416015625, ["y"] = -296.89733886719, ["z"] = -28.087270736694},
	[12] = { ["x"] = 3158.9484863281, ["y"] = -281.97003173828, ["z"] = -27.074890136719},
	[13] = { ["x"] = 3150.7426757813, ["y"] = -262.9921875, ["z"] = -28.271263122559},
	[14] = { ["x"] = 3150.8854980469, ["y"] = -217.15423583984, ["z"] = -16.165866851807},
	[15] = { ["x"] = 3120.6462402344, ["y"] = -200.17106628418, ["z"] = -24.049646377563},
	[16] = { ["x"] = 3140.7524414063, ["y"] = -316.0227355957, ["z"] = -24.688371658325},
	[17] = { ["x"] = 3146.8132324219, ["y"] = -247.95794677734, ["z"] = -24.676942825317},
	[18] = { ["x"] = 3165.4816894531, ["y"] = -258.66400146484, ["z"] = -26.750165939331},
	[19] = { ["x"] = 3181.0842285156, ["y"] = -317.25454711914, ["z"] = -26.883680343628},
	[20] = { ["x"] = 3180.0959472656, ["y"] = -341.40322875977, ["z"] = -30.784688949585},
	[21] = { ["x"] = 3193.1364746094, ["y"] = -363.17828369141, ["z"] = -30.75234413147},
	[22] = { ["x"] = 3197.1911621094, ["y"] = -385.39462280273, ["z"] = -35.836166381836},
	[23] = { ["x"] = 3182.8552246094, ["y"] = -390.6247253418, ["z"] = -29.592353820801},
	[24] = { ["x"] = 3141.5588378906, ["y"] = -367.74792480469, ["z"] = -21.118682861328},
	[25] = { ["x"] = 3119.9138183594, ["y"] = -345.11264038086, ["z"] = -24.653188705444},
	[26] = { ["x"] = 3118.1330566406, ["y"] = -306.34729003906, ["z"] = -16.11749458313},
	[27] = { ["x"] = 3142.1520996094, ["y"] = -283.90283203125, ["z"] = -10.221350669861},
	[28] = { ["x"] = 3148.6247558594, ["y"] = -280.36285400391, ["z"] = -9.3033046722412},
	[29] = { ["x"] = 3156.5888671875, ["y"] = -279.69830322266, ["z"] = -7.2221312522888},
	[30] = { ["x"] = 3141.9328613281, ["y"] = -260.60629272461, ["z"] = -26.25365447998},
	[31] = { ["x"] = 3157.6818847656, ["y"] = -251.28622436523, ["z"] = -28.205274581909},
	[32] = { ["x"] = 3159.1472167969, ["y"] = -224.02615356445, ["z"] = -16.791307449341},
	[33] = { ["x"] = 3118.2922363281, ["y"] = -227.54614257813, ["z"] = -20.618988037109},
	[34] = { ["x"] = 3163.9130859375, ["y"] = -273.08697509766, ["z"] = -6.8318490982056},
	[35] = { ["x"] = 3166.4831542969, ["y"] = -307.53030395508, ["z"] = -10.113006591797},
	[36] = { ["x"] = 3164.4318847656, ["y"] = -323.21084594727, ["z"] = -12.844867706299},
	[37] = { ["x"] = 3168.4270019531, ["y"] = -331.61938476563, ["z"] = -25.868635177612},
	[38] = { ["x"] = 3181.1440429688, ["y"] = -350.92611694336, ["z"] = -29.355766296387},
	[39] = { ["x"] = 3167.3950195313, ["y"] = -322.44485473633, ["z"] = -12.537293434143},
	[40] = { ["x"] = 3173.3049316406, ["y"] = -325.94842529297, ["z"] = -13.356497764587},
	[41] = { ["x"] = 3188.8291015625, ["y"] = -400.81228637695, ["z"] = -25.698865890503},
	[42] = { ["x"] = 3146.501953125, ["y"] = -404.28521728516, ["z"] = -17.819589614868},
	[43] = { ["x"] = 3146.7465820313, ["y"] = -359.43133544922, ["z"] = -21.088090896606},
}

local materialsTable = {4,26,27,28,30,31,32,33,34}
local craftingItemsTable = {47,48,50,51,52,53}
local craftingItemsChances= {90,86,65,60,40,40}

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



--{3200.0163574219,-378.68206787109,-22.250713348389},

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

------------------------------------------------

---             Fish Functions Below

------------------------------------------------


-- size is * 100
-- Fish Size Impacts sale Price
local fishTable = {
	-- small fish 
	[1] = {["name"] = "Herring",["sizeMin"] = 250,["sizeMax"] = 700,["chance"] = 20},
	[2] = {["name"] = "Hailbut",["sizeMin"] = 150,["sizeMax"] = 400,["chance"] = 5},
	[3] = {["name"] = "Perch",["sizeMin"] = 150,["sizeMax"] = 300,["chance"] = 15},
	[4] = {["name"] = "Minnow",["sizeMin"] = 50,["sizeMax"] = 100,["chance"] = 60},

	-- Noraml Sized Fish

	[5] = {["name"] = "Salmon",["sizeMin"] = 580,["sizeMax"] = 1000,["chance"] = 40},
	[6] = {["name"] = "FlatHead",["sizeMin"] = 600,["sizeMax"] = 740,["chance"] = 55},
	[7] = {["name"] = "Cod",["sizeMin"] = 750,["sizeMax"] = 1400,["chance"] = 50},
	[8] = {["name"] = "Trout",["sizeMin"] = 500,["sizeMax"] = 900,["chance"] = 60},
	[9] = {["name"] = "Bass",["sizeMin"] = 700,["sizeMax"] = 1000,["chance"] = 65},

	-- Large Fish

	[10] = {["name"] = "Barbel",["sizeMin"] = 2000,["sizeMax"] = 3100,["chance"] = 80},
	[11] = {["name"] = "TigerFish",["sizeMin"] = 300,["sizeMax"] = 2800,["chance"] = 74},
	[12] = {["name"] = "Mahseer",["sizeMin"] = 800,["sizeMax"] = 2900,["chance"] = 78},
	[13] = {["name"] = "Hake",["sizeMin"] = 900,["sizeMax"] = 2300,["chance"] = 75},
	[14] = {["name"] = "Billfish",["sizeMin"] = 1200,["sizeMax"] = 3700,["chance"] = 78},
	

	-- Super Rare , Crazy Fish
	[15] = {["name"] = "Golden Cod",["sizeMin"] = 4000,["sizeMax"] = 7500,["chance"] = 98},
	[16] = {["name"] = "Shark",["sizeMin"] = 9000,["sizeMax"] = 12000,["chance"] = 99},
}


local randomMessage = {
	[1] = "You fished up a tire,' i am so tired of this. '",
	[2] = "You fished up a new set of 90's shoes.",
	[3] = "You fished up a hook",
	[4] = "You fished up a bag of trash",
	[5] = "You fished up a bag of trash",
	[6] = "You fished up a 'interestingly' shaped glass object ",
	[7] = "You fished up a sloth",
	[8] = "You fished up a skull",
	[9] = "You fished up some nude mags, 'they seem stuck together'",
	[10] = "You fished up a golden ticket, 'Oh its just coop's old one'",
	[11] = "You fished up martha's toy",
}

local fishInBucket = {}

playing_femote = false
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 


function fishingStart()
	
	isFishing = true
	playing_femote = true
	local lPed = GetPlayerPed(-1)

	RequestAnimDict("amb@world_human_stand_fishing@idle_a")
	while not HasAnimDictLoaded("amb@world_human_stand_fishing@idle_a") do
		Citizen.Wait(0)
	end

	attachModel = GetHashKey('prop_fishing_rod_01')

	SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263) 
	local bone = GetPedBoneIndex(GetPlayerPed(-1), 60309)

	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end


	FishRod = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)

	AttachEntityToEntity(FishRod, GetPlayerPed(-1), bone, 0,0,0, 0,0,0, 1, 1, 0, 0, 2, 1)


	local leftFishing = false


	TriggerEvent("playFishing")


	local zseccount = math.random(2500)

	while zseccount > 0 do
		Citizen.Wait(1)
		zseccount = zseccount - 1
		if IsControlJustPressed(1, 38) then
			zseccount = 0
			leftFishing = true
		end

	end

	if not leftFishing then

		local dicks = 250
		local fish = false 

		while dicks > 0 do

			drawTxt('You got a bite, press ~g~E~s~ to catch the ~b~ fish!',0,1,0.5,0.8,0.3,255,255,255,255)

			Citizen.Wait(1)
			dicks = dicks - 1
			if IsControlJustPressed(1, 38) then
				dicks = 0
				fish = true
			end
		end

		if fish then 

			local itemRandom = math.random(1000)
			if itemRandom < 550 then
				if itemRandom < 30 then
					TriggerEvent("DoLongHudText","You just pulled up a bag full of materials.",1)
					for i,v in ipairs(materialsTable) do
						local rnd = math.random(1,5)
						TriggerEvent('player:receiveItem',recyclablematerial, rnd)
					end
				elseif itemRandom < 55 then
					TriggerEvent("DoLongHudText","Gah! Fish snapped the line and you cut yourself.",1)
					local health = GetEntityHealth(GetPlayerPed(-1))
					SetEntityHealth(GetPlayerPed(-1),(health-15))
					TriggerEvent("Evidence:StateSet",22,1200)
				elseif itemRandom < 70 then
					TriggerEvent("DoLongHudText","You found a sealed bag of cash, how odd.",1)
					local rnd = math.random(10,100)
					TriggerServerEvent('missionSystem:caughtMoney',rnd)
				else 
					local randomMsg = math.random(8)
					TriggerEvent("DoLongHudText",randomMessage[randomMsg],1)
				end
				
			else
				local foundFish = false
				local fishNumber = 0

				repeat
					Wait(0)
					local rnd = 1
					rnd = math.random(1,16)
					if math.random(100) >= fishTable[rnd].chance then
						if rnd == 15 or rnd == 16 then
							if math.random(100) >= 25 then
								foundFish = true
								fishNumber = rnd
							end
						else
							foundFish = true
							fishNumber = rnd
						end
					end
				until foundFish

				local fishsize = math.random(fishTable[fishNumber].sizeMin,fishTable[fishNumber].sizeMax)
				TriggerEvent("DoLongHudText","You just caught a "..fishTable[fishNumber].name.." that was " .. (fishsize / 10) .. "cm long.",1)
				TriggerEvent("player:receiveItem","freshmeat",math.random(3))
			end

		else
			TriggerEvent("DoLongHudText","You took too long.",2)
		end
	end

	ClearPedTasks(lPed)
	TriggerEvent("fistpump")
	DeleteEntity(FishRod)
	playing_femote = false
	isFishing = false
end

local noFish = {
	{-815.97216796875,-1462.1270751953,37.754516601563,250},
	{-1117.2260742188,-1823.3757324219,13.025714874268,210},
	{-1034.0518798828,-1069.9602050781,13.025714874268,250},
}

function isInNoFish()
	for i,v in ipairs(noFish) do
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),v[1],v[2],v[3]) <= v[4] then return true end
	end
	return false
end

RegisterNetEvent('playFishing')
AddEventHandler('playFishing', function()

	local lPed = GetPlayerPed(-1)
	loadAnimDict( "amb@world_human_stand_fishing@base" )
	loadAnimDict( "amb@world_human_stand_fishing@idle_a" )
	ClearPedTasksImmediately(IPed)
	while playing_femote do
		TaskPlayAnim(lPed, "amb@world_human_stand_fishing@idle_a", "idle_c", 20.0, -8, -1, 16, 0, 0, 0, 0)
		Wait(8200)
	end

end)









RegisterNetEvent('animation:farm')
AddEventHandler('animation:farm', function()

		inanimation = true
		local lPed = GetPlayerPed(-1)
		RequestAnimDict("amb@world_human_gardener_plant@male@base")
		while not HasAnimDictLoaded("amb@world_human_gardener_plant@male@base") do
			Citizen.Wait(0)
		end
		
		if IsEntityPlayingAnim(lPed, "amb@world_human_gardener_plant@male@base", "base", 3) then
			ClearPedSecondaryTask(lPed)
		else
			TaskPlayAnim(lPed, "amb@world_human_gardener_plant@male@base", "base", 8.0, -8, -1, 49, 0, 0, 0, 0)
			seccount = 4
			while seccount > 0 do
				Citizen.Wait(1000)
				seccount = seccount - 1
			end
			ClearPedSecondaryTask(lPed)
		end		
		inanimation = false

end)
