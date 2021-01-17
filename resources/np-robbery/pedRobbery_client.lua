local recentRobs = {}
Citizen.CreateThread(function()
    while true do
        Wait(1)
        aiming, ent = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if aiming then
            local pedCrds = GetEntityCoords(PlayerPedId())
            local entCrds = GetEntityCoords(ent)

            local pedType = GetPedType(ent)
            local animalped = false
            if pedType == 6 or pedType == 27 or pedType == 29 or pedType == 28 then
                animalped = true
            end

            if not animalped and #(pedCrds - entCrds) < 5.0 and not recentRobs["rob"..ent] and not IsPedAPlayer(ent) and not IsEntityDead(ent) and not IsPedDeadOrDying(ent, 1) and IsPedArmed(PlayerPedId(), 6) and not IsPedArmed(ent, 7) and not IsEntityPlayingAnim(ent, "missfbi5ig_22", "hands_up_anxious_scientist", 3) then
                local veh = 0
                if IsPedInAnyVehicle(ent, false) and GetEntitySpeed(veh) < 1.5 then
                    ClearPedTasks(ent)
                    Citizen.Wait(100)
                    veh = GetVehiclePedIsIn(ent,false)
                    TaskLeaveVehicle(ent, veh, 0)
                    Citizen.Wait(1500)
                    TriggerEvent("robEntity",ent,veh)
                    recentRobs["rob"..ent] = true
                    Citizen.Wait(1000)
                end

                if not IsPedInAnyVehicle(ent, false) then
                    TriggerEvent("robEntity",ent,veh)
                    recentRobs["rob"..ent] = true
                    Citizen.Wait(1000)
                end

            end

        else
            Wait(1000)
        end
    end
end)


-- 303280717 safe hash
local RobbedRegisters = {}
RegisterNetEvent("robEntity")
AddEventHandler("robEntity", function(entityRobbed,veh)

	local robbingEntity = true
	local startCrds = GetEntityCoords(PlayerPedId())
	local entCrds = GetEntityCoords(PlayerPedId())
	local pedCrds = GetEntityCoords(PlayerPedId())
	local pedOwner = NetworkGetEntityOwner(entityRobbed)

	if pedOwner == PlayerId() then
		DecorSetBool(entityRobbed, 'ScriptedPed', true)
	else
		TriggerServerEvent('np:peds:decor', GetPlayerServerId(pedOwner), PedToNet(entityRobbed))
	end

	SetPedDropsWeaponsWhenDead(entityRobbed,false)
	ClearPedTasks(entityRobbed)
	

    ClearPedTasks(entityRobbed)
    ClearPedSecondaryTask(entityRobbed)
    TaskTurnPedToFaceEntity(entityRobbed, PlayerPedId(), 3.0)
    TaskSetBlockingOfNonTemporaryEvents(entityRobbed, true)
    SetPedFleeAttributes(entityRobbed, 0, 0)
    SetPedCombatAttributes(entityRobbed, 17, 1)

    SetPedSeeingRange(entityRobbed, 0.0)
    SetPedHearingRange(entityRobbed, 0.0)
    SetPedAlertness(entityRobbed, 0)
    SetPedKeepTask(entityRobbed, true)

    Citizen.Wait(2000)

    RequestAnimDict("missfbi5ig_22")
    while not HasAnimDictLoaded("missfbi5ig_22") do
        Citizen.Wait(0)
    end
    local storeRobbery = false
	local alerted = false
	local robberySuccessful = true

	while robbingEntity do
		Citizen.Wait(100)
		if not IsEntityPlayingAnim(entityRobbed, "missfbi5ig_22", "hands_up_anxious_scientist", 3) then
			TaskPlayAnim(entityRobbed, "missfbi5ig_22", "hands_up_anxious_scientist", 5.0, 1.0, -1, 1, 0, 0, 0, 0)
			Citizen.Wait(1000)
		end

		pedCrds = GetEntityCoords(PlayerPedId())
		entCrds = GetEntityCoords(entityRobbed)

		if #(pedCrds - entCrds) > 15.0 then
			robbingEntity = false
			robberySuccessful = false
		end
		

		if math.random(1000) < 15 and #(pedCrds - entCrds) < 7.0 then
			TriggerEvent("traps:luck:ai")
			local extracash = math.ceil( math.random(25) + (math.random(15) * 1.5) ) 

			
			if extracash > 500 then
				extracash = 500
			end

			if veh ~= 0 then
				TriggerEvent("DoLongHudText","They handed you the keys!")
				local plate = GetVehicleNumberPlateText(veh, false)
				TriggerEvent("keys:addNew",veh,plate)
				TriggerEvent("timer:stolenvehicle",plate)
			end

			extracash = math.ceil(extracash)
			if(robberySuccessful) then
				TriggerServerEvent('mission:completed',extracash )
			end
		    RequestAnimDict("mp_common")
		    while not HasAnimDictLoaded("mp_common") do
		        Citizen.Wait(0)
		    end			
		    TaskPlayAnim( entityRobbed, "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0 )


			robbingEntity = false

			Citizen.Wait(1200)
		end
	end
	Citizen.Wait(800)
	ClearPedTasks(entityRobbed)

	TriggerEvent("client:newStress",true,50)
	Citizen.Wait(5000)
	TaskWanderStandard(entityRobbed, 10.0, 10)

	DecorSetBool(entityRobbed, 'ScriptedPed', false)


	Citizen.Wait(math.random(1000,30000))	
	if veh ~= 0 then
		TriggerEvent("civilian:alertPolice",8.0,"personRobbed",veh)
	else
		TriggerEvent("civilian:alertPolice",8.0,"personRobbed",0)
	end
	if #recentRobs > 20 then
		recentRobs = {}
	end
end)
