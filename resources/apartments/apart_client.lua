local displayApartBlips = true

local interiors = {

}

local apartmentCraft = {
    [4] = {-273.47332763672,-949.95874023438,92.519622802734},
    [5] = {-12.486763000488,-598.58776855469,79.430191040039},
    [6] = {-27.672889709473,-587.68591308594,90.12353515625},
    [7] = {-467.10076904297,-699.30908203125,77.095626831055},
    [8] = {-795.51818847656,328.05123901367,217.03817749023},
    [9] = {0,0,0},
    [10] = {0,0,0},
    [11] = {0,0,0},
    [12] = {0,0,0},
    [13] = {120.0290222168,566.74981689453,176.6971282959},
    [14] = {378.38751220703,429.40719604492,138.30012512207},
    [15] = {-175.73382568359,492.81289672852,130.04368591309},
    [16] = {337.07977294922,438.06484985352,141.77076721191},
    [17] = {0,0,0},
    [18] = {-622.29577636719,55.076812744141,97.599594116211},
    [19] = {-772.45220947266,326.41375732422,176.81233215332},
    [20] = {-1558.6561279297,-570.78936767578,108.52295684814},
    [21] = {-1466.4221191406,-526.12689208984,73.443634033203},
    [22] = {-1466.6994628906,-526.49060058594,73.443634033203},
    [23] = {-1457.9486083984,-531.32458496094,69.565284729004},
    [24] = {-1458.0120849609,-530.94244384766,69.565284729004},
    [25] = {-1458.1560058594,-531.05981445313,56.937641143799},
    [26] = {-1458.2700195313,-531.740234375,56.937641143799},
    [27] = {-928.00549316406,-376.24533081055,113.6741104126},
    [28] = {0,0,0},
    [29] = {-915.87677001953,-376.46038818359,109.44897460938},
    [30] = {-913.70495605469,-374.43060302734,85.489166259766},
    [31] = {-898.92443847656,-449.21166992188,126.54309844971},
    [32] = {-895.00018310547,-443.83084106445,95.469779968262},
    [33] = {0,0,0},
    [34] = {0,0,0},
    [35] = {0,0,0},
    [36] = {0,0,0},
    [37] = {0,0,0},
    [38] = {-795.90240478516,327.22695922852,217.03819274902},
    [39] = {-126.52939605713,-636.41564941406,168.82038879395},
    [40] = {-82.335220336914,-806.50543212891,243.38583374023},
    [41] = {-1377.6461181641,-464.69641113281,72.042137145996},
    [42] = {0,0,0},
    [43] = {0,0,0},
    [44] = {0,0,0}
}

--hospitals/police station/bank is held by the mayor

local lang = 'en' 
local txt = {
  ['fr'] = {
        ['fermermenu'] = 'Fermer le menu',
        ['sonner'] = 'Sonner a la porte',
        ['gohome'] = 'Rentrer chez moi',
        ['vendre'] = 'Revendre l\'appartement',
        ['acheter'] = 'Acheter l\'appartement',
        ['visiter'] = 'Visiter l\'appartement',
        ['menu'] = 'Appuyez sur ~g~E~s~ pour ouvrir le menu',
        ['soon'] = 'Cette fonctionnalite arrivera bientot'
  },

    ['en'] = {
        ['fermermenu'] = 'Close menu',
        ['sonner'] = 'Ring the doorbell',
        ['gohome'] = 'Go to home',
        ['vendre'] = 'Sell apartment',
        ['acheter'] = 'Buy apartment',
        ['visiter'] = 'Visit the apartment',
        ['visiterC'] = 'Enter as Police',
        ['visiter2'] = 'Enter unlocked house.',
        ['lock'] = 'Lock the apartment',
        ['unlock'] = 'Unlock the apartment',
        ['menu'] = 'Press ~g~E~s~ to open property menu',
        ['soon'] = 'This functionality will come soon'
    }
}

local entrer = false
local isBuy = 0
local lockStatus = 1
 
distance = 50.5999 -- distance to draw
timer = 0
current_int = 0
 
RegisterNetEvent("update:bank")
AddEventHandler("update:bank", function(ownercid,amount,newBal)
  local cid = exports["isPed"]:isPed("cid")
  local cid = tonumber(cid)
  local ownercid = tonumber(ownercid)
  if cid == ownercid then
    TriggerEvent("DoLongHudText","A contract was just paid to your bank in the amount of $" .. amount)
    TriggerEvent("banking:updateBalance", newBal, false)
  end
end)

RegisterNetEvent("apart:lockStatus")
AddEventHandler("apart:lockStatus", function(lockUpdateStatus)
  lockStatus = lockUpdateStatus
end)

RegisterNetEvent("apart:rentOverdue")
AddEventHandler("apart:rentOverdue", function()
  isBuy = 3
end)

RegisterNetEvent("apart:isBuy")
AddEventHandler("apart:isBuy", function()
  isBuy = 1
end)
 
RegisterNetEvent("apart:isNotBuy")
AddEventHandler("apart:isNotBuy", function()
  isBuy = 0
end)

RegisterNetEvent("apart:isMine")
AddEventHandler("apart:isMine", function()
  isBuy = 2
end)

RegisterNetEvent("apart:isFriend")
AddEventHandler("apart:isFriend", function()
  isBuy = 4
end)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
        N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end

function SetBlipTrade(id, text, color, x, y, z)
  local Blip = AddBlipForCoord(x, y, z)
  SetBlipSprite(Blip, id)
  SetBlipColour(Blip, color)
  SetBlipAsShortRange(Blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(text)
  EndTextCommandSetBlipName(Blip)
end
 
function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y)
end

function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end
 
isCop = false
 
RegisterNetEvent('nowCopSpawn')
AddEventHandler('nowCopSpawn', function()
    isCop = true
end)

RegisterNetEvent('nowCopSpawnOff')
AddEventHandler('nowCopSpawnOff', function()
    isCop = false
end)

isJudge = false
RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
    isJudge = true
end)
RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
    isJudge = false
end)

RegisterNetEvent("apart:giveKey")
AddEventHandler("apart:giveKey", function()
    t, distance = GetClosestPlayer()
    if t ~= nil then
        local thename = GrabApartment(10)
        if thename ~= "none" then
            TriggerServerEvent("Appartment:giveKey",thename,GetPlayerServerId(t))
        else
            TriggerEvent("DoLongHudText","Could not find property.",2)
        end
    end
end)

function checkDist(distance,t)
    if t ~= -1 then
        if distance > 5 then
            return true
        else
            return false
        end
    else
        return true
    end
end

currentApartment = false
function MenuAppartement()
    ped = PlayerPedId();
    MenuTitle = "Apartement"
    ClearMenu()
 
    for i,v in pairs(interiors) do
        if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xe,interiors[i].ye,interiors[i].ze)) < 52 then
            DrawMarker(27,interiors[i].xe,interiors[i].ye,interiors[i].ze, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 212, 189, 0, 30, 0, 0, 2, 0, 0, 0, 0)
            if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xe,interiors[i].ye,interiors[i].ze)) < 1.599 then
                 t, distance = GetClosestPlayer()
                if checkDist(distance,t) then
                    TriggerServerEvent("apart:getAppart", interiors[i].name,interiors[i].TypeOfProperty)
                    GetPropertyType(i)
                    Wait(1000)

                    if IsHudComponentActive(19) then return end

                    TriggerEvent("chatMessage", "Info: ", {255, 0, 0}, "You are visiting the " .. interiors[i].name .. " property. " .. interiors[i].price .. "$USD")
                    
                    currentApartment = i
                    
                    TriggerEvent("openApartmentMenu",Store,isBuy,lockStatus,false)

                    SetEntityCoords(PlayerPedId(),interiors[i].xe,interiors[i].ye,interiors[i].ze)
                    FreezeEntityPosition(PlayerPedId(),true)
                    Citizen.Wait(2000)
                    FreezeEntityPosition(PlayerPedId(),false)
                else
                    TriggerEvent("DoLongHudText","Already someone here.",2)
                end
            end
        end

    end
end


function MenuAppartement2()
    ped = PlayerPedId();
    MenuTitle = "Apartement"
    ClearMenu()
    for i,v in pairs(interiors) do
        if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xo,interiors[i].yo,interiors[i].zo)) < 52 then
            DrawMarker(27,interiors[i].xo,interiors[i].yo,interiors[i].zo, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 212, 189, 0, 30, 0, 0, 2, 0, 0, 0, 0)
            if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xo,interiors[i].yo,interiors[i].zo)) < 1.599 then
                t, distance = GetClosestPlayer()
                if  checkDist(distance,t) then
                    TriggerServerEvent("apart:getAppart", interiors[i].name,interiors[i].TypeOfProperty)
                    GetPropertyType(i)
                    Wait(800)

                    if IsHudComponentActive(19) then return end

                    TriggerEvent("chatMessage", "Info: ", {255, 0, 0}, "You are visiting the " .. interiors[i].name .. " property. " .. interiors[i].price .. "$USD")

                    currentApartment = i
                    
                    TriggerEvent("openApartmentMenu",Store,isBuy,lockStatus,true)
                end
            end
        end
    end
end



function GetPropertyType(i)
    Store = false
    propertyType = interiors[i].TypeOfProperty
    if propertyType ~= 1 then  
        Store = true 
    end
end


function CloseMenu()
    Menu.hidden = true    
end

function Sonner()
    drawNotification(txt[lang]['You do not own this!'])
end

RegisterNetEvent('Appartment:StashCash')
RegisterNetEvent('Appartment:StashDM')
RegisterNetEvent('Appartment:TakeCash')
RegisterNetEvent('Appartment:TakeDM')

function GrabApartmentPrice()
    appartmentName = 0
    for i,v in pairs(interiors) do

        if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xe,interiors[i].ye,interiors[i].ze)) < 5 then
            appartmentName = interiors[i].price
        end

        if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xo,interiors[i].yo,interiors[i].zo)) < 5 then
            appartmentName = interiors[i].price
        end


    end
    return appartmentName
end



function GrabApartment(distancec)
    appartmentName = "none"
    startdistance = 100
    for i,v in pairs(interiors) do
        if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xe,interiors[i].ye,interiors[i].ze)) < distancec then
            if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xe,interiors[i].ye,interiors[i].ze)) > 100 and interiors[i].TypeOfProperty ~= 10 then
                --too far from store.
            else
                DISTANCECHECKED = #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xe,interiors[i].ye,interiors[i].ze))
                if DISTANCECHECKED < startdistance then
                    startdistance = DISTANCECHECKED
                    appartmentName = interiors[i].name
                end
            end
        end

        if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xo,interiors[i].yo,interiors[i].zo)) < distancec then
            if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xo,interiors[i].yo,interiors[i].zo)) > 100 and interiors[i].TypeOfProperty ~= 10 then
                --too far from store.
            else
                DISTANCECHECKED = #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xo,interiors[i].yo,interiors[i].zo))
                if DISTANCECHECKED < startdistance then
                    startdistance = DISTANCECHECKED
                    appartmentName = interiors[i].name
                end
            end
        end
    end
    return appartmentName
end

function GrabApartmentDrug(distancec)
    appartmentName = "none"
    for i,v in pairs(interiors) do
        if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xe,interiors[i].ye,interiors[i].ze)) < distancec then
            if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xe,interiors[i].ye,interiors[i].ze)) > distancec and interiors[i].TypeOfProperty ~= 10 then
                --too far from store.
            else
                propertyType = interiors[i].TypeOfProperty                
                if appartmentName == "none" and propertyType == 10 then
                    appartmentName = interiors[i].name
                end
            end
        end
    end
    return appartmentName
end

-- UPV = update property value

RegisterNetEvent('DrugsUPV')
AddEventHandler('DrugsUPV', function(amount)   
    TriggerEvent("DoLongHudText","Checking for bonuses..",1)
    local thename = GrabApartmentDrug(200)
    if thename ~= "none" then
        TriggerServerEvent("Appartment:ServerUpdateValueWithReturn",thename, amount)
        TriggerEvent("DoLongHudText",thename,1)
    end
end)

RegisterNetEvent('UPVBank')
AddEventHandler('UPVBank', function(amount)   
    local thename = "Maze Banking"
    if thename ~= "none" then
        TriggerServerEvent("Appartment:ServerUpdateValue",thename, amount)
    end
end)

RegisterNetEvent('PropertyCashAdjust')
AddEventHandler('PropertyCashAdjust', function(giveAmount, cashtype, dirty)
    local thename = GrabApartment(5)
    if thename ~= "none" then
        TriggerServerEvent("PropertyCashAdjust", giveAmount, cashtype, thename, dirty)
    end
end)

RegisterNetEvent('UPV')
AddEventHandler('UPV', function(amount)
    local thename = GrabApartment(100)
    if thename ~= "none" then
        TriggerServerEvent("Appartment:ServerUpdateValue",thename, amount)
    end
end)

RegisterNetEvent('UPVWood')
AddEventHandler('UPVWood', function(amount,name)   
    if name ~= "none" then
        TriggerServerEvent("Appartment:ServerUpdateValue",name, amount)
    end
end)

RegisterNetEvent('Appartment:PayRent')
AddEventHandler('Appartment:PayRent', function()
    TriggerServerEvent("apart:payRent",GrabApartment(22), GrabApartmentPrice())
end)

RegisterNetEvent('Appartment:CheckRent')
AddEventHandler('Appartment:CheckRent', function()
    TriggerServerEvent("apart:checkRent",GrabApartment(22), GrabApartmentPrice())
end)

AddEventHandler('Appartment:StashCash', function()
    TriggerEvent("DoLongHudText","Stored Cash.",1)
    TriggerEvent("civcashtype",1, false )
end)

AddEventHandler('Appartment:StashDM', function()
    TriggerEvent("DoLongHudText","Stored Marked Bills.",1)
    TriggerEvent("civcashtype",1, true )
end)

AddEventHandler('Appartment:TakeCash', function()
    TriggerEvent("DoLongHudText","Took Cash.",1)
    TriggerEvent("civcashtype",2, false )
end)

AddEventHandler('Appartment:TakeDM', function()
    TriggerEvent("DoLongHudText","Took Marked Bills.",1)
    TriggerEvent("civcashtype",2, true )

end)
RegisterNetEvent('Appartment:SeizeAllTEXT')
AddEventHandler('Appartment:SeizeAllTEXT', function()
  -- TriggerEvent("DoLongHudText","Seizure Completed on ID #" .. target)
    TriggerServerEvent("apart:SeizeAllTEXT")
end)
RegisterNetEvent('Appartment:SeizeAll')
AddEventHandler('Appartment:SeizeAll', function()
    TriggerEvent("DoLongHudText","Seizure Completed.",1)
    TriggerServerEvent("apart:SeizeAll",GrabApartment(5))
end)


RegisterNetEvent('Appartment:CheckOwner')
AddEventHandler('Appartment:CheckOwner', function()
    TriggerEvent("DoLongHudText","Checking Ownership.",1)
    TriggerServerEvent("apart:returnOwner",GrabApartment(5))
end)



RegisterNetEvent('Appartment:lock')
AddEventHandler('Appartment:lock', function()
    TriggerServerEvent("apart:lockAppart", GrabApartment(22), 1)
end)

RegisterNetEvent('Appartment:unlock')
AddEventHandler('Appartment:unlock', function()
    TriggerServerEvent("apart:lockAppart", GrabApartment(22), 0)
end)

RegisterNetEvent('Appartment:Vendre')
AddEventHandler('Appartment:Vendre', function()
    TriggerServerEvent("apart:sellAppart", GrabApartment(22), GrabApartmentPrice())
    TriggerEvent("fistpump")
end)

RegisterNetEvent('Appartment:Acheter')
AddEventHandler('Appartment:Acheter', function()
    TriggerServerEvent("apart:buyAppart", GrabApartment(22), GrabApartmentPrice())
    TriggerEvent("fistpump")
end)

RegisterNetEvent('Appartment:Visiter2')
AddEventHandler('Appartment:Visiter2', function()
    i = currentApartment
    if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xo,interiors[i].yo,interiors[i].zo)) < 15 then
        DrawMarker(27,interiors[i].xo,interiors[i].yo,interiors[i].ze-1.0001, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 212, 189, 0, 30, 0, 0, 2, 0, 0, 0, 0)
        if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xo,interiors[i].yo,interiors[i].zo)) < 1.599 then
            DoScreenFadeOut(50)
            timer = 20
            while IsScreenFadingOut() do Citizen.Wait(0) end
            --NetworkFadeOutEntity(PlayerPedId(), true, false)
            Wait(50)
            SetEntityCoords(PlayerPedId(), interiors[currentApartment].xe,interiors[currentApartment].ye,interiors[currentApartment].ze)
            SetEntityHeading(PlayerPedId(), interiors[currentApartment].ho)
            TriggerServerEvent("appartments:testCrafting",apartmentCraft[i],false)
            TriggerServerEvent("apart:returnIsOwner",interiors[i].name)
            TriggerEvent('craft:updateOwnerShip',false,"") 
            --NetworkFadeInEntity(PlayerPedId(), 0)
            Wait(50)
            current_int = i
            SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
            DoScreenFadeIn(50)
            while IsScreenFadingIn() do Citizen.Wait(0) end
        end
    end
end)

 RegisterNetEvent('Appartment:Visiter')
AddEventHandler('Appartment:Visiter', function()
    i = currentApartment
    if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xe,interiors[i].ye,interiors[i].ze)) < 15 then
        DrawMarker(27,interiors[i].xe,interiors[i].ye,interiors[i].ze-1.0001, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 212, 189, 0, 30, 0, 0, 2, 0, 0, 0, 0)
        if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xe,interiors[i].ye,interiors[i].ze)) < 1.599  then
            DoScreenFadeOut(50)
            timer = 20
            while IsScreenFadingOut() do Citizen.Wait(0) end
            --NetworkFadeOutEntity(PlayerPedId(), true, false)
            Wait(50)
            SetEntityCoords(PlayerPedId(), interiors[currentApartment].xo,interiors[currentApartment].yo,interiors[currentApartment].zo)
            SetEntityHeading(PlayerPedId(), interiors[currentApartment].ho)
            TriggerServerEvent("appartments:testCrafting",apartmentCraft[i],true)
            TriggerServerEvent("apart:returnIsOwner",interiors[i].name) 
           -- NetworkFadeInEntity(PlayerPedId(), 0)
            Wait(50)
            current_int = i
            SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
            DoScreenFadeIn(50)
            while IsScreenFadingIn() do Citizen.Wait(0) end
        end
    end
end)
 

local apartmentEntries = {
    [1] = { ["x"] = 312.96966552734,["y"] = -218.2705078125, ["z"] = 54.221797943115, ["name"] = "Hotel 1-1" },
    [2] = { ["x"] = 267.48132324219, ["y"] = -638.818359375, ["z"] = 41.020294189453, ["name"] = "Middle Class Apartments" },
    [3] = { ["x"] = 160.26762390137, ["y"] = -641.96905517578, ["z"] = 47.073524475098, ["name"] = "High Class Apartments" },
    [4] = { ['x'] = -1472.38,['y'] = -657.84,['z'] = 29.27, ["name"] = "Hotel 1-2" },
    [5] = { ['x'] = 505.4,['y'] = 215.07,['z'] = 102.9, ["name"] = "Hotel 1-3" },
    [6] = { ['x'] = -880.0,['y'] = -1290.65,['z'] = 9.71, ["name"] = "Hotel 1-4" },
    [7] = { ['x'] = -1583.62,['y'] = -265.63,['z'] = 48.28, ["name"] = "Hotel 1-5" },
    [8] = { ['x'] = -1310.95,['y'] = -931.85,['z'] = 13.36, ["name"] = "Hotel 1-6" },
    [9] = { ['x'] = -412.02,['y'] = 152.74,['z'] = 73.74, ["name"] = "Hotel 1-7" },
}

local showMainAppartment = false

RegisterNetEvent('Appartment:ToggleHouses')
AddEventHandler('Appartment:ToggleHouses', function()
    showMainAppartment = not showMainAppartment
   for _, item in pairs(interiors) do
        if item.TypeOfProperty == 1 then 
            if not showMainAppartment then
                if item.blip ~= nil then
                    RemoveBlip(item.blip)
                end
            else
                item.blip = AddBlipForCoord(item.xe, item.ye, item.ze)
                SetBlipSprite(item.blip, 375)
                SetBlipAsShortRange(item.blip, true)
                BeginTextCommandSetBlipName("STRING")
                SetBlipColour(item.blip, 3)
                SetBlipScale(item.blip, 0.9)
                AddTextComponentString("Housing")
                EndTextCommandSetBlipName(item.blip)
            end
        end
    end
end)

Citizen.CreateThread(function()

    if displayApartBlips == true then
        showMainAppartment = true
        TriggerEvent('Appartment:ToggleHouses')

        for i = 1, #apartmentEntries do
              local blip = AddBlipForCoord(apartmentEntries[i]["x"], apartmentEntries[i]["y"], apartmentEntries[i]["z"])
              SetBlipSprite(blip, 350)
              SetBlipAsShortRange(blip, true)
              BeginTextCommandSetBlipName("STRING")
              SetBlipColour(blip, i+8)
              SetBlipScale(blip, 1.1)
              AddTextComponentString(apartmentEntries[i]["name"])
              EndTextCommandSetBlipName(blip)
        end

    end


end)





RegisterNetEvent('np-weapons:stashitem')
AddEventHandler('np-weapons:stashitem', function(itemnumber,amount,meta)


        thename1 = "none"
        thename1 = GrabApartment(2)

        if thename1 ~= "none" then

            TriggerServerEvent("np-weapons:stashweapon", thename1, itemnumber, amount, 1,1,meta)


        else
            TriggerEvent("DoLongHudText", "Error finding property.",2)
        end

end)


decimalToName = {
["2725352035"] = "WEAPON_UNARMED",
["4194021054"] = "WEAPON_ANIMAL",
["148160082"] = "WEAPON_COUGAR",
["2578778090"] = "WEAPON_KNIFE",
["1737195953"] = "WEAPON_NIGHTSTICK",
["1317494643"] = "WEAPON_HAMMER",
["2508868239"] = "WEAPON_BAT",
["1141786504"] = "WEAPON_GOLFCLUB",
["2227010557"] = "WEAPON_CROWBAR",
["453432689"] = "WEAPON_PISTOL",
["1593441988"] = "WEAPON_COMBATPISTOL",
["584646201"] = "WEAPON_APPISTOL",
["2578377531"] = "WEAPON_PISTOL50",
["432421536"] = "WEAPON_MICROSMG",
["736523883"] = "WEAPON_SMG",
["4024951519"] = "WEAPON_ASSAULTSMG",
["3220176749"] = "WEAPON_ASSAULTRIFLE",
["2210333304"] = "WEAPON_CARBINERIFLE",
["2937143193"] = "WEAPON_ADVANCEDRIFLE",
["2634544996"] = "WEAPON_MG",
["2144741730"] = "WEAPON_COMBATMG",
["487013001"] = "WEAPON_PUMPSHOTGUN",
["2017895192"] = "WEAPON_SAWNOFFSHOTGUN",
["3800352039"] = "WEAPON_ASSAULTSHOTGUN",
["2640438543"] = "WEAPON_BULLPUPSHOTGUN",
["911657153"] = "WEAPON_STUNGUN",
["100416529"] = "WEAPON_SNIPERRIFLE",
["205991906"] = "WEAPON_HEAVYSNIPER",
["856002082"] = "WEAPON_REMOTESNIPER",
["2726580491"] = "WEAPON_GRENADELAUNCHER",
["1305664598"] = "WEAPON_GRENADELAUNCHER_SMOKE",
["2982836145"] = "WEAPON_RPG",
["375527679"] = "WEAPON_PASSENGER_ROCKET",
["324506233"] = "WEAPON_AIRSTRIKE_ROCKET",
["1752584910"] = "WEAPON_STINGER",
["1119849093"] = "WEAPON_MINIGUN",
["2481070269"] = "WEAPON_GRENADE",
["741814745"] = "WEAPON_STICKYBOMB",
["4256991824"] = "WEAPON_SMOKEGRENADE",
["2694266206"] = "WEAPON_BZGAS",
["615608432"] = "WEAPON_MOLOTOV",
["101631238"] = "WEAPON_FIREEXTINGUISHER",
["883325847"] = "WEAPON_PETROLCAN",
["4256881901"] = "WEAPON_DIGISCANNER",
["2294779575"] = "WEAPON_BRIEFCASE",
["28811031"] = "WEAPON_BRIEFCASE_02",
["600439132"] = "WEAPON_BALL",
["1233104067"] = "WEAPON_FLARE",
["3204302209"] = "WEAPON_VEHICLE_ROCKET",
["1223143800"] = "WEAPON_BARBED_WIRE",
["4284007675"] = "WEAPON_DROWNING",
["1936677264"] = "WEAPON_DROWNING_IN_VEHICLE",
["2339582971"] = "WEAPON_BLEEDING",
["2461879995"] = "WEAPON_ELECTRIC_FENCE",
["539292904"] = "WEAPON_EXPLOSION",
["3452007600"] = "WEAPON_FALL",
["910830060"] = "WEAPON_EXHAUSTION",
["3425972830"] = "WEAPON_HIT_BY_WATER_CANNON",
["133987706"] = "WEAPON_RAMMED_BY_CAR",
["2741846334"] = "WEAPON_RUN_OVER_BY_CAR",
["341774354"] = "WEAPON_HELI_CRASH",
["3750660587"] = "WEAPON_FIRE",
["3218215474"] = "WEAPON_SNSPISTOL",
["4192643659"] = "WEAPON_BOTTLE",
["1627465347"] = "WEAPON_GUSENBERG",
["3231910285"] = "WEAPON_SPECIALCARBINE",
["3523564046"] = "WEAPON_HEAVYPISTOL",
["2132975508"] = "WEAPON_BULLPUPRIFLE",
["2460120199"] = "WEAPON_DAGGER",
["137902532"] = "WEAPON_VINTAGEPISTOL",
["2138347493"] = "WEAPON_FIREWORK",
["2828843422"] = "WEAPON_MUSKET",
["984333226"] = "WEAPON_HEAVYSHOTGUN",
["3342088282"] = "WEAPON_MARKSMANRIFLE",
["1672152130"] = "WEAPON_HOMINGLAUNCHER",
["2874559379"] = "WEAPON_PROXMINE",
["126349499"] = "WEAPON_SNOWBALL",
["1198879012"] = "WEAPON_FLAREGUN",
["3794977420"] = "WEAPON_GARBAGEBAG",
["3494679629"] = "WEAPON_HANDCUFFS",
["171789620"] = "WEAPON_COMBATPDW",
["3696079510"] = "WEAPON_MARKSMANPISTOL",
["3638508604"] = "WEAPON_KNUCKLE",
["4191993645"] = "WEAPON_HATCHET",
["1834241177"] = "WEAPON_RAILGUN",
["3713923289"] = "WEAPON_MACHETE",
["3675956304"] = "WEAPON_MACHINEPISTOL",
["738733437"] = "WEAPON_AIR_DEFENCE_GUN",
["3756226112"] = "WEAPON_SWITCHBLADE",
["3249783761"] = "WEAPON_REVOLVER",
["4019527611"] = "WEAPON_DBSHOTGUN",
["1649403952"] = "WEAPON_COMPACTRIFLE",
["317205821"] = "WEAPON_AUTOSHOTGUN",
["3441901897"] = "WEAPON_BATTLEAXE",
["125959754"] = "WEAPON_COMPACTLAUNCHER",
["3173288789"] = "WEAPON_MINISMG",
["3125143736"] = "WEAPON_PIPEBOMB",
["2484171525"] = "WEAPON_POOLCUE",
["419712736"] = "WEAPON_WRENCH"
}

hashGun = {
    '883325847',
    '1233104067',
    '-1716189206',
    '1317494643',
    '-1786099057',
    '-2067956739',
    '1141786504',
    '-102323637',
    '-1834847097',
    '-102973651',
    '-656458692',
    '-581044007',
    '-1951375401',
    '-538741184',
    '-1810795771',
    '419712736',
    '453432689',
    '1593441988',
    '137902532',
    '911657153',
    '324215364',
    '736523883',
    '-270015777',
    '1627465347',
    '2017895192',
    '-1654528753',
    '-494615257',
    '984333226',
    '317205821',
    '-1074790547',
    '-2084633992' ,
    '-1357824103',
    '-1063057011' , --CARBINE S
    '2132975508',
    '100416529',
    '205991906',
    '-952879014',
    '2138347493',
    '101631238'
}
function D2N(info)
    info = decimalToName[info]
    return info
end

RegisterNetEvent('np-weapons:giveweaponfromproperty')
AddEventHandler('np-weapons:giveweaponfromproperty', function(result)
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, tonumber(result), 150, 0, false)
    TriggerEvent("attachWeapons")
    TriggerEvent("fistpump")
end)





-- RegisterNetEvent('np-weapons:checkinventory')
-- AddEventHandler('np-weapons:checkinventory', function()

--     if not IsPedInAnyVehicle(PlayerPedId(),true) then
--         thename1 = "none"
--         thename1 = GrabApartment(2)

--         if thename1 ~= "none" then

--             TriggerServerEvent("np-weapons:checkinventory", thename1)

--         else
--             TriggerEvent("DoLongHudText", "Error finding property.",2)
--         end

--     else
--         TriggerEvent("DoLongHudText", "Can not do in a vehicle.",2)
--     end

-- end)



-- RegisterNetEvent('np-weapons:takefromstash')
-- AddEventHandler('np-weapons:takefromstash', function(itemname, quantity, itemtype, item, askedAmount,meta)
--     thename1 = GrabApartment(2)
--     if thename1 ~= "none" then
--         TriggerServerEvent("np-weapons:takefromstash",itemname, quantity, itemtype, item, askedAmount,thename1,meta)
--     else
--         TriggerEvent("DoLongHudText", "Error finding property.",2)
--     end
-- end)


-- RegisterNetEvent('np-weapons:stashweapon')
-- AddEventHandler('np-weapons:stashweapon', function()

--     if not IsPedInAnyVehicle(PlayerPedId(),true) then
--         thename1 = "none"
--         thename1 = GrabApartment(2)

--         if thename1 ~= "none" then
--             local weaponname = GetSelectedPedWeapon(PlayerPedId())
--             local weaponHash = GetHashKey(weaponname)
--             local ammo = GetAmmoInPedWeapon(PlayerPedId(),weaponname)
--             for i,v in ipairs(hashGunToText) do
--                 if v == weaponname then
--                     weaponname = hashGun[i]
--                 end
--             end

--             -- Note From Sin , For some reason setPedDrop wont work with 0 ammo but removeWeapon will ?
--             RemoveWeaponFromPed(PlayerPedId(),weaponname)
--             --SetPedDropsWeapon(PlayerPedId())                 
--             GiveWeaponToPed(PlayerPedId(), 0xA2719263, 0, 0, 1)
--             TriggerEvent("attachWeapons")
--             TriggerServerEvent("np-weapons:stashweapon", thename1, weaponname, 1, 0,ammo)
--             TriggerServerEvent("weaponshop:removeSingleWeapon",weaponname)
--         else
--             TriggerEvent("DoLongHudText", "Error finding property.",2)
--         end

--     else
--         TriggerEvent("DoLongHudText", "Can not do in a vehicle.",2)
--     end

-- end)


function D2N(info)
    info = tostring(info)
    info = decimalToName[info]
    return info
end

hashGunToText = {
['-102973651'] = "Hatchet",
['-1834847097'] = "Dagger",
['-102323637'] = "Glass Bottle",
['-2067956739'] = "Crowbar",
['-656458692'] = "Knuckle Dusters",
['-1786099057'] = "Baseball Bat",

['-102973651'] = "Hatchet",
['-1834847097'] = "Dagger",
['-102323637'] = "Glass Bottle",
['-2067956739'] = "Crowbar",
['-656458692'] = "Knuckle Dusters",
['-1786099057'] = "Baseball Bat",
['-1716189206'] = "Combat Knife",
['-2066285827'] = "Assault SMG",
['-270015777'] = "Bullpup Rifle",
['-1654528753'] = "Bullpup Shotgun",
['-494615257'] = "Auto Shotgun",
['-619010992'] = "Tec 9",
['-2009644972'] = "SNS Pistol",
['-1121678507'] = "Mini SMG",
['2725352035'] = "Unarmed",
['4194021054'] = "Animal",
['148160082'] = "Cougar",
['2578778090'] = "Knife",
['1737195953'] = "Nightstick",
['1317494643'] = "Hammer",
['2508868239'] = "Bat",
['1141786504'] = "Golfclub",
['2227010557'] = "Crowbar",
['453432689'] = "Pistol",
['1593441988'] = "Combat Pistol",
['584646201'] = "AP Pistol",
['2578377531'] = "Deagle",
['324215364'] = "Micro SMG",
['736523883'] = "SMG",
['4024951519'] = "Assault SMG",
['3220176749'] = "Assault Rifle",
['2210333304'] = "Carbine",
['2937143193'] = "Adv Rifle",
['2634544996'] = "MG",
['2144741730'] = "Combat MG",
['487013001'] = "Pump Action",
['2017895192'] = "Sawnoff",
['3800352039'] = "Assault Shotgun",
['2640438543'] = "Bullpup Shotgun",
['911657153'] = "Stun Gun",
['100416529'] = "Sniper",
['205991906'] = "Heavy Sniper",
['856002082'] = "Remote Sniper",
['2726580491'] = "GND Launcher",
['1305664598'] = "GND Launcher SMK",
['2982836145'] = "RPG",
['375527679'] = "Passenger Rocket",
['324506233'] = "Air Rocket",
['1752584910'] = "Stinger",
['1119849093'] = "Minigun",
['2481070269'] = "Grenade",
['741814745'] = "Sticky Bomb",
['4256991824'] = "Smoke Grenade",
['2694266206'] = "Bz Gas",
['615608432'] = "Molotov",
['101631238'] = "Fire Ext",
['883325847'] = "Petrol Can",
['4256881901'] = "Digi Scanner",
['2294779575'] = "Briefcase",
['28811031'] = "Briefcase",
['600439132'] = "Ball",
['1233104067'] = "Flare",
['3204302209'] = "Veh Rocket",
['1223143800'] = "Barbed Wire",
['4284007675'] = "Drown",
['1936677264'] = "Drown Vehicle",
['2339582971'] = "Bleeding",
['2461879995'] = "Electric Fence",
['539292904'] = "Explosion",
['3452007600'] = "Fall",
['910830060'] = "Exhaustion",
['3425972830'] = "Water Cannon",
['133987706'] = "Rammed",
['2741846334'] = "Run Over",
['341774354'] = "Heli Crash",
['3750660587'] = "Fire",

----------------DLC Weapons----------------

------------------------------------
['3218215474'] = "SNS Pistol",
['4192643659'] = "Bottle",

------------------------------------
['1627465347'] = "Gusenberg",

------------------------------------
['3231910285'] = "Special Carbine",
['3523564046'] = "Heavy Pistol",

------------------------------------
['2132975508'] = "Bullpup",


------------------------------------
['2460120199'] = "Dagger",
['137902532'] = "Vintage Pistol",


------------------------------------
['2138347493'] = "Firework",
['2828843422'] = "Musket",


------------------------------------
['984333226'] = "Heavy Shotgun",
['3342088282'] = "Mark Rifle",


------------------------------------
['1672152130'] = "Homing Launcher",
['2874559379'] = "Proximity Mine",
['126349499'] = "Snowball",

------------------------------------
['1198879012'] = "Flaregun",
['3794977420'] = "Garbage Bag",
['3494679629'] = "Handcuffs",


------------------------------------
['171789620'] = "Combat PDW",


------------------------------------
['3696079510'] = "Mrk Pistol",
['3638508604'] = "Knuckle",


------------------------------------
['4191993645'] = "Hatchet",
['1834241177'] = "Railgun",


------------------------------------
['3713923289'] = "Machete",
['3675956304'] = "Mac Pistol",


------------------------------------
['738733437'] = "Air Defence",
['3756226112'] = "Switchblade",
['3249783761'] = "Revolver",


------------------------------------
['4019527611'] = "DB Shotgun",
['1649403952'] = "Cmp Rifle",


------------------------------------
['317205821'] = "Auto Shotgun",
['3441901897'] = "Battle Axe",
['125959754'] = "Cmp Launcher",
['3173288789'] = "SMG Mini",
['3125143736'] = "Pipebomb",
['2484171525'] = "Cue",
['419712736'] = "Wrench",
["-581044007"] = "Machete",
}

weaponNameToHash = { 
    ["WEAPON_UNARMED"] = 0xA2719263,
    ["WEAPON_ANIMAL"] = 0xF9FBAEBE,
    ["WEAPON_COUGAR"] = 0x08D4BE52,
    ["WEAPON_KNIFE"] = 0x99B507EA,
    ["WEAPON_NIGHTSTICK"] = 0x678B81B1,
    ["WEAPON_HAMMER"] = 0x4E875F73,
    ["WEAPON_BAT"] =    0x958A4A8F,
    ["WEAPON_GOLFCLUB"] =   0x440E4788,
    ["WEAPON_CROWBAR"] = 0x84BD7BFD,
    ["WEAPON_PISTOL"] = 0x1B06D571,
    ["WEAPON_COMBATPISTOL"] = 0x5EF9FEC4,
    ["WEAPON_APPISTOL"] = 0x22D8FE39,
    ["WEAPON_PISTOL50"] = 0x99AEEB3B,
    ["WEAPON_MICROSMG"] = 0x13532244,
    ["WEAPON_SMG"] = 0x2BE6766B,
    ["WEAPON_ASSAULTSMG"] = 0xEFE7E2DF,
    ["WEAPON_ASSAULTRIFLE"] = 0xBFEFFF6D,
    ["WEAPON_CARBINERIFLE"] = 0x83BF0278,
    ["WEAPON_ADVANCEDRIFLE"] = 0xAF113F99,
    ["WEAPON_MG"] = 0x9D07F764,
    ["WEAPON_COMBATMG"] = 0x7FD62962,
    ["WEAPON_PUMPSHOTGUN"] = 0x1D073A89,
    ["WEAPON_SAWNOFFSHOTGUN"] = 0x7846A318,
    ["WEAPON_ASSAULTSHOTGUN"] = 0xE284C527,
    ["WEAPON_BULLPUPSHOTGUN"] = 0x9D61E50F,
    ["WEAPON_STUNGUN"] = 0x3656C8C1,
    ["WEAPON_SNIPERRIFLE"] = 0x05FC3C11,
    ["WEAPON_HEAVYSNIPER"] = 0x0C472FE2,
    ["WEAPON_REMOTESNIPER"] = 0x33058E22,
    ["WEAPON_GRENADELAUNCHER"] = 0xA284510B,
    ["WEAPON_GRENADELAUNCHER_SMOKE"] = 0x4DD2DC56,
    ["WEAPON_RPG"] = 0xB1CA77B1,
    ["WEAPON_PASSENGER_ROCKET"] = 0x166218FF,
    ["WEAPON_AIRSTRIKE_ROCKET"] = 0x13579279,
    ["WEAPON_STINGER"] = 0x687652CE,
    ["WEAPON_MINIGUN"] = 0x42BF8A85,
    ["WEAPON_GRENADE"] = 0x93E220BD,
    ["WEAPON_STICKYBOMB"] = 0x2C3731D9,
    ["WEAPON_SMOKEGRENADE"] = 0xFDBC8A50,
    ["WEAPON_BZGAS"] = 0xA0973D5E,
    ["WEAPON_MOLOTOV"] = 0x24B17070,
    ["WEAPON_FIREEXTINGUISHER"] = 0x060EC506,
    ["WEAPON_PETROLCAN"] = 0x34A67B97,
    ["WEAPON_DIGISCANNER"] = 0xFDBADCED,
    ["WEAPON_BRIEFCASE"] = 0x88C78EB7,
    ["WEAPON_BRIEFCASE_02"] = 0x01B79F17,
    ["WEAPON_BALL"] = 0x23C9F95C,
    ["WEAPON_FLARE"] = 0x497FACC3,
    ["WEAPON_VEHICLE_ROCKET"] = 0xBEFDC581,
    ["WEAPON_BARBED_WIRE"] = 0x48E7B178,
    ["WEAPON_DROWNING"] = 0xFF58C4FB,
    ["WEAPON_DROWNING_IN_VEHICLE"] = 0x736F5990,
    ["WEAPON_BLEEDING"] = 0x8B7333FB,
    ["WEAPON_ELECTRIC_FENCE"] = 0x92BD4EBB,
    ["WEAPON_EXPLOSION"] = 0x2024F4E8,
    ["WEAPON_FALL"] = 0xCDC174B0,
    ["WEAPON_EXHAUSTION"] = 0x364A29EC,
    ["WEAPON_HIT_BY_WATER_CANNON"] = 0xCC34325E,
    ["WEAPON_RAMMED_BY_CAR"] = 0x07FC7D7A,
    ["WEAPON_RUN_OVER_BY_CAR"] = 0xA36D413E,
    ["WEAPON_HELI_CRASH"] = 0x145F1012,
    ["WEAPON_FIRE"] = 0xDF8E89EB,
    ["WEAPON_SNSPISTOL"] = 0xBFD21232,
    ["WEAPON_BOTTLE"] = 0xF9E6AA4B,
    ["WEAPON_GUSENBERG"] = 0x61012683,
    ["WEAPON_SPECIALCARBINE"] = 0xC0A3098D,
    ["WEAPON_HEAVYPISTOL"] = 0xD205520E,
    ["WEAPON_BULLPUPRIFLE"] = 0x7F229F94,
    ["WEAPON_DAGGER"] = 0x92A27487,
    ["WEAPON_VINTAGEPISTOL"] = 0x083839C4,
    ["WEAPON_FIREWORK"] = 0x7F7497E5,
    ["WEAPON_MUSKET"] = 0xA89CB99E,
    ["WEAPON_HEAVYSHOTGUN"] = 0x3AABBBAA,
    ["WEAPON_MARKSMANRIFLE"] = 0xC734385A,
    ["WEAPON_HOMINGLAUNCHER"] = 0x63AB0442,
    ["WEAPON_PROXMINE"] = 0xAB564B93,
    ["WEAPON_SNOWBALL"] = 0x787F0BB,
    ["WEAPON_FLAREGUN"] = 0x47757124,
    ["WEAPON_GARBAGEBAG"] = 0xE232C28C,
    ["WEAPON_HANDCUFFS"] = 0xD04C944D,
    ["WEAPON_COMBATPDW"] = 0x0A3D4D34,
    ["WEAPON_MARKSMANPISTOL"] = 0xDC4DB296,
    ["WEAPON_KNUCKLE"] = 0xD8DF3C3C,
    ["WEAPON_HATCHET"] = 0xF9DCBF2D,
    ["WEAPON_RAILGUN"] = 0x6D544C99,
    ["WEAPON_MACHETE"] = 0xDD5DF8D9,
    ["WEAPON_MACHINEPISTOL"] = 0xDB1AA450,
    ["WEAPON_AIR_DEFENCE_GUN"] = 0x2C082D7D,
    ["WEAPON_SWITCHBLADE"] = 0xDFE37640,
    ["WEAPON_REVOLVER"] = 0xC1B3C3D1,
    ["WEAPON_DBSHOTGUN"] = 0xEF951FBB ,
    ["WEAPON_COMPACTRIFLE"] = 0x624FE830,
    ["WEAPON_AUTOSHOTGUN"] = 0x12E82D3D,
    ["WEAPON_BATTLEAXE"] = 0xCD274149,
    ["WEAPON_COMPACTLAUNCHER"] = 0x0781FE4A,
    ["WEAPON_MINISMG"] = 0xBD248B55,
    ["WEAPON_PIPEBOMB"] = 0xBA45E8B8,
    ["WEAPON_POOLCUE"] = 0x94117305,
    ["WEAPON_WRENCH"] = 0x19044EE0  
}








decimalToName = {
["2725352035"] = "WEAPON_UNARMED",
["4194021054"] = "WEAPON_ANIMAL",
["148160082"] = "WEAPON_COUGAR",
["2578778090"] = "WEAPON_KNIFE",
["1737195953"] = "WEAPON_NIGHTSTICK",
["1317494643"] = "WEAPON_HAMMER",
["2508868239"] = "WEAPON_BAT",
["1141786504"] = "WEAPON_GOLFCLUB",
["2227010557"] = "WEAPON_CROWBAR",
["453432689"] = "WEAPON_PISTOL",
["1593441988"] = "WEAPON_COMBATPISTOL",
["584646201"] = "WEAPON_APPISTOL",
["2578377531"] = "WEAPON_PISTOL50",
["432421536"] = "WEAPON_MICROSMG",
["736523883"] = "WEAPON_SMG",
["4024951519"] = "WEAPON_ASSAULTSMG",
["3220176749"] = "WEAPON_ASSAULTRIFLE",
["2210333304"] = "WEAPON_CARBINERIFLE",
["2937143193"] = "WEAPON_ADVANCEDRIFLE",
["2634544996"] = "WEAPON_MG",
["2144741730"] = "WEAPON_COMBATMG",
["487013001"] = "WEAPON_PUMPSHOTGUN",
["2017895192"] = "WEAPON_SAWNOFFSHOTGUN",
["3800352039"] = "WEAPON_ASSAULTSHOTGUN",
["2640438543"] = "WEAPON_BULLPUPSHOTGUN",
["911657153"] = "WEAPON_STUNGUN",
["100416529"] = "WEAPON_SNIPERRIFLE",
["205991906"] = "WEAPON_HEAVYSNIPER",
["856002082"] = "WEAPON_REMOTESNIPER",
["2726580491"] = "WEAPON_GRENADELAUNCHER",
["1305664598"] = "WEAPON_GRENADELAUNCHER_SMOKE",
["2982836145"] = "WEAPON_RPG",
["375527679"] = "WEAPON_PASSENGER_ROCKET",
["324506233"] = "WEAPON_AIRSTRIKE_ROCKET",
["1752584910"] = "WEAPON_STINGER",
["1119849093"] = "WEAPON_MINIGUN",
["2481070269"] = "WEAPON_GRENADE",
["741814745"] = "WEAPON_STICKYBOMB",
["4256991824"] = "WEAPON_SMOKEGRENADE",
["2694266206"] = "WEAPON_BZGAS",
["615608432"] = "WEAPON_MOLOTOV",
["101631238"] = "WEAPON_FIREEXTINGUISHER",
["883325847"] = "WEAPON_PETROLCAN",
["4256881901"] = "WEAPON_DIGISCANNER",
["2294779575"] = "WEAPON_BRIEFCASE",
["28811031"] = "WEAPON_BRIEFCASE_02",
["600439132"] = "WEAPON_BALL",
["1233104067"] = "WEAPON_FLARE",
["3204302209"] = "WEAPON_VEHICLE_ROCKET",
["1223143800"] = "WEAPON_BARBED_WIRE",
["4284007675"] = "WEAPON_DROWNING",
["1936677264"] = "WEAPON_DROWNING_IN_VEHICLE",
["2339582971"] = "WEAPON_BLEEDING",
["2461879995"] = "WEAPON_ELECTRIC_FENCE",
["539292904"] = "WEAPON_EXPLOSION",
["3452007600"] = "WEAPON_FALL",
["910830060"] = "WEAPON_EXHAUSTION",
["3425972830"] = "WEAPON_HIT_BY_WATER_CANNON",
["133987706"] = "WEAPON_RAMMED_BY_CAR",
["2741846334"] = "WEAPON_RUN_OVER_BY_CAR",
["341774354"] = "WEAPON_HELI_CRASH",
["3750660587"] = "WEAPON_FIRE",
["3218215474"] = "WEAPON_SNSPISTOL",
["4192643659"] = "WEAPON_BOTTLE",
["1627465347"] = "WEAPON_GUSENBERG",
["3231910285"] = "WEAPON_SPECIALCARBINE",
["3523564046"] = "WEAPON_HEAVYPISTOL",
["2132975508"] = "WEAPON_BULLPUPRIFLE",
["2460120199"] = "WEAPON_DAGGER",
["137902532"] = "WEAPON_VINTAGEPISTOL",
["2138347493"] = "WEAPON_FIREWORK",
["2828843422"] = "WEAPON_MUSKET",
["984333226"] = "WEAPON_HEAVYSHOTGUN",
["3342088282"] = "WEAPON_MARKSMANRIFLE",
["1672152130"] = "WEAPON_HOMINGLAUNCHER",
["2874559379"] = "WEAPON_PROXMINE",
["126349499"] = "WEAPON_SNOWBALL",
["1198879012"] = "WEAPON_FLAREGUN",
["3794977420"] = "WEAPON_GARBAGEBAG",
["3494679629"] = "WEAPON_HANDCUFFS",
["171789620"] = "WEAPON_COMBATPDW",
["3696079510"] = "WEAPON_MARKSMANPISTOL",
["3638508604"] = "WEAPON_KNUCKLE",
["4191993645"] = "WEAPON_HATCHET",
["1834241177"] = "WEAPON_RAILGUN",
["3713923289"] = "WEAPON_MACHETE",
["3675956304"] = "WEAPON_MACHINEPISTOL",
["738733437"] = "WEAPON_AIR_DEFENCE_GUN",
["3756226112"] = "WEAPON_SWITCHBLADE",
["3249783761"] = "WEAPON_REVOLVER",
["4019527611"] = "WEAPON_DBSHOTGUN",
["1649403952"] = "WEAPON_COMPACTRIFLE",
["317205821"] = "WEAPON_AUTOSHOTGUN",
["3441901897"] = "WEAPON_BATTLEAXE",
["125959754"] = "WEAPON_COMPACTLAUNCHER",
["3173288789"] = "WEAPON_MINISMG",
["3125143736"] = "WEAPON_PIPEBOMB",
["2484171525"] = "WEAPON_POOLCUE",
["419712736"] = "WEAPON_WRENCH"
}


local currentlyrobbing = {}
local store = ""
local secondsRemaining = 0

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


function drawTxt2(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function DrawText3DTest(text)
    local x,y,z=table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.5, 0.0))
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = 60 / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


local storetype = 0
RegisterNetEvent('AppRobberies:currentlyrobbing')
AddEventHandler('AppRobberies:currentlyrobbing', function()
    if exports["np-inventory"]:hasEnoughOfItem("lockpick",1) then
        checkRobbedStore()
        Citizen.Wait(1500)
        TriggerServerEvent("AppRobberies:rob",store,currentlyrobbing.xe, currentlyrobbing.ye, currentlyrobbing.ze,storetype)
    end
end)

RegisterNetEvent('AppRobberies:startRobbery')
AddEventHandler('AppRobberies:startRobbery', function()
     for i,v in pairs(interiors) do
        if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xe,interiors[i].ye,interiors[i].ze)) < 2 then
            TriggerEvent("robbery:appartmentName",interiors[i].name)
            -- this event no longer exist's 
            TriggerServerEvent("robbery:startRobberyForClient",{interiors[i].xe,interiors[i].ye,interiors[i].ze},1,21,"appartments",0,{1,8,3,3},{1,3,6,6},10)
        end
    end
end)
RegisterNetEvent('AppRobberies:StockChange')
AddEventHandler('AppRobberies:StockChange', function()
    if storetype == 2 or storetype == 4 or storetype == 5 or storetype == 6 or storetype == 1 then
        if math.random(100) > 80 then
            local amount = math.random(10) / 10
            TriggerServerEvent("stocks:reducestock",storetype,amount)
        end
    end
    storetype = 0
end)

function checkRobbedStore()
     for i,v in pairs(interiors) do
        if #(GetEntityCoords(PlayerPedId()) - vector3(interiors[i].xe,interiors[i].ye,interiors[i].ze)) < 2 then
            currentlyrobbing = interiors[i]
            store = interiors[i].name
            storeType = interiors[i].TypeOfProperty
        end
    end
end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end
