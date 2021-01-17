
local gui = false
local currentlyInGame = false
local passed = false;


function lockpick(pickhealth,pickdamage,pickPadding,distance)
  openGui()
  play(pickhealth,pickdamage,pickPadding,distance)
  currentlyInGame = true
  while currentlyInGame do
    Wait(400)
    if exports["isPed"]:isPed("dead") then 
      closeGui()
    end 
  end

  if passed then return 100 else return 0 end
end

function openGui()
    gui = true
    SetNuiFocus(true,true)
    SendNUIMessage({openPhone = true})
end


function play(pickhealth,pickdamage,pickPadding,distance) 
  SendNUIMessage({openSection = "playgame", health = pickhealth,damage = pickdamage,padding = pickPadding,solveDist = distance})
end

function CloseGui()
    currentlyInGame = false
    gui = false
    SetNuiFocus(false,false)
    SendNUIMessage({openPhone = false})
end

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  passed = false
  CloseGui()
  cb('ok')
end)

RegisterNUICallback('failure', function(data, cb)
  passed = false
  TriggerEvent("evidence:bleeding")
  CloseGui()
  cb('ok')
end)

RegisterNUICallback('complete', function(data, cb)
  passed = true
  CloseGui()
  cb('ok')
end)
