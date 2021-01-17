NPX.Core = NPX.Core or {}

function NPX.Core.ConsoleLog(self, msg, mod)
    if not tostring(msg) then return end
    if not tostring(mod) then mod = "No Module" end
    
    local pMsg = string.format("[NPX LOG - %s] %s", mod, msg)
    if not pMsg then return end

    print(pMsg)
end

RegisterNetEvent("np-base:consoleLog")
AddEventHandler("np-base:consoleLog", function(msg, mod)
    NPX.Core:ConsoleLog(msg, mod)
end)

function getModule(module)
    if not NPX[module] then print("Warning: '" .. tostring(module) .. "' module doesn't exist") return false end
    return NPX[module]
end

function addModule(module, tbl)
    if NPX[module] then print("Warning: '" .. tostring(module) .. "' module is being overridden") end
    NPX[module] = tbl
end

NPX.Core.ExportsReady = false

function NPX.Core.WaitForExports(self)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if exports and exports["np-base"] then
                TriggerEvent("np-base:exportsReady")
                NPX.Core.ExportsReady = true
                return
            end
        end
    end)
end

NPX.Core:WaitForExports()