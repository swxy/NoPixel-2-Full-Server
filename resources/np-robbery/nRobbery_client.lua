local markers = {}
local particlePos = {}
local flags = {}
local markerDifficult = {}



------- Enum ------------------

-- Type of lock
local ELECTRICAL_LOCK = "electricLock" -- kit or thermite
local PHYSICAL_LOCK_PICK = "physicalPick" -- lockpick or thermite
local PHYSICAL_LOCK_THERMITE = "physicalThermite" -- only thermite
local CARDED_LOCK = "cardedlock"
local CARDED_LOCK2 = "cardedlock2"
local AIR_LOCK = "airLock" -- only thermite
-- State of HUD
local hudState = "off"

----------------------------------

----------------------------------
-- Cards
security_cards = {
    [1] = "Gruppe6Card2",
    [2] = "Gruppe6Card2",
    [3] = "Gruppe6Card2",
    [4] = "Gruppe6Card2",
    [5] = "Gruppe6Card2",
}

local CURRENT_CARD_PALETO = 1
local CURRENT_CARD_CITY = 1

----------------------------------


local states = {["City_Power"] = true, ["Prison_Power"] = true, ["Prison_Electric"] = false, ["Prison_Physical"] = false,["vaultDoor"] = false,["Paleto_Electric"] = true}

RegisterNetEvent("robbery:sendServerFlags")
AddEventHandler("robbery:sendServerFlags", function(Prison_Electric_State,Prison_Physical_State,City_Power_State,Prison_Power_State,door,Paleto_Power_State,CityCard,PaletoCard)
    states["City_Power"] = City_Power_State
    states["Prison_Power"] = Prison_Power_State
    states["Prison_Electric"] = Prison_Electric_State
    states["Prison_Physical"] = Prison_Physical_State
    states["vaultDoor"] = door
    states["Paleto_Electric"] = Paleto_Power_State
    CURRENT_CARD_PALETO = PaletoCard
    CURRENT_CARD_CITY = CityCard
    print("this is vault ", tostring(door))
    print("thats prison:"..tostring(Prison_Power_State))
    VaultDoor()
end)



isCop = false
 
RegisterNetEvent('nowCopSpawn')
AddEventHandler('nowCopSpawn', function()
    isCop = true
end)

RegisterNetEvent('nowCopSpawnOff')
AddEventHandler('nowCopSpawnOff', function()
    isCop = false
end)

RegisterNetEvent("robbery:sendMarkers")
AddEventHandler("robbery:sendMarkers", function(onlyone)
    markers = onlyone
    particlePos = onlyone
    for k,v in pairs(onlyone) do
        markerDifficult[k] = v.difficulty
    end
end)

RegisterNetEvent("robbery:sendFlags")
AddEventHandler("robbery:sendFlags", function(flagSent)
  --  print("got the flags bud")
    flags = flagSent
end)

RegisterNetEvent("robbery:triggerItemUsed")
AddEventHandler("robbery:triggerItemUsed", function(itemID,activePolice)
    print(itemID)
    attemptToRob(itemID,activePolice)
end)

Citizen.CreateThread(function()
    Wait(900)
    TriggerServerEvent("inv:playerSpawnedTest")
    
    local lastCheck = 0
    local distance = {}
    local compiledMarkers = {}
    while true do 
        Wait(1)
        local isNear = false
        local foundLock = -1
        
        if markers ~= nil then

            if (GetGameTimer()-lastCheck) > 2000 then -- adjust this value for timing 
                compiledMarkers = {}
                local player = GetEntityCoords(PlayerPedId())
                for k,v in pairs(markers) do
                    distance[k] = #(vector3(v["pos"][1],v["pos"][2],v["pos"][3]) - player)
                    compiledMarkers[k] = true
                end
                lastCheck = GetGameTimer()
            end

            
            for k,j in pairs(compiledMarkers) do
                local continue = false
                local haveNotcompleted = false
                local dist = distance[k]
                local v = markers[k]
                if dist == nil then continue = true end
                -- print(dist)
                -- print(continue)
                if k == 36 then if not states["Prison_Electric"] or not states["Prison_Physical"] then haveNotcompleted = true end end

                if isCop or (not flags[k].isFinished and not continue) then

                    if dist < 30 then isNear = true end
                    if dist < 5 and isCop then DrawMarker(27,v["pos"][1],v["pos"][2],v["pos"][3]-0.90, 0, 0, 0, 0, 0, 0, 0.69, 0.69, 0.3, 100, 255, 255, 60, 0, 0, 2, 0, 0, 0, 0) end
                    if dist < 5 and not isCop then 
                        local rgb = {250,255,190}
                        if sendServerFlags then
                            rgb = {255,0,0}
                        end
                        DrawMarker(27,v["pos"][1],v["pos"][2],v["pos"][3]-0.90, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, rgb[1], rgb[2], rgb[3], 60, 0, 0, 2, 0, 0, 0, 0) 
                    end

                    if dist < 1.3 and not flags[k].inUse then
                        if IsControlJustPressed(1,23) and isCop then
                            checkEvidence(k)
                        end 
                        foundLock = k
                    end
                end
                if not isCop and flags[k].isFinished and dist < 30 then
                    isNear = true
                    DrawMarker(27,v["pos"][1],v["pos"][2],v["pos"][3]-0.90, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 222, 2, 2, 60, 0, 0, 2, 0, 0, 0, 0) 
                end

            end

            if foundLock ~= -1 then
                if not isCop then
                    local card = 1
                    if markers[foundLock]["group"] == "mainBank" then card = CURRENT_CARD_CITY elseif markers[foundLock]["group"] == "paletoBank" then card = CURRENT_CARD_PALETO end
                    renderOptions(markers[foundLock]["toolType"],card)
                end
            else
                renderOptions("off")
            end

        end

        if not isNear then Wait(2000) end
    end
end)

function VaultDoor()
    local VaultDoor = GetClosestObjectOfType(255.2283, 223.976, 102.3932, 25.0, `v_ilev_bk_vaultdoor`, 0, 0, 0)
    local CurrentHeading = 160.0

    if states["vaultDoor"] and GetEntityHeading(VaultDoor) > 159 then

        for i = 1, 50 do
            SetEntityHeading(VaultDoor, CurrentHeading - i)
            Wait(5)
        end

        FreezeEntityPosition(VaultDoor,true)
    elseif not states["vaultDoor"] then 
        SetEntityHeading(VaultDoor,160.0)
        FreezeEntityPosition(VaultDoor,true)
    end
end



Citizen.CreateThread(function()
    local isNear = false
    while true do 
        Wait(2000)
        local dist = #(vector3(255.2283, 223.976, 102.3932) - GetEntityCoords(PlayerPedId()))
        if dist < 4 then isNear = true end
        if isNear then
            VaultDoor()
        else
            Wait(2000)
        end
    end
end)


function getClosestMarker()
    local markerID = 0
    local currentLowest = 0
    for k,v in pairs(markers) do
        local dist = #(vector3(v["pos"][1],v["pos"][2],v["pos"][3]) - GetEntityCoords(PlayerPedId()))
        if currentLowest == 0 or currentLowest > dist then
            if dist < 2.0 then
                currentLowest = dist
                markerID = k
            end
        end
    end
    return markerID
end






function attemptToRob(itemID,activePolice)
    if isCop then return end
    local activePolice = 5
    local locationID = getClosestMarker();
    if locationID == 0 then return end

    if activePolice < 0 then
        TriggerEvent("DoLongHudText","Need more Police",2) 
        return
    end

    local marker = markers[locationID]
    local difficult = markerDifficult[locationID]

    if (marker["group"] == "mainBank" or marker["group"] == "prisonGates") and (states["Prison_Power"]) then
        TriggerEvent("DoLongHudText","The vault is still powered..",2) 
        return
    end

    if flags[locationID].inUse then TriggerEvent("DoLongHudText","Someone Is Already Using this.",2) return end
    if flags[locationID].isFinished then TriggerEvent("DoLongHudText","This Lock has already been broken.",2) return end

    local card = 1
    if marker["group"] == "mainBank" then card = CURRENT_CARD_CITY elseif marker["group"] == "paletoBank" then card = CURRENT_CARD_PALETO end


    if marker.toolType == ELECTRICAL_LOCK and not (itemID == "electronickit" or itemID == "thermite") then TriggerEvent("DoLongHudText","Not the right tool for this job.",2) return end
    if marker.toolType == PHYSICAL_LOCK_PICK and not (itemID == "lockpick" or itemID == "thermite") then TriggerEvent("DoLongHudText","Not the right tool for this job.",2) return end
    if marker.toolType == PHYSICAL_LOCK_THERMITE and itemID ~= "thermite" then TriggerEvent("DoLongHudText","Not the right tool for this job.",2) return end

    if marker.toolType == AIR_LOCK and itemID ~= "locksystem" then TriggerEvent("DoLongHudText","Not the right tool for this job.",2) return end

    if marker.toolType == CARDED_LOCK then
        if itemID == "electronickit" then
            TriggerEvent("DoLongHudText","Must be started with a card , both will be used for this lock.",2)
            return
        elseif itemID ~= "Gruppe6Card2" then
            TriggerEvent("DoLongHudText","Not the right tool for this job.",2)
            return
        end
    end

    if marker.toolType == CARDED_LOCK2 then
        if itemID == "electronickit" then
            TriggerEvent("DoLongHudText","Must be started with a card , both will be used for this lock.",2)
            return
        elseif itemID ~= "Gruppe6Card22" then
            TriggerEvent("DoLongHudText","Not the right tool for this job.",2)
            return
        end
    end

    if itemID == "lockpick" then
        local itemNum = 21
        TriggerServerEvent("robbery:inUse",locationID,true)
        Wait(300)
        TriggerEvent("animation:lockpickcar")
        local pick = difficult.lockpicking
        local finished = exports["np-lockpicking"]:lockpick(pick[1],pick[2],pick[3],pick[4])
        ClearPedTasks(PlayerPedId())
        if finished == 100 then 
            TriggerServerEvent("robbery:robberyFinished",locationID,marker.toolType,itemNum)
        else
            TriggerServerEvent("robbery:robberyFailed",locationID,itemNum)
            if math.random(1,100) > 50 then
                TriggerEvent('inventory:removeItem',"lockpick", 1)
                TriggerEvent("Evidence:StateSet",26,1200)
                TriggerEvent("evidence:bleeding")
            end  
        end
        TriggerServerEvent("robbery:inUse",locationID,false)
        alarm(locationID,finished)
    end



    if itemID == "electronickit" then
        local kit = difficult.kit
        TriggerServerEvent("robbery:inUse",locationID,true)
        Wait(300)
        TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 1.0, -1, 49, 0, 0, 0, 0)
        TriggerEvent("attachItemPhone","phone01")
        TriggerEvent("mhacking:show")
        TriggerEvent("mhacking:start",kit[1],kit[2],locationID,mycb)
    end

    if itemID == "locksystem" then
        TriggerServerEvent("robbery:robberyFinished",locationID,marker.toolType,itemID)
        TriggerEvent('inventory:removeItem',"locksystem", 1)
    end



    if itemID == "thermite" then

            local thermite = markerDifficult[locationID].thermite

            local outcome = exports["np-thermite"]:startGame(thermite[1],thermite[2],thermite[3],thermite[4])
            local finished = 0
            if outcome then finished = 100 end
            local rnd = math.random(1,99999)

            if finished == 100 then

                TriggerEvent('inventory:removeItem',"thermite", 1)
                TriggerEvent("attachItem","minigameThermite")
                RequestAnimDict("weapon@w_sp_jerrycan")
                while ( not HasAnimDictLoaded( "weapon@w_sp_jerrycan" ) ) do
                    Wait(10)
                end
                Wait(100)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                Wait(5000)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                local thermite = markerDifficult[locationID].thermite
                TriggerEvent("destroyProp")
                ClearPedTasks(PlayerPedId())
                
                TriggerEvent("DoLongHudText","Thermite Success!")
                TriggerServerEvent('np-robbery:checkflag')
                
            else
                if math.random(1,100) > 85 then
                    exports["np-thermite"]:startFireAtLocation(marker.pos[1],marker.pos[2],marker.pos[3]-0.3,10000)                   
                end

                TriggerEvent('inventory:removeItem',"thermite", 1)
            end

            TriggerEvent("Evidence:StateSet",16,2200)
            TriggerServerEvent("robbery:inUse",locationID,false)
            if finished == 100 then 
                TriggerServerEvent("robbery:robberyFinished",locationID,marker.toolType,itemID)
            else
                if marker["group"] == "prisonPower" then
                    -- TriggerServerEvent("robbery:spawnaids")
                end
                TriggerServerEvent("robbery:alarmTrigger",locationID)
                TriggerServerEvent("robbery:robberyFailed",locationID,itemID)
            end



    end

    if itemID == "Gruppe6Card2" then

        if exports["np-inventory"]:hasEnoughOfItem("electronickit",1,false) then
            local card = exports["np-taskbar"]:taskBar(9000,"Inserting Card")
            if card == 100 then
                Wait(400)
                TriggerEvent("animation:cancel")
                TriggerServerEvent("robbery:alarmTrigger",locationID)
                local rdif = exports["np-taskbar"]:taskBar(6000,"Hacking..")
                if  rdif == 100 then
                    local kit = difficult.kit
                    TriggerEvent('inventory:removeItem',"Gruppe6Card2", 1)
                    TriggerServerEvent("robbery:inUse",locationID,true)
                    Wait(300)
                    TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 1.0, -1, 49, 0, 0, 0, 0)
                    TriggerEvent("attachItemPhone","phone01")
                    TriggerEvent("mhacking:show")
                    TriggerEvent("mhacking:start",kit[1],kit[2],locationID,mycb)
                end
            end
        else
            TriggerEvent("DoLongHudText","Both a card and hacking device needed for this lock.",2)
        end

    end

    if itemID == "Gruppe6Card22" then

        print('pog')

        if exports["np-inventory"]:hasEnoughOfItem("electronickit",1,false) then
            local card = exports["np-taskbar"]:taskBar(9000,"Inserting Card")
            if card == 100 then
                Wait(400)
                 TriggerEvent("animation:cancel")
                TriggerServerEvent("robbery:alarmTrigger",locationID)
                local rdif = exports["np-taskbar"]:taskBar(6000,"Hacking..")
                if  rdif == 100 then
                    local kit = difficult.kit
                    TriggerEvent('inventory:removeItem',"Gruppe6Card22", 1)
                    TriggerServerEvent("robbery:inUse",locationID,true)
                    Wait(300)
                    TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 1.0, -1, 49, 0, 0, 0, 0)
                    TriggerEvent("attachItemPhone","phone01")
                    TriggerEvent("mhacking:show")
                    TriggerEvent("mhacking:start",kit[1],kit[2],locationID,mycb)
                end
            end
        else
            TriggerEvent("DoLongHudText","Both a card and hacking device needed for this lock.",2)
        end

    end







end

function renderOptions(toolType,cardNumber)
    if hudState ~= tostring(toolType) then
        hudState = tostring(toolType)
        SendNUIMessage({openSection = "toolSelect",tool = toolType,card = cardNumber})
    end
end

function thermiteHandle(locationID,itemID)

    local marker = markers[locationID]
    local particle = particlePos[locationID]

    local taskFinished = exports["np-taskbar"]:taskBar(1000,"Getting Thermite ready")
    if taskFinished == 100 then
       
        TriggerEvent("attachItem","minigameThermite")
        RequestAnimDict("weapon@w_sp_jerrycan")
        while ( not HasAnimDictLoaded( "weapon@w_sp_jerrycan" ) ) do
            Wait(10)
        end
        Wait(100)
        TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
        Wait(5000)
        TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
        local thermite = markerDifficult[locationID].thermite
        TriggerEvent("destroyProp")
        ClearPedTasks(PlayerPedId())
        local rnd = math.random(1,99999)
        -- TriggerServerEvent("particle:StartParticleAtLocation",particle[1],particle[2],particle[3],"lavaPour",rnd,particle[4],particle[5],particle[6])
        Wait(11200)
        -- TriggerServerEvent("particle:StopParticle",rnd)
        TriggerEvent('inventory:removeItem',"thermite", 1)
        TriggerEvent("Evidence:StateSet",16,2200)
        TriggerServerEvent("robbery:inUse",locationID,false)

        TriggerServerEvent("robbery:robberyFinished",locationID,marker.toolType,itemID)
        alarm(locationID,finished)
    end
end

function checkEvidence(locationID)
    local flag = flags[locationID]
    local message = "This lock looks in fine condition."

    if flag.isFinished then
        if flag.toolUsed == "lockpick" then
            message = "This lock looks to have the pins forced."
        elseif flag.toolUsed == "thermite" then
            message = "This lock looks to have been burnt through."
        elseif flag.toolUsed == "electronickit" then
            message = "This Device looks to have been tampered with."
        end
    else
        if flag.toolUsed == "lockpick" then
            message = "This lock looks to have scratch marks around and going into the lock."
        elseif flag.toolUsed == "thermite" then
            message = "This lock looks to have scortch marks from an attempted fire starter."
        elseif flag.toolUsed == "electronickit" then
            message = "This Device is displaying an intrusion warning."
        end
    end

     TriggerEvent('chatMessage', 'Inspection: ', 1, message)
end

local forcedAlarms = {6,7,8,9,10,11,12,29,30,31,32,33,34,35,36,37,38,39,40,41}

function alarm(locationID,finishedPercent)
    local failed = false
    if finishedPercent ~= 100 then failed = true end

    if failed then
        if math.random(1,100) > 90 then
            TriggerServerEvent("robbery:alarmTrigger",locationID)
        end
    else
        for k,v in pairs(forcedAlarms) do
            if locationID == v then
                TriggerServerEvent("robbery:alarmTrigger",locationID)
            end
        end
    end
end


function mycb(success,locationID,timeremaining)

    print('being called')
    TriggerEvent("destroyPropPhone")
    if success then
        TriggerServerEvent("robbery:robberyFinished",locationID,markers[locationID].toolType,43)
        TriggerEvent('mhacking:hide')
        alarm(locationID,100)
        local particle = particlePos[locationID]
        local rnd = math.random(1,99999)
        -- TriggerServerEvent("particle:StartParticleAtLocation",particle[1],particle[2],particle[3],"spark",rnd,particle[4],particle[5],particle[6])
        Wait(3000)
        -- TriggerServerEvent("particle:StopParticle",rnd)
    else
        TriggerServerEvent("robbery:robberyFailed",locationID,43)
        TriggerEvent('mhacking:hide')
        alarm(locationID,5)
    end
     TriggerServerEvent("robbery:inUse",locationID,false)
end


function DrawText3DTest(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 245)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 410
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 133)
end