myBlips = {}
local currentJob = ""

-- Events
RegisterNetEvent('phoneGui')
AddEventHandler('phoneGui', function()
  TriggerEvent('jobssystem:current', function(job)
    if job == nil or job == "unemployed" or job == "trucker" then
      SendNUIMessage({ toggleAlerts = true, status = false })
    else
      SendNUIMessage({ toggleAlerts = true, status = true })
    end
  end)
end)


RegisterNetEvent('phone:registerBlip')
AddEventHandler('phone:registerBlip', function(pData)
  addBlip(pData)
end)

RegisterNetEvent('phone:assistClear')
AddEventHandler('phone:assistClear', function(id,jobsent)
  TriggerEvent('jobssystem:current', function(job)
    if myBlips[id] ~= nil and not myBlips[id].onRoute and (job == jobsent or (job == "police" and jobsent == "911")) then
      clearBlip(myBlips[id])
    end
  end)
end)

local holding = false
RegisterNetEvent('phone:currentNewsState')
AddEventHandler('phone:currentNewsState', function(isHolding)
  holding = isHolding
end)

local lastBlip = {}
local newsPayment = 0
local blipcount = 0

RegisterNetEvent('phone:assistPayJ')
AddEventHandler('phone:assistPayJ', function(name)

    if name == 'taxi' then
      
      local ped = PlayerPedId()
      local currentVehicle = GetVehiclePedIsIn(ped, false)
      local driverPed = GetPedInVehicleSeat(currentVehicle, -1)

      if driverPed then
        if IsPedInAnyTaxi(ped) then
          TriggerServerEvent("server:givepayJob", "Taxi Service", math.random(1,300))
        else
          TriggerEvent("DoLongHudText","Please use a taxi or sign off duty.",2)
        end   
      end

    elseif name == 'towtruck' then
      TriggerServerEvent("server:givepayJob", "Tow Service", math.random(1,300))

    elseif name == 'news' then
      blipcount = blipcount + 1
      lastBlip = GetEntityCoords(ped)
      newsPayment = newsPayment +  math.random(1,200)
      TriggerEvent("DoLongHudText","Payment added to next payout.",2)

   else
      TriggerServerEvent("server:givepayJob", "Assist Blip Payment (Emergency)", math.random(1,300))

   end

end)

-- entertainer locations for job

nearEntertainments = {
  {x=377.01,y=-991.37,z=-98.6},
  {x=-551.63,y=284.18,z=82.98},
  {x=684.34,y=571.87,z=130.47},
}

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end
function GetClosestPlayers()
  local players = GetPlayers()
  local ply = PlayerPedId()
  local plyCoords = GetEntityCoords(ply, 0)
  local closestplayers = {}
  for index,value in ipairs(players) do
    local target = GetPlayerPed(value)
    if(target ~= ply) then
      local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
      local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
      if(distance < 25) then
        closestplayers[#closestplayers+1]=target
      end
    end
  end
  return #closestplayers
end

function CountPlayers() -- function to get players
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return #players
end

function nearEntertainment()

  for _,k in pairs(nearEntertainments) do

    local distance = #(GetEntityCoords(PlayerPedId()) - vector3(k.x,k.y,k.z))

    if(distance < 3.0) then
      return true
    end

  end

  return false
end


Citizen.CreateThread(function()
  local timer = 0
  local canPay = true

  while true do

    Citizen.Wait(60000)

    if nearEntertainment() and exports["np-base"]:getModule("LocalPlayer"):getVar("job") == "entertainer" then

      playerCount = GetClosestPlayers()
      local payment = math.ceil(8 * playerCount)
      if payment > 50 then
        payment = 50
      end
      TriggerServerEvent("server:givepayJob", "Entertainer Payment - Near Players = " .. playerCount, payment) 
    elseif exports["np-base"]:getModule("LocalPlayer"):getVar("job") == "news" then
      local dist = 0
      if lastBlip.x then
        dist = #(GetEntityCoords(PlayerPedId()) - vector3(lastBlip.x,lastBlip.y,lastBlip.z))
      end
      if holding and dist < 130 and dist ~= 0 and blipcount >= 1 then
        playerCount = GetClosestPlayers()
        local pay = newsPayment + (25 * playerCount)
        TriggerServerEvent("server:givepayJob", "News Reporter",pay) 
        newsPayment = 0
        blipcount = 0 
        TriggerEvent("DoLongHudText","You have been paid a bonus for your dedication.",2)
      else
        if newsPayment ~= 0 then
          TriggerServerEvent("server:givepayJob", "News Reporter",newsPayment) 
          newsPayment = 0
        end
      end
      Citizen.Wait(2400000)
    else
      if exports["np-base"]:getModule("LocalPlayer"):getVar("job") == "entertainer" then
        Citizen.Wait(300000)
      end
    end

  end

end)


-- entertainer shit ^^

Citizen.CreateThread(function()
  local timer = 0
  local canPay = true
  while true do
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local curTime = GetGameTimer()
    if timer >= 300 then canPay = true end -- Time limit ,300 = 5 min ,1000 ms * 300 = 5 min 
    timer = timer +1

    for key, item in pairs(myBlips) do
      if (key ~= nil and item ~= nil) then
        -- If we are within 10 units of a blip that is not our own, clear the blip and message the server to clear for everyone
        if #(vector2(pos.x, pos.y) - vector2(item.pos.x, item.pos.y)) < 50.0 then
          if item.jobType == "ems" then
            if exports["np-base"]:getModule("LocalPlayer"):getVar("job") == "ems" then
              TriggerServerEvent('phone:assistRemove', item.id, item.jobType) -- Send message of clear to others
              clearBlip(item)
              if GetTimeDifference(curTime, item.timestamp) > 2000 then
                if canPay then
                  canPay = false
                  timer = 0
                  TriggerServerEvent('phone:checkJob')
                end
              end
            end
          elseif item.jobType == "news" then 
            if exports["np-base"]:getModule("LocalPlayer"):getVar("job") == "news" then
              TriggerServerEvent('phone:assistRemove', item.id, item.jobType) -- Send message of clear to others
              clearBlip(item)
              if GetTimeDifference(curTime, item.timestamp) > 2000 then
                if canPay then
                  canPay = false
                  timer = 0
                  TriggerServerEvent('phone:checkJob')
                end
              end
            end
          else
             TriggerServerEvent('phone:assistRemove', item.id, item.jobType) -- Send message of clear to others
              clearBlip(item)
              if GetTimeDifference(curTime, item.timestamp) > 2000 then
                if canPay then
                  canPay = false
                  timer = 0
                  TriggerServerEvent('phone:checkJob')
                end

              end
          end
        elseif GetTimeDifference(curTime, item.timestamp) > 600000 and not item.onRoute then
          -- If its been passed 10 minutes, clear the bip locally unless it's a blip we are on route to
          clearBlip(item)
        end
      end
    end

    Citizen.Wait(1000)
  end
end)

RegisterNetEvent("clearJobBlips")
AddEventHandler("clearJobBlips", function()
  -- Clear all our blips as our job has changed
  for key, item in pairs(myBlips) do
    if (key ~= nil and item ~= nil) then
      clearBlip(item)
    end
  end
end)

function addBlip(data)
  local blip = AddBlipForCoord(data.blipLocation.x, data.blipLocation.y, data.blipLocation.z)
  SetBlipScale(blip, 2.0)
  if data.isImportant then
    SetBlipFlashesAlternate(blip,true)
  end
  SetBlipSprite(blip, data.blipSprite)
  SetBlipColour(blip, data.blipColor)
  if data.currentJob == "news" then
    SetBlipSprite(blip, 459)
  end
  SetBlipAlpha(blip, 180)
  SetBlipHighDetail(blip, 1)
  BeginTextCommandSetBlipName("STRING")
  local displayText = data.blipDescription
  if data.currentJob == "news" then
    displayText = 'Scanner | ' .. data.blipDescription
  else
    displayText = data.blipTenCode .. " | " .. data.blipDescription
  end
  AddTextComponentString(displayText)
  EndTextCommandSetBlipName(blip)

  local blipId = math.random(1,60000)-- GetCloudTimeAsInt() + math.random(1,5)
  myBlips[blipId] = {
    timestamp = GetGameTimer(),
    pos = {
      x = data.blipLocation.x,
      y = data.blipLocation.y,
      z = data.blipLocation.z
    },
    blip = blip,
    id = blipId,
    jobType = data.currentJob
  }
  PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
end

function clearBlip(item)
  if item == nil then
    return
  end

  local id = item.id
  local pedb = item.blip

  if item.onRoute then
    SetBlipRoute(pedb, false) 
  end

  if pedb ~= nil and DoesBlipExist(pedb) then
    myBlips[id] = nil
    SetBlipSprite(pedb, 2)
    SetBlipDisplay(pedb, 3)
    RemoveBlip(dblip)
  end
end