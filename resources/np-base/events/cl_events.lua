NPX.Events = NPX.Events or {}
NPX.Events.Total = 0
NPX.Events.Active = {}

function NPX.Events.Trigger(self, event, args, callback)
    local id = NPX.Events.Total + 1
    NPX.Events.Total = id

    id = event .. ":" .. id

    if NPX.Events.Active[id] then return end

    NPX.Events.Active[id] = {cb = callback}
    
    TriggerServerEvent("np-events:listenEvent", id, event, args)
end

RegisterNetEvent("np-events:listenEvent")
AddEventHandler("np-events:listenEvent", function(id, data)
    local ev = NPX.Events.Active[id]
    
    if ev then
        ev.cb(data)
        NPX.Events.Active[id] = nil
    end
end)