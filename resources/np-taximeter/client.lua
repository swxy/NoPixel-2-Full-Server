-- Settings
local guiEnabled = false
local hasOpened = false
local endloop = false
local Total = 0
local PerMinute = 0
local BaseFare = 0
local frozen = false
local passenger = false
-- Open Gui and Focus NUI
function openGui()
  if guiEnabled then
    return
  end
  guiEnabled = true
  Citizen.Trace("OPENING tm")
  SendNUIMessage({openSection = "openTaxiMeter"})
  local inveh = IsPedSittingInAnyVehicle(PlayerPedId())
  -- If this is the first time we've opened the phone, load all warrants
end


-- Close Gui and disable NUI
function closeGui()
  ped = PlayerPedId();
  ClearPedTasks(ped);
  Citizen.Trace("CLOSING tm")
  endloop = true
  SendNUIMessage({openSection = "closeTaxiMeter"})
  guiEnabled = false
  SetPlayerControl(PlayerId(), 1, 0)
end
local lastupdate = 0
-- Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if guiEnabled then
      lastupdate = lastupdate + 1
      Citizen.Wait(6000)
      -- add update per Minute function here boro
      if not frozen then
        Total = Total + math.ceil(PerMinute / 10)  
      end

      local playerPed = PlayerPedId()
      local driverPed = GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1)
      local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))

      if playerPed == driverPed or passenger then

          SendNUIMessage({openSection = "updateTotal", sentnumber = "$"..Total..".00" })
          SendNUIMessage({openSection = "updatePerMinute", sentnumber = "$"..PerMinute..".00" })
          SendNUIMessage({openSection = "updateBaseFare", sentnumber = "$"..BaseFare..".00" }) 

        if frozen then
          TriggerEvent("DoLongHudText","Fare frozen.",2)
        end

        if not passenger and lastupdate == 5 then
          updateDriverMeter()
        end
             
        end

    else
      Citizen.Wait(10000)
    end
  end
end)





RegisterNetEvent('taximeter:PerMinute')
AddEventHandler('taximeter:PerMinute', function(numsent)
  local numsent = tonumber(numsent)
  if numsent < 0 then numsent = 0 end
  if numsent > 100 then numsent = 100 end
  local playerPed = PlayerPedId()
  local driverPed = GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1)
  local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
  local numsent = math.ceil(numsent)

  if IsPedInAnyVehicle(PlayerPedId(), false) then
    if GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == `taxi` and playerPed == driverPed then
      PerMinute = numsent
      Total = BaseFare
      --updateDriverMeter()
      TriggerEvent("taximeter:restartmeter")
    end
  end

end)

RegisterNetEvent('taximeter:BaseFare')
AddEventHandler('taximeter:BaseFare', function(numsent)
  local numsent = tonumber(numsent)
  if numsent < 0 then numsent = 0 end
  if numsent > 100 then numsent = 100 end
  local playerPed = PlayerPedId()
  local driverPed = GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1)
  local numsent = math.ceil(numsent)
  if IsPedInAnyVehicle(PlayerPedId(), false) then
    if GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == `taxi` and playerPed == driverPed then
      BaseFare = numsent
      Total = BaseFare
      --updateDriverMeter()
      TriggerEvent("taximeter:restartmeter")
    end
  end
end)

function updateDriverMeter()
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
    SendNUIMessage({openSection = "updateTotal", sentnumber = "$"..Total..".00" })
    SendNUIMessage({openSection = "updatePerMinute", sentnumber = "$"..PerMinute..".00" })
    SendNUIMessage({openSection = "updateBaseFare", sentnumber = "$"..BaseFare..".00" })      
    TriggerServerEvent("taxi:updatemeters",plate,Total,PerMinute,BaseFare)
    lastupdate = 0
end
RegisterNetEvent('taximeter:freeze')
AddEventHandler('taximeter:freeze', function()

  local playerPed = PlayerPedId()
  local driverPed = GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1)
  local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
  if GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == `taxi` and playerPed == driverPed then
    frozen = not frozen
    if frozen then
      TriggerServerEvent("taximeter:freeze",plate,true)
      TriggerEvent("DoLongHudText","Fare has been frozen.",2)
    else
      TriggerServerEvent("taximeter:freeze",plate,false)
      TriggerEvent("DoLongHudText","Fare has resumed.",1)
    end
  end
end)


-- this function will check if we are the driver and let the people
RegisterNetEvent('taximeter:RequestedFare')
AddEventHandler('taximeter:RequestedFare', function(plate)
  local playerPed = PlayerPedId()
  local driverPed = GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1)
  local curplate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
  if curplate == plate and playerPed == driverPed then
    updateDriverMeter()
  end 
end)


RegisterNetEvent('taximeter:updateFare')
AddEventHandler('taximeter:updateFare', function(plate,TotalSent,PerMinuteSent,BaseFareSent)
  local playerPed = PlayerPedId()
  local driverPed = GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1)
  local curplate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))

  if curplate == plate and playerPed ~= driverPed then
    openGui()
    passenger = true
    Total = TotalSent
    PerMinute = PerMinuteSent
    BaseFare = BaseFareSent
    SendNUIMessage({openSection = "updateTotal", sentnumber = "$"..Total })
    SendNUIMessage({openSection = "updatePerMinute", sentnumber = "$"..PerMinute..".00" })
    SendNUIMessage({openSection = "updateBaseFare", sentnumber = "$"..BaseFare..".00" }) 
  end


end)


RegisterNetEvent('taximeter:ExitedTaxi')
AddEventHandler('taximeter:ExitedTaxi', function()
    if guiEnabled then
      closeGui()
    end
    passenger = false
end)
-- upon entering any taxi that we dont drive, we do this to check its current fare
RegisterNetEvent('taximeter:EnteredTaxi')
AddEventHandler('taximeter:EnteredTaxi', function()
  local playerPed = PlayerPedId()
  local driverPed = GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1)
  local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
  if playerPed ~= driverPed then
    TriggerServerEvent("taxi:RequestFare",plate)
  elseif playerPed == driverPed then
    openGui()
    TriggerServerEvent("taxi:updatemeters",plate,Total,PerMinute,BaseFare)
  end
end)

RegisterNetEvent('taximeter:restartmeter')
AddEventHandler('taximeter:restartmeter', function()
  local playerPed = PlayerPedId()
  local driverPed = GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1)
  local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
  if GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == `taxi` and playerPed == driverPed then
    Total = BaseFare
    updateDriverMeter()
  end
end)

RegisterNetEvent('taximeter:FreezePlate')
AddEventHandler('taximeter:FreezePlate', function(platesent,result)

  local playerPed = PlayerPedId()
  local driverPed = GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1)
  local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
  if plate == nil then
    return
  end
  if plate == platesent and GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == `taxi` and playerPed ~= driverPed then
    frozen = result
  end
end)

RegisterNetEvent('taximeter:close')
AddEventHandler('taximeter:close', function()
  closeGui()
end)

RegisterNetEvent('taximeter:start')
AddEventHandler('taximeter:start', function()
  openGui()      
end)
