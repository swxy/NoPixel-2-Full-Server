NPX.Player = NPX.Player or {}
NPX.LocalPlayer = NPX.LocalPlayer or {}

local function GetUser()
    return NPX.LocalPlayer
end

function NPX.LocalPlayer.setVar(self, var, data)
    GetUser()[var] = data
end

function NPX.LocalPlayer.getVar(self, var)
    return GetUser()[var]
end

function NPX.LocalPlayer.setCurrentCharacter(self, data)
    if not data then return end
    GetUser():setVar("character", data)
end

function NPX.LocalPlayer.getCurrentCharacter(self)
    return GetUser():getVar("character")
end

RegisterNetEvent("np-base:networkVar")
AddEventHandler("np-base:networkVar", function(var, val)
    NPX.LocalPlayer:setVar(var, val)
end)