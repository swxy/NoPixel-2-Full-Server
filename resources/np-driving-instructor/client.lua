
--[[ Client Variables --]]

local isInstructorMode = false
local myJob = "Unemployed"
local isInVehicle = false
local usingClipboard = false
local curTest = {
  cid = -1,
  instructor = '',
  points = 10,
  passed = true,
  results = {},
}
local actions = {
  vehicle = 0,
  isBraking = false
}
local drivingSchools = {
  vector3(983.83, -206.17, 71.07),
}

--[[ Functions --]]

function DrawText3Ds(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)

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

function updateNUI(tempData)
  tempData = tempData or false
  if exports["isPed"]:isPed("dead") then
    if not usingClipboard then
      SetNuiFocus(false,false)
      SendNUIMessage({show = false})
      TriggerEvent("drivingInstructor:clipboard")
    end
    return
  end
  if usingClipboard then
    if (not tempData) then
      SetNuiFocus(true,true)
      SendNUIMessage({show = true, data = curTest})
    else
      SetNuiFocus(true,false)
      SendNUIMessage({show = true, data = tempData, readonly = true})

      Citizen.CreateThread(function()
        while usingClipboard do
          Citizen.Wait(1)
          if IsControlJustPressed(1, 322) then
            SendNUIMessage({close = true})
          end
        end
      end)
    end
  else
    SetNuiFocus(false,false)
    SendNUIMessage({show = false})
  end
  TriggerEvent("drivingInstructor:clipboard", (not tempData))
end

function updateInstructor()
  if isInstructorMode then
    checkForVehicle()
    TriggerEvent("DoShortHudText","Instructor Mode: Enabled")
  else
    TriggerEvent("DoShortHudText","Instructor Mode: Disabled")
  end

  TriggerEvent("drivingInstructor:update", isInstructorMode) -- Sets isPed("drivingInstructor") value
end

function isVehicleAllowed(vehhicle) -- Check if the vehicle is one we allow instructor controls for
  local vehicleClass = GetVehicleClass(vehhicle)
  --  8: Motorcycles, 13: Cycles, 15: Helicopters, 16: Planes, 17: Service, 18: Emergency, 19: Military, 21: Trains  
  return (vehicleClass ~= 8 and vehicleClass ~= 13 and vehicleClass ~= 15 and vehicleClass ~= 16 and vehicleClass ~= 17 and vehicleClass ~= 18 and vehicleClass ~= 19 and vehicleClass ~= 21)
end

function checkForVehicle()
  isInVehicle = false -- Reset value until we check for new status

  Citizen.CreateThread(function()
    local playerPed = PlayerPedId()
    while isInstructorMode do
      local playerVeh = GetVehiclePedIsIn(playerPed, false)
      if isInVehicle then
        if playerVeh == 0 then
          isInVehicle = false
        end
      else
        if playerVeh ~= 0 and isVehicleAllowed(playerVeh) then -- Check if we weren't in a vehicle before but now are
          if exports["np-keys"]:hasKey(GetVehicleNumberPlateText(playerVeh)) then -- Only run on vehicles we have keys for
            isInVehicle = true
            instructorControls(playerPed, playerVeh) -- Got in vehicle, start checking for instructor actions
          end
        end
      end
      Wait(1000)
    end
  end)
end

function instructorControls(playerPed, veh)
  Citizen.CreateThread(function()
    local isBraking = false

    -- These functions are checked on tick so only check when we in Instructor Mode and in a vehicle
    while (isInstructorMode and isInVehicle) do
      if GetPedInVehicleSeat(veh, 0) == playerPed then -- Check if we are in the passenger seat
        if not isBraking and IsControlJustPressed(0, 22) then -- Braking ("SPACE")
          isBraking = true
          sendActionToDriver(veh, 1)
        elseif isBraking and IsControlJustReleased(0, 22) then -- Unbrake ("SPACE")
          isBraking = false
          sendActionToDriver(veh, 2)
        elseif IsControlJustPressed(0, 38) then -- Vehicle kill switch toggle ("E")
          sendActionToDriver(veh, 3) -- Engine toggle
        end
      end

      Wait(1)
    end

    sendActionToDriver(veh, 4) -- Clear any remaining actions
  end)
end

function sendActionToDriver(vehicle, action)
  local driverPed = GetPedInVehicleSeat(vehicle, -1)
  if driverPed > 0 then -- Find driver to send the action to
    TriggerServerEvent('driving:vehicleAction', GetPlayerServerId(NetworkGetPlayerIndexFromPed(driverPed)), action)
  else -- No driver found, so try the action locally
    TriggerEvent('drivingInstructor:vehicleAction', action)
  end
end

function isNearDrivingSchool()
  for i = 1, #drivingSchools do
    local drivingSchool = drivingSchools[i]
		local ply = PlayerPedId()
		local plyCoords = GetEntityCoords(ply, 0)
		local distance = #(drivingSchool - plyCoords)
		if(distance < 3.0) then
			DrawText3Ds(drivingSchool["x"], drivingSchool["y"], drivingSchool["z"], "[Y] Toggle Driving Instructor Mode" )
		end
		if(distance < 3.0) then
			return true
		end
	end
end

function checkForDrivingSchool()
  -- Check for instructor toggle
  Citizen.CreateThread(function()
    while (myJob == "driving instructor") do
      Citizen.Wait(0)

      if isNearDrivingSchool() then
        if IsControlJustPressed(1, 246) then -- [Y] key
          TriggerServerEvent('driving:toggleInstructorMode', isInstructorMode)
        end
      else
        Wait(2500)
      end
    end
  end)
end

--[[ Event Handlers --]]

RegisterNUICallback('close', function(data, cb)
  -- Obly set local variables if we have a valid cid
  if isInstructorMode and (data and data.cid and data.cid ~= -1) then
    curTest.cid = data.cid
    curTest.points = data.points
    curTest.passed = data.passed
    curTest.results = data.results
  end

  usingClipboard = false
  updateNUI()
  cb('ok')
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
  myJob = job

  if (job == "driving instructor") then
    checkForDrivingSchool()
  end
end)

RegisterNetEvent("drivingInstructor:instructorToggle")
AddEventHandler("drivingInstructor:instructorToggle", function(toggle, name)
  isInstructorMode = toggle

  if (name) then
    curTest.instructor = name
  end

  updateInstructor()
end)

RegisterNetEvent("drivingInstructor:testToggle")
AddEventHandler("drivingInstructor:testToggle", function()
  if not isInstructorMode then
    if usingClipboard then -- Close clipboard if we had it open
      usingClipboard = false
      updateNUI()
    else
      -- Only give error if they are trying to access the test when not in the proper mode
      TriggerEvent('DoLongHudText',"You must be in driving instructor mode to do this!", 2)
    end
  else
    usingClipboard = not usingClipboard

    updateNUI()
  end
end)

RegisterNetEvent("drivingInstructor:submitTest")
AddEventHandler("drivingInstructor:submitTest", function()
  if not isInstructorMode then
    TriggerEvent('DoLongHudText',"You must be in driving instructor mode to do this!", 2)
    return
  end

  if curTest.cid <= 0  then
    TriggerEvent('DoLongHudText',"You have not filled out the persons CID!", 2)
    return
  end

  TriggerServerEvent('driving:submitTest', curTest)
end)

RegisterNetEvent("drivingInstructor:viewResults")
AddEventHandler("drivingInstructor:viewResults", function(testData)
  usingClipboard = true

  updateNUI(testData)
end)

RegisterNetEvent("drivingInstructor:vehicleAction")
AddEventHandler("drivingInstructor:vehicleAction", function(action)
  local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
  if vehicle == 0 then
    actions.isBraking = false
    return
  else
    actions.vehicle = vehicle
  end

  if action == 1 then -- Brake
    actions.isBraking = true
    Citizen.CreateThread(function()
      local veh = actions.vehicle -- Localize here incase vehicle changes at some point before turning brakes back off
      local ped = PlayerPedId()
      while actions.isBraking do
        TaskVehicleTempAction(ped, veh, 24, 1)
        Citizen.Wait(0)
      end
    end)
  elseif action == 2 then -- Release Brake
    actions.isBraking = false
  elseif action == 3 then -- Engine Toggle
    if GetIsVehicleEngineRunning(actions.vehicle) then -- Turn Off
      SetVehicleEngineOn(actions.vehicle,0,1,1)
      SetVehicleUndriveable(actions.vehicle, true)
    else -- Turn On
      SetVehicleEngineOn(actions.vehicle,1,1,1)
      SetVehicleUndriveable(actions.vehicle, false)
    end
  elseif action == 4 then -- Instructor is no longer in control, clear any of their actions
    actions.isBraking = false
  end
end)

--[[ Animations --]]

RegisterNetEvent("drivingInstructor:clipboard")
AddEventHandler("drivingInstructor:clipboard", function(isWriting)
  local ped = PlayerPedId()
  local anim = "amb@world_human_clipboard@male@base"
  local board = "clipboard01"
  if isWriting then
    anim = "amb@medic@standing@timeofdeath@base"
    board = "clipboard02"
  end

  RequestAnimDict(anim)
  while not HasAnimDictLoaded(anim) do
    Citizen.Wait(0)
  end

  if usingClipboard then
    local intrunk = exports["isPed"]:isPed("intrunk")
    if not intrunk then
      TaskPlayAnim(ped, anim, "base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
    end
    Citizen.Wait(450)

    TriggerEvent("attachItem",board)
    Citizen.Wait(150)

    while usingClipboard do
      local dead = exports["isPed"]:isPed("dead")
      if dead then
        usingClipboard = false
        updateNUI()
      end
      intrunk = exports["isPed"]:isPed("intrunk")
      if not intrunk and not IsEntityPlayingAnim(ped, anim, "base", 3) then
        TaskPlayAnim(ped, anim, "base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
      end
      Citizen.Wait(1)
    end

    intrunk = exports["isPed"]:isPed("intrunk")
    if not intrunk then
      ClearPedTasks(ped)
    end
    TriggerEvent("destroyProp")
  else
    TriggerEvent("destroyProp")
    intrunk = exports["isPed"]:isPed("intrunk")
    if not intrunk then
      ClearPedTasks(ped)
      Citizen.Wait(400)
      TaskPlayAnim(ped, anim, "exit", 2.0, 1.0, 5.0, 49, 0, 0, 0, 0)
      Citizen.Wait(400)
      ClearPedTasks(ped)
    end
  end
end)
