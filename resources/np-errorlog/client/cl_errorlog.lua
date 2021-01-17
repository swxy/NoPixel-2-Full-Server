local oldError = error
local oldTrace = Citizen.Trace

local errorWords = {"failure", "error", "not", "failed", "not safe", "invalid", "cannot", ".lua", "server", "client", "attempt", "traceback", "stack", "function"}

function error(...)
    local resource = GetCurrentResourceName()
    print("------------------ ERROR IN RESOURCE: " .. resource)
    print(...)
    print("------------------ END OF ERROR")
    TriggerServerEvent("error", resource, args)
end

function Citizen.Trace(...)
    oldTrace(...)

    if type(...) == "string" then
        args = string.lower(...)
        
        for _, word in ipairs(errorWords) do
            if string.find(args, word) then
                error(...)
                return
            end
        end
    end
end
