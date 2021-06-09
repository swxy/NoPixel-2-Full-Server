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


local WaitTime = 30000 -- How often do you want to update the status (In MS)
    local appid = '667510448538517520' -- Make an application @ https://discordapp.com/developers/applications/ ID can be found there.
    local asset = 'small' -- Go to https://discordapp.com/developers/applications/APPID/rich-presence/assets
    
    function SetRP()
        local name = GetPlayerName(PlayerId())
        local id = GetPlayerServerId(PlayerId())
    
        SetDiscordAppId(appid)
        --SetDiscordRichPresenceAsset(asset)
        
        SetDiscordRichPresenceAsset("big")
        SetDiscordRichPresenceAssetText(name)
    
        SetDiscordRichPresenceAssetSmall("small")
        SetDiscordRichPresenceAssetSmallText("Health: "..GetEntityHealth(GetPlayerPed(-1)))
    end
    
    Citizen.CreateThread(function()
        
        --SetRP()
        
        while true do
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
            local StreetHash = GetStreetNameAtCoord(x, y, z)
            Citizen.Wait(WaitTime)	
    
            SetRP()
            
            if StreetHash ~= nil then
                StreetName = GetStreetNameFromHashKey(StreetHash)
                if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
                    if IsPedSprinting(PlayerPedId()) then
                        SetRichPresence("Ducking down ops @ "..StreetName)
                    elseif IsPedRunning(PlayerPedId()) then
                        SetRichPresence("Shooting down ops @ "..StreetName)
                    elseif IsPedWalking(PlayerPedId()) then
                        SetRichPresence("Walking down "..StreetName)
                    elseif IsPedStill(PlayerPedId()) then
                        SetRichPresence("Standing on "..StreetName)
                    end
                elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
                    local MPH = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId())) * 2.236936)
                    local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
                    if MPH > 50 then
                        SetRichPresence("Speeding down "..StreetName.." In a "..VehName)
                    elseif MPH <= 50 and MPH > 0 then
                        SetRichPresence("Whipping down "..StreetName.." In a "..VehName)
                    elseif MPH == 0 then
                        SetRichPresence("Parked on "..StreetName.." In a "..VehName)
                    end
                elseif IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
                    local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
                    if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 5.0 then
                        SetRichPresence("Flying over "..StreetName.." in a "..VehName)
                    else
                        SetRichPresence("Landed at "..StreetName.." in a "..VehName)
                    end
                elseif IsEntityInWater(PlayerPedId()) then
                    SetRichPresence("Swimming around")
                elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
                    local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
                    SetRichPresence("Sailing around in a "..VehName)
                elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
                    SetRichPresence("In a yellow submarine")
                end
            end
        end
    end)