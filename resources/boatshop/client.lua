--[[Register]]--

RegisterNetEvent("ply_docks:getBoat")
RegisterNetEvent('ply_docks:SpawnBoat')
RegisterNetEvent('ply_docks:StoreBoat')
RegisterNetEvent('ply_docks:BuyTrue')
RegisterNetEvent('ply_docks:BuyFalse')
RegisterNetEvent('ply_docks:StoreBoatTrue')
RegisterNetEvent('ply_docks:StoreBoatFalse')
RegisterNetEvent('ply_docks:SelBoatTrue')
RegisterNetEvent('ply_docks:SelBoatFalse')


--[[Local/Global]]--

BOATS = {}

local vente_location = {-774.553, -1425.26, 1.000}
local ventenamefr = "Sell"
local ventenameen = "Sell"
local docks = {
	{name="Dock", colour=3, id=356, x=-794.352, y=-1501.18, z=1.000, axe = 120.000},
}

dockSelected = { {x=nil, y=nil, z=nil}, }

--[[Functions]]--

function configLang(lang)
	local lang = lang
	if lang == "FR" then
		lang_string = {
			menu0 = "Store the boat",
			menu1 = "Marina",
			menu2 = "Get a boat",
			menu3 = "Close",
			menu4 = "Boats",
			menu5 = "Back",
			menu6 = "Get",
			menu7 = "~g~E~s~ to open menu",
			menu8 = "~g~E~s~ to sell the boat at 50% of the purchase price",
			state1 = "Out",
			state2 = "In",
			text1 = "No boat present",
			text2 = "The area is crowded",
			text3 = "This boat is already out",
			text4 = "Boat out",
			text5 = "It's not your boat",
			text6 = "Boat stored",
			text7 = "Boat bought, good wind",
			text8 = "Insufficient funds",
			text9 = "Boat sold"
	}

	elseif lang == "EN" then
		lang_string = {
			menu0 = "Store the boat",
			menu1 = "Marina",
			menu2 = "Get a boat",
			menu3 = "Close",
			menu4 = "Boats",
			menu5 = "Back",
			menu6 = "Get",
			menu7 = "~g~E~s~ to open menu",
			menu8 = "~g~E~s~ to sell the boat at 50% of the purchase price",
			state1 = "Out",
			state2 = "In",
			text1 = "No boat present",
			text2 = "The area is crowded",
			text3 = "This boat is already out",
			text4 = "Boat out",
			text5 = "It's not your boat",
			text6 = "Boat stored",
			text7 = "Boat bought, good wind",
			text8 = "Insufficient funds",
			text9 = "Boat sold"
	}
	end
end

		lang_string = {
			menu0 = "Store the boat",
			menu1 = "Marina",
			menu2 = "Get a boat",
			menu3 = "Close",
			menu4 = "Boats",
			menu5 = "Back",
			menu6 = "Get",
			menu7 = "~g~E~s~ to open menu",
			menu8 = "~g~E~s~ to sell the boat at 50% of the purchase price",
			state1 = "Out",
			state2 = "In",
			text1 = "No boat present",
			text2 = "The area is crowded",
			text3 = "This boat is already out",
			text4 = "Boat out",
			text5 = "It's not your boat",
			text6 = "Boat stored",
			text7 = "Boat bought, good wind",
			text8 = "Insufficient funds",
			text9 = "Boat sold"
	}

--[[Menu Dock]]--

function MenuDock()
    ped = PlayerPedId();
    MenuTitle = lang_string.menu1
    ClearMenu()
    Menu.addButton(lang_string.menu0,"RentrerBateau",nil)
    Menu.addButton(lang_string.menu2,"ListeBateau",nil)
    Menu.addButton(lang_string.menu3,"CloseMenu",nil) 

end

function RentrerBateau()
	Citizen.CreateThread(function()
		local caissei = GetClosestVehicle(-794.352, -1501.18, 1.000, 15.000, 0, 12294)

		local plate = GetVehicleNumberPlateText(caissei)
		if DoesEntityExist(caissei) then
			TriggerServerEvent('ply_docks:CheckForBoat',plate)
		else
			drawNotification(lang_string.text1)
		end   
	end)
	CloseMenu()
end

function ListeBateau()
    ped = PlayerPedId();
    MenuTitle = lang_string.menu4
    ClearMenu()
    for ind, value in pairs(BOATS) do
            Menu.addButton(tostring(value.boat_name) .. " : " .. tostring(value.boat_state), "OptionBateau", value.id)
    end    
    Menu.addButton(lang_string.menu5,"MenuDock",nil)
end

function OptionBateau(boatID)

	local boatID = boatID
    MenuTitle = "Options"
    ClearMenu()
    Menu.addButton(lang_string.menu6, "SortirBateau", boatID)
    Menu.addButton(lang_string.menu5, "ListeVBateau", nil)
end

function SortirBateau(boatID)
	local boatID = boatID
	TriggerServerEvent('ply_docks:CheckForSpawnBoat', boatID)
	CloseMenu()
end


---Generic Fonction

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function CloseMenu()
	TriggerServerEvent("ply_docks:GetBoats")
    Menu.hidden = true
end

function LocalPed()
	return PlayerPedId()
end

function Chat(debugg)
    TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

--[[Citizen]]--

--dock
Citizen.CreateThread(function()

	for _, item in pairs(docks) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipAsShortRange(item.blip, true)
		SetBlipColour(item.blip, item.colour)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.name)
		EndTextCommandSetBlipName(item.blip)
    end


	local loc = vente_location
	local pos = vente_location
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,207)
	SetBlipColour(blip, 3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(ventenameen)
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
	checkgarage = 0



	while true do
		Citizen.Wait(1)

		local near = false

		local comparedst = #(GetEntityCoords(PlayerPedId()) - vector3( -794.352, -1501.18, 1.000))
		local comparedst2 = #(GetEntityCoords(PlayerPedId()) - vector3( vente_location[1],vente_location[2],vente_location[3] ))


		if comparedst < 10 and IsPedInAnyVehicle(LocalPed(), true) == false then
			DrawMarker(1, -794.352, -1501.18, 1.000 , 0, 0, 0, 0, 0, 0, 5.001, 5.0001, 0.5001, 0, 155, 255, 70, 0, 0, 0, 0)
			drawTxt(lang_string.menu7,0,1,0.5,0.8,0.6,255,255,255,255)
			if IsControlJustReleased(1, 86) then
				MenuDock()
				Menu.hidden = not Menu.hidden 
			end
			Menu.renderGUI() 
		end

		if comparedst < 10 and near ~= true then 
			near = true							
		end

		if near == false then 
			Menu.hidden = true;
		end

		if comparedst2 < 10 then
			DrawMarker(1,vente_location[1],vente_location[2],vente_location[3],0,0,0,0,0,0,5.001,5.0001,0.5001,0,155,255,50,0,0,0,0)
			if #(vector3(vente_location[1],vente_location[2],vente_location[3]) - GetEntityCoords(LocalPed())) < 15 and IsPedInAnyVehicle(LocalPed(), true) == false then
				drawTxt(lang_string.menu8,0,1,0.5,0.8,0.6,255,255,255,255)
				if IsControlJustPressed(1, 86) then
					local caissei = GetClosestVehicle(vente_location[1],vente_location[2],vente_location[3], 15.000, 0, 12294)

					local platecaissei = GetVehicleNumberPlateText(caissei)
					if DoesEntityExist(caissei) then
						TriggerServerEvent('ply_docks:CheckForSelBoat',platecaissei)
					else
						drawNotification(lang_string.text1)
					end  
				end
			end
		end

		if comparedst2 > 20 and comparedst > 20 then
			Citizen.Wait(5000)
		end
	end

end)





--[[Events]]--

AddEventHandler("ply_docks:getBoat", function(THEBOATS)
--[[     BOATS = {}
    BOATS = THEBOATS ]]
end)


RegisterNetEvent('Relog')
AddEventHandler('Relog', function()
	local lang = "EN"
	configLang(lang)
	TriggerServerEvent("ply_docks:Lang", lang)
end)



AddEventHandler('ply_docks:SpawnBoat', function(boat, plate, state, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
	local boat = boat
	local car = GetHashKey(boat)
	local plate = plate
	local state = state
	local primarycolor = tonumber(primarycolor)
	local secondarycolor = tonumber(secondarycolor)
	local pearlescentcolor = tonumber(pearlescentcolor)
	local wheelcolor = tonumber(wheelcolor)
	Citizen.CreateThread(function()
		Citizen.Wait(1000)
		local caisseo = GetClosestVehicle(-794.352, -1501.18, 1.000, 3.000, 0, 12294)
		if DoesEntityExist(caisseo) then
			drawNotification(lang_string.text2) 
		else
			if state == lang_string.state1 then
				drawNotification(lang_string.text3)
			else
				local mods = {}
				for i = 0,24 do
					mods[i] = GetVehicleMod(veh,i)
				end
				RequestModel(car)
				while not HasModelLoaded(car) do
				Citizen.Wait(0)
				end
				veh = CreateVehicle(car, -794.352, -1501.18, 1.000, 90.0, true, false)
				SetModelAsNoLongerNeeded(car)
				local timer = 9000
				while not DoesEntityExist(veh) and timer > 0 do
					timer = timer - 1
					Citizen.Wait(1)
				end


				for i,mod in pairs(mods) do
					SetVehicleModKit(personalvehicle,0)
					SetVehicleMod(personalvehicle,i,mod)
				end
				SetVehicleNumberPlateText(veh, plate)
				SetVehicleOnGroundProperly(veh)
				SetVehicleHasBeenOwnedByPlayer(veh,true)
				local id = NetworkGetNetworkIdFromEntity(veh)
				SetNetworkIdCanMigrate(id, true)
				SetVehicleColours(veh, primarycolor, secondarycolor)
				SetVehicleExtraColours(veh, pearlescentcolor, wheelcolor)
				SetEntityInvincible(veh, false) 
				drawNotification(lang_string.text4)	

				TriggerEvent("keys:addNew",veh,plate)	
				SetPedIntoVehicle(PlayerPedId(), veh, - 1)
				TriggerServerEvent('ply_docks:SetBoatOut', boat, plate)
   				TriggerServerEvent("ply_docks:GetBoats")

   				SetVehicleHasBeenOwnedByPlayer(veh,true)
			end
		end
	end)
end)

AddEventHandler('ply_docks:StoreBoatTrue', function()
	Citizen.Trace("Store Success")
	Citizen.CreateThread(function()
		Citizen.Wait(1000)
		local caissei = GetClosestVehicle(-794.352, -1501.18, 1.000, 15.000, 0, 12294)

		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
		drawNotification(lang_string.text6)
		TriggerServerEvent("ply_docks:GetBoats")
	end)
end)

AddEventHandler('ply_docks:StoreBoatFalse', function()
	Citizen.Trace("Store False")
	drawNotification(lang_string.text5)
end)

AddEventHandler('ply_docks:SelBoatTrue', function()
	Citizen.Trace("Sell Boat True")
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		local caissei = GetClosestVehicle(vente_location[1],vente_location[2],vente_location[3], 15.000, 0, 12294)

		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
		drawNotification(lang_string.text9)
		TriggerServerEvent("ply_docks:GetBoats")
	end)
end)

AddEventHandler('ply_docks:SelBoatFalse', function()
	Citizen.Trace("Sell Boat False")
	drawNotification(lang_string.text5)
end)

AddEventHandler('ply_docks:BuyTrue', function()
	Citizen.Trace("Buy Success")
	drawNotification(lang_string.text7)
    TriggerServerEvent("ply_docks:GetBoats")
end)

AddEventHandler('ply_docks:BuyFalse', function()
	Citizen.Trace("Buy False")
	drawNotification(lang_string.text8)
end)

RegisterNetEvent("ply_docks:SetBoatInventory")
AddEventHandler("ply_docks:SetBoatInventory", function(boats)
	BOATS = boats
end)

RemoveIpl('v_carshowroom')
RemoveIpl('shutter_open')
RemoveIpl('shutter_closed')
RemoveIpl('shr_int')
RemoveIpl('csr_inMission')
RequestIpl('v_carshowroom')
RequestIpl('shr_int')
RequestIpl('shutter_closed')
