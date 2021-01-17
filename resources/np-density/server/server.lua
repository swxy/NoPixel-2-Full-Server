RegisterNetEvent('np:peds:rogue')
AddEventHandler('np:peds:rogue', function(toDelete)
  if toDelete == nil then return end

  TriggerClientEvent("np:peds:rogue:delete",-1, toDelete)
end)