RegisterServerEvent('NewsStandCheckFinish')
AddEventHandler('NewsStandCheckFinish', function(strg, strg2)
  local src = source
  TriggerClientEvent('NewsStandCheckFinish', src, strg, strg2)
end)

-- cleared and removed ((sway))