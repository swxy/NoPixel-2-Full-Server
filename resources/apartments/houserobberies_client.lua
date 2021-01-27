local daytime = true
local disturbance = 0
local calledin = false
local agrodone = false
local Lockpicking = false
local mansion = false
local apartment = false
local office = false
local curHouseCoords = { ['x'] = 0.22,['y'] = 0.67,['z'] = 0.79,['h'] = 0.41, ['info'] = ' default ' }
local entryType = 1
local mygps = {}
local GPSblip
local shithouse = false
local safehouse = false
local safepos = { ["x"]=0.0, ["y"]=0.0, ["z"]=0.0 }
local safespawned = false
local rentedOffices = {}
local rentedOfficesBlips = {}
local rentedOffice = false
local rentedShop = false
local doge = 0
local shopshit = false
local PlayerStoreIdentifier = false
local trailer = false;
local house_poi = { 
	["info"] = "No House Selected", 
	["house_id"] = 0, 
	["house_model"] = 0,
	["garages"] = {}, 
	["creationpoints"] = {},
	["backdoorinside"] = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0  },
	["backdooroutside"] = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0  },
	["clothing"] = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0  },
	["storage"] = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0  },
}

markerColor = 
{
	["Red"] = 222,
	["Green"] = 50,
	["Blue"] = 50
}
local loadedShell;

-- entryType 1 == house robbery, 2 = normal housing
RegisterNetEvent('daytime')
AddEventHandler("daytime",function(passedTime)
    daytime = passedTime
end)

RegisterNetEvent('agronpcs')
AddEventHandler("agronpcs",function()
	agroNPC(true)
	agrodone = true
end)

RegisterNetEvent('traps:payment')
AddEventHandler("traps:payment",function(amount)
    TriggerServerEvent( 'mission:completed', amount )
end)

RegisterNetEvent('updatedRented')
AddEventHandler("updatedRented",function(rentedOfficesNew)
	rentedOffices = rentedOfficesNew
	for i = 1, #rentedOfficesBlips do
		RemoveBlip(rentedOfficesBlips[i])
	end
	rentedOfficesBlips = {}
	for i = 1, #rentedOffices do
	    local blip = AddBlipForCoord(rentedOffices[i]["location"]["x"], rentedOffices[i]["location"]["y"], rentedOffices[i]["location"]["z"])
        SetBlipSprite(blip, 52)
		SetBlipScale(blip, 1.0)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(rentedOffices[i]["name"])
		EndTextCommandSetBlipName(blip)
		rentedOfficesBlips[i] = blip
	end
end)

local waitingAI = {

}

RegisterNetEvent("ai:store:walkout")
AddEventHandler("ai:store:walkout", function(id)
	id = math.floor(id + 1)
	waitingAI["key"..id] = id
end)

local RentedTrapHouses = {
	[1] = {['x'] = -185.31, ['y'] = -1701.86, ['z'] = 32.78, ['h'] = 130.24, ['info'] = ' Stash1 '},
	[2] = {['x'] = 143.91,['y'] = -1656.45,['z'] = 29.34,['h'] = 227.96, ['info'] = ' Stash2 '},
	[3] = {['x'] = 214.08 , ['y'] = -1834.71, ['z'] = 27.54, ['h'] = 141.76, ['info'] = ' Stash3 '},
}

RegisterNetEvent("traps:luck:ai")
AddEventHandler("traps:luck:ai", function(id)
	if math.random(100) > 95 then
		for i = 1, #rentedOffices do
			local coords = rentedOffices[i]["location"]
			if rentedOffices[i]["trap"] and GetDistanceBetweenCoords( GetEntityCoords(GetPlayerPed(-1)) , coords["x"],coords["y"],coords["z"] ) < 5 then
				TriggerEvent("DoLongHudText","Aight, the code is: " .. rentedOffices[i]["pincode"])
			end
		end
	end
end)


RegisterNetEvent("traps:luck:aiSale")
AddEventHandler("traps:luck:aiSale", function(id)
	for i = 1, #rentedOffices do
		if rentedOffices[i]["trap"] and tonumber(rentedOffices[i]["owner"]) == 0 then
			if math.random(100) > 50 then
				TriggerEvent("DoLongHudText","Yo, I found this is a code for a trap house: " .. rentedOffices[i]["pincode"])
				return
			end
		end
	end
end)




RegisterNetEvent("ai:store:remove:nikez:sucks")
AddEventHandler("ai:store:remove:nikez:sucks", function(key,id)
	if waitingAI[key] then
		waitingAI[key] = nil
	end
end)

Citizen.CreateThread(function()
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
 	while true do
		Wait(5000)
		local playerped = GetPlayerPed(-1)
    	local playerCoords = GetEntityCoords(playerped)
		for key,v in pairs(waitingAI) do
			if rentedOffices[tonumber(v)] then
				local coords = rentedOffices[tonumber(v)]["location"]
				if GetDistanceBetweenCoords(coords["x"],coords["y"],coords["z"],playerCoords) < 100 then
					if math.random(100) > 55 then
						CreatePedFunction(v)
						TriggerServerEvent("ai:store:remove",key,v)
					end
				end
			end
		end
	end
end)





function CreatePedFunction(id)

	local hashKey = `g_m_y_salvagoon_01`
	if not rentedOffices[id]["trap"] then
		hashKey = `a_m_y_stwhi_02`
	end

	local pedType = GetPedType(hashKey)
    RequestModel(hashKey)
    while not HasModelLoaded(hashKey) do
        RequestModel(hashKey)
        Citizen.Wait(100)
    end

	local Ped = CreatePed(pedType, hashKey, rentedOffices[id]["location"]["x"], rentedOffices[id]["location"]["y"], rentedOffices[id]["location"]["z"], 270.0, 1, 1)
	DecorSetBool(Ped, 'ScriptedPed', true)
	SetPedKeepTask(Ped, false)
	TaskSetBlockingOfNonTemporaryEvents(Ped, false)
	ClearPedTasks(Ped)
	TaskWanderStandard(Ped, 10.0, 10)
	SetPedAsNoLongerNeeded(Ped)

end

local myhouseid = 0
local myhousetype = 0
local moneyhouses = {
}



local crafthouses = {
}

RegisterNetEvent("resetinhouse")
AddEventHandler("resetinhouse", function()
	myhouseid = 0
	myhousetype = 0
end)

RegisterNetEvent("resetcraftinghouses")
AddEventHandler("resetcraftinghouses", function()
	crafthouses = {}
end)

RegisterNetEvent("resetmoneyhouses")
AddEventHandler("resetmoneyhouses", function()
	moneyhouses = {}
end)

RegisterNetEvent("crafthouse")
AddEventHandler("crafthouse", function(housenumber,gangname)
	crafthouses[housenumber] = gangname
end)

RegisterNetEvent("moneyhouse")
AddEventHandler("moneyhouse", function(housenumber,gangname)
	moneyhouses[housenumber] = gangname
end)

local robbing = false
RegisterNetEvent("houserobberies:enterhouse")
AddEventHandler("houserobberies:enterhouse", function(id,firstin,isFlashbang)
	TriggerEvent("robbing",true)
	robbing = true
	DoScreenFadeOut(100)

	while IsScreenFadingOut() do
		Citizen.Wait(10)
	end
	myhouseid = id
	CreateRobberyApartment(id,false,isFlashbang)
	
	DoScreenFadeIn(1000)
	TriggerEvent("attachWeapons")
end)

local gangSpots = {
	["Strawberry"] = { ["Label"] = "North Side", ["zone"] = 1, ["GroupHashKey"] = 1166638144 },
	["Rancho"] = { ["Label"] = "East Side", ["zone"] = 3, ["GroupHashKey"] = 296331235 },
	["Chamberlain Hills"] = { ["Label"] = "North Side", ["zone"] = 1, ["GroupHashKey"] = 1166638144 },
	["Davis"] = { ["Label"] = "South Central", ["zone"] = 2, ["GroupHashKey"] = -1033021910 },
}

local allowGunChance = false
function AreaChecked()
	local gangType = exports["isPed"]:isPed("corner")
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    local Area = GetLabelText(GetNameOfZone(x, y, z))
    if gangSpots[Area] then
    	if gangSpots[Area]["zone"] ~= gangType then
    		allowGunChance = true
	    	return true
	    else
	    	allowGunChance = false
	    	return false
	    end
    end
    return false
end

RegisterNetEvent("houserobberies:createhouse")
AddEventHandler("houserobberies:createhouse", function(id,firstin,isFlashbang)
	TriggerEvent("robbing",true)
	robbing = true
	DoScreenFadeOut(1000)

	while IsScreenFadingOut() do
		Citizen.Wait(100)
	end

	myhouseid = id
	local Allowed = AreaChecked()
	if math.random(100) > 50 and Allowed then
		safehouse = true
	end
	CreateRobberyApartment(id,true,isFlashbang)

	DoScreenFadeIn(1000)
	TriggerEvent("attachWeapons")
end)

RegisterNetEvent("houserobberies:delete")
AddEventHandler("houserobberies:delete", function(id,owner,backdoor)
		
	if backdoor then
		if mansion then
			if (GetDistanceBetweenCoords(curHouseCoords["x"] , curHouseCoords["y"], curHouseCoords["z"], robberyExitCoordsMansions[myhouseid]["x"] , robberyExitCoordsMansions[myhouseid]["y"], robberyExitCoordsMansions[myhouseid]["z"] ) < 100.0 ) then
				SetEntityCoords( PlayerPedId(), robberyExitCoordsMansions[myhouseid]["x"] , robberyExitCoordsMansions[myhouseid]["y"], robberyExitCoordsMansions[myhouseid]["z"] )
			else
				SetEntityCoords(PlayerPedId(), curHouseCoords["x"] , curHouseCoords["y"], curHouseCoords["z"] )
			end
		elseif mansion2 then
			if (GetDistanceBetweenCoords(curHouseCoords["x"] , curHouseCoords["y"], curHouseCoords["z"], robberyExitCoordsMansions[myhouseid]["x"] , robberyExitCoordsMansions[myhouseid]["y"], robberyExitCoordsMansions[myhouseid]["z"] ) < 100.0 ) then
				SetEntityCoords( PlayerPedId(), robberyExitCoordsMansions[myhouseid]["x"] , robberyExitCoordsMansions[myhouseid]["y"], robberyExitCoordsMansions[myhouseid]["z"] )
			else
				SetEntityCoords(PlayerPedId(), curHouseCoords["x"] , curHouseCoords["y"], curHouseCoords["z"] )
			end
		else
			if (GetDistanceBetweenCoords(curHouseCoords["x"] , curHouseCoords["y"], curHouseCoords["z"], robberyExitCoords[myhouseid]["x"] , robberyExitCoords[myhouseid]["y"], robberyExitCoords[myhouseid]["z"] ) < 100.0 ) then
				SetEntityCoords( PlayerPedId(), robberyExitCoords[myhouseid]["x"] , robberyExitCoords[myhouseid]["y"], robberyExitCoords[myhouseid]["z"] )
			else
				SetEntityCoords(PlayerPedId(), curHouseCoords["x"] , curHouseCoords["y"], curHouseCoords["z"] )
			end
		end
	else
		SetEntityCoords(PlayerPedId(), curHouseCoords["x"] , curHouseCoords["y"], curHouseCoords["z"] )
	end

	TriggerEvent("attachWeapons")
	TriggerEvent("robbing",false)
	safespawned = false
	safe = 0
	safehouse = false
	robbing = false

	if DoesEntityExist(safe) then
		SetEntityAsNoLongerNeeded(safe)
		DeleteEntity(safe)
		DeleteObjecT(safe)
	end

	myhouseid = 0
	disturbance = 0
	myhousetype = 0
	calledin = false
	SetBlackout(false)
	
	local plypos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 2.0, 0.0)
	local plyhead = GetEntityHeading(GetPlayerPed(PlayerId()))

	if backdoor then
		SetEntityCoords(doge,curHouseCoords["x"] , curHouseCoords["y"], curHouseCoords["z"])
	else
		SetEntityCoords(doge,curHouseCoords["x"] , curHouseCoords["y"], curHouseCoords["z"])
	end
	
	Citizen.Wait(8000)
	DeleteSpawnedHouse(id,owner)
	TriggerEvent("robbery:guiclose")
	agrodone = false
end)

local CorrectHouse = 0

RegisterNetEvent("lucky:house")
AddEventHandler("lucky:house", function()

	while true do
		CorrectHouse = math.random(#robberycoordsMansions)
		if robberycoordsMansions[CorrectHouse]["office"] == 2 then
			return
		end
		Citizen.Wait(100)
	end
	
	local houseAddresss = robberycoordsMansions[CorrectHouse]["info"]
	TriggerEvent("chatMessage", "EMAIL ", 8, "Hey, I heard a house has some hot shit in it, go check it out @ " .. houseAddresss)
end)

RegisterNetEvent("houserobberies:item")
AddEventHandler("houserobberies:item", function(searchedpreviously)

	if searchedpreviously then
	else
		if math.random(100) > 60 then
			if math.random(100) > 85 then
				TriggerServerEvent('loot:useItem', 'houserobbery')
			end
			if (math.random(100) > 95) and allowGunChance then
				DropItemPed3()
			elseif (math.random(200) > 195) and not allowGunChance then
				DropItemPedBankCard()
			elseif (math.random(200) > 193) and allowGunChance then
				DropItemPedBankCard()
			elseif (math.random(200) > 193) and mansion then
				DropItemPedBankCard()
				TriggerServerEvent('loot:useItem', 'houserobbery')
			else
				DropItemPed()
			end
			-- fix me dick head
			if mansion and tonumber(myhouseid) == tonumber(CorrectHouse) then


				if math.random(100) < 20 then
				    if math.random(100) > 70 then
				      TriggerEvent("player:receiveItem","Gruppe6Card2",1)
				    else
				      TriggerEvent("player:receiveItem","Gruppe6Card3",1)
				    end
				end

				if math.random(30) == 28 then
					TriggerEvent( "player:receiveItem", "locksystem", math.random(10))
				end

				TriggerServerEvent('mission:completed', math.random(450))
			end

		else
			local distance, pedcount = closestNPC()
			local extracash = 0.1
			if pedcount > 0 then
				extracash = extracash + (pedcount / 100)
				local distancealter = (8.0 - distance) / 100
				extracash = extracash + distancealter
			end
			if factor == 75 then 
				factor = 95
			else
				factor = 70
			end
			if math.random(100) > factor then
				extracash = math.random(45) + (math.random(45) * (extracash * 3.5))
				extracash = math.ceil(extracash)
				TriggerServerEvent('mission:completed',extracash )
			else
				TriggerServerEvent('mission:completed', math.random(75))
			end
			
		end
	end
end)

enterback = false

RegisterNetEvent("breach")
AddEventHandler("breach", function(isFlashbang)

	if isFlashbang then
		if exports["np-inventory"]:hasEnoughOfItem("-73270376",1,false) then
			TriggerEvent('inventory:removeItem',"-73270376", 1)
		else
			isFlashbang = false
			TriggerEvent("DoLongHudText","You have no flashbangs entering without flash!",19)
		end
	end

   local robNum = 0
   local dick = 0
   mansion = false
   apartment = false
   shopshit = false
   enterback = false
   trailer = false
	for i=1,#robberycoords do
		if (#(vector3(robberycoords[i]["x"],robberycoords[i]["y"],robberycoords[i]["z"]) - GetEntityCoords(PlayerPedId())) < 1.5 and robberycoords[i]["apt"] ~= 1 ) then
			robNum = i
			curHouseCoords = robberycoords[i]
		end
		dick = i
	end

	if robNum == 0 then
		for i=1,#robberycoordsMansions do
			if (#(vector3(robberycoordsMansions[i]["x"],robberycoordsMansions[i]["y"],robberycoordsMansions[i]["z"]) - GetEntityCoords(PlayerPedId())) < 1.5 and robberycoords[i]["office"] ~= 1 ) then
				mansion = true
				curHouseCoords = robberycoordsMansions[i]
				robNum = i
			end
			dick = i
		end
	end

	for i=1,#robberyExitCoords do
		if (#(vector3(robberyExitCoords[i]["x"],robberyExitCoords[i]["y"],robberyExitCoords[i]["z"]) - GetEntityCoords(PlayerPedId())) < 5.5 and robberycoords[i]["apt"] ~= 1 ) then
			robNum = i
			curHouseCoords = robberycoords[i]
		end
		dick = i
	end

	if robNum == 0 then

		for i=1,#robberyExitCoordsMansions do
			
			if (#(vector3(robberyExitCoordsMansions[i]["x"],robberyExitCoordsMansions[i]["y"],robberyExitCoordsMansions[i]["z"]) - GetEntityCoords(PlayerPedId())) < 4.5 and robberycoords[i]["office"] ~= 1 ) then
				mansion = true
				curHouseCoords = robberycoordsMansions[i]
				enterback = true
				robNum = i
			end
			dick = i
		end
	end

	if robNum == 0 then
		return
	end

	local myJob = exports["isPed"]:isPed("myJob")

	if (myJob ~= "police" and myJob ~= "judge" and myJob ~= "ems") then
	    TriggerEvent("civilian:alertPolice",10.0,"robberyhouse",0)
	    TriggerEvent("client:newStress",true,200)
	end


	if robberycoords[robNum]["apt"] == 4 then
		shopshit = true
	end

	TriggerEvent("client:newStress",true,math.random(100))
    TriggerEvent("doAnim","kickindoor")
    Citizen.Wait(1000)
   	TriggerServerEvent("houserobberies:enter",robNum,mansion,isFlashbang) 

    myhousetype = 1

    if mansion then
	    myhousetype = 2
	end

end)

RegisterNetEvent("robbery:lockpickhouse")
AddEventHandler("robbery:lockpickhouse", function(isForced)

	if DoesEntityExist(safe) then
		local safeCrd = GetEntityCoords(safe)
		local myCrd = GetEntityCoords(PlayerPedId())
		if #(myCrd - safeCrd) < 5.0 then
			TriggerEvent("safecracking:loop",5,"safe:success")
			TriggerEvent("client:newStress",true,math.random(100))
		end

		return
	end
	
   local robNum = 0
   local dick = 0
   mansion = false
   shopshit = false
   apartment = false
   enterback = false
   trailer = false
	for i=1,#robberycoords do
		if (#(vector3(robberycoords[i]["x"],robberycoords[i]["y"],robberycoords[i]["z"]) - GetEntityCoords(PlayerPedId())) < 1.5 and robberycoords[i]["apt"] ~= 1 ) then
			robNum = i
			curHouseCoords = robberycoords[i]
		end
		dick = i
	end

	if robNum == 0 then
		for i=1,#robberycoordsMansions do
			if (#(vector3(robberycoordsMansions[i]["x"],robberycoordsMansions[i]["y"],robberycoordsMansions[i]["z"]) - GetEntityCoords(PlayerPedId())) < 1.5 and robberycoords[i]["office"] ~= 1 ) then
				mansion = true
				curHouseCoords = robberycoordsMansions[i]
				robNum = i
			end
			dick = i
		end
	end

	for i=1,#robberyExitCoords do
		if (#(vector3(robberyExitCoords[i]["x"],robberyExitCoords[i]["y"],robberyExitCoords[i]["z"]) - GetEntityCoords(PlayerPedId())) < 5.5 and robberycoords[i]["apt"] ~= 1 ) then
			robNum = i
			curHouseCoords = robberycoords[i]
		end
		dick = i
	end

	if robNum == 0 then

		for i=1,#robberyExitCoordsMansions do
			
			if (#(vector3(robberyExitCoordsMansions[i]["x"],robberyExitCoordsMansions[i]["y"],robberyExitCoordsMansions[i]["z"]) - GetEntityCoords(PlayerPedId())) < 4.5 and robberycoords[i]["office"] ~= 1 ) then
				mansion = true
				curHouseCoords = robberycoordsMansions[i]
				enterback = true
				robNum = i
			end
			dick = i
		end
	end


	if robNum == 0 then
		return
	end

	if daytime then
		TriggerEvent("DoLongHudText","Its too bright out.",2)
		return
	end

	Lockpicking = true
	TriggerEvent("civilian:alertPolice",10.0,"robberyhouse",0)

	Wait(300)
	TriggerEvent("animation:lockpickhouse")
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)
	Wait(1500)
	local finished = exports["np-lockpicking"]:lockpick(100,5,2,10)
	ClearPedTasks(PlayerPedId())
	if finished == 100 then 
		TriggerServerEvent("houserobberies:enter",robNum,mansion)
	else
		if math.random(1,100) > 50 then
			TriggerEvent('inventory:removeItem',"lockpick", 1)
			TriggerEvent("Evidence:StateSet",26,1200)
			TriggerEvent("evidence:bleeding")
		end  
	end
	
    TriggerEvent("gangs:robloserep")
    myhousetype = 1
    if mansion then
	    myhousetype = 2
	end

	if robberycoords[robNum]["apt"] == 4 then
		shopshit = true
	end


    TriggerEvent("civilian:alertPolice",10.0,"robberyhouse",0)
    Lockpicking = false
end)

RegisterNetEvent("house:entersuccessbackdoor")
AddEventHandler("house:entersuccessbackdoor", function(house_id,house_model,furniture,x,y,z,h)
	local house_id = tonumber(house_id)
	local house_model = tonumber(house_model)

	myhouseid = house_id
	myhousetype = house_model
	entryType = 2
	mansion = false
	apartment = false
	office = false
	beachhouse = false
	mansion2 = false
	shopshit = false
	trailer = false

	DoScreenFadeOut(2000)

	while IsScreenFadingOut() do
		Citizen.Wait(100)
	end

	TriggerEvent("house:entering")


	curHouseCoords = robberycoords[house_id]

	if house_model == 2 then
		curHouseCoords = robberycoordsMansions[house_id]
	end

	if house_model == 1 then

		if robberycoords[myhouseid]["apt"] == 1 then
			apartment = true
			buildApartment(robberycoords[myhouseid]["h"]+90.0)
		elseif robberycoords[myhouseid]["apt"] == 2 then
			beachhouse = true
			buildTrevor()
		elseif robberycoords[myhouseid]["apt"] == 3 then
			shithouse = true
			buildNorth()			
		elseif robberycoords[myhouseid]["apt"] == 4 then
			shopshit = true
			buildShop(house_id)
		else 
			buildHouse()
		end
	else

		if robberycoordsMansions[myhouseid]["office"] == 1 then
			office = true
			buildOffice2()
		elseif robberycoordsMansions[myhouseid]["office"] == 2 then
			mansion2 = true
			buildFranklin()
		else
			mansion = true
			buildMansion()
		end

	end
	SetEntityCoords(PlayerPedId(),x,y,z)
	SetEntityHeading(PlayerPedId(),h)
	TriggerEvent("inhouse",true)
	TriggerEvent("placefurniture",furniture)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	TriggerEvent("attachWeapons")

end)

RegisterNetEvent("house:entersuccess")
AddEventHandler("house:entersuccess", function(house_id,house_model,furniture)
	myhouseid = house_id
	myhousetype = house_model
	entryType = 2
	mansion = false
	rentedOffice = false
	rentedShop = false
	apartment = false
	beachhouse = false
	office = false
	mansion2 = false
	shithouse = false
	shopshit = false
	trailer = false

	DoScreenFadeOut(1000)

	while IsScreenFadingOut() do
		Citizen.Wait(100)
	end

	if rentedOffices[tonumber(house_id)] then
		if (rentedOffices[tonumber(house_id)]["trap"] ~= nil) then
			DoScreenFadeOut(1)
			TriggerEvent("house:entering")
		end
	end

	curHouseCoords = robberycoords[house_id]

	if house_model == 2 then
		curHouseCoords = robberycoordsMansions[house_id]
	end

	if house_model == 1 then
		
		if robberycoords[myhouseid]["apt"] == 1 then
			apartment = true
			buildApartment(robberycoords[myhouseid]["h"]+90.0)
		elseif robberycoords[myhouseid]["apt"] == 2 then
			beachhouse = true
			buildTrevor()
		elseif robberycoords[myhouseid]["apt"] == 3 then
			shithouse = true
			buildNorth()
		elseif robberycoords[myhouseid]["apt"] == 4 then
			shopshit = true
			buildShop()
		else
			buildHouse()
		end

	elseif house_model == 2 then
		

		if robberycoordsMansions[myhouseid]["office"] == 1 then
			office = true
			buildOffice2()
		elseif robberycoordsMansions[myhouseid]["office"] == 2 then
			mansion2 = true
			buildFranklin()			
		else
			mansion = true
			buildMansion()
		end
	elseif house_model == 3 then
		local x = rentedOffices[tonumber(house_id)]["location"]["x"]
		local y = rentedOffices[tonumber(house_id)]["location"]["y"]
		local z = rentedOffices[tonumber(house_id)]["location"]["z"]

		curHouseCoords = rentedOffices[tonumber(house_id)]["location"]
		
		buildlowOffice(x,y,z)
	elseif house_model == 4 then

		local key = 0
		for i = 1 , #rentedOffices do
			if tonumber(house_id) == tonumber(rentedOffices[i]["house_id"]) then
				key = i
			end
		end

		if key == 0 then
			DoScreenFadeIn(100)
			return 
		end

		local mycid = exports["isPed"]:isPed("cid")
		if (not rentedOffices[key]["trap"]) then
			PlayerStoreIdentifier = rentedOffices[key]["stash"]
			local x = rentedOffices[key]["location"]["x"]
			local y = rentedOffices[key]["location"]["y"]
			local z = rentedOffices[key]["location"]["z"]
			curHouseCoords = rentedOffices[key]["location"]
			buildShop1(x,y,z)
		else

			if  mycid ~= rentedOffices[key]["owner"] then
				TriggerEvent("trap:attempt",house_id)
				TriggerEvent("inventory-open-trap",false)
			else
				TriggerEvent("inventory-open-trap",true)
				PlayerStoreIdentifier = rentedOffices[key]["stash"]
				local x = rentedOffices[key]["location"]["x"]
				local y = rentedOffices[key]["location"]["y"]
				local z = rentedOffices[key]["location"]["z"]
				curHouseCoords = rentedOffices[key]["location"]
				buildShop1(x,y,z)
			end
			DoScreenFadeIn(100)
			return
		end
	elseif house_model == 5
	then
		trailer = true
		buildTrailer()
		Citizen.Wait(1000)
		DoScreenFadeIn(1000)
	end

	TriggerEvent("inhouse",true)
	TriggerEvent("placefurniture",furniture)

	Citizen.Wait(1000)
	DoScreenFadeIn(1000)


end)


local disableTrap = true
RegisterNetEvent('traphouse:open')
AddEventHandler("traphouse:open",function(house_id,pin)



	-- disable trap houses
	if disableTrap then return end

	if tonumber(pin) ~= tonumber(rentedOffices[tonumber(house_id)]["pincode"]) then
		TriggerEvent("inhouse",false)
		return
	end

	myhouseid = house_id
	myhousetype = 4
	entryType = 2
	mansion = false
	rentedOffice = false
	rentedShop = false
	apartment = false
	beachhouse = false
	office = false
	mansion2 = false
	shithouse = false
	shopshit = false
	trailer = false

	DoScreenFadeOut(2000)

	while IsScreenFadingOut() do
		Citizen.Wait(100)
	end

	if (rentedOffices[tonumber(house_id)]["trap"] ~= nil) then
		TriggerEvent("house:entering")
	end

	PlayerStoreIdentifier = rentedOffices[tonumber(house_id)]["stash"]
	local x = rentedOffices[tonumber(house_id)]["location"]["x"]
	local y = rentedOffices[tonumber(house_id)]["location"]["y"]
	local z = rentedOffices[tonumber(house_id)]["location"]["z"]
	curHouseCoords = rentedOffices[tonumber(house_id)]["location"]

	buildShop1(x,y,z)
	TriggerEvent("inhouse",true)
	TriggerEvent("placefurniture",furniture)

	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	TriggerEvent("attachWeapons")

end)


RegisterNetEvent('knockinisdehouse')
AddEventHandler("knockinisdehouse",function(house_id,house_model)
	if myhouseid == house_id and myhousetype == house_model then
		TriggerEvent('InteractSound_CL:PlayOnOne','doorknock', 0.5)
	end
end)

RegisterNetEvent('knockknock')
AddEventHandler("knockknock",function()

	local houseinfo = GetHouseInformation()
	if houseinfo == nil then	
		return
	else
		local house_model = houseinfo[2]
		local house_id = houseinfo[1]
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'doorknock', 0.5)
		TriggerServerEvent("knockhouse",house_id,house_model)
		return
	end

end)

RegisterNetEvent('knockreceive')
AddEventHandler("knockreceive",function()
	
	TriggerEvent('InteractSound_CL:PlayOnOne','doorknock', 0.5)
end)

RegisterNetEvent('housing:info')
AddEventHandler('housing:info', function(args)

	local houseinfo = GetHouseInformation()
	if houseinfo == nil then
		return
	end


	local house_model = houseinfo[2]
	local house_id = houseinfo[1]
	if house_model == 1 then
		house_name = robberycoords[house_id]["info"]
	end

	if house_model == 2 then
		house_name = robberycoordsMansions[house_id]["info"]
	end
	
	if house_model == 3 then
		house_name = rentedOffices[house_id]["name"]
	end

	TriggerEvent("DoLongHudText","Looking up Information on " .. house_name,1)
	TriggerServerEvent("house:checkavailability",house_id,house_model)

end)





modifying = false
modifyingTable = { 
	["info"] = "No House Selected", 
	["house_id"] = 0, 
	["house_model"] = 0,
	["garages"] = {}, 
	["creationpoints"] = {},
	["backdoorinside"] = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0  },
	["backdooroutside"] = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0  },
	["clothing"] = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0  },
	["storage"] = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0  },
}
function resetModifyingTable()
	modifyingTable["garages"] = {}
	modifyingTable["creationpoints"] = {}
	modifyingTable["backdoorinside"] = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0  }
	modifyingTable["backdooroutside"] = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0  }
	modifyingTable["clothing"] = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0  }
	modifyingTable["storage"] = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0  }
end

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
local startingGarages = {}
RegisterNetEvent('house:spawnpoints')
AddEventHandler('house:spawnpoints', function(spawns)
	if spawns["info"] ~= nil then

		modifyingTable = spawns
		startingGarages = modifyingTable["garages"]
	end
	TriggerEvent("DoLongHudText","Loaded.",91)
end)

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then

		for index,value in ipairs(players) do
			local target = GetPlayerPed(value)
			if(target ~= ply) then
				local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
				local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
				if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
					closestPlayer = value
					closestDistance = distance
				end
			end
		end
		
		return closestPlayer, closestDistance

	else
		TriggerEvent("DoShortHudText","Inside Vehicle.",2)
	end

end


RegisterNetEvent('houses:WipeKeys')
AddEventHandler('houses:WipeKeys', function()


	local houseinfo = GetHouseInformation()
	if houseinfo == nil then
		return
	end

	local house_model = houseinfo[2]
	local house_id = houseinfo[1]

	if house_model == 1 then
		house_name = robberycoords[house_id]["info"]
	end

	if house_model == 2 then
		house_name = robberycoordsMansions[house_id]["info"]
	end
	
	if house_model == 3 then
		house_name = rentedOffices[house_id]["name"]
	end

	TriggerServerEvent("house:wipekeys",house_id,house_model)


end)



RegisterNetEvent('houses:Mortgage')
AddEventHandler('houses:Mortgage', function()

	local houseinfo = GetHouseInformation()
	if houseinfo == nil then
		TriggerEvent("DoLongHudText","No house found!",2)
		return
	end

	local house_model = houseinfo[2]
	local house_id = houseinfo[1]
	local house_name = ""

	if house_model == 1 then
		house_name = robberycoords[house_id]["info"]
	end

	if house_model == 2 then
		house_name = robberycoordsMansions[house_id]["info"]
	end
	
	if house_model == 3 then
		house_name = rentedOffices[tonumber(house_id)]["name"]
	end



	TriggerServerEvent("house:dopayment",house_id,house_model)
	TriggerEvent("DoLongHudText","Attempting to pay Mortgage to house " .. house_name,1)

end)

RegisterNetEvent('houses:removeHouseKey')
AddEventHandler('houses:removeHouseKey', function(target)
	local houseinfo = GetHouseInformation()
	if houseinfo == nil then
		return
	end

	local house_model = houseinfo[2]
	local house_id = houseinfo[1]

	if house_model == 1 or house_model == 5 then
		house_name = robberycoords[house_id]["info"]
	end

	if house_model == 2 then
		house_name = robberycoordsMansions[house_id]["info"]
	end
	
	if house_model == 3 then
		house_name = rentedOffices[house_id]["name"]
	end
	
	TriggerServerEvent("house:removeKey",house_id, house_model, target)		
end)

RegisterNetEvent('houses:retrieveHouseKeys')
AddEventHandler('houses:retrieveHouseKeys', function()
	local houseinfo = GetHouseInformation()
	if houseinfo == nil then
		return
	end

	local house_model = houseinfo[2]
	local house_id = houseinfo[1]

	if house_model == 1 or house_model == 5 then
		house_name = robberycoords[house_id]["info"]
	end

	if house_model == 2 then
		house_name = robberycoordsMansions[house_id]["info"]
	end
	
	if house_model == 3 then
		house_name = rentedOffices[house_id]["name"]
	end
	
	TriggerServerEvent("ReturnHouseKeys", house_id)	
	print('lol')
end)



RegisterNetEvent('house:keys')
AddEventHandler('house:keys', function()
	print('lol')
	TriggerServerEvent("house:retrieveKeys",house_id,house_model)
	print(house_id, house_model)
end)

RegisterNetEvent('houses:GiveKey')
AddEventHandler('houses:GiveKey', function()

	local houseinfo = GetHouseInformation()
	if houseinfo == nil then
		return
	end

	local house_model = houseinfo[2]
	local house_id = houseinfo[1]
	house_id = tonumber(house_id)

	local house_name = ""

	if house_model == 1 or house_model == 5 then
		house_name = robberycoords[house_id]["info"]
	end

	if house_model == 2 then
		house_name = robberycoordsMansions[house_id]["info"]
	end
	
	if house_model == 3 then
		house_name = rentedOffices[tonumber(house_id)]["name"]
	end

	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 5) then
		TriggerServerEvent("house:givekey",house_id,house_model,GetPlayerServerId(t))
		TriggerEvent("DoLongHudText","Attempting to give key to house " .. house_name,1)
		return
	end	

	TriggerEvent("DoLongHudText","Failed to find near person.",2)

end)



RegisterCommand('givehkeys', function(source, args)
    print('lol')
    TriggerEvent('houses:GiveKey')
end)


local housenameraid = "none"
RegisterNetEvent('housing:enter')
AddEventHandler('housing:enter', function()
	housenameraid = "none"
	local houseinfo = GetHouseInformation()
	if houseinfo == nil then
		return
	end

	local house_model = houseinfo[2]
	local house_id = houseinfo[1]

	local house_name = ""

	if house_model == 1 then
		house_name = robberycoords[house_id]["info"]
	elseif house_model == 2 then
		house_name = robberycoordsMansions[house_id]["info"]
	elseif house_model == 3 then
		house_name = rentedOffices[tonumber(house_id)]["name"]
	elseif house_model == 4 then
		house_name = rentedOffices[tonumber(house_id)]["name"]
	elseif house_model == 5 then -- Trailers
		house_name = robberycoords[tonumber(house_id)]["info"]
	end	

	
	local myJob = exports["isPed"]:isPed("myJob")
	local LEO = false
	
	if myJob == "police" or myJob == "judge" then
		LEO = true
	end

	if modifying or LEO then
		TriggerServerEvent("house:enterhouse",house_id,house_model,true)
		housenameraid = house_name
	else
		TriggerServerEvent("house:enterhouse",house_id,house_model,false)
		housenameraid = "none"
	end

end)

RegisterCommand('enter', function(source, args)
	print('HELLO')
	TriggerEvent('housing:enter')
end)

RegisterNetEvent('housing:raid')
AddEventHandler('housing:raid', function()
	if housenameraid ~= "none" and myhouseid ~= 0 then
		TriggerEvent("server-inventory-open", "1", "house-"..housenameraid)
	end
end)

local buying = 0
local buy = false
RegisterNetEvent('housing:findsalecid')
AddEventHandler('housing:findsalecid', function(checkcid,price)
	-- name is only passed on rented offices / small shops.
	print('lol')
	if buying > 0 then
		print('not buying')
		return
	end

	local cid = exports["isPed"]:isPed("cid")
	local upfront = math.ceil(price * 0.5)

	print(cid)


	buying = 30000
	buy = false

	local housename = "Error"

	if name ~= nil then
		housename = name
	else
		housename = robberycoords[modifyingTable["house_id"]]["info"]
		if house_model == 2 then
			housename = robberycoordsMansions[modifyingTable["house_id"]]["info"]
		end
	end
	
	local weekly = upfront/20
	local weeklyafter = upfront/50

	while buying > 0 do

		if name ~= nil then
			TriggerEvent("DoLongHudText","Offered property " .. tostring(modifyingTable["info"]) .. " with down payment of $3000 then $3000 per week, Type /confirm to confirm.",91)
		else
			TriggerEvent("DoLongHudText","Your Agreement is a lease-purchase with the Real Estate Company.  Half of total purchase price as down payment must be made upon closing with 5 percent of remaining balance paid per week for a total of 24 weeks.  After fully paid, an HOA of $1,500.00 will be due every week for the entirety of the occupation.  If the client causes any harm to any employee of the Real Estate Company or does not make proper payment for 14 days, this agreement is revoked, and property surrendered.  This clause will be in perpetuity of the leaseholder’s occupation of the property. Type /confirm to confirm.",91)
		end
		Citizen.Wait(5000)
		buying = buying - 1

	end

	if buy then
		TriggerEvent("DoLongHudText","Attempting purchase - please wait.",91)
		if name ~= nil then
			TriggerServerEvent("housing:attemptsale",checkcid,3000,modifyingTable["house_id"],modifyingTable["house_model"])
		else
			TriggerServerEvent("housing:attemptsale",checkcid,upfront,modifyingTable["house_id"],modifyingTable["house_model"])
		end
	end

end)



RegisterCommand('confirm', function()
buy = true
buying = 1
end)

RegisterNetEvent('housing:confirmed')
AddEventHandler('housing:confirmed', function()
	buy = true
	buying = 0
end)

RegisterNetEvent('GarageData')
AddEventHandler('GarageData', function(garages)

	local mygarages = {}

	for i = 1, #garages do

		local house_id = tonumber(garages[i]["house_id"])
		local table_id = tonumber(garages[i]["table_id"])
		local house_model = tonumber(garages[i]["house_model"]) 
		if house_model < 3 or house_model == 5 then
			local house_name = garages[i]["house_name"]
			local x = robberycoords[house_id]["x"]
			local y = robberycoords[house_id]["y"]
			local z = robberycoords[house_id]["z"]
			if house_model == 2 then
				x = robberycoordsMansions[house_id]["x"]
				y = robberycoordsMansions[house_id]["y"]
				z = robberycoordsMansions[house_id]["z"]
			end
			mygarages["garage"..table_id] = { ["house_name"] = house_name, ["house_id"] = house_id, ["house_model"] = house_model, ["house_poi"] = garages[i]["house_poi"],  ["x"] = x,  ["y"] = y,  ["z"] = z,  ["table_id"] = garages[i]["table_id"] }
		end
	end

	TriggerEvent("house:garagelocations",mygarages)

end)



RegisterNetEvent('housing:sendPurchaseAttempt')
AddEventHandler('housing:sendPurchaseAttempt', function(cid,price)
	if cid ~= nil and price ~= nil then
		if modifying then
			TriggerServerEvent("housing:attemptsale",cid,price,modifyingTable["house_id"],modifyingTable["house_model"])
			print(modifyingTable["house_model"])
		else
			TriggerEvent("DoLongHudText","You must have a house in modify mode to sell it!",1)
		end
	end
end)

RegisterNetEvent('housing:transferHouseAttempt')
AddEventHandler('housing:transferHouseAttempt', function(cid)
	if cid ~= nil then
		if modifying then
			TriggerServerEvent("house:transferHouse",modifyingTable["house_id"],modifyingTable["house_model"],cid)
		else
			TriggerEvent("DoLongHudText","You must have a house in modify mode to transfer it!",91)
		end
	end
end)

RegisterNetEvent('housing:evictHouseAttempt')
AddEventHandler('housing:evictHouseAttempt', function()
	if modifying then
		TriggerServerEvent("house:evictHouse",modifyingTable["house_id"],modifyingTable["house_model"],cid)
	else
		TriggerEvent("DoLongHudText","You must have a house in modify mode to evict the residents!",91)
	end
end)

RegisterNetEvent('housing:smallOffice')
AddEventHandler('housing:smallOffice', function(cid,name)
	local realEstateRank = exports["isPed"]:GroupRank("real_estate")
    if realEstateRank > 0 then
		if cid ~= nil and name ~= nil then
			local crds = GetEntityCoords(PlayerPedId())
			local x = crds["x"]
			local y = crds["y"]
			local z = crds["z"]
			TriggerServerEvent("housing:attemptsale",cid,3000,0,3,name,x,y,z)
			TriggerEvent("DoLongHudText","Attempting Sale.",1)
		end
	else
		TriggerEvent("DoLongHudText","You can not do this.",2)
	end
end)

RegisterNetEvent('housing:deleteOffice')
AddEventHandler('housing:deleteOffice', function(cid,name)
	local realEstateRank = exports["isPed"]:GroupRank("real_estate")
    if realEstateRank > 0 then
		if cid ~= nil and name ~= nil then
			TriggerServerEvent("housing:deleteShopOrOffice", cid, name, 3)
		end
	else
		TriggerEvent("DoLongHudText","You can not do this.",2)
	end
end)

RegisterNetEvent('housing:smallShop')
AddEventHandler('housing:smallShop', function(cid,name)
	local realEstateRank = exports["isPed"]:GroupRank("real_estate")
    if realEstateRank > 0 then
		if cid ~= nil and name ~= nil then
			local crds = GetEntityCoords(PlayerPedId())
			local x = crds["x"]
			local y = crds["y"]
			local z = crds["z"]
			TriggerServerEvent("housing:attemptsale",cid,3000,0,4,name,x,y,z)
			TriggerEvent("DoLongHudText","Attempting Sale.",1)
		end
	else
		TriggerEvent("DoLongHudText","You can not do this.",2)
	end
end)

RegisterNetEvent('housing:deleteShop')
AddEventHandler('housing:deleteShop', function(cid,name)
	local realEstateRank = exports["isPed"]:GroupRank("real_estate")
    if realEstateRank > 0 then
		if cid ~= nil and name ~= nil then
			TriggerServerEvent("housing:deleteShopOrOffice", cid, name, 4)
		end
	else
		TriggerEvent("DoLongHudText","You can not do this.",2)
	end
end)

local garageswiped = false
RegisterNetEvent('housing:info:realtor')
AddEventHandler('housing:info:realtor', function(args)
	if modifying then
		if args == "reset" then
			resetModifyingTable()
			TriggerEvent("DoLongHudText","Your house editing has been reset but has not saved!",91)
			return
		end

		if args == "stop" then
			modifying = false
			resetModifyingTable()
			TriggerEvent("DoLongHudText","You have stopped!",1)
			return
		end

		if args == "creationpoint" then
			local coords = GetEntityCoords(PlayerPedId())
			local heading = GetEntityHeading(PlayerPedId())
			modifyingTable["creationpoints"][#modifyingTable["creationpoints"] + 1] = { ["x"] = coords["x"], ["y"] = coords["y"], ["z"] = coords["z"], ["h"] = heading }
			TriggerEvent("DoLongHudText","A new creation point has been set, there is " .. #modifyingTable["creationpoints"] .. " in total!",1)
			return
		end

		if args == "setclothing" then
			local coords = GetEntityCoords(PlayerPedId())
			local heading = GetEntityHeading(PlayerPedId())
			modifyingTable["clothing"] = { ["x"] = coords["x"], ["y"] = coords["y"], ["z"] = coords["z"], ["h"] = heading }
			TriggerEvent("DoLongHudText","A new clothing area has been set, there is " .. #modifyingTable["clothing"] .. " in total!",1)
			return
		end

		if args == "setstorage" then
			local coords = GetEntityCoords(PlayerPedId())
			local heading = GetEntityHeading(PlayerPedId())
			modifyingTable["storage"] = { ["x"] = coords["x"], ["y"] = coords["y"], ["z"] = coords["z"], ["h"] = heading }
			TriggerEvent("DoLongHudText","A new storage area has been set, there is " .. #modifyingTable["storage"] .. " in total!",1)
			return
		end

		if args == "setgarage" then
			local coords = GetEntityCoords(PlayerPedId())
			local heading = GetEntityHeading(PlayerPedId())
			modifyingTable["garages"][#modifyingTable["garages"] + 1] = { ["x"] = coords["x"], ["y"] = coords["y"], ["z"] = coords["z"], ["h"] = heading }
			TriggerEvent("DoLongHudText","A new garage has been set, there is " .. #modifyingTable["garages"] .. " in total!",1)
			return
		end

		if args == "wipegarages" then
			local coords = GetEntityCoords(PlayerPedId())
			local heading = GetEntityHeading(PlayerPedId())
			modifyingTable["garages"] = {}
			TriggerEvent("DoLongHudText","Garages for " .. modifyingTable["info"] .. " have been wiped!",1)
			garageswiped = true
			return
		end

		if args == "backdoorinside" then
			local coords = GetEntityCoords(PlayerPedId())
			local heading = GetEntityHeading(PlayerPedId())
			modifyingTable["backdoorinside"] = { ["x"] = coords["x"], ["y"] = coords["y"], ["z"] = coords["z"], ["h"] = heading }
			TriggerEvent("DoLongHudText","Door Set",1)
			return
		end

		if args == "backdooroutside" then
			local coords = GetEntityCoords(PlayerPedId())
			local heading = GetEntityHeading(PlayerPedId())
			modifyingTable["backdooroutside"] = { ["x"] = coords["x"], ["y"] = coords["y"], ["z"] = coords["z"], ["h"] = heading }
			TriggerEvent("DoLongHudText","Door Set",1)
			return
		end

		if args == "update" then
			-- TriggerServerEvent("house:updatespawns",modifyingTable,garageswiped,startingGarages)
			TriggerServerEvent("house:updatespawns",modifyingTable, modifyingTable["house_id"])
			return
		end

	end

	local houseinfo = GetHouseInformation()
	if houseinfo == nil then
		return
	end	


	if args == "unlock" and modifying then

		TriggerServerEvent("housing:unlockRE",houseinfo[1],houseinfo[2])
		return
	end

	if args == "unlock" then

		TriggerServerEvent("housing:unlock",houseinfo[1],houseinfo[2])
	elseif args == "modify" then
		print('lol')
		
		if modifying then
			TriggerEvent("DoLongHudText",modifyingTable["info"] .. " is already being modified.",91)
		else
			garageswiped = false
			local house_model = houseinfo[2]
			local house_id = houseinfo[1]
			local house_name = robberycoords[house_id]["info"]
			if house_model == 2 then
				house_name = robberycoordsMansions[house_id]["info"]
			end	


			modifyingTable["info"] = house_name
			modifyingTable["house_model"] = house_model
			modifyingTable["house_id"] = house_id
			print(house_id, house_name, house_model)
			modifying = true
			TriggerServerEvent("housing:requestSpawnTable",modifyingTable, house_id)
			print(house_id)
			print(house_model)
			TriggerEvent("DoLongHudText",house_name .. " is loading.",1)

		end

	end

end)

RegisterCommand('realtor', function(source, args)
TriggerEvent('housing:info:realtor', tostring(args[1]))
end)


RegisterCommand('sell2', function(source, args)
	TriggerEvent('housing:findsalecid', tonumber(args[1]), tonumber(args[2]))
end)

RegisterNetEvent('housing:exit:backdoor')
AddEventHandler('housing:exit:backdoor', function(x,y,z,h)
	DeleteSpawnedHouse(0,false)
	SetEntityCoords(PlayerPedId(),x,y,z)
	SetEntityHeading(PlayerPedId(),h)
	TriggerEvent("inhouse",false)
	myhouseid = 0
	myhousetype = 0
	entryType = 0
end)


RegisterNetEvent('safe:success')
AddEventHandler('safe:success', function()
	DeleteEntity(safe)
	DeleteObject(safe)
	SetEntityAsNoLongerNeeded(safe)
	safepos = { ["x"]=0, ["y"]=0, ["z"]=0 }
	if myhousetype == 2 then
		--mansion
		TriggerServerEvent( 'mission:completed',math.random(1500) )
	else

		DropItemPed2()


	end

    if math.random(12) < 3 then
	        TriggerEvent("DoLongHudText", "The lockpick bent out of shape.",2)
	        TriggerEvent("inventory:removeItem","lockpick", 1)
	    end

end)



---1346995970
safe = 0
function CreateSafe(x,y,z)

	safespawned = true
	safepos = { ["x"]=x, ["y"]=y, ["z"]=z }
	local safemodel = `prop_ld_int_safe_01`
	RequestModel(safemodel)
	while not HasModelLoaded(safemodel) do
		Citizen.Wait(100)
	end
	safe = CreateObject(safemodel,x,y,z,true,false,false)

	FreezeEntityPosition(safe,true)

end

function ExitHouse()
	DeleteSpawnedHouse(0,false)
	SetEntityCoords(PlayerPedId(),curHouseCoords["x"],curHouseCoords["y"],curHouseCoords["z"])
	TriggerEvent("inhouse",false)
	TriggerEvent("robbing",false)
	myhouseid = 0
	myhousetype = 0
	entryType = 0
end

function GetHouseInformation()
	local house_model = 0
	local house_id = 0
	local housefound = false
	local houseinfo = { [1] = house_id, [2] = house_model }
	for i=1,#robberycoords do
		if (#(vector3(robberycoords[i]["x"],robberycoords[i]["y"],robberycoords[i]["z"]) - GetEntityCoords(PlayerPedId())) < 1.2 ) then
			house_id = i

			if robberycoords[i]["trailer"] ~= nil
			then
				house_model = 5
			else
				house_model = 1
			end
			housefound = true
			curHouseCoords = robberycoords[i]

		end
	end

	if house_id == 0 then

		for i=1,#robberycoordsMansions do
			if (#(vector3(robberycoordsMansions[i]["x"],robberycoordsMansions[i]["y"],robberycoordsMansions[i]["z"]) - GetEntityCoords(PlayerPedId())) < 1.1 ) then
				house_id = i
				house_model = 2
				housefound = true
			
				curHouseCoords = robberycoordsMansions[i]
			end
		end
	end

	if house_id == 0 then

		for i=1,#rentedOffices do
			if (#(vector3(rentedOffices[i]["location"]["x"],rentedOffices[i]["location"]["y"],rentedOffices[i]["location"]["z"]) - GetEntityCoords(PlayerPedId())) < 1.1 ) then
				house_id = rentedOffices[i]["house_id"]
				house_model = rentedOffices[i]["house_model"]
				housefound = true

				curHouseCoords = rentedOffices[i]["location"]
			end
		end

	end

	if housefound then
		houseinfo = { [1] = house_id, [2] = house_model }
		return houseinfo
	else
		print('house not found')
		TriggerEvent("DoLongHudText","No house found!",2)
	end
end

RegisterNetEvent('animation:lockpickhouse')
AddEventHandler('animation:lockpickhouse', function()
    local lPed = PlayerPedId()
    RequestAnimDict("veh@break_in@0h@p_m_one@")
    while not HasAnimDictLoaded("veh@break_in@0h@p_m_one@") do
        Citizen.Wait(0)
    end
    while Lockpicking do
        if not IsEntityPlayingAnim(lPed, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3) then
            TaskPlayAnim(lPed, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 1, 0.0, 0, 0, 0)
            --TaskPlayAnim(ped, animDictionary, animationName, speedIN, speedOUT, duration, flag, Animation Start, lockX, lockY, lockZ)
            Citizen.Wait(1500)
            ClearPedTasks(PlayerPedId())
        end
        Citizen.Wait(1)
    end
    ClearPedTasks(lPed)
end)

function DropItemPed2()

	local pos = GetEntityCoords(PlayerPedId())

	local information = {
        ["fakeWeaponData"] = true,
    }      

    TriggerEvent('player:receiveItem',"plastic",20)

	if math.random(100) > 95 then
		TriggerEvent('player:receiveItem',453432689,1, true,information)
	end

	if math.random(100) > 95 then
		TriggerEvent('player:receiveItem',1593441988,1, true,information)
	end

	if math.random(100) > 95 then
		TriggerEvent('player:receiveItem',137902532,1, true,information)
	end




	TriggerServerEvent( 'mission:completed',math.random(500) )
	
end


-- allowGunChance

gunListRob = {
	[1] = 453432689,
	[2] = 1593441988,
	[3] = 137902532,
	[4] = 453432689,	
	[5] = 1593441988,
	[6] = 137902532,
	[7] = 453432689,
	[8] = 1593441988,
	[9] = 137902532,
	[10] = 584646201,

}

function DropItemPedBankCard()

	TriggerServerEvent( 'mission:completed',math.random(2500) )
	
end

function DropItemPed3()

	local pos = GetEntityCoords(PlayerPedId())
	local myluck = math.random(50)

	if myluck < 30 then
		TriggerEvent("player:receiveItem",gunListRob[math.random(10)],1)
	else
		TriggerEvent("player:receiveItem","rolexwatch",math.random(10,30))
	end

	TriggerServerEvent( 'mission:completed',math.random(2500) )
	
end


function DropItemPed()
    local pos = GetEntityCoords(PlayerPedId())
    local count = 1
    local itemrec = false

    if math.random(100) > 90 then
	    TriggerEvent('player:receiveItem',"plastic",10)
	end

    if mansion then
    	if math.random(100) > 75 then
    		itemrec = true
		    TriggerEvent("player:receiveItem","rolexwatch",math.random(20))
		end
    else
    	if math.random(100) > 85 then
			itemrec = true
	    	TriggerEvent("player:receiveItem","rolexwatch",math.random(10))
	    end
    end

	Citizen.Wait(100)
    if math.random(100) > 92 and not itemrec then
		TriggerServerEvent('loot:useItem', 'houserobbery')
		TriggerServerEvent('loot:useItem', 'houserobbery')
	end	
end

local shop1 = true
local shop2 = true

local pawnTable = {
	[84] = "stolencasiowatch",
	[85] = "rolexwatch",
	[86] = "stoleniphone",
	[87] = "stolens8",
	[88] = "stolennokia",
	[89] = "stolenpixel3",
	[90] = "stolen2ctchain",
	[91] = "stolen5ctchain",
	[92] = "stolen8ctchain",
	[93] = "stolen10ctchain",
	[94] = "stolenraybans",
	[95] = "stolenoakleys",
	[96] = "stolengameboy",
	[97] = "stolenpsp",
}


function PawnItems(shopnumber)
	if not daytime then
		TriggerEvent("DoLongHudText","The shop only trades during day hours.",2)
		return
	end

	local totalpay = 0
	Wait(math.random(2500))
	if shopnumber == 1 and not shop1 then
		TriggerEvent("DoLongHudText","This shop isnt currently taking items.",2)
		return
	end
	if shopnumber == 2 and not shop2 then
		TriggerEvent("DoLongHudText","This shop isnt currently taking items.",2)
		return
	end
	local i = 84
	while i < 98 do
		local dstPawn = #(GetEntityCoords(PlayerPedId()) - vector3(-1459.39, -413.89, 35.74))
		local dstPawn2 = #(GetEntityCoords(PlayerPedId()) - vector3(182.8, -1319.45, 29.32))
		local itemcount = exports["np-inventory"]:getQuantity(pawnTable[i])
		if i > 89 and i < 94 then
			totalpay = totalpay + (itemcount * math.random(100+i,250))
		else
			totalpay = totalpay + (itemcount * math.random(100,250))
		end
		TriggerEvent("inventory:removeItem",pawnTable[i], itemcount)
		i = i + 1
		if dstPawn > 3.0 and dstPawn2 > 3.0  then
			i = 98
		end
	end

	TriggerServerEvent('mission:completed',totalpay)
	if math.random(100) > 70 and totalpay > 0 then
		TriggerServerEvent("DisablePawnShop",shopnumber)
	end
end

RegisterNetEvent('pawnshop:disabled')
AddEventHandler('pawnshop:disabled', function(shopnumber,toggle)
	if shopnumber == 1 then
		shop1 = toggle
	end
	if shopnumber == 2 then
		shop2 = toggle
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

RegisterNetEvent('event:control:houserobberies')
AddEventHandler('event:control:houserobberies', function(useID)
	if useID == 1 then
		DoScreenFadeOut(1)
		TriggerEvent("inhouse",true)
		buildOfficeCentre()
		SetEntityHeading(PlayerPedId(),180.0)
		DoScreenFadeIn(1000)
		Citizen.Wait(1000)
	elseif useID == 2 then
		DoScreenFadeOut(1)
		Citizen.Wait(100)
		TriggerEvent("inhouse",false)
		CleanUpArea()
		SetEntityCoords(PlayerPedId(),172.78, -26.89, 68.35)
		SetEntityHeading(PlayerPedId(),180.0)
		DoScreenFadeIn(1000)
		Citizen.Wait(1000)
	end
end)

-- #MarkedForMarker
Citizen.CreateThread(function()

 	while true do
		Citizen.Wait(1)
		local plyId = PlayerPedId()
		local plyCoords = GetEntityCoords(plyId)
		local dstOffice = #(plyCoords - vector3(172.78, -26.89, 68.35))
		local dstOfficeExit = #(plyCoords - vector3(-1389.412, -475.6651, 72.04217))

		if dstOffice < 3.0 then
			DrawText3Ds( 172.78, -26.89, 68.35, '[E] Enter Job Centre' )
		elseif dstOfficeExit < 3.0 then
			DrawText3Ds( -1389.412, -475.6651, 72.04217, '[E] Exit Job Centre' )
		else
			if dstOffice > 100.0 then
				Citizen.Wait(2000)
			end
		end
	end
end)


shoprobbales = {
	[1] = { ["x"] = 1.50339700, ["y"] = -0.70026800, ["z"] = -10.29917900, ["name"] = "Cabinet 2" },
	[2] = { ["x"] = -1.00363200, ["y"] = -1.55289400, ["z"] = -10.30625800, ["name"] = "Under Table" },
	[3] = { ["x"] = -3.50712600, ["y"] = -4.13621600, ["z"] = -10.29625800, ["name"] = "Desk" },
	[4] = { ["x"] = 5.8819500, ["y"] = -2.50979300, ["z"] = -10.19712300, ["name"] = "Jackets" },
	[5] = { ["x"] = 5.85982700, ["y"] = -1.35874100, ["z"] = -10.29625800, ["name"] = "Jackets 2" },
	[6] = { ["x"] = 5.46626300, ["y"] = 6.03223600, ["z"] = -10.19425800, ["name"] = "Boxes" },
	[7] = { ["x"] = 5.84416200, ["y"] = 3.07377400, ["z"] = -10.22089100, ["name"] = "Front Cabinet" },
	[8] = { ["x"] = 3.04164100, ["y"] = 4.61671810, ["z"] = -10.58363900, ["name"] = "Front Counter" },
	[9] = { ["x"] = 5.86376900, ["y"] = 1.20651200, ["z"] = -10.36589100, ["name"] = " Corner Cabinet" },
	[10] = { ["x"] = 1.53442400, ["y"] = -2.41585100, ["z"] = -10.30395600, ["name"] = "Cabinet 1" },
	[11] = { ["x"] = -5.53120400, ["y"] = 0.76299670, ["z"] = -10.77236000, ["name"] = "Under Table" },
	[12] = { ["x"] = -1.00716200, ["y"] = 6.07820500, ["z"] = -10.69089300, ["name"] = "Boxes" },

	[13] = { ["x"] = 5.85982700, ["y"] = -0.15874100, ["z"] = -10.19625800, ["name"] = "Jackets 3" },
}

Citizen.CreateThread(function()
	Wait(300)
	local updatetime = 0
 	while true do
		Citizen.Wait(1)

		if modifying then

			for i = 1, #modifyingTable["creationpoints"] do
				DrawText3Ds( modifyingTable["creationpoints"][i]["x"],modifyingTable["creationpoints"][i]["y"],modifyingTable["creationpoints"][i]["z"] , 'Creation Point #' .. i )
			end

			for i = 1, #modifyingTable["garages"] do
				DrawText3Ds( modifyingTable["garages"][i]["x"],modifyingTable["garages"][i]["y"],modifyingTable["garages"][i]["z"] , 'Garage Spawn Point #' .. i )
			end

			if modifyingTable["backdoorinside"]["x"] ~= 0.0 then
				DrawText3Ds( modifyingTable["backdoorinside"]["x"],modifyingTable["backdoorinside"]["y"],modifyingTable["backdoorinside"]["z"] , 'Backdoor Inside' )
			end

			if modifyingTable["backdooroutside"]["x"] ~= 0.0 then
				DrawText3Ds( modifyingTable["backdooroutside"]["x"],modifyingTable["backdooroutside"]["y"],modifyingTable["backdooroutside"]["z"] , 'Backdoor Outside')
			end		

			if modifyingTable["clothing"]["x"] ~= 0.0 then
				DrawText3Ds( modifyingTable["clothing"]["x"],modifyingTable["clothing"]["y"],modifyingTable["clothing"]["z"] , 'Clothing Point' )
			end

			if modifyingTable["storage"]["x"] ~= 0.0 then
				DrawText3Ds( modifyingTable["storage"]["x"],modifyingTable["storage"]["y"],modifyingTable["storage"]["z"] , 'Storage Point')
			end		

		end
		
		if myhouseid == 0 then
			if not modifying then
				Citizen.Wait(1000)
			end
		else
			local plyId = PlayerPedId()
			local playerCoords = GetEntityCoords(plyId)
			local plySpeed = GetEntitySpeed(plyId)
	
			if entryType == 1 then
				NetworkOverrideClockTime( 22, 0, 0 )
				local crafting = false
				if crafthouses[myhouseid] ~= nil then
					crafting = true
		            if IsControlJustReleased(1,Controlkey["generalUse"][1]) then
		                TriggerEvent("craft:freeCraft",crafthouses[myhouseid])
		            end
		        end
		        if moneyhouses[myhouseid] ~= nil then
		        	crafting = true
		            if IsControlJustReleased(1,Controlkey["generalUse"][1]) then
		                TriggerEvent("secondaryjobs:attemptClean",moneyhouses[myhouseid])
		            end
		        end

		        if not crafting then

					local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 24.0}
					local roblist = {}
					if mansion then 
						generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 34.0}
						roblist = robbablesMansion 
					elseif shopshit then
						roblist = shoprobbales
					else
						roblist = robbables2 
					end


					for i=1,#roblist do
						if (GetDistanceBetweenCoords(generator.x + roblist[i]["x"],generator.y + roblist[i]["y"],generator.z + roblist[i]["z"], playerCoords) < 1.4 ) then
							DrawText3Ds( generator.x + roblist[i]["x"], generator.y + roblist[i]["y"], generator.z + roblist[i]["z"], '~g~'..Controlkey["housingMain"][2]..'~s~ to search ' .. roblist[i]["name"] )

							if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
								local distance, pedcount = closestNPC()
								local distadd = 0.1
								if pedcount > 0 then
									distadd = distadd + (pedcount / 70)
									local distancealter = (8.0 - distance) / 70
									distadd = distadd + distancealter
								end
								if mansion then
									disturbance = disturbance + math.random(35)
								end
								distadd = distadd * 100
								disturbance = disturbance + distadd
								if math.random(100) > 95 then
									disturbance = disturbance + 25
									TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 9.0, 'robberyglass', 1.0)
								else
									TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'robberydraw', 0.5)
								end
								
								local finished = exports["np-taskbar"]:taskBar(15000,"Browsing " ..roblist[i]["name"])
								if finished == 100 then
									TriggerEvent("client:newStress",true,math.random(200))
									TriggerServerEvent("houserobberies:rob",myhouseid,i,mansion)
								end

							end

						end
					end

					if robbing then

						TriggerEvent("robbery:guiupdate",math.ceil(disturbance))
					end
					if disturbance > 70 then

						local myJob = exports["isPed"]:isPed("myJob")
						
						if myJob == "police" or myJob == "judge" or myJob == "ems" then
							calledin = true
						end
						-- shit hit the fan chance
						if not calledin then
							local num = 150 - disturbance
							if num < 3 and GetEntitySpeed(PlayerPedId()) > 0.8 then
								calledin = true
								TriggerEvent("agronpcs")
								if mansion then
									TriggerEvent("civilian:alertPolice",8.0,"robberyhouseMansion",0)
								else
									TriggerEvent("civilian:alertPolice",8.0,"robberyhouse",0)
								end
							end
						end
					end

					if plySpeed > 1.4 then

						local distance, pedcount = closestNPC()
						local alteredsound = 0.1
						if pedcount > 0 then
							alteredsound = alteredsound + (pedcount / 100)
							local distancealter = (8.0 - distance) / 100
							alteredsound = alteredsound + distancealter
						end

						disturbance = disturbance + alteredsound
						if plySpeed > 2.0 then
							disturbance = disturbance + alteredsound
						
						elseif plySpeed > 3.0 then
							disturbance = disturbance + alteredsound
						end
					else
						disturbance = disturbance - 0.01
						if disturbance < 0 then
							disturbance = 0
						end
					end
				end

				if myhouseid ~= 0 then
					if (#(vector3(curHouseCoords["x"] , curHouseCoords["y"], curHouseCoords["z"]) - playerCoords) < 1.2 ) then
						TriggerServerEvent("houserobberies:exit",myhouseid,mansion)
						Citizen.Wait(5000)
					end
				end

				if myhouseid ~= 0 then

					if mansion then

						if (#(vector3(curHouseCoords["x"]-5.5793,curHouseCoords["y"]+5.100,curHouseCoords["z"]-32.42) - playerCoords) < 1.2 ) then
							DrawText3Ds( curHouseCoords["x"]-5.5793,curHouseCoords["y"]+5.100,curHouseCoords["z"]-32.82, '~g~'..Controlkey["housingMain"][2]..'~s~ front door' )
							if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
								TriggerServerEvent("houserobberies:exit",myhouseid,mansion,false)
								Citizen.Wait(5000)
							end
						end

						
						---522.51, 438.29 --- -502.49, 434.4
						if robberyExitCoordsMansions[myhouseid] then
							if robberyExitCoordsMansions[myhouseid]["x"] ~= 0.0 then
								if (#(vector3(curHouseCoords["x"]+14.1793,curHouseCoords["y"]+1.900,curHouseCoords["z"]-32.42) - playerCoords) < 1.2 ) then
									DrawText3Ds( curHouseCoords["x"]+14.1793,curHouseCoords["y"]+1.900,curHouseCoords["z"]-32.82, '~g~'..Controlkey["housingMain"][2]..'~s~ back door' )
									if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
										TriggerServerEvent("houserobberies:exit",myhouseid,mansion,true)
										Citizen.Wait(5000)
									end
								end
							end
						end
					elseif mansion2 then

						if (#(vector3(curHouseCoords["x"]+7.5793,curHouseCoords["y"]+6.400,curHouseCoords["z"]-19.42) - playerCoords) < 1.2 ) then
							DrawText3Ds( curHouseCoords["x"]+7.5793,curHouseCoords["y"]+6.400,curHouseCoords["z"]-19.42, '~g~'..Controlkey["housingMain"][2]..'~s~ front door' )
							if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
								TriggerServerEvent("houserobberies:exit",myhouseid,mansion,false)
								Citizen.Wait(5000)
							end
						end	
					elseif shopshit then

						if (#(vector3((curHouseCoords["x"]+3),(curHouseCoords["y"]-5),(curHouseCoords["z"]-34.0)) - playerCoords) < 1.2 ) then
							DrawText3Ds( (curHouseCoords["x"]+3),(curHouseCoords["y"]-5),(curHouseCoords["z"]-34.0), '~g~'..Controlkey["housingMain"][2]..'~s~ to leave' )
							if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
								ExitHouse()
								Citizen.Wait(5000)
							end
						end

					elseif trailer
					then
						if (#(vector3((curHouseCoords["x"]-1.443),(curHouseCoords["y"]-1.892),(curHouseCoords["z"]-74.0)) - playerCoords) < 100.2 ) then
							DrawText3Ds( (curHouseCoords["x"]-1.443),(curHouseCoords["y"]-1.892),(curHouseCoords["z"]-74.0), '~g~'..Controlkey["housingMain"][2]..'~s~ to leave' )
							if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
								ExitHouse()
								Citizen.Wait(5000)
							end
						end
					else
						if (#(vector3(curHouseCoords["x"] + 4.3,curHouseCoords["y"] - 15.95,curHouseCoords["z"]-21.42) - playerCoords) < 1.2 ) then
							DrawText3Ds( (curHouseCoords["x"] + 4.3),(curHouseCoords["y"] - 15.95),(curHouseCoords["z"]-21.42), '~g~'..Controlkey["housingMain"][2]..'~s~ front door' )
							if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
								TriggerServerEvent("houserobberies:exit",myhouseid,mansion,false)
								Citizen.Wait(5000)
							end
						end

						if robberyExitCoords[myhouseid] then
							if robberyExitCoords[myhouseid]["x"] ~= 0.0 then
								if (#(vector3(curHouseCoords["x"] -3.8,curHouseCoords["y"] + 5.25,curHouseCoords["z"]-21.42) - playerCoords) < 1.2 ) then
									DrawText3Ds( (curHouseCoords["x"] - 3.8),(curHouseCoords["y"] + 5.25),(curHouseCoords["z"]-21.42), '~g~'..Controlkey["housingMain"][2]..'~s~ back door' )
									if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
										TriggerServerEvent("houserobberies:exit",myhouseid,mansion,true)
										Citizen.Wait(5000)
									end
								end
							end
						end
					end
				end
			else
				if mansion then
					if (#(vector3(curHouseCoords["x"]-5.5793,curHouseCoords["y"]+5.100,curHouseCoords["z"]-32.42) - playerCoords) < 1.2 ) then
						DrawText3Ds( curHouseCoords["x"]-5.5793,curHouseCoords["y"]+5.100,curHouseCoords["z"]-32.82, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave' )
						if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
							ExitHouse()
							Citizen.Wait(5000)
						end
					end
				elseif rentedShop then
					if (#(vector3(curHouseCoords["x"]-1.4,curHouseCoords["y"]-4.47,curHouseCoords["z"]-32.2) - playerCoords) < 2.2 ) then
						DrawText3Ds( curHouseCoords["x"]-1.4,curHouseCoords["y"]-4.47,curHouseCoords["z"]-32.2, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave' )
						if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
							ExitHouse()
							Citizen.Wait(5000)
						end
					end

					if (#(vector3(curHouseCoords["x"]-1.4,curHouseCoords["y"]-1.47,curHouseCoords["z"]-32.2) - playerCoords) < 2.2 ) then

						if ( not rentedOffices[myhouseid]["trap"]) then

							DrawText3Ds( curHouseCoords["x"]-1.4,curHouseCoords["y"]-1.47,curHouseCoords["z"]-32.2, '~g~'..Controlkey["housingMain"][2]..'~s~ to Browse' )
							if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
								TriggerEvent("server-inventory-open", "1", PlayerStoreIdentifier)
								Citizen.Wait(5000)
							end
							DrawText3Ds( curHouseCoords["x"]-1.4,curHouseCoords["y"]-1.47,curHouseCoords["z"]-32.8, '~g~F~s~ to see reputation' )
							if IsControlJustReleased(1, 23) then
								TriggerEvent("DoShortHudText","Reputation: " .. rentedOffices[myhouseid]["reputation"])
								Citizen.Wait(5000)
							end
						else

							local mycid = exports["isPed"]:isPed("cid")

							if (rentedOffices[myhouseid]["owner"] ~= mycid) then
								DrawText3Ds( curHouseCoords["x"]-1.4,curHouseCoords["y"]-1.47,curHouseCoords["z"]-32.5, '~g~'..Controlkey["generalUse"][2]..'~s~ Take Over ($5000)' )
								if IsControlJustReleased(1, Controlkey["generalUse"][1]) then
									local finished = exports["np-taskbar"]:taskBar(300000,"Doing Takeover")
									if finished == 100 then
										TriggerServerEvent("traps:take",myhouseid,mycid)
									end
									Citizen.Wait(5000)
								end
							else
								DrawText3Ds( curHouseCoords["x"]-1.4,curHouseCoords["y"]-1.47,curHouseCoords["z"]-32.5, '~g~'..Controlkey["generalUse"][2]..'~s~ Take Cash' )
								if IsControlJustReleased(1, Controlkey["generalUse"][1]) then
									local finished = exports["np-taskbar"]:taskBar(10000,"Taking Cash")
									if finished == 100 then
										TriggerServerEvent("traps:cashout",myhouseid)
									end
									Citizen.Wait(5000)
								end
							end

							DrawText3Ds( curHouseCoords["x"]-1.4,curHouseCoords["y"]-1.47,curHouseCoords["z"]-32.8, '~g~F~s~ to see pincode/reputation' )
							if IsControlJustReleased(1, 23) then
								TriggerEvent("DoShortHudText","Pincode: " .. rentedOffices[myhouseid]["pincode"] .. " | Reputation: " .. rentedOffices[myhouseid]["reputation"])
								Citizen.Wait(5000)
							end

							DrawText3Ds( curHouseCoords["x"]-1.4,curHouseCoords["y"]-1.47,curHouseCoords["z"]-32.2, '~g~'..Controlkey["housingMain"][2]..'~s~ to Browse' )
							if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
								TriggerEvent("server-inventory-open", "1", PlayerStoreIdentifier)
								Citizen.Wait(5000)
							end

						end
					end

				elseif rentedOffice then
					if (#(vector3(curHouseCoords["x"]+9,curHouseCoords["y"]+0.52,curHouseCoords["z"]-33.99) - playerCoords) < 3.2 ) then
						DrawText3Ds( curHouseCoords["x"]+9,curHouseCoords["y"]+0.52,curHouseCoords["z"]-33.99, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave' )
						if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
							ExitHouse()
							Citizen.Wait(5000)
						end
					end
				elseif mansion2 then
						if (#(vector3(curHouseCoords["x"]+7.5793,curHouseCoords["y"]+6.400,curHouseCoords["z"]-19.42) - playerCoords) < 1.2 ) then
							DrawText3Ds( curHouseCoords["x"]+7.5793,curHouseCoords["y"]+6.400,curHouseCoords["z"]-19.42, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave' )
						if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
							ExitHouse()
							Citizen.Wait(5000)
						end
					end
				elseif office then
					if (#(vector3(curHouseCoords["x"]-3.5793,curHouseCoords["y"]+3.100,curHouseCoords["z"]-22.42) - playerCoords) < 1.2 ) then
						DrawText3Ds( curHouseCoords["x"]-3.5793,curHouseCoords["y"]+3.100,curHouseCoords["z"]-22.82, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave' )
						if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
							ExitHouse()
							Citizen.Wait(5000)
						end
					end
				elseif trailer
				then
					if (#(vector3((curHouseCoords["x"]-1.343),(curHouseCoords["y"]-2.292),(curHouseCoords["z"]-71.75)) - playerCoords) < 1.2 ) then
						DrawText3Ds( (curHouseCoords["x"]-1.343),(curHouseCoords["y"]-2.292),(curHouseCoords["z"]-71.75), '~g~'..Controlkey["housingMain"][2]..'~s~ to leave' )
						if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
							ExitHouse()
							Citizen.Wait(5000)
						end
					end
				else
					if apartment then
						if (#(vector3(curHouseCoords["x"] - 1.15,curHouseCoords["y"] - 4.2,curHouseCoords["z"]-26.90) - playerCoords) < 1.2 ) then
							DrawText3Ds(curHouseCoords["x"] - 1.15,curHouseCoords["y"] - 4.2,curHouseCoords["z"]-26.90, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave')
							if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
								ExitHouse()
								Citizen.Wait(5000)
							end
						end
					elseif shithouse then
						if (#(vector3(curHouseCoords["x"]+5.3,curHouseCoords["y"]-5.5,curHouseCoords["z"]-24.2) - playerCoords) < 1.2 ) then
							DrawText3Ds( curHouseCoords["x"]+5.3,curHouseCoords["y"]-5.5,curHouseCoords["z"]-24.2, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave' )
							if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
								ExitHouse()
								Citizen.Wait(5000)
							end
						end					
					elseif beachhouse then

						if (#(vector3(curHouseCoords["x"],curHouseCoords["y"] - 4,curHouseCoords["z"]-32.42) - playerCoords) < 1.2 ) then
							DrawText3Ds( (curHouseCoords["x"]),(curHouseCoords["y"] - 4),(curHouseCoords["z"]-32.42), '~g~'..Controlkey["housingMain"][2]..'~s~ to leave' )
							if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
								ExitHouse()
								Citizen.Wait(5000)
							end
						end
					elseif shopshit then
						if (#(vector3((curHouseCoords["x"]+3),(curHouseCoords["y"]-5),(curHouseCoords["z"]-34.0)) - playerCoords) < 5555.2 ) then
							DrawText3Ds( (curHouseCoords["x"]+3),(curHouseCoords["y"]-5),(curHouseCoords["z"]-34.0), '~g~'..Controlkey["housingMain"][2]..'~s~ to leave' )
							if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
								ExitHouse()
								Citizen.Wait(5000)
							end
						end
					else
						if (#(vector3(curHouseCoords["x"] + 4.3,curHouseCoords["y"] - 15.95,curHouseCoords["z"]-25.42) - playerCoords) < 1.2 ) then
							DrawText3Ds( (curHouseCoords["x"] + 4.3),(curHouseCoords["y"] - 15.95),(curHouseCoords["z"]-25.42), '~g~'..Controlkey["housingMain"][2]..'~s~ to leave' )
							if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
								ExitHouse()
								Citizen.Wait(5000)
							end
						end
					end
				end
			end
		end
	end
end)

local wpns = {
	[1] = "WEAPON_Knife",
	[2] = "WEAPON_HAMMER",
	[3] = "WEAPON_Bat",
	[4] = "WEAPON_Bottle",
	[5] = "WEAPON_Flashlight",
	[6] = "WEAPON_Poolcue"
}

function agroNPC(giveweapon)

    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom = 999.0
    local pedcount = 0
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if distance < 8.0 and ped ~= PlayerPedId() and not IsPedAPlayer(ped) and myhouseid ~= 0 then
        	SetPedToRagdoll(ped, math.random(55), math.random(55), 3, 0, 0, 0)
        	SetPedDropsWeaponsWhenDead(ped,false)
        	if giveweapon then
	        	GiveWeaponToPed(ped, GetHashKey(wpns[math.random(6)]), 150, 0, 1)
	        end
        	TaskCombatPed(ped, PlayerPedId(), 0, 16)
        	SetPedKeepTask(ped, true)
	    end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
end

function closestNPC()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom = 999.0
    local pedcount = 0
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if distance < 8.0 and ped ~= PlayerPedId() and not IsPedAPlayer(ped) then
        	pedcount = pedcount + 1
	        if (distance < distanceFrom) then
	            distanceFrom = distance
	            rped = ped
	        end
	    end

        success, ped = FindNextPed(handle)
    until not success

    EndFindPed(handle)
    return distanceFrom, pedcount
end


function FloatTilSafeR(buildingsent)
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
	elseif processing == 1 then
		FreezeEntityPosition(PlayerPedId(),false)
		SetEntityCoords(PlayerPedId(), curHouseCoords["x"] , curHouseCoords["y"], curHouseCoords["z"] )
		TriggerEvent("DoLongHudText","Failed to load property.",2)
	end

	Citizen.Wait(1000)
	SetEntityInvincible(PlayerPedId(),false)
end

function FreezeRobberyApartment()
    local playerped = PlayerPedId()
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(vector3(curHouseCoords["x"], curHouseCoords["y"], (curHouseCoords["z"] - 24.0)) - pos)
        if distance < 35.0 and ObjectFound ~= playerped then
        	if IsEntityAPed(ObjectFound) then

        	else
        		FreezeEntityPosition(ObjectFound,true)
        	end            
        end
        success, ObjectFound = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    if owner then
    	RemoveNPC(id)
    end
end


function LocalPed()
	return PlayerPedId()
end


RegisterNetEvent("UpdateCurrentHouseSpawns")
AddEventHandler("UpdateCurrentHouseSpawns", function(id,data)
	house_poi = json.decode(data)

	print(json.encode(house_poi["storage"]))

	local id = tonumber(id)
	-- if hasKey(id) then
	-- 	TriggerServerEvent("GarageData")
	-- end

end)

Citizen.CreateThread(function()

	while true do



			Citizen.Wait(6)
			local plyId = LocalPed()
			local plyCoords = GetEntityCoords(plyId)

			local garages = house_poi["garages"]
			local backdooroutside = house_poi["backdooroutside"]
			local backdoorinside = house_poi["backdoorinside"]
			local clothing = house_poi["clothing"]
			local storage = house_poi["storage"]


	

					



					-- if backdooroutside["x"] ~= 0.0 then
					-- 	if #(vector3(backdooroutside["x"],backdooroutside["y"],backdooroutside["z"]-0.3) - plyCoords) < 3.0 then
					-- 		DrawMarker(20,backdooroutside["x"],backdooroutside["y"],backdooroutside["z"]-0.3,0,0,0,0,0,0,0.701,1.0001,0.3001,markerColor.Red,markerColor.Green, markerColor.Blue,11,0,0,0,0)
					-- 	end
					-- 	if #(vector3(backdooroutside["x"],backdooroutside["y"],backdooroutside["z"]-0.3) - plyCoords) < 1.5 then
					-- 		DrawText3Ds( backdooroutside["x"],backdooroutside["y"],backdooroutside["z"] , '~g~E~s~ to enter house.')
							
					-- 		if IsControlJustReleased(2, 38) then
					-- 			-- TriggerServerEvent("house:enterhousebackdoor",house_poi["house_id"],house_poi["house_model"],false,backdoorinside["x"],backdoorinside["y"],backdoorinside["z"],backdoorinside["h"])
					-- 			Citizen.Wait(3000)
					-- 		end
					-- 	end	
					-- end

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
								TriggerEvent("server-inventory-open", "1", "house-"..house_poi["info"])

							end
						end
				end
			end
end)

function DeleteSpawnedHouse(id,owner)

	TriggerEvent("inhouse",false)
    local playerped = PlayerPedId()
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(vector3(curHouseCoords["x"], curHouseCoords["y"], (curHouseCoords["z"] - 24.0)) - pos)
        if distance < 35.0 and ObjectFound ~= playerped then
        	if IsEntityAPed(ObjectFound) then
        		if IsPedAPlayer(ObjectFound) then
        		else
        			DeleteObject(ObjectFound)
        		end
        	else
        		DeleteObject(ObjectFound)
        	end            
        end
        success, ObjectFound = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    if owner then
    	RemoveNPC(id)
    end
end

function RemoveNPC(id)
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom = 999.0
    local pedcount = 0
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(vector3(curHouseCoords["x"] , curHouseCoords["y"], curHouseCoords["z"]-24.0) - pos)

        if distance < 8.0 and ped ~= PlayerPedId() and not IsPedAPlayer(ped) then
        	if agrodone then
	        	SetEntityAsNoLongerNeeded(ped)
	        	SetEntityCoords(ped,curHouseCoords["x"] , curHouseCoords["y"], curHouseCoords["z"])
        	else
	        	SetEntityAsNoLongerNeeded(ped)
	        	DeleteEntity(ped)
        	end
	    end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
end

RegisterNetEvent("ruhroh")
AddEventHandler("ruhroh", function()
	if not DoesEntityExist(doge) then
		local plypos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 2.0, 0.0)
		local plyhead = GetEntityHeading(GetPlayerPed(PlayerId()))
		local model
		model = `A_C_Rottweiler`
		
		RequestModel(model)
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(100)
		end	

		doge = CreatePed(GetPedType(model), model, plypos.x, plypos.y, plypos.z, plyhead, 1, 0)
		Citizen.Wait(1500)
		TaskCombatPed(doge, PlayerPedId(), 0, 16)
	    SetPedKeepTask(doge, true)
	    SetEntityInvincible(doge,false)
	    Citizen.Wait(45000)
	    SetEntityAsNoLongerNeeded(doge)
	    doge = 0
	end
end)





RegisterNetEvent("weed:startcropInsideCheck")
AddEventHandler("weed:startcropInsideCheck", function(weedType)
	if entryType == 2 then
		TriggerEvent("weed:startcrop",weedType)
	end
end)


RegisterNetEvent("openFurniture")
AddEventHandler("openFurniture", function()
	print('lol')
	if entryType == 2 then
		if mansion or mansion2 or office then
			TriggerServerEvent("CheckFurniture",myhouseid,2)
		elseif trailer
		then
			TriggerServerEvent("CheckFurniture",myhouseid,5)
		else
			TriggerServerEvent("CheckFurniture",myhouseid,1)
		end
	end
end)


RegisterCommand('furniture', function(source, args)
TriggerEvent('openFurniture')
end)

function EnterCreatedApartment(id)
	myhouseid = id
	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 24.0}
	SetEntityCoords(PlayerPedId(), generator.x+4.5 , generator.y-14, generator.z+2.9)
	disturbance = 0 + math.random(20)
end

function CreateRobberyApartment(id,firstin,isFlashbang)

	for i=1,#robberycoords do
		if (#(vector3(robberycoords[i]["x"],robberycoords[i]["y"],robberycoords[i]["z"]) - GetEntityCoords(PlayerPedId())) < 1.5 ) then
			curHouseCoords = robberycoords[i]
		end
	end

	myhouseid = id
	entryType = 1
--	DoScreenFadeOut(1)
	local generator = {}
	local xDir = 0.0
	local yDir = 0.0

	if mansion then
		buildMansionRob(id,firstin)
		 generator = { x = curHouseCoords["x"]-5.57921200 , y = curHouseCoords["y"]+5.10079500, z = curHouseCoords["z"] - 32.9}
		 xDir = 40.0
	else
		if robberycoords[id]["apt"] == 4 then
			buildShopRob(id,firstin)
			generator = { x = curHouseCoords["x"]+4 , y = curHouseCoords["y"]-4, z = curHouseCoords["z"] - 34.0}
			yDir = -40.0 -- shops are very ... uh broken
		else
			buildHouseRob(id,firstin)
			yDir = 40.0
			generator = { x = curHouseCoords["x"]+3.6 , y = curHouseCoords["y"]-14, z = curHouseCoords["z"] - 21.1}
		end
		
	end

	if firstin and math.random(100) > 90 then
		TriggerEvent("ruhroh")
	end
	
--	DoScreenFadeOut(1000)
	if isFlashbang and generator then
		DoScreenFadeOut(1)
		local finished = exports["np-taskbar"]:taskBar(2000,"Throwing Flash")
		if finished == 100 then
			TriggerEvent("flashbang:breach",{generator.x, generator.y, generator.z},xDir,yDir,true)
		else
			TriggerEvent("flashbang:breach",{generator.x, generator.y, generator.z},xDir,yDir,false)
		end
		Wait(3000)
		DoScreenFadeOut(1000)
	end

	Citizen.Wait(1000)
end

function buildShop(house_id)

	local network = false;

    SetEntityCoords(PlayerPedId(),9000.0,0.0,110.0)
    
    Citizen.Wait(1000)

	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 124.0}

	SetEntityCoords(PlayerPedId(),generator.x+3, generator.y-4, generator.z+90.0)
	FreezeEntityPosition(PlayerPedId(),true)
	Citizen.Wait(1000)
    local building = CreateObject(`v_shop_gc_shell`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local wall = CreateObject(`v_shop_gcpartwall`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local stuff = CreateObject(`v_shop_backrmstuff`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass1 = CreateObject(`v_shop_glass01`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass2 = CreateObject(`v_shop_glass02`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass3 = CreateObject(`v_shop_glass03`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass4 = CreateObject(`v_shop_glass04`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass5 = CreateObject(`v_shop_glass05`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass6 = CreateObject(`v_shop_glass06`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass7 = CreateObject(`v_shop_glass07`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass8 = CreateObject(`v_shop_glass08`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass9 = CreateObject(`v_shop_glass10`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass10 = CreateObject(`v_shop_glass11`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass11 = CreateObject(`v_shop_glass12`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass12 = CreateObject(`v_shop_glass13`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass13 = CreateObject(`v_shop_glass14`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local guns = CreateObject(`v_shop_handguns`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local post = CreateObject(`v_shop_officepost`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local shad = CreateObject(`v_shop_officeshad`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local stuff2 = CreateObject(`v_shop_officestuff`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local stuff3 = CreateObject(`v_shop_officestuff2`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local shadowshop = CreateObject(`v_shop_shadowshop`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local shirts = CreateObject(`v_shop_shirts`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local posters = CreateObject(`v_shop_shopposters`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local shadowshop2 = CreateObject(`v_shop_shopshadow`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local skirt = CreateObject(`v_shop_shopskirt`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local skirting = CreateObject(`v_shop_skirting`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local vents1 = CreateObject(`v_shop_vents01`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local vents2 = CreateObject(`v_shop_vents02`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local edges = CreateObject(`v_shop_walledges`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local wallguns = CreateObject(`v_shop_wallguns`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local wallhooks = CreateObject(`v_shop_wallhooks`, generator.x, generator.y, generator.z, network and network or false, false, false)

     FreezeEntityPosition(building,true)
   	 Citizen.Wait(100)
     SetEntityCoords(PlayerPedId(),generator.x+3, generator.y-4, generator.z+90.0)
     FreezeEntityPosition(PlayerPedId(),false)
     SetEntityHeading(PlayerPedId(),0.0)


end



function buildShop1()
	SetEntityCoords(PlayerPedId(),1212.77,-472.43,66.21) -- Default
	Citizen.Wait(1000)
	rentedShop = true
	Citizen.Wait(2000)
	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 35.0}
  	SetEntityCoords(PlayerPedId(),generator.x,generator.y,generator.z)

	local building = CreateObject(`V_38_C_Barbers_Shell`,generator.x-0.31811000,generator.y+1.79183500,generator.z+1.56171400,false,false,false)

	CreateObject(`V_38_C_Barbers_Det`,generator.x+0.36036100,generator.y-0.35528500,generator.z+1.54137200,false,false,false)
	CreateObject(`V_38_C_CABINET02`,generator.x+0.37338400,generator.y-3.67517500,generator.z+1.48056600,false,false,false)

	CreateObject(`V_38_FAN`,generator.x+0.18863910,generator.y-1.78123200,generator.z+1.49853700,false,false,false)
	CreateObject(`V_38_SHELVES`,generator.x+0.38722500,generator.y-0.21649000,generator.z+2.34309200,false,false,false)
	CreateObject(`V_38_Pictures`,generator.x+0.36021210,generator.y+0.34026300,generator.z+1.82029300,false,false,false)
	CreateObject(`V_38_LIGHTS`,generator.x+0.95295510,generator.y-0.34358800,generator.z+4.50438800,false,false,false)
	
	local plant = CreateObject(`V_38_BARB_PLANT02`,generator.x+3.01122600,generator.y-4.98704700,generator.z+2.91572800,false,false,false)
	SetEntityRotation(plant,0.0,0.0,170.0,2,1)

	local chair1 = CreateObject(`Prop_chair_01b`,generator.x+2.92626000,generator.y+0.70815100,generator.z+1.54303900,false,false,false)
	local chair2 = CreateObject(`prop_chair_04a`,generator.x+2.92626000,generator.y+2.21829500,generator.z+1.54303900,false,false,false)
	local chair3 = CreateObject(`prop_chair_02`,generator.x+2.92626000,generator.y+1.44866100,generator.z+1.54303900,false,false,false)
	local chair4 = CreateObject(`prop_chair_02`,generator.x+2.92626000,generator.y+0.00554299,generator.z+1.54303900,false,false,false)

	SetEntityRotation(chair1,0.0,0.0,-90.0,2,1)
	SetEntityRotation(chair2,0.0,0.0,-80.0,2,1)
	SetEntityRotation(chair3,0.0,0.0,-85.0,2,1)
	SetEntityRotation(chair4,0.0,0.0,-95.0,2,1)

	CreateObject(`prop_tv_05`,generator.x+2.97058500,generator.y+4.72485000,generator.z+3.96126500,false,false,false)
	local tv = CreateObject(`prop_tv_05`,generator.x-2.20064500,generator.y-4.56200100,generator.z+3.96016800,false,false,false)
	SetEntityRotation(tv,0.0,0.0,190.0,2,1)
	
	local til = CreateObject(`prop_till_01`,generator.x-2.18592300,generator.y-1.87080100,generator.z+2.51398500,false,false,false)
	SetEntityRotation(til,0.0,0.0,180.0,2,1)
	CreateObject(`v_ret_gc_fan`,generator.x+2.94997000,generator.y+3.27074200,generator.z+1.49715400,false,false,false)
	
	CreateObject(`prop_cctv_cam_06a`,generator.x-2.35117100,generator.y+4.86646700,generator.z+4.18179800,false,false,false)
	CreateObject(`prop_game_clock_01`,generator.x-0.54486800,generator.y+5.01194300,generator.z+3.67846000,false,false,false)
	CreateObject(`prop_radio_01`,generator.x+3.07343200,generator.y+3.16888200,generator.z+3.37168900,false,false,false)
	
	CreateObject(`prop_speaker_05`,generator.x-2.40189600,generator.y+0.54597100,generator.z+3.89755000,false,false,false)
	CreateObject(`prop_speaker_05`,generator.x-2.40189600,generator.y+3.19824400,generator.z+3.16581200,false,false,false)
	CreateObject(`prop_rub_stool`,generator.x-2.20233000,generator.y+4.06275700,generator.z+1.52316500,false,false,false)
	CreateObject(`prop_watercooler`,generator.x-2.26554100,generator.y+2.82748200,generator.z+1.41562700,false,false,false)
	CreateObject(`V_38_C_SHADOWMAP`,generator.x-0.31811000,generator.y+1.79183500,generator.z+1.54171400,false,false,false)

	
	CreateObject(`V_38_BARB_PLANT003`,generator.x-2.30056400,generator.y+1.66849900,generator.z+2.38898200,false,false,false)
	CreateObject(`V_38_C_Pictures3`,generator.x+3.20509200,generator.y-0.40208200,generator.z+1.91242400,false,false,false)
	CreateObject(`V_38_C_Sink`,generator.x-0.62845000,generator.y+4.84067900,generator.z+1.41538000,false,false,false)

	FreezeEntityPosition(building,true)
	SetEntityCoords(PlayerPedId(),curHouseCoords["x"]-1.4,curHouseCoords["y"]-4.47,curHouseCoords["z"]-32.2)
	SetEntityHeading(PlayerPedId(),0.0)
end




function buildlowOffice(x,y,z) 
rentedOffice = true
SetEntityCoords(PlayerPedId(),1165.09,-3191.71,-39.0)
Citizen.Wait(2000)
	
local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 35.0}

local building = CreateObject(`bkr_Ware06_Walls_UPGRADE`,generator.x+0.11353500,generator.y+0.28204400,generator.z+2.58,false,false,false)
FreezeEntityPosition(building,true)
SetEntityCoords(building,generator.x+0.11353500,generator.y+0.28204400,generator.z+2.58)
local cab1 = CreateObject(`v_corp_filecabtall`,generator.x-7.34422700,generator.y-3.14134700,generator.z-0.01861100,false,false,false)
local cab2 = CreateObject(`v_corp_filecablow`,generator.x-9.07980300,generator.y+2.52155600,generator.z-0.01447000,false,false,false)
CreateObject(`bkr_Ware05_pipes`,generator.x+2.68628700,generator.y-0.92839200,generator.z+3.49654800,false,false,false)
CreateObject(`bkr_Ware05_LIGHT01`,generator.x-8.26626200,generator.y+1.56995300,generator.z+3.31107700,false,false,false)
CreateObject(`bkr_Ware06_skirt`,generator.x-3.21316700,generator.y+0.00500900,generator.z-0.61911000,false,false,false)
local cab3 = CreateObject(`v_corp_filecabtall`,generator.x-9.10312300,generator.y+1.00748900,generator.z-0.01861100,false,false,false)
local cab4 = CreateObject(`v_corp_filecabtall`,generator.x-2.82898200,generator.y-3.10538900,generator.z-0.01861100,false,false,false)
local chair4 = CreateObject(`prop_off_chair_04b`,generator.x+3.67178300,generator.y-2.35235600,generator.z+0.03800000,false,false,false)

local cab5 = CreateObject(`v_corp_filecabtall_01`,generator.x-9.10312300,generator.y+1.61945100,generator.z-0.01861100,false,false,false)
local cab6 = CreateObject(`v_corp_filecablow`,generator.x-8.34643300,generator.y-2.91642200,generator.z-0.01447000,false,false,false)
local cab7 = CreateObject(`prop_cabinet_02b`,generator.x-9.07114100,generator.y-0.29327900,generator.z+0.01447000,false,false,false)
local cab8 = CreateObject(`v_corp_filecablow`,generator.x+1.32407700,generator.y-3.14627900,generator.z-0.01447000,false,false,false)
local cab9 = CreateObject(`v_corp_filecablow`,generator.x+5.57632200,generator.y-3.10635800,generator.z-0.01447000,false,false,false)
local cab10 = CreateObject(`v_corp_filecabtall`,generator.x+7.11282000,generator.y-3.10396800,generator.z-0.01861100,false,false,false)

SetEntityHeading(cab1,GetEntityHeading(cab1)-180)
SetEntityHeading(cab2,GetEntityHeading(cab2)+90)
SetEntityHeading(cab3,GetEntityHeading(cab3)+90)
SetEntityHeading(cab4,GetEntityHeading(cab4)-180)
SetEntityHeading(cab5,GetEntityHeading(cab5)+90)
SetEntityHeading(cab6,GetEntityHeading(cab6)-180)
SetEntityHeading(cab7,GetEntityHeading(cab7)+90)
SetEntityHeading(cab8,GetEntityHeading(cab8)-180)
SetEntityHeading(cab9,GetEntityHeading(cab9)-180)
SetEntityHeading(cab10,GetEntityHeading(cab10)-180)

FreezeEntityPosition(cab1,true)
FreezeEntityPosition(cab2,true)
FreezeEntityPosition(cab3,true)
FreezeEntityPosition(cab4,true)
FreezeEntityPosition(cab5,true)
FreezeEntityPosition(cab6,true)
FreezeEntityPosition(cab7,true)
FreezeEntityPosition(cab8,true)
FreezeEntityPosition(cab9,true)
FreezeEntityPosition(cab10,true)

local cab19 = CreateObject(`v_corp_filecabtall`,generator.x+6.49944700,generator.y-3.10396800,generator.z-0.01861100,false,false,false)
CreateObject(`v_ret_gc_bin`,generator.x-4.11729600,generator.y-3.11868100,generator.z+0.01861100,false,false,false)
local cab11 = CreateObject(`v_corp_filecabtall`,generator.x+8.61164200,generator.y+2.83432800,generator.z-0.01861100,false,false,false)
local cab12 = CreateObject(`v_corp_filecabtall_01`,generator.x+1.63522500,generator.y+2.78941700,generator.z-0.01861100,false,false,false)
local cab13 = CreateObject(`v_corp_filecabtall`,generator.x+2.24028300,generator.y+2.78941600,generator.z-0.01861100,false,false,false)
local cab14 = CreateObject(`prop_cabinet_02b`,generator.x+2.84972000,generator.y+2.78941700,generator.z+0.01861100,false,false,false)
local cab15 = CreateObject(`v_corp_filecabtall`,generator.x+7.99428500,generator.y+2.83432800,generator.z-0.01861100,false,false,false)
local alarm = CreateObject(`Prop_Office_Alarm_01`,generator.x+2.18887500,generator.y-3.16437500,generator.z+2.58569600,false,false,false)
local clock = CreateObject(`prop_game_clock_02`,generator.x-9.38126500,generator.y+0.06388100,generator.z+3.02828600,false,false,false)
local cab16 = CreateObject(`prop_cabinet_02b`,generator.x+8.45207500,generator.y-3.06685500,generator.z+0.01861100,false,false,false)
local cab17 = CreateObject(`prop_cabinet_02b`,generator.x+7.78654900,generator.y-3.07523800,generator.z+0.01861100,false,false,false)
local cab18 = CreateObject(`prop_cabinet_02b`,generator.x-9.07114100,generator.y+0.35301400,generator.z+0.01861100,false,false,false)
CreateObject(`prop_fire_exting_2a`,generator.x+9.08120100,generator.y+1.51019000,generator.z+0.20927700,false,false,false)

SetEntityHeading(cab19,GetEntityHeading(cab19)-180)
SetEntityHeading(cab16,GetEntityHeading(cab16)-180)
SetEntityHeading(cab17,GetEntityHeading(cab17)-180)
SetEntityHeading(cab18,GetEntityHeading(cab18)+90)

SetEntityHeading(alarm,GetEntityHeading(alarm)-180)
SetEntityHeading(clock,GetEntityHeading(clock)+90)

FreezeEntityPosition(cab19,true)
FreezeEntityPosition(cab11,true)
FreezeEntityPosition(cab12,true)
FreezeEntityPosition(cab13,true)
FreezeEntityPosition(cab14,true)
FreezeEntityPosition(cab15,true)
FreezeEntityPosition(cab16,true)
FreezeEntityPosition(cab17,true)
FreezeEntityPosition(cab18,true)

local cab20 = CreateObject(`prop_cabinet_02b`,generator.x-3.43977000,generator.y-3.08526800,generator.z+0.01861100,false,false,false)
CreateObject(`bkr_Ware05_coatstand`,generator.x+8.80970800,generator.y+2.05195300,generator.z+0.01861100,false,false,false)
CreateObject(`bkr_Ware05_filing`,generator.x-0.34554900,generator.y-3.18451300,generator.z+0.00361100,false,false,false)
CreateObject(`prop_fire_exting_3a`,generator.x+9.08120100,generator.y+1.16520200,generator.z+0.20927700,false,false,false)
CreateObject(`bkr_Ware06_normaldecal`,generator.x-0.63655110,generator.y-0.06951900,generator.z-0.78872000,false,false,false)
CreateObject(`prop_rub_boxpile_09`,generator.x+3.89339400,generator.y+2.98365500,generator.z-0.00403600,false,false,false)

SetEntityHeading(cab20,GetEntityHeading(cab20)+180)


CreateObject(`prop_rub_boxpile_09`,generator.x+8.41980600,generator.y-3.15773600,generator.z+1.82872900,false,false,false)
CreateObject(`bkr_Ware05_noticeboard`,generator.x+6.07660000,generator.y+3.12634400,generator.z+1.13559000,false,false,false)
local chair1 = CreateObject(`v_ret_gc_chair02`,generator.x+8.61064500,generator.y-1.66148500,generator.z+0.01861100,false,false,false)
CreateObject(`v_ind_cfemlight`,generator.x+4.21705200,generator.y+3.05128300,generator.z+2.39011000,false,false,false)
CreateObject(`v_serv_switch_3`,generator.x+9.11426400,generator.y+1.00535700,generator.z+1.41933600,false,false,false)
CreateObject(`v_serv_switch_3`,generator.x+9.11426400,generator.y+1.18736500,generator.z+1.41933600,false,false,false)
local bin = CreateObject(`v_serv_waste_bin1`,generator.x+8.78876900,generator.y-1.16578300,generator.z+0.01861100,false,false,false)
CreateObject(`v_ret_gc_plant1`,generator.x+0.57552000,generator.y-3.06355700,generator.z+2.21231100,false,false,false)
local coathook = CreateObject(`prop_coathook_01`,generator.x+9.04301700,generator.y-1.51808700,generator.z+1.55393400,false,false,false)

SetEntityHeading(chair1,GetEntityHeading(chair1)-90)
SetEntityHeading(coathook,GetEntityHeading(coathook)-90)

FreezeEntityPosition(chair1,true)
FreezeEntityPosition(bin,true)
FreezeEntityPosition(coathook,true)



CreateObject(`bkr_Ware05_Shelves`,generator.x-0.31607800,generator.y-3.24394500,generator.z+1.18469900,false,false,false)
CreateObject(`bkr_Ware05_filing2`,generator.x-9.15907500,generator.y+0.14262400,generator.z+1.85613700,false,false,false)
CreateObject(`v_serv_bktmop_h`,generator.x+1.06425300,generator.y+2.79939400,generator.z-0.00403600,false,false,false)
CreateObject(`v_serv_2socket`,generator.x+9.11426400,generator.y+1.10089100,generator.z+0.22389600,false,false,false)
CreateObject(`bkr_Ware05_windows`,generator.x+0.11353500,generator.y+0.28204400,generator.z+2.57704200,false,false,false)

local desk = CreateObject(`bkr_ware06_desksupgrade`,generator.x-1.40019800,generator.y-0.78046800,generator.z-2.67858200,false,false,false)
local copy3 = CreateObject(`prop_copier_01`,generator.x-0.96465600,generator.y+1.37476100,generator.z+0.00000000,false,false,false)

SetEntityHeading(copy3,GetEntityHeading(copy3)-180)
FreezeEntityPosition(copy3,true)

CreateObject(`prop_mouse_02`,generator.x+4.31184200,generator.y-2.54925000,generator.z+0.71098800,false,false,false)
CreateObject(`prop_mouse_02`,generator.x-4.69416600,generator.y-2.74531100,generator.z+0.71098800,false,false,false)
CreateObject(`bkr_Ware05_PCUpgrade1`,generator.x-4.95896700,generator.y-2.55382900,generator.z+0.71098800,false,false,false)
local mon = CreateObject(`prop_trailer_monitor_01`,generator.x+4.42691200,generator.y-2.97983800,generator.z+0.71098800,false,false,false)
local cables = CreateObject(`bkr_ware06_cablesupgrade`,generator.x-1.40019800,generator.y-0.78046800,generator.z-2.60858200,false,false,false)
CreateObject(`bkr_Ware05_laptop1`,generator.x-5.07897800,generator.y-0.30462100,generator.z+0.71098800,false,false,false)
CreateObject(`bkr_Ware05_laptop3`,generator.x-0.64745500,generator.y-0.08766600,generator.z+0.71098800,false,false,false)
CreateObject(`bkr_Ware05_PClatopBasic1`,generator.x-1.62515600,generator.y+0.02346100,generator.z+0.71098800,false,false,false)

SetEntityHeading(desk,GetEntityHeading(desk)-90)
SetEntityHeading(cables,GetEntityHeading(cables)-90)
SetEntityHeading(mon,GetEntityHeading(mon)-180)

CreateObject(`prop_mouse_01`,generator.x+3.50753200,generator.y-2.49509400,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_print`,generator.x-1.12285900,generator.y-0.78029400,generator.z+0.71098800,false,false,false)
CreateObject(`p_notepad_01_s`,generator.x-6.52386400,generator.y-2.67459700,generator.z+0.71098800,false,false,false)
CreateObject(`Prop_CS_Spray_Can`,generator.x-5.44937700,generator.y-0.52977300,generator.z+0.71098800,false,false,false)

CreateObject(`v_ind_cm_lubcan`,generator.x-6.72289000,generator.y+0.32566400,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_pen1`,generator.x-4.54459100,generator.y-0.84293700,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_pen1`,generator.x-0.44212300,generator.y-0.41842700,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_pen2`,generator.x-5.12303500,generator.y-2.14434400,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_pen2`,generator.x-1.58417400,generator.y+0.48285100,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_scissors`,generator.x-4.57919200,generator.y-2.74882700,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_scissors`,generator.x+0.04293700,generator.y-1.12593200,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_scissors`,generator.x+3.54400300,generator.y-2.78199700,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_staple`,generator.x-0.61162100,generator.y-1.29870600,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_staple`,generator.x-5.21551700,generator.y+0.21101800,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_staple`,generator.x-4.75682700,generator.y-0.79320600,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_staple`,generator.x+4.54903200,generator.y-2.44175200,generator.z+0.71098800,false,false,false)
CreateObject(`v_serv_abox_02`,generator.x-0.22096300,generator.y+0.69162000,generator.z+0.71098800,false,false,false)

CreateObject(`prop_paper_box_03`,generator.x-9.11115700,generator.y+2.89515000,generator.z+0.86943800,false,false,false)
CreateObject(`prop_rub_boxpile_09`,generator.x-9.05709700,generator.y+2.26734500,generator.z+0.88989100,false,false,false)
CreateObject(`bkr_Ware05_DoorBasic`,generator.x+9.16955900,generator.y-0.03041000,generator.z-0.02590900,false,false,false)
CreateObject(`prop_cd_folder_pile1`,generator.x+3.31967600,generator.y-3.26778000,generator.z+0.67535400,false,false,false)
local books = CreateObject(`prop_cd_folder_pile1`,generator.x-5.38115000,generator.y-2.25130400,generator.z+0.67535400,false,false,false)
SetEntityHeading(books,GetEntityHeading(books)-90)

CreateObject(`prop_cd_folder_pile1`,generator.x-1.17782200,generator.y+0.82561810,generator.z+0.73535400,false,false,false)
local books2 = CreateObject(`prop_cd_folder_pile1`,generator.x+1.53132600,generator.y-3.26208100,generator.z+1.52613500,false,false,false)
SetEntityHeading(books2,GetEntityHeading(books2)-180)

local books3 = CreateObject(`prop_cd_folder_pile1`,generator.x+4.34637100,generator.y-3.29452700,generator.z+1.60788400,false,false,false)
local books4 = CreateObject(`prop_cd_folder_pile1`,generator.x+6.14707900,generator.y-3.29452700,generator.z+1.83899700,false,false,false)

SetEntityHeading(books3,GetEntityHeading(books3)-180)
SetEntityHeading(books4,GetEntityHeading(books4)-180)

local books5 = CreateObject(`prop_cd_folder_pile1`,generator.x+4.69448700,generator.y-3.22720900,generator.z+2.30722800,false,false,false)
local books6 = CreateObject(`prop_cd_folder_pile1`,generator.x-0.37581000,generator.y-3.26833800,generator.z+2.36943700,false,false,false)

SetEntityHeading(books5,GetEntityHeading(books5)-180)
SetEntityHeading(books6,GetEntityHeading(books6)-180)

local books7 = CreateObject(`prop_cd_folder_pile1`,generator.x-2.56968200,generator.y-3.22342500,generator.z+1.88119000,false,false,false)
local books8 = CreateObject(`prop_cd_folder_pile1`,generator.x-6.37535100,generator.y-3.29452700,generator.z+1.60366900,false,false,false)

SetEntityHeading(books7,GetEntityHeading(books7)-180)
SetEntityHeading(books8,GetEntityHeading(books8)-180)

local books9 = CreateObject(`prop_cd_folder_pile1`,generator.x-9.23715800,generator.y-1.70292000,generator.z+2.18091700,false,false,false)
local books10 = CreateObject(`prop_cd_folder_pile1`,generator.x-9.24730200,generator.y-2.62697900,generator.z+2.63990000,false,false,false)
local books11 = CreateObject(`prop_cd_folder_pile2`,generator.x-5.76275400,generator.y-3.01413600,generator.z+0.71098800,false,false,false)

SetEntityHeading(books9,GetEntityHeading(books9)+90)
SetEntityHeading(books10,GetEntityHeading(books10)+90)

CreateObject(`prop_cd_folder_pile2`,generator.x-5.81559200,generator.y-0.85069900,generator.z+0.71098800,false,false,false)
CreateObject(`prop_cd_folder_pile2`,generator.x+2.88389500,generator.y-3.17198600,generator.z+1.59716600,false,false,false)
CreateObject(`prop_cd_folder_pile2`,generator.x+5.15800200,generator.y-3.17198600,generator.z+1.83845000,false,false,false)

local books12 = CreateObject(`prop_cd_folder_pile2`,generator.x-1.11321000,generator.y-3.19456200,generator.z+2.38567100,false,false,false)
local books13 = CreateObject(`prop_cd_folder_pile2`,generator.x+3.52017800,generator.y-3.26069100,generator.z+2.30554200,false,false,false)
local books14 = CreateObject(`prop_cd_folder_pile2`,generator.x-3.59368400,generator.y-3.00866900,generator.z+1.87302300,false,false,false)
local books15 = CreateObject(`prop_cd_folder_pile2`,generator.x+5.10332000,generator.y-3.17892000,generator.z+1.46112100,false,false,false)

SetEntityHeading(books12,GetEntityHeading(books12)+90)
SetEntityHeading(books13,GetEntityHeading(books13)+180)
SetEntityHeading(books14,GetEntityHeading(books14)+180)
SetEntityHeading(books15,GetEntityHeading(books15)+90)

CreateObject(`prop_cd_folder_pile2`,generator.x+6.00508000,generator.y-3.17892000,generator.z+1.45926000,false,false,false)
CreateObject(`prop_cd_folder_pile2`,generator.x-5.80488000,generator.y-3.17198600,generator.z+1.61264700,false,false,false)
local books16 = CreateObject(`prop_cd_folder_pile2`,generator.x-5.75346100,generator.y-3.30610400,generator.z+1.78391600,false,false,false)
local books17 = CreateObject(`prop_cd_folder_pile2`,generator.x-5.75685200,generator.y-3.17198600,generator.z+1.97946600,false,false,false)
CreateObject(`prop_cd_folder_pile2`,generator.x-9.19273500,generator.y-1.00892600,generator.z+2.11243900,false,false,false)

SetEntityHeading(books16,GetEntityHeading(books16)+180)
SetEntityHeading(books17,GetEntityHeading(books17)+180)

CreateObject(`prop_cd_folder_pile2`,generator.x-9.19273500,generator.y-2.84502500,generator.z+2.16243900,false,false,false)
CreateObject(`prop_cd_folder_pile3`,generator.x+5.64516100,generator.y-3.27598700,generator.z+2.30531200,false,false,false)
CreateObject(`prop_cd_folder_pile3`,generator.x+3.50351100,generator.y-3.30957800,generator.z+1.60049100,false,false,false)
CreateObject(`prop_cd_folder_pile3`,generator.x+0.01976800,generator.y-3.27762900,generator.z+2.37890100,false,false,false)

local books18 = CreateObject(`prop_cd_folder_pile3`,generator.x+4.01981200,generator.y-3.27598700,generator.z+2.32022600,false,false,false)
local books19 = CreateObject(`prop_cd_folder_pile3`,generator.x-6.00125700,generator.y-3.27598700,generator.z+1.60998400,false,false,false)

SetEntityHeading(books18,GetEntityHeading(books18)+180)
SetEntityHeading(books19,GetEntityHeading(books19)+180)


local books20 = CreateObject(`prop_cd_folder_pile3`,generator.x-9.22329500,generator.y-1.87029700,generator.z+1.71785300,false,false,false)
local books21 = CreateObject(`prop_cd_folder_pile3`,generator.x-9.23415300,generator.y-1.24655500,generator.z+2.62080800,false,false,false)

SetEntityHeading(books20,GetEntityHeading(books20)+90)
SetEntityHeading(books21,GetEntityHeading(books21)+90)

CreateObject(`prop_cd_folder_pile4`,generator.x+4.78897600,generator.y-3.26039500,generator.z+1.82519400,false,false,false)
CreateObject(`prop_cd_folder_pile4`,generator.x+3.03184300,generator.y-3.26039500,generator.z+2.32074300,false,false,false)

CreateObject(`prop_cd_folder_pile4`,generator.x-5.43449500,generator.y-3.26039500,generator.z+1.58986600,false,false,false)
local books22 = CreateObject(`prop_cd_folder_pile4`,generator.x-9.20302600,generator.y-1.92963200,generator.z+2.18687200,false,false,false)
local books23 = CreateObject(`prop_cd_folder_pile4`,generator.x-9.20302600,generator.y-2.40129800,generator.z+2.18687200,false,false,false)

SetEntityHeading(books22,GetEntityHeading(books22)-90)
SetEntityHeading(books23,GetEntityHeading(books23)-90)


CreateObject(`Prop_CD_Paper_Pile1`,generator.x-3.55938400,generator.y+3.10863800,generator.z+1.23964800,false,false,false)
CreateObject(`Prop_CD_Paper_Pile2`,generator.x-3.10214300,generator.y+3.14612800,generator.z+1.18971300,false,false,false)
local copy = CreateObject(`prop_copier_01`,generator.x-8.94256500,generator.y-1.98000800,generator.z+0.00000000,false,false,false)
local copy2 = CreateObject(`prop_copier_01`,generator.x+5.80260800,generator.y+2.62030700,generator.z+0.00000000,false,false,false)
SetEntityHeading(copy,GetEntityHeading(copy)+90)
FreezeEntityPosition(copy,true)
FreezeEntityPosition(copy2,true)

CreateObject(`Prop_CS_CardBox_01`,generator.x+2.83393900,generator.y+2.88158000,generator.z+1.83250300,false,false,false)
CreateObject(`Prop_CS_CardBox_01`,generator.x+5.25757300,generator.y-3.24880900,generator.z+2.30871000,false,false,false)
CreateObject(`Prop_CS_CardBox_01`,generator.x+0.93497600,generator.y-3.19773400,generator.z+1.52177500,false,false,false)

CreateObject(`Prop_CS_CardBox_01`,generator.x-6.45386900,generator.y-3.24880900,generator.z+2.30394500,false,false,false)
CreateObject(`Prop_CS_CardBox_01`,generator.x-9.20910200,generator.y-1.95228400,generator.z+2.65754000,false,false,false)
CreateObject(`Prop_CS_CardBox_01`,generator.x-9.20910200,generator.y-2.00922900,generator.z+2.96588800,false,false,false)

CreateObject(`prop_fax_01`,generator.x-7.95239400,generator.y-2.89988400,generator.z+0.87260010,false,false,false)
CreateObject(`prop_inout_tray_01`,generator.x-4.84976500,generator.y-1.02491000,generator.z+0.78987400,false,false,false)
CreateObject(`prop_inout_tray_01`,generator.x-1.54063700,generator.y-1.28218400,generator.z+0.78987400,false,false,false)
CreateObject(`prop_kettle_01`,generator.x+5.55725000,generator.y-3.16822300,generator.z+0.89741000,false,false,false)

CreateObject(`Prop_M_Pack_INT_01`,generator.x+8.73317100,generator.y+2.10665800,generator.z+1.45640100,false,false,false)
local micro = CreateObject(`prop_micro_02`,generator.x+5.93970000,generator.y-3.11768500,generator.z+0.89481800,false,false,false)
SetEntityHeading(micro,GetEntityHeading(micro)+180)
FreezeEntityPosition(micro,true)

CreateObject(`prop_printer_01`,generator.x-5.31346100,generator.y-0.92755400,generator.z+0.71098800,false,false,false)
CreateObject(`prop_printer_01`,generator.x+2.67466800,generator.y-3.14176900,generator.z+0.71098800,false,false,false)
CreateObject(`prop_shredder_01`,generator.x+5.32904400,generator.y+2.87084500,generator.z+0.00000000,false,false,false)
CreateObject(`prop_watercooler`,generator.x+2.20342600,generator.y-3.00504000,generator.z+0.00000000,false,false,false)
CreateObject(`v_corp_bombhum`,generator.x+7.30933900,generator.y+2.60374100,generator.z-0.01455100,false,false,false)
CreateObject(`v_ind_cs_box01`,generator.x-1.73967000,generator.y-3.19059700,generator.z+2.35723900,false,false,false)
CreateObject(`v_ind_cs_paper`,generator.x+6.96007400,generator.y-3.23432700,generator.z+1.86399900,false,false,false)
CreateObject(`v_ind_cs_paper`,generator.x+1.70994300,generator.y-3.21537900,generator.z+1.52590600,false,false,false)
CreateObject(`v_ind_cs_paper`,generator.x+3.70368500,generator.y-3.30957800,generator.z+1.95154500,false,false,false)
CreateObject(`v_ind_cs_paper`,generator.x+0.26684800,generator.y-3.16566200,generator.z+2.71550100,false,false,false)
CreateObject(`v_ind_cs_paper`,generator.x+3.03325700,generator.y-3.30957800,generator.z+2.45361600,false,false,false)
CreateObject(`v_ind_cs_paper`,generator.x+2.73605800,generator.y-3.26588400,generator.z+2.33015500,false,false,false)
CreateObject(`v_ind_cs_paper`,generator.x+5.54501700,generator.y-3.26828900,generator.z+1.48229700,false,false,false)
CreateObject(`v_ind_cs_paper`,generator.x-5.24846000,generator.y-3.16566200,generator.z+2.33299200,false,false,false)
CreateObject(`v_ind_cs_paper`,generator.x-9.25221000,generator.y-2.06577300,generator.z+1.73543800,false,false,false)
CreateObject(`v_ind_cs_paper`,generator.x-9.21950500,generator.y-2.84280700,generator.z+2.66074000,false,false,false)
CreateObject(`v_ind_cs_paper`,generator.x-9.21950500,generator.y+0.38650100,generator.z+2.50355800,false,false,false)
CreateObject(`v_ind_cs_paper`,generator.x-9.18035900,generator.y+0.05155400,generator.z+2.50448200,false,false,false)
CreateObject(`v_ind_ss_box03`,generator.x-2.07327900,generator.y-3.24858400,generator.z+2.47272200,false,false,false)
CreateObject(`v_res_cdstorage`,generator.x+4.51417900,generator.y-3.20936000,generator.z+1.84652900,false,false,false)
CreateObject(`v_res_cdstorage`,generator.x-5.14409100,generator.y-3.20936000,generator.z+1.61120100,false,false,false)
CreateObject(`v_res_cdstorage`,generator.x-9.18560100,generator.y-2.05177100,generator.z+1.89320300,false,false,false)
CreateObject(`v_res_desktidy`,generator.x+3.92537200,generator.y-3.18134100,generator.z+0.79097300,false,false,false)
CreateObject(`v_res_fa_fan`,generator.x+8.39164700,generator.y+2.86113700,generator.z+1.88964600,false,false,false)
CreateObject(`v_res_paperfolders`,generator.x+4.70266200,generator.y-3.20471300,generator.z+1.43026100,false,false,false)
CreateObject(`v_res_paperfolders`,generator.x+0.90445600,generator.y-3.20471300,generator.z+1.87600500,false,false,false)
CreateObject(`v_res_paperfolders`,generator.x-5.93890900,generator.y-3.25466300,generator.z+2.30331900,false,false,false)
CreateObject(`v_res_paperfolders`,generator.x-9.18207900,generator.y-1.48388300,generator.z+2.62931000,false,false,false)
CreateObject(`v_res_paperfolders`,generator.x-9.18207900,generator.y-2.33308500,generator.z+2.21691100,false,false,false)
CreateObject(`v_ret_gc_bin`,generator.x-0.67574300,generator.y+1.42213700,generator.z+0.11098800,false,false,false)
CreateObject(`v_ret_gc_phone`,generator.x-1.18315800,generator.y-0.14374200,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_phone`,generator.x+3.11493000,generator.y-2.66918900,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_gc_phone`,generator.x-6.63282500,generator.y-0.05553100,generator.z+0.71098800,false,false,false)
CreateObject(`v_ret_ta_spray`,generator.x-1.35667600,generator.y-3.22178800,generator.z+2.50833500,false,false,false)
CreateObject(`Prop_Coffee_Cup_trailer`,generator.x+0.18648300,generator.y-1.34517500,generator.z+0.72098800,false,false,false)
CreateObject(`prop_fib_ashtray_01`,generator.x-4.72128500,generator.y-2.95514900,generator.z+0.72098800,false,false,false)
CreateObject(`prop_mug_01`,generator.x+5.58503700,generator.y-2.98578900,generator.z+0.72098800,false,false,false)
CreateObject(`prop_mug_01`,generator.x+5.39395200,generator.y-2.92095000,generator.z+0.72098800,false,false,false)
CreateObject(`prop_mug_01`,generator.x-1.82899100,generator.y-1.46671900,generator.z+0.72098800,false,false,false)
CreateObject(`v_res_tissues`,generator.x-5.82758600,generator.y-1.31450600,generator.z+0.72098800,false,false,false)
CreateObject(`prop_cd_folder_pile3`,generator.x-0.48034990,generator.y-0.94285030,generator.z+0.72098800,false,false,false)

local chair1 = CreateObject(`prop_off_chair_04b`,generator.x+1.96880600,generator.y+0.29190850,generator.z+0.03800000,false,false,false)
local chair2 = CreateObject(`prop_off_chair_04b`,generator.x+4.15014100,generator.y+0.72278440,generator.z+0.03800000,false,false,false)
local chair3 = CreateObject(`prop_off_chair_04b`,generator.x+4.19992800,generator.y-0.28254890,generator.z+0.03800000,false,false,false)

SetEntityHeading(chair1,GetEntityHeading(chair1)+90)
SetEntityHeading(chair2,GetEntityHeading(chair2)-90)
SetEntityHeading(chair3,GetEntityHeading(chair3)-90)

FreezeEntityPosition(chair1,true)
FreezeEntityPosition(chair2,true)
FreezeEntityPosition(chair3,true)
FreezeEntityPosition(chair4,true)

local door = CreateObject(`bkr_Ware05_DoorBasic`,generator.x+4.26955900,generator.y+3.29041000,generator.z-0.02590900,false,false,false)
SetEntityHeading(door,GetEntityHeading(door)+90)
FreezeEntityPosition(door,true)

SetEntityCoords(PlayerPedId(),generator.x+8.5,generator.y,generator.z)
SetEntityHeading(PlayerPedId(),267.0)
SetGameplayCamRelativeHeading(0.0)
end


function buildNorth()

	SetEntityCoords(PlayerPedId(),260.32970000 ,-997.42880000, -100.00000000)
	Wait(1200)
	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 28.0}
	SetEntityCoords(PlayerPedId(), generator.x+5.3, generator.y-5.5,generator.z+4.2)

	local building = CreateObject(`furnitured_lowapart`,generator.x+1.05453500,generator.y-3.61683300,generator.z+0.64563890,false,false,false)
	FreezeEntityPosition(building,true)
	SetEntityHeading(PlayerPedId(),0.0)
	CreateObject(`V_16_mesh_delta`,generator.x-0.17773440,generator.y-1.16581800,generator.z+2.79010700,false,false,false)
	CreateObject(`V_16_Molding01`,generator.x+0.95904540,generator.y-0.54156590,generator.z+2.64563900,false,false,false)

	CreateObject(`V_16_LivStuff003`,generator.x+0.78976440,generator.y+0.28811740,generator.z+2.78658000,false,false,false)
	CreateObject(`v_16_studapart00`,generator.x+2.08828700,generator.y+2.00200600,generator.z+2.15232800,false,false,false)
	CreateObject(`V_16_low_ktn_mesh_units`,generator.x+3.44339000,generator.y+1.19931100,generator.z+2.57747200,false,false,false)
	CreateObject(`V_16_low_lng_over_decal`,generator.x+0.96144110,generator.y-0.58607290,generator.z+2.51227700,false,false,false)

	CreateObject(`V_16_shadsy`,generator.x+1.05453500,generator.y-3.61683300,generator.z+1.20563890,false,false,false)
	CreateObject(`V_16_barglow`,generator.x-2.25659200,generator.y+2.92449500,generator.z+1.28594400,false,false,false)
	CreateObject(`V_16_barglow001`,generator.x-2.06150800,generator.y+3.22672500,generator.z+1.10201100,false,false,false)
	CreateObject(`V_16_barglownight`,generator.x-2.25659200,generator.y+2.91845800,generator.z+1.28594400,false,false,false)
	CreateObject(`V_16_treeglow001`,generator.x+0.98612980,generator.y+3.02291800,generator.z+1.13237200,false,false,false)

	CreateObject(`V_16_low_lng_over_shadow`,generator.x+0.85839840,generator.y-1.75070600,generator.z+0.68176790,false,false,false)
	CreateObject(`V_16_low_lng_over_normal`,generator.x+0.27519230,generator.y-0.38116550,generator.z+1.62705500,false,false,false)
	CreateObject(`V_16_vint1_multilow02`,generator.x-0.84963990,generator.y-1.39983300,generator.z+2.69145900,false,false,false)
	CreateObject(`V_16_low_bath_over_decal`,generator.x-4.81040900,generator.y-3.34513900,generator.z+2.65959100,false,false,false)

	CreateObject(`V_16_BathEmOn`,generator.x-4.73307800,generator.y-2.96252200,generator.z+4.62362500,false,false,false)
	CreateObject(`V_16_BathStuff`,generator.x-4.93583700,generator.y-3.25723600,generator.z+2.68417500,false,false,false)
	CreateObject(`V_16_BathMirror`,generator.x-4.72398400,generator.y-2.34521200,generator.z+2.73924300,false,false,false)
	CreateObject(`V_16_Lo_Shower`,generator.x-5.95976300,generator.y-3.32741100,generator.z+2.69451500,false,false,false)
	CreateObject(`V_16_low_bath_mesh_window`,generator.x-6.55250500,generator.y-3.28534800,generator.z+3.90488600,false,false,false)
	CreateObject(`V_16_v_1_studapart02`,generator.x+0.60858150,generator.y-5.93369900,generator.z+2.65880200,false,false,false)
	CreateObject(`V_16_StudFrame`,generator.x+1.02046200,generator.y-6.09521700,generator.z+2.65524200,false,false,false)
	CreateObject(`V_16_FrankCurtain1`,generator.x+1.47291600,generator.y-7.61168500,generator.z+2.80524200,false,false,false)
	CreateObject(`V_16_shadowobject69`,generator.x+0.74165340,generator.y-5.93369900,generator.z+2.39880200,false,false,false)
	CreateObject(`V_16_StrsDet01`,generator.x+5.14518700,generator.y-7.39305100,generator.z+0.64861680,false,false,false)
	SetEntityHeading(PlayerPedId(),267.0)
	SetGameplayCamRelativeHeading(0.0)
end


function buildFranklin()
	SetEntityCoords(PlayerPedId(),3.19946300 ,529.78070000, 169.62620000)
	Wait(1200)

	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 28.0}
	SetEntityCoords(PlayerPedId(), generator.x+7.5793, generator.y+6.400,generator.z+9.5)



	local building = CreateObject(`V_24_Shell`,generator.x-2.75363900,generator.y-1.67145000,generator.z+1.80765100,false,false,false)
	FreezeEntityPosition(building,true)

	CreateObject(`V_24_BedroomShell`,generator.x-0.57804100,generator.y-1.87575600,generator.z+1.90440100,false,false,false)
	CreateObject(`V_24_bdr_over_normal`,generator.x-2.62198500,generator.y-1.82425300,generator.z+1.89525400,false,false,false)

	CreateObject(`V_24_bdr_over_decal`,generator.x-2.51400300,generator.y-2.06588400,generator.z+0.00310300,false,false,false)
	CreateObject(`V_24_bdr_over_emmisve`,generator.x-0.09511701,generator.y+2.87445100,generator.z+1.61904500,false,false,false)
	CreateObject(`V_24_bdr_mesh_delta`,generator.x-2.83036300,generator.y-1.73855200,generator.z+1.90582900,false,false,false)

	CreateObject(`V_24_lgb_mesh_bottomDelta`,generator.x-3.43638900,generator.y-2.45154500,generator.z+5.90377100,false,false,false)

	CreateObject(`V_24_lng_over_normal`,generator.x-4.94545100,generator.y-1.91387200,generator.z+5.91765100,false,false,false)
	CreateObject(`V_24_lng_over_decal`,generator.x-5.18632600,generator.y-1.77267300,generator.z+5.9253700,false,false,false)



	CreateObject(`V_24_lnb_mesh_windows`,generator.x-2.16944100,generator.y-6.71544600,generator.z+5.93267300,false,false,false)
	CreateObject(`V_24_lgb_mesh_fire`,generator.x+0.95475600,generator.y+0.23381400,generator.z+6.47443400,false,false,false)
	CreateObject(`V_24_lgb_mesh_topDelta`,generator.x-5.38059600,generator.y+2.99834300,generator.z+5.89102100,false,false,false)
	CreateObject(`V_24_lnb_mesh_fireGlass`,generator.x+0.95787500,generator.y+0.14574900,generator.z+6.42364500,false,false,false)
	CreateObject(`V_24_lgb_over_dirt`,generator.x+7.92383600,generator.y+0.48949300,generator.z+5.92185400,false,false,false)
	CreateObject(`V_24_lnb_mesh_lightCeiling`,generator.x-9.45505200,generator.y+2.30337000,generator.z+8.10869600,false,false,false)


	CreateObject(`V_24_knt_over_normal`,generator.x-13.46313000,generator.y-6.33643100,generator.z+9.47339900,false,false,false)
	CreateObject(`V_24_knt_over_decal`,generator.x-14.40418000,generator.y-3.76733500,generator.z+4.45807900,false,false,false)
	CreateObject(`V_24_knt_mesh_windowsA`,generator.x-19.68472000,generator.y-6.61449600,generator.z+5.93174400,false,false,false)
	CreateObject(`V_24_knt_mesh_delta`,generator.x-14.82886000,generator.y-6.13017100,generator.z+5.98389400,false,false,false)
	CreateObject(`V_24_ktn_over_dirt`,generator.x+7.92383500,generator.y+0.48949300,generator.z+5.95443400,false,false,false)

	CreateObject(`V_24_5`,generator.x-10.95861000,generator.y-8.07690200,generator.z+5.93174400,false,false,false)




	CreateObject(`V_24_hal_mesh_delta`,generator.x-1.73101400,generator.y+4.99876000,generator.z+1.90587200,false,false,false)
	CreateObject(`V_24_hal_over_decal`,generator.x-1.47243500,generator.y+4.74542700,generator.z+0.08907700,false,false,false)
	CreateObject(`V_24_hal_over_normal`,generator.x-1.47243500,generator.y+4.74542600,generator.z+1.89659400,false,false,false)

	CreateObject(`V_24_lga_mesh_delta`,generator.x+6.48049700,generator.y-3.08154200,generator.z+5.88945200,false,false,false)
	CreateObject(`V_24_lga_over_normal`,generator.x+6.66721800,generator.y-2.87677000,generator.z+6.15558600,false,false,false)
	CreateObject(`V_24_lga_over_dirt`,generator.x+7.92383500,generator.y+0.48949300,generator.z+5.94185400,false,false,false)
	CreateObject(`V_24_lna_mesh_win2`,generator.x+10.50836000,generator.y-4.35302000,generator.z+5.93174400,false,false,false)
	CreateObject(`V_24_lna_mesh_win3`,generator.x+8.11404300,generator.y-6.76422400,generator.z+5.93174400,false,false,false)
	CreateObject(`V_24_lna_mesh_win4`,generator.x+4.61669200,generator.y-6.86532900,generator.z+5.93174400,false,false,false)
	CreateObject(`V_24_lna_mesh_win1`,generator.x+10.61062000,generator.y-1.02313000,generator.z+5.93174400,false,false,false)

	CreateObject(`V_24_rpt_mesh_delta`,generator.x+4.67462300,generator.y+2.99967600,generator.z+6.38973500,false,false,false)

	CreateObject(`V_24_rpt_over_normal`,generator.x+4.76357300,generator.y+2.91692200,generator.z+6.60752300,false,false,false) -- one has a shadow
	CreateObject(`V_24_rct_over_decal`,generator.x+7.63307100,generator.y+7.23755300,generator.z+6.62183300,false,false,false) -- one has a shadow

	CreateObject(`V_24_lna_Stair_window`,generator.x+14.18039000,generator.y+1.72082600,generator.z+5.54589800,false,false,false)
	CreateObject(`V_24_sta_mesh_delta`,generator.x+11.66691000,generator.y+3.74437700,generator.z+2.09721300,false,false,false)
	CreateObject(`V_24_sta_over_normal`,generator.x+11.99206000,generator.y+3.74093500,generator.z+1.90694100,false,false,false)
	CreateObject(`V_24_wdr_mesh_delta`,generator.x+4.48859200,generator.y-3.54236200,generator.z+1.90639300,false,false,false)
	CreateObject(`V_24_wdr_mesh_windows`,generator.x+4.58995500,generator.y-6.76755800,generator.z+1.90783500,false,false,false)
	CreateObject(`V_24_wdr_over_decal`,generator.x+4.60529600,generator.y-3.56273700,generator.z+1.93097000,false,false,false)
	CreateObject(`V_24_wdr_over_normal`,generator.x+4.56429800,generator.y-3.56380800,generator.z+1.99213000,false,false,false)
	CreateObject(`V_24_wdr_over_dirt`,generator.x-2.51400300,generator.y-2.02274400,generator.z+1.93097000,false,false,false)



	local window = CreateObject(`V_24_bdr_mesh_windows_closed`,generator.x-2.17360200,generator.y-6.82748900,generator.z+1.90783500,false,false,false)

	FreezeEntityPosition(window,true)
	SetEntityHeading(PlayerPedId(),267.0)
	SetGameplayCamRelativeHeading(0.0)
end

function buildTrevor()
	-- make it trevor later
	SetEntityCoords(PlayerPedId(),-1153.18300000 ,-1518.34800000, 9.63082300)
	Wait(1200)

	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 35.0}
	SetEntityCoords(PlayerPedId(), generator.x, generator.y-4,generator.z+3.0)

	local building = CreateObject(`furnitured_midapart`,generator.x+0.42222900,generator.y-0.13131700,generator.z+1.18855100,false,false,false)
	FreezeEntityPosition(building,true)

	SetEntityHeading(PlayerPedId(),267.0)
	SetGameplayCamRelativeHeading(0.0)

end



function buildApartment(heading)

	SetEntityCoords(PlayerPedId(), 152.09986877441 , -1004.7946166992, -98.999984741211)
	Wait(1300)
	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 28.0}

	Citizen.Wait(1500)

	local building = CreateObject(`furnitured_motel`,generator.x,generator.y,generator.z,false,false,false)

	FreezeEntityPosition(building,true)
	Citizen.Wait(100)

	local a = CreateObject(`v_49_motelmp_winframe`,generator.x+0.74,generator.y-4.26,generator.z+1.11,false,false,false)
	local b = CreateObject(`v_49_motelmp_glass`,generator.x+0.74,generator.y-4.26,generator.z+1.13,false,false,false)
	local c = CreateObject(`v_49_motelmp_curtains`,generator.x+0.74,generator.y-4.15,generator.z+0.9,false,false,false)
	FreezeEntityPosition(a,true)
	FreezeEntityPosition(b,true)
	FreezeEntityPosition(c,true)
	Citizen.Wait(500)
	SetEntityCoords(PlayerPedId(), generator.x-1, generator.y-4, generator.z+1.8)


end


function buildHouse()
	SetEntityCoords(PlayerPedId(),347.04724121094,-1000.2844848633,-99.194671630859)
	Wait(1200)

	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 28.0}
	SetEntityCoords(PlayerPedId(), generator.x+4.5 , generator.y-14, generator.z+2.9)

	local building = CreateObject(`furnitured_midapart`,generator.x+2.29760700,generator.y-1.33191200,generator.z+1.26253700,false,false,false)
	FreezeEntityPosition(building,true)
	Citizen.Wait(100)

	local glow = CreateObject(`V_16_treeglow`,generator.x-1.37408500,generator.y-0.95420070,generator.z+1.135,false,false,false)
	local curtins = CreateObject(`V_16_midapt_curts`,generator.x-1.96423300,generator.y-0.95958710,generator.z+1.280,false,false,false)
	local mpdelta = CreateObject(`V_16_mid_hall_mesh_delta`,generator.x+3.69693000,generator.y-5.80020100,generator.z+1.293,false,false,false)
	local bathDelta = CreateObject(`V_16_mid_bath_mesh_delta`,generator.x+4.45460500,generator.y+3.21322800,generator.z+1.21116100,false,false,false)
	local bathmirror = CreateObject(`V_16_mid_bath_mesh_mirror`,generator.x+3.57740800,generator.y+3.25032000,generator.z+1.48871300,false,false,false)
	local beddelta = CreateObject(`V_16_mid_bed_delta`,generator.x+7.95187400,generator.y+1.04246500,generator.z+1.28402300,false,false,false)

	FreezeEntityPosition(dt,true)
	FreezeEntityPosition(glow,true)
	FreezeEntityPosition(curtins,true)
	FreezeEntityPosition(mpmid13,true)
	FreezeEntityPosition(mpdelta,true)

	Citizen.Wait(1500)
	SetEntityCoords(PlayerPedId(), generator.x+4.5 , generator.y-14, generator.z+2.9)
	SetEntityHeading(PlayerPedId(),267.0)
	SetGameplayCamRelativeHeading(0.0)

end


function buildMansion()
	SetEntityCoords(PlayerPedId(),-801.5,178.69,72.84) -- Default Garage location
	Citizen.Wait(1000)

	Wait(1200)
	
	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 40.0}
	SetEntityCoords(PlayerPedId(), generator.x-5.5793 , generator.y+5.100, generator.z)

	local building = CreateObject(`shell_michael`,generator.x+3.57921200,generator.y+3.70079500,generator.z+0.045,false,false,false)
	CreateObject(`V_44_Shell_DT`,generator.x+3.53319000,generator.y+0.63158610,generator.z+0.05,false,false,false)
	CreateObject(`V_44_Shell_kitchen`,generator.x+10.43252000,generator.y+6.99729500,generator.z+0.50649800,false,false,false)
	CreateObject(`V_44_1_Hall_Deta`,generator.x+3.37417900,generator.y+1.67813900,generator.z+4.64078700,false,false,false)
	CreateObject(`V_44_Lounge_Deca`,generator.x+3.46935500,generator.y-2.95353700,generator.z+0.19696300,false,false,false)
	CreateObject(`V_44_Lounge_Items`,generator.x+3.51090600,generator.y-1.92194400,generator.z+0.99696300,false,false,false)
	CreateObject(`V_44_Lounge_Deta`,generator.x+3.51090600,generator.y-1.92194300,generator.z+0.04133500,false,false,false)
	CreateObject(`V_44_1_Hall_Deca`,generator.x+3.13426900,generator.y+1.57208700,generator.z+4.17700800,false,false,false)
	CreateObject(`V_44_1_Hall_Emis`,generator.x+3.07805800,generator.y+1.41576700,generator.z+4.67713900,false,false,false)
	CreateObject(`V_44_G_Hall_Stairs`,generator.x+2.20412200,generator.y+6.63279700,generator.z+0.0591100,false,false,false)
	CreateObject(`V_44_G_Hall_Deca`,generator.x-1.17366600,generator.y+5.92338700,generator.z+0.0591100,false,false,false)
	CreateObject(`V_44_G_Hall_Detail`,generator.x-1.02243200,generator.y+6.13491800,generator.z-0.10022200,false,false,false)
	local fakeWindow = CreateObject(`V_44_fakewindow2`,generator.x+4.21531000,generator.y+10.08412000,generator.z+4.87963000,false,false,false)
	SetEntityHeading(fakeWindow,GetEntityHeading(fakeWindow)+90)
	CreateObject(`V_44_G_Hall_Emis`,generator.x+2.20520900,generator.y+6.75564800,generator.z+0.08329000,false,false,false)
	CreateObject(`v_res_wall_cornertop`,generator.x+5.75375900,generator.y+3.57656500,generator.z+4.64713100,false,false,false)

	CreateObject(`V_44_CableMesh3833165_TStd`,generator.x+1.75523300,generator.y+6.39947000,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd001`,generator.x+1.78448500,generator.y+6.42844600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd002`,generator.x+1.74144700,generator.y+6.35389700,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd003`,generator.x+1.75072700,generator.y+6.30324000,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd004`,generator.x+1.78820400,generator.y+6.25723600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd005`,generator.x+1.84311200,generator.y+6.23637000,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd006`,generator.x+1.90750400,generator.y+6.24566200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd007`,generator.x+1.96734300,generator.y+6.28310200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd008`,generator.x+2.00246200,generator.y+6.34640700,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd009`,generator.x+2.00791500,generator.y+6.42378600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd010`,generator.x+1.97100100,generator.y+6.50082400,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd011`,generator.x+1.90181300,generator.y+6.55381400,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd012`,generator.x+1.81217900,generator.y+6.56836200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd013`,generator.x+1.72014100,generator.y+6.54205000,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd014`,generator.x+1.64590600,generator.y+6.47087100,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd015`,generator.x+1.61379000,generator.y+6.36883200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd016`,generator.x+1.62891000,generator.y+6.25810100,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd017`,generator.x+1.69617000,generator.y+6.16635900,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd018`,generator.x+1.80279100,generator.y+6.11314600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd019`,generator.x+1.92696300,generator.y+6.11514100,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd020`,generator.x+2.04181100,generator.y+6.17349800,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd021`,generator.x+2.12081100,generator.y+6.28245600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd022`,generator.x+2.14047900,generator.y+6.41642200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd023`,generator.x+2.09283800,generator.y+6.55434200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd024`,generator.x+1.98836000,generator.y+6.65625400,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd025`,generator.x+1.84142900,generator.y+6.70009800,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd026`,generator.x+1.68961500,generator.y+6.67540200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd027`,generator.x+1.56111200,generator.y+6.57634700,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd028`,generator.x+1.48924500,generator.y+6.42581500,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd029`,generator.x+1.49306700,generator.y+6.25427400,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd030`,generator.x+1.57488200,generator.y+6.10241900,generator.z+4.76513900,false,false,false)



	CreateObject(`V_44_G_Kitche_Deta`,generator.x+10.46560000,generator.y+5.93617800,generator.z+0.45652500,false,false,false)
	CreateObject(`V_44_Kitche_Units`,generator.x+8.25900000,generator.y+8.95200000,generator.z+0.46638600,false,false,false)
	CreateObject(`V_44_G_Kitche_Deca`,generator.x+10.32270000,generator.y+6.99725600,generator.z+0.19062300,false,false,false)
	CreateObject(`v_ilev_mm_fridge_r`,generator.x+8.25900000,generator.y+8.95199800,generator.z+0.60638600,false,false,false)
	CreateObject(`v_ilev_mm_fridge_l`,generator.x+6.88500100,generator.y+8.95199800,generator.z+0.60638600,false,false,false)

	CreateObject(`V_44_kitc_chand`,generator.x+10.41700000,generator.y+6.60862900,generator.z+3.18510400,false,false,false)
	

	

	CreateObject(`v_res_wall`,generator.x+9.48288900,generator.y+3.80587900,generator.z+0.49649800,false,false,false)

	CreateObject(`V_44_Kitche_Cables`,generator.x+15.13288000,generator.y+7.09520900,generator.z+2.93397100,false,false,false)
	CreateObject(`V_44_G_Kitche_Mirror`,generator.x+10.43927000,generator.y+6.61117700,generator.z+1.35984500,false,false,false)
	CreateObject(`V_44_Kitc_Emmi_Refl`,generator.x+14.88308000,generator.y+7.08548200,generator.z+1.71777900,false,false,false)

	CreateObject(`V_44_1_WC_Deta`,generator.x+1.17765600,generator.y-4.48131400,generator.z+4.63232000,false,false,false)
	CreateObject(`V_44_1_WC_Deca`,generator.x+1.59504700,generator.y-6.12709600,generator.z+4.63267900,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.70206260,generator.y-4.16378900,generator.z+5.71612900,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.68338590,generator.y-4.52617000,generator.z+5.71612900,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.72427940,generator.y-4.86893600,generator.z+5.71612900,false,false,false)
	CreateObject(`v_res_mbathpot`,generator.x+0.70345690,generator.y-4.35693900,generator.z+6.48056100,false,false,false)
	CreateObject(`v_res_glasspot`,generator.x+0.71698950,generator.y-4.14175200,generator.z+6.47866700,false,false,false)

	CreateObject(`v_res_mlaundry`,generator.x+0.76481630,generator.y-4.38597400,generator.z+4.68115500,false,false,false)
	CreateObject(`v_res_mbbin`,generator.x+0.77170370,generator.y-4.85373500,generator.z+4.68933400,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.71842000,generator.y-4.16739000,generator.z+6.09812900,false,false,false)
	CreateObject(`prop_toilet_shamp_02`,generator.x+0.68262770,generator.y-4.77760400,generator.z+6.60591400,false,false,false)
	CreateObject(`v_res_mpotpouri`,generator.x+0.72062970,generator.y-4.56955600,generator.z+6.47866700,false,false,false)

	CreateObject(`prop_toilet_shamp_02`,generator.x+0.78394590,generator.y-4.83148300,generator.z+6.60591400,false,false,false)
	CreateObject(`v_res_tissues`,generator.x+0.74644000,generator.y-4.58213100,generator.z+6.09788000,false,false,false)
	CreateObject(`v_res_fa_mag_rumor`,generator.x+0.71411900,generator.y-4.89627400,generator.z+6.19172800,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.70755580,generator.y-4.71013000,generator.z+5.40776400,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.70206260,generator.y-4.31527900,generator.z+5.40776400,false,false,false)
	CreateObject(`v_res_m_wctoiletroll`,generator.x+1.05170400,generator.y-7.98192900,generator.z+5.28550600,false,false,false)

	CreateObject(`V_44_1_WC_Wall`,generator.x+0.58679010,generator.y-5.92510000,generator.z+4.64117100,false,false,false)
	local sink = CreateObject(`v_res_m_sinkunit`,generator.x+0.57028010,generator.y-6.54750800,generator.z+4.57696100,false,false,false)
	SetEntityHeading(sink,GetEntityHeading(sink)+90)
	CreateObject(`v_res_mbathpot`,generator.x+0.44344710,generator.y-5.86374200,generator.z+5.41919400,false,false,false)
	CreateObject(`v_res_mbaccessory`,generator.x+0.44116590,generator.y-5.68478200,generator.z+5.40682800,false,false,false)

	CreateObject(`v_res_fashmag1`,generator.x+0.53466320,generator.y-7.69714400,generator.z+5.40757800,false,false,false)
	CreateObject(`v_res_mpotpouri`,generator.x+0.46240810,generator.y-7.37532400,generator.z+5.40551200,false,false,false)
	CreateObject(`prop_toilet_brush_01`,generator.x+0.89410590,generator.y-7.78916400,generator.z+4.55693300,false,false,false)
	CreateObject(`prop_toothpaste_01`,generator.x+0.62113380,generator.y-6.03470400,generator.z+5.39733200,false,false,false)
	CreateObject(`prop_toilet_shamp_02`,generator.x+0.37264820,generator.y-6.11828800,generator.z+5.53571800,false,false,false)
	CreateObject(`prop_toilet_shamp_02`,generator.x+0.34396170,generator.y-6.26275800,generator.z+5.53571800,false,false,false)
	local mirror = CreateObject(`v_ret_mirror`,generator.x+0.31381230,generator.y-6.52928800,generator.z+5.64878300,false,false,false)
	SetEntityHeading(mirror,GetEntityHeading(mirror)+90)
	CreateObject(`V_44_1_Son_Deta`,generator.x-2.38526100,generator.y-4.51695800,generator.z+4.60237100,false,false,false)
	CreateObject(`V_44_fakewindow6`,generator.x-5.33984800,generator.y-6.60726400,generator.z+4.74075300,false,false,false)
	CreateObject(`V_44_1_Daught_Deta_ns`,generator.x+5.15501400,generator.y-4.61960500,generator.z+4.63951100,false,false,false)

	CreateObject(`V_44_D_chand`,generator.x+4.94644200,generator.y-5.37181500,generator.z+7.03764900,false,false,false)
	CreateObject(`V_44_fakewindow007`,generator.x+5.43454700,generator.y-6.13995100,generator.z+5.70870800,false,false,false)
	CreateObject(`V_44_1_Master_Deca`,generator.x-3.69378700,generator.y+6.42393100,generator.z+4.70213800,false,false,false)
	CreateObject(`V_44_fakewindow5`,generator.x-4.23272900,generator.y+10.06902000,generator.z+6.88756600,false,false,false)
	CreateObject(`prop_d_balcony_l_light`,generator.x-8.07400100,generator.y+7.33400000,generator.z+5.98500000,false,false,false)
	CreateObject(`prop_d_balcony_r_light`,generator.x-8.07500100,generator.y+5.36899900,generator.z+5.98200100,false,false,false)
	CreateObject(`V_44_Dine_Deca`,generator.x+11.95362000,generator.y+1.21796200,generator.z+0.73423600,false,false,false)
	CreateObject(`V_44_Dine_Deta`,generator.x+12.00919000,generator.y+1.16270300,generator.z+0.49488500,false,false,false)
	CreateObject(`V_44_Dine_Detail`,generator.x+11.95362000,generator.y+1.21796200,generator.z+2.53423600,false,false,false)
	CreateObject(`V_44_G_Fron_Deca`,generator.x-6.02163100,generator.y+6.55411300,generator.z+0.12220900,false,false,false)
	CreateObject(`V_44_1_Master_Ward`,generator.x-6.40655500,generator.y+1.73388900,generator.z+4.63934600,false,false,false)
	CreateObject(`V_44_1_Mast_WaDeca`,generator.x-5.12681000,generator.y+1.68215100,generator.z+4.63070600,false,false,false)
	CreateObject(`V_44_G_Cor_Blen`,generator.x+4.49310600,generator.y+8.63649000,generator.z+0.24844800,false,false,false)
	CreateObject(`V_44_G_Cor_Deta`,generator.x+4.49310600,generator.y+8.63649000,generator.z+0.24844800,false,false,false)
	CreateObject(`V_44_Garage_Shell`,generator.x+0.79177808,generator.y+13.23049000,generator.z+0.24844800,false,false,false)

	local shelf = CreateObject(`V_44_1_Mast_WaShel_M`,generator.x-3.78199100,generator.y+1.73383800,generator.z+4.57161100,false,false,false)
	FreezeEntityPosition(shelf,true)

	FreezeEntityPosition(building,true)
	Citizen.Wait(1500)


	SetEntityCoords(PlayerPedId(), generator.x-5.5793 , generator.y+5.100, generator.z)
	SetEntityHeading(PlayerPedId(),267.0)
	SetGameplayCamRelativeHeading(0.0)

end

--[1] =  { ['x'] = 171.91,['y'] = -34.89,['z'] = 68.0,['h'] = 180.43, ['info'] = ' Park 1' },
--[2] =  { ['x'] = 166.28,['y'] = -32.11,['z'] = 67.87,['h'] = 179.19, ['info'] = ' Park 2' },
--[3] =  { ['x'] = 160.67,['y'] = -30.25,['z'] = 67.77,['h'] = 176.39, ['info'] = ' Park 3' },
--[4] =  { ['x'] = 154.77,['y'] = -27.93,['z'] = 67.69,['h'] = 176.23, ['info'] = ' Park 4' },


function buildOfficeCentre()

	SetEntityCoords(PlayerPedId(),-1389.412, -475.6651, 72.04217)
  	Citizen.Wait(1000)
	local generator = { x = -1389.412 , y = -475.6651, z = 72.04217 }
	


	
  	SetEntityHeading(PlayerPedId(),267.0)
  	SetGameplayCamRelativeHeading(0.0)
end


function buildOffice2()

	SetEntityCoords(PlayerPedId(),-139.53950000,-629.07570000,167.82040000)
	Citizen.Wait(2000)

	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 24.0}
	SetEntityCoords(PlayerPedId(), generator.x-3.5793 , generator.y+3.100, generator.z)

	local building = CreateObject(`ex_office_03b_shell_2`,generator.x+0.82022000,generator.y+1.45879100,generator.z-4.22499600,false,false,false)

	CreateObject(`ex_office_03b_skirt1`,generator.x+0.82022000,generator.y+1.45879100,generator.z+0.08499600,false,false,false)
	CreateObject(`ex_off_03b_GEOMLIGHT_Reception`,generator.x+5.59351200,generator.y+0.97565800,generator.z+3.40000800,false,false,false)

	local l1 = CreateObject(`v_serv_2socket`,generator.x-2.12396500,generator.y-2.06103500,generator.z+0.30746700,false,false,false)
	local l2 =CreateObject(`v_serv_switch_3`,generator.x-2.21688300,generator.y-2.06089200,generator.z+1.49840300,false,false,false)
	local l3 =CreateObject(`v_serv_switch_3`,generator.x-2.02786100,generator.y-2.06089200,generator.z+1.49840300,false,false,false)
	SetEntityHeading(l1,GetEntityHeading(l1)+90)
	SetEntityHeading(l2,GetEntityHeading(l2)+90)
	SetEntityHeading(l3,GetEntityHeading(l3)+90)

	local alarm = CreateObject(`v_res_tre_alarmbox`,generator.x-2.74074700,generator.y-1.48556800,generator.z+1.24797900,false,false,false)
	SetEntityHeading(alarm,GetEntityHeading(alarm)+90)
	CreateObject(`ex_office_03b_EdgesRecep`,generator.x+4.60805000,generator.y-1.47149300,generator.z+0.01280200,false,false,false)
	CreateObject(`ex_office_03b_Shad_Recep`,generator.x+3.65794100,generator.y-0.10437700,generator.z+0.00000000,false,false,false)
	

	CreateObject(`ex_Office_03b_hskirt3`,generator.x+13.31318000,generator.y+1.32258700,generator.z+0.05000100,false,false,false)
	CreateObject(`ex_off_03b_GEOLIGHT_FrontOffice`,generator.x+12.77866000,generator.y-11.67066000,generator.z+3.22427500,false,false,false)
	CreateObject(`ex_office_03b_FloorLamp0103`,generator.x+10.77528000,generator.y+14.41163000,generator.z-0.00005500,false,false,false)

	CreateObject(`v_serv_2socket`,generator.x+10.21870000,generator.y+12.57842000,generator.z+0.30746700,false,false,false)


	local safe = CreateObject(`ex_office_03b_Safes`,generator.x+10.49555000,generator.y+0.00422400,generator.z+0.00000000,false,false,false)
	SetEntityHeading(safe,GetEntityHeading(safe)-90)
	--CreateObject(`ex_prop_safedoor_office3a_l`,generator.x+11.41656000,generator.y+14.50558000,generator.z+1.05049900,false,false,false)
	CreateObject(`ex_office_03b_Edges_Main`,generator.x+13.61647000,generator.y+1.94954700,generator.z+0.01285300,false,false,false)
	--CreateObject(`ex_prop_safedoor_office3a_r`,generator.x+16.25136000,generator.y+14.50558000,generator.z+1.05049900,false,false,false)
	CreateObject(`ex_office_03b_Shad_Main`,generator.x+13.86071000,generator.y+0.08125000,generator.z+0.00000000,false,false,false)

	local wframe =  CreateObject(`ex_office_03b_wFrame003`,generator.x+12.31777000,generator.y-5.44320100,generator.z+0.10772200,false,false,false)
	SetEntityHeading(wframe,GetEntityHeading(wframe)-90)
	
	CreateObject(`ex_office_03b_SoundBaffles1`,generator.x+14.50548000,generator.y-0.94601400,generator.z+3.39024900,false,false,false)

	local window =CreateObject(`ex_prop_office_louvres`,generator.x+18.06730000,generator.y-0.23932300,generator.z+0.10772200,false,false,false)
	SetEntityHeading(window,GetEntityHeading(window)+90)

	
	CreateObject(`ex_office_03b_GlassPane2`,generator.x+11.06012000,generator.y-5.40525200,generator.z+0.22725900,false,false,false)
	CreateObject(`ex_office_03b_GlassPane004`,generator.x+16.32030000,generator.y-5.41362200,generator.z+0.22725900,false,false,false)
	CreateObject(`ex_office_03b_GlassPane003`,generator.x+11.06012000,generator.y-5.41357300,generator.z+0.22725900,false,false,false)
	CreateObject(`ex_office_03b_GlassPane1`,generator.x+16.32030000,generator.y-5.40530200,generator.z+0.22725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass020`,generator.x+17.59421000,generator.y-2.51997600,generator.z+0.50725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass019`,generator.x+17.59421000,generator.y-4.25111800,generator.z+0.50725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass022`,generator.x+17.59421000,generator.y+0.94213700,generator.z+0.50725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass023`,generator.x+17.59421000,generator.y+2.67310600,generator.z+0.50725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass021`,generator.x+17.59421000,generator.y-0.78900700,generator.z+0.50725900,false,false,false)
	
	local iw1 = CreateObject(`ex_office_03b_WinGlass014`,generator.x+6.15745700,generator.y-5.41205300,generator.z+0.17772200,false,false,false)
	local iw2 = CreateObject(`ex_office_03b_WinGlass015`,generator.x+8.12344600,generator.y-5.41205300,generator.z+0.17772200,false,false,false)
	local iw3 = CreateObject(`ex_office_03b_WinGlass013`,generator.x+4.19166100,generator.y-5.41205300,generator.z+0.17772200,false,false,false)
	local frame2 = CreateObject(`ex_office_03b_wFrame2`,generator.x+6.14261300,generator.y-5.40933400,generator.z+0.00772200,false,false,false)
	SetEntityHeading(frame2,GetEntityHeading(frame2)-90)
	SetEntityHeading(iw1,GetEntityHeading(iw1)-90)
	SetEntityHeading(iw2,GetEntityHeading(iw2)-90)
	SetEntityHeading(iw3,GetEntityHeading(iw3)-90)
	
	
	local sink = CreateObject(`ex_office_03b_kitchen`,generator.x+4.23552100,generator.y-11.73340000,generator.z+0.06602100,false,false,false)
	CreateObject(`ex_office_03b_skirt2`,generator.x+4.10593700,generator.y-8.57737300,generator.z+0.04999800,false,false,false)
	CreateObject(`ex_off_03b_GEOMLIGHT_WaitingArea`,generator.x+3.34384900,generator.y-10.12492000,generator.z+3.40000800,false,false,false)
	SetEntityHeading(sink,GetEntityHeading(sink)-90)


	local edges4 = CreateObject(`ex_office_03b_EdgesWait`,generator.x+9.14111600,generator.y-5.90339900,generator.z+0.00000400,false,false,false)
	SetEntityHeading(edges4,GetEntityHeading(edges4)-90)

	local iw4 = CreateObject(`ex_office_03b_WinGlass018`,generator.x+5.07940000,generator.y-5.42724400,generator.z+0.17772200,false,false,false)
	local iw5 =CreateObject(`ex_office_03b_WinGlass017`,generator.x+7.04538900,generator.y-5.42724400,generator.z+0.17772200,false,false,false)
	local iw6 =CreateObject(`ex_office_03b_WinGlass016`,generator.x+9.01118500,generator.y-5.42724400,generator.z+0.17772200,false,false,false)
	SetEntityHeading(iw4,GetEntityHeading(iw4)+90)
	SetEntityHeading(iw5,GetEntityHeading(iw5)+90)
	SetEntityHeading(iw6,GetEntityHeading(iw6)+90)
	


	
	CreateObject(`ex_office_03b_skirt4`,generator.x+5.87873900,generator.y+9.78554600,generator.z+0.04999900,false,false,false)
	CreateObject(`ex_office_03b_GEOMLIGHT_Bathroom`,generator.x+5.14397000,generator.y+8.93845400,generator.z+2.91470400,false,false,false)




	local gshelf = CreateObject(`ex_office_03b_GlassShelves2`,generator.x+10.06959000,generator.y+12.40041000,generator.z+0.75042600,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+1.51790700,generator.y+6.78857800,generator.z+1.49840300,false,false,false)
	CreateObject(`v_serv_2socket`,generator.x+1.51944800,generator.y+6.78857800,generator.z+0.30746700,false,false,false)
	CreateObject(`v_serv_2socket`,generator.x+2.51535200,generator.y+12.63103000,generator.z+0.30746700,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+2.51381100,generator.y+12.63103000,generator.z+1.49840300,false,false,false)
	CreateObject(`ex_office_03b_Edges_Chng`,generator.x+4.58213600,generator.y+10.05374000,generator.z+0.00000400,false,false,false)
	CreateObject(`ex_office_03b_Shad_Bath`,generator.x+5.59655300,generator.y+12.34816000,generator.z+0.00000000,false,false,false)
	local art = CreateObject(`ex_Office_03b_bathroomArt`,generator.x+10.19056000,generator.y+12.57837000,generator.z+1.66302500,false,false,false)
	local power4 = CreateObject(`ex_office_03b_sideboardPower_004`,generator.x+8.81734200,generator.y+9.50928800,generator.z+0.10705600,false,false,false)
	SetEntityHeading(art,GetEntityHeading(art)-90)
	SetEntityHeading(gshelf,GetEntityHeading(gshelf)-180)
	SetEntityHeading(power4,GetEntityHeading(power4)+90)
	
	local plate = CreateObject(`ex_mp_h_acc_dec_plate_01`,generator.x-16.45605000,generator.y-0.05843100,generator.z+1.00123400,false,false,false)

	local table0 = CreateObject(`ex_prop_ex_console_table_01`,generator.x-16.33744000,generator.y-0.05843100,generator.z+0.00000000,false,false,false)

	SetEntityHeading(plate,GetEntityHeading(plate)+90)
	SetEntityHeading(table0,GetEntityHeading(table0)+90)

	
	CreateObject(`ex_office_03b_LIGHT_Foyer`,generator.x-3.82964100,generator.y+0.02804200,generator.z+3.10086700,false,false,false)
	CreateObject(`ex_office_03b_normalonly1`,generator.x-8.42918000,generator.y-0.02619600,generator.z+0.71280200,false,false,false)
	CreateObject(`ex_office_03b_foyerdetail`,generator.x-9.78775400,generator.y-0.02673700,generator.z+0.09000000,false,false,false)
	CreateObject(`ex_Office_03b_numbers`,generator.x-9.93670100,generator.y-0.02917200,generator.z+2.40085100,false,false,false)
	local detail = CreateObject(`ex_office_03b_elevators`,generator.x+10.49555000,generator.y+0.00422400,generator.z+0.08000000,false,false,false)
	CreateObject(`ex_office_03b_CARPETS`,generator.x+8.07606700,generator.y+1.32258800,generator.z+0.00198900,false,false,false)
	CreateObject(`ex_office_03b_Shower`,generator.x+0.34558600,generator.y+6.88265700,generator.z-0.06255700,false,false,false)
	SetEntityHeading(detail,GetEntityHeading(detail)-90)
	

	CreateObject(`ex_p_mp_door_apart_doorbrown_s`,generator.x+1.44672400,generator.y+8.81843100,generator.z+1.24813200,false,false,false)
	CreateObject(`ex_Office_03b_Proxy_CeilingLight`,generator.x+3.33397300,generator.y-0.02675400,generator.z+3.68248700,false,false,false)
	CreateObject(`ex_Office_03b_ToiletSkirting`,generator.x+1.13302800,generator.y+11.37978000,generator.z-0.10000000,false,false,false)
	CreateObject(`ex_Office_03b_Toilet`,generator.x+1.08040800,generator.y+12.24717000,generator.z+0.22479800,false,false,false)

	CreateObject(`ex_Office_03b_ToiletArt`,generator.x+1.13303000,generator.y+12.73267000,generator.z+1.33258700,false,false,false)
	CreateObject(`prop_toilet_roll_02`,generator.x+0.56858000,generator.y+12.57573000,generator.z+0.58252000,false,false,false)
	CreateObject(`v_res_mlaundry`,generator.x+0.03584800,generator.y+12.02357000,generator.z+0.00000000,false,false,false)
	CreateObject(`prop_towel_rail_02`,generator.x-0.12948900,generator.y+11.68217000,generator.z+0.70703100,false,false,false)
	CreateObject(`v_res_tre_washbasket`,generator.x+2.09027800,generator.y+10.48882000,generator.z+0.00000000,false,false,false)
	CreateObject(`ex_office_03b_sinks001`,generator.x+0.28737900,generator.y+11.64389000,generator.z+1.19806000,false,false,false)
	CreateObject(`ex_Office_03b_ToiletTaps`,generator.x+0.01130900,generator.y+11.10180000,generator.z+1.01921500,false,false,false)
	CreateObject(`ex_office_03b_GEOMLIGHT_Toilet`,generator.x+0.38847900,generator.y+11.50150000,generator.z+2.69625500,false,false,false)
	CreateObject(`ex_p_mp_door_apart_doorbrown01`,generator.x+2.47054500,generator.y+10.99843000,generator.z+1.15000000,false,false,false)
	CreateObject(`ex_office_03b_room_blocker`,generator.x+6.21348800,generator.y+6.43969200,generator.z-0.29498500,false,false,false)


	FreezeEntityPosition(building,true)
  	SetEntityCoords(PlayerPedId(), generator.x-3.5793 , generator.y+3.100, generator.z+0.6)
  	SetEntityHeading(PlayerPedId(),267.0)
  	SetGameplayCamRelativeHeading(0.0)
end







function buildMansionRob(id,firstin) 

	SetEntityCoords(PlayerPedId(),-801.5,178.69,72.84) -- Default Garage location
  	
	FreezeEntityPosition(PlayerPedId(),true)
	Citizen.Wait(3000)

	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 34.0}

	if enterback then
		SetEntityCoords(PlayerPedId(),generator.x+14.17921200,generator.y+1.90079500,generator.z+1.1)
	else
		SetEntityCoords(PlayerPedId(),generator.x-5.57921200,generator.y+5.10079500,generator.z+1.1)
	end


	

	local building = CreateObject(`v_44_shell`,generator.x+3.57921200,generator.y+3.70079500,generator.z-0.1,false,false,false)
	local building2 = CreateObject(`V_44_Shell2`,generator.x+3.57921200,generator.y+3.70079500,generator.z+4.54096300,false,false,false)
	CreateObject(`V_44_Shell_DT`,generator.x+3.53319000,generator.y+0.63158610,generator.z+0.05,false,false,false)
	CreateObject(`V_44_Shell_kitchen`,generator.x+10.43252000,generator.y+6.99729500,generator.z+0.50649800,false,false,false)
	CreateObject(`V_44_1_Hall_Deta`,generator.x+3.37417900,generator.y+1.67813900,generator.z+4.64078700,false,false,false)
	CreateObject(`V_44_Lounge_Deca`,generator.x+3.46935500,generator.y-2.95353700,generator.z+0.19696300,false,false,false)
	CreateObject(`V_44_Lounge_Items`,generator.x+3.51090600,generator.y-1.92194400,generator.z+0.99696300,false,false,false)
	CreateObject(`V_44_Lounge_DecaL`,generator.x+3.26119400,generator.y-2.95349700,generator.z+0.72649800,false,false,false)

	CreateObject(`v_res_m_armchair`,generator.x+2.39658700,generator.y-0.76810070,generator.z+0.68484200,false,false,false)
	local sofa = CreateObject(`v_ilev_m_sofa`,generator.x+2.49675000,generator.y-4.20500900,generator.z+0.67964300,false,false,false)
	SetEntityHeading(sofa,GetEntityHeading(sofa)+100)
	CreateObject(`v_res_m_lampstand2`,generator.x+1.48265400,generator.y-0.84137140,generator.z+0.67608500,false,false,false)
	CreateObject(`v_res_m_armchair`,generator.x+6.21690200,generator.y-6.11628200,generator.z+0.67484200,false,false,false)
	CreateObject(`v_res_m_armchair`,generator.x+2.39658700,generator.y-0.76810070,generator.z+0.68484200,false,false,false)



	CreateObject(`V_44_Lounge_Deta`,generator.x+3.51090600,generator.y-1.92194300,generator.z+0.04133500,false,false,false)
	CreateObject(`v_res_mplanttongue`,generator.x+6.71760400,generator.y-2.22743200,generator.z+0.67305700,false,false,false)
	CreateObject(`v_res_fashmag1`,generator.x+3.57820100,generator.y+1.92808700,generator.z+1.75578100,false,false,false)
	local projector =  CreateObject(`v_ilev_mm_scre_off`,generator.x+6.20400000,generator.y-3.86164200,generator.z+2.34300000,false,false,false)
	SetEntityHeading(projector,GetEntityHeading(projector)+90)
	CreateObject(`v_res_mountedprojector`,generator.x+1.57309300,generator.y-3.85972100,generator.z+4.10981500,false,false,false)
	CreateObject(`v_res_m_stool`,generator.x+3.44306000,generator.y-2.37584100,generator.z+0.67964300,false,false,false)
	local desk = CreateObject(`v_res_mconsolemod`,generator.x+3.34306000,generator.y+2.07584100,generator.z+0.67964300,false,false,false)
	FreezeEntityPosition(desk,true)

	CreateObject(`v_res_msidetblemod`,generator.x+1.61465700,generator.y-1.51442700,generator.z+0.67151600,false,false,false)
	CreateObject(`v_res_msidetblemod`,generator.x+6.15811500,generator.y-7.04496300,generator.z+0.67151600,false,false,false)
	CreateObject(`v_res_mconsoletrad`,generator.x+2.26189700,generator.y-8.03078800,generator.z+0.67178400,false,false,false)
	CreateObject(`v_res_m_l_chair1`,generator.x+1.85258000,generator.y+2.04241000,generator.z+0.68464200,false,false,false)
	CreateObject(`v_res_m_l_chair1`,generator.x+4.80667200,generator.y+2.04241000,generator.z+0.68464200,false,false,false)
	CreateObject(`v_res_mplanttongue`,generator.x+6.61146400,generator.y-5.48816700,generator.z+0.67305700,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x+6.15963000,generator.y-7.04415300,generator.z+1.51251600,false,false,false)
	CreateObject(`v_res_r_fighorsestnd`,generator.x+2.76621100,generator.y-8.16190900,generator.z+1.67301800,false,false,false)
	CreateObject(`v_res_m_palmplant1`,generator.x+0.08713913,generator.y-7.26929300,generator.z+0.3557600,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x+3.82970200,generator.y+2.15182300,generator.z+1.75605000,false,false,false)
	CreateObject(`v_res_m_candlelrg`,generator.x+6.27535300,generator.y-2.88023300,generator.z+0.70131200,false,false,false)
	CreateObject(`v_res_mpotpouri`,generator.x+1.89024700,generator.y-7.97319000,generator.z+1.67301800,false,false,false)
	CreateObject(`v_res_m_candlelrg`,generator.x+6.27901500,generator.y-4.86268600,generator.z+0.70131200,false,false,false)
	CreateObject(`v_res_fa_candle04`,generator.x+6.12360800,generator.y-6.89644600,generator.z+1.58551100,false,false,false)
	CreateObject(`v_res_fa_candle04`,generator.x+1.67240800,generator.y-7.95039100,generator.z+1.74601300,false,false,false)
	CreateObject(`v_res_m_spanishbox`,generator.x+2.31205000,generator.y-8.02846300,generator.z+1.67301800,false,false,false)


	CreateObject(`v_res_m_statue`,generator.x-1.27413000,generator.y-3.86254400,generator.z+2.98763400,false,false,false)
	CreateObject(`Prop_Cigar_pack_02`,generator.x+1.78793000,generator.y-1.69860600,generator.z+1.51857000,false,false,false)
	CreateObject(`prop_ashtray_01`,generator.x+1.67015600,generator.y-1.70531800,generator.z+1.53098900,false,false,false)
	CreateObject(`v_res_m_pot1`,generator.x-0.77471540,generator.y+0.12082960,generator.z+1.75637100,false,false,false)
	CreateObject(`v_res_m_pot1`,generator.x-0.84445380,generator.y-0.11595340,generator.z+1.75637100,false,false,false)
	CreateObject(`v_res_m_spanishbox`,generator.x-1.31776900,generator.y-1.91292500,generator.z+1.94832000,false,false,false)

	CreateObject(`v_res_mbronzvase`,generator.x-1.22181700,generator.y-5.85892400,generator.z+2.96991700,false,false,false)
	CreateObject(`v_res_mbronzvase`,generator.x-1.22181700,generator.y-1.93053400,generator.z+2.96991700,false,false,false)
	CreateObject(`P_CS_Lighter_01`,generator.x+1.65356500,generator.y-1.83352900,generator.z+1.51874300,false,false,false)
	CreateObject(`prop_cs_remote_01`,generator.x+1.91542400,generator.y-3.08195300,generator.z+1.17354000,false,false,false)
	CreateObject(`Prop_Cigar_03`,generator.x+1.69850500,generator.y-1.87285600,generator.z+1.51726400,false,false,false)
	CreateObject(`v_res_jewelbox`,generator.x-1.28456500,generator.y-1.86961300,generator.z+0.92229600,false,false,false)
	CreateObject(`v_res_sculpt_decb`,generator.x+6.35535900,generator.y-6.97679200,generator.z+1.51251600,false,false,false)
	CreateObject(`v_med_smokealarm`,generator.x+2.16099000,generator.y+0.16853520,generator.z+4.27092600,false,false,false)
	CreateObject(`Prop_MP3_Dock`,generator.x+3.01717900,generator.y+1.91097300,generator.z+1.82875200,false,false,false)
	CreateObject(`v_res_mplanttongue`,generator.x+6.22999700,generator.y+2.87820200,generator.z+0.67128700,false,false,false)
	CreateObject(`v_res_m_palmplant1`,generator.x+6.08580900,generator.y-7.32884600,generator.z+0.3557600,false,false,false)
	CreateObject(`v_res_mconsolemod`,generator.x-0.91939260,generator.y-0.08264160,generator.z+4.57637000,false,false,false)
	CreateObject(`v_res_jewelbox`,generator.x-0.82748790,generator.y-0.20085050,generator.z+5.66071400,false,false,false)
	local tbl = CreateObject(`v_res_mconsoletrad`,generator.x+8.11723000,generator.y+1.42394700,generator.z+4.57726500,false,false,false)
	SetEntityHeading(tbl,GetEntityHeading(tbl)+90)
	CreateObject(`v_res_m_lamptbl`,generator.x-1.62722200,generator.y-0.13789180,generator.z+5.65792500,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x+8.18071300,generator.y+2.04316300,generator.z+5.57849900,false,false,false)
	local chair = CreateObject(`v_res_m_l_chair1`,generator.x+7.99242500,generator.y+0.01499653,generator.z+4.57605400,false,false,false)
	CreateObject(`v_res_m_l_chair1`,generator.x+8.01060600,generator.y+2.76839300,generator.z+4.57605400,false,false,false)
	SetEntityHeading(chair,GetEntityHeading(chair)+180)
	CreateObject(`V_44_1_Hall_Deca`,generator.x+3.13426900,generator.y+1.57208700,generator.z+4.17700800,false,false,false)






	CreateObject(`v_res_rosevase`,generator.x-0.26545330,generator.y-0.10977080,generator.z+5.65792600,false,false,false)
	CreateObject(`v_res_sculpt_decb`,generator.x-0.53595730,generator.y-0.11254690,generator.z+5.64740600,false,false,false)
	CreateObject(`v_med_smokealarm`,generator.x+1.68776500,generator.y+0.42464830,generator.z+8.42701300,false,false,false)
	CreateObject(`V_44_1_Hall_Emis`,generator.x+3.07805800,generator.y+1.41576700,generator.z+4.67713900,false,false,false)
	CreateObject(`v_res_exoticvase`,generator.x+8.19652200,generator.y+0.84531020,generator.z+5.57848900,false,false,false)
	CreateObject(`v_res_wall_cornertop`,generator.x+5.75375900,generator.y+3.57656500,generator.z+4.64713100,false,false,false)
	CreateObject(`V_44_G_Hall_Stairs`,generator.x+2.20412200,generator.y+6.63279700,generator.z+0.0591100,false,false,false)
	CreateObject(`v_res_jewelbox`,generator.x+2.19403800,generator.y+6.81445700,generator.z+0.98931310,false,false,false)
	CreateObject(`V_44_G_Hall_Deca`,generator.x-1.17366600,generator.y+5.92338700,generator.z+0.0591100,false,false,false)

	CreateObject(`V_44_G_Hall_Detail`,generator.x-1.02243200,generator.y+6.13491800,generator.z-0.10022200,false,false,false)
	CreateObject(`v_res_m_h_console`,generator.x+1.82824500,generator.y+6.68009400,generator.z-0.01091900,false,false,false)
	CreateObject(`v_res_m_l_chair1`,generator.x+0.31978320,generator.y+6.61237500,generator.z-0.00766298,false,false,false)

	CreateObject(`v_res_m_lamptbl`,generator.x+2.53901100,generator.y+6.84344500,generator.z+0.98873800,false,false,false)
	CreateObject(`v_res_r_fighorse`,generator.x+1.51177400,generator.y+6.80384800,generator.z+0.98999990,false,false,false)

	CreateObject(`V_44_G_Hall_Emis`,generator.x+2.20520900,generator.y+6.75564800,generator.z+0.08329000,false,false,false)
	CreateObject(`v_res_m_palmstairs`,generator.x+4.72221300,generator.y+8.98925600,generator.z+2.54000000,false,false,false)

	CreateObject(`V_44_CableMesh3833165_TStd`,generator.x+1.75523300,generator.y+6.39947000,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd001`,generator.x+1.78448500,generator.y+6.42844600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd002`,generator.x+1.74144700,generator.y+6.35389700,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd003`,generator.x+1.75072700,generator.y+6.30324000,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd004`,generator.x+1.78820400,generator.y+6.25723600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd005`,generator.x+1.84311200,generator.y+6.23637000,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd006`,generator.x+1.90750400,generator.y+6.24566200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd007`,generator.x+1.96734300,generator.y+6.28310200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd008`,generator.x+2.00246200,generator.y+6.34640700,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd009`,generator.x+2.00791500,generator.y+6.42378600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd010`,generator.x+1.97100100,generator.y+6.50082400,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd011`,generator.x+1.90181300,generator.y+6.55381400,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd012`,generator.x+1.81217900,generator.y+6.56836200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd013`,generator.x+1.72014100,generator.y+6.54205000,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd014`,generator.x+1.64590600,generator.y+6.47087100,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd015`,generator.x+1.61379000,generator.y+6.36883200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd016`,generator.x+1.62891000,generator.y+6.25810100,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd017`,generator.x+1.69617000,generator.y+6.16635900,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd018`,generator.x+1.80279100,generator.y+6.11314600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd019`,generator.x+1.92696300,generator.y+6.11514100,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd020`,generator.x+2.04181100,generator.y+6.17349800,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd021`,generator.x+2.12081100,generator.y+6.28245600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd022`,generator.x+2.14047900,generator.y+6.41642200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd023`,generator.x+2.09283800,generator.y+6.55434200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd024`,generator.x+1.98836000,generator.y+6.65625400,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd025`,generator.x+1.84142900,generator.y+6.70009800,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd026`,generator.x+1.68961500,generator.y+6.67540200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd027`,generator.x+1.56111200,generator.y+6.57634700,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd028`,generator.x+1.48924500,generator.y+6.42581500,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd029`,generator.x+1.49306700,generator.y+6.25427400,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd030`,generator.x+1.57488200,generator.y+6.10241900,generator.z+4.76513900,false,false,false)

	CreateObject(`prop_kettle_01`,generator.x+14.70269000,generator.y+5.80536400,generator.z+1.49509300,false,false,false)
	CreateObject(`v_res_mchopboard`,generator.x+14.36221000,generator.y+6.14473800,generator.z+1.44332300,false,false,false)
	CreateObject(`v_res_ovenhobmod`,generator.x+11.64079000,generator.y+9.26502400,generator.z+0.53966500,false,false,false)
	CreateObject(`v_res_mcofcupdirt`,generator.x+9.42801900,generator.y+6.43112200,generator.z+1.35738400,false,false,false)
	local chair3 = CreateObject(`v_res_kitchnstool`,generator.x+8.80919000,generator.y+6.47474700,generator.z+0.44114000,false,false,false)
	SetEntityHeading(chair3,GetEntityHeading(chair3)+90)
	local chair2 = CreateObject(`v_res_kitchnstool`,generator.x+10.91919000,generator.y+5.77998600,generator.z+0.44114000,false,false,false)
	SetEntityHeading(chair2,GetEntityHeading(chair2)-180)
	CreateObject(`v_res_mcofcupdirt`,generator.x+11.34266000,generator.y+6.24398800,generator.z+1.35738300,false,false,false)
	CreateObject(`v_res_cherubvase`,generator.x+14.63630000,generator.y+5.11709100,generator.z+3.49411800,false,false,false)
	local chalk2 = CreateObject(`v_res_mchalkbrd`,generator.x+13.66986000,generator.y+4.39613200,generator.z+1.55808300,false,false,false)
	SetEntityHeading(chalk2,GetEntityHeading(chalk2)-180)
	CreateObject(`V_44_G_Kitche_Deta`,generator.x+10.46560000,generator.y+5.93617800,generator.z+0.45652500,false,false,false)
	CreateObject(`V_44_Kitche_Units`,generator.x+8.25900000,generator.y+8.95200000,generator.z+0.46638600,false,false,false)
	CreateObject(`V_44_G_Kitche_Deca`,generator.x+10.32270000,generator.y+6.99725600,generator.z+0.19062300,false,false,false)
	CreateObject(`v_ilev_mm_fridge_r`,generator.x+8.25900000,generator.y+8.95199800,generator.z+0.60638600,false,false,false)
	CreateObject(`v_ilev_mm_fridge_l`,generator.x+6.88500100,generator.y+8.95199800,generator.z+0.60638600,false,false,false)
	local fau = CreateObject(`v_ilev_mm_faucet`,generator.x+14.71225000,generator.y+7.05411800,generator.z+1.44085800,false,false,false)
	SetEntityHeading(fau,GetEntityHeading(fau)-90)
	CreateObject(`v_res_ovenhobmod`,generator.x+10.74079000,generator.y+9.26502400,generator.z+0.53966500,false,false,false)
	CreateObject(`V_44_kitc_chand`,generator.x+10.41700000,generator.y+6.60862900,generator.z+3.18510400,false,false,false)

	CreateObject(`v_res_mcofcup`,generator.x+14.45970000,generator.y+9.07571200,generator.z+2.24126100,false,false,false)
	CreateObject(`v_res_mcofcup`,generator.x+14.54827000,generator.y+8.99532900,generator.z+2.24126100,false,false,false)
	CreateObject(`v_res_mcofcup`,generator.x+14.71489000,generator.y+9.00675800,generator.z+2.24126100,false,false,false)
	CreateObject(`v_res_mcofcup`,generator.x+14.83611000,generator.y+9.04519500,generator.z+2.24126100,false,false,false)

	CreateObject(`v_res_mmug`,generator.x+14.78669000,generator.y+9.03503600,generator.z+2.87347100,false,false,false)
	CreateObject(`v_res_mmug`,generator.x+14.63922000,generator.y+9.06091500,generator.z+2.87347100,false,false,false)
	CreateObject(`v_res_mmug`,generator.x+14.43891000,generator.y+9.05505500,generator.z+2.87347100,false,false,false)
	CreateObject(`v_res_mmug`,generator.x+14.42877000,generator.y+9.11096400,generator.z+2.55747100,false,false,false)
	CreateObject(`v_res_mmug`,generator.x+14.54221000,generator.y+9.00290800,generator.z+2.55747100,false,false,false)
	CreateObject(`v_res_mmug`,generator.x+14.68125000,generator.y+9.04880700,generator.z+2.55747100,false,false,false)
	CreateObject(`v_res_mmug`,generator.x+14.81833000,generator.y+9.06052600,generator.z+2.55747100,false,false,false)

	CreateObject(`v_res_mcofcup`,generator.x+14.75149000,generator.y+9.12099900,generator.z+2.24126100,false,false,false)
	CreateObject(`v_res_mcofcup`,generator.x+14.60091000,generator.y+9.11538300,generator.z+2.24126100,false,false,false)
	CreateObject(`v_res_bowl_dec`,generator.x+14.60194000,generator.y+5.59344000,generator.z+3.49420900,false,false,false)
	CreateObject(`prop_coffee_mac_02`,generator.x+14.66308000,generator.y+8.61713000,generator.z+1.68848500,false,false,false)
	CreateObject(`v_res_r_sugarbowl`,generator.x+14.78637000,generator.y+8.41123000,generator.z+1.44060400,false,false,false)
	CreateObject(`v_res_r_coffpot`,generator.x+14.53064000,generator.y+8.37244600,generator.z+1.44111000,false,false,false)
	local util = CreateObject(`v_res_mutensils`,generator.x+10.18923000,generator.y+9.27150500,generator.z+1.64567300,false,false,false)
	SetEntityHeading(util,GetEntityHeading(util)+90)

	CreateObject(`v_res_mkniferack`,generator.x+14.88481000,generator.y+5.59870400,generator.z+1.66517100,false,false,false)
	CreateObject(`v_res_r_pepppot`,generator.x+10.19567000,generator.y+9.20170600,generator.z+1.43884000,false,false,false)
	CreateObject(`v_res_r_pepppot`,generator.x+10.19869000,generator.y+9.06467400,generator.z+1.43884000,false,false,false)
	CreateObject(`v_res_cherubvase`,generator.x+14.64228000,generator.y+9.01812800,generator.z+3.49411800,false,false,false)

	CreateObject(`v_res_mpotpouri`,generator.x+14.55577000,generator.y+8.50598100,generator.z+3.49411800,false,false,false)
	local util2 = CreateObject(`v_res_mutensils`,generator.x+12.18506000,generator.y+9.27150500,generator.z+1.64567300,false,false,false)
	SetEntityHeading(util2,GetEntityHeading(util2)+90)
	CreateObject(`prop_micro_02`,generator.x+6.14397200,generator.y+9.10795800,generator.z+1.48797600,false,false,false)
	CreateObject(`prop_lime_jar`,generator.x+10.82650000,generator.y+6.78537100,generator.z+1.39791000,false,false,false)
	CreateObject(`prop_copper_pan`,generator.x+11.08923000,generator.y+9.36298200,generator.z+1.46961000,false,false,false)
	CreateObject(`prop_kitch_juicer`,generator.x+5.87455900,generator.y+7.72984300,generator.z+1.52251400,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+5.88074500,generator.y+7.55808400,generator.z+1.44086000,false,false,false)
	local chalk = CreateObject(`v_ilev_mchalkbrd_1`,generator.x+13.67297000,generator.y+4.37304300,generator.z+1.71720500,false,false,false)
	SetEntityHeading(chalk,GetEntityHeading(chalk)-180)
	CreateObject(`prop_metalfoodjar_01`,generator.x+14.50831000,generator.y+4.53625300,generator.z+2.24113200,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+14.50855000,generator.y+4.55157300,generator.z+2.55713100,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+14.49850000,generator.y+4.54775800,generator.z+2.87313100,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+14.66818000,generator.y+4.56423800,generator.z+2.87313100,false,false,false)

	CreateObject(`v_res_m_pot1`,generator.x+14.61287000,generator.y+4.86072500,generator.z+3.49455900,false,false,false)
	CreateObject(`v_res_m_pot1`,generator.x+14.65746000,generator.y+8.76475400,generator.z+3.49455900,false,false,false)
	CreateObject(`v_ilev_mm_fridgeint`,generator.x+7.57204700,generator.y+9.50173000,generator.z+1.59127800,false,false,false)
	CreateObject(`prop_cs_kitchen_cab_l`,generator.x+13.48880000,generator.y+9.39807700,generator.z+1.50317400,false,false,false)
	CreateObject(`prop_cs_kitchen_cab_r`,generator.x+9.14163700,generator.y+9.39807700,generator.z+1.50319300,false,false,false)
	CreateObject(`p_w_grass_gls_s`,generator.x+6.30300100,generator.y+8.03400000,generator.z+1.40800000,false,false,false)
	CreateObject(`v_res_mbronzvase`,generator.x+14.69197000,generator.y+9.00720200,generator.z+1.44086000,false,false,false)
	CreateObject(`v_res_mbronzvase`,generator.x+14.69197000,generator.y+4.55828000,generator.z+1.44086000,false,false,false)
	CreateObject(`v_med_smokealarm`,generator.x+12.91037000,generator.y+6.59943400,generator.z+4.12818200,false,false,false)
	CreateObject(`prop_foodprocess_01`,generator.x+5.95365100,generator.y+8.23214900,generator.z+1.44086000,false,false,false)
	CreateObject(`v_res_wall`,generator.x+9.48288900,generator.y+3.80587900,generator.z+0.49649800,false,false,false)



	CreateObject(`V_44_Kitche_Cables`,generator.x+15.13288000,generator.y+7.09520900,generator.z+2.93397100,false,false,false)

	CreateObject(`p_whiskey_bottle_s`,generator.x+9.76500100,generator.y+6.22099900,generator.z+1.49900000,false,false,false)
	CreateObject(`p_tumbler_cs2_s`,generator.x+9.51600000,generator.y+6.20100000,generator.z+1.40700000,false,false,false)
	CreateObject(`V_44_G_Kitche_Mirror`,generator.x+10.43927000,generator.y+6.61117700,generator.z+1.35984500,false,false,false)
	CreateObject(`V_44_Kitc_Emmi_Refl`,generator.x+14.88308000,generator.y+7.08548200,generator.z+1.71777900,false,false,false)

	CreateObject(`V_44_1_WC_Deta`,generator.x+1.17765600,generator.y-4.48131400,generator.z+4.63232000,false,false,false)
	CreateObject(`V_44_1_WC_Deca`,generator.x+1.59504700,generator.y-6.12709600,generator.z+4.63267900,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.70206260,generator.y-4.16378900,generator.z+5.71612900,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.68338590,generator.y-4.52617000,generator.z+5.71612900,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.72427940,generator.y-4.86893600,generator.z+5.71612900,false,false,false)
	CreateObject(`v_res_mbathpot`,generator.x+0.70345690,generator.y-4.35693900,generator.z+6.48056100,false,false,false)
	CreateObject(`v_res_glasspot`,generator.x+0.71698950,generator.y-4.14175200,generator.z+6.47866700,false,false,false)

	CreateObject(`v_res_mlaundry`,generator.x+0.76481630,generator.y-4.38597400,generator.z+4.68115500,false,false,false)
	CreateObject(`v_res_mbbin`,generator.x+0.77170370,generator.y-4.85373500,generator.z+4.68933400,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.71842000,generator.y-4.16739000,generator.z+6.09812900,false,false,false)
	CreateObject(`prop_toilet_shamp_02`,generator.x+0.68262770,generator.y-4.77760400,generator.z+6.60591400,false,false,false)
	CreateObject(`v_res_mpotpouri`,generator.x+0.72062970,generator.y-4.56955600,generator.z+6.47866700,false,false,false)

	CreateObject(`prop_toilet_shamp_02`,generator.x+0.78394590,generator.y-4.83148300,generator.z+6.60591400,false,false,false)
	CreateObject(`v_res_tissues`,generator.x+0.74644000,generator.y-4.58213100,generator.z+6.09788000,false,false,false)
	CreateObject(`v_res_fa_mag_rumor`,generator.x+0.71411900,generator.y-4.89627400,generator.z+6.19172800,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.70755580,generator.y-4.71013000,generator.z+5.40776400,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.70206260,generator.y-4.31527900,generator.z+5.40776400,false,false,false)
	CreateObject(`v_res_m_wctoiletroll`,generator.x+1.05170400,generator.y-7.98192900,generator.z+5.28550600,false,false,false)

	CreateObject(`V_44_1_WC_Wall`,generator.x+0.58679010,generator.y-5.92510000,generator.z+4.64117100,false,false,false)
	local sink = CreateObject(`v_res_m_sinkunit`,generator.x+0.57028010,generator.y-6.54750800,generator.z+4.57696100,false,false,false)
	SetEntityHeading(sink,GetEntityHeading(sink)+90)
	CreateObject(`v_res_mbathpot`,generator.x+0.44344710,generator.y-5.86374200,generator.z+5.41919400,false,false,false)
	CreateObject(`v_res_mbaccessory`,generator.x+0.44116590,generator.y-5.68478200,generator.z+5.40682800,false,false,false)

	CreateObject(`v_res_fashmag1`,generator.x+0.53466320,generator.y-7.69714400,generator.z+5.40757800,false,false,false)
	CreateObject(`v_res_mpotpouri`,generator.x+0.46240810,generator.y-7.37532400,generator.z+5.40551200,false,false,false)
	CreateObject(`prop_toilet_brush_01`,generator.x+0.89410590,generator.y-7.78916400,generator.z+4.55693300,false,false,false)
	CreateObject(`prop_toothpaste_01`,generator.x+0.62113380,generator.y-6.03470400,generator.z+5.39733200,false,false,false)
	CreateObject(`prop_toilet_shamp_02`,generator.x+0.37264820,generator.y-6.11828800,generator.z+5.53571800,false,false,false)
	CreateObject(`prop_toilet_shamp_02`,generator.x+0.34396170,generator.y-6.26275800,generator.z+5.53571800,false,false,false)
	local mirror = CreateObject(`v_ret_mirror`,generator.x+0.31381230,generator.y-6.52928800,generator.z+5.64878300,false,false,false)
	SetEntityHeading(mirror,GetEntityHeading(mirror)+90)
	CreateObject(`v_res_desklamp`,generator.x-1.65334600,generator.y-8.03860100,generator.z+5.37723000,false,false,false)
	CreateObject(`V_44_son_clutter`,generator.x-2.72426300,generator.y-4.61612700,generator.z+4.70186500,false,false,false)
	CreateObject(`V_44_1_Son_Deta`,generator.x-2.38526100,generator.y-4.51695800,generator.z+4.60237100,false,false,false)
	CreateObject(`prop_speaker_06`,generator.x-4.37202500,generator.y-3.15667900,generator.z+5.40821800,false,false,false)


	CreateObject(`V_44_1_Son_Deca`,generator.x-2.38558800,generator.y-4.51694800,generator.z+4.70213800,false,false,false)
	local bed = CreateObject(`v_res_msonbed`,generator.x-1.28441200,generator.y-4.80573900,generator.z+4.57700000,false,false,false)
	FreezeEntityPosition(bed,true)
	SetEntityHeading(bed,GetEntityHeading(bed)-90)
	CreateObject(`des_tvsmash`,generator.x-4.65294700,generator.y-3.06008700,generator.z+6.08225600,false,false,false)
	CreateObject(`v_res_fa_mag_motor`,generator.x-0.39596750,generator.y-6.14882800,generator.z+4.65708300,false,false,false)
	CreateObject(`v_res_m_lampstand`,generator.x-0.12011430,generator.y-6.15963500,generator.z+4.57726500,false,false,false)
	CreateObject(`v_res_tt_pizzaplate`,generator.x-0.72473050,generator.y-6.00035400,generator.z+4.58975600,false,false,false)
	CreateObject(`v_res_tt_can03`,generator.x-0.07454681,generator.y-3.55089300,generator.z+4.64916200,false,false,false)
	CreateObject(`v_res_tt_pizzaplate`,generator.x-2.14520900,generator.y-3.73351100,generator.z+4.58975600,false,false,false)
	CreateObject(`v_res_tt_can03`,generator.x-0.12168120,generator.y-3.84719700,generator.z+4.64916200,false,false,false)
	CreateObject(`v_res_tt_can03`,generator.x-3.68282300,generator.y-1.50274500,generator.z+4.64916200,false,false,false)
	CreateObject(`v_res_tt_pizzaplate`,generator.x-3.79727100,generator.y-1.68703200,generator.z+4.58975600,false,false,false)
	CreateObject(`v_res_tt_can03`,generator.x-0.35707760,generator.y-6.58195200,generator.z+4.64916200,false,false,false)
	CreateObject(`v_club_roc_gstand`,generator.x-0.24508670,generator.y-6.91720400,generator.z+4.57714300,false,false,false)
	CreateObject(`v_res_fashmag1`,generator.x-1.77334100,generator.y-3.80492700,generator.z+4.60178600,false,false,false)
	CreateObject(`v_res_tt_can03`,generator.x-0.10475160,generator.y-0.74553110,generator.z+4.64916200,false,false,false)
	CreateObject(`V_44_fakewindow6`,generator.x-5.33984800,generator.y-6.60726400,generator.z+4.74075300,false,false,false)
	CreateObject(`V_44_1_Daught_Deta`,generator.x+5.15501400,generator.y-4.61960500,generator.z+4.65251100,false,false,false)
	CreateObject(`v_res_tissues`,generator.x+4.23728100,generator.y-7.78753900,generator.z+5.57759400,false,false,false)
	CreateObject(`V_44_M_Daught_Over`,generator.x+5.06478200,generator.y-4.51694800,generator.z+4.65251100,false,false,false)

	CreateObject(`v_res_mbchair`,generator.x+4.34751900,generator.y-6.83495000,generator.z+4.57700000,false,false,false)
	CreateObject(`v_res_jewelbox`,generator.x+5.60166200,generator.y-7.84856600,generator.z+5.57709100,false,false,false)
	CreateObject(`v_res_m_candle`,generator.x+5.63198000,generator.y-8.10918900,generator.z+5.58055000,false,false,false)
	local dresser = CreateObject(`v_res_mddresser`,generator.x+4.96540800,generator.y-7.90087300,generator.z+4.57736500,false,false,false)
	FreezeEntityPosition(dresser,true)
	SetEntityHeading(dresser,GetEntityHeading(dresser)+180)
	CreateObject(`v_res_mdbedlamp`,generator.x+3.43900000,generator.y-3.66071800,generator.z+5.27747500,false,false,false)
	local bed2 = CreateObject(`v_res_mdbed`,generator.x+4.26333300,generator.y-5.19171000,generator.z+4.57726400,false,false,false)
	FreezeEntityPosition(bed2,true)
	SetEntityHeading(bed2,GetEntityHeading(bed2)+90)
	local desk = CreateObject(`v_res_mddesk`,generator.x+3.52612600,generator.y-6.93888700,generator.z+4.57726500,false,false,false)
	FreezeEntityPosition(desk,true)
	SetEntityHeading(desk,GetEntityHeading(desk)+90)
	CreateObject(`v_res_fa_mag_rumor`,generator.x+3.25719700,generator.y-7.18534500,generator.z+5.75928800,false,false,false)
	CreateObject(`v_res_tre_cushionc`,generator.x+3.74167700,generator.y-5.04673700,generator.z+5.23786200,false,false,false)
	CreateObject(`v_res_jcushionc`,generator.x+3.47843300,generator.y-5.44828800,generator.z+5.34760300,false,false,false)
	CreateObject(`V_44_1_Daught_Deta_ns`,generator.x+5.15501400,generator.y-4.61960500,generator.z+4.63951100,false,false,false)
	CreateObject(`v_res_d_dressdummy`,generator.x+3.80953400,generator.y-7.96329600,generator.z+4.57726400,false,false,false)
	CreateObject(`v_club_vu_drawer`,generator.x+6.33438800,generator.y-7.96820100,generator.z+4.57700000,false,false,false)
	local flat = CreateObject(`prop_tv_flat_03b`,generator.x+7.02415300,generator.y-5.41506100,generator.z+6.39180400,false,false,false)
	SetEntityHeading(flat,GetEntityHeading(flat)-90)


	CreateObject(`V_44_D_chand`,generator.x+4.94644200,generator.y-5.37181500,generator.z+7.03764900,false,false,false)
	CreateObject(`v_club_dress1`,generator.x+6.10717800,generator.y-1.56363600,generator.z+6.50635300,false,false,false)
	CreateObject(`v_res_m_candle`,generator.x+4.30049800,generator.y-8.10229200,generator.z+5.58055000,false,false,false)
	CreateObject(`v_res_fa_book04`,generator.x+3.78683400,generator.y-7.22723100,generator.z+5.48160700,false,false,false)
	CreateObject(`v_res_fa_book03`,generator.x+3.78421300,generator.y-7.26617900,generator.z+5.43769900,false,false,false)
	CreateObject(`V_44_fakewindow007`,generator.x+5.43454700,generator.y-6.13995100,generator.z+5.70870800,false,false,false)
	CreateObject(`v_res_mdbedtable`,generator.x+3.50600100,generator.y-3.73348200,generator.z+4.57736500,false,false,false)
	CreateObject(`V_44_D_emis`,generator.x+5.06478000,generator.y-4.51694400,generator.z+4.57726800,false,false,false)

	CreateObject(`V_44_1_Daught_GeomL`,generator.x+6.32631400,generator.y-4.70905700,generator.z+4.66521900,false,false,false)

	CreateObject(`V_44_1_Master_Deca`,generator.x-3.69378700,generator.y+6.42393100,generator.z+4.70213800,false,false,false)
	CreateObject(`v_res_tissues`,generator.x-0.70506190,generator.y+8.35398300,generator.z+5.41244700,false,false,false)
	CreateObject(`v_res_fa_book03`,generator.x-5.56946900,generator.y+9.12105200,generator.z+5.19722600,false,false,false)
	CreateObject(`v_res_fa_book04`,generator.x-5.54973200,generator.y+9.12014800,generator.z+5.15438000,false,false,false)
	CreateObject(`v_res_fa_book02`,generator.x-6.50122700,generator.y+9.17851300,generator.z+4.59468800,false,false,false)
	CreateObject(`v_res_fashmagopen`,generator.x-0.98937320,generator.y+8.10803400,generator.z+5.41998300,false,false,false)
	CreateObject(`v_res_fa_mag_motor`,generator.x-6.78904000,generator.y+9.23604700,generator.z+4.67064800,false,false,false)
	CreateObject(`v_res_r_bublbath`,generator.x-0.67247480,generator.y+7.95763200,generator.z+5.41998300,false,false,false)

	CreateObject(`V_44_1_Master_Deta`,generator.x-3.78856900,generator.y+5.11689300,generator.z+4.69215000,false,false,false)
	CreateObject(`des_frenchdoor`,generator.x-8.08411000,generator.y+6.35292000,generator.z+4.54623800,false,false,false)
	CreateObject(`v_res_m_bananaplant`,generator.x-7.02282700,generator.y+4.15889300,generator.z+4.07726500,false,false,false)
	CreateObject(`v_res_m_bananaplant`,generator.x-6.98458900,generator.y+8.58176000,generator.z+4.07726500,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x-2.88499400,generator.y+9.32790300,generator.z+5.13576900,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x-5.67367400,generator.y+9.32790300,generator.z+5.13576900,false,false,false)
	CreateObject(`v_res_m_l_chair1`,generator.x-1.71462300,generator.y+7.92522600,generator.z+4.57605400,false,false,false)

	local mirr =  CreateObject(`v_ret_mirror`,generator.x-0.53916740,generator.y+7.97935500,generator.z+5.45417000,false,false,false)
	SetEntityHeading(mirr,GetEntityHeading(mirr)-90)
	CreateObject(`v_res_mconsoletrad`,generator.x-3.59876400,generator.y+3.85237200,generator.z+4.57726500,false,false,false)
	CreateObject(`V_44_1_Master_Chan`,generator.x-4.28273200,generator.y+8.01677900,generator.z+7.52571900,false,false,false)
	CreateObject(`v_res_mplanttongue`,generator.x-2.54529100,generator.y+3.77437800,generator.z+4.57856000,false,false,false)
	CreateObject(`v_res_mplanttongue`,generator.x-4.65680100,generator.y+3.87188100,generator.z+4.57856000,false,false,false)
	CreateObject(`v_res_mpotpouri`,generator.x-3.01684700,generator.y+3.81856100,generator.z+5.57820200,false,false,false)
	CreateObject(`v_res_fa_candle04`,generator.x-3.19362500,generator.y+3.93352300,generator.z+5.65119800,false,false,false)
	CreateObject(`v_res_fa_candle04`,generator.x-3.34104000,generator.y+3.87041400,generator.z+5.65119800,false,false,false)
	CreateObject(`v_res_fa_candle04`,generator.x-4.03105700,generator.y+3.95793800,generator.z+5.65119800,false,false,false)
	local dres =  CreateObject(`v_res_mbdresser`,generator.x-0.85383890,generator.y+7.96966400,generator.z+4.57766400,false,false,false)
	FreezeEntityPosition(dres,true)
	SetEntityHeading(dres,GetEntityHeading(dres)-90)
	CreateObject(`v_res_d_lampa`,generator.x-0.79797650,generator.y+8.74071700,generator.z+5.41998300,false,false,false)
	CreateObject(`v_res_d_lampa`,generator.x-0.77069570,generator.y+7.17489800,generator.z+5.41998300,false,false,false)
	CreateObject(`v_res_mbbedtable`,generator.x-2.89582400,generator.y+9.22972300,generator.z+4.58609800,false,false,false)
	CreateObject(`v_res_mbbedtable`,generator.x-5.67645700,generator.y+9.23738900,generator.z+4.58609800,false,false,false)
	CreateObject(`v_res_fashmag1`,generator.x-6.43877000,generator.y+9.22318300,generator.z+4.61232700,false,false,false)
	CreateObject(`V_44_fakewindow5`,generator.x-4.23272900,generator.y+10.06902000,generator.z+6.88756600,false,false,false)
	CreateObject(`prop_d_balcony_l_light`,generator.x-8.07400100,generator.y+7.33400000,generator.z+5.98500000,false,false,false)
	CreateObject(`prop_d_balcony_r_light`,generator.x-8.07500100,generator.y+5.36899900,generator.z+5.98200100,false,false,false)
	local sofa3 = CreateObject(`v_res_m_h_sofa_sml`,generator.x-0.04692268,generator.y+4.91675800,generator.z+4.57255100,false,false,false)
	SetEntityHeading(sofa3,GetEntityHeading(sofa3)-90)
	FreezeEntityPosition(sofa3,true)
	CreateObject(`V_44_1_Master_Refl`,generator.x-2.24256700,generator.y+6.12810900,generator.z+7.40200100,false,false,false)
	local flat = CreateObject(`prop_tv_flat_michael`,generator.x-3.60332300,generator.y+3.59323500,generator.z+6.69362700,false,false,false)
	SetEntityHeading(flat,GetEntityHeading(flat)+180)

	CreateObject(`V_44_Dine_Deca`,generator.x+11.95362000,generator.y+1.21796200,generator.z+0.73423600,false,false,false)
	CreateObject(`v_res_m_dinetble`,generator.x+11.65958000,generator.y+1.48803700,generator.z+0.67128700,false,false,false)
	CreateObject(`v_res_m_palmplant1`,generator.x+14.03610000,generator.y+3.36004000,generator.z+0.1157600,false,false,false)
	CreateObject(`v_res_m_bananaplant`,generator.x+14.03464000,generator.y-0.53919510,generator.z+0.1157600,false,false,false)
	CreateObject(`v_res_m_palmplant1`,generator.x+9.87301400,generator.y-0.91560370,generator.z+0.1157600,false,false,false)
	local dChair = CreateObject(`v_ilev_m_dinechair`,generator.x+11.07593000,generator.y+2.15326300,generator.z+0.67300000,false,false,false)
	SetEntityHeading(dChair,GetEntityHeading(dChair)+40)
	local dChair2 = CreateObject(`v_ilev_m_dinechair`,generator.x+12.21606000,generator.y+1.99956100,generator.z+0.67300000,false,false,false)
	SetEntityHeading(dChair2,GetEntityHeading(dChair2)-60)
	local dChair3 = CreateObject(`v_ilev_m_dinechair`,generator.x+12.21671000,generator.y+0.96316720,generator.z+0.67300000,false,false,false)
	SetEntityHeading(dChair3,GetEntityHeading(dChair3)+210)
	local dChair4 = CreateObject(`v_ilev_m_dinechair`,generator.x+10.97966000,generator.y+1.02813000,generator.z+0.67300000,false,false,false)
	SetEntityHeading(dChair4,GetEntityHeading(dChair4)+130)
	CreateObject(`V_44_Dine_Deta`,generator.x+12.00919000,generator.y+1.16270300,generator.z+0.49488500,false,false,false)

	CreateObject(`V_44_Dine_Detail`,generator.x+11.95362000,generator.y+1.21796200,generator.z+2.53423600,false,false,false)
	CreateObject(`V_44_G_Fron_Deta`,generator.x-6.02225700,generator.y+6.81935900,generator.z+0.12220800,false,false,false)
	CreateObject(`V_44_G_Fron_Deca`,generator.x-6.02163100,generator.y+6.55411300,generator.z+0.12220900,false,false,false)
	CreateObject(`v_res_m_bananaplant`,generator.x-6.39008700,generator.y+8.55775700,generator.z-0.39999999,false,false,false)
	CreateObject(`v_res_m_h_sofa`,generator.x-4.16015100,generator.y+9.05558000,generator.z-0.00826600,false,false,false)
	CreateObject(`v_res_mconsoletrad`,generator.x-6.08591400,generator.y+4.25902900,generator.z-0.01249600,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x-6.57136300,generator.y+4.19632500,generator.z+0.98873800,false,false,false)
	CreateObject(`v_res_m_statue`,generator.x-5.90549600,generator.y+4.21699500,generator.z+1.00457700,false,false,false)
	CreateObject(`v_res_mconsoletrad`,generator.x-2.32082600,generator.y+4.25408500,generator.z-0.01249600,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x-1.79376400,generator.y+4.19632500,generator.z+0.98873800,false,false,false)
	CreateObject(`v_res_m_horsefig`,generator.x-2.26889200,generator.y+4.23528100,generator.z+0.98709510,false,false,false)
	CreateObject(`v_res_rosevase`,generator.x-2.92113700,generator.y+4.18977400,generator.z+0.98873800,false,false,false)
	CreateObject(`v_med_smokealarm`,generator.x-2.08868800,generator.y+6.37618500,generator.z+4.25485000,false,false,false)
	CreateObject(`v_res_exoticvase`,generator.x-4.24948700,generator.y+3.70693700,generator.z+1.08849900,false,false,false)
	CreateObject(`v_res_picture_frame`,generator.x-4.14919900,generator.y+9.59165000,generator.z+1.83966000,false,false,false)

	CreateObject(`V_44_G_Fron_Refl`,generator.x-4.58479900,generator.y+6.54761000,generator.z+3.05482600,false,false,false)
	CreateObject(`v_res_mlaundry`,generator.x-4.80988900,generator.y+0.47404100,generator.z+4.57726400,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144300,generator.y+0.43847470,generator.z+4.67645100,false,false,false)
	CreateObject(`v_res_mbbin`,generator.x-4.24965800,generator.y+2.95531300,generator.z+4.57726400,false,false,false)
	CreateObject(`V_44_1_Master_Ward`,generator.x-6.40655500,generator.y+1.73388900,generator.z+4.57834600,false,false,false)
	CreateObject(`V_44_1_Master_WCha`,generator.x-4.09320100,generator.y+1.72192600,generator.z+7.00458700,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144300,generator.y+0.43847470,generator.z+4.79156300,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144200,generator.y+0.43847560,generator.z+5.41287100,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144200,generator.y+0.43847560,generator.z+5.29775800,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144300,generator.y+0.43847470,generator.z+4.91203100,false,false,false)

	CreateObject(`v_res_mpotpouri`,generator.x-4.29746100,generator.y+0.48316380,generator.z+5.89753800,false,false,false)
	CreateObject(`prop_toilet_shamp_02`,generator.x-4.48238100,generator.y+0.62180140,generator.z+6.02429700,false,false,false)
	CreateObject(`prop_toilet_shamp_02`,generator.x-4.48615000,generator.y+0.49110990,generator.z+6.02429700,false,false,false)
	CreateObject(`v_res_mbathpot`,generator.x-2.87927600,generator.y+1.44019500,generator.z+6.19828700,false,false,false)
	CreateObject(`v_res_glasspot`,generator.x-2.94354800,generator.y+1.24733200,generator.z+6.19828700,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144300,generator.y+0.41808890,generator.z+5.02752500,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144200,generator.y+0.42529200,generator.z+5.52627400,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.35752500,generator.y+0.42529200,generator.z+5.64102000,false,false,false)
	CreateObject(`v_club_dress1`,generator.x-3.17459400,generator.y+2.65436600,generator.z+6.60635300,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34182500,generator.y+0.43845940,generator.z+6.61331000,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34182500,generator.y+0.43845940,generator.z+6.49819700,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34067500,generator.y+0.42532540,generator.z+6.72671200,false,false,false)
	CreateObject(`v_res_jewelbox`,generator.x-2.88840100,generator.y+1.73250300,generator.z+6.19802900,false,false,false)
	CreateObject(`v_ret_box`,generator.x-2.89328200,generator.y+2.04067000,generator.z+6.19828700,false,false,false)

	CreateObject(`V_44_1_Mast_WaDeca`,generator.x-5.12681000,generator.y+1.68215100,generator.z+4.53070600,false,false,false)
	local sofa5 = CreateObject(`v_res_m_h_sofa_sml`,generator.x-7.23159200,generator.y+1.74248200,generator.z+4.57207500,false,false,false)
	SetEntityHeading(sofa5,GetEntityHeading(sofa5)+90)
	FreezeEntityPosition(sofa5,true)
	CreateObject(`v_ret_ps_bag_01`,generator.x-3.61668600,generator.y+3.13254600,generator.z+4.99871100,false,false,false)
	CreateObject(`v_ret_ps_toiletbag`,generator.x-2.76861400,generator.y+1.39369200,generator.z+5.89606400,false,false,false)
	CreateObject(`v_ret_ps_box_01`,generator.x-2.97353500,generator.y+1.29670200,generator.z+5.89606400,false,false,false)
	CreateObject(`V_44_1_Master_WRefl`,generator.x-4.09332200,generator.y+1.72202400,generator.z+7.60138100,false,false,false)
	CreateObject(`v_ret_ps_bag_01`,generator.x-3.01495300,generator.y+0.96563630,generator.z+6.19942300,false,false,false)
	CreateObject(`v_ret_ps_toiletbag`,generator.x-3.46218600,generator.y+0.41771320,generator.z+6.19835800,false,false,false)
	CreateObject(`v_res_mbathpot`,generator.x-3.90824200,generator.y+0.45705510,generator.z+6.19828700,false,false,false)
	CreateObject(`v_ret_ps_cologne_01`,generator.x-3.73762700,generator.y+0.33720970,generator.z+6.19861200,false,false,false)
	CreateObject(`v_ret_ps_cologne`,generator.x-3.71301800,generator.y+0.51087090,generator.z+6.19861200,false,false,false)
	CreateObject(`v_ret_ps_toiletry_02`,generator.x-3.57097800,generator.y+0.58250620,generator.z+6.19861200,false,false,false)
	CreateObject(`V_44_1_Hall2_Deca`,generator.x+1.57198900,generator.y-2.18456100,generator.z+4.65403500,false,false,false)
	CreateObject(`V_44_1_Hall2_Deta`,generator.x+1.56736800,generator.y-2.06291400,generator.z+4.65576400,false,false,false)
	CreateObject(`V_44_1_Hall2_Emis`,generator.x+1.56687600,generator.y-2.20749900,generator.z+4.60605400,false,false,false)


	CreateObject(`v_ilev_mm_windowwc`,generator.x+1.62417000,generator.y-8.63196500,generator.z+5.1711000,false,false,false)
	CreateObject(`prop_laptop_01a`,generator.x+3.56317100,generator.y-6.85662900,generator.z+5.42643200,false,false,false)
	CreateObject(`Prop_MP3_Dock`,generator.x+6.60110600,generator.y-5.41524300,generator.z+5.74843500,false,false,false)
	CreateObject(`V_44_1_Daught_CDoor`,generator.x+6.38870800,generator.y-2.07008200,generator.z+4.67503500,false,false,false)
	CreateObject(`V_44_1_Daught_Item`,generator.x+5.15501400,generator.y-4.61960500,generator.z+4.70251100,false,false,false)
	CreateObject(`V_44_D_Items_Over`,generator.x+5.06478200,generator.y-4.51694800,generator.z+4.70226800,false,false,false)
	CreateObject(`v_club_brush`,generator.x+5.27156900,generator.y-7.82374500,generator.z+5.57799900,false,false,false)
	CreateObject(`v_club_comb`,generator.x+5.33156700,generator.y-7.92099000,generator.z+5.57799900,false,false,false)
	CreateObject(`v_club_roc_jacket1`,generator.x+5.99520300,generator.y-1.56453200,generator.z+6.49564800,false,false,false)
	CreateObject(`v_club_skirtflare`,generator.x+6.23020200,generator.y-1.56066700,generator.z+6.50772100,false,false,false)
	CreateObject(`v_club_skirtplt`,generator.x+6.15445000,generator.y-1.56480200,generator.z+6.51050600,false,false,false)
	CreateObject(`v_club_slip`,generator.x+6.51164300,generator.y-1.56346100,generator.z+6.50603100,false,false,false)
	CreateObject(`v_club_vu_bear`,generator.x+3.24126400,generator.y-6.64180100,generator.z+5.66661100,false,false,false)
	CreateObject(`v_club_vuhairdryer`,generator.x+4.60364600,generator.y-7.89662200,generator.z+4.57700000,false,false,false)
	CreateObject(`v_club_vumakeupbrsh`,generator.x+4.74676800,generator.y-7.83952300,generator.z+5.57799900,false,false,false)
	CreateObject(`v_club_vutongs`,generator.x+4.69820500,generator.y-7.88481200,generator.z+5.58364700,false,false,false)
	CreateObject(`v_club_vuvanity`,generator.x+6.33217200,generator.y-7.98365200,generator.z+5.50917400,false,false,false)
	CreateObject(`v_res_mbathpot`,generator.x+4.93267800,generator.y-8.07459300,generator.z+5.61459300,false,false,false)
	local chest =  CreateObject(`v_res_mdchest`,generator.x+6.66236100,generator.y-5.40825500,generator.z+4.57736500,false,false,false)
	SetEntityHeading(chest,GetEntityHeading(chest)-90)
	FreezeEntityPosition(chest,true)
	CreateObject(`v_res_r_bublbath`,generator.x+5.07845400,generator.y-8.04203800,generator.z+5.57799900,false,false,false)
	CreateObject(`v_res_r_perfume`,generator.x+4.75592900,generator.y-8.10680400,generator.z+5.57799900,false,false,false)
	CreateObject(`v_ret_box`,generator.x+3.56020000,generator.y-3.48869900,generator.z+5.27409700,false,false,false)

	CreateObject(`V_44_G_Cor_Blen`,generator.x+4.49310600,generator.y+8.63649000,generator.z+0.24844800,false,false,false)
	CreateObject(`V_44_G_Cor_Deta`,generator.x+4.49310600,generator.y+8.63649000,generator.z+0.24844800,false,false,false)
	CreateObject(`V_44_Garage_Shell`,generator.x+0.79177808,generator.y+13.23049000,generator.z+0.24844800,false,false,false)
	local shelf = CreateObject(`V_44_1_Mast_WaShel_M`,generator.x-3.78199100,generator.y+1.73383800,generator.z+4.57161100,false,false,false)
	FreezeEntityPosition(shelf,true)

	if not DoesEntityExist(safe) and safehouse and math.random(100) > 90 then
		CreateSafe(generator.x-4.22426300,generator.y-4.61612700,generator.z+4.70186500)
	end

	if not DoesEntityExist(safe) and safehouse and math.random(100) > 70 then
		CreateSafe(generator.x-2.89582400,generator.y+8.22972300,generator.z+4.68609800)
	end

	if not DoesEntityExist(safe) and safehouse and math.random(100) > 10 then
		CreateSafe(generator.x-5.89582400,generator.y+1.22972300,generator.z+4.68609800)
		SetEntityHeading(safe,GetEntityHeading(safe)-180)
	end

	FreezeRobberyApartment()
	FreezeEntityPosition(building,true)
	FreezeEntityPosition(building2,true)
	FreezeEntityPosition(PlayerPedId(),false)
	SetEntityHeading(PlayerPedId(),267.0)
	SetGameplayCamRelativeHeading(0.0)
end

function buildShopRob(id,firstin)
	local network = false;


    SetEntityCoords(PlayerPedId(),9000.0,0.0,110.0)
    
    Citizen.Wait(1000)

	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 124.0}

	SetEntityCoords(PlayerPedId(),generator.x+3, generator.y-4, generator.z+90.0)
	FreezeEntityPosition(PlayerPedId(),true)
	Citizen.Wait(1000)
    local building = CreateObject(`v_shop_gc_shell`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local wall = CreateObject(`v_shop_gcpartwall`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local stuff = CreateObject(`v_shop_backrmstuff`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass1 = CreateObject(`v_shop_glass01`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass2 = CreateObject(`v_shop_glass02`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass3 = CreateObject(`v_shop_glass03`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass4 = CreateObject(`v_shop_glass04`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass5 = CreateObject(`v_shop_glass05`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass6 = CreateObject(`v_shop_glass06`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass7 = CreateObject(`v_shop_glass07`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass8 = CreateObject(`v_shop_glass08`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass9 = CreateObject(`v_shop_glass10`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass10 = CreateObject(`v_shop_glass11`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass11 = CreateObject(`v_shop_glass12`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass12 = CreateObject(`v_shop_glass13`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local glass13 = CreateObject(`v_shop_glass14`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local guns = CreateObject(`v_shop_handguns`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local post = CreateObject(`v_shop_officepost`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local shad = CreateObject(`v_shop_officeshad`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local stuff2 = CreateObject(`v_shop_officestuff`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local stuff3 = CreateObject(`v_shop_officestuff2`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local shadowshop = CreateObject(`v_shop_shadowshop`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local shirts = CreateObject(`v_shop_shirts`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local posters = CreateObject(`v_shop_shopposters`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local shadowshop2 = CreateObject(`v_shop_shopshadow`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local skirt = CreateObject(`v_shop_shopskirt`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local skirting = CreateObject(`v_shop_skirting`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local vents1 = CreateObject(`v_shop_vents01`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local vents2 = CreateObject(`v_shop_vents02`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local edges = CreateObject(`v_shop_walledges`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local wallguns = CreateObject(`v_shop_wallguns`, generator.x, generator.y, generator.z, network and network or false, false, false)
    local wallhooks = CreateObject(`v_shop_wallhooks`, generator.x, generator.y, generator.z, network and network or false, false, false)

     FreezeEntityPosition(building,true)
   	 Citizen.Wait(100)
     SetEntityCoords(PlayerPedId(),generator.x+3, generator.y-4, generator.z+90.0)
     FreezeEntityPosition(PlayerPedId(),false)
     SetEntityHeading(PlayerPedId(),0.0)

end



function buildHouseRob(id,firstin) 


	SetEntityCoords(PlayerPedId(),347.04724121094,-1000.2844848633,-99.194671630859)
	FreezeEntityPosition(PlayerPedId(),true)
	Citizen.Wait(3000)

	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 24.0}



	if enterback then
		SetEntityCoords(PlayerPedId(), generator.x-3.8 , generator.y+5.2, generator.z+2.9)
	else
		SetEntityCoords(PlayerPedId(), generator.x+4.5 , generator.y-14, generator.z+2.9)
	end
	local shelves = CreateObject(`v_16_midapttex`,generator.x+3.04164100,generator.y+0.31671810,generator.z+3.58363900,false,false,false)
	local building = CreateObject(`playerhouse_tier1`,generator.x-0.01854400,generator.y-0.01389600,generator.z+-0.08068600,false,false,false)
	FreezeEntityPosition(building,true)
	Citizen.Wait(100)
	FloatTilSafeR(building)
	Citizen.Wait(500)
	SetEntityCoords(PlayerPedId(), generator.x+4.5 , generator.y-14, generator.z+2.9)

	local dt = CreateObject(`V_16_DT`,generator.x-1.21854400,generator.y-1.04389600,generator.z+1.39068600,false,false,false)
	local mpmid01 = CreateObject(`V_16_mpmidapart01`,generator.x+0.52447510,generator.y-5.04953700,generator.z+1.32,false,false,false)
	local mpmid09 = CreateObject(`V_16_mpmidapart09`,generator.x+0.82202150,generator.y+2.29612000,generator.z+1.88,false,false,false)
	local mpmid07 = CreateObject(`V_16_mpmidapart07`,generator.x-1.91445900,generator.y-6.61911300,generator.z+1.45,false,false,false)
	local mpmid03 = CreateObject(`V_16_mpmidapart03`,generator.x-4.82565300,generator.y-6.86803900,generator.z+1.14,false,false,false)
	local midData = CreateObject(`V_16_midapartdeta`,generator.x+2.28558400,generator.y-1.94082100,generator.z+1.32,false,false,false)
	local glow = CreateObject(`V_16_treeglow`,generator.x-1.37408500,generator.y-0.95420070,generator.z+1.135,false,false,false)
	local curtins = CreateObject(`V_16_midapt_curts`,generator.x-1.96423300,generator.y-0.95958710,generator.z+1.280,false,false,false)
	local mpmid13 = CreateObject(`V_16_mpmidapart13`,generator.x-4.65580700,generator.y-6.61684000,generator.z+1.259,false,false,false)
	local mpcab = CreateObject(`V_16_midapt_cabinet`,generator.x-1.16177400,generator.y-0.97333810,generator.z+1.27,false,false,false)
	local mpdecal = CreateObject(`V_16_midapt_deca`,generator.x+2.311386000,generator.y-2.05385900,generator.z+1.297,false,false,false)
	local mpdelta = CreateObject(`V_16_mid_hall_mesh_delta`,generator.x+3.69693000,generator.y-5.80020100,generator.z+1.293,false,false,false)
	local beddelta = CreateObject(`V_16_mid_bed_delta`,generator.x+7.95187400,generator.y+1.04246500,generator.z+1.28402300,false,false,false)
	local bed = CreateObject(`V_16_mid_bed_bed`,generator.x+6.86376900,generator.y+1.20651200,generator.z+1.36589100,false,false,false)
	local beddecal = CreateObject(`V_16_MID_bed_over_decal`,generator.x+7.82861300,generator.y+1.04696700,generator.z+1.34753700,false,false,false)
	local bathDelta = CreateObject(`V_16_mid_bath_mesh_delta`,generator.x+4.45460500,generator.y+3.21322800,generator.z+1.21116100,false,false,false)
	local bathmirror = CreateObject(`V_16_mid_bath_mesh_mirror`,generator.x+3.57740800,generator.y+3.25032000,generator.z+1.48871300,false,false,false)

	--props
	local beerbot = CreateObject(`Prop_CS_Beer_Bot_01`,generator.x+1.73134600,generator.y-4.88520200,generator.z+1.91083000,false,false,false)
	local couch = CreateObject(`v_res_mp_sofa`,generator.x-1.48765600,generator.y+1.68100600,generator.z+1.21640500,false,false,false)
	local chair = CreateObject(`v_res_mp_stripchair`,generator.x-4.44770800,generator.y-1.78048800,generator.z+1.21640500,false,false,false)
	local chair2 = CreateObject(`v_res_tre_chair`,generator.x+2.91325400,generator.y-5.27835100,generator.z+1.22746400,false,false,false)
	local plant = CreateObject(`Prop_Plant_Int_04a`,generator.x+2.78941300,generator.y-4.39133900,generator.z+2.12746400,false,false,false)
	local lamp = CreateObject(`v_res_d_lampa`,generator.x-3.61473100,generator.y-6.61465100,generator.z+2.08382800,false,false,false)
	local fridge = CreateObject(`v_res_fridgemodsml`,generator.x+1.90339700,generator.y-3.80026800,generator.z+1.29917900,false,false,false)
	local micro = CreateObject(`prop_micro_01`,generator.x+2.03442400,generator.y-4.61585100,generator.z+2.30395600,false,false,false)
	local sideBoard = CreateObject(`V_Res_Tre_SideBoard`,generator.x+2.84053000,generator.y-4.30947100,generator.z+1.24577300,false,false,false)
	local bedSide = CreateObject(`V_Res_Tre_BedSideTable`,generator.x-3.50363200,generator.y-6.55289400,generator.z+1.30625800,false,false,false)
	local lamp2 = CreateObject(`v_res_d_lampa`,generator.x+2.69674700,generator.y-3.83123500,generator.z+2.09373700,false,false,false)
	local plant2 = CreateObject(`v_res_tre_tree`,generator.x-4.96064800,generator.y-6.09898500,generator.z+1.31631400,false,false,false)
	local table = CreateObject(`V_Res_M_DineTble_replace`,generator.x-3.50712600,generator.y-4.13621600,generator.z+1.29625800,false,false,false)
	local tv = CreateObject(`Prop_TV_Flat_01`,generator.x-5.53120400,generator.y+0.76299670,generator.z+2.17236000,false,false,false)
	local plant3 = CreateObject(`v_res_tre_plant`,generator.x-5.14112800,generator.y-2.78951000,generator.z+1.25950800,false,false,false)
	local chair3 = CreateObject(`v_res_m_dinechair`,generator.x-3.04652400,generator.y-4.95971200,generator.z+1.19625800,false,false,false)
	local lampStand = CreateObject(`v_res_m_lampstand`,generator.x+1.26588400,generator.y+3.68883900,generator.z+1.30556700,false,false,false)
	local stool = CreateObject(`V_Res_M_Stool_REPLACED`,generator.x-3.23216300,generator.y+2.06159000,generator.z+1.20556700,false,false,false)
	local chair4 = CreateObject(`v_res_m_dinechair`,generator.x-2.82237200,generator.y-3.59831300,generator.z+1.25950800,false,false,false)
	local chair5 = CreateObject(`v_res_m_dinechair`,generator.x-4.14955100,generator.y-4.71316600,generator.z+1.19625800,false,false,false)
	local chair6 = CreateObject(`v_res_m_dinechair`,generator.x-3.80622900,generator.y-3.37648300,generator.z+1.19625800,false,false,false)

	local plant4 = CreateObject(`v_res_fa_plant01`,generator.x+2.97859200,generator.y+2.55307400,generator.z+1.85796300,false,false,false)
	local storage = CreateObject(`v_res_tre_storageunit`,generator.x+8.47819500,generator.y-2.50979300,generator.z+1.19712300,false,false,false)
	local storage2 = CreateObject(`v_res_tre_storagebox`,generator.x+9.75982700,generator.y-1.35874100,generator.z+1.29625800,false,false,false)
	local basketmess = CreateObject(`v_res_tre_basketmess`,generator.x+8.70730600,generator.y-2.55503600,generator.z+1.94059590,false,false,false)
	local lampStand2 = CreateObject(`v_res_m_lampstand`,generator.x+9.54306000,generator.y-2.50427700,generator.z+1.30556700,false,false,false)
	local plant4 = CreateObject(`Prop_Plant_Int_03a`,generator.x+9.87521400,generator.y+3.90917400,generator.z+1.20829700,false,false,false)

	local basket = CreateObject(`v_res_tre_washbasket`,generator.x+9.39091500,generator.y+4.49676300,generator.z+1.19625800,false,false,false)
	local wardrobe = CreateObject(`V_Res_Tre_Wardrobe`,generator.x+8.46626300,generator.y+4.53223600,generator.z+1.19425800,false,false,false)
	local basket2 = CreateObject(`v_res_tre_flatbasket`,generator.x+8.51593000,generator.y+4.55647300,generator.z+3.46737300,false,false,false)
	local basket3 = CreateObject(`v_res_tre_basketmess`,generator.x+7.57797200,generator.y+4.55198800,generator.z+3.46737300,false,false,false)
	local basket4 = CreateObject(`v_res_tre_flatbasket`,generator.x+7.12286400,generator.y+4.54689200,generator.z+3.46737300,false,false,false)
	local wardrobe2 = CreateObject(`V_Res_Tre_Wardrobe`,generator.x+7.24382000,generator.y+4.53423500,generator.z+1.19625800,false,false,false)
	local basket5 = CreateObject(`v_res_tre_flatbasket`,generator.x+8.03364600,generator.y+4.54835500,generator.z+3.46737300,false,false,false)

	local switch = CreateObject(`v_serv_switch_2`,generator.x+6.28086900,generator.y-0.68169880,generator.z+2.30326000,false,false,false)

	local table2 = CreateObject(`V_Res_Tre_BedSideTable`,generator.x+5.84416200,generator.y+2.57377400,generator.z+1.22089100,false,false,false)
	local lamp3 = CreateObject(`v_res_d_lampa`,generator.x+5.84912100,generator.y+2.58001100,generator.z+1.95311890,false,false,false)
	local laundry = CreateObject(`v_res_mlaundry`,generator.x+5.77729800,generator.y+4.60211400,generator.z+1.19674400,false,false,false)

	local ashtray = CreateObject(`Prop_ashtray_01`,generator.x-1.24716200,generator.y+1.07820500,generator.z+1.89089300,false,false,false)

	local candle1 = CreateObject(`v_res_fa_candle03`,generator.x-2.89289900,generator.y-4.35329700,generator.z+2.02881310,false,false,false)
	local candle2 = CreateObject(`v_res_fa_candle02`,generator.x-3.99865700,generator.y-4.06048500,generator.z+2.02530190,false,false,false)
	local candle3 = CreateObject(`v_res_fa_candle01`,generator.x-3.37733400,generator.y-3.66639800,generator.z+2.02526200,false,false,false)
	local woodbowl = CreateObject(`v_res_m_woodbowl`,generator.x-3.50787400,generator.y-4.11983000,generator.z+2.02589900,false,false,false)
	local tablod = CreateObject(`V_Res_TabloidsA`,generator.x-0.80513000,generator.y+0.51389600,generator.z+1.18418800,false,false,false)


	local tapeplayer = CreateObject(`Prop_Tapeplayer_01`,generator.x-1.26010100,generator.y-3.62966400,generator.z+2.37883200,false,false,false)
	local woodbowl2 = CreateObject(`v_res_tre_fruitbowl`,generator.x+2.77764900,generator.y-4.138297000,generator.z+2.10340100,false,false,false)
	local sculpt = CreateObject(`v_res_sculpt_dec`,generator.x+3.03932200,generator.y+1.62726400,generator.z+3.58363900,false,false,false)
	local jewlry = CreateObject(`v_res_jewelbox`,generator.x+3.04164100,generator.y+0.31671810,generator.z+3.58363900,false,false,false)	

	local basket6 = CreateObject(`v_res_tre_basketmess`,generator.x-1.64906300,generator.y+1.62675900,generator.z+1.39038500,false,false,false)
	local basket7 = CreateObject(`v_res_tre_flatbasket`,generator.x-1.63938900,generator.y+0.91133310,generator.z+1.39038500,false,false,false)

	local basket8 = CreateObject(`v_res_tre_flatbasket`,generator.x-1.19923400,generator.y+1.69598600,generator.z+1.39038500,false,false,false)
	local basket9 = CreateObject(`v_res_tre_basketmess`,generator.x-1.18293800,generator.y+0.91436380,generator.z+1.39038500,false,false,false)
	local bowl = CreateObject(`v_res_r_sugarbowl`,generator.x-0.26029210,generator.y-6.66716800,generator.z+3.77324900,false,false,false)
	local breadbin = CreateObject(`Prop_Breadbin_01`,generator.x+2.09788500,generator.y-6.57634000,generator.z+2.24041900,false,false,false)
	local knifeblock = CreateObject(`v_res_mknifeblock`,generator.x+1.82084700,generator.y-6.58438500,generator.z+2.27399500,false,false,false)

	local toaster = CreateObject(`prop_toaster_01`,generator.x-1.05790700,generator.y-6.59017400,generator.z+2.26793200,false,false,false)
	local wok = CreateObject(`prop_wok`,generator.x+2.01728800,generator.y-5.57091500,generator.z+2.26793200,false,false,false)
	local plant5 = CreateObject(`Prop_Plant_Int_03a`,generator.x+2.55015600,generator.y+4.60183900,generator.z+1.20829700,false,false,false)

	local tumbler = CreateObject(`p_tumbler_cs2_s`,generator.x-0.90916440,generator.y-4.24099100,generator.z+2.26793200,false,false,false)
	local wisky = CreateObject(`p_whiskey_bottle_s`,generator.x-0.92809300,generator.y-3.99099100,generator.z+2.26793200,false,false,false)
	local tissue = CreateObject(`v_res_tissues`,generator.x+7.95889300,generator.y-2.54847100,generator.z+1.94013400,false,false,false)

	local pants = CreateObject(`V_16_Ap_Mid_Pants4`,generator.x+7.55366500,generator.y-0.25457100,generator.z+1.33009200,false,false,false)
	local pants2 = CreateObject(`V_16_Ap_Mid_Pants5`,generator.x+7.76753200,generator.y+3.00476500,generator.z+1.33052800,false,false,false)
	local hairdryer = CreateObject(`v_club_vuhairdryer`,generator.x+8.12616000,generator.y-2.50562000,generator.z+1.96009390,false,false,false)

	FreezeEntityPosition(shelves,true)
	FreezeEntityPosition(dt,true)
	FreezeEntityPosition(mpmid01,true)
	FreezeEntityPosition(mpmid09,true)
	FreezeEntityPosition(mpmid07,true)
	FreezeEntityPosition(mpmid03,true)
	FreezeEntityPosition(midData,true)
	FreezeEntityPosition(glow,true)
	FreezeEntityPosition(curtins,true)
	FreezeEntityPosition(mpmid13,true)
	FreezeEntityPosition(mpcab,true)
	FreezeEntityPosition(mpdecal,true)
	FreezeEntityPosition(mpdelta,true)
	FreezeEntityPosition(couch,true)
	FreezeEntityPosition(chair,true)
	FreezeEntityPosition(chair2,true)
	FreezeEntityPosition(plant,true)
	FreezeEntityPosition(lamp,true)
	FreezeEntityPosition(fridge,true)
	FreezeEntityPosition(micro,true)
	FreezeEntityPosition(sideBoard,true)
	FreezeEntityPosition(bedSide,true)
	FreezeEntityPosition(plant2,true)
	FreezeEntityPosition(table,true)
	FreezeEntityPosition(tv,true)
	FreezeEntityPosition(plant3,true)
	FreezeEntityPosition(chair3,true)
	FreezeEntityPosition(lampStand,true)
	FreezeEntityPosition(chair4,true)
	FreezeEntityPosition(chair5,true)
	FreezeEntityPosition(chair6,true)
	FreezeEntityPosition(plant4,true)
	FreezeEntityPosition(storage2,true)
	FreezeEntityPosition(basket,true)
	FreezeEntityPosition(wardrobe,true)
	FreezeEntityPosition(wardrobe2,true)
	FreezeEntityPosition(table2,true)
	FreezeEntityPosition(lamp3,true)
	FreezeEntityPosition(laundry,true)
	FreezeEntityPosition(beddelta,true)
	FreezeEntityPosition(bed,true)
	FreezeEntityPosition(beddecal,true)
	FreezeEntityPosition(tapeplayer,true)
	FreezeEntityPosition(basket7,true)
	FreezeEntityPosition(basket6,true)
	FreezeEntityPosition(basket8,true)
	FreezeEntityPosition(basket9,true)

	SetEntityHeading(beerbot,GetEntityHeading(beerbot)+90)
	SetEntityHeading(couch,GetEntityHeading(couch)-90)
	SetEntityHeading(chair,GetEntityHeading(chair)+getRotation(0.28045480))
	SetEntityHeading(chair2,GetEntityHeading(chair2)+getRotation(0.3276100))
	SetEntityHeading(fridge,GetEntityHeading(chair2)+160)
	SetEntityHeading(micro,GetEntityHeading(micro)-80)
	SetEntityHeading(sideBoard,GetEntityHeading(sideBoard)+90)
	SetEntityHeading(bedSide,GetEntityHeading(bedSide)+180)
	SetEntityHeading(tv,GetEntityHeading(tv)+90)
	SetEntityHeading(plant3,GetEntityHeading(plant3)+90)
	SetEntityHeading(chair3,GetEntityHeading(chair3)+200)
	SetEntityHeading(chair4,GetEntityHeading(chair3)+100)
	SetEntityHeading(chair5,GetEntityHeading(chair5)+135)
	SetEntityHeading(chair6,GetEntityHeading(chair6)+10)
	SetEntityHeading(storage,GetEntityHeading(storage)+180)
	SetEntityHeading(storage2,GetEntityHeading(storage2)-90)
	SetEntityHeading(table2,GetEntityHeading(table2)+90)
	SetEntityHeading(tapeplayer,GetEntityHeading(tapeplayer)+90)
	SetEntityHeading(knifeblock,GetEntityHeading(knifeblock)+180)

	if not DoesEntityExist(safe) and safehouse then
		CreateSafe(generator.x+6.4,generator.y+4.22972300,generator.z+1.18609800)
	end

	FreezeEntityPosition(PlayerPedId(),false)
	SetBlackout(true)
	if firstin then
		Citizen.Wait(1000)
		randomAI()
	end
	SetEntityHeading(PlayerPedId(),0.0)
	SetGameplayCamRelativeHeading(0.0)

end

function buildTrailer()
	trailer = true
	DoScreenFadeOut(100)

	while IsScreenFadingOut() do
		Citizen.Wait(10)
	end

	SetEntityCoords(PlayerPedId(), 1040.64, 2676.53, -150.61)
	FreezeEntityPosition(PlayerPedId(),true)

	RequestModel(`nopixel_trailer`)
	while not HasModelLoaded(`nopixel_trailer`)
	do
		Citizen.Wait(100)
	end

	local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 75.0}
	loadedShell = CreateObject(`nopixel_trailer`, generator.x, generator.y, generator.z, false, false, false)
	FreezeEntityPosition(loadedShell, true)
	
	FloatTilSafeR(loadedShell)
	
	SetEntityCoords(PlayerPedId(), generator.x - 1.443, generator.y - 1.892, generator.z+1.7)
	SetEntityHeading(PlayerPedId(), 359.00)
	FreezeEntityPosition(PlayerPedId(), false)
	DoScreenFadeIn(100)
	while IsScreenFadingIn()
	do
		Citizen.Wait(100)
	end
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

deathanims = {
    [1] = "dead_a",
    [2] = "dead_b",
    [3] = "dead_c",
    [4] = "dead_d",
    [5] = "dead_e",
    [6] = "dead_f",
    [7] = "dead_g",
    [8] = "dead_h",
}

function randomAI()

	local modelhash = `a_m_m_beach_02`

    RequestModel(modelhash)

    while not HasModelLoaded(modelhash) do
        Citizen.Wait(0)
    end

	local crafting = false
	if crafthouses[myhouseid] ~= nil then
		crafting = true
		TriggerEvent("DoLongHudText","You can craft guns in this property! [E]",19)
    end

    if moneyhouses[myhouseid] ~= nil then
    	crafting = true
        TriggerEvent("DoLongHudText","You can clean money in this property! [E]",19)
    end

    if not crafting then 
  
	    local generator = { x = curHouseCoords["x"] , y = curHouseCoords["y"], z = curHouseCoords["z"] - 24.0}
	    local airoll = math.random(2)

	    if airoll == 1 then

			local robberyped = CreatePed(GetPedType(modelhash), modelhash, generator.x+6.86376900,generator.y+1.20651200,generator.z+1.36589100, 15.0, 1, 1)
			DecorSetBool(robberyped, 'ScriptedPed', true)
			SetEntityCoords(robberyped,generator.x+6.86376900,generator.y+1.20651200,generator.z+1.36589100)
			SetEntityHeading(robberyped,80.0)

			local anim = deathanims[math.random(1,8)]
		    loadAnimDict( "dead" ) 
		    TaskPlayAnim( robberyped, "dead", anim, 100.0, 1.0, -1, 1, 0, 0, 0, 0 )

	    elseif airoll == 2 then

			local robberyped = CreatePed(GetPedType(modelhash), modelhash, generator.x+6.86376900,generator.y+1.20651200,generator.z+1.36589100, 15.0, 1, 1)
			DecorSetBool(robberyped, 'ScriptedPed', true)
			SetEntityCoords(robberyped,generator.x-1.48765600,generator.y+1.68100600,generator.z+1.21640500)
			SetEntityHeading(robberyped,190.0)

			local anim = deathanims[math.random(1,8)]
		    loadAnimDict( "dead" ) 
		    TaskPlayAnim( robberyped, "dead", anim, 100.0, 1.0, -1, 1, 0, 0, 0, 0 )

	    end
	end	

end

local customGPSlocations = {
  [1] = { ["x"] = 484.77066040039, ["y"] = -77.643089294434, ["z"] = 77.600166320801, ["info"] = "Garage A"},
  [2] = { ["x"] = -331.96115112305, ["y"] = -781.52337646484, ["z"] = 33.964477539063,  ["info"] = "Garage B"},
  [3] = { ["x"] = -451.37295532227, ["y"] = -794.06591796875, ["z"] = 30.543809890747, ["info"] = "Garage C"},
  [4] = { ["x"] = 399.51190185547, ["y"] = -1346.2742919922, ["z"] = 31.121940612793, ["info"] = "Garage D"},
  [5] = { ["x"] = 598.77319335938, ["y"] = 90.707237243652, ["z"] = 92.829048156738, ["info"] = "Garage E"},
  [6] = { ["x"] = 641.53442382813, ["y"] = 205.42562866211, ["z"] = 97.186958312988, ["info"] = "Garage F"},
  [7] = { ["x"] = 82.359413146973, ["y"] = 6418.9575195313, ["z"] = 31.479639053345, ["info"] = "Garage G"},
  [8] = { ["x"] = -794.578125, ["y"] = -2020.8499755859, ["z"] = 8.9431390762329, ["info"] = "Garage H"},
  [9] = { ["x"] = -669.15631103516, ["y"] = -2001.7552490234, ["z"] = 7.5395741462708, ["info"] = "Garage I"},
  [10] = { ["x"] = -606.86322021484, ["y"] = -2236.7624511719, ["z"] = 6.0779848098755, ["info"] = "Garage J"},
  [11] = { ["x"] = -166.60482788086, ["y"] = -2143.9333496094, ["z"] = 16.839847564697, ["info"] = "Garage K"},
  [12] = { ["x"] = -38.922565460205, ["y"] = -2097.2663574219, ["z"] = 16.704851150513, ["info"] = "Garage L"},
  [13] = { ["x"] = -70.179389953613, ["y"] = -2004.4139404297, ["z"] = 18.016941070557, ["info"] = "Garage M"},
  [14] = { ["x"] = 549.47796630859, ["y"] = -55.197559356689, ["z"] = 71.069190979004, ["info"] = "Garage Impound Lot"},
  [15] = { ["x"] = 364.27685546875, ["y"] = 297.84490966797, ["z"] = 103.49515533447, ["info"] = "Garage O"},
  [16] = { ["x"] = -338.31619262695, ["y"] = 266.79782104492, ["z"] = 85.741966247559, ["info"] = "Garage P"},
  [17] = { ["x"] = 273.66683959961, ["y"] = -343.83737182617, ["z"] = 44.919876098633, ["info"] = "Garage Q"},
  [18] = { ["x"] = 66.215492248535, ["y"] = 13.700443267822, ["z"] = 69.047248840332, ["info"] = "Garage R"},
  [19] = { ['x'] = -791.79,['y'] = -191.7,['z'] = 37.29, ["info"] = "Garage Imports"},
  [20] = { ["x"] = 286.67013549805, ["y"] = 79.613700866699, ["z"] = 94.362899780273, ["info"] = "Garage S"},
	[21] = { ["x"] = 211.79, ["y"] = -808.38, ["z"] = 30.833, ["info"] = "Garage T"},
  [22] = { ["x"] = 447.65, ["y"] = -1021.23, ["z"] = 28.45, ["info"] = "Garage Police Department"},
	[23] = { ["x"] = -25.59, ["y"] = -720.86, ["z"] = 32.22, ["info"] = "Garage House"},
	[24] = { ['x'] = -836.93,['y'] = -1273.09,['z'] = 5.01, ['info'] = 'Garage U' },
	[25] = { ['x'] = -1563.23,['y'] = -257.64,['z'] = 48.28, ['info'] = 'Garage V' },
	[26] = { ['x'] = -1327.67,['y'] = -927.44,['z'] = 11.21, ['info'] = 'Garage W' },
}



RegisterNetEvent('GPS:SetRoute')
AddEventHandler('GPS:SetRoute', function(house_id,house_model)
	
	local house_id = tonumber(house_id)
	local house_model = tonumber(house_model)

	if house_model == 1 then
		mygps = robberycoords[house_id]
		
	elseif house_model == 2 then
		
		mygps = robberycoordsMansions[house_id]
	elseif house_model == 3 then
		
		mygps = rentedOffices[house_id]["location"]
		mygps["info"] = rentedOffices[house_id]["name"]
	else
		mygps = customGPSlocations[house_id]
	end
	if GPSblip ~= nil then
		RemoveBlip(GPSblip)
	end
	GPSblip = AddBlipForCoord(mygps["x"],mygps["y"],mygps["z"])
	TriggerEvent("GPSActivated",true)
	SetBlipRoute(GPSblip, 1)
	SetBlipAsFriendly(GPSblip, 1)
	SetBlipColour(GPSblip, 6)
	TriggerEvent("DoLongHudText","Your GPS location has been set to " .. mygps["info"] .. "!")

end)

RegisterNetEvent('GPSLocations')
AddEventHandler('GPSLocations', function()
	if GPSblip ~= nil then
		RemoveBlip(GPSblip)
		GPSblip = nil
	end	
	TriggerEvent("DoLongHudText","GPS has been deactivated, please select your route!")
	TriggerEvent("GPSActivated",false)
	TriggerEvent("openGPS",robberycoordsMansions,robberycoords,rentedOffices)
end)

drugspots = {
	[1] =  { ['x'] = 49.22,['y'] = -1893.67,['z'] = 21.79,['h'] = 201.41, ['info'] = ' drug spot 1' },
	[2] =  { ['x'] = -125.16,['y'] = -1535.4,['z'] = 34.14,['h'] = 200.84, ['info'] = ' drug spot 2' },
	[3] =  { ['x'] = 1242.16,['y'] = -1613.26,['z'] = 52.6,['h'] = 200.34, ['info'] = ' drug spot 3' },
}

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