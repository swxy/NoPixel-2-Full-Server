RegisterNetEvent('settax0')
AddEventHandler('settax0', function()
  TriggerServerEvent('setTaxGlobal',0)
end)
RegisterNetEvent('settax5')
AddEventHandler('settax5', function()
  TriggerServerEvent('setTaxGlobal',5)
end)
RegisterNetEvent('settax10')
AddEventHandler('settax10', function()
  TriggerServerEvent('setTaxGlobal',10)
end)
RegisterNetEvent('settax15')
AddEventHandler('settax15', function()
  TriggerServerEvent('setTaxGlobal',15)
end)

RegisterNetEvent('setEMS0')
AddEventHandler('setEMS0', function()
  TriggerServerEvent('setEmsPay',0)
end)

RegisterNetEvent('setEMS50')
AddEventHandler('setEMS50', function()
  TriggerServerEvent('setEmsPay',50)
end)

RegisterNetEvent('setEMS100')
AddEventHandler('setEMS100', function()
  TriggerServerEvent('setEmsPay',100)
end)

RegisterNetEvent('setEMS200')
AddEventHandler('setEMS200', function()
  TriggerServerEvent('setEmsPay',200)
end)


RegisterNetEvent('setPolice0')
AddEventHandler('setPolice0', function()
  TriggerServerEvent('setPolicePay',0)
end)

RegisterNetEvent('setPolice50')
AddEventHandler('setPolice50', function()
  TriggerServerEvent('setPolicePay',50)
end)

RegisterNetEvent('setPolice100')
AddEventHandler('setPolice100', function()
  TriggerServerEvent('setPolicePay',100)
end)

RegisterNetEvent('setPolice200')
AddEventHandler('setPolice200', function()
  TriggerServerEvent('setPolicePay',200)
end)


RegisterNetEvent('setCivilian0')
AddEventHandler('setCivilian0', function()
  TriggerServerEvent('setCivilianPay',0)
end)

RegisterNetEvent('setCivilian50')
AddEventHandler('setCivilian50', function()
  TriggerServerEvent('setCivilianPay',50)
end)

RegisterNetEvent('setCivilian100')
AddEventHandler('setCivilian100', function()
  TriggerServerEvent('setCivilianPay',100)
end)



RegisterNetEvent('updatepasses')
AddEventHandler('updatepasses', function()
  TriggerServerEvent('updatePasses')
end)


RegisterNetEvent('checkmayorcash')
AddEventHandler('checkmayorcash', function()
  TriggerServerEvent('checkmayorcash')
end)

RegisterNetEvent('nextElection')
AddEventHandler('nextElection', function()
  TriggerServerEvent('nextElection')
end)

RegisterNetEvent('nextValueCheck')
AddEventHandler('nextValueCheck', function()
	TriggerServerEvent('nextValueCheck')
end)
mayorTax = 0
RegisterNetEvent('setTax')
AddEventHandler('setTax', function(mayortax)
	mayorTax = mayortax
	TriggerEvent("DoLongHudText","Tax is currently set to: " .. mayorTax .. "%",1)
end)

function getTax()
	return mayorTax
end

messaged = false

RegisterNetEvent('taxMessage')
AddEventHandler('taxMessage', function()
    if not messaged then
      messaged = true
      TriggerEvent("chatMessage", "Info: ", {255, 0, 0}, "All seen payments do not include the Mayor tax.")
      Citizen.Wait(10000)
      messaged = false
    end
end)



-- 1 client, 2 server tax
--local currenttax = exports["np-votesystem"]:getTax()
--player:getTax()
-- 

--  local curTax = user:getTax()
--  local price = price + (price * (curTax/100))
-- local price = math.ceil(price)
-- local aids = costs * (curTax/100)
--  TriggerEvent('votesystem:addfunds',aids)



RegisterCommand('testing', function()
  TriggerEvent('updatepasses')
end)


