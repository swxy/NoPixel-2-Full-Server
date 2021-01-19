
local ammoTable = {}
local guiOpen = false
local currentWeapons = {}
local selected = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0
}
unholsteringactive = false
local prevupdate = 0
local gunEquipped = false
local armed = false
local sleeploop = false
local policeweapons = {}
local droppedweapons = {}
local currentInformation = 0
local CurrentID = 0
local CurrentSqlID = 0
local TIME_REMOVED_FOR_DEG = 1000 * 60 * 5 -- 5 mins
local focusTaken = false

local weaponTypes = {
    ["2685387236"] =  "Unarmed" ,
    ["3566412244"] =  "Melee" ,
    ["-728555052"] =  "Melee" ,
    ["416676503"] =  "Pistol",
    ["3337201093"] =  "SMG", 
    ["970310034"] =  "AssaultRifle", 
    ["-957766203"] =  "AssaultRifle", 
    ["3539449195"] =  "DigiScanner", 
    ["4257178988"] =  "FireExtinguisher",
    ["1159398588"] =  "MG", 
    ["3493187224"] =  "NightVision",
    ["431593103"] =  "Parachute", 
    ["860033945"] =  "Shotgun", 
    ["3082541095"] =  "Sniper", 
    ["690389602"] =  "Stungun", 
    ["2725924767"] =  "Heavy", 
    ["1548507267"] =  "Thrown", 
    ["1595662460"] =  "PetrolCan", 
}
pullfromback = {
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
}


local throwableWeapons = {}
throwableWeapons["741814745"] = true  
throwableWeapons["741814745"] = true   
throwableWeapons["615608432"] = true   
throwableWeapons["1233104067"] = true  
throwableWeapons["2874559379"] = true  
throwableWeapons["126349499"] = true 
throwableWeapons["3125143736"] = true  
throwableWeapons["-73270376"] = true  


RegisterNUICallback('dropweapon', function(data, cb)

end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

isCop = false
 
RegisterNetEvent('nowCopSpawn')
AddEventHandler('nowCopSpawn', function()
    isCop = true
end)

RegisterNetEvent('nowCopSpawnOff')
AddEventHandler('nowCopSpawnOff', function()
    isCop = false
end)


function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))


    local fov = (1/GetGameplayCamFov())*100
    
    if onScreen then
        SetTextScale(0.2,0.2)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end




local Drops = {}
local allowwait = false



function getDropChance(startingChance)
	local chance = startingChance
	if chance == nil then
		chance = math.random(100)
	end
	if weather == "RAIN" then
		chance = startingChance + 10
	elseif weather == "THUNDER" then
		chance = startingChance + 20
	end
	
	if chance > 95 then chance = 95 end
	return chance
end

AddEventHandler('baseevents:onPlayerKilled', function(killedBy, data)
	if true then
		return
		-- error here, native no workies.
	end
	local victim = source
	local killer = GetPedSourceOfDeath(PlayerPedId())
	if IsPedAPlayer(killer) then
		local weapon = GetSelectedPedWeapon(killer)
		for i,v in ipairs(weaponCheck) do
			if v == weapon then
				local cid = exports["isPed"]:isPed("cid")
				local DNA = "DNA-"..cid
				TriggerServerEvent('Evidence:DNAWeapon',GetPlayerServerId(GetClosestPlayer()),DNA)
			end
		end
	end
end)

weaponCheck = {
	2508868239,
	1141786504,
	2227010557,
	4191993645,
	3713923289,
	2484171525,
	419712736,
	2578778090,
	1737195953,
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

function randPickupAnim()
  local randAnim = math.random(7)

  if randAnim == 1 then
    loadAnimDict('missfbi_s4mop')
    TaskPlayAnim(PlayerPedId(),'missfbi_s4mop', 'pickup_bucket_0',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
  elseif randAnim == 2 then
    loadAnimDict('pickup_object')
    TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
  elseif randAnim == 3 then
    loadAnimDict('missheist_agency2aig_13')
    TaskPlayAnim(PlayerPedId(),'missheist_agency2aig_13', 'pickup_briefcase',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
  elseif randAnim == 4 then
    loadAnimDict('pickup_object')
    TaskPlayAnim(PlayerPedId(),'pickup_object', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
  elseif randAnim == 5 then
    loadAnimDict('random@atmrobberygen')
    TaskPlayAnim(PlayerPedId(),'random@atmrobberygen', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
  elseif randAnim == 6 then
    loadAnimDict('pickup_object')
    TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
  elseif randAnim == 7 then
    loadAnimDict('random@domestic')
    TaskPlayAnim(PlayerPedId(),'random@domestic', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
  end
end


RegisterNetEvent('RemoveServiceWeapons')
AddEventHandler('RemoveServiceWeapons', function()
	policeweapons = {}

end)

RegisterNetEvent('GiveWeaponToPed')
AddEventHandler('GiveWeaponToPed', function(hash,name)


end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(jobpassed, name, notify)
	job = jobpassed
    if not job then
        job = "None"
    end
    if job ~= "police" and job ~= "ems" then
    	policeweapons = {}
    end
end)


function WeaponSlot(hash)
    local strHash = "" .. GetWeapontypeGroup(hash) .. ""
    if weaponTypes[strHash] then
        return weaponTypes[strHash]["slot"]
    else
        return 4
    end
end



RegisterNetEvent('np-items:SetAmmo')
AddEventHandler('np-items:SetAmmo', function(sentammoTable)
	if sentammoTable ~= nil then
		ammoTable = sentammoTable
		GiveAmmoNow()
		Wait(300)
	end
end)

function GiveAmmoNow()
	for i,v in pairs(ammoTable) do
		for x,b in pairs(v) do
			SetPedAmmoByType(PlayerPedId(), v.type, v.ammo)
		end
	end
end

local displaycounter = 0

local shieldActive = false
local shieldEntity = nil
local hadPistol = false

-- ANIM
local animDict = "combat@gestures@gang@pistol_1h@beckon"
local animName = "0"

local prop = "prop_ballistic_shield"
local pistol = `WEAPON_PISTOL`




local lastWeaponDeg = 0
function attemptToDegWeapon()
	if math.random(100) > 85 then
		local hasTimer = 99999
		hasTimer = (GetGameTimer()-lastWeaponDeg)

		if  hasTimer >= 2000 then
			lastWeaponDeg = GetGameTimer();
			TriggerServerEvent("inventory:degItem",CurrentSqlID)
		end
	end
end

Controlkey = {["actionBar"] = {37,"TAB"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["actionBar"] = table["actionBar"]
end)

Citizen.CreateThread( function()

	while true do
		Citizen.Wait(1)
		
		local ped = PlayerPedId()

		if IsPedShooting(ped) then
			local hash = GetSelectedPedWeapon(ped)
			local ammoType = Citizen.InvokeNative(0x7FEAD38B326B9F74, ped, hash)
			newammo = GetPedAmmoByType(ped, ammoType)
			if newammo < 5 then
				updateAmmo()
			end

			attemptToDegWeapon()

			local weapon = "".. hash ..""
			if throwableWeapons[weapon] then
				if exports["np-inventory"]:hasEnoughOfItem(weapon,1,false) then
					TriggerEvent("inventory:removeItem", weapon, 1)
					Citizen.Wait(3000)
				end
			end

		end

		if unholsteringactive then
			DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
		end


		prevupdate = prevupdate - 1

		if (IsControlJustReleased(0,157) or IsDisabledControlJustReleased(0,157)) and not focusTaken then
			TriggerEvent("inventory-bind",1)
		end

		if (IsControlJustReleased(0,158) or IsDisabledControlJustReleased(0,158)) and not focusTaken then
			TriggerEvent("inventory-bind",2)
		end

		if (IsControlJustReleased(0,160) or IsDisabledControlJustReleased(0,160)) and not focusTaken then
			TriggerEvent("inventory-bind",3)
		end

		if (IsControlJustReleased(0,164) or IsDisabledControlJustReleased(0,164)) and not focusTaken then
			TriggerEvent("inventory-bind",4)
		end

		if (IsControlJustPressed(0,Controlkey["actionBar"][1]) or IsDisabledControlJustPressed(0,Controlkey["actionBar"][1])) and not focusTaken then
			TriggerEvent("inventory-bar",true)
		end

		if (IsControlJustReleased(0,Controlkey["actionBar"][1]) or IsDisabledControlJustReleased(0,Controlkey["actionBar"][1])) and not focusTaken then
			TriggerEvent("inventory-bar",false)
		end

		if `WEAPON_UNARMED` ~= GetSelectedPedWeapon(PlayerPedId()) then
			DisplayAmmoThisFrame(true)
		end

		if IsPedPlantingBomb(ped) then
			if exports["np-inventory"]:hasEnoughOfItem("741814745",1,false) then

				TriggerEvent("inventory:removeItem", 741814745, 1)
				Citizen.Wait(3000)
			end
		end

	end

end)

function helpDisplay(text, state)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

RegisterNUICallback('equipweapon', function(data, cb)
	equipWeaponID(data.saveid)
end)

lasthash = 0
lastslot = 2

AddEventHandler("np:voice:focus:set", function(pState)
  focusTaken = pState
end)

RegisterNetEvent('equipWeaponID')
AddEventHandler('equipWeaponID', function(hash,newInformation,sqlID)
	--GiveAmmoNow()
	
	CurrentSqlID = sqlID
	currentInformation = json.decode(newInformation)

	


	if (currentInformation.cartridge == nil) then
		currentInformation = "Scratched off data"
	else
		currentInformation = currentInformation.cartridge
	end
	TriggerEvent("evidence:bulletInformation", currentInformation)

	local dead = exports["isPed"]:isPed("dead")
	if dead then
		return
	end

	if `WEAPON_UNARMED` == GetSelectedPedWeapon(PlayerPedId()) then
		armed = false
	end

	if armed then
		armed = false
		TriggerEvent("hud-display-item",tonumber(hash),"Holster")
		holster1h()		
	else
		armed = true
		TriggerEvent("hud-display-item",tonumber(hash),"Equip")
		unholster1h(tonumber(hash),true)
	end	


	SetPedAmmo(PlayerPedId(),  `WEAPON_FIREEXTINGUISHER`, 10000)
	SetPedAmmo(PlayerPedId(),  `WEAPON_PetrolCan`, 10000)

end)

RegisterNetEvent('brokenWeapon')
AddEventHandler('brokenWeapon', function()

	local dead = exports["isPed"]:isPed("dead")
	if dead then
		return
	end


	holster1h()
	armed = false

	SetPedAmmo(PlayerPedId(),  `WEAPON_FIREEXTINGUISHER`, 10000)
	SetPedAmmo(PlayerPedId(),  `WEAPON_PetrolCan`, 10000)

end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function ammoTypeCheck(atype)
	if type(atype) == "number" then
		if ammoTable["" .. atype .. ""] == nil then
			ammoTable["" .. atype .. ""] = {}
			ammoTable["" .. atype .. ""]["ammo"] = 0
			ammoTable["" .. atype .. ""]["type"] = atype
		end
	end
end



RegisterNetEvent('actionbar:ammo')
AddEventHandler('actionbar:ammo', function(hash,amount,addition)

	local ped = PlayerPedId()
	local ammoType = hash
	ammoTypeCheck(ammoType)

	if ammoTable == nil then
		TriggerServerEvent("np-weapons:getAmmo")
		Citizen.Wait(2000)
	end

	if ammoTable["" .. ammoType .. ""] == nil then
		TriggerServerEvent("np-weapons:getAmmo")
		Citizen.Wait(2000)
	end

	curAmmo = ammoTable["" .. ammoType .. ""]["ammo"]

	if curAmmo == nil then
		ammoTable["" .. ammoType .. ""]["ammo"] = 0
	end

	if addition then
	    newammo = tonumber(curAmmo) + tonumber(amount)
	else
		newammo = tonumber(curAmmo) - tonumber(amount)
	end

	if (curAmmo == newammo) then
		newammo = newammo + 30
	end


	if newammo > 150 then
   		newammo = 150
    elseif newammo < 0 then
    	newammo = 0
    end

    ammoTable["" .. ammoType .. ""]["ammo"] = newammo

    SetPedAmmoByType(PlayerPedId(), ammoType, newammo)

    prevupdate = 0
   	updateAmmo()
end)

RegisterNetEvent('armory:ammo')
AddEventHandler('armory:ammo', function()
	TriggerEvent("actionbar:ammo",1950175060,150,true)
	TriggerEvent("actionbar:ammo",218444191,150,true)
	TriggerEvent("actionbar:ammo",-1878508229,150,true)
	TriggerEvent("actionbar:ammo",1820140472,150,true)
end)


function updateAmmoClient()

	local ped = PlayerPedId()
	local hash = GetSelectedPedWeapon(ped)
	local newammo = 0
	local ammoType = Citizen.InvokeNative(0x7FEAD38B326B9F74, ped, hash)

	if type(ammoType) == 'number' then 

		ammoTypeCheck(ammoType)

	    newammo = GetPedAmmoByType(ped, ammoType)
		if newammo == nil then
			newammo = 0
		end
		if newammo > 150 then
			newammo = 150
		end
		if newammo < 7 then
			newammo = 0
		end
		ammoTable["" .. ammoType .. ""]["ammo"] = newammo
	end

	TriggerEvent("np-items:SetAmmo",ammoTable)
end

function updateAmmoNow()

	local ped = PlayerPedId()
	local hash = GetSelectedPedWeapon(ped)
	local newammo = 0
	local ammoType = Citizen.InvokeNative(0x7FEAD38B326B9F74, ped, hash)


	if type(ammoType) == 'number' then 

		ammoTypeCheck(ammoType)

	    newammo = GetPedAmmoByType(ped, ammoType)
		if newammo == nil then
			newammo = 0
		end
		if newammo > 150 then
			newammo = 150
		end
		if newammo < 2 then
			newammo = 0
		end
		ammoTable["" .. ammoType .. ""]["ammo"] = newammo

		if newammo > 150 then
			newammo = 150
		end

		TriggerServerEvent("np-weapons:updateAmmo",newammo,ammoType,ammoTable)

	end

	return newammo
end

RegisterNetEvent('actionbar:setEmptyHanded')
AddEventHandler('actionbar:setEmptyHanded', function()
	prevupdate = 0
	updateAmmo()
	Wait(500)
	SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
end)



function updateAmmo()

	if prevupdate > 0 then
		return
	end

	prevupdate = 5
	local ped = PlayerPedId()
	local hash = GetSelectedPedWeapon(ped)
	local newammo = 0
	local ammoType = Citizen.InvokeNative(0x7FEAD38B326B9F74, ped, hash)

	if type(ammoType) == 'number' then 

		ammoTypeCheck(ammoType)

	    newammo = GetPedAmmoByType(ped, ammoType)
		if newammo == nil then
			newammo = 0
		end
		if newammo > 150 then
			newammo = 150
		end
		if newammo < 2 then
			newammo = 0
		end
		ammoTable["" .. ammoType .. ""]["ammo"] = newammo

		if newammo > 150 then
			newammo = 150
		end

		TriggerServerEvent("np-weapons:updateAmmo",newammo,ammoType,ammoTable)

	end

	return newammo
end


function getAmmo(hash)
	if (throwableWeapons[""..hash..""]) then
    	return 1
    end

	local ped = PlayerPedId()
	local ammoType = Citizen.InvokeNative(0x7FEAD38B326B9F74, ped, hash)
	local newammo = 0

	if type(ammoType) == "number" then
		ammoTypeCheck(ammoType)
		newammo = ammoTable["" .. ammoType .. ""]["ammo"]
	end

	if newammo > 150 then
		newammo = 150
	end

	return newammo
end

RegisterNetEvent('np-item:CheckClientAmmo')
AddEventHandler('np-item:CheckClientAmmo', function(weapons)
	local ped = PlayerPedId()
	local ammoType = Citizen.InvokeNative(0x7FEAD38B326B9F74, ped, weapons)
	local newammo = 0

	ammoTypeCheck(ammoType)

	if type(ammoType) == "number" then
		ammoTypeCheck(ammoType)
		newammo = ammoTable["" .. ammoType .. ""]["ammo"]
	end


end)

local weaponTypes = {
    ["2685387236"] = { "Unarmed", ["slot"] = 0 },
    ["3566412244"] = { "Melee", ["slot"] = 1 },
    ["-728555052"] = { "Melee", ["slot"] = 1 },
    ["416676503"] = { "Pistol", ["slot"] = 2 },
    ["3337201093"] = { "SMG", ["slot"] = 3 },
    ["970310034"] = { "AssaultRifle", ["slot"] = 4 },
    ["-957766203"] = { "AssaultRifle", ["slot"] = 4 },
    ["3539449195"] = { "DigiScanner", ["slot"] = 4 },
    ["4257178988"] = { "FireExtinguisher", ["slot"] = 0 },
    ["1159398588"] = { "MG", ["slot"] = 4 },
    ["3493187224"] = { "NightVision", ["slot"] = 0 },
    ["431593103"] = { "Parachute", ["slot"] = 0 },
    ["860033945"] = { "Shotgun", ["slot"] = 3 },
    ["3082541095"] = { "Sniper", ["slot"] = 3 },
    ["690389602"] = { "Stungun", ["slot"] = 1 },
    ["2725924767"] = { "Heavy", ["slot"] = 4 },
    ["1548507267"] = { "Thrown", ["slot"] = 0 },
    ["1595662460"] = { "PetrolCan", ["slot"] = 1 }
}

function unholster1h(weaponHash)

	unholsteringactive = true

	local dict = "reaction@intimidation@1h"
	local anim = "intro"
	local myJob = exports["isPed"]:isPed("myJob")
	local ped = PlayerPedId()

	if myJob == "police" then
		copunholster(weaponHash)

	    if weaponHash == 3219281620 then
			GiveWeaponComponentToPed(PlayerPedId(), 3219281620, `COMPONENT_AT_PI_FLSH_02` )
	    end


	    if weaponHash == 736523883 then
			GiveWeaponComponentToPed( ped, 736523883, `COMPONENT_AT_AR_FLSH` )
			GiveWeaponComponentToPed( ped, 736523883, `COMPONENT_AT_SCOPE_MACRO_02` )	
	    end

	    if weaponHash == -2084633992 then
			GiveWeaponComponentToPed( ped, -2084633992, `COMPONENT_AT_AR_FLSH` )
			GiveWeaponComponentToPed( ped, -2084633992, `COMPONENT_AT_AR_AFGRIP` )
			GiveWeaponComponentToPed( ped, -2084633992, `COMPONENT_AT_SCOPE_MEDIUM` )
	    end
	    if weaponHash == 1432025498 then
			GiveWeaponComponentToPed( ped, 1432025498, `COMPONENT_AT_SCOPE_MACRO_MK2` )
			GiveWeaponComponentToPed( ped, 1432025498, `COMPONENT_AT_AR_FLSH` )

	    end

	    if weaponHash == 2024373456 then
			GiveWeaponComponentToPed( ped, 2024373456, `COMPONENT_AT_AR_FLSH` )
			GiveWeaponComponentToPed( ped, 2024373456, `COMPONENT_AT_SIGHTS_SMG` )	
			GiveWeaponComponentToPed( ped, 2024373456, `COMPONENT_AT_MUZZLE_01` )
			GiveWeaponComponentToPed( ped, 2024373456, `COMPONENT_AT_SB_BARREL_02` )	
	    end

	    if weaponHash == -86904375 then
	    	GiveWeaponComponentToPed( ped, -86904375, `COMPONENT_AT_AR_FLSH` )
	    	GiveWeaponComponentToPed( ped, -86904375, `COMPONENT_AT_SIGHTS` )
	    end

	    if weaponHash == -1075685676 then
	    	GiveWeaponComponentToPed( ped, -1075685676, `COMPONENT_AT_PI_FLSH_02` )
	    end  

		AttachmentCheck(weaponHash)
		
	    Citizen.Wait(450)
	    unholsteringactive = false
		return
	end	

	RemoveAllPedWeapons(ped)

	if weaponHash ~= -538741184 and weaponHash ~= 615608432 then
		local animLength = GetAnimDuration(dict, anim) * 1000
	    loadAnimDict(dict) 
	    TaskPlayAnim(ped, dict, anim, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
	    Citizen.Wait(900)
	    GiveWeaponToPed(ped, weaponHash, getAmmo(weaponHash), 0, 1)
	     SetCurrentPedWeapon(ped, weaponHash, 1)
	else
		GiveWeaponToPed(ped, weaponHash, getAmmo(weaponHash), 1, 0)
		 SetCurrentPedWeapon(ped, weaponHash, 0)
	end
    

   
    AttachmentCheck(weaponHash)
    Citizen.Wait(500)
    
    ClearPedTasks(ped)
    Citizen.Wait(1200)
    
    unholsteringactive = false

end



function AttachmentCheck(weaponhash)

	if exports["np-inventory"]:hasEnoughOfItem("silencer_l",1,false) then
		GiveWeaponComponentToPed( PlayerPedId(), weaponhash, `COMPONENT_AT_AR_SUPP` )
	end

	if exports["np-inventory"]:hasEnoughOfItem("silencer_l2",1,false) then
		GiveWeaponComponentToPed( PlayerPedId(), weaponhash, `COMPONENT_AT_AR_SUPP_02` )
	end

	if exports["np-inventory"]:hasEnoughOfItem("silencer_s",1,false) then
		GiveWeaponComponentToPed( PlayerPedId(), weaponhash, `COMPONENT_AT_PI_SUPP` )
	end

	if exports["np-inventory"]:hasEnoughOfItem("silencer_s2",1,false) then
		GiveWeaponComponentToPed( PlayerPedId(), weaponhash, `COMPONENT_AT_PI_SUPP_02` )	
	end

	if exports["np-inventory"]:hasEnoughOfItem("extended_ap",1,false) then
		GiveWeaponComponentToPed( PlayerPedId(), weaponhash, `COMPONENT_APPISTOL_CLIP_02` )	
	end

	if exports["np-inventory"]:hasEnoughOfItem("extended_sns",1,false) then
		GiveWeaponComponentToPed( PlayerPedId(), weaponhash, `COMPONENT_SNSPISTOL_CLIP_02` )	
	end

	if exports["np-inventory"]:hasEnoughOfItem("extended_micro",1,false) then
		GiveWeaponComponentToPed( PlayerPedId(), weaponhash, `COMPONENT_MICROSMG_CLIP_02` )	
	end

	if exports["np-inventory"]:hasEnoughOfItem("MediumScope",1,false) then
		GiveWeaponComponentToPed( PlayerPedId(), weaponhash, `COMPONENT_AT_SCOPE_MEDIUM` )	
	end

	if exports["np-inventory"]:hasEnoughOfItem("SmallScope",1,false) then
		GiveWeaponComponentToPed( PlayerPedId(), weaponhash, `COMPONENT_AT_SCOPE_SMALL` )	
	end


	if exports["np-inventory"]:hasEnoughOfItem("TinyScope",1,false) then
		GiveWeaponComponentToPed( PlayerPedId(), weaponhash, `COMPONENT_AT_SCOPE_MACRO` )	
	end

	if exports["np-inventory"]:hasEnoughOfItem("extended_tec9",1,false) then
		GiveWeaponComponentToPed( PlayerPedId(), weaponhash, `COMPONENT_MACHINEPISTOL_CLIP_02` )	
	end




end


function copunholster(weaponHash)
  local dic = "reaction@intimidation@cop@unarmed"
  local anim = "intro"
  local ammoCount = 0
   loadAnimDict( dic ) 

	local ped = PlayerPedId()
	RemoveAllPedWeapons(ped)

	TaskPlayAnim(ped, dic, anim, 10.0, 2.3, -1, 49, 1, 0, 0, 0 )

	Citizen.Wait(600)

    GiveWeaponToPed(ped, weaponHash, getAmmo(weaponHash), 0, 1)
	
	SetCurrentPedWeapon(ped, weaponHash, 1)
	ClearPedTasks(ped)

end

function copholster()

  local dic = "reaction@intimidation@cop@unarmed"
  local anim = "intro"
  local ammoCount = 0
   loadAnimDict( dic ) 

	local ped = PlayerPedId()
	prevupdate = 0
	updateAmmo()

	TaskPlayAnim(ped, dic, anim, 10.0, 2.3, -1, 49, 1, 0, 0, 0 )

	Citizen.Wait(600)
	SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, 1)
	RemoveAllPedWeapons(ped)
	ClearPedTasks(ped)
end
function holster1h()
	unholsteringactive = true
	local dict = "reaction@intimidation@1h"
	local anim = "outro"
	local myJob = exports["isPed"]:isPed("myJob")
	if myJob == "police" then
		copholster()
		Citizen.Wait(600)
		unholsteringactive = false
		return
	end
	local ped = PlayerPedId()
	prevupdate = 0
	updateAmmo()
	local animLength = GetAnimDuration(dict, anim) * 1000
    loadAnimDict(dict) 
    TaskPlayAnim(ped, dict, anim, 1.0, 1.0, -1, 50, 0, 0, 0, 0)   
    Citizen.Wait(animLength - 2200)
    
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, 1)
    Citizen.Wait(300)
    RemoveAllPedWeapons(ped)
    ClearPedTasks(ped)
    Citizen.Wait(800)
    unholsteringactive = false
end

function holster2h(weaponHash)
	unholsteringactive = true
	local dict = "amb@world_human_golf_player@male@idle_a"
	local anim = "idle_a"
	local ped = PlayerPedId()
	prevupdate = 0
    loadAnimDict(dict) 
    updateAmmo()
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, 1)
    TriggerEvent("attachWeaponPull",weaponHash,true)
    TaskPlayAnim(ped, dict, anim, 1.5, 1.5, -1, 49, 10, 0, 0, 0)   
    Citizen.Wait(1200)  
    RemoveAllPedWeapons(ped)
    ClearPedTasks(ped)
    Citizen.Wait(500)
    unholsteringactive = false
end

function grab2h(weaponHash)
	unholsteringactive = true
	local dict = "amb@world_human_golf_player@male@idle_a"
	local anim = "idle_a"
	local ped = PlayerPedId()
	RemoveAllPedWeapons(ped)
    loadAnimDict(dict) 
    TaskPlayAnim(ped, dict, anim, 1.5, 1.5, -1, 49, 10, 0, 0, 0)   
    Citizen.Wait(1100)
    TriggerEvent("attachWeaponPull",weaponHash,false)
    ClearPedTasks(ped)
    Citizen.Wait(650)
    GiveWeaponToPed(ped, weaponHash, getAmmo(weaponHash), 0, 1)
	SetCurrentPedWeapon(ped, weaponHash, 1)
    ClearPedTasks(ped)

    local myJob = exports["isPed"]:isPed("myJob")
	if myJob == "police" then
	    if weaponHash == 2210333304 then
			GiveWeaponComponentToPed( ped, 2210333304, `COMPONENT_AT_AR_FLSH` )
			GiveWeaponComponentToPed( ped, 2210333304, `COMPONENT_AT_AR_AFGRIP_02` )
			GiveWeaponComponentToPed( ped, 2210333304, `COMPONENT_AT_SCOPE_MEDIUM` )
			GiveWeaponComponentToPed( ped, 2210333304, `COMPONENT_AT_AR_SUPP_02` )   	
	    end
	   
	    Citizen.Wait(600)

    	unholsteringactive = false
		return
	end

    Citizen.Wait(600)

    unholsteringactive = false
end
