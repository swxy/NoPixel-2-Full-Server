local thecount = 0
local isCop = false
local isEMS = false
local ragdol = 1    
local imDead = 0
local inwater = false
local EHeld = 500

RegisterNetEvent('nowCopDeathOff')
AddEventHandler('nowCopDeathOff', function()
    isCop = false
end)

RegisterNetEvent('nowCopDeath')
AddEventHandler('nowCopDeath', function()
    isCop = true
    mymodel = GetEntityModel(PlayerPedId())
end)

RegisterNetEvent('nowEMSDeathOff')
AddEventHandler('nowEMSDeathOff', function()
    isEMS = false
end)

RegisterNetEvent('hasSignedOnEms')
AddEventHandler('hasSignedOnEms', function()
    TriggerServerEvent("TokoVoip:addPlayerToRadio", 2, GetPlayerServerId(PlayerId()))
    TriggerEvent("ChannelSet",2)
    isEMS = true
end)

RegisterNetEvent("isDoctor")
AddEventHandler("isDoctor", function()
    isEMS = true
end)


function copChangeSkin()
    if IsModelInCdimage(mymodel) and IsModelValid(mymodel) then
        RequestModel(mymodel)
        while not HasModelLoaded(mymodel) do
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), mymodel)
        SetPedRandomComponentVariation(PlayerPedId(), true)
        SetModelAsNoLongerNeeded(mymodel)
    else
        TriggerEvent("DoLongHudText","Model not found",2)
    end
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


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

Citizen.CreateThread(function()
    imDead = 0
    ragdol = 0
    while true do
        Wait(100)
        if IsEntityDead(PlayerPedId()) then 

            SetEntityInvincible(PlayerPedId(), true)
            SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))

            plyPos = GetEntityCoords(PlayerPedId())
           
            TriggerServerEvent('police:isDead', GetPedCauseOfDeath(PlayerPedId()))
            TriggerEvent("Evidence:isDead") 

            if imDead == 0 then
                imDead = 1
                deathTimer()
            end
        end
    end
end)


Citizen.CreateThread(function()
    local isDeadList = {}
    local recentPlayersSent = {}
    local latestRefresh = 0
    while true do
        Citizen.Wait(500)
        if latestRefresh > 0 then
            -- tick down our last cache of nearby players
            latestRefresh = latestRefresh - 1
            if #recentPlayers > 0 then          
                for i = 1, #recentPlayers do

                    -- when we kill people, we revive them and use dead_a animation, so we check that to see if they are "dead" as well

                    if IsEntityDead(recentPlayers[i]) and recentPlayersSent["cock"..recentPlayers[i]] == nil and not IsEntityPlayingAnim(recentPlayers[i], "dead", "dead_a", 3) then
                        -- we think they are dead, so we tell the server to let them know.
                        recentPlayersSent["cock"..recentPlayers[i]] = 15
                        TriggerServerEvent("kill:confirmed",GetPlayerServerId(ent))
                    elseif recentPlayersSent["cock"..recentPlayers[i]] and not IsEntityDead(recentPlayers[i]) and not IsEntityPlayingAnim(recentPlayers[i], "dead", "dead_a", 3) then
                        -- we found out our recently sent dead person is now alive again, lets remove them from our list.
                        recentPlayersSent["cock"..recentPlayers[i]] = nil
                    end
                    
                end
            else
                latestRefresh = 0
                recentPlayers = {}
            end
        else
            -- cache nearby players every 5000 frames
            recentPlayers = {}
            latestRefresh = 50
            for i=1,256 do                 
                if NetworkIsPlayerActive(i) then
                    local ent = GetPlayerPed(i)
                    if #(GetEntityCoords(ent) - GetEntityCoords(PlayerPedId())) < 100.0 and ent ~= PlayerPedId() then

                        -- if entity is in a recently sent list, do a timer to count him down so we dont spam them. This is 15x what 5000 frames roughly a minute and a half
                        if recentPlayersSent["cock"..ent] then
                            if recentPlayersSent["cock"..ent] > 0 then
                                recentPlayersSent["cock"..ent] = recentPlayersSent["cock"..ent] - 1
                            else
                                recentPlayersSent["cock"..ent] = nil
                            end
                        else
                            -- cache the near player
                            recentPlayers[#recentPlayers+1] = ent
                        end
                    end
                end
            end
        end
    end 
end)




RegisterNetEvent('doTimer')
AddEventHandler('doTimer', function()
    TriggerEvent('pd:deathcheck')
    while imDead == 1 do
        Citizen.Wait(0)
        if thecount > 0 then
            drawTxt(0.89, 1.44, 1.0,1.0,0.6, "Respawn: ~r~" .. math.ceil(thecount) .. "~w~ seconds remaining", 255, 255, 255, 255)
        else
            drawTxt(0.89, 1.44, 1.0,1.0,0.6, "~w~HOLD ~r~E ~w~(" .. math.ceil(EHeld/100) .. ") ~w~TO ~r~RESPAWN ~w~OR WAIT FOR ~r~EMS", 255, 255, 255, 255)
        end
    end
    TriggerEvent('pd:deathcheck')
end)



dragged = false
RegisterNetEvent('deathdrop')
AddEventHandler('deathdrop', function(beingDragged)
    dragged = beingDragged
    if beingDragged and imDead == 1 then
        --TriggerEvent('resurrect:relationships')
    end
      if not beingDragged and imDead == 1 then
        SetEntityHealth(PlayerPedId(), 200.0)
        SetEntityCoords( PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 1.0) )
    end 
end)

RegisterNetEvent('resurrect:relationships')
AddEventHandler('resurrect:relationships', function()
    local plyPos = GetEntityCoords(PlayerPedId(),  true)
    NetworkResurrectLocalPlayer(plyPos, true, true, false)
    resetrelations()
end)

RegisterNetEvent('ressurection:relationships:norevive')
AddEventHandler('ressurection:relationships:norevive', function()
    resetrelations()
end)

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

myanim = "dead_a"

function InVeh()
  local ply = PlayerPedId()
  local intrunk = exports["isPed"]:isPed("intrunk")
  if IsPedSittingInAnyVehicle(ply) or intrunk then
    return true
  else
    return false
  end
end

function resetrelations()
    Citizen.Wait(1000)
    if isCop or isEMS then
        SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION2`)
        SetPedRelationshipGroupHash(PlayerPedId(),`MISSION2`)
    else
        SetPedRelationshipGroupDefaultHash(PlayerPedId(),`PLAYER`)
        SetPedRelationshipGroupHash(PlayerPedId(),`PLAYER`)
    end
    TriggerEvent("gangs:setDefaultRelations")
end
local disablingloop = false
RegisterNetEvent('disableAllActions')
AddEventHandler('disableAllActions', function()
    if not disablingloop then
        local ped = PlayerPedId()

        myanim = "dead_a"
        disablingloop = true
        Citizen.Wait(100)
        while GetEntitySpeed(ped) > 0.5 do
            Citizen.Wait(1)
        end 
        Citizen.Wait(100)

        
        local seat = 0
        local veh = GetVehiclePedIsUsing(ped)
        if veh then
            local vehmodel = GetEntityModel(veh)
            for index = 1, GetVehicleModelNumberOfSeats(vehmodel) do
                if GetPedInVehicleSeat(veh,index) == ped then
                    seat = index
                end
            end
        end

        TriggerEvent("resurrect:relationships")
      --  SetPedCanRagdoll(PlayerPedId(), false)
        Wait(100)
        if veh then
            TaskWarpPedIntoVehicle(ped,veh,index)
        end

        TriggerEvent("deathAnim")
        TriggerEvent("disableAllActions2")
        local inveh = 0
        while imDead == 1 do
            if IsEntityInWater(PlayerPedId()) then
                inwater = true
            else
                inwater = false
            end
            SetEntityInvincible(PlayerPedId(), true)
            Citizen.Wait(1) 
            if InVeh() then
                if not inveh then
                    inveh = true
                end
                local intrunk = exports["isPed"]:isPed("intrunk")
                if not intrunk then
                    deadcaranim()
                end
            elseif not InVeh() and inveh and GetEntityHeightAboveGround(PlayerPedId()) < 2.0 or inveh == 0 and GetEntityHeightAboveGround(PlayerPedId()) < 2.0 then
                inveh = false
                Citizen.Trace("Not In Veh DA")
                TriggerEvent("deathAnim")
            elseif not InVeh() then
                if (GetEntitySpeed(PlayerPedId()) > 0.3  and not inwater) or (not IsEntityPlayingAnim(PlayerPedId(), "dead", myanim, 1) and not inwater) then
                    TriggerEvent("deathAnim")
                elseif (not IsEntityPlayingAnim(PlayerPedId(), "dam_ko", "drown", 1) and inwater) then
                    TriggerEvent("deathAnim")
                end 
            end

        end
        SetEntityInvincible(PlayerPedId(), false)
      --  SetPedCanRagdoll(PlayerPedId(), true)
        disablingloop = false
    end
end)



RegisterNetEvent('disableAllActions2')
AddEventHandler('disableAllActions2', function()
        TriggerEvent("disableVehicleActions")
        local playerPed = PlayerPedId()
        while imDead == 1 do

            Citizen.Wait(0) 
            DisableInputGroup(0)
            DisableInputGroup(1)
            DisableInputGroup(2)
             DisableControlAction(1, 19, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 9, true)

            DisableControlAction(0, 32, true)
            DisableControlAction(0, 8, true)
            DisableControlAction(2, 31, true)
            DisableControlAction(2, 32, true)
            DisableControlAction(1, 33, true)
            DisableControlAction(1, 34, true)
            DisableControlAction(1, 35, true)
            DisableControlAction(1, 21, true)  -- space
            DisableControlAction(1, 22, true)  -- space
            DisableControlAction(1, 23, true)  -- F
            DisableControlAction(1, 24, true)  -- F
            DisableControlAction(1, 25, true)  -- F
            if IsControlJustPressed(1,29) then
                SetPedToRagdoll(playerPed, 26000, 26000, 3, 0, 0, 0) 
                 Citizen.Wait(22000)
                 TriggerEvent("deathAnim")
            end

            DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
            DisableControlAction(1, 140, true) --Disables Melee Actions
            DisableControlAction(1, 141, true) --Disables Melee Actions
            DisableControlAction(1, 142, true) --Disables Melee Actions 
            DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
            DisablePlayerFiring(playerPed, true) -- Disable weapon firing
        end
        SetPedCanRagdoll(PlayerPedId(), false)



end)

RegisterNetEvent('disableVehicleActions')
AddEventHandler('disableVehicleActions', function()
    local playerPed = PlayerPedId()
    while imDead == 1 do
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        Wait(300)
        if playerPed ==  GetPedInVehicleSeat(currentVehicle, -1) then
            SetVehicleUndriveable(currentVehicle,true)
        end
    end
end)


--dead dead_a
--dead dead_b
--dead dead_c
--dead dead_d
--dead dead_e
--dead dead_f
--dead dead_g
--dead dead_h
--dead@fall dead_fall_down

local tryingAnim = false
local enteringveh = false
RegisterNetEvent('respawn:sleepanims')
AddEventHandler('respawn:sleepanims', function()
    if not enteringveh then
        enteringveh = true
        ClearPedTasksImmediately(PlayerPedId())
        Citizen.Wait(1000)
        enteringveh = false   
    end
end)
function deadcaranim()
   loadAnimDict( "veh@low@front_ps@idle_duck" ) 
   TaskPlayAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 8.0, -8, -1, 1, 0, 0, 0, 0)
end
myanim = "dead_a"
RegisterNetEvent('deathAnim')
AddEventHandler('deathAnim', function()
    if not dragged and not tryingAnim and not enteringveh and not InVeh() and imDead == 1 then
        tryingAnim = true
        while GetEntitySpeed(PlayerPedId()) > 0.5 and not inwater do
            Citizen.Wait(1)
        end        

        if inwater then
            SetEntityCoords(GetEntityCoords(PlayerPedId()))
            SetPedToRagdoll(PlayerPedId(), 26000, 26000, 3, 0, 0, 0) 
        else
            
            loadAnimDict( "dead" ) 
            SetEntityCoords(PlayerPedId(),GetEntityCoords(PlayerPedId()))
            ClearPedTasksImmediately(PlayerPedId())
            TaskPlayAnim(PlayerPedId(), "dead", myanim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        end


        Citizen.Wait(3000)
        tryingAnim = false
    end
end)



function deathTimer()
    EHeld = 500
    TriggerEvent("civilian:alertPolice",100.0,"death",0)
    thecount = 300
    TriggerEvent("doTimer")

    TriggerEvent("disableAllActions")
    while imDead == 1 do
        
        Citizen.Wait(100)
        thecount = thecount - 0.1

        if thecount == 60 or thecount == 120 or thecount == 180 or thecount == 240 then
            TriggerEvent("civilian:alertPolice",100.0,"death",0)
        end
        --SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))

        while thecount < 0 do
            Citizen.Wait(1)
             
            if IsControlPressed(1,38) then
                local hspDist = #(vector3(307.93017578125,-594.99530029297,43.291835784912) - GetEntityCoords(PlayerPedId()))
                EHeld = EHeld - 1
                if hspDist > 5 and EHeld < 1 then
                      thecount = 99999999
                      releaseBody()
                end
            else
                EHeld = 500
            end
        end      
    end
end

local restblip = AddBlipForCoord(2438.3266601563,4960.3046875,47.27229309082)
SetBlipAsFriendly(restblip, true)
SetBlipSprite(restblip, 84)
SetBlipColour(restblip, 68)
SetBlipAsShortRange(restblip,true)
BeginTextCommandSetBlipName("STRING");
AddTextComponentString(tostring("The Rest House"))
EndTextCommandSetBlipName(restblip)

RegisterNetEvent('trycpr')
AddEventHandler('trycpr', function()

    curDist = #(GetEntityCoords(PlayerPedId(), 0) - vector3(2438.3266601563,4960.3046875,47.27229309082))
    curDist2 = #(GetEntityCoords(PlayerPedId(), 0) - vector3(-1001.18, 4850.52, 274.61))
    
    if curDist < 5 or curDist2 < 5 then
        local penis = 0
        while penis < 10 do
            penis = penis + 1
            local finished = exports["np-taskbarskill"]:taskBar(math.random(2000,10000),math.random(5,20))
            if finished ~= 100 then
                return
            end
            Wait(100)
        end
        -- The below line dupes the pix check since /cpr calls the check that calls this function
        -- TriggerEvent("pixerium:check",3,"serverCPR",true)
        TriggerServerEvent("serverCPR")
    else
        TriggerEvent("DoLongHudText","You are not near the rest house",2)
    end
end)

RegisterNetEvent('reviveFunction')
AddEventHandler('reviveFunction', function()
    attemptRevive()
end)

function releaseBody()
    local ply = PlayerPedId()
    thecount = 240
    imDead = 0   
    ragdol = 1
    ClearPedTasksImmediately(ply)
    TriggerEvent("DoLongHudText", "You have been revived by medical staff.",1)
    TriggerServerEvent('Evidence:ClearDamageStates')   
    TriggerServerEvent("ragdoll:emptyInventory")  
    TriggerServerEvent("police:SeizeCash", GetPlayerServerId(PlayerId()))
    FreezeEntityPosition(ply, false)
    -- the tp is hashed out to prevent crashing? maybe
    if isCop then
        SetEntityCoords(ply, 441.60, -982.37, 30.67)
    else
        RemoveAllPedWeapons(ply)
        SetEntityCoords(ply, 357.43, -593.36, 28.79)
    end
    SetEntityInvincible(ply, false)
    ClearPedBloodDamage(ply)
    local plyPos = GetEntityCoords(ply,true)
    TriggerEvent("resurrect:relationships")
    TriggerEvent("Evidence:isAlive")
    TriggerEvent("attachWeapons")
    SetCurrentPedWeapon(ply,2725352035,true)
    TriggerEvent('ai:resetKOS')
    Citizen.CreateThread(function()
        Citizen.Wait(4000)
        TriggerEvent("unEscortPlayer")
        TriggerEvent("resetCuffs")
    end)
end



function attemptRevive()
    if imDead == 1 then
        ragdol = 1
        imDead = 0
        thecount = 240
        TriggerEvent("Heal")
        SetEntityInvincible(PlayerPedId(), false)
        ClearPedBloodDamage(PlayerPedId())        
        local plyPos = GetEntityCoords(PlayerPedId(),  true)
        TriggerEvent("resurrect:relationships")
        TriggerEvent("Evidence:isAlive")
        TriggerEvent('ai:resetKOS')
        ClearPedTasksImmediately(PlayerPedId())
        if isCop then
            GiveWeaponToPed(PlayerPedId(), `WEAPON_FLASHLIGHT`, true, true)
            GiveWeaponToPed(PlayerPedId(), `WEAPON_NIGHTSTICK`, true, true)
            GiveWeaponToPed(PlayerPedId(), `WEAPON_PISTOL`, 150, true, true)
            GiveWeaponToPed(PlayerPedId(), `WEAPON_FIREEXTINGUISHER`, 1150, true, true)  
            GiveWeaponToPed(PlayerPedId(), `WEAPON_STUNGUN`, true, true)  
            SetPlayerMaxArmour(PlayerId(), 60)         
            SetPedArmour(PlayerPedId(), 60)            
        end
        TriggerEvent("attachWeapons")
        Citizen.Wait(500)
        getup()
    end
end

function getup()
    ClearPedSecondaryTask(PlayerPedId())
    loadAnimDict( "random@crash_rescue@help_victim_up" ) 
    TaskPlayAnim( PlayerPedId(), "random@crash_rescue@help_victim_up", "helping_victim_to_feet_victim", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    SetCurrentPedWeapon(PlayerPedId(),2725352035,true)
    Citizen.Wait(3000)
    endanimation()
end

function endanimation()
    ClearPedSecondaryTask(PlayerPedId())
end

function loadAnimDict( dict )
    RequestAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        
        Citizen.Wait( 1 )
    end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedBeingStunned(PlayerPedId()) then
		ragdol = 1
		end
	end
end)

RegisterNetEvent("heal")
AddEventHandler('heal', function()
	local ped = PlayerPedId()
	if DoesEntityExist(ped) and not IsEntityDead(ped) then
		SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
		ragdol = 0
	end
end)

RegisterNetEvent('phoneGui')
AddEventHandler('phoneGui', function()
  if imDead == 1 then
    TriggerEvent("DoLongHudText","You are unconcious. You can not communicate.",2)
  else
    TriggerEvent("phoneGui2")
  end
end)