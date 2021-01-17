-- Settings
local guiEnabled = false
local hasOpened = false

local endloop = false
-- Open Gui and Focus NUI
function openGui()
  
  SetPlayerControl(PlayerId(), 0, 0)
  guiEnabled = true
  SetNuiFocus(true)
  Citizen.Trace("OPENING")
  SendNUIMessage({openSection = "openGurgle"})
  TriggerEvent("notepad")
  -- If this is the first time we've opened the phone, load all warrants
  if hasOpened == false then
    lstContacts = {}
    hasOpened = true
  end
end

-- Close Gui and disable NUI
function closeGui()
  ped = PlayerPedId();
  ClearPedTasks(ped);
  Citizen.Trace("CLOSING")
  endloop = true
  SetNuiFocus(false)
  SendNUIMessage({openSection = "closeGurgle"})
  guiEnabled = false
  SetPlayerControl(PlayerId(), 1, 0)
end

RegisterNUICallback('btnSubmit', function(data, cb)
  TriggerServerEvent("website:new",data.websiteName, data.websiteKeywords, data.websiteDescription)
  -- submitting.
  Citizen.Trace("submitting new site: " .. data.websiteName)
  closeGui()
  cb('ok')

end)
-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  TriggerEvent("enableGurgleText")
  cb('ok')
end)

RegisterNetEvent('Gurgle:close')
AddEventHandler('Gurgle:close', function()
  closeGui()
end)

RegisterNetEvent('Gurgle:open')
AddEventHandler('Gurgle:open', function()
  openGui()
end)

--local crime = { ["ContractID"] = v.id, ["amount"] = v.bill, ["Info"] = v.message }
local gurgleList = {
  -- [1] = { ["Title"] = "Website Title" ,["Keywords"] = "Website Keywords", ["Description"] = "Website Description"  }
}

