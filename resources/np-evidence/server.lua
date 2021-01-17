RegisterServerEvent('evidence:pooled')
AddEventHandler('evidence:pooled', function(data)
    TriggerClientEvent('evidence:pooled',-1,data)
end)

RegisterServerEvent('evidence:removal')
AddEventHandler('evidence:removal', function(id)
    TriggerClientEvent('evidence:remove:done',-1,id)
end)

RegisterServerEvent('evidence:clear')
AddEventHandler('evidence:clear', function(id)
    for k,v in ipairs(id) do
      TriggerClientEvent('evidence:remove:done',-1,v)
    end
end)