local serverNotes = {}

RegisterServerEvent("server:destroyNote")
AddEventHandler("server:destroyNote", function(closestNoteId)
    table.remove(serverNotes,closestNoteId)
    TriggerClientEvent('client:updateNotesRemove', -1, closestNoteId)
end)

RegisterServerEvent("server:newNote")
AddEventHandler("server:newNote", function(text,x,y,z)
    serverNotes[#serverNotes+1] = { text = text, x = x, y = y, z = z }
    TriggerClientEvent('client:updateNotesAdd', -1, { text = text, x = x, y = y, z = z })
end)

RegisterServerEvent("server:requestNotes")
AddEventHandler("server:requestNotes", function()
    local src = source
    TriggerClientEvent('client:updateNotes', src, serverNotes)
end)

RegisterCommand('notepad', function(source)
    TriggerClientEvent('Notepad:open', source)
end)