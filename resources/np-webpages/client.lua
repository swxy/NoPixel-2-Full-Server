
function openCalc()
    SendNUIMessage({openSection = "calculator"})
    SetNuiFocus(true,true)
end

function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({openSection = "close"})
end

RegisterNUICallback('close', function()
  closeGui()
end)


RegisterCommand('calculator', function(source, args)
  openCalc()
end)



RegisterNetEvent('openCalculator')
AddEventHandler('openCalculator', function()
	openCalc()
end)