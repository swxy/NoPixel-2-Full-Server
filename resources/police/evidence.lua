CurrentDamageList = {}
CurrentLocationList = {}
StoringEnabled = true
local bonesTarget = {}
local curfading = 0
local myboneActive = false
lasthealth = GetEntityHealth(PlayerPedId())
lastarmor = GetPedArmour(PlayerPedId())
lasthealth2 = lasthealth

local armsdisabled = false
local injured = false
local maxfade = 0.0
local animEnabled = false
local bonesUpdatingServer = false
local clipchanged = false
local isBleeding = false
local bleedLevel = 0
local setBleedLevel = 0
local inbed = false
local injurycount = 0
local passingout = false
local legsdisabled = false
local healTargetBoneId = 0
local healing = false
local targetidsend = 0
local pulse = 0
local pulseUp = true
local denoms = true

local bleeddamage = false
local bleeddamage2 = false
-- Add custom statuses and effects to players here
-- Example - Red Hands for 300 seconds after a melee fight.
-- TriggerEvent("Evidence:StateSet",9,1200)


stresslevel = 0
Currentstates = {
	[1] = { ["text"] = "Red Hands", ["status"] = false, ["timer"] = 0 },
	[2] = { ["text"] = "Dilated Eyes", ["status"] = false, ["timer"] = 0 },
	[3] = { ["text"] = "Red Eyes", ["status"] = false, ["timer"] = 0 },
	[4] = { ["text"] = "Smells Like Marijuana", ["status"] = false, ["timer"] = 0 },
	[5] = { ["text"] = "Fresh Bandaging", ["status"] = false, ["timer"] = 0 },
	[6] = { ["text"] = "Agitated", ["status"] = false, ["timer"] = 0 },
	[7] = { ["text"] = "Uncoordinated", ["status"] = false, ["timer"] = 0 },
	[8] = { ["text"] = "Breath smells like Alcohol", ["status"] = false, ["timer"] = 0 },
	[9] = { ["text"] = "Smells like Gasoline", ["status"] = false, ["timer"] = 0 },
	[10] = { ["text"] = "Red Gunpowder Residue", ["status"] = false, ["timer"] = 0 },
	[11] = { ["text"] = "Smells of Chemicals", ["status"] = false, ["timer"] = 0 },
	[12] = { ["text"] = "Smells of Oil / Metalwork", ["status"] = false, ["timer"] = 0 },
	[13] = { ["text"] = "Ink Stained Hands", ["status"] = false, ["timer"] = 0 },
	[14] = { ["text"] = "Smells like smoke.", ["status"] = false, ["timer"] = 0 },
	[15] = { ["text"] = "Has camping equipment.", ["status"] = false, ["timer"] = 0 },
	[16] = { ["text"] = "Smells like burnt Aluminum and iron.", ["status"] = false, ["timer"] = 0 },
	[17] = { ["text"] = "Has metal specs on clothing.", ["status"] = false, ["timer"] = 0 },
	[18] = { ["text"] = "Smells Like Cigarette Smoke.", ["status"] = false, ["timer"] = 0 },
	[19] = { ["text"] = "Labored Breathing.", ["status"] = false, ["timer"] = 0 },
	[20] = { ["text"] = "Body Sweat.", ["status"] = false, ["timer"] = 0 },
	[21] = { ["text"] = "Clothing Sweat.", ["status"] = false, ["timer"] = 0 },	
    [22] = { ["text"] = "Wire Cuts.", ["status"] = false, ["timer"] = 0 },
	[23] = { ["text"] = "Saturated Clothing.", ["status"] = false, ["timer"] = 0 },		
    [24] = { ["text"] = "Looks Dazed.", ["status"] = false, ["timer"] = 0 },
    [25] = { ["text"] = "Looks Well Fed.", ["status"] = false, ["timer"] = 0 },
    [26] = { ["text"] = "Has scratches on hands.", ["status"] = false, ["timer"] = 0 }, 
    [27] = { ["text"] = "Looks Alert.", ["status"] = false, ["timer"] = 0 }, 
}

BAL = 0
METHL = 0
WEEDL = 0




HudStage = 1
RegisterNetEvent("disableHUD")
AddEventHandler("disableHUD", function(passedinfo)
  HudStage = passedinfo
end)
hasdenoms = false
RegisterNetEvent("denoms")
AddEventHandler("denoms", function(denomsp)
    if not hasdenoms and not denomsp then
        return
    end
  hasdenoms = denomsp
  if hasdenoms then
    TriggerEvent('chatMessage', 'STATUS: ', 1, "Your currency has Multiple Denominations" )
  else
    TriggerEvent('chatMessage', 'STATUS: ', 1, "Your currency no longer has Multiple Denominations" )
  end
end)


shieldActive = false
RegisterNetEvent('shieldLoadout')
AddEventHandler('shieldLoadout', function()
    if shieldActive then
        shieldActive = false
    else
        shieldActive = true
    end
end)

RegisterNetEvent("Evidence:StateSet")
AddEventHandler("Evidence:StateSet",function(stateId,stateLength)
	if Currentstates[stateId]["timer"] < 10 and stateLength ~= 0 then
		TriggerEvent('chatMessage', 'STATUS: ', 1, Currentstates[stateId]["text"])
	end
	Currentstates[stateId]["timer"] = stateLength
end)
heavybleed = false
lightbleed = false
lightestbleed = false
initialbleed = false
Citizen.CreateThread(function()

    while true do
        Citizen.Wait(10000)
        for i = 1, #Currentstates do
        	if Currentstates[i]["timer"] > 0 then
        		Currentstates[i]["timer"] = Currentstates[i]["timer"] - 10
	        	if Currentstates[i]["timer"] < 0 then
	        		Currentstates[i]["timer"] = 0
	        	end
        	end
        end

    end
end)
armor = false


isCop = false
 
RegisterNetEvent('nowCopSpawn')
AddEventHandler('nowCopSpawn', function()
    isCop = true
end)

RegisterNetEvent('nowCopSpawnOff')
AddEventHandler('nowCopSpawnOff', function()
    isCop = false
end)

-- tier 1 bleed
tier1 = {
    ["37193"] = true,
    ["31086"] = true,
    ["39317"] = true,
    ["47495"] = true,
    ["61839"] = true,
    ["20623"] = true,
    ["21550"] = true,
    ["19336"] = true,
}
-- 
tier2 = {
    ["10706"] = true,
    ["64729"] = true,
    ["11816"] = true,
    ["58271"] = true,
    ["51826"] = true,
    ["24816"] = true,
    ["24817"] = true,
    ["24818"] = true,
}
local bleedmulti = 1

function bleedMulti(WeaponValue)

    local injured,part = GetPedLastDamageBone( PlayerPedId() )  
    if tier1[""..part..""] then

        Wait(2000)
        if WeaponValue == 1 then
            initialbleed = true
        end
        bleedmulti = math.ceil(2 * WeaponValue)
    end

    if tier2[""..part..""] then
        bleedmulti = WeaponValue
    end  

    if healing then
        bleedmulti = bleedmulti / 2
    end

    if bleedmulti == WeaponValue then
        bleedmulti = 1
    end
end

bleedcount = 0
function bulletUpdate()
    for i = 1, #InjuryList do
        if HasPedBeenDamagedByWeapon(PlayerPedId(), GetHashKey(InjuryList[i][1]),0) then
            bleedmulti = 1       
            if not lightestbleed and (GetWeapontypeGroup(GetHashKey(InjuryList[i][1])) == 970310034 or GetWeapontypeGroup(GetHashKey(InjuryList[i][1])) == 416676503 or GetWeapontypeGroup(GetHashKey(InjuryList[i][1])) == -957766203 or GetWeapontypeGroup(GetHashKey(InjuryList[i][1])) == 860033945) then
                lightestbleed = true
                bleedMulti(1)
                bleedcount = 120
                myBleeds()
            end 
        end
    end
end


function updateStates()

	if not StoringEnabled then
		return
	end

	CurrentDamageList = {}
	for i = 1, #InjuryList do
		if HasPedBeenDamagedByWeapon(PlayerPedId(), GetHashKey(InjuryList[i][1]),0) then
			table.insert( CurrentDamageList, InjuryList[i][3] )
		end
	end

    for i = 1, #Currentstates do
    	if Currentstates[i]["timer"] > 0 then
    		local msg = Currentstates[i]["text"] .. " " 
	    	if Currentstates[i]["timer"] > 360 then
	    		msg = msg .. "(Very noticable)"
	    	elseif Currentstates[i]["timer"] > 180 then
	    		msg = msg .. "(Noticable)"
	    	elseif Currentstates[i]["timer"] > 60 then
	    		msg = msg .. "(Very light)"
	    	end
	    	 CurrentDamageList[# CurrentDamageList+1]= msg
	    end
    end

    if GetPedArmour(PlayerPedId()) > 1 and armor then
	    table.insert( CurrentDamageList, "Is wearing body armor." )
	elseif armor then
		armor = false
	end
end



RegisterNetEvent("UseBodyArmor")
AddEventHandler("UseBodyArmor", function()
    armor = true
    lastarmor = GetPedArmour(PlayerPedId())
    lasthealth = GetEntityHealth(PlayerPedId())
    lasthealth2 = lasthealth  
    TriggerEvent("hud:saveCurrentMeta")  
end)

local healing = false
RegisterNetEvent("ems:healpassed")
AddEventHandler("ems:healpassed", function()
    HealSlow()
end)

function HealSlow()
    if not healing then
        healing = true
    else
        return
    end
    
    local count = 30
    while count > 0 do
        Citizen.Wait(1000)
        count = count - 1
        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 1) 
    end

    if math.random(100) > 80 and bleedcount > 0 then
        bleedcount = 0
    end
    initialbleed = false
    healing = false
end

function myBleeds()
    bleedcount = bleedcount - 1
    bleeddamage2 = true

    if not initialbleed and math.random(100) < 20 then
        if lightbleed or heavybleed or lightestbleed then
            TriggerEvent("DoLongHudText","You notice blood oozing from your body the more you move.",2)
            SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) - bleedmulti)
        end
    end

    if initialbleed then
        TriggerEvent("DoLongHudText","You notice blood oozing from your body the more you move.",2)
        for i = 1, 7 do
             if lightbleed or heavybleed or lightestbleed then
                SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) - bleedmulti)
                Citizen.Wait(350)
            end
        end
    end

    bleeddamage2 = false

    initialbleed = false
    if bleedcount < 1 then
        bleedcount = 0
        lightbleed = false
        heavybleed = false
        lightestbleed = false
        initialbleed = false        
    end
end


RegisterNetEvent("healed:useOxy")
AddEventHandler("healed:useOxy", function()

    for i = 1, #bones do
        bones[i]["applied"] = false
        if bones[i]["hitcount"] > 0 then
            bones[i]["hitcount"] = 0
            bones[i]["timer"] = 0
        end
    end


    ClearPedBloodDamage(PlayerPedId())

    HealSlow()
    bleedcount = 0
    lightbleed = false
    heavybleed = false
    lightestbleed = false
    initialbleed = false  
    lasthealth = GetEntityHealth(PlayerPedId())
    lasthealth2 = lasthealth

    if not bonesUpdatingServer then
        TriggerEvent("bones:client:updateServer")
    end
    
end)

RegisterNetEvent("healed:minors")
AddEventHandler("healed:minors", function()
    for i = 1, #bones do
        bones[i]["applied"] = false
        if bones[i]["hitcount"] > 0 and bones[i]["hitcount"] < 3 then
            bones[i]["hitcount"] = 0
            bones[i]["timer"] = 0
        end
    end


    ClearPedBloodDamage(PlayerPedId())

    HealSlow()

    lasthealth = GetEntityHealth(PlayerPedId())
    lasthealth2 = lasthealth

    if not bonesUpdatingServer then
        TriggerEvent("bones:client:updateServer")
    end
    
end)


Citizen.CreateThread(function()

    while true do
        Wait(5000)
        if StoringEnabled then
        	updateStates()
        end
    end
end)


Citizen.CreateThread(function()
	local firstspawn = false
    local lastbone = 0
    local saveHealth = GetEntityHealth(PlayerPedId())
    local entityModel = GetEntityModel(PlayerPedId())
    lasthealth = GetEntityHealth(PlayerPedId())
    lastarmor = GetPedArmour(PlayerPedId())
    local saveFlag = 0
    while true do
        Wait(100)

        if GetEntityHealth(PlayerPedId()) ~= saveHealth then

            if entityModel == GetEntityModel(PlayerPedId()) then       
                saveHealth = GetEntityHealth(PlayerPedId())
                saveFlag = 50
            else
                entityModel = GetEntityModel(PlayerPedId())
                saveHealth = GetEntityHealth(PlayerPedId())
                saveFlag = 0
            end
        end

        if GetPedArmour(PlayerPedId()) ~= lastarmor then
            
            if entityModel == GetEntityModel(PlayerPedId()) then   
                lastarmor = GetPedArmour(PlayerPedId())
                saveFlag = 50
            else
                entityModel = GetEntityModel(PlayerPedId())
                lastarmor = GetPedArmour(PlayerPedId())
                saveFlag = 0
            end
        end

        if GetEntityHealth(PlayerPedId()) < lasthealth and GetPedArmour(PlayerPedId()) < 1 then
            TriggerEvent("evidence:bleeding")
        	lasthealth = GetEntityHealth(PlayerPedId())
            local injured,part = GetPedLastDamageBone( PlayerPedId() )
            if lastbone ~= part and not bleeddamage and not bleeddamage2 then
                if (lightbleed or heavybleed or lightestbleed) then
                    lightbleed = false
                    heavybleed = false
                    lightestbleed = false
                    initialbleed = false
                end
            end
            bulletUpdate()	
            local injured,part = GetPedLastDamageBone( PlayerPedId() )
            lastbone = part
	    end

        if saveFlag > 0 then
            saveFlag = saveFlag - 1
            if saveFlag == 0 then
                TriggerEvent("hud:saveCurrentMeta")
            end
        end
    end
end)



local bleeders = {}
RegisterNetEvent("blood")
AddEventHandler("blood", function(x,y,z)
    local particleDictionary = "core"
    local particleName = "blood_stab"
    RequestNamedPtfxAsset(particleDictionary)
    while not HasNamedPtfxAssetLoaded(particleDictionary) do
        Citizen.Wait(0)
    end
    SetPtfxAssetNextCall(particleDictionary)
    local particle = StartParticleFxLoopedAtCoord(particleName, x, y, z-0.9, 0.0, 0.0, 0.0, 1.0, 0, 0, 0, 0)
    StopParticleFxLooped(particle, true)
end)

RegisterNetEvent("bleeder:alter")
AddEventHandler("bleeder:alter", function(bleedid,bleedon)
    local bleedid = tonumber(bleedid)
    local idlol = 0
    if bleedon then
        bleeders[#bleeders+1]={ ["id"] = bleedid }
    else
        checkingbleedid = 0

        for i = 1, #bleeders do
            checkingbleedid = bleeders[i]["id"]
            assadf = tonumber(checkingbleedid)
            if assadf == bleedid then
                idlol = i
            end
        end

        table.remove(bleeders,idlol)
    end
end)



local lastTarget
local target
local targetLastHealth
local bodySweat = 0
local sweatTriggered = false
Citizen.CreateThread(function()

    while true do
        Wait(300)

        if IsPedInAnyVehicle(PlayerPedId(), false) then
        	local vehicle = GetVehiclePedIsUsing(PlayerPedId())
        	local bicycle = IsThisModelABicycle( GetEntityModel(vehicle) )
        	local speed = GetEntitySpeed(vehicle)
        	if bicycle and speed > 0 then
        		sweatTriggered = true
        		if bodySweat < 180000 then
        			bodySweat = bodySweat + (150 + math.ceil(speed * 40))
        		else
        			bodySweat = bodySweat + (150 + math.ceil(speed * 11))
        		end

        		if bodySweat > 300000 then
	        		bodySweat = 300000
	        	end
        	end
        end        

        if IsPedInMeleeCombat(PlayerPedId()) then
        	bodySweat = bodySweat + 4000
        	sweatTriggered = true
        	target = GetMeleeTargetForPed(PlayerPedId())
        	if target == lastTarget or lastTarget == nil then
        		if IsPedAPlayer(target) then
        			lastTarget = target
        		end
        	else
        		if IsPedAPlayer(target) then
	        		targetLastHealth = GetEntityHealth(target)
	        		lastTarget = target
	        	end
        	end
        end

        if IsPedSwimming(PlayerPedId()) then
        	local speed = GetEntitySpeed(PlayerPedId())
        	if speed > 0 then
        		sweatTriggered = true
        		TriggerEvent("Evidence:StateSet",20,0)
        		TriggerEvent("Evidence:StateSet",21,0)
        		TriggerEvent("Evidence:StateSet",23,600)
        		if bodySweat < 180000 then
        			bodySweat = bodySweat + (150 + math.ceil(speed * 40))
        		else
        			bodySweat = bodySweat + (150 + math.ceil(speed * 11))
        		end
        		

        		if bodySweat > 210000 then
        			TriggerEvent("Evidence:StateSet",19,600)
	        		bodySweat = 210000
	        	end
        	end
        end

        if IsPedRunning(PlayerPedId()) then
        	bodySweat = bodySweat + 3000
        	if bodySweat > 800000 then
        		bodySweat = 800000
        	end
        elseif bodySweat > 0.0 then
        	if not sweatTriggered then
        		bodySweat = 0.0
        	end
        	if bodySweat < 100000 then
        		bodySweat = bodySweat - 1500
        	end
        	bodySweat = bodySweat - 100
        	if bodySweat == 0.0 then
        		sweatTriggered = false
        	end
        end
        if bodySweat > 200000 and not IsPedSwimming(PlayerPedId()) then
			TriggerEvent("Evidence:StateSet",19,300)
        end  

        if bodySweat > 300000 and not IsPedSwimming(PlayerPedId()) and Currentstates[22]["timer"] < 50 then
			TriggerEvent("Evidence:StateSet",20,450)
        end 
        if bodySweat > 800000 and not IsPedSwimming(PlayerPedId()) and Currentstates[22]["timer"] < 50 then
        	sweatTriggered = true
			TriggerEvent("Evidence:StateSet",21,600)
        end

    end
end)

local weather = ""

RegisterNetEvent("kWeatherSync")
AddEventHandler("kWeatherSync", function(wfer)
	weather = wfer
end)

function getDropChance(startingChance)
	local chance = startingChance

	if weather == "RAIN" then
		chance = startingChance + 10
	elseif weather == "THUNDER" then
		chance = startingChance + 20
	end
	
	if chance > 95 then chance = 95 end
	return chance
end


function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end


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

local firstspawn = 0
RegisterNetEvent("loggedoff")
AddEventHandler("loggedoff",function()
    firstspawn = 0
end)


local allowdamage = false
RegisterNetEvent("enabledamage")
AddEventHandler("enabledamage",function(bvasdf)
    allowdamage = bvasdf
end)

RegisterNetEvent("Evidence:dropdna")
AddEventHandler("Evidence:dropdna",function(dna,dropType)
	local pos = GetEntityCoords(PlayerPedId())
    local sendPos = {pos.x,pos.y,pos.z-0.7}

	if dropType == 1 then

        local information = {
          ["data"] = dna,
          ["name"] = "blood",
          ["Desc"] = "Blood drop's."
        }

        --TriggerEvent("inv:CreatedropItem",56,1,sendPos,information)
	elseif dropType == 2 then

        local information = {
          ["data"] = dna,
          ["name"] = "blood",
          ["Desc"] = "Broken Lockpick with blood."
        }
        
        --TriggerEvent("inv:CreatedropItem",56,1,sendPos,information)
	end
end)

RegisterNetEvent("Evidence:wipe")
AddEventHandler("Evidence:wipe",function()
	CurrentDamageList = {}
	StoredDamageList = {}
end)

RegisterNetEvent("Evidence:isDead")
AddEventHandler("Evidence:isDead",function()
	StoringEnabled = false
end)

RegisterNetEvent("Evidence:isAlive")
AddEventHandler("Evidence:isAlive",function()
	StoringEnabled = true
	CurrentDamageList = {}
	CurrentLocationList = {}
end)

RegisterNetEvent("Evidence:ClearDamageStates")
AddEventHandler("Evidence:ClearDamageStates",function()
	local plyPos = GetEntityCoords(PlayerPedId(),  true)
	local plyHead = GetEntityHeading(PlayerPedId())
	TriggerEvent("resurrect:relationships")
	ClearPedTasks(PlayerPedId())
	CurrentDamageList = {}
	CurrentLocationList = {}
end)

RegisterNetEvent("Evidence:GiveWounds")
AddEventHandler("Evidence:GiveWounds",function(id) 
	updateStates()
	TriggerServerEvent("Evidence:GiveWoundsFinish",CurrentDamageList,id,bones)
end)

RegisterNetEvent("Evidence:CurrentDamageListTarget")
AddEventHandler("Evidence:CurrentDamageListTarget",function(CurrentDamageListTarget,bt,targetid)
	for i = 1, #CurrentDamageListTarget do
		TriggerEvent('chatMessage', 'STATUS: ', 1, CurrentDamageListTarget[i])
	end
    local myJob = exports["isPed"]:isPed("myJob")
	if myJob == "police" or myJob == "ems" or myJob == "doctor" then
    	boneIssuesTarget(bt,targetid)
    end
end)

RegisterNetEvent("Evidence:CurrentDamageList")
AddEventHandler("Evidence:CurrentDamageList",function()
	updateStates()
	for i = 1, #CurrentDamageList do
		TriggerEvent('chatMessage', 'STATUS: ', 1, CurrentDamageList[i] )
	end
	
	for i = 1, #bones do
		if bones[i]["timer"] > 0 then
			TriggerEvent('chatMessage', 'STATUS: ', 1, bones[i]["part"] .. " Injury" )
		end
		
	end

end)


RegisterNetEvent("Evidence:CurrentPainList")
AddEventHandler("Evidence:CurrentPainList",function()
	myPains()
	for i = 1, #CurrentLocationList do
		TriggerEvent('chatMessage', 'STATUS: ', 1, CurrentLocationList[i] )
	end
end)

InjuryIndexList = { 
	{ "Pelvis","4103","11816" },
	{ "Left Thigh","4103","58271" },
	{ "Left Calf","4103","63931" },
	{ "Left Foot","4103","14201" },
	{ "Left Knee","119","46078" },
	{ "Right Thigh","4103","51826" },
	{ "Right Calf","4103","36864" },
	{ "Right Foot","4103","52301" },
	{ "Right Knee","119","16335" },
	{ "Spine Lower","4103","23553" },
	{ "Spine Mid Lower","4103","24816" },
	{ "Spine Mid","4103","24817" },
	{ "Spine High","4103","24818" },
	{ "Left Clavicle","4103","64729" },
	{ "Left UpperArm","4103","45509" },
	{ "Left Forearm","4215","61163" },
	{ "Left Hand","4215","18905" },
	{ "Left Finger Pinky","4103","26610" },
	{ "Left Finger Index","4103","26611" },
	{ "Left Finger Middle","4103","26612" },
	{ "Left Finger Ring","4103","26613" },
	{ "Left Finger Thumb","4103","26614" },
	{ "Left Hand","119","60309" },
	{ "Left ForeArmRoll","7","61007" },
	{ "Left ArmRoll","7","5232" },
	{ "Left Elbow","119","22711" },
	{ "Right Clavicle","4103","10706" },
	{ "Right UpperArm","4103","40269" },
	{ "Right Forearm","4215","28252" },
	{ "Right Hand","4215","57005" },
	{ "Right Finger Pinky","4103","58866" },
	{ "Right Finger Index","4103","58867" },
	{ "Right Finger Middle","4103","58868" },
	{ "Right Finger Ring","4103","58869" },
	{ "Right Finger Thumb","4103","58870" },
	{ "Right Hand","119","28422" },
	{ "Right Hand","119","6286" },
	{ "Right ForeArmRoll","7","43810" },
	{ "Right ArmRoll","7","37119" },
	{ "Right Elbow","119","2992" },
	{ "Neck","4103","39317" },
	{ "Head","4103","31086" },
	{ "Head","119","12844" },
	{ "Face Left Brow_Out","1799","58331" },
	{ "Face Left Lid_Upper","1911","45750" },
	{ "Face Left Eye","1799","25260" },
	{ "Face Left CheekBone","1799","21550" },
	{ "Face Left Lip_Corner","1911","29868" },
	{ "Face Right Lid_Upper","1911","43536" },
	{ "Face Right Eye","1799","27474" },
	{ "Face Right CheekBone","1799","19336" },
	{ "Face Right Brow_Out","1799","1356" },
	{ "Face Right Lip_Corner","1911","11174" },
	{ "Face Brow_Centre","1799","37193" },
	{ "Face UpperLipRoot","5895","20178" },
	{ "Face UpperLip","6007","61839" },
	{ "Face Left Lip_Top","1911","20279" },
	{ "Face Right Lip_Top","1911","17719" },
	{ "Face Jaw","5895","46240" },
	{ "Face LowerLipRoot","5895","17188" },
	{ "Face LowerLip","6007","20623" },
	{ "Face Left Lip_Bot","1911","47419" },
	{ "Face Right Lip_Bot","1911","49979" },
	{ "Face Tongue","1911","47495" },
	{ "Neck","7","35731" }
}

InjuryTypes = {
	[1] = "Light Bandage",
	[2] = "Butterfly Stitching",
	[3] = "Pressure Bandaging",
	[4] = "Disinfect Deep Wound",
	[5] = "Pain killer",
	[6] = "Splinting / Bracing",
}


local injured,part = GetPedLastDamageBone( PlayerPedId() )



bones = {
    [1] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Pelvis", ["boneIndex"] = 11816, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 4, ["offset1"] = 0.35, ["offset2"] = 0.35, ["zone"] = 0 },
    [2] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Left Thigh", ["boneIndex"] = 58271, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 4, ["offset1"] = 0.35, ["offset2"] = 0.8, ["zone"] = 4 },
    [3] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Mouth", ["boneIndex"] = 47495, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.45, ["offset2"] = 0.35, ["zone"] = 1 },
    [4] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Left Foot", ["boneIndex"] = 14201, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 4 },
    [5] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Left Knee", ["boneIndex"] = 46078, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 4, ["offset1"] = 0.35, ["offset2"] = 0.55, ["zone"] = 4 },
    [6] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Right Thigh", ["boneIndex"] = 51826, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 4, ["offset1"] = 0.35, ["offset2"] = 0.8, ["zone"] = 5 },
    [7] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Spine Lower", ["boneIndex"] = 24816, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 5, ["offset1"] = 0.25, ["offset2"] = 0.35, ["zone"] = 0 },
    [8] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Right Foot", ["boneIndex"] = 52301, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 5 },
    [9] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Right Knee", ["boneIndex"] = 16335, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 4, ["offset1"] = 0.35, ["offset2"] = 0.55, ["zone"] = 5 },
    [10] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Spine Mid", ["boneIndex"] = 24817, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 5, ["offset1"] = 0.25, ["offset2"] = 0.55, ["zone"] = 0 },
    [11] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Left Hand", ["boneIndex"] = 60309, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 2 },
    [12] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Left Elbow", ["boneIndex"] = 22711, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 3, ["offset1"] = 0.35, ["offset2"] = 0.75, ["zone"] = 2 },
    [13] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Right Hand", ["boneIndex"] = 57005, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 3 },
    [14] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Right Elbow", ["boneIndex"] = 2992, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 3, ["offset1"] = 0.35, ["offset2"] = 0.75, ["zone"] = 3 },
    [15] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Neck", ["boneIndex"] = 39317, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 5, ["offset1"] = 0.25, ["offset2"] = 0.95, ["zone"] = 0 },
    [16] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Head", ["boneIndex"] = 31086, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 2, ["offset1"] = 0.35, ["offset2"] = 0.75, ["zone"] = 1 }, 
    [17] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Spine High", ["boneIndex"] = 24818, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 5, ["offset1"] = 0.25, ["offset2"] = 0.85, ["zone"] = 0 },   
    [18] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Left Clavicle", ["boneIndex"] = 64729, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 3, ["offset1"] = 0.15, ["offset2"] = 0.75, ["zone"] = 0 },    
    [19] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Left Finger Pinky", ["boneIndex"] = 26610, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 2 },  
    [20] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Left Finger Index", ["boneIndex"] = 26611, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 2 },  
    [21] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Left Finger Middle", ["boneIndex"] = 26612, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 2 }, 
    [22] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Left Finger Ring", ["boneIndex"] = 26613, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 2 },   
    [23] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Left Finger Thumb", ["boneIndex"] = 26614, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 2 },  
    [24] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Right Clavicle", ["boneIndex"] = 10706, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 3, ["offset1"] = 0.35, ["offset2"] = 0.75, ["zone"] = 0 },   
    [25] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Right Finger Pinky", ["boneIndex"] = 58866, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 3 }, 
    [26] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Right Finger Index", ["boneIndex"] = 58867, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 3 }, 
    [27] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Right Finger Middle", ["boneIndex"] = 58868, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 3 },    
    [28] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Right Finger Ring", ["boneIndex"] = 58869, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 3 },  
    [29] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Right Finger Thumb", ["boneIndex"] = 58870, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.2, ["zone"] = 3 }, 
    [30] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Face Left CheekBone", ["boneIndex"] = 21550, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.55, ["offset2"] = 0.45, ["zone"] = 1 },  
    [31] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Face Right CheekBone", ["boneIndex"] = 19336, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.35, ["offset2"] = 0.45, ["zone"] = 1 }, 
    [32] = { ["applied"] = false, ["maxhit"] = false, ["part"] = "Forehead", ["boneIndex"] = 37193, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 2, ["offset1"] = 0.45, ["offset2"] = 0.75, ["zone"] = 1  },    
    [33] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Face UpperLip", ["boneIndex"] = 61839, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.45, ["offset2"] = 0.35, ["zone"] = 1  },    
    [34] = { ["applied"] = false, ["maxhit"] = true, ["part"] = "Face LowerLip", ["boneIndex"] = 20623, ["timer"] = 0, ["hitcount"] = 0, ["injuryType"] = 1, ["offset1"] = 0.45, ["offset2"] = 0.35, ["zone"] = 1  },    
}


-- light wounds = 1
-- concussions = 2
-- upper movement impairing = 3
-- lower movement impairing = 4
-- full movement impairing = 5

-- maxStatus == 1
lightwounds = {
	[1] = { ["text"] = "Light Bleeding" },
	[2] = { ["text"] = "Light Bleeding" },
	[3] = { ["text"] = "Light Bleeding" },
	[4] = { ["text"] = "Heavy Bleeding" },
	[5] = { ["text"] = "Heavy Bleeding" },
	[6] = { ["text"] = "Very Heavy Bleeding" },	
}
-- maxStatus == 2
concussions = {
	[1] = { ["text"] = "Light Bleeding" },
	[2] = { ["text"] = "Heavy Bleeding" },
	[3] = { ["text"] = "Light Concussion" },
	[4] = { ["text"] = "Concussion" },
	[5] = { ["text"] = "Heavy Concussion" },
	[6] = { ["text"] = "Very Heavy Concussion" },
}

-- maxStatus == 3 to 5
movement = {
	[1] = { ["text"] = "Basic Movement Issues" },
	[2] = { ["text"] = "Movement Issues" },
	[3] = { ["text"] = "Severe Movement Issues" },
	[4] = { ["text"] = "Very Severe Movement Issues" },
	[5] = { ["text"] = "Extreme Movement Issues" },
	[6] = { ["text"] = "Fully Impaired Movement" },
}
sleepanim = 0
RegisterNetEvent('sleepinjuryanim')
AddEventHandler('sleepinjuryanim', function()
    if sleepanim > 0 then
        sleepanim = 1500
        return
    end
    sleepanim = 500
    while sleepanim > 0 do
        sleepanim = sleepanim - 1
        Citizen.Wait(1)
    end
    sleepanim = 0
end)


RegisterNetEvent('eventConc')
AddEventHandler('eventConc', function(level)
	
	if math.random(100) > 40 then

		local levelset = math.ceil(level * (stresslevel + 1))
		local fullcol = false


		if not fullcol then
			DoScreenFade(levelset,true)
			Wait(100)
			DoScreenFade(levelset,false)
		end

	end

end)



--ApplyPedBlood(ped, boneIndex, 0.0, 0.0, 0.0, "wound_sheet")

-- light wounds = 1
-- concussions = 2
-- upper movement impairing = 3
-- lower movement impairing = 4
-- full movement impairing = 5



CurrentLocationList = {}
lastpart = 0
fading = false
local indamagefunction = false
RegisterNetEvent("DoDamageFunction")
AddEventHandler("DoDamageFunction",function(InjuryType,CurrentHitCount,boneIndex)
	indamagefunction = true
	if imdead == 0 then
        bleeddamage = true
		local curhealth = GetEntityHealth(PlayerPedId())

		if InjuryType == 1 then
			
			if math.random(50) > 45 then
				curhealth = curhealth - (CurrentHitCount*3)
				lasthealth2 = curhealth
				SetEntityHealth(PlayerPedId(),curhealth)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)
			--	ApplyPedBlood(PlayerPedId(), boneIndex, 0.0, 0.0, 0.0, "wound_sheet")
			end

		elseif InjuryType == 2 then

			if math.random(50) > 20 then
				curhealth = curhealth - (CurrentHitCount*4)
				lasthealth2 = curhealth
				SetEntityHealth(PlayerPedId(),curhealth)
				--ApplyPedBlood(PlayerPedId(), boneIndex, 0.0, 0.0, 0.0, "wound_sheet")
			end
			if CurrentHitCount == 3 then
				TriggerEvent("eventConc",3)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)
			elseif CurrentHitCount == 4 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.025)
				TriggerEvent("eventConc",4)
			elseif CurrentHitCount == 5 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.03)
				TriggerEvent("eventConc",5)
			elseif CurrentHitCount == 6 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.035)
				TriggerEvent("eventConc",6)
			end

		else
            
            if math.random(50) > 40 then
                curhealth = curhealth - (CurrentHitCount*3)
                lasthealth2 = curhealth
                SetEntityHealth(PlayerPedId(),curhealth)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)
                --ApplyPedBlood(PlayerPedId(), boneIndex, 0.0, 0.0, 0.0, "wound_sheet")
            end

			MovementImpair(CurrentHitCount,InjuryType)
		end
        bleeddamage = false
	end
	Citizen.Wait(5000)
	indamagefunction = false

end)

RegisterNetEvent("client:updateStress")
AddEventHandler("client:updateStress",function(newStress)
	stresslevel = newStress / 100
end)




function MovementImpair(impairLevel,impairType)

	if impairType == 4 then
		-- leg movement		
		local fct = math.ceil(impairLevel * (stresslevel + 1))

		if impairLevel > 2 then
			legsdisabled = true
		end
	end

	if impairLevel > 2 and impairType == 3 then
		-- arm movement
		armsdisabled = true
      
	end

	if impairLevel > 2 and impairType == 5 then
		-- full body
        legsdisabled = true
        
		TriggerEvent("eventConc",20)
	end

end



function DoScreenFade(length,todark)
	if passingout then
		return
	end
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.01)
	opacity = 0
    
	passingout = true
	if not todark then

		opacity = 255

		while length > 0 or opacity > 0 do 

			if math.random(199) > 81 then
				DisableControlAction(2,59,true)
				DisableControlAction(2,60,true)
			end

			DrawRect(0,0, 10.0, 10.0, 1, 1, 1, opacity)
			if math.random(100) < 45 then

				opacity = opacity - 1

			end
			Citizen.Wait(1)
			if opacity < 0 then
				opacity = 0
			end
			length = length - 1

		end

	else

		opacity = curfading

		while length > 0 or opacity < 255 do 


			if math.random(199) > 81 then
				DisableControlAction(2,59,true)
				DisableControlAction(2,60,true)
			end


			DrawRect(0, 0, 10.0, 10.0, 1, 1, 1, opacity)
			
			opacity = opacity + 1
			
			if opacity > 253 then
				length = length - 10
				opacity = math.random(253,255)
			end
			length = length - 1
			Citizen.Wait(1)

		end
		local distcheckhsp2 = #(vector3(304.77590942383,-589.34625244141,43.29186630249) - GetEntityCoords(PlayerPedId()))
		local distcheckhsp = #(vector3(347.80456542969,-588.97180175781,43.30224609375) - GetEntityCoords(PlayerPedId()))
		if distcheckhsp < 30.0 or distcheckhsp2 < 30.0 then
			if not (IsPedInAnyVehicle(PlayerPedId(), false)) then
				findBed(false)
			end
		end
	end
    
	passingout = false
end

local bedcoords = {
    [1] =  { ['x'] = 310.26,['y'] = -577.63,['z'] = 43.29,['h'] = 53.16 },   
    [2] =  { ['x'] = 321.9,['y'] = -585.86,['z'] = 43.29,['h'] = 193.55 },
    [3] =  { ['x'] = 318.56,['y'] = -580.69,['z'] = 43.29,['h'] = 245.66 },
    [4] =  { ['x'] = 316.87,['y'] = -584.93,['z'] = 43.29,['h'] = 247.1 },
    [5] =  { ['x'] = 313.56,['y'] = -583.83,['z'] = 43.29,['h'] = 250.0 },
    [6] =  { ['x'] = 314.91,['y'] = -579.39,['z'] = 43.29,['h'] = 68.7 },
    [7] =  { ['x'] = 312.01,['y'] = -583.34,['z'] = 43.29,['h'] = 66.16 },
}

local function HealInjuries()
	local count, injury = 0, nil

	if bones ~= nil then
		for i = 1, #bones do
			if bones[i]["timer"] > 0 then
				bones[i]["timer"] = 0
				count = count + bones[i]["hitcount"]
				bones[i]["hitcount"] = 0
				bones[i]["applied"] = false
				Citizen.Wait(1000)

				injury = bones[i]["part"] .. " Injury"
			end
		end
	end

	return count, injury
end

RegisterNetEvent("Hospital:HealInjuries")
AddEventHandler("Hospital:HealInjuries", HealInjuries)


function findBed(fadein)
    
	if not inbed then
		myinjury = "General Checkups"
		local mybedx,mybedy,mybedz = 363.86135864258,-593.99725341797,43.389274597168
		for i = 1, #bedcoords do
			if CheckBeds(bedcoords[i]["x"],bedcoords[i]["y"],bedcoords[i]["z"]) and not inbed then
				inbed = true
				mybedx,mybedy,mybedz = bedcoords[i]["x"],bedcoords[i]["y"],bedcoords[i]["z"]
			end
		end

		SetEntityCoords(PlayerPedId(),mybedx,mybedy,mybedz)

		if inbed then
			TriggerEvent("client:bed")
		end
		
		TriggerEvent("inbedrect",fadein)
		
		local count, injury = HealInjuries()

		myinjury = injury or myinjury
		injurycount = count and count + injurycount or injurycount

		Citizen.Wait(5000)
        -- add a diff system for hospital fees.
		--TriggerServerEvent("hospital:ticketUser","Hospital Fees",(injurycount*50))
		if not bonesUpdatingServer then
			TriggerEvent("bones:client:updateServer")
		end

		if math.random(100) > 97 then
	
    		local nlevel = math.ceil(stresslevel / 10) + 1
	
    		TriggerServerEvent("stress:illnesslevel:new",myinjury,nlevel)

			TriggerEvent("chatMessage", "Service ", 5, "It was a success with complications with your " .. myinjury .. ", you have been billed for your injuries in the amount of: $" .. (injurycount*30) .. " and will need to return at a later point! Keep in touch.")


		else

			TriggerEvent("chatMessage", "Service ", 5, "It was a success, you have been billed for your injuries in the amount of: $" .. (injurycount*30) .. ".")

		end

		TriggerServerEvent("government:bill",injurycount*30)
		SetEntityHealth(PlayerPedId(),200)
		Citizen.Wait(1000)
		inbed = false
		injurycount = 0
        TriggerEvent( "DoShortHudText" , "Press [E] to leave the bed!" , 1)

	end

end

RegisterNetEvent("bed:checkin")
AddEventHandler("bed:checkin",function()
	findBed(true)
end)

RegisterNetEvent("inbedrect")
AddEventHandler("inbedrect",function(fadein)
	local opacityc
	if fadein then
		opacityc = 0
	else
		opacityc = 255
	end
	while inbed do
		if opacityc < 255 then
			opacityc = opacityc + 1
		end
		DrawRect(0, 0, 10.0, 10.0, 1, 1, 1, opacityc)
		Citizen.Wait(1)
	end
end)

function redflash(enable)
    if enable then
        StartScreenEffect("SuccessTrevor", 1.0, 0)
        StopScreenEffect("SuccessTrevor")   
        Citizen.Wait(50)     
        StartScreenEffect("SuccessTrevor", 1.0, 0)
    else
        StartScreenEffect("SuccessTrevor", 1.0, 0)
        StopScreenEffect("SuccessTrevor")
    end
end

function CheckBeds(x,y,z)
	local players = GetPlayers()
	local ply = PlayerPedId()
	local closestplayers = {}
	local closestdistance = {}
	local closestcoords = {}
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(x,y,z))
			if(distance < 3) then
				return false
			end
		end
	end
	return true
end

function myPains()
    bleedLevel = 0
    
	if armsdisabled then
		if bones[12]["hitcount"] == 0 and bones[14]["hitcount"] == 0 and bones[18]["hitcount"] == 0 and bones[24]["hitcount"] == 0 then
			armsdisabled = false
            
		end
	end

    if legsdisabled then
        if bones[1]["hitcount"] == 0 and bones[2]["hitcount"] == 0 and bones[5]["hitcount"] == 0 and bones[6]["hitcount"] == 0 and bones[7]["hitcount"] == 0 and bones[9]["hitcount"] == 0 and bones[10]["hitcount"] == 0 and bones[15]["hitcount"] == 0 and bones[17]["hitcount"] == 0 then
            legsdisabled = false
            
        end
    end
    
    
	if armsdisabled or GetEntityHealth(PlayerPedId()) < (stresslevel + 80) or legsdisabled then

		
        if not clipchanged then
            clipchanged = true
    	    TriggerEvent("AnimSet:Set:temp",true,"move_m@injured")
        end
        

	elseif clipchanged then
		TriggerEvent("AnimSet:Set:temp",false,"move_m@injured")
        clipchanged = false
	end

	local injured,part = GetPedLastDamageBone( PlayerPedId() )

	for o = 1, #bones do

		if bones[o]["timer"] < 1 and bones[o]["hitcount"] > 0 then
			bones[o]["hitcount"] = 0
			bones[o]["timer"] = 0
            bones[o]["applied"] = false
		end		

		if bones[o]["timer"] > 0 then
			bones[o]["timer"] = bones[o]["timer"] - 1
            if bones[o]["hitcount"] > 0 then
                bleedLevel = bleedLevel + 1
            else
                bones[o]["timer"] = 0
            end
		end

		if bones[o]["hitcount"] > 0 then
			
			if not myboneActive then
				TriggerEvent("myboneIssuesTarget")
			end
            if not bones[o]["applied"] then
                Citizen.InvokeNative(0xEF0D582CBF2D9B0F,PlayerPedId(), bones[o]["zone"], bones[o]["offset1"], bones[o]["offset2"], 0.0, 1.0, -1, 0.0, "BasicSlash");
                bones[o]["applied"] = true
            end
			local chance = 9999
			--Citizen.Trace(GetEntitySpeed(PlayerPedId()))
			if GetEntitySpeed(PlayerPedId()) < 1.4 then
       			chance = 9995
			else
				chance = 5000
			end

			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				
				local veh = GetVehiclePedIsIn(PlayerPedId(),false)

       			if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
       				chance = 10000 / 2
       			else
       				chance = 9500
       			end
				
			end

			if IsPedRunning(PlayerPedId()) or IsPedSwimming(PlayerPedId()) or IsPedJumping(PlayerPedId()) or IsPedInMeleeCombat(PlayerPedId()) then
				chance = chance / 2
			end
			if math.random(10000) > chance and not passingout and not indamagefunction then
				if math.random(50) > 10 then
					TriggerEvent("DoDamageFunction",bones[o]["injuryType"],bones[o]["hitcount"],bones[o]["boneIndex"])
				end
			end

		end

		if passingout then
			while passingout do
				Citizen.Wait(1)
			end
			lasthealth2 = GetEntityHealth(PlayerPedId())
		end

		if bones[o]["boneIndex"] == part and ( (lasthealth2 > GetEntityHealth(PlayerPedId()) and ( lasthealth2 - GetEntityHealth(PlayerPedId())) > 1 ) or lastarmor > GetPedArmour(PlayerPedId()) ) then
			
            if allowdamage then
                local hitdamage = math.ceil( ( lasthealth2 - GetEntityHealth( PlayerPedId() ) ) / 20 )
                if lastarmor > GetPedArmour(PlayerPedId()) then
                    hitdamage = math.ceil( ( lastarmor - GetPedArmour( PlayerPedId() ) ) / 20 )
                end	


    			
    			if bones[o]["timer"] > 2000 then
    				bones[o]["hitcount"] = bones[o]["hitcount"] + hitdamage
    			else
    				bones[o]["hitcount"] = hitdamage
    			end

    			if bones[o]["hitcount"] > 6 then
    				bones[o]["hitcount"] = 6
    			end

                if not bones[o]["applied"] then
                    Citizen.InvokeNative(0xEF0D582CBF2D9B0F,PlayerPedId(), bones[o]["zone"], bones[o]["offset1"], bones[o]["offset2"], 0.0, 1.0, -1, 0.0, "BasicSlash");
                    bones[o]["applied"] = true
                end

    			bones[o]["timer"] = bones[o]["hitcount"] * 2000

    			if not bonesUpdatingServer then
    				TriggerEvent("bones:client:updateServer")
    			end

            end

            lasthealth2 = GetEntityHealth(PlayerPedId())
            lastarmor = GetPedArmour(PlayerPedId())
		end

		if GetPedArmour(PlayerPedId()) == 100 and lastarmor ~= 100 then
			lastarmor = 100
		end

        Citizen.Wait(10)
	end

end

RegisterNetEvent("breaklegs")
AddEventHandler("breaklegs",function()
    bones[5]["hitcount"] = bones[5]["hitcount"] + math.random(3,6)
    bones[9]["hitcount"] = bones[9]["hitcount"] + math.random(3,6)
    bones[6]["hitcount"] = bones[6]["hitcount"] + math.random(1,6)
    bones[5]["timer"] = 600
    bones[9]["timer"] = 600
    bones[6]["timer"] = 600
end)

 
RegisterNetEvent("randomBoneDamage")
AddEventHandler("randomBoneDamage",function()
    local b1 = math.random(34)
    local b2 = math.random(34)
    local b3 = math.random(34)
    bones[b1]["hitcount"] = bones[b1]["hitcount"] + math.random(2,6)
    bones[b2]["hitcount"] = bones[b2]["hitcount"] + math.random(2,6)
    bones[b3]["hitcount"] = bones[b3]["hitcount"] + math.random(1,3)
    bones[b1]["timer"] = 600
    bones[b2]["timer"] = 300
    bones[b3]["timer"] = 300
end)

RegisterNetEvent("bones:client:updatefromDB")
AddEventHandler("bones:client:updatefromDB",function(newbones)
	bones = newbones
	
end)

RegisterNetEvent("bones:client:updateServer")
AddEventHandler("bones:client:updateServer",function()
	bonesUpdatingServer = true
	Citizen.Wait(30000)
	TriggerServerEvent("bones:server:updateServer",bones)
	bonesUpdatingServer = false
end)



function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.2, 0.2)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 95)
    SetTextEdge(1, 0, 0, 0, 250)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end


function DrawText3DsInjured2(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.22, 0.22)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 185)
    SetTextEdge(1, 0, 0, 0, 250)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 820
    DrawRect(_x,_y+0.0095, 0.015+ factor, 0.015, 155, 55, 55, 118)
end

function DrawText3DsInjured(x,y,z, text)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 185)
    SetTextEdge(1, 0, 0, 0, 250)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 340
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 155, 55, 55, 168)

end
local disKeys = {
	[1] = 140,
	[2] = 141,
	[3] = 142,
	[4] = 37,
}
Citizen.CreateThread(function()

    while true do
        Wait(1000)
        if not passingout and not fading then
        	TriggerEvent("DoHealthFading")
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if legsdisabled or armsdisabled then
            if armsdisabled then
                if math.random(100) > 5 then
                    DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
                    DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
                end
            end
            if legsdisabled then
                DisableControlAction( 0, 21, true ) -- sprint
            end
            Citizen.Wait(1)
        else
            Citizen.Wait(1000)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(500)
        myPains()

        if (heavybleed or lightbleed or lightestbleed) and imdead == 0 then
            TriggerEvent("evidence:bleeding")
            Wait(50)
            if (GetPedArmour(PlayerPedId()) > 1 and math.random(80) > 100) or GetPedArmour(PlayerPedId()) < 35 then
                if GetEntitySpeed(PlayerPedId()) < 1.0 or IsPedSittingInAnyVehicle(PlayerPedId()) or initialbleed or math.random(100) < 45 then
                    myBleeds()
                else
                    myBleeds()
                end
            end
        end
    end
end)

function DrawText3DsInjuredPulse(x,y,z, text, red)
    if HudStage < 3 then
        local onScreen,_x,_y=World3dToScreen2d(x,y,z)
        local px,py,pz=table.unpack(GetGameplayCamCoords())
        SetTextScale(0.33, 0.33)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, pulse)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
 --   local factor = (string.len(text)) / 820
 --   DrawRect(_x,_y+0.0095, 0.015+ factor, 0.015, 155, 55, 55, pulse)
end

RegisterNetEvent("myboneIssuesTarget")
AddEventHandler("myboneIssuesTarget",function()
	myboneActive = true
    local damagereport = ""
    local effectedcount = 0
	for i = 1, #bones do
		if bones[i]["timer"] > 0 and bones[i]["hitcount"] > 0 then
			if bones[i]["hitcount"] > 2 then
                effectedcount = effectedcount + 1
                if damagereport == "" then
                    damagereport = damagereport .. "" .. bones[i]["part"] .. " is very painful"
                else
                    damagereport = damagereport .. " | " .. bones[i]["part"] .. " is very painful"
                end
			elseif bones[i]["hitcount"] == 2 then
                effectedcount = effectedcount + 1
                if damagereport == "" then
                    damagereport = damagereport .. "" .. bones[i]["part"] .. " feels warm with blood"
                else
                    damagereport = damagereport .. " | " .. bones[i]["part"] .. " feels warm with blood"
                end 
			elseif bones[i]["hitcount"] == 1 then
                effectedcount = effectedcount + 1
                if damagereport == "" then
                    damagereport = damagereport .. "" .. bones[i]["part"] .. " feels irritated"
                else
                    damagereport = damagereport .. " | " .. bones[i]["part"] .. " feels irritated"
                end
			end
		end	

        if armsdisabled and not legsdisabled then
            TriggerEvent("DoLongHudText","I am finding it difficult to use my arms properly.",2)
        elseif legsdisabled and not armsdisabled then
            TriggerEvent("DoLongHudText","I am finding it difficult to use my legs properly.",2)
        elseif legsdisabled and armsdisabled then
            TriggerEvent("DoLongHudText","I am finding it difficult to use my arms and legs.",2)
        end

        if effectedcount > 3 then
            damagereport = "I feel multiple pains"
        end
        if damagereport ~= "" then
            TriggerEvent("DoLongHudText",damagereport, 155)
        end

	end

    Citizen.Wait(15000)
    myboneActive = false

end)

function boneIssuesTarget(bt,targetid)
	active = false
	Citizen.Wait(100)
	bonesTarget = bt
	targetidsend = targetid
	targetChar = GetPlayerPed(GetPlayerFromServerId(targetid))
	active = true
	while active do
		Citizen.Wait(1)
		
		if not healing then
			healTargetBoneId = 0
		end
		for i = 1, #bonesTarget do
			local crds = GetPedBoneCoords(targetChar, bonesTarget[i]["boneIndex"], 0.0, 0.0, 0.0)
			if bonesTarget[i]["timer"] > 0 then
				print('stage2')
				local onScreen2,x2,y2=World3dToScreen2d(crds["x"], crds["y"],crds["z"])
			    if x2 > 0.33 and x2 < 0.66 and y2 > 0.33 and y2 < 0.66 then

			    	DrawText3DsInjured(crds["x"], crds["y"],crds["z"], bonesTarget[i]["part"] .. " (" .. InjuryTypes[bonesTarget[i]["hitcount"]] .. ")")
			    	if not healing then
			    		healTargetBoneId = i
			    	end			    	
			    else
			    	DrawText3DsInjured2(crds["x"], crds["y"],crds["z"], bonesTarget[i]["part"])
			    end	
			else
				--DrawText3Ds(crds["x"], crds["y"],crds["z"], bonesTarget[i]["part"])
			end	
			if IsControlJustReleased(0,38) and not healing and healTargetBoneId ~= 0 then
				TriggerEvent("healTargetsBoneId")
			end	

	        local pos = GetEntityCoords(targetChar)
	        local playerCoords = GetEntityCoords(PlayerPedId())
	        local distance = #(playerCoords - pos)

			if distance > 5 or IsControlJustReleased(0,47) then
				active = false
			end
		end
	end
end

RegisterNetEvent("DoHealthFading")
AddEventHandler("DoHealthFading",function()
	fading = true
    maxfade = 290.0 - (GetEntityHealth(PlayerPedId()) + 50.0)
	if maxfade < 65.0 then
		maxfade = 0
	end
	maxfade = math.ceil(maxfade)
	--Citizen.Trace(maxfade)

	while curfading < maxfade and not passingout do
		Citizen.Wait(1)
		DrawRect(0,0, 10.0, 10.0, 1, 1, 1, curfading)
		curfading = curfading + 1
	end

	while curfading > 5 and not passingout do
		Citizen.Wait(1)
		DrawRect(0,0, 10.0, 10.0, 1, 1, 1, curfading)
		curfading = curfading - 1
	end

	while curfading < maxfade and not passingout do
		Citizen.Wait(1)
		DrawRect(0,0, 10.0, 10.0, 1, 1, 1, curfading)
		curfading = curfading + 1
	end

	while curfading > 5 and not passingout do
		Citizen.Wait(1)
		DrawRect(0,0, 10.0, 10.0, 1, 1, 1, curfading)
		curfading = curfading - 1
	end

	Citizen.Wait(30000)
	curfading = 0
	fading = false
end)

RegisterNetEvent("updateHealLocation:client")
AddEventHandler("updateHealLocation:client",function(newinfo)
	bones = newinfo
	if not bonesUpdatingServer then
		TriggerEvent("bones:client:updateServer")
	end
end)

RegisterNetEvent("healTargetsBoneId")
AddEventHandler("healTargetsBoneId",function()
	healing = true
	runHealAnim()
	Citizen.Wait(2000)
	ClearPedTasks(PlayerPedId())
	bonesTarget[healTargetBoneId]["hitcount"] = bonesTarget[healTargetBoneId]["hitcount"] - 1
	if bonesTarget[healTargetBoneId]["hitcount"] == 0 then
		bonesTarget[healTargetBoneId]["timer"] = 0
	end
	TriggerServerEvent("updateHealLocation",bonesTarget,targetidsend)
	healing = false
end)

function runHealAnim()
	if not IsEntityPlayingAnim(PlayerPedId(), "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 3) then
		LoadAnimationDictionary("mini@cpr@char_a@cpr_str")	
		TaskPlayAnim(PlayerPedId(), "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 8.0, -8, -1, 49, 0, 0, 0, 0)
	end
end

InjuryList = {
	[1] = { "WEAPON_UNARMED","-1569615261", "Fist Marks" },
	[2] = { "WEAPON_ANIMAL","-100946242", "Animal Bites and Claws" },
	[3] = { "WEAPON_COUGAR","148160082", "Animal Bites and Claws" },
	[4] = { "WEAPON_KNIFE","-1716189206", "Knife Wounds" },
	[5] = { "WEAPON_NIGHTSTICK","1737195953", "Blunt Object (Metal)" },
	[6] = { "WEAPON_HAMMER","1317494643", "Small Blunt Object (Metal)" },
	[7] = { "WEAPON_BAT","-1786099057", "Large Blunt Object (Wooden)" },
	[8] = { "WEAPON_GOLFCLUB","1141786504", "Long Thing Blunt Object" },
	[9] = { "WEAPON_CROWBAR","-2067956739", "Medium Size Jagged Metal Object" },
	[10] = { "WEAPON_PISTOL","453432689", "Pistol Bullets" },
	[11] = { "WEAPON_COMBATPISTOL","1593441988", "Combat Pistol Bullets" },
	[12] = { "WEAPON_APPISTOL","584646201", "AP Pistol Bullets" },
	[13] = { "WEAPON_PISTOL50","-1716589765", "50 Cal Pistol Bullets" },
	[14] = { "WEAPON_MICROSMG","324215364", "Micro SMG Bullets" },
	[15] = { "WEAPON_SMG","736523883", "SMG Bullets" },
	[16] = { "WEAPON_ASSAULTSMG","-270015777", "Assault SMG Bullets" },
	[17] = { "WEAPON_ASSAULTRIFLE","-1074790547", "Assault Rifle Bullets" },
	[18] = { "WEAPON_CARBINERIFLE","-2084633992", "Carbine Rifle Bullets" },
	[19] = { "WEAPON_ADVANCEDRIFLE","-1357824103", "Advanced Rifle bullets" },
	[20] = { "WEAPON_MG","-1660422300", "Machine Gun Bullets" },
	[21] = { "WEAPON_COMBATMG","2144741730", "Combat MG Bullets" },
	[22] = { "WEAPON_PUMPSHOTGUN","487013001", "Pump Shotgun Bullets" },
	[23] = { "WEAPON_SAWNOFFSHOTGUN","2017895192", "Sawn Off Bullets" },
	[24] = { "WEAPON_ASSAULTSHOTGUN","-494615257", "Assault Shotgun Bullets" },
	[25] = { "WEAPON_BULLPUPSHOTGUN","-1654528753", "Bullpup Shotgun Bullets" },
	[26] = { "WEAPON_STUNGUN","911657153", "Stun Gun Damage" },
	[27] = { "WEAPON_SNIPERRIFLE","100416529", "Sniper Rifle Wounds" },
	[28] = { "WEAPON_HEAVYSNIPER","205991906", "Sniper Rifle Wounds" },
	[29] = { "WEAPON_REMOTESNIPER","856002082", "Sniper Rifle Wounds" },
	[30] = { "WEAPON_GRENADELAUNCHER","-1568386805", "Explosive Damage (Grenades)" },
	[31] = { "WEAPON_GRENADELAUNCHER_SMOKE","1305664598", "Smoke Damage" },
	[32] = { "WEAPON_RPG","-1312131151", "RPG damage" },
	[33] = { "WEAPON_STINGER","1752584910", "RPG damage" },
	[34] = { "WEAPON_MINIGUN","1119849093", "Minigun Wounds" },
	[35] = { "WEAPON_GRENADE","-1813897027", "Grenade Wounds" },
	[36] = { "WEAPON_STICKYBOMB","741814745", "Sticky Bomb Wounds" },
	[37] = { "WEAPON_SMOKEGRENADE","-37975472", "Smoke Damage" },
	[38] = { "WEAPON_BZGAS","-1600701090", "Gas Damage" },
	[39] = { "WEAPON_MOLOTOV","615608432", "Molotov/Accelerant Burns" },
	[40] = { "WEAPON_FIREEXTINGUISHER","101631238", "Fire Extenguisher Damage" },
	[41] = { "WEAPON_PETROLCAN","883325847", "Petrol Can Damage" },
	[42] = { "WEAPON_FLARE","1233104067", "Flare Damage" },
	[43] = { "WEAPON_BARBED_WIRE","1223143800", "Barbed Wire Damage" },
	[44] = { "WEAPON_DROWNING","-10959621", "Drowning" },
	[45] = { "WEAPON_DROWNING_IN_VEHICLE","1936677264", "Drowned in Vehicle" },
	[46] = { "WEAPON_BLEEDING","-1955384325", "Died to Blood Loss" },
	[47] = { "WEAPON_ELECTRIC_FENCE","-1833087301", "Electric Fence Wounds" },
	[48] = { "WEAPON_EXPLOSION","539292904", "Explosion Damage" },
	[49] = { "WEAPON_FALL","-842959696", "Fall / Impact Damage" },
	[50] = { "WEAPON_EXHAUSTION","910830060", "Died of Exhaustion" },
	[51] = { "WEAPON_HIT_BY_WATER_CANNON","-868994466", "Water Cannon Pelts" },
	[52] = { "WEAPON_RAMMED_BY_CAR","133987706", "Vehicular Accident" },
	[53] = { "WEAPON_RUN_OVER_BY_CAR","-1553120962", "Runover by Vehicle" },
	[54] = { "WEAPON_HELI_CRASH","341774354", "Heli Crash" },
	[55] = { "WEAPON_FIRE","-544306709", "Fire Victim" },

    [56] = { "WEAPON_ASSAULTSMG","4024951519", "Assault SMG"},
    [57] = { "WEAPON_GUSENBERG","1627465347", "Gusenberg"},

    [58] = { "WEAPON_COMBATPDW","171789620", "Combat PDW"},
    [59] = { "WEAPON_HEAVYSHOTGUN","984333226", "Heavy Shotgun"},
    [60] = { "WEAPON_AUTOSHOTGUN","317205821", "Autoshotgun"},
    [61] = { "WEAPON_BULLPUPSHOTGUN","2640438543", "Bullpup Shotgun"},
    [62] = { "WEAPON_ASSAULTSHOTGUN","3800352039", "Assault Shotgun"},
    [63] = { "WEAPON_BULLPUPRIFLE","2132975508", "Bullpup Rifle"},
    [64] = { "WEAPON_ASSAULTRIFLE","3220176749", "Assault Rifle"},
    [65] = { "WEAPON_PISTOL_MK2","3219281620", "PD Pistol"}
 


}





