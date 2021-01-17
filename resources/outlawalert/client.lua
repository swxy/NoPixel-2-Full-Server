--Config
local timer = 0 --in minutes - Set the time during the player is outlaw
local showOutlaw = false --Set if show outlaw act on map
local gunshotAlert = true --Set if show alert when player use gun
local carJackingAlert = true --Set if show when player do carjacking
local meleeAlert = true --Set if show when player fight in melee
local blipGunTime = 60 --in second
local blipMeleeTime = 60 --in second
local blipJackingTime = 60 -- in second
local blipDeathTime = 360 -- in second
local isInService = false
--End config

local origin = false --Don't touche it
local timing = timer * 60000 --Don't touche i


isCop = false

RegisterNetEvent('nowCopSpawn')
AddEventHandler('nowCopSpawn', function()
    isCop = true
end)

RegisterNetEvent('nowCopSpawnOff')
AddEventHandler('nowCopSpawnOff', function()
    isCop = false
end)




HudStage = 1
RegisterNetEvent("disableHUD")
AddEventHandler("disableHUD", function(passedinfo)
  HudStage = passedinfo
  if HudStage > 2 then
    TriggerEvent("chat:clear")
  end
end)

RegisterNetEvent('playerlocal')
AddEventHandler('playerlocal', function(player, name, msg)
    if not DoesPlayerExist(player) then return end
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(player)
    if sonid == monid then
        TriggerEvent('chatMessage', "Local: ", {130, 144, 155}, "" .. name .. " " .. msg .. "")
    elseif #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(sonid))) < 15 then
        TriggerEvent('chatMessage', "Local: ", {130, 144, 155}, "" .. name .. " " .. msg .. "")
    end
end)

RegisterNetEvent('outlawNotifyID')
AddEventHandler('outlawNotifyID', function(player, info)
    if not DoesPlayerExist(player) then return end
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(player)
    local cref = "661241-"..info.Identifier
    local pref = "81902-" .. player

    info.Identifier = cref
    info.pref = pref


    if tonumber(info.Sex) == 0 then info.Sex = "Male" else info.Sex = "Female" end
    if sonid == monid then
        TriggerEvent('chat:showCID',info)
    elseif #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(sonid))) < 19.999 then
        TriggerEvent('chat:showCID',info)
    end
end)

RegisterNetEvent('outlawNotifyBusiness')
AddEventHandler('outlawNotifyBusiness', function(player, info)
    if not DoesPlayerExist(player) then return end
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(player)
    if sonid == monid then
        TriggerEvent('chatMessage', "", {30, 144, 255}, info)
    elseif #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(sonid))) < 19.999 then
        TriggerEvent('chatMessage', "", {30, 144, 255}, info)
    end
end)

RegisterNetEvent('outlawNotifyPhone')
AddEventHandler('outlawNotifyPhone', function(player, info)
    if not DoesPlayerExist(player) then return end
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(player)
    local phoneNumber = string.sub(info.phone_number, 0, 3) .. '-' .. string.sub(info.phone_number, 4, 6) .. '-' .. string.sub(info.phone_number, 7, 10)
    if sonid == monid then
        TriggerEvent('chatMessage', "", {30, 144, 255}, "^5Phone Number: " .. phoneNumber .. "")
    elseif #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(sonid))) < 19.999 then
        TriggerEvent('chatMessage', "", {30, 144, 255}, "^5Phone Number: " .. phoneNumber .. "")
    end
end)

RegisterNetEvent('outlawNotifyChat311')
AddEventHandler('outlawNotifyChat311', function(args, caller)
    table.remove(args, 1)
    if isInService then
        TriggerEvent('chatMessage', "^5[311]", 3, " (^1 Caller ID: ^3 | "..caller.."^0 ) " .. table.concat(args, " "))
        PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
    end
end)

RegisterNetEvent('outlawNotifyChat311r')
AddEventHandler('outlawNotifyChat311r', function(args, caller)
    table.remove(args, 1)
    if isInService then
        TriggerEvent('chatMessage', "311 RESPONSE:", 3, "^3 Sent to: " .. source .. ": ^7" .. table.concat(args, " ") .. " ")
    end
end)

RegisterNetEvent('outlawNotifyChat')
AddEventHandler('outlawNotifyChat', function(args, caller)
    table.remove(args, 1)
    if isInService then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        TriggerEvent('chatMessage', "^5[911]", 3, " (^1 Caller ID: ^3 | "..caller.."^0 ) " .. table.concat(args, " "))
        PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    end
end)
RegisterNetEvent('callsound')
AddEventHandler('callsound', function()
    PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
end)

RegisterNetEvent('outlawNotifyChat911r')
AddEventHandler('outlawNotifyChat911r', function(args, caller)
    table.remove(args, 1)
    if isInService then
        TriggerEvent('chatMessage', "911 RESPONSE:", 3, "^3 Sent to: " .. source .. ": ^7" .. table.concat(args, " ") .. " ")
    end
end)

RegisterNetEvent('outlawNotifyGTASALE')
AddEventHandler('outlawNotifyGTASALE', function()
    if isCop then
        TriggerEvent('chatMessage', "^1[Dispatch]", 3, "A stolen vehicle has been sold!")
    end
end)

RegisterNetEvent('outlawNotifyRobberies')
AddEventHandler('outlawNotifyRobberies', function(x,y,z)
    if isCop then
        TriggerEvent('AppRobberies:addblip', x,y,z)
        TriggerEvent('chatMessage', "^1[Dispatch]", 3, "A property is currently being robbed!")
    end
end)

RegisterNetEvent('outlawNotify')
AddEventHandler('outlawNotify', function(alert, senderpos)

    if not origin and isCop then
     --   TriggerEvent("DoLongHudText", "Dispatch: " .. alert .. " " )
        TriggerEvent('chatMessage', "^1[Dispatch]", 3, alert)
    end
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
	if job == "police" or job == "ems" then
		isInService = true
	else
		isInService = false
	end
end)

RegisterNetEvent('outlawNotify2')
AddEventHandler('outlawNotify2', function(alert)
    if isInService then
     --   TriggerEvent("DoLongHudText", "Dispatch: " .. alert .. " " )
        TriggerEvent('chatMessage', "^1[Dispatch]", 3, alert)
    end
end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end


RegisterNetEvent('judgeAnnouceGetChat')
AddEventHandler('judgeAnnouceGetChat', function()

    local amount = KeyboardInput("Enter Message:","",255)
    if amount == nil or amount == "" then return end
    TriggerServerEvent("judgeAnnounce",amount)
end)




function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
  TriggerEvent("hud:insidePrompt",true)
  AddTextEntry('FMMC_KEY_TIP1', TextEntry)
  DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
  blockinput = true

  while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
    Citizen.Wait(0)
  end

  if UpdateOnscreenKeyboard() ~= 2 then
    local result = GetOnscreenKeyboardResult()
    Citizen.Wait(500)
    blockinput = false
    TriggerEvent("hud:insidePrompt",false)
    return result
  else
    Citizen.Wait(500)
    blockinput = false
    TriggerEvent("hud:insidePrompt",false)
    return nil
  end

end


--Star color
--[[1- White
2- Black
3- Grey
4- Clear grey
5-
6-
7- Clear orange
8-
9-
10-
11-
12- Clear blue
15 - tweet notification
16 - sms notification


]]

local waitKeys = false

RegisterNetEvent('car:engineHasKeys')
AddEventHandler('car:engineHasKeys', function(targetVehicle, allow)
    if isCop then
        allow = true
    end
    if allow then
        if IsVehicleEngineOn(targetVehicle) then
            if not waitKeys then
                waitKeys = true
                SetVehicleEngineOn(targetVehicle,0,1,1)
                SetVehicleUndriveable(targetVehicle,true)
                TriggerEvent("DoShortHudText", "Engine Halted",1)
                Citizen.Wait(300)
                waitKeys = false
            end
        else
            if not waitKeys then
                waitKeys = true
                TriggerEvent("keys:startvehicle")
                TriggerEvent("DoShortHudText", "Engine Started",1)
                Citizen.Wait(300)
                waitKeys = false
            end
        end
    end
end)

--1 basic notification
--2 error msg
--3 System Msg / Admin shit

-- same color notification
--4 Seat Belt
--5 Police vehicle actions
--6 Body Stress
--7 housing related
--8 purchase item
--9 engine toggle
--10 phone noticiations
--11 cruise actived
--12 fish winner
--14 race countdown
--15 Gang Update notification

RegisterNetEvent('DoLongHudText')
AddEventHandler('DoLongHudText', function(text,color,length)
    if HudStage > 2 then return end
    if not color then color = 1 end
    if not length then length = 12000 end
    TriggerEvent("tasknotify:guiupdate",color, text, 12000)
end)

RegisterNetEvent('DoShortHudText')
AddEventHandler('DoShortHudText', function(text,color,length)
    if not color then color = 1 end
    if not length then length = 10000 end
    if HudStage > 2 then return end
    TriggerEvent("tasknotify:guiupdate",color, text, 10000)
end)





local msgCount2 = 0
local scary2 = 0
local scaryloop2 = false
local dicks2 = 0
local dicks3 = 0
local dicks = 0

RegisterNetEvent('DoHudTextCoords')
AddEventHandler('DoHudTextCoords', function(text,obj)
    if HudStage > 2 then return end
    dicks2 = 600
    msgCount2 = msgCount2 + 0.22
    local mycount2 = msgCount2

    scary2 = 600 - (msgCount2 * 100)
    TriggerEvent("scaryLoop2")
    local power2 = true
    while dicks2 > 0 do

        dicks2 = dicks2 - 1

        local plyCoords2 = GetEntityCoords(obj)

        output = dicks2

        if output > 255 then
            output = 255
        end

        if not isInVehicle and GetFollowPedCamViewMode() == 0 then
            DrawText3DTest(plyCoords2["x"],plyCoords2["y"],plyCoords2["z"]+(mycount2/2) - 0.2, text, output,power2)
        elseif not isInVehicle and GetFollowPedCamViewMode() == 4 then
            DrawText3DTest(plyCoords2["x"],plyCoords2["y"],plyCoords2["z"]+(mycount2/7) - 0.1, text, output,power2)
        elseif GetFollowPedCamViewMode() == 4 then
            DrawText3DTest(plyCoords2["x"],plyCoords2["y"],plyCoords2["z"]+(mycount2/7) - 0.2, text, output,power2)
        else
            DrawText3DTest(plyCoords2["x"],plyCoords2["y"],plyCoords2["z"]+mycount2 - 1.25, text, output,power2)
        end

        Citizen.Wait(1)
    end

end)

RegisterNetEvent('scaryLoop2')
AddEventHandler('scaryLoop2', function()
    if scaryloop2 then return end
    scaryloop2 = true
    while scary2 > 0 do
        if msgCount2 > 2.6 then
           scary2 = 0
        end
        Citizen.Wait(1)
        scary2 = scary2 - 1
    end
    dicks2 = 0
    scaryloop2 = false
    scary2 = 0
    msgCount2 = 0
end)


RegisterNetEvent('outlawNoticeRangeText')
AddEventHandler('outlawNoticeRangeText', function(sonid, item)
    if DoesPlayerExist(sonid) then
        local ply = GetPlayerFromServerId(sonid)
        local monid = PlayerId()

        if #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(ply))) < 8.0 and HasEntityClearLosToEntity( GetPlayerPed(monid), GetPlayerPed(ply), 17 ) then
            TriggerEvent('DoHudTextCoords', item, GetPlayerPed(ply))
        end
    end
end)


RegisterNetEvent('outlawNoticeRange')
AddEventHandler('outlawNoticeRange', function(sonid, item)
    local monid = PlayerId()

    if #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(sonid))) < 8.0 and HasEntityClearLosToEntity( GetPlayerPed(monid), GetPlayerPed(sonid), 17 ) then
        TriggerEvent('DoHudTextCoords', item, GetPlayerPed(sonid))
    end
end)


RegisterNetEvent('outlawNotifyRange')
AddEventHandler('outlawNotifyRange', function(sonid, item)

    local monid = PlayerId()

    if #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(sonid))) < 8.0 and HasEntityClearLosToEntity( GetPlayerPed(monid), GetPlayerPed(sonid), 17 ) then
        TriggerEvent('DoHudTextCoords', item, GetPlayerPed(sonid))
    end

end)




function DrawText3DTest(x,y,z, text, dicks,power)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if dicks > 255 then
        dicks = 255
    end
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 155)
        SetTextEdge(1, 0, 0, 0, 250)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
         SetTextColour(255, 255, 255, dicks)

        DrawText(_x,_y)
        local factor = (string.len(text)) / 250
        if dicks < 115 then
             DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, dicks)
        else
             DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, 115)
        end

    end
end


RegisterNetEvent('car:engine')
AddEventHandler('car:engine', function()
    local targetVehicle = GetVehiclePedIsUsing(PlayerPedId())
    TriggerEvent("keys:hasKeys", 'engine', targetVehicle)
end)

function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

local nextMeleeAction = GetCloudTimeAsInt() -- 1777000000
AddEventHandler('gameEventTriggered', function (name, args)
    local isSelfAttacker = (args[2] == PlayerPedId() and true or false)
    local isMeleeAttack = (args[5] == `WEAPON_UNARMED` and true or false)
    if name == "CEventNetworkEntityDamage" and isMeleeAttack and isSelfAttacker and GetCloudTimeAsInt() > nextMeleeAction then
        TriggerEvent("civilian:alertPolice",35.0,"fight",0)
        TriggerEvent("Evidence:StateSet",1,300)
        nextMeleeAction = GetCloudTimeAsInt() + 20000
    end
end)

local atms = {
  [1] = -1126237515,
  [2] = 506770882,
  [3] = -870868698,
  [4] = 150237004,
  [5] = -239124254,
  [6] = -1364697528,
}

function IsNearATM()
  for i = 1, #atms do
    local objFound = GetClosestObjectOfType( GetEntityCoords(PlayerPedId()), 3.0, atms[i], 0, 0, 0)
    if DoesEntityExist(objFound) then
      Citizen.Trace("ATM Found")
      return true
    end
  end
  return false
end

local PayPhoneHex = {
  [1] = 1158960338,
  [2] = -78626473,
  [3] = 1281992692,
  [4] = -1058868155
}

function checkForPayPhone()
  for i = 1, #PayPhoneHex do
    local objFound = GetClosestObjectOfType( GetEntityCoords(PlayerPedId()), 5.0, PayPhoneHex[i], 0, 0, 0)
    if DoesEntityExist(objFound) then
      Citizen.Trace("Pay Phone Found")
      return true
    end
  end
  return false
end


function getRandomNpc(basedistance)
    local basedistance = basedistance
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom

    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if ped ~= PlayerPedId() and distance < basedistance and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
        end
        success, ped = FindNextPed(handle)
    until not success

    EndFindPed(handle)

    return rped
end

local exlusionZones = {
    {1713.1795654297,2586.6862792969,59.880760192871,250}, -- prison
    {-106.63687896729,6467.7294921875,31.626684188843,45}, -- paleto bank
    {251.21984863281,217.45391845703,106.28686523438,20}, -- city bank
    {-622.25042724609,-230.93577575684,38.057060241699,10}, -- jewlery store
    {699.91052246094,132.29960632324,80.743064880371,55}, -- power 1
    {2739.5505371094,1532.9992675781,57.56616973877,235}, -- power 2
    {12.53, -1097.99, 29.8, 10} -- Adam's Apple / Pillbox Weapon shop
}

--10-94
local ped = PlayerPedId()
local isInVehicle = IsPedInAnyVehicle(ped, true)
Citizen.CreateThread( function()
    while true do
        Wait(1000)
        ped = PlayerPedId()
        isInVehicle = IsPedInAnyVehicle(ped, true)
    end
end)



Citizen.CreateThread( function()
    local origin = false
    local w = `WEAPON_PetrolCan`
    local w1 = `WEAPON_FIREEXTINGUISHER`
    local w2 = `WEAPON_FLARE`
    local curw = GetSelectedPedWeapon(PlayerPedId())
    local armed = false
    local timercheck = 0
    while true do
        Wait(50)
        

        if not armed then
            if IsPedArmed(ped, 7) and not IsPedArmed(ped, 1) then
                curw = GetSelectedPedWeapon(ped)
                armed = true
                timercheck = 15
            end
        end

        if IsPedShooting(ped) then
            TriggerEvent("civilian:alertPolice",15.0,"gunshot",0,true)
        end

        if armed then

            if w == curw then
                TriggerEvent("Evidence:StateSet",9,1200)
            end

            if w2 == curw then
                TriggerEvent("Evidence:StateSet",10,1200)
            end

            if not isCop and IsPedShooting(ped) and curw ~= w and curw ~= w2 and curw ~= w1 and not origin then
                local inArea = false
                for i,v in ipairs(exlusionZones) do
                    local playerPos = GetEntityCoords(ped)
                    if #(vector3(v[1],v[2],v[3]) - vector3(playerPos.x,playerPos.y,playerPos.z)) < v[4] then
                        --if `WEAPON_COMBATPDW` == curw then
                            inArea = true
                        --end
                    end
                end
                if not inArea then
                    origin = true
                    if IsPedCurrentWeaponSilenced(ped) then
                        TriggerEvent("civilian:alertPolice",15.0,"gunshot",0,true)
                    elseif isInVehicle then
                        TriggerEvent("civilian:alertPolice",150.0,"gunshotvehicle",0,true)
                    else
                        TriggerEvent("civilian:alertPolice",550.0,"gunshot",0,true)
                    end

                    Wait(60000)
                    origin = false
                end
            end

            if timercheck == 0 then
                armed = false
            else
                timercheck = timercheck - 1
            end

        else


             Citizen.Wait(5000)


        end
    end
end)

local idx = 0
function gcr()
    idx = idx + 1
    return idx
end


Citizen.CreateThread( function()

    local origin2 = false
    while true do
        Wait(1)
        local plyPos = GetEntityCoords(PlayerPedId(),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
        local w = `WEAPON_PetrolCan`
        local w1 = `WEAPON_FIREEXTINGUISHER`
        local w2 = `WEAPON_FLARE`
        local curw = GetSelectedPedWeapon(PlayerPedId())

        local targetCoords = GetEntityCoords(PlayerPedId(), 0)

        if math.random(100) > 77 and not isCop and not isInVehicle and IsPedArmed(PlayerPedId(), 7) and not IsPedArmed(PlayerPedId(), 1) and curw ~= w and curw ~= w2 and curw ~= w1 and not origin2 then
            origin2 = true

            TriggerEvent("civilian:alertPolice",35.0,"PDOF",0)
            Wait(60000)
            origin2 = false
        else
            if isCop then
                Wait(60000)
            else
                Wait(5000)
            end
        end

    end
end)

local gasStations = {
    {264.47033691406,-1261.2421875,29.29295539856},
    {-320.13858032227,-1471.3533935547,30.548488616943},
    {-526.69915771484,-1210.8858642578,18.184833526611},
    {-724.63739013672,-934.99969482422,19.213779449463},
    {1208.9411621094,-1402.3977050781,35.224239349365},
    {819.65350341797,-1028.7437744141,26.404289245605},
    {-70.216720581055,-1761.7586669922,29.552667617798},
    {1181.3813476563,-330.79992675781,69.301834106445},
    {620.84295654297,269.13439941406,103.0856552124},
    {-1437.6204833984,-276.74166870117,46.212665557861},
    {-2096.2429199219,-320.27899169922,13.164064407349},
    {2581.3210449219,362.05072021484,108.46426391602},
    {-1800.3715820313,803.67309570313,138.64669799805},
    {-2554.9643554688,2334.4987792969,33.077770233154},
    {2539.0300292969,2594.3547363281,37.96667098999},
    {2679.9538574219,3263.9755859375,55.235542297363},
    {1785.4615478516,3330.3972167969,41.382518768311},
    {1207.3582763672,2660.1997070313,38.37427520752},
    {1040.25,2671.1923828125,39.550861358643},
    {263.99612426758,2606.4821777344,44.982532501221},
    {49.521022796631,2778.8117675781,58.049034118652},
    {2005.2669677734,3773.830078125,32.403442382813},
    {1701.4376220703,6416.0341796875,32.763523101807},
    {180.12121582031,6602.83203125,31.868190765381},
    {154.82797241211,6628.8154296875,31.73567199707},
    {-94.501037597656,6419.6235351563,31.485576629639},
}


Citizen.CreateThread( function()
    local origin3 = false
    while true do
        Wait(1)
        local plyPos = GetEntityCoords(PlayerPedId(),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        local dstcheck = 1000.0
        for i,v in ipairs(gasStations) do
            local scandst = #(vector3(v[1],v[2],v[3]) - vector3(plyPos.x, plyPos.y, plyPos.z))
            if scandst < 10 and scandst < dstcheck then
                dstcheck = scandst
                if IsExplosionInSphere(9,v[1],v[2],v[3],60.0)  then
                    origin3 = true
                    TriggerServerEvent('dispatch:svNotify', {
                        dispatchCode = "10-70",
                        firstStreet = street1,
                        secondStreet = street2,
                        ctxId = gcr(),
                        origin = {
                            x = plyPos.x,
                            y = plyPos.y,
                            z = plyPos.z
                        }
                    })
                    Wait(9000)
                    origin3 = false
                end
            end
        end
        if dstcheck > 50 then
            Citizen.Wait(math.ceil(dstcheck*10))
        end
    end
end)
