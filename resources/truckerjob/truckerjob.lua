local currentJobs = {}
local currentPackages = {}
local job = 0
local currentJobPos = 0

local plate = nil
local existingVeh = nil
local blip = nil
local spawnedvehicles = {}
local vehicles_spawned = false
local stage = "none"
local waitingForConfirmation = false

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


--- dock jobs 000


local cab = "phantom"
local trailer = "trailers"
local DockInfo = {
  ["Drop1"] =  { ['x'] = 929.36,['y'] = -3131.95,['z'] = 5.91,['h'] = 357.19, ['info'] = ' drop point 1' },
  ["Drop2"] =  { ['x'] = 964.23,['y'] = -2920.1,['z'] = 5.91,['h'] = 90.61, ['info'] = ' drop point 2' },
  ["trailerspawn"] =  { ['x'] = 151.67,['y'] = 6440.07,['z'] = 31.33,['h'] = 138.2, ['info'] = ' trailer spawn' },
  ["truckspawn"] =  { ['x'] = 138.46,['y'] = 6427.5,['z'] = 31.34,['h'] = 133.33, ['info'] = ' truck spawn' },
  ["requestspawn"] =  { ['x'] = 123.46,['y'] = 6407.27,['z'] = 31.36,['h'] = 134.62, ['info'] = ' request spawn' },
}



function SpawnTruckPaleto()

    local myPed = PlayerPedId()
    local player = PlayerId()
    local vehicle = GetHashKey(cab)

    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
      Wait(1)
    end

    local trailerToSpawn = GetHashKey(trailer)
    RequestModel(trailerToSpawn)
    while not HasModelLoaded(trailerToSpawn) do
      Wait(1)
    end

    local plate = "DOCK" .. GetRandomIntInRange(1000, 9000)
    local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0)
    local spawned_car = CreateVehicle(vehicle, DockInfo["truckspawn"]["x"],DockInfo["truckspawn"]["y"],DockInfo["truckspawn"]["z"], DockInfo["truckspawn"]["h"], true, false)

    SetVehicleOnGroundProperly(spawned_car)
    SetVehicleNumberPlateText(spawned_car, plate)
    TriggerEvent("keys:addNew",spawned_car,plate)
    TriggerServerEvent('garges:addJobPlate', plate)
    SetPedIntoVehicle(myPed, spawned_car, - 1)
    SetEntityAsMissionEntity(spawned_car,false,true)
    SetVehiclePetrolTankHealth(spawned_car, 1000.0)


    local plate = "DOCK" .. GetRandomIntInRange(1000, 9000)
    local spawned_trailer = CreateVehicle(trailerToSpawn, DockInfo["trailerspawn"]["x"],DockInfo["trailerspawn"]["y"],DockInfo["trailerspawn"]["z"], DockInfo["trailerspawn"]["h"], true, false)
    SetVehicleOnGroundProperly(spawned_trailer)
    SetVehicleNumberPlateText(spawned_trailer, plate)
    TriggerEvent("keys:addNew",spawned_trailer,plate)
    TriggerServerEvent('garges:addJobPlate', plate)
    SetPedIntoVehicle(myPed, spawned_trailer, - 1)    
    SetEntityAsMissionEntity(spawned_trailer,false,true)
    SetVehiclePetrolTankHealth(spawned_trailer, 1000.0)
    
end

function VehicleInFront()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 3.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

function DepositTruckDocks()
  local vehFront = VehicleInFront()
    if vehFront > 0 then
     

      if GetEntityModel(vehFront) == GetHashKey(trailer) then
        local finished = exports["np-taskbar"]:taskBar(25000,"Storing Trailer Contents")
        if finished == 100 then
            TriggerServerEvent("inv:delete","Trunk-"..GetVehicleNumberPlateText(vehFront))
        end
      else
        TriggerEvent("DoLongHudText", "This trailer appears to be the wrong one..",2)
      end

  else
      TriggerEvent("DoLongHudText", "Cant find vehicle..",2)
  end  
end

RegisterNetEvent("docks:manage")
AddEventHandler("docks:manage", function(arg,arg2)
  local rank = exports["isPed"]:GroupRank("dock_worker")
  if rank > 3 then
    if arg == "list" then
      TriggerServerEvent("inv:latestdocks")
    elseif arg == "open" then
      if arg2 == nil then
        return
      end
      arg2 = arg2 .. "STORED"
      TriggerEvent("server-inventory-open", "1", arg2)
    end
  end
end)

local inProgress = false
RegisterNetEvent('event:control:truckerjob')
AddEventHandler('event:control:truckerjob', function(useID)
  local rank = exports["isPed"]:GroupRank("dock_worker")
  if rank > 0 then
    if useID == 1 and not inProgress then
      inProgress = true
      SpawnTruckPaleto()
      Wait(60000)
      inProgress = false
    elseif useID == 2 then
      DepositTruckDocks()
    end
  end
end)

-- #MarkedForMarker
Citizen.CreateThread(function()
  while true do
    Wait(1)

      local dist = #(vector3(DockInfo["requestspawn"]["x"],DockInfo["requestspawn"]["y"],DockInfo["requestspawn"]["z"]) - GetEntityCoords(PlayerPedId()))
      local drop1 = #(vector3(DockInfo["Drop1"]["x"],DockInfo["Drop1"]["y"],DockInfo["Drop1"]["z"]) - GetEntityCoords(PlayerPedId()))
      if dist < 30 or drop1 < 30 then
        local rank = exports["isPed"]:GroupRank("dock_worker")
        if rank > 0 then
          if dist < 20 then
            -- paleto
            DrawMarker(27,DockInfo["requestspawn"]["x"],DockInfo["requestspawn"]["y"],DockInfo["requestspawn"]["z"], 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 0, 212, 175, 155, 0, 0, 0, 0)

            if dist < 2 then
              DrawText3Ds(DockInfo["requestspawn"]["x"],DockInfo["requestspawn"]["y"],DockInfo["requestspawn"]["z"],"[E] Spawn a Truck and Trailer.")
            end
          else
            -- docks
            DrawMarker(27,DockInfo["Drop1"]["x"],DockInfo["Drop1"]["y"],DockInfo["Drop1"]["z"], 0, 0, 0, 0, 0, 0, 5.001, 5.0001, 0.5001, 0, 212, 175, 155, 0, 0, 0, 0)
            if drop1 < 8.0 then
              DrawText3Ds(DockInfo["Drop1"]["x"],DockInfo["Drop1"]["y"],DockInfo["Drop1"]["z"],"[E] Deposit the Truck.")            
            end
          end
        else
          Wait(15000)
        end
      else
        Wait(1000)
      end

  end
end)



--- dock jobs end ---
















local locations = {
  [1] = {165.22, -28.38, 67.94}
}

local garges = {
[1] =  { 171.82, -34.76, 67.0, 182.51,true,0}, 

[2] =  { 154.96, -28.5, 66.7, 175.54,true,0}, 


}


--------------------------------------
----- Section : Thread's -------------
--------------------------------------
--------------------------------------

Citizen.CreateThread(function()
  while true do
    Wait(1)

      local isNear = false
      for i,v in ipairs(locations) do
        local dist = #(vector3(v[1],v[2],v[3]) - GetEntityCoords(PlayerPedId()))
        if dist < 200 then
          isNear = true
          if not vehicles_spawned then
            SpawnSaleVehicles(i)
          end
          if dist < 45 then
            DrawSpawning(i)
          end
        end
      end

      if not isNear then
        
        if vehicles_spawned then
          DespawnSaleVehicles()
        end
        Citizen.Wait(3000)
      end

  end
end)


Controlkey = {["generalUse"] = {38,"E"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
  Controlkey["generalUse"] = table["generalUse"]
end)

local longrun = false

local notspawned = true
Citizen.CreateThread(function()
  while true do

    Wait(1)
    if exports["np-base"]:getModule("LocalPlayer"):getVar("job") == "trucker" and existingVeh ~= nil then
      if job ~= 0 and stage == "pickup" then
        if currentJobs[currentJobPos] == nil then
          TriggerEvent("DoLongHudText","Looks like the job has been taken,find a new job in the phone.",1)
          clearBlip()
          stage = "none"
          job = 0
        elseif currentJobs[currentJobPos].active == 0 then
          local dist = #(vector3(currentJobs[currentJobPos].pickup[1], currentJobs[currentJobPos].pickup[2], currentJobs[currentJobPos].pickup[3]) - GetEntityCoords(PlayerPedId()))
          if dist < 50 and notspawned then
            if currentJobs[currentJobPos].active ~= 0 then
              TriggerEvent("DoLongHudText","Looks like the job has been taken,find a new job in the phone.",1)
              clearBlip()
              stage = "none"
              job = 0
            else
              TriggerServerEvent("trucker:jobTaken",job)
              for i = 1, currentJobs[currentJobPos].dropAmount do
                  loadModel("prop_cs_cardbox_01")
                  local obj = CreateObject(`prop_cs_cardbox_01`,currentJobs[currentJobPos].pickup[1], currentJobs[currentJobPos].pickup[2], currentJobs[currentJobPos].pickup[3]-0.8, 1, 0, 0)
                  PlaceObjectOnGroundProperly(obj)
              end
              notspawned = false
              local collected = currentJobs[currentJobPos].dropAmount
              while collected > 0 do
                  local plyc = GetEntityCoords(PlayerPedId())
                  if( #(plyc - vector3( currentJobs[currentJobPos].pickup[1], currentJobs[currentJobPos].pickup[2], currentJobs[currentJobPos].pickup[3] )) < 18.0) then
                      DrawText3Ds(currentJobs[currentJobPos].pickup[1], currentJobs[currentJobPos].pickup[2], currentJobs[currentJobPos].pickup[3],"Pick up package ~r~"..Controlkey["generalUse"][2].."~w~.")
                      if(IsControlJustPressed(1,Controlkey["generalUse"][1])) and ( #(plyc - vector3( currentJobs[currentJobPos].pickup[1], currentJobs[currentJobPos].pickup[2], currentJobs[currentJobPos].pickup[3] )) < 1.5) then 
                          DelBox()

                          runPickup()
                          collected = collected - 1
                      end
                  end
                  
                  Citizen.Wait(1)
              end
              clearBlip()
              if currentJobs[currentJobPos].JobType ~= "Shops" and currentJobs[currentJobPos].shopId ~= "" and currentJobs[currentJobPos].shopId ~= "none" then
               TriggerServerEvent("trucker:pickup",job)
              end
              blip = AddBlipForCoord(currentJobs[currentJobPos].drop[1], currentJobs[currentJobPos].drop[2], currentJobs[currentJobPos].drop[3])
              goToPickup()
              stage = "drop"
            end
          else
            Wait(3000)
          end
        else
          TriggerEvent("DoLongHudText","Looks like the job has been taken,find a new job in the phone.",1)
          clearBlip()
          stage = "none"
          job = 0
        end
      elseif job ~= 0 and stage == "drop" then
        currentJobPos = returnJobPos(job)
        if currentJobs[currentJobPos].JobType == "Shops" then
            local dist = #(vector3(currentJobs[currentJobPos].drop[1], currentJobs[currentJobPos].drop[2], currentJobs[currentJobPos].drop[3]) - GetEntityCoords(PlayerPedId()))
            if dist < 20 then
              stage = "waiting"
            else
              Wait(500)
            end
        elseif currentJobs[currentJobPos].JobType ~= "Shops" then
          local dist = #(vector3(currentJobs[currentJobPos].drop[1], currentJobs[currentJobPos].drop[2], currentJobs[currentJobPos].drop[3]) - GetEntityCoords(PlayerPedId()))
          if dist < 20 then
            TriggerEvent("DoLongHudText","You have arrived at drop point , start unpacking good's.",1)
            clearBlip()
            runDrop()
            stage = "none"
            TriggerServerEvent("trucker:jobFinished",job)
            job = 0

            local payment = CalculateTravelDistanceBetweenPoints(currentJobs[currentJobPos].pickup[1], currentJobs[currentJobPos].pickup[2], currentJobs[currentJobPos].pickup[3],currentJobs[currentJobPos].drop[1], currentJobs[currentJobPos].drop[2], currentJobs[currentJobPos].drop[3])
            payment = math.ceil((payment / 20))
            if payment > 400 then
              payment = 400
            end
            if payment == nil or payment < 200 then
              payment = 200
            end

            --if math.random(100) > 66 then
            --
            --TriggerEvent("payment:chopshopscrap",math.random(30),false)
            --end
            TriggerServerEvent('loot:useItem', 'deliveryjob')
            payment = math.random(100,payment)
            TriggerServerEvent("server:givepayJob", "Delivery Service", payment)
          end
          Wait(1)
        end
      elseif job ~= 0 and stage == "waiting" then
        if waitingForConfirmation then
          TriggerEvent("DoLongHudText","Delivery Accepted , Start unpacking",1)
          clearBlip()
          runDrop()
          stage = "none"
          TriggerServerEvent("trucker:jobFinished",job)
          job = 0
          local payment = CalculateTravelDistanceBetweenPoints(currentJobs[currentJobPos].pickup[1], currentJobs[currentJobPos].pickup[2], currentJobs[currentJobPos].pickup[3],currentJobs[currentJobPos].drop[1], currentJobs[currentJobPos].drop[2], currentJobs[currentJobPos].drop[3])
          payment = math.ceil((payment / 20))
          currentJobPos = 0

          if payment > 400 then
            payment = 400
          end
          
          if math.random(100) > 66 then
            --
            TriggerEvent("payment:chopshopscrap",math.random(30),false)
          end

          TriggerServerEvent("server:givepayJob", "Delivery Service", math.random(100,payment))
          waitingForConfirmation = false
        end
      else
        Wait(3000)
      end
    else
      Wait(9000)
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Wait(9000)
    if job ~= 0 and exports["np-base"]:getModule("LocalPlayer"):getVar("job") == "trucker"  then
      currentJobPos = returnJobPos(job)
      checkDestruction()
    end
  end
end)


--------------------------------------
----- Section : Phone Connection -----
--------------------------------------
--------------------------------------


RegisterNetEvent("trucker:confirmation")
AddEventHandler("trucker:confirmation", function()
  if job ~= 0 then
   currentJobPos = returnJobPos(job)
    if currentJobs[currentJobPos] ~= nil and currentJobs[currentJobPos].JobType == "Shops" then
      local dist = #(vector3(currentJobs[currentJobPos].drop[1], currentJobs[currentJobPos].drop[2], currentJobs[currentJobPos].drop[3]) - GetEntityCoords(PlayerPedId()))
      if dist < 20 then
        local t, distance = GetClosestPlayer()
        if(distance ~= -1 and distance < 5) then
            TriggerEvent("DoLongHudText","Requesting Acceptance from person.",1)
            TriggerServerEvent("np-shops:checkOwner",GetPlayerServerId(t),currentJobs[currentJobPos].shopId)
        else
          TriggerEvent("DoLongHudText", "No player near you!",2)
        end   
      else
        TriggerEvent("DoLongHudText","You have to be near the drop location.",1)
      end
    else
      TriggerEvent("DoLongHudText","No valid job found.",1)
    end
  else
    TriggerEvent("DoLongHudText","No valid job found.",1)
  end
end)

RegisterNetEvent("trucker:OwnerCheck")
AddEventHandler("trucker:OwnerCheck", function()
  waitingForConfirmation = true
end)

RegisterNetEvent("Trucker:GetPackages")
AddEventHandler("Trucker:GetPackages", function()
   TriggerEvent("phone:packages",currentPackages)
end)

RegisterNetEvent("Trucker:GetJobs")
AddEventHandler("Trucker:GetJobs", function()

   TriggerEvent("phone:trucker",currentJobs)

end)

RegisterNetEvent("Trucker:SelectJob")
AddEventHandler("Trucker:SelectJob", function(data)
  
    if job ~= 0 then
        TriggerServerEvent("trucker:jobfailure",false,job)
        stage = "none"
        existingVeh = nil
        job = 0
        currentJobPos = 0
        waitingForConfirmation = false
    end

    job = data.jobId
    clearBlip()
    currentJobPos = returnJobPos(job)
    blip = AddBlipForCoord(currentJobs[currentJobPos].pickup[1], currentJobs[currentJobPos].pickup[2], currentJobs[currentJobPos].pickup[3])
    goToPickup()
    stage = "pickup"
    notspawned = true
    TriggerEvent("DoLongHudText","Job Selected!",1)
end)





--------------------------------------
------- Section : Animations ---------
--------------------------------------
--------------------------------------



function runPickup()
    TriggerEvent("DoLongHudText","Pickup Started!",1)
    local hasPackedCargo = false
    local playerPed = PlayerPedId()
    currentJobPos = returnJobPos(job)
    local currentTruckPos = GetEntityCoords(existingVeh)
    
    TriggerEvent("attachItem","crate01")
    RequestAnimDict("anim@heists@box_carry@")
    Citizen.Wait(100)
    while not HasAnimDictLoaded("anim@heists@box_carry@") do
        Citizen.Wait(1)
    end
    TaskPlayAnim(PlayerPedId(),"anim@heists@box_carry@","idle",2.0, 1.0, 180, 49, 0, 0, 0, 0)
    Wait(100)

    while not hasPackedCargo do
        Wait(1)
        local player = PlayerPedId()
        local playerCo = GetEntityCoords(player)

        local d1,d2 = GetModelDimensions( GetEntityModel( (existingVeh) ) )
        local back = GetOffsetFromEntityInWorldCoords(existingVeh, 0.0,d1["y"]+2.5,0.0)

        if not IsEntityPlayingAnim(player, "anim@heists@box_carry@","idle", 3) then
            TaskPlayAnim(PlayerPedId(),"anim@heists@box_carry@","idle",2.0, 1.0, 180000000, 49, 0, 0, 0, 0)
        end

        if IsPedRunning(PlayerPedId()) then
          SetPedToRagdoll(PlayerPedId(),2000,2000, 3, 0, 0, 0)
          Wait(2100)
          TaskPlayAnim(GetPlayerPed(-1),"anim@heists@box_carry@","idle",2.0, -8, 180000000, 49, 0, 0, 0, 0)
        end

        if( #(playerCo - vector3( back["x"], back["y"], back["z"] )) < 15.0) then
            DrawText3Ds(back["x"], back["y"], back["z"],"Press ~r~"..Controlkey["generalUse"][2].."~w~ to store then check for more.")
            if( IsControlJustPressed(1,Controlkey["generalUse"][1]) ) and #(playerCo - vector3( back["x"], back["y"], back["z"] )) < 1.0 then
                stopCarry()
                attachBox()
                hasPackedCargo = true
            end
        end
    end
 
end

function runDrop()
  TriggerEvent("DoLongHudText","Drop Started!",1)

    local dropOffSet = {}
    local hasDropped = false
    local hasStarted = false
    local hasDelivered = false
    currentJobPos = returnJobPos(job)

    for i=1,currentJobs[currentJobPos].dropAmount do
        hasDropped = false
        while not hasDropped do

            local player = PlayerPedId()
            local playerCo = GetEntityCoords(player)
            local currentTruckPos = GetEntityCoords(existingVeh)

            local d1,d2 = GetModelDimensions( GetEntityModel( (existingVeh) ) )
            local back = GetOffsetFromEntityInWorldCoords(existingVeh, 0.0,d1["y"]+2.5,0.0)


            Wait(1)
            DrawText3Ds(back["x"],back["y"],back["z"],"Press ~r~"..Controlkey["generalUse"][2].."~w~ to start unpacking.")
            if( #(playerCo - vector3( back["x"],back["y"],back["z"])) < 1.0) then
                
                if(IsControlJustPressed(1,Controlkey["generalUse"][1]) ) then
                    DelBox()
                   hasDropped = false
                   stackBox()
                    hasDropped = true
                    
                end
            end
        end
    end
end

--------------------------------------
------- Section : Box Handling  ------
--------------------------------------
--------------------------------------
function attachBox()
    local veh = existingVeh

    loadModel("prop_cs_cardbox_01")
    local vehc = GetEntityCoords(existingVeh)
    local obj = CreateObject(`prop_cs_cardbox_01`,vehc["x"],vehc["y"],vehc["z"], 1, 0, 0)

    local x = math.random(10) / 10
    if math.random(100) > 50 then
        x = x - x - x
    end

    local y = math.random(10) / 10
    if math.random(100) > 50 then
        y = y - y - y
    end

    AttachEntityToEntity(obj, veh, GetEntityBoneIndexByName(veh, 'bodyshell'), x, y, 0.2, 0, 0, 0, 1, 1, 0, 1, 0, 1)
end

function DelBox()
    local objFound = GetClosestObjectOfType( GetEntityCoords(PlayerPedId()), 5.0, `prop_cs_cardbox_01`, 0, 0, 0)
    if objFound then
        DetachEntity(objFound)

        DeleteEntity(objFound)

        SetEntityCoords(objFound,0.0,0.0,-100.0)
    end
end


function stackBox()
    local stackBox = false
    local playerPed = PlayerPedId()
    currentJobPos = returnJobPos(job)
    local currentTruckPos = GetEntityCoords(existingVeh)

    TriggerEvent("attachItem","crate01")
    RequestAnimDict("anim@heists@box_carry@")
    Citizen.Wait(100)
    while not HasAnimDictLoaded("anim@heists@box_carry@") do
        Citizen.Wait(1)
    end
    TaskPlayAnim(PlayerPedId(),"anim@heists@box_carry@","idle",2.0, 1.0, 180, 49, 0, 0, 0, 0)
    Wait(100)
    while not stackBox do
        Wait(1)
        local player = PlayerPedId()
        local playerCo = GetEntityCoords(player)

        local d1,d2 = GetModelDimensions( GetEntityModel( (existingVeh) ) )
        local back = GetOffsetFromEntityInWorldCoords(existingVeh, 0.0,d1["y"]-2.5,0.0)

        if not IsEntityPlayingAnim(player, "anim@heists@box_carry@","idle", 3) then
            TaskPlayAnim(PlayerPedId(),"anim@heists@box_carry@","idle",2.0, 1.0, 180000000, 49, 0, 0, 0, 0)
        end

        if IsPedRunning(PlayerPedId()) then
          SetPedToRagdoll(PlayerPedId(),2000,2000, 3, 0, 0, 0)
          Wait(2100)
          TaskPlayAnim(GetPlayerPed(-1),"anim@heists@box_carry@","idle",2.0, -8, 180000000, 49, 0, 0, 0, 0)
        end

        if( #(playerCo - vector3( currentJobs[currentJobPos].drop[1], currentJobs[currentJobPos].drop[2], currentJobs[currentJobPos].drop[3] )) < 40.0) then
          DrawText3Ds(currentJobs[currentJobPos].drop[1], currentJobs[currentJobPos].drop[2], currentJobs[currentJobPos].drop[3],"Press ~r~"..Controlkey["generalUse"][2].."~w~ to store package.")
          if( IsControlJustPressed(1,Controlkey["generalUse"][1]) ) and #(playerCo - vector3( currentJobs[currentJobPos].drop[1], currentJobs[currentJobPos].drop[2], currentJobs[currentJobPos].drop[3] )) < 1.0 then
              stopCarry()
              stackBox = true
          end
      end
    end

end

--------------------------------------
------- Section : Util ---------------
--------------------------------------
--------------------------------------

RegisterNetEvent("np-base:characterLoaded")
AddEventHandler("np-base:characterLoaded", function()
    TriggerServerEvent("trucker:returnCurrentJobs")
end)

RegisterNetEvent("trucker:updateJobs")
AddEventHandler("trucker:updateJobs", function(jobs,packages)
    currentJobs = jobs
    currentPackages = packages
end)

RegisterNetEvent("trucker:updateGarages")
AddEventHandler("trucker:updateGarages", function(result)
  --  garges = result
end)

function checkDestruction()
    if existingVeh ~= nil then
        local healthVeh = GetEntityHealth(existingVeh)
        local msg = "The Truck Was Destroyed, nothing was lost"
        if healthVeh <= 0 then

          if stage == "drop" or stage == "waiting" then
            TriggerServerEvent("trucker:jobfailure",true,job)
            msg = "The Truck Was Destroyed and you lost all Cargo, you have been held responsable."
          else
            TriggerServerEvent("trucker:jobfailure",false,job)
          end
          TriggerEvent("DoLongHudText",msg,1)
          stage = "none"
          existingVeh = nil
          job = 0
          currentJobPos = 0
          waitingForConfirmation = false
        end
    end
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

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end

function returnStage()
  return stage
end

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


function goToPickup()
   SetBlipSprite(blip, 1)
   SetBlipScale(blip, 1.0)
  SetBlipColour(blip, 58)
  SetBlipRoute(blip, true) 

end

function loadModel(modelName)
    RequestModel(GetHashKey(modelName))
    while not HasModelLoaded(GetHashKey(modelName)) do
        RequestModel(GetHashKey(modelName))
        Citizen.Wait(1)
    end
end

function clearBlip()
    if curblip ~= 0 then
        RemoveBlip(curblip)
        curblip = 0
    end
    if blip ~= nil then
      SetBlipRoute(blip, false) 
      RemoveBlip(blip)
    end
end

function stopCarry()
    ClearPedTasks(PlayerPedId())
    TriggerEvent("destroyProp")
end

function returnJobPos(jobId)
  for i,v in ipairs(currentJobs) do
    if v.id == jobId then
      return i
    end
  end
  return false
end


--------------------------------------
------- Section : Veh Spawning -------
--------------------------------------
--------------------------------------

function spawnTruck(i)
  
      Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(spawnedvehicles[i]))
      

      TriggerEvent("DoLongHudText","Use Phone to check job",1)

      local model = `mule2`
      RequestModel(model)
      while not HasModelLoaded(model) do
          Wait(1)
      end 

      local playerPed = PlayerPedId()
      if plate ~= nil then
          TriggerEvent("keys:remove",plate)
      end
      

      local pos = GetEntityCoords(PlayerPedId())

      Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
      spawned_car = CreateVehicle(model, garges[i][1], garges[i][2], garges[i][3], garges[i][4], true, false)
      SetVehicleFixed(spawned_car)
      SetVehicleEngineHealth(spawned_car, 1000.0)
      SetVehicleBodyHealth(spawned_car, 1000.0)
      local plate = "TRU ".. GetRandomIntInRange(1000, 9000)
      DecorSetInt(spawned_car, "CurrentFuel", 100)
      existingVeh = spawned_car
      SetVehicleOnGroundProperly(existingVeh)

      SetVehicleNumberPlateText(existingVeh, plate)
      TriggerEvent("keys:addNew",existingVeh,plate)
      TriggerServerEvent('garges:addJobPlate', plate)

      SetPedIntoVehicle(playerPed, existingVeh, -1)
      local finished = exports["np-taskbar"]:taskBar(3000,"Checking Vehicle")
      if finished == 100 then
      SetVehicleEngineHealth(spawned_car, 1000.0)
      SetVehicleBodyHealth(spawned_car, 1000.0)
      SetVehiclePetrolTankHealth(spawned_car, 1000.0)

end

end

function SpawnSaleVehicles(garageNum)
  if #spawnedvehicles > 0 then
    DespawnSaleVehicles()
  end
  for i=1,#garges do

      local model = `mule2`
      RequestModel(model)
      while not HasModelLoaded(model) do
          Wait(1)
      end 
      local veh = CreateVehicle(model,garges[i][1],garges[i][2],garges[i][3],garges[i][4],false,false)
      
      SetVehicleOnGroundProperly(veh)
      SetEntityInvincible(veh,true)

      
      spawnedvehicles[i] = veh
      SetVehicleDoorsLocked(veh, 2)
      FreezeEntityPosition(veh,true)
      vehicles_spawned = true

  end
  
end

function DespawnSaleVehicles()
  vehicles_spawned = false
  for i,v in pairs(spawnedvehicles) do
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(spawnedvehicles[i]))
  end
  spawnedvehicles = {}
end

function DrawSpawning(garageNum)
  for i,v in ipairs(garges) do
    if (garageNum == 1 and i >= 1 and i <= 4) or (garageNum == 2 and i >= 5 and i <= 7) then
      if v[5] then
        if #(vector3(v[1],v[2],v[3]) - GetEntityCoords(PlayerPedId())) < 5.5 then
          DrawText3Ds(v[1],v[2],v[3],Controlkey["generalUse"][2].." to pull out Truck.")
          if(IsControlJustPressed(1, Controlkey["generalUse"][1])) then

            if job ~= 0 then
              TriggerServerEvent("trucker:CarUsed",i)
            else
              TriggerEvent("DoLongHudText","You need a Job Set - Sign on as trucker then Open your phone to select a available delivery.",2)
            end
            
            Wait(2000)
          end
        end
      end
    end
  end
end

RegisterNetEvent("trucker:acceptspawn")
AddEventHandler("trucker:acceptspawn", function(i)
    spawnTruck(i)
end)