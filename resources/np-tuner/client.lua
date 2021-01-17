-- Settings
local guiEnabled = false
local hasOpened = false
local serverNotes = {
  
}

-- Open Gui and Focus NUI
function openGui()
  SetPlayerControl(PlayerId(), 0, 0)
  guiEnabled = true
  SetNuiFocus(true)
  Citizen.Trace("OPENING")
  SendNUIMessage({openSection = "openNotepad"})
end

function openGuiRead(text)
  SetPlayerControl(PlayerId(), 0, 0)
  guiEnabled = true
  SetNuiFocus(true)
  Citizen.Trace("OPENING")
  SendNUIMessage({openSection = "openNotepadRead", TextRead = text})


end


-- Close Gui and disable NUI
function closeGui()
  guiEnabled = false
  ped = PlayerPedId();
  ClearPedTasks(ped);
  Citizen.Trace("CLOSING")
  SetNuiFocus(false)
  SendNUIMessage({openSection = "close"})
  SetPlayerControl(PlayerId(), 1, 0)
end

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)
local plate="testicle"
local vehicleDefaultTable = {
  -- ["" .. veh .. ""] = {
  --    ["fInitialDriveForce"] = 1.50000, 
  --    ["fClutchChangeRateScaleUpShift"] = 1.50000,
  --    ["fClutchChangeRateScaleDownShift"] = 1.50000,
  --    ["fBrakeBiasFront"] = 1.50000,
  --    ["fDriveBiasFront"] = 1.50000,
  --  }
}

local vehicleTable = {
  -- ["" .. veh .. ""] = {
  --   [1] = 0,
  --   [2] = 0,
  --   [3] = 0,
  --   [4] = 5,
  --   [5] = 5
  -- }
}

function doBoostFuel(amount,amount2,veh,plate)
    print("Boost Start  : " .. GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce'))
    print("Low Traction Loss Start  : " .. GetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult'))
    local amount = amount
    if amount == 0 then
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', vehicleDefaultTable["" .. veh .. ""]["fInitialDriveForce"])
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult', vehicleDefaultTable["" .. veh .. ""]["fLowSpeedTractionLossMult"])
      print("Set boost and fuel to default")
    else
      local defaultBoost = vehicleDefaultTable["" .. veh .. ""]["fInitialDriveForce"]
      local defaultTLoss = vehicleDefaultTable["" .. veh .. ""]["fLowSpeedTractionLossMult"]
      local new = defaultBoost + defaultBoost * (amount/200)
      local new2 = defaultTLoss + defaultTLoss * (amount/20)
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', new)
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult', new2)
    end
    print("Boost Set: " .. GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce'))
    print("Low Traction Loss End  : " .. GetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult'))




    print("Boost Start  : " .. GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce'))
    print("fDriveInertia : " .. GetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveInertia'))

    if amount2 == 0 and amount == 0 then

      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveInertia', vehicleDefaultTable["" .. veh .. ""]["fDriveInertia"])
      print("Set boost and fuel to default")
    else
      local defaultBoost = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
      local defaultfDriveInertia = vehicleDefaultTable["" .. veh .. ""]["fDriveInertia"]
      local new = defaultBoost + defaultBoost * (amount2/200)

      local new2 = defaultfDriveInertia - defaultfDriveInertia * (amount2/30)
      if new2 < 0.5 then
        new2 = 0.5
      end
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', new)
       SetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveInertia', new2)
    end
    print("Boost Set: " .. GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce'))
    print("fDriveInertia : " .. GetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveInertia'))


end

function doGears(amount,veh,plate)
    print("fClutchChangeRateScaleUpShift : " .. GetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift'))

    print("fInitialDragCoeff : " .. GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff'))

    if amount == 0 then
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', vehicleDefaultTable["" .. veh .. ""]["fClutchChangeRateScaleUpShift"])
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleDownShift', vehicleDefaultTable["" .. veh .. ""]["fClutchChangeRateScaleDownShift"])
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff', vehicleDefaultTable["" .. veh .. ""]["fInitialDragCoeff"])
      print("Set gears to default")
    else
      local defaultShift = vehicleDefaultTable["" .. veh .. ""]["fClutchChangeRateScaleUpShift"]
      local defaultShift2 = vehicleDefaultTable["" .. veh .. ""]["fClutchChangeRateScaleUpShift"]
      local fInitialDragCoeff = vehicleDefaultTable["" .. veh .. ""]["fInitialDragCoeff"]
      local new = defaultShift + amount
      local new2 = defaultShift2 + amount
      local new3 = fInitialDragCoeff + (amount/50)
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', new)
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleDownShift', new2)
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff', new3)
      print("Gears | Downshift | Take Off",new,new2,new3)
    end
end

function doBraking(amount,veh,plate)
    if amount == 5 then
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeBiasFront', vehicleDefaultTable["" .. veh .. ""]["fBrakeBiasFront"])
      print("Braking set to default.")
    else
      local defaultBrakeBias = vehicleDefaultTable["" .. veh .. ""]["fBrakeBiasFront"]
      local new = (amount/10)
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeBiasFront', new)
      print("Braking Bias Set: " .. new)
    end
end

function doDrive(amount,veh,plate)
    if amount == 5 then
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveBiasFront', vehicleDefaultTable["" .. veh .. ""]["fDriveBiasFront"])
      print("Drive set to default.")
    else
      local defaultBrakeBias = vehicleDefaultTable["" .. veh .. ""]["fDriveBiasFront"]
      local new = (amount/10)
      SetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveBiasFront', new)
      print("Drive Train Set: " .. new)
    end
end


function modify(boost,fuel,gears,braking,drive,veh,plate)
    doBoostFuel(boost,fuel,veh,plate)
    doGears(gears,veh,plate)
    doBraking(braking,veh,plate)
    doDrive(drive,veh,plate)

    TriggerServerEvent("tuner:modify",vehicleTable["" .. veh .. ""],vehicleDefaultTable["" .. veh .. ""],plate)
end

RegisterNetEvent('tuner:setNew')
AddEventHandler('tuner:setNew', function(defaultTable,newTable)
  vehicleDefaultTable = defaultTable
  vehicleTable = newTable
end)


RegisterNetEvent('tuner:setDriver')
AddEventHandler('tuner:setDriver', function()
    local veh = GetVehiclePedIsUsing(PlayerPedId())  
    if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
      if vehicleTable["" .. veh .. ""] ~= nil then
        Wait(1000)
        local df = vehicleTable["" .. veh .. ""][1]
        local gr1 = vehicleTable["" .. veh .. ""][2]
        local gr2 = vehicleTable["" .. veh .. ""][3]
        local bb = vehicleTable["" .. veh .. ""][4]
        local db = vehicleTable["" .. veh .. ""][5]
        print("Stored Alterions Attached",df,gr1,gr2,bb,db)
        modify(df,gr1,gr2,bb,db,veh,plate)
      end
    end
end)






RegisterNetEvent('tuner:open')
AddEventHandler('tuner:open', function()
    Wait(1000)
    local veh = GetVehiclePedIsUsing(PlayerPedId())  
    if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
      if GetEntitySpeed(veh) < 0.1 then
        local plate = GetVehicleNumberPlateText(veh)

        if vehicleTable["" .. veh .. ""] then
          print("We already have default values set.")
        else
          print("We are setting our default values.")
          vehicleDefaultTable["" .. veh .. ""] = {
            ["fInitialDriveForce"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce'), 
            ["fClutchChangeRateScaleUpShift"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift'),
            ["fClutchChangeRateScaleDownShift"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleDownShift'),
            ["fBrakeBiasFront"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeBiasFront'),
            ["fDriveBiasFront"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveBiasFront'),
            ["nInitialDriveIntertia"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'nInitialDriveIntertia'),
            ["fMass"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fMass'),
            ["fInitialDragCoeff"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff'),
            ["fBrakeForce"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce'),
            ["fLowSpeedTractionLossMult"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult'),
            ["fDriveInertia"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveInertia'),

          } 
          vehicleTable["" .. veh .. ""] = {
            [1] = 0,
            [2] = 0,
            [3] = 0,
            [4] = 5,
            [5] = 5
          }

        end

        local df = vehicleTable["" .. veh .. ""][1]
        local gr1 = vehicleTable["" .. veh .. ""][2]
        local gr2 = vehicleTable["" .. veh .. ""][3]
        local bb = vehicleTable["" .. veh .. ""][4]
        local db = vehicleTable["" .. veh .. ""][5]

        openGui(df,gr1,gr2,bb,db)

        guiEnabled = true
      end
    end
end)


RegisterNUICallback('tuneSystem', function(data, cb)
  closeGui()
  local boost = data.boost
  local fuel = data.fuel
  local gears = data.gears
  local braking = data.braking
  local drive = data.drive

  local veh = GetVehiclePedIsUsing(PlayerPedId())  
  if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
    local plate = GetVehicleNumberPlateText(veh)
    vehicleTable["" .. veh .. ""][1] = boost
    vehicleTable["" .. veh .. ""][2] = fuel
    vehicleTable["" .. veh .. ""][3] = gears
    vehicleTable["" .. veh .. ""][4] = braking
    vehicleTable["" .. veh .. ""][5] = drive

    modify(boost,fuel,gears,braking,drive,veh,plate)
  end
  -- submit here
  --cb('ok')
end)


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
