local location = 0

function openGui()
    SetNuiFocus(true,true)
    SendNUIMessage({open = true})
end

function CloseGui()
    SetNuiFocus(false,false)
    SendNUIMessage({close = true})
end

RegisterNUICallback('close', function(data, cb)
  CloseGui()
  cb('ok')
end)

RegisterNUICallback('complete', function(data, cb)
  TriggerEvent("traphouse:open",location,data.pin)
  CloseGui()
  cb('ok')
end)

RegisterNetEvent('trap:attempt')
AddEventHandler('trap:attempt', function(num)
    location = num
    openGui()
end)

