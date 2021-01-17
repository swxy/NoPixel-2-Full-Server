-- Settings
local guiEnabled = false
local hasOpened = false

local endloop = false
-- Open Gui and Focus NUI
function openGui()
  SetPlayerControl(PlayerId(), 0, 0)
  guiEnabled = true
  SetNuiFocus(true)
  SendNUIMessage({openContracts = true})
end

-- Close Gui and disable NUI
function closeGui()
  endloop = true
  SetNuiFocus(false)
  SendNUIMessage({openSection = "close"})
  guiEnabled = false
  SetPlayerControl(PlayerId(), 1, 0)
end

-- Disable controls while GUI open
Citizen.CreateThread(function()
  closeGui()
  while true do
    if guiEnabled then
      if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({type = "click"})
      end
    end
    Citizen.Wait(0)
  end
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)


RegisterNetEvent('FishList')
AddEventHandler('FishList', function(metaData)
  openGui()
  SendNUIMessage({openSection = "fishOpen", NUICaseId = metaData.caseId})
  for i,v in ipairs(metaData.data) do
      SendNUIMessage({openSection = "fishUpdate",  name = v.name, size = v.size})
  end  
end)