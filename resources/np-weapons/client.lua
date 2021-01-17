function W2H(info)
	returnItem = weaponNameToHash.info
	return returnItem
end

function D2N(info)
	info = decimalToName[info]
	return info
end

function N2P(info)
	info = info:gsub("WEAPON_","PICKUP_WEAPON_")
	return info
end

-- pickup hashes seem to not return so this doesnt work.
function doPickup(PickupHash, etype, unk, x, y, z, ModelHash)
	CreatePickup(PickupHash, x, y, z, 23, 23, 23, ModelHash)
end

function IsNearPlayer(player)
  local ply = PlayerPedId()
  local plyCoords = GetEntityCoords(ply, 0)
  local ply2 = GetPlayerPed(GetPlayerFromServerId(player))
  local ply2Coords = GetEntityCoords(ply2, 0)
  local distance = Vdist2(plyCoords, ply2Coords)
  if(distance <= 10) then
    return true
  end
end
local weapon = nil 
local canDrop = true

RegisterNetEvent('np-weapons:destroyGroundWeapon')
AddEventHandler('np-weapons:destroyGroundWeapon', function()
	DeleteEntity(weapon)
end)

RegisterNetEvent('np-weapons:allowDrop')
AddEventHandler('np-weapons:allowDrop', function()
	canDrop = true
end)

RegisterNetEvent('np-weapons:dropweapon')
AddEventHandler('np-weapons:dropweapon', function(AmountOfCurrentWeapon,weaponModel,rowID)
	if not canDrop then TriggerEvent("DoLongHudText", "Cannot Drop Right now.",2) return end
	local name = weaponModel
	if rowID == 0 then return end
	if not name then return end
	
	if AmountOfCurrentWeapon <= 0 then return end
	
	if AmountOfCurrentWeapon == 1 then
		RemoveWeaponFromPed(PlayerPedId(),tonumber(name))
	end

	local model = ""

	model = findModel(toName(name))

	if model == nil then model = "w_ar_assaultrifle" end

	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end	

	local posDrop = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -0.3)


	weapon = CreateObject(GetHashKey(model),posDrop.x,posDrop.y,posDrop.z, 1, 0, 0)
	ActivatePhysics(weapon)

	local vel = GetOffsetFromEntityInWorldCoords(weapon, 0.0, 0.0, 0.0)
	local stoppedMoving = true
	Wait(10)

	while stoppedMoving do
		local curvel = GetOffsetFromEntityInWorldCoords(weapon, 0.0, 0.0, 0.0)
		if vel.x == curvel.x and vel.y == curvel.y and vel.z == curvel.z then stoppedMoving = false end
		
		vel = GetOffsetFromEntityInWorldCoords(weapon, 0.0, 0.0, 0.0)
        Citizen.Wait(100)
    end    

    local pos = GetOffsetFromEntityInWorldCoords(weapon, 0.0, 0.0, 0.0) 
    canDrop = false
	TriggerServerEvent("np-weapons:dropWeapon",{pos.x,pos.y,pos.z+0.75},name,rowID)

	Wait(400)
	--stringedmessage = "Hash to Weapon Returned: " .. name .. " | "
	--TriggerEvent("DoLongHudText", stringedmessage)

	TriggerServerEvent("actionclose", PlayerPedId(), "Dropped a weapon", PlayerId())

	TriggerServerEvent("weaponshop:removeSingleWeapon",rowID)

	Citizen.Wait(1000)
	
	GiveWeaponToPed(PlayerPedId(), 0xA2719263, 0, 0, 1)
	TriggerEvent("attachWeapons")
	TriggerEvent("updateActionBar")

end)

RegisterNetEvent('np-weapons:doHandOver')
AddEventHandler('np-weapons:doHandOver', function(weapon)
  --GiveWeaponToPed(PlayerPedId(), tonumber(weapon), 0, 0, false)
  TriggerEvent("attachWeapons")
end)

RegisterNetEvent('np-weapons:dropWeaponSearch')
AddEventHandler('np-weapons:dropWeaponSearch', function(weapon)
	--RemoveWeaponFromPed(PlayerPedId(),tonumber(weapon))
  TriggerEvent("attachWeapons")
end)


RegisterNetEvent('np-weapons:giveweapon')
AddEventHandler('np-weapons:giveweapon', function(toPlayer,AmountOfCurrentWeapon,weaponModel,rowID)


	if not IsPedInAnyVehicle(PlayerPedId(),true) then
			local name = weaponModel
			if rowID == 0 then return end
			if not name then return end
			if AmountOfCurrentWeapon <= 0 then return end

		if not IsNearPlayer(toPlayer) then TriggerEvent('chatMessage', "", {255, 0, 0}, "^1You are not near this player!") return end

		local target = GetPlayerFromServerId(toPlayer)
		local targetPos = GetEntityCoords(GetPlayerPed(target))

		local userCoords = GetEntityCoords(PlayerPedId())

		if Vdist2(targetPos, userCoords) > 15.0 then
			TriggerEvent('chatMessage', "", {255, 0, 0}, "^1You are not near this player!")
			return
		end

		local player2 = GetPlayerFromServerId(tonumber(toPlayer))
		local playing = IsPlayerPlaying(player2)

		if (playing ~= false) then
			
			if AmountOfCurrentWeapon == 1 then
				RemoveWeaponFromPed(PlayerPedId(),tonumber(name))
			end
	    
			GiveWeaponToPed(PlayerPedId(), 0xA2719263, 0, 0, 1)

			
			TriggerServerEvent("np-weapons:giveweapon", toPlayer, name,rowID)
			Wait(1300)
			TriggerServerEvent("weaponshop:removeSingleWeapon",rowID)
			TriggerEvent("attachWeapons")
		else
			TriggerEvent('chatMessage', "", {255, 0, 0}, "^1This player is not online!")
		end

	else
		TriggerEvent("DoLongHudText", "You can not do this in a vehicle..",2)
	end

end)



Citizen.CreateThread(function()
	print("starting")
    while true do
        Wait(0)
        	
        if IsPedClimbing(PlayerPedId()) or IsPedJumping(PlayerPedId()) then
        	Citizen.Wait(100)
        	TriggerEvent("AnimSet:Set")
        	Citizen.Wait(1000)
        end
    end
end)

lastweapon = 0
Citizen.CreateThread(function()
	print("starting")
    while true do
        Wait(0)
        	

        if invehicle == nil then
        	print("nil invehicle -- starting scripts")
        	invehicle = false
        	TriggerEvent("attachWeapons")
        	TriggerEvent("AnimSet:Set")
        end

        local curw = GetSelectedPedWeapon(PlayerPedId())

        if not invehicle and IsPedInAnyVehicle(PlayerPedId(), false) then
        	print("entered vehicle")

        	if GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == `taxi` then
        		print("entered taxi boro")
        		TriggerEvent("taximeter:EnteredTaxi")
        	end

        	invehicle = true
        	removeAttachedProp()
        	TriggerEvent("AnimSet:Set")
        	TriggerEvent("deg:EnteredVehicle")
        end

        if invehicle and not IsPedInAnyVehicle(PlayerPedId(), false) then
        	TriggerEvent("deg:EnteredVehicle")
        	print("exited vehicle")

			TriggerEvent("taximeter:ExitedTaxi")

	       	invehicle = false
        	TriggerEvent("attachWeapons")
        	TriggerEvent("AnimSet:Set")
        end    

        if curw ~= lastweapon and not invehicle then
        	--print("weapon changed")
        	invehicle = false
        	lastweapon = curw
        	TriggerEvent("attachWeapons")
        	TriggerEvent("AnimSet:Set")
        end
    end
end)







attachedProp1 = 0
attachedProp2 = 0
attachedProp3 = 0
attachedProp4 = 0
attachedProp5 = 0
attachedProp6 = 0

function removeAttachedProp()
	DeleteEntity(attachedProp1)
	DeleteEntity(attachedProp2)
	DeleteEntity(attachedProp3)
	DeleteEntity(attachedProp4)
	DeleteEntity(attachedProp5)
	DeleteEntity(attachedProp6)
	attachedProp1 = 0
	attachedProp2 = 0
	attachedProp3 = 0	
	attachedProp4 = 0
	attachedProp5 = 0
	attachedProp6 = 0
end


RegisterNetEvent('attachWeapon1')
AddEventHandler('attachWeapon1', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end

	attachedProp1 = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	--attachWeapon1exports["isPed"]:GlobalObject(attachedProp1)
	AttachEntityToEntity(attachedProp1, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 0, 0, 0, 2, 1)
end)

RegisterNetEvent('attachWeapon2')
AddEventHandler('attachWeapon2', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedProp2 = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	--attachWeapon1exports["isPed"]:GlobalObject(attachedProp2)
	AttachEntityToEntity(attachedProp2, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 0, 0, 0, 2, 1)
end)


RegisterNetEvent('attachWeapon3')
AddEventHandler('attachWeapon3', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedProp3 = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	--attachWeapon1exports["isPed"]:GlobalObject(attachedProp3)
	AttachEntityToEntity(attachedProp3, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 0, 0, 0, 2, 1)
end)

RegisterNetEvent('attachWeapon4')
AddEventHandler('attachWeapon4', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end

	attachedProp4 = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	--attachWeapon1exports["isPed"]:GlobalObject(attachedProp4)
	AttachEntityToEntity(attachedProp4, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 0, 0, 0, 2, 1)
end)

RegisterNetEvent('attachWeapon5')
AddEventHandler('attachWeapon5', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedProp5 = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	--attachWeapon1exports["isPed"]:GlobalObject(attachedProp5)
	AttachEntityToEntity(attachedProp5, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 0, 0, 0, 2, 1)
end)


RegisterNetEvent('attachWeapon6')
AddEventHandler('attachWeapon6', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedProp6 = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	--attachWeapon1exports["isPed"]:GlobalObject(attachedProp6)
	AttachEntityToEntity(attachedProp6, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 0, 0, 0, 2, 1)
end)



local tempdisable = 0
local policeweapons = {}
RegisterNetEvent('serviceWeapons')
AddEventHandler('serviceWeapons', function(passwpns)
	policeweapons = passwpns
end)


RegisterNetEvent('RemoveServiceWeapons')
AddEventHandler('RemoveServiceWeapons', function()
	policeweapons = {}
	TriggerEvent("serviceWeapons",policeweapons)
end)
local weapcount = 1
local attaching = false
RegisterNetEvent('attachWeapons')
AddEventHandler('attachWeapons', function()

	
	-- no more attaching for testing
	if true then
		return
	end
	-- no more attaching for testing


	if attaching then
		return
	end
	attaching = true
	print("attaching")
	Wait(100)
	removeAttachedProp()
	
	local currentWeapons = exports["np-inventory"]:GetCurrentWeapons() 
	weapcount = 1
	local curw = GetSelectedPedWeapon(PlayerPedId())
	local curwName = "nothing"

	if activeTesting[curw] then
		curwName = activeTesting[curw]["name"]
	end


	for i = 1, #currentWeapons do

		local try = tonumber(currentWeapons[i]["hash"])

		if activeTesting[try] ~= nil then
			if curw ~= try and curwName ~= currentWeapons[i]["name"] then
				doAttach(activeTesting[try]["model"],activeTesting[try]["rotate"])
				hasweapon = true
			else
				if curw == try then
					weapcount = weapcount + 1
				end
			end
		end

	end		

	for i = 1, #policeweapons do
		local try = tonumber(policeweapons[i]["hash"])

		if activeTesting[try] ~= nil then
			if curw ~= try and curwName ~= policeweapons[i]["name"] then
				doAttach(activeTesting[try]["model"],activeTesting[try]["rotate"])
				hasweapon = true
			else
				if curw == try then
					weapcount = weapcount + 1
				end
			end
		end
	end

	Wait(500)
	attaching = false


end)


function doAttach(w,r)
	local curw = GetSelectedPedWeapon(PlayerPedId())

	if weapcount < 7 then

		local add = 0.0


		if weapcount == 3 then
			TriggerEvent("attachWeapon1",w, 24816, 0.17 + add, -0.17, 0.0, 0.0, r, 0.0)
		elseif weapcount == 6 then
			TriggerEvent("attachWeapon2",w, 24816, 0.17 - add, -0.17, 0.07, 0.0, r, 0.0)
		elseif weapcount == 5 then
			TriggerEvent("attachWeapon3",w, 24816, 0.17 + add, -0.17, -0.07, 0.0, r, 0.0)
		elseif weapcount == 1 then
			TriggerEvent("attachWeapon4",w, 24816, 0.17 - add, -0.17, 0.11, 0.0, r, 0.0)
		elseif weapcount == 4 then
			TriggerEvent("attachWeapon5",w, 24816, 0.17 + add, -0.17, -0.12, 0.0, r, -0.0)
		elseif weapcount == 2 then
			TriggerEvent("attachWeapon6",w, 24816, 0.17 - add, -0.17, -0.18, 0.0, r, 0.0)
		end

		weapcount = weapcount + 1
	end

end




attachedDrawProp1 = 0

function removeAttachedDrawProp()
	DeleteEntity(attachedDrawProp1)
	attachedDrawProp1 = 0
end







RegisterNetEvent('attachWeaponPull')
AddEventHandler('attachWeaponPull', function(hash,longer)
	
	if activeTesting[hash] then
		removeAttachedDrawProp()

		TriggerEvent("attachWeaponHand",activeTesting[hash]["model"], 18905, 0.12, 0.1, 0.0, 270.0, 280.0, 260.0,longer)
	end
end)

RegisterNetEvent('attachWeaponHand')
AddEventHandler('attachWeaponHand', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR,longer)
	TriggerEvent("attachWeapons")
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end

	attachedDrawProp1 = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedDrawProp1, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 0, 0, 0, 2, 1)
	Citizen.Wait(800)
	if longer then
		Citizen.Wait(600)
	end
	removeAttachedDrawProp()
	tempdisable = 0
	TriggerEvent("attachWeapons")
end)













--Citizen.CreateThread(function()
--	print( "dicks" )
--	for i = 1, #curweapons do
--		print( GetHashKey(curweapons[i]) )
--		TriggerServerEvent("SaveGunsBrah", GetHashKey(curweapons[i]), curweapons[i])
--	end
--end)


-- weap model then CID
RegisterNetEvent('DisplayWeapons')
AddEventHandler('DisplayWeapons', function(results) 

	--print(json.encode(results))

	TriggerEvent('chatMessage', 'SEARCH - WEAPONS', {255, 0, 0}, " TOTAL: (" .. #results .. ")")

	for k,v in ipairs(results) do

		local curCheck = v.weapon_model
		local metaData = json.decode(v.metaData)
		local cartridge = ""
		local isMelee = false 
		for _,j in ipairs(weaponCheck) do
			if tonumber(v.weapon_model) == j then
				isMelee = true
			else
				if isMelee then isMelee = true else isMelee = false end
			end
		end
		if isMelee then
			cartridge = "None"
		else
			if v.metaData.cartridge ~= nil then
				cartridge = v.metaData.cartridge
			end	
		end
		if tostring( hashGunToText[curCheck] ) ~= nil then
			
			if v.originalCID == nil or v.originalCID == 0 then
				TriggerEvent('chatMessage', 'SEARCH - WEAPONS', {255, 0, 0}, hashGunToText[curCheck] .. " - (Unknown) ".." - Cartridge: "..cartridge)
			else
				if hashGunToText[curCheck] == nil then
					TriggerEvent('chatMessage', 'SEARCH - WEAPONS', {255, 0, 0}, "Error: Unknown Weapon - (" .. v.originalCID .. ")".." - Cartridge: "..cartridge)
				else
					TriggerEvent('chatMessage', 'SEARCH - WEAPONS', {255, 0, 0}, hashGunToText[curCheck] .. " - (" .. v.originalCID .. ")".." - Cartridge: "..cartridge)
				end				
			end	
		else
			TriggerEvent('chatMessage', 'SEARCH - WEAPONS', {255, 0, 0}, v.weapon_model .. " - (" .. v.originalCID .. ")".." Cartridge: "..cartridge)
		end
		if isMelee then
			for _,j in ipairs(metaData.dna) do
				TriggerEvent('chatMessage', 'Evidence - WEAPONS', {255, 0, 0}, hashGunToText[curCheck] .." - Dna: "..j)
			end
		end
			
	end

end)


weaponCheck = {
    -1716189206,
    1317494643,
    -1786099057,
    -2067956739,
    1141786504 ,
    -102323637,
    -1834847097,
    -102973651 ,
    -656458692 ,
    -581044007,
    -1951375401,
    -538741184 ,
    -1810795771 ,
    419712736 
}

curweapons = {
	[1] = "WEAPON_PetrolCan",
	[2] = "WEAPON_Flare",
	[3] = "WEAPON_Knife",
	[4] = "WEAPON_HAMMER",
	[5] = "WEAPON_Bat",
	[6] = "WEAPON_Crowbar",
	[7] = "WEAPON_Golfclub",
	[8] = "WEAPON_Bottle",
	[9] = "WEAPON_Dagger",
	[10] = "WEAPON_Hatchet",
	[11] = "WEAPON_KNUCKLE",
	[12] = "WEAPON_Machete",
	[13] = "WEAPON_Flashlight",
	[14] = "WEAPON_SwitchBlade",
	[15] = "WEAPON_Poolcue",
	[16] = "WEAPON_Wrench",
	[17] = "WEAPON_Pistol",
	[18] = "WEAPON_CombatPistol",
	[19] = "WEAPON_VintagePistol",
	[20] = "WEAPON_StunGun",
	[21] = "WEAPON_MicroSMG",
	[22] = "WEAPON_SMG",
	[23] = "WEAPON_AssaultSMG",
	[24] = "WEAPON_Gusenberg",
	[25] = "WEAPON_SawnoffShotgun",
	[26] = "WEAPON_BullpupShotgun",
	[27] = "WEAPON_AssaultShotgun",
	[28] = "WEAPON_HeavyShotgun",
	[29] = "WEAPON_Autoshotgun",
	[30] = "WEAPON_AssaultRifle",
	[31] = "WEAPON_CarbineRifle",
	[32] = "WEAPON_AdvancedRifle",
	[33] = "WEAPON_SpecialCarbine",
	[34] = "WEAPON_BullpupRifle",
	[35] = "WEAPON_SniperRifle",
	[36] = "WEAPON_HeavySniper",
	[37] = "WEAPON_MarksmanRifle",
	[38] = "WEAPON_Firework",
	[39] = "WEAPON_FireExtinguisher"
}


local weaponList = {
    {name = 'WEAPON_KNIFE', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'prop_w_me_knife_01'},
	{name = 'WEAPON_NIGHTSTICK', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'w_me_nightstick'},
	{name = 'WEAPON_HAMMER', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'prop_tool_hammer'},
	{name = 'WEAPON_BAT', 				bone = 24818, x = 0.0, y = 0.0, z = 0.0, xRot = 320.0, yRot = 320.0, zRot = 320.0, category = 'melee', 	model = 'w_me_bat'},
	{name = 'WEAPON_GOLFCLUB', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'w_me_gclub'},
	{name = 'WEAPON_CROWBAR', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'w_me_crowbar'},
	{name = 'WEAPON_BOTTLE', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'prop_w_me_bottle'},
	{name = 'WEAPON_KNUCKLE', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'prop_w_me_dagger'},
	{name = 'WEAPON_HATCHET', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'w_me_hatchet'},
	{name = 'WEAPON_MACHETE', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'prop_ld_w_me_machette'},
	{name = 'WEAPON_SWITCHBLADE', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'prop_w_me_dagger'},
	{name = 'WEAPON_FLASHLIGHT', 		bone = 24818, x = 0.0, y = 0.0, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'prop_w_me_dagger'},

	{name = 'WEAPON_PISTOL', 			bone = 51826, x = -0.01, y = 0.10, z = 0.07,  xRot = -115.0, yRot = 0.0,  zRot = 0.0, category = 'handguns', 	model = 'w_pi_pistol'},
	{name = 'WEAPON_COMBATPISTOL', 		bone = 51826, x = -0.01, y = 0.10, z = 0.07,  xRot = -115.0, yRot = 0.0,  zRot = 0.0, category = 'handguns', 	model = 'w_pi_combatpistol'},
	{name = 'WEAPON_APPISTOL', 			bone = 51826, x = -0.01, y = 0.10, z = 0.07,  xRot = -115.0, yRot = 0.0,  zRot = 0.0, category = 'handguns', 	model = 'w_pi_appistol'},
	{name = 'WEAPON_PISTOL50', 			bone = 51826, x = -0.01, y = 0.10, z = 0.07,  xRot = -115.0, yRot = 0.0,  zRot = 0.0, category = 'handguns', 	model = 'w_pi_pistol50'},
	{name = 'WEAPON_VINTAGEPISTOL', 	bone = 51826, x = -0.01, y = 0.10, z = 0.07,  xRot = -115.0, yRot = 0.0,  zRot = 0.0, category = 'handguns', 	model = 'w_pi_vintage_pistol'},
	{name = 'WEAPON_HEAVYPISTOL', 		bone = 51826, x = -0.01, y = 0.10, z = 0.07,  xRot = -115.0, yRot = 0.0,  zRot = 0.0, category = 'handguns', 	model = 'w_pi_heavypistol'},
	{name = 'WEAPON_SNSPISTOL', 		bone = 58271, x = -0.01, y = 0.1,  z = -0.07, xRot = -55.0,  yRot = 0.10, zRot = 0.0, category = 'handguns', 	model = 'w_pi_sns_pistol'},
	{name = 'WEAPON_FLAREGUN', 			bone = 58271, x = -0.01, y = 0.1,  z = -0.07, xRot = -55.0,  yRot = 0.10, zRot = 0.0, category = 'handguns', 	model = 'w_pi_flaregun'},

	{name = 'WEAPON_STUNGUN', 			bone = 58271, x = -0.01, y = 0.1,  z = -0.07, xRot = -55.0,  yRot = 0.10, zRot = 0.0, category = 'handguns', 	model = 'w_pi_stungun'},

	{name = 'WEAPON_MICROSMG', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'machine', 	model = 'w_sb_microsmg'},
	{name = 'WEAPON_SMG', 				bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'machine', 	model = 'w_sb_smg'},
	{name = 'WEAPON_MG', 				bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'machine', 	model = 'w_mg_mg'},
	{name = 'WEAPON_COMBATMG', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'machine', 	model = 'w_mg_combatmg'},
	{name = 'WEAPON_GUSENBERG', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'machine', 	model = 'w_sb_gusenberg'},

	{name = 'WEAPON_ASSAULTSMG', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'machine', 	model = 'w_sb_smg'},

	{name = 'WEAPON_ASSAULTRIFLE', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'assault', 	model = 'w_ar_assaultrifle'},
	{name = 'WEAPON_CARBINERIFLE', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'assault', 	model = 'w_ar_carbinerifle'},
	{name = 'WEAPON_ADVANCEDRIFLE', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'assault', 	model = 'w_ar_advancedrifle'},
	{name = 'WEAPON_SPECIALCARBINE', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'assault', 	model = 'w_ar_specialcarbine'},
	{name = 'WEAPON_BULLPUPRIFLE', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'assault', 	model = 'w_ar_bullpuprifle'},


	{name = 'WEAPON_PUMPSHOTGUN', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'shotgun', 	model = 'w_sg_pumpshotgun'},

	{name = 'WEAPON_BULLPUPSHOTGUN', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'shotgun', 	model = 'w_sg_bullpupshotgun'},
	{name = 'WEAPON_ASSAULTSHOTGUN', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'shotgun', 	model = 'w_sg_assaultshotgun'},
	{name = 'WEAPON_MUSKET', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'shotgun', 	model = 'w_ar_musket'},
	{name = 'WEAPON_HEAVYSHOTGUN', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 225.0, zRot = 0.0, category = 'shotgun', 	model = 'w_sg_heavyshotgun'},


	{name = 'WEAPON_SNIPERRIFLE', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'sniper', 	model = 'w_sr_sniperrifle'},
	{name = 'WEAPON_HEAVYSNIPER', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'sniper', 	model = 'w_sr_heavysniper'},
	{name = 'WEAPON_MARKSMANRIFLE', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'sniper', 	model = 'w_sr_marksmanrifle'},


	{name = 'WEAPON_GRENADELAUNCHER', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'heavy', 		model = 'w_lr_grenadelauncher'},
	{name = 'WEAPON_RPG', 				bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'heavy', 		model = 'w_lr_rpg'},
	{name = 'WEAPON_MINIGUN', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'heavy', 		model = 'w_mg_minigun'},
	{name = 'WEAPON_FIREWORK', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'heavy', 		model = 'w_lr_firework'},
	{name = 'WEAPON_RAILGUN', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'heavy', 		model = 'w_ar_railgun'},
	{name = 'WEAPON_HOMINGLAUNCHER', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'heavy', 		model = 'w_lr_homing'},


	{name = 'WEAPON_STICKYBOMB', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'prop_bomb_01_s'},
	{name = 'WEAPON_MOLOTOV', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_ex_molotov'},
	{name = 'WEAPON_FIREEXTINGUISHER', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_am_fire_exting'},
	{name = 'WEAPON_PETROLCAN', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_am_jerrycan'},

	{name = 'WEAPON_SNOWBALL', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_ex_snowball'},
	{name = 'WEAPON_BALL', 				bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_am_baseball'},
	{name = 'WEAPON_GRENADE', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_ex_grenadefrag'},
	{name = 'WEAPON_SMOKEGRENADE', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_ex_grenadesmoke'},
	{name = 'WEAPON_BZGAS', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_ex_grenadesmoke'},

	{name = 'WEAPON_DIGISCANNER', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = 'w_am_digiscanner'},
	{name = 'WEAPON_DAGGER', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = 'prop_w_me_dagger'},

	{name = 'WEAPON_BATTLEAXE', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = 'prop_tool_fireaxe'},

	{name = 'WEAPON_POOLCUE', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = 'prop_pool_cue'},
	{name = 'WEAPON_WRENCH', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = 'w_me_hammer'},

}











activeTesting = {
    [736523883] =   {["name"] = "SMG",                ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_smg.png", ["weapon"] = true, ["model"] = "w_sb_smg" ,["rotate"] = 0.0}, --'SMG',
    [-270015777] =  {["name"] = "Assault SMG",        ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_assault-smg.png", ["weapon"] = true, ["model"] = "w_mg_combatmg" ,["rotate"] = 0.0}, --'Assault SMG',
    [4024951519] =  {["name"] = "Assault SMG",        ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_assault-smg.png", ["weapon"] = true, ["model"] = "w_mg_combatmg" ,["rotate"] = 0.0}, --'Assault SMG',
    [1627465347] =  {["name"] = "Gusenberg",          ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_gusenberg.png", ["weapon"] = true, ["model"] = "w_mg_combatmg" ,["rotate"] = 0.0}, --'Gusenberg',
    [2017895192] =  {["name"] = "Sawnoff Shotgun",    ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_sawnoff-shotgun.png ", ["weapon"] = true, ["model"] = "w_sg_pumpshotgun" ,["rotate"] = 0.0}, --'Sawnoff Shotgun',
    [-1654528753] = {["name"] = "Bullpup Shotgun",    ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_bullpup-shotgun.png", ["weapon"] = true, ["model"] = "w_sg_bullpupshotgun" ,["rotate"] = 0.0}, --'Bullpup Shotgun',
    [2640438543] =  {["name"] = "Bullpup Shotgun",    ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_bullpup-shotgun.png", ["weapon"] = true, ["model"] = "w_sg_bullpupshotgun" ,["rotate"] = 0.0}, --'Bullpup Shotgun',
    [-494615257] =  {["name"] = "Assault Shotgun",    ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_assault-shotgun.png", ["weapon"] = true, ["model"] = "w_sg_assaultshotgun" ,["rotate"] = 0.0}, --'Assault Shotgun',
    [3800352039] =  {["name"] = "Assault Shotgun",    ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_assault-shotgun.png", ["weapon"] = true, ["model"] = "w_sg_assaultshotgun" ,["rotate"] = 0.0}, --'Assault Shotgun',
    [984333226] =   {["name"] = "Heavy Shotgun",      ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_heavy-shotgun.png", ["weapon"] = true, ["model"] = "w_sg_assaultshotgun" ,["rotate"] = 0.0}, --'Heavy Shotgun',
    [317205821] =   {["name"] = "Autoshotgun",        ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_sweeper-shotgun.png", ["weapon"] = true, ["model"] = "w_sg_assaultshotgun" ,["rotate"] = 0.0}, --'Autoshotgun',
    [-1074790547] = {["name"] = "Assault Rifle",      ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_assault-rifle.png", ["weapon"] = true, ["model"] = "w_ar_assaultrifle" ,["rotate"] = 0.0}, --'Assault Rifle',
    [3220176749] =  {["name"] = "Assault Rifle",      ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_assault-shotgun.png", ["weapon"] = true, ["model"] = "w_ar_assaultrifle" ,["rotate"] = 0.0}, --'Assault Rifle',

    [-2084633992] = {["name"] = "Carbine Rifle",      ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_carbine-rifle.png", ["weapon"] = true, ["model"] = "w_ar_carbinerifle" ,["rotate"] = 0.0}, --'Carbine Rifle',

    [2210333304] =  {["name"] = "Carbine Rifle",      ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_carbine-rifle.png", ["weapon"] = true, ["model"] = "w_ar_carbinerifle" ,["rotate"] = 0.0}, --'Carbine Rifle',

    [-1357824103] = {["name"] = "Advanced Rifle",     ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_advanced-rifle.png", ["weapon"] = true, ["model"] = "w_ar_advancedrifle" ,["rotate"] = 0.0}, --'Advanced Rifle',
    [2937143193] =  {["name"] = "Advanced Rifle",     ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_advanced-rifle.png", ["weapon"] = true, ["model"] = "w_ar_advancedrifle" ,["rotate"] = 0.0}, --'Advanced Rifle',

    [-1063057011] = {["name"] = "Special Carbine",    ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_special-carbine.png", ["weapon"] = true, ["model"] = "w_ar_specialcarbine" ,["rotate"] = 0.0}, --'Special Carbine',
    [2132975508] =  {["name"] = "Bullpup Rifle",      ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_bullpup-rifle.png", ["weapon"] = true, ["model"] = "w_ar_specialcarbine" ,["rotate"] = 0.0}, --'Bullpup Rifle',
    [100416529] =   {["name"] = "Sniper Rifle",       ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_sniper-rifle.png", ["weapon"] = true, ["model"] = "w_sr_sniperrifle" ,["rotate"] = 0.0}, --'Sniper Rifle',
    [205991906] =   {["name"] = "Heavy Sniper",       ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_heavy-sniper.png", ["weapon"] = true, ["model"] = "w_sr_sniperrifle" ,["rotate"] = 0.0}, --'Heavy Sniper',
    [-952879014] =  {["name"] = "Marksman Rifle",     ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_marksman-rifle.png", ["weapon"] = true, ["model"] = "w_sr_marksmanrifle" ,["rotate"] = 0.0}, --'Marksman Rifle',
 
    [2138347493] =  {["name"] = "Firework Launcher",  ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_firework-launcher.png", ["weapon"] = true, ["model"] = "w_lr_firework" ,["rotate"] = 0.0}, --'Firework Launcher',
    [2726580491] =  {["name"] = "Grenade Launcher",   ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_grenade-launcher.png", ["weapon"] = true, ["model"] = "w_lr_grenadelauncher" ,["rotate"] = 0.0},--"Grenade Launcher",
    [2982836145] =  {["name"] = "RPG",                ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_rpg.png", ["weapon"] = true, ["model"] = "w_lr_rpg" ,["rotate"] = 0.0}, --'RPG',




    [487013001] =   {["name"] = "Pump Shotgun",       ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_pump-shotgun.png", ["weapon"] = true, ["model"] = "w_sg_pumpshotgun" ,["rotate"] = 0.0}, --'Pump Shotgun',
    [2144741730] =  {["name"] = "Combat MG",          ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_combat-mg.png", ["weapon"] = true, ["model"] = "w_mg_mg" ,["rotate"] = 0.0}, --'Combat MG',
    [-1660422300] =  {["name"] = "MG",                ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_mg.png", ["weapon"] = true, ["model"] = "w_mg_mg" ,["rotate"] = 0.0}, --'MG',


   [171789620] =   {["name"] = "Combat PDW",         ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_combat-pdw.png", ["weapon"] = true, ["model"] = "w_sb_smg" ,["rotate"] = 0.0}, --'Combat PDW'



    [-102973651] =  {["name"] = "Hatchet",            ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_hatchet.png", ["weapon"] = true, ["model"] = "w_me_hatchet" ,["rotate"] = 90.0},
    [-2067956739] = {["name"] = "Crowbar",            ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_crowbar.png", ["weapon"] = true, ["model"] = "w_me_crowbar" ,["rotate"] = 90.0},
    [-1786099057] = {["name"] = "Baseball Bat",       ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_baseball-bat.png", ["weapon"] = true, ["model"] = "w_me_bat" ,["rotate"] = 90.0},


    [-2066285827] = {["name"] = "Assault SMG",        ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_assault-smg.png", ["weapon"] = true, ["model"] = "w_sb_smg" ,["rotate"] = 0.0},

    [2508868239] =  {["name"] = "Bat",                ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_baseball-bat.png", ["weapon"] = true, ["model"] = "w_me_bat" ,["rotate"] = 90.0},


    [1141786504] =  {["name"] = "Golfclub",           ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_golfclub.png", ["weapon"] = true, ["model"] = "w_me_gclub" ,["rotate"] = 90.0},
    [2227010557] =  {["name"] = "Crowbar",            ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_crowbar.png", ["weapon"] = true, ["model"] = "w_me_crowbar" ,["rotate"] = 90.0},
    [1305664598] =  {["name"] = "GND Launcher SMK",   ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_grenade-launcher.png", ["weapon"] = true, ["model"] = "w_lr_grenadelauncher" ,["rotate"] = 0.0},


    [883325847] =   {["name"] = "Petrol Can",         ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_petrol-can.png", ["weapon"] = true, ["model"] = "w_am_jerrycan" ,["rotate"] = 0.0},

    [3231910285] =  {["name"] = "Special Carbine",    ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_special-carbine.png", ["weapon"] = true, ["model"] = "w_ar_assaultrifle" ,["rotate"] = 0.0},

    [3342088282] =  {["name"] = "Mark Rifle",         ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_marksman-rifle.png", ["weapon"] = true, ["model"] = "w_ar_assaultrifle" ,["rotate"] = 0.0},
    [1672152130] =  {["name"] = "Homing Launcher",    ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_homing-launcher.png", ["weapon"] = true, ["model"] = "w_ar_assaultrifle" ,["rotate"] = 0.0},
    [4191993645] =  {["name"] = "Hatchet",            ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_hatchet.png", ["weapon"] = true, ["model"] = "w_me_hatchet" ,["rotate"] = 90.0},
    [3713923289] =  {["name"] = "Machete",            ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_machete.png", ["weapon"] = true, ["model"] = "prop_ld_w_me_machette" ,["rotate"] = 90.0},

    [4019527611] =  {["name"] = "DB Shotgun",         ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_db-shotgun.png", ["weapon"] = true, ["model"] = "w_sg_pumpshotgun" ,["rotate"] = 0.0},

    [1649403952] =  {["name"] = "Cmp Rifle",          ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_cmp-rifle.png", ["weapon"] = true, ["model"] = "w_ar_assaultrifle" ,["rotate"] = 0.0},
    [125959754] =   {["name"] = "Cmp Launcher",       ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_cmp-launcher.png", ["weapon"] = true, ["model"] = "w_lr_homing" ,["rotate"] = 0.0},


    [2484171525] =  {["name"] = "Cue",                ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_pool-cue.png", ["weapon"] = true, ["model"] = "prop_pool_cue" ,["rotate"] = 90.0},


    [419712736] =   {["name"] = "Wrench",             ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_wrench.png", ["weapon"] = true, ["model"] = "w_me_hammer" ,["rotate"] = 90.0},


    [-581044007] =  {["name"] = "Machete",            ["price"] = 250,    ["weight"] = 11,["nonStack"] = true,["model"] = "", ["image"] = "np_machete.png", ["weapon"] = true, ["model"] = "prop_ld_w_me_machette" ,["rotate"] = 90.0},
}

activeWeaponsCheck = {
	[1] = "WEAPON_MicroSMG",
	[2] = "WEAPON_SMG",
	[3] = "WEAPON_AssaultSMG",
	[4] = "WEAPON_Gusenberg",
	[5] = "WEAPON_AssaultShotgun",
	[6] = "WEAPON_BullpupShotgun",
	[7] = "WEAPON_HeavyShotgun",
	[8] = "WEAPON_Autoshotgun",
	[9] = "WEAPON_SawnoffShotgun",
	[10] = "WEAPON_AssaultRifle",
	[11] = "WEAPON_CarbineRifle",
	[12] = "WEAPON_AdvancedRifle",
	[13] = "WEAPON_SpecialCarbine",
	[14] = "WEAPON_BullpupRifle",
	[15] = "WEAPON_SniperRifle",
	[16] = "WEAPON_HeavySniper",
	[17] = "WEAPON_MarksmanRifle",
	[18] = "WEAPON_Firework",
	[19] = "WEAPON_PetrolCan",
	[20] = "WEAPON_Bat",
	[21] = "WEAPON_Crowbar",
	[22] = "WEAPON_Golfclub",
	[23] = "WEAPON_Hatchet",
	[24] = "WEAPON_Machete",
	[25] = "WEAPON_Poolcue",
	[26] = "WEAPON_Wrench",
	[27] = "WEAPON_PUMPSHOTGUN",
	[28] = "WEAPON_COMBATPDW",
	[29] = "WEAPON_MINISMG",
	[30] = "BULLPUPRIFLE_MK2",
	[31] = "WEAPON_COMBATMG",
	[32] = "WEAPON_RPG",
	[33] = "WEAPON_GRENADELAUNCHER",
}


activeWeapons = {
	[1] = "w_sb_assaultsmg",
	[2] = "w_sb_gusenberg",
	[3] = "w_sb_microsmg",
	[4] = "w_sb_smg",
	[5] = "w_sg_assaultshotgun",
	[6] = "w_sg_bullpupshotgun",
	[7] = "w_sg_heavyshotgun",
	[8] = "w_sg_pumpshotgun",
	[9] = "w_sg_sawnoff",
	[10] = "w_ar_assaultrifle",
	[11] = "w_ar_carbinerifle",
	[12] = "w_ar_advancedrifle",
	[13] = "w_ar_specialcarbine",
	[14] = "w_ar_bullpuprifle",
	[15] = "w_sr_sniperrifle",
	[16] = "w_sr_heavysniper",
	[17] = "w_sr_marksmanrifle",
	[18] = "w_lr_firework",
	[19] = "w_am_jerrycan",
	[20] = "w_me_bat",
	[21] = "w_me_crowbar",
	[22] = "w_me_gclub",
	[23] = "w_me_hatchet",
	[24] = "prop_ld_w_me_machette",
	[25] = "prop_pool_cue",
	[26] = "prop_tool_wrench",
	[27] = "w_sg_pumpshotgun",
	[28] = "w_ar_bullpuprifle",
	[29] = "w_sb_minismg",
	[30] = "w_ar_bullpuprifle",
	[31] = "w_mg_combatmg",
	[32] = "w_lr_rpg",
	[33] = "w_lr_grenadelauncher",
}






weaponNameToHash = { 
	["WEAPON_UNARMED"] = 0xA2719263,
	["WEAPON_ANIMAL"] = 0xF9FBAEBE,
	["WEAPON_COUGAR"] = 0x08D4BE52,
	["WEAPON_KNIFE"] = 0x99B507EA,
	["WEAPON_NIGHTSTICK"] = 0x678B81B1,
	["WEAPON_HAMMER"] = 0x4E875F73,
	["WEAPON_BAT"] =	0x958A4A8F,
	["WEAPON_GOLFCLUB"] =	0x440E4788,
	["WEAPON_CROWBAR"] = 0x84BD7BFD,
	["WEAPON_PISTOL"] = 0x1B06D571,
	["WEAPON_COMBATPISTOL"] = 0x5EF9FEC4,
	["WEAPON_APPISTOL"] = 0x22D8FE39,
	["WEAPON_PISTOL50"] = 0x99AEEB3B,
	["WEAPON_MICROSMG"] = 0x13532244,
	["WEAPON_SMG"] = 0x2BE6766B,
	["WEAPON_ASSAULTSMG"] = 0xEFE7E2DF,
	["WEAPON_ASSAULTRIFLE"] = 0xBFEFFF6D,
	["WEAPON_CARBINERIFLE"] = 0x83BF0278,
	["WEAPON_ADVANCEDRIFLE"] = 0xAF113F99,
	["WEAPON_MG"] = 0x9D07F764,
	["WEAPON_COMBATMG"] = 0x7FD62962,
	["WEAPON_PUMPSHOTGUN"] = 0x1D073A89,
	["WEAPON_SAWNOFFSHOTGUN"] = 0x7846A318,
	["WEAPON_ASSAULTSHOTGUN"] = 0xE284C527,
	["WEAPON_BULLPUPSHOTGUN"] = 0x9D61E50F,
	["WEAPON_STUNGUN"] = 0x3656C8C1,
	["WEAPON_SNIPERRIFLE"] = 0x05FC3C11,
	["WEAPON_HEAVYSNIPER"] = 0x0C472FE2,
	["WEAPON_REMOTESNIPER"] = 0x33058E22,
	["WEAPON_GRENADELAUNCHER"] = 0xA284510B,
	["WEAPON_GRENADELAUNCHER_SMOKE"] = 0x4DD2DC56,
	["WEAPON_RPG"] = 0xB1CA77B1,
	["WEAPON_PASSENGER_ROCKET"] = 0x166218FF,
	["WEAPON_AIRSTRIKE_ROCKET"] = 0x13579279,
	["WEAPON_STINGER"] = 0x687652CE,
	["WEAPON_MINIGUN"] = 0x42BF8A85,
	["WEAPON_GRENADE"] = 0x93E220BD,
	["WEAPON_STICKYBOMB"] = 0x2C3731D9,
	["WEAPON_SMOKEGRENADE"] = 0xFDBC8A50,
	["WEAPON_BZGAS"] = 0xA0973D5E,
	["WEAPON_MOLOTOV"] = 0x24B17070,
	["WEAPON_FIREEXTINGUISHER"] = 0x060EC506,
	["WEAPON_PETROLCAN"] = 0x34A67B97,
	["WEAPON_DIGISCANNER"] = 0xFDBADCED,
	["WEAPON_BRIEFCASE"] = 0x88C78EB7,
	["WEAPON_BRIEFCASE_02"] = 0x01B79F17,
	["WEAPON_BALL"] = 0x23C9F95C,
	["WEAPON_FLARE"] = 0x497FACC3,
	["WEAPON_VEHICLE_ROCKET"] = 0xBEFDC581,
	["WEAPON_BARBED_WIRE"] = 0x48E7B178,
	["WEAPON_DROWNING"] = 0xFF58C4FB,
	["WEAPON_DROWNING_IN_VEHICLE"] = 0x736F5990,
	["WEAPON_BLEEDING"] = 0x8B7333FB,
	["WEAPON_ELECTRIC_FENCE"] = 0x92BD4EBB,
	["WEAPON_EXPLOSION"] = 0x2024F4E8,
	["WEAPON_FALL"] = 0xCDC174B0,
	["WEAPON_EXHAUSTION"] = 0x364A29EC,
	["WEAPON_HIT_BY_WATER_CANNON"] = 0xCC34325E,
	["WEAPON_RAMMED_BY_CAR"] = 0x07FC7D7A,
	["WEAPON_RUN_OVER_BY_CAR"] = 0xA36D413E,
	["WEAPON_HELI_CRASH"] = 0x145F1012,
	["WEAPON_FIRE"] = 0xDF8E89EB,
	["WEAPON_SNSPISTOL"] = 0xBFD21232,
	["WEAPON_BOTTLE"] = 0xF9E6AA4B,
	["WEAPON_GUSENBERG"] = 0x61012683,
	["WEAPON_SPECIALCARBINE"] = 0xC0A3098D,
	["WEAPON_HEAVYPISTOL"] = 0xD205520E,
	["WEAPON_BULLPUPRIFLE"] = 0x7F229F94,
	["WEAPON_DAGGER"] = 0x92A27487,
	["WEAPON_VINTAGEPISTOL"] = 0x083839C4,
	["WEAPON_FIREWORK"] = 0x7F7497E5,
	["WEAPON_MUSKET"] = 0xA89CB99E,
	["WEAPON_HEAVYSHOTGUN"] = 0x3AABBBAA,
	["WEAPON_MARKSMANRIFLE"] = 0xC734385A,
	["WEAPON_HOMINGLAUNCHER"] = 0x63AB0442,
	["WEAPON_PROXMINE"] = 0xAB564B93,
	["WEAPON_SNOWBALL"] = 0x787F0BB,
	["WEAPON_FLAREGUN"] = 0x47757124,
	["WEAPON_GARBAGEBAG"] = 0xE232C28C,
	["WEAPON_HANDCUFFS"] = 0xD04C944D,
	["WEAPON_COMBATPDW"] = 0x0A3D4D34,
	["WEAPON_MARKSMANPISTOL"] = 0xDC4DB296,
	["WEAPON_KNUCKLE"] = 0xD8DF3C3C,
	["WEAPON_HATCHET"] = 0xF9DCBF2D,
	["WEAPON_RAILGUN"] = 0x6D544C99,
	["WEAPON_MACHETE"] = 0xDD5DF8D9,
	["WEAPON_MACHINEPISTOL"] = 0xDB1AA450,
	["WEAPON_AIR_DEFENCE_GUN"] = 0x2C082D7D,
	["WEAPON_SWITCHBLADE"] = 0xDFE37640,
	["WEAPON_REVOLVER"] = 0xC1B3C3D1,
	["WEAPON_DBSHOTGUN"] = 0xEF951FBB ,
	["WEAPON_COMPACTRIFLE"] = 0x624FE830,
	["WEAPON_AUTOSHOTGUN"] = 0x12E82D3D,
	["WEAPON_BATTLEAXE"] = 0xCD274149,
	["WEAPON_COMPACTLAUNCHER"] = 0x0781FE4A,
	["WEAPON_MINISMG"] = 0xBD248B55,
	["WEAPON_PIPEBOMB"] = 0xBA45E8B8,
	["WEAPON_POOLCUE"] = 0x94117305,
	["WEAPON_WRENCH"] = 0x19044EE0	
}







weaponHashToName = { 
	["0xA2719263"] = "WEAPON_UNARMED",
	["0xF9FBAEBE"] = "WEAPON_ANIMAL",
	["0x08D4BE52"] = "WEAPON_COUGAR",
	["0x99B507EA"] = "WEAPON_KNIFE",
	["0x678B81B1"] = "WEAPON_NIGHTSTICK",
	["0x4E875F73"] = "WEAPON_HAMMER",
	["0x958A4A8F"] = "WEAPON_BAT",
	["0x440E4788"] = "WEAPON_GOLFCLUB",
	["0x84BD7BFD"] = "WEAPON_CROWBAR",
	["0x1B06D571"] = "WEAPON_PISTOL",
	["0x5EF9FEC4"] = "WEAPON_COMBATPISTOL",
	["0x22D8FE39"] = "WEAPON_APPISTOL",
	["0x99AEEB3B"] = "WEAPON_PISTOL50",
	["0x13532244"] = "WEAPON_MICROSMG",
	["0x2BE6766B"] = "WEAPON_SMG",
	["0xEFE7E2DF"] = "WEAPON_ASSAULTSMG",
	["0xBFEFFF6D"] = "WEAPON_ASSAULTRIFLE",
	["0x83BF0278"] = "WEAPON_CARBINERIFLE",
	["0xAF113F99"] = "WEAPON_ADVANCEDRIFLE",
	["0x9D07F764"] = "WEAPON_MG",
	["0x7FD62962"] = "WEAPON_COMBATMG",
	["0x1D073A89"] = "WEAPON_PUMPSHOTGUN",
	["0x7846A318"] = "WEAPON_SAWNOFFSHOTGUN",
	["0xE284C527"] = "WEAPON_ASSAULTSHOTGUN",
	["0x9D61E50F"] = "WEAPON_BULLPUPSHOTGUN",
	["0x3656C8C1"] = "WEAPON_STUNGUN",
	["0x05FC3C11"] = "WEAPON_SNIPERRIFLE",
	["0x0C472FE2"] = "WEAPON_HEAVYSNIPER",
	["0x33058E22"] = "WEAPON_REMOTESNIPER",
	["0xA284510B"] = "WEAPON_GRENADELAUNCHER",
	["0x4DD2DC56"] = "WEAPON_GRENADELAUNCHER_SMOKE",
	["0xB1CA77B1"] = "WEAPON_RPG",
	["0x166218FF"] = "WEAPON_PASSENGER_ROCKET",
	["0x13579279"] = "WEAPON_AIRSTRIKE_ROCKET",
	["0x687652CE"] = "WEAPON_STINGER",
	["0x42BF8A85"] = "WEAPON_MINIGUN",
	["0x93E220BD"] = "WEAPON_GRENADE",
	["0x2C3731D9"] = "WEAPON_STICKYBOMB",
	["0xFDBC8A50"] = "WEAPON_SMOKEGRENADE",
	["0xA0973D5E"] = "WEAPON_BZGAS",
	["0x24B17070"] = "WEAPON_MOLOTOV",
	["0x060EC506"] = "WEAPON_FIREEXTINGUISHER",
	["0x34A67B97"] = "WEAPON_PETROLCAN",
	["0xFDBADCED"] = "WEAPON_DIGISCANNER",
	["0x88C78EB7"] = "WEAPON_BRIEFCASE",
	["0x01B79F17"] = "WEAPON_BRIEFCASE_02",
	["0x23C9F95C"] = "WEAPON_BALL",
	["0x497FACC3"] = "WEAPON_FLARE",
	["0xBEFDC581"] = "WEAPON_VEHICLE_ROCKET",
	["0x48E7B178"] = "WEAPON_BARBED_WIRE",
	["0xFF58C4FB"] = "WEAPON_DROWNING",
	["0x736F5990"] = "WEAPON_DROWNING_IN_VEHICLE",
	["0x8B7333FB"] = "WEAPON_BLEEDING",
	["0x92BD4EBB"] = "WEAPON_ELECTRIC_FENCE",
	["0x2024F4E8"] = "WEAPON_EXPLOSION",
	["0xCDC174B0"] = "WEAPON_FALL",
	["0x364A29EC"] = "WEAPON_EXHAUSTION",
	["0xCC34325E"] = "WEAPON_HIT_BY_WATER_CANNON",
	["0x07FC7D7A"] = "WEAPON_RAMMED_BY_CAR",
	["0xA36D413E"] = "WEAPON_RUN_OVER_BY_CAR",
	["0x145F1012"] = "WEAPON_HELI_CRASH",
	["0xDF8E89EB"] = "WEAPON_FIRE",
	["0xBFD21232"] = "WEAPON_SNSPISTOL",
	["0xF9E6AA4B"] = "WEAPON_BOTTLE",
	["0x61012683"] = "WEAPON_GUSENBERG",
	["0xC0A3098D"] = "WEAPON_SPECIALCARBINE",
	["0xD205520E"] = "WEAPON_HEAVYPISTOL",
	["0x7F229F94"] = "WEAPON_BULLPUPRIFLE",
	["0x92A27487"] = "WEAPON_DAGGER",
	["0x083839C4"] = "WEAPON_VINTAGEPISTOL",
	["0x7F7497E5"] = "WEAPON_FIREWORK",
	["0xA89CB99E"] = "WEAPON_MUSKET",
	["0x3AABBBAA"] = "WEAPON_HEAVYSHOTGUN",
	["0xC734385A"] = "WEAPON_MARKSMANRIFLE",
	["0x63AB0442"] = "WEAPON_HOMINGLAUNCHER",
	["0xAB564B93"] = "WEAPON_PROXMINE",
	["0x787F0BB"] = "WEAPON_SNOWBALL",
	["0x47757124"] = "WEAPON_FLAREGUN",
	["0xE232C28C"] = "WEAPON_GARBAGEBAG",
	["0xD04C944D"] = "WEAPON_HANDCUFFS",
	["0x0A3D4D34"] = "WEAPON_COMBATPDW",
	["0xDC4DB296"] = "WEAPON_MARKSMANPISTOL",
	["0xD8DF3C3C"] = "WEAPON_KNUCKLE",
	["0xF9DCBF2D"] = "WEAPON_HATCHET",
	["0x6D544C99"] = "WEAPON_RAILGUN",
	["0xDD5DF8D9"] = "WEAPON_MACHETE",
	["0xDB1AA450"] = "WEAPON_MACHINEPISTOL",
	["0x2C082D7D"] = "WEAPON_AIR_DEFENCE_GUN",
	["0xDFE37640"] = "WEAPON_SWITCHBLADE",
	["0xC1B3C3D1"] = "WEAPON_REVOLVER",
	["0xEF951FBB"] = "WEAPON_DBSHOTGUN",
	["0x624FE830"] = "WEAPON_COMPACTRIFLE",
	["0x12E82D3D"] = "WEAPON_AUTOSHOTGUN",
	["0xCD274149"] = "WEAPON_BATTLEAXE",
	["0x0781FE4A"] = "WEAPON_COMPACTLAUNCHER",
	["0xBD248B55"] = "WEAPON_MINISMG",
	["0xBA45E8B8"] = "WEAPON_PIPEBOMB",
	["0x94117305"] = "WEAPON_POOLCUE",
	["0x19044EE0"] = "WEAPON_WRENCH"	
}


















































hashGunToText = {
['-102973651'] = "Hatchet",
['-1834847097'] = "Dagger",
['-102323637'] = "Glass Bottle",
['-2067956739'] = "Crowbar",
['-656458692'] = "Knuckle Dusters",
['-1786099057'] = "Baseball Bat",

['-102973651'] = "Hatchet",
['-1834847097'] = "Dagger",
['-102323637'] = "Glass Bottle",
['-2067956739'] = "Crowbar",
['-656458692'] = "Knuckle Dusters",
['-1786099057'] = "Baseball Bat",
['-1716189206'] = "Combat Knife",
['-2066285827'] = "Assault SMG",
['-270015777'] = "Bullpup Rifle",
['-1654528753'] = "Bullpup Shotgun",
['-494615257'] = "Auto Shotgun",
['-619010992'] = "Tec 9",
['-2009644972'] = "SNS Pistol",
['-1121678507'] = "Mini SMG",
['2725352035'] = "Unarmed",
['4194021054'] = "Animal",
['148160082'] = "Cougar",
['2578778090'] = "Knife",
['1737195953'] = "Nightstick",
['1317494643'] = "Hammer",
['2508868239'] = "Bat",
['1141786504'] = "Golfclub",
['2227010557'] = "Crowbar",
['453432689'] = "Pistol",
['1593441988'] = "Combat Pistol",
['584646201'] = "AP Pistol",
['2578377531'] = "Deagle",
['324215364'] = "Micro SMG",
['736523883'] = "SMG",
['4024951519'] = "Assault SMG",
['3220176749'] = "Assault Rifle",
['2210333304'] = "Carbine",
['2937143193'] = "Adv Rifle",
['2634544996'] = "MG",
['2144741730'] = "Combat MG",
['487013001'] = "Pump Action",
['2017895192'] = "Sawnoff",
['3800352039'] = "Assault Shotgun",
['2640438543'] = "Bullpup Shotgun",
['911657153'] = "Stun Gun",
['100416529'] = "Sniper",
['205991906'] = "Heavy Sniper",
['856002082'] = "Remote Sniper",
['2726580491'] = "GND Launcher",
['1305664598'] = "GND Launcher SMK",
['2982836145'] = "RPG",
['375527679'] = "Passenger Rocket",
['324506233'] = "Air Rocket",
['1752584910'] = "Stinger",
['1119849093'] = "Minigun",
['2481070269'] = "Grenade",
['741814745'] = "Stick Bomb",
['4256991824'] = "Smoke Grenade",
['2694266206'] = "Bz Gas",
['615608432'] = "Molotov",
['101631238'] = "Fire Ext",
['883325847'] = "Petrol Can",
['4256881901'] = "Digi Scanner",
['2294779575'] = "Briefcase",
['28811031'] = "Briefcase",
['600439132'] = "Ball",
['1233104067'] = "Flare",
['3204302209'] = "Veh Rocket",
['1223143800'] = "Barbed Wire",
['4284007675'] = "Drown",
['1936677264'] = "Drown Vehicle",
['2339582971'] = "Bleeding",
['2461879995'] = "Electric Fence",
['539292904'] = "Explosion",
['3452007600'] = "Fall",
['910830060'] = "Exhaustion",
['3425972830'] = "Water Cannon",
['133987706'] = "Rammed",
['2741846334'] = "Run Over",
['341774354'] = "Heli Crash",
['3750660587'] = "Fire",

----------------DLC Weapons----------------

------------------------------------
['3218215474'] = "SNS Pistol",
['4192643659'] = "Bottle",

------------------------------------
['1627465347'] = "Gusenberg",

------------------------------------
['3231910285'] = "Special Carbine",
['3523564046'] = "Heavy Pistol",

------------------------------------
['2132975508'] = "Bullpup",


------------------------------------
['2460120199'] = "Dagger",
['137902532'] = "Vintage Pistol",


------------------------------------
['2138347493'] = "Firework",
['2828843422'] = "Musket",


------------------------------------
['984333226'] = "Heavy Shotgun",
['3342088282'] = "Mark Rifle",


------------------------------------
['1672152130'] = "Homing Launcher",
['2874559379'] = "Proximity Mine",
['126349499'] = "Snowball",

------------------------------------
['1198879012'] = "Flaregun",
['3794977420'] = "Garbage Bag",
['3494679629'] = "Handcuffs",


------------------------------------
['171789620'] = "Combat PDW",


------------------------------------
['3696079510'] = "Mrk Pistol",
['3638508604'] = "Knuckle",


------------------------------------
['4191993645'] = "Hatchet",
['1834241177'] = "Railgun",


------------------------------------
['3713923289'] = "Machete",
['3675956304'] = "Mac Pistol",


------------------------------------
['738733437'] = "Air Defence",
['3756226112'] = "Switchblade",
['3249783761'] = "Revolver",


------------------------------------
['4019527611'] = "DB Shotgun",
['1649403952'] = "Cmp Rifle",


------------------------------------
['317205821'] = "Auto Shotgun",
['3441901897'] = "Battle Axe",
['125959754'] = "Cmp Launcher",
['3173288789'] = "SMG Mini",
['3125143736'] = "Pipebomb",
['2484171525'] = "Cue",
['419712736'] = "Wrench",
["-581044007"] = "Machete",
}


decimalToName = {
["2725352035"] = "WEAPON_UNARMED",
["4194021054"] = "WEAPON_ANIMAL",
["148160082"] = "WEAPON_COUGAR",
["2578778090"] = "WEAPON_KNIFE",
["-1716189206"] = "WEAPON_KNIFE",
["1737195953"] = "WEAPON_NIGHTSTICK",
["1317494643"] = "WEAPON_HAMMER",
["2508868239"] = "WEAPON_BAT",
["-1786099057"] = "WEAPON_BAT",
["1141786504"] = "WEAPON_GOLFCLUB",
["2227010557"] = "WEAPON_CROWBAR",
["-2067956739"] = "WEAPON_CROWBAR",
["453432689"] = "WEAPON_PISTOL",
["1593441988"] = "WEAPON_COMBATPISTOL",
["584646201"] = "WEAPON_APPISTOL",
["2578377531"] = "WEAPON_PISTOL50",
["432421536"] = "WEAPON_MICROSMG",
["736523883"] = "WEAPON_SMG",
["4024951519"] = "WEAPON_ASSAULTSMG",
["3220176749"] = "WEAPON_ASSAULTRIFLE",
["2210333304"] = "WEAPON_CARBINERIFLE",
["2937143193"] = "WEAPON_ADVANCEDRIFLE",
["2634544996"] = "WEAPON_MG",
["2144741730"] = "WEAPON_COMBATMG",
["487013001"] = "WEAPON_PUMPSHOTGUN",
["2017895192"] = "WEAPON_SAWNOFFSHOTGUN",
["3800352039"] = "WEAPON_ASSAULTSHOTGUN",
["2640438543"] = "WEAPON_BULLPUPSHOTGUN",
["911657153"] = "WEAPON_STUNGUN",
["100416529"] = "WEAPON_SNIPERRIFLE",
["205991906"] = "WEAPON_HEAVYSNIPER",
["856002082"] = "WEAPON_REMOTESNIPER",
["2726580491"] = "WEAPON_GRENADELAUNCHER",
["1305664598"] = "WEAPON_GRENADELAUNCHER_SMOKE",
["2982836145"] = "WEAPON_RPG",
["375527679"] = "WEAPON_PASSENGER_ROCKET",
["324506233"] = "WEAPON_AIRSTRIKE_ROCKET",
["1752584910"] = "WEAPON_STINGER",
["1119849093"] = "WEAPON_MINIGUN",
["2481070269"] = "WEAPON_GRENADE",
["741814745"] = "WEAPON_STICKYBOMB",
["4256991824"] = "WEAPON_SMOKEGRENADE",
["2694266206"] = "WEAPON_BZGAS",
["615608432"] = "WEAPON_MOLOTOV",
["101631238"] = "WEAPON_FIREEXTINGUISHER",
["883325847"] = "WEAPON_PETROLCAN",
["4256881901"] = "WEAPON_DIGISCANNER",
["2294779575"] = "WEAPON_BRIEFCASE",
["28811031"] = "WEAPON_BRIEFCASE_02",
["600439132"] = "WEAPON_BALL",
["1233104067"] = "WEAPON_FLARE",
["3204302209"] = "WEAPON_VEHICLE_ROCKET",
["1223143800"] = "WEAPON_BARBED_WIRE",
["4284007675"] = "WEAPON_DROWNING",
["1936677264"] = "WEAPON_DROWNING_IN_VEHICLE",
["2339582971"] = "WEAPON_BLEEDING",
["2461879995"] = "WEAPON_ELECTRIC_FENCE",
["539292904"] = "WEAPON_EXPLOSION",
["3452007600"] = "WEAPON_FALL",
["910830060"] = "WEAPON_EXHAUSTION",
["3425972830"] = "WEAPON_HIT_BY_WATER_CANNON",
["133987706"] = "WEAPON_RAMMED_BY_CAR",
["2741846334"] = "WEAPON_RUN_OVER_BY_CAR",
["341774354"] = "WEAPON_HELI_CRASH",
["3750660587"] = "WEAPON_FIRE",
["3218215474"] = "WEAPON_SNSPISTOL",
["4192643659"] = "WEAPON_BOTTLE",
["-102323637"] = "WEAPON_BOTTLE",
["1627465347"] = "WEAPON_GUSENBERG",
["3231910285"] = "WEAPON_SPECIALCARBINE",
["3523564046"] = "WEAPON_HEAVYPISTOL",
["2132975508"] = "WEAPON_BULLPUPRIFLE",
["2460120199"] = "WEAPON_DAGGER",
["-1834847097"] = "WEAPON_DAGGER",
["137902532"] = "WEAPON_VINTAGEPISTOL",
["2138347493"] = "WEAPON_FIREWORK",
["2828843422"] = "WEAPON_MUSKET",
["984333226"] = "WEAPON_HEAVYSHOTGUN",
["3342088282"] = "WEAPON_MARKSMANRIFLE",
["1672152130"] = "WEAPON_HOMINGLAUNCHER",
["2874559379"] = "WEAPON_PROXMINE",
["126349499"] = "WEAPON_SNOWBALL",
["1198879012"] = "WEAPON_FLAREGUN",
["3794977420"] = "WEAPON_GARBAGEBAG",
["3494679629"] = "WEAPON_HANDCUFFS",
["171789620"] = "WEAPON_COMBATPDW",
["3696079510"] = "WEAPON_MARKSMANPISTOL",
["3638508604"] = "WEAPON_KNUCKLE",
["-656458692"] = "WEAPON_KNUCKLE",
["4191993645"] = "WEAPON_HATCHET",
["-102973651"] = "WEAPON_HATCHET",
["1834241177"] = "WEAPON_RAILGUN",
["3713923289"] = "WEAPON_MACHETE",
["-581044007"] = "WEAPON_MACHETE",
["3675956304"] = "WEAPON_MACHINEPISTOL",
["738733437"] = "WEAPON_AIR_DEFENCE_GUN",
["3756226112"] = "WEAPON_SWITCHBLADE",
["3249783761"] = "WEAPON_REVOLVER",
["4019527611"] = "WEAPON_DBSHOTGUN",
["1649403952"] = "WEAPON_COMPACTRIFLE",
["317205821"] = "WEAPON_AUTOSHOTGUN",
["3441901897"] = "WEAPON_BATTLEAXE",
["125959754"] = "WEAPON_COMPACTLAUNCHER",
["3173288789"] = "WEAPON_MINISMG",
["3125143736"] = "WEAPON_PIPEBOMB",
["2484171525"] = "WEAPON_POOLCUE",
["419712736"] = "WEAPON_WRENCH"
}






function toName(hash)
	local name = decimalToName[tostring(hash)]
	return tostring(name)
end



-- All Functions based on names , Use To name function to have the hash converted to name 

function findModel(name)
	for i,v in ipairs(weaponList) do
		if name == v.name then
			return v.model
		end
	end
end

