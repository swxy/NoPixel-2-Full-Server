NPX.Events = NPX.Events or {}
NPX.Events.Registered = NPX.Events.Registered or {}

RegisterServerEvent("np-events:listenEvent")
AddEventHandler("np-events:listenEvent", function(id, name, args)
    local src = source

    if not NPX.Events.Registered[name] then return end

    NPX.Events.Registered[name].f(NPX.Events.Registered[name].mod, args, src, function(data)
        TriggerClientEvent("np-events:listenEvent", src, id, data)
    end)
end)

function NPX.Events.AddEvent(self, module, func, name)
    NPX.Events.Registered[name] = {
        mod = module,
        f = func
    }
end