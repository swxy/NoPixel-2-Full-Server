local groundCoords = {
    {-1517.29,852.89,181.6}, 
    { -1564.5,775.2,189.2},
    { -1572.18,771.74,189.2},
    { -1581.47,788.57,189.2},
    { -1579.19,815.84,186.0},
}

local restrictionCoords = {
    [1] =  { ['x'] = -1512.66,['y'] = 863.0,['z'] = 181.9,['r'] = 80.0},
    [2] =  { ['x'] = -1594.4,['y'] = 765.59,['z'] = 189.2,['r'] = 36.0},
    [3] =  { ['x'] = -1576.23,['y'] = 815.9,['z'] = 185.99,['r'] = 60.0},
}

local placement = 0
local isInRehab = false
RegisterNetEvent('beginJailRehab')
AddEventHandler('beginJailRehab', function(isInRehabSent)
    isInRehab = isInRehabSent
    local rnd = math.random(1,5)
    placement = rnd
    TriggerEvent("DensityModifierEnable",false)
    TriggerEvent("DoLongHudText", "You are on a mental hold.",1)
    Citizen.Wait(1000)
    SetEntityCoords(PlayerPedId(),groundCoords[placement][1],groundCoords[placement][2],groundCoords[placement][3]) 
    TriggerEvent("falseCuffs")  
    DoScreenFadeIn(1500)
    if isInRehab then
        while isInRehab do
            Citizen.Wait(1000)
            RemoveAllPedWeapons(PlayerPedId())
            TriggerEvent("attachWeapons")
            local inside = false
            for k,v in pairs(restrictionCoords) do
                if #(GetEntityCoords(PlayerPedId()) - vector3(v.x,v.y,v.z)) < v.r then
                    inside = true
                end
            end

            if not inside then
                TriggerEvent("DoLongHudText", "The orderly have placed you back into the facility for protection.",1)
                SetEntityCoords(PlayerPedId(), groundCoords[placement][1],groundCoords[placement][2],groundCoords[placement][3]) 
            end

            if placement == 0 then break end
        end
    else
        placement = 0
    end

    TriggerEvent("DoLongHudText", "You were removed from Mental health care.",1)
    SetEntityCoords(PlayerPedId(), -1475.86,884.47,182.93)

    TriggerEvent("DensityModifierEnable",true)
end)

RegisterNetEvent('rehab:changeCharecter')
AddEventHandler('rehab:changeCharecter', function()
   isInRehab = false
end)