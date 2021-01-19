local guiEnabled = false

-- Open Gui and Focus NUI
function openGui()
  local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
  --if not isInVeh then
  --  SetPlayerControl(PlayerId(), 0, 0)
  --end
  guiEnabled = true
  SetCustomNuiFocus(true,true)
  SendNUIMessage({openWarrants = true})
   TriggerEvent('animation:tablet',true)
end

function openGuiDoctor()
  local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
  if not isInVeh then
    SetPlayerControl(PlayerId(), 0, 0)
  end
  guiEnabled = true
  SetCustomNuiFocus(true,true)
  SendNUIMessage({openDoctors = true})
   TriggerEvent('animation:tablet',true)
end

function openpr()
  SetPlayerControl(PlayerId(), 0, 0)
  guiEnabled = true
  SetCustomNuiFocus(true,true)
    SendNUIMessage({
      openSection = "publicrecords"
    })
   TriggerEvent('animation:tablet',true)
end

-- Close Gui and disable NUI
function closeGui()
  SetCustomNuiFocus(false,false)
  guiEnabled = false
  TriggerEvent('animation:tablet',false)
  Wait(250)
  ClearPedTasks(PlayerPedId())
  SetPlayerControl(PlayerId(), 1, 0)
end

RegisterNetEvent("phone:publicrecords")
AddEventHandler("phone:publicrecords", function()
    openpr()
end)

-- Opens our warrants
RegisterNetEvent('warrantsGui')
AddEventHandler('warrantsGui', function()
  openGui()
  guiEnabled = true
end)

RegisterNetEvent('mdt:close')
AddEventHandler('mdt:close', function()
  closeGui()
  SendNUIMessage({
    closeGUI = true
  })
end)

RegisterNetEvent('doctorGui')
AddEventHandler('doctorGui', function()
  openGuiDoctor()
  guiEnabled = true
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

function SetCustomNuiFocus(hasKeyboard, hasMouse)
  HasNuiFocus = hasKeyboard or hasMouse

  SetNuiFocus(hasKeyboard, hasMouse)
  SetNuiFocusKeepInput(HasNuiFocus)

  TriggerEvent("np:voice:focus:set", HasNuiFocus, hasKeyboard, hasMouse)
end