local function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

local Keys = {
    [289] = "F2", [170] = "F3", [166] = "F5", [167] = "F6", [168] = "F7" ,[56] = "F9", [57] = "F10" 
}

local p_anims = {}
local favorites = {}
local currentKeys = {
    {["key"] = {289},["anim"] = ""},
    {["key"] = {170},["anim"] = ""},
    {["key"] = {166},["anim"] = ""},
    {["key"] = {167},["anim"] = ""},
    {["key"] = {168},["anim"] = ""},
    {["key"] = {56},["anim"] = ""},
    {["key"] = {57},["anim"] = ""},

    {["key"] = {289,21},["anim"] = ""},
    {["key"] = {170,21},["anim"] = ""},
    {["key"] = {166,21},["anim"] = ""},
    {["key"] = {167,21},["anim"] = ""},
    {["key"] = {168,21},["anim"] = ""},
    {["key"] = {56,21},["anim"] = ""},
    {["key"] = {57,21},["anim"] = ""},
}
local dToggle = false








local dogEmote = {
    [289] = "dogsit",
    [170] = "bark",
    [166] = "bark2",
    [167] = "beg",
    [168] = "paw",
    [56] = "pet",
    [57] = "dump",
    -- Shift + key , done via  key + 21
    [310] = "pee",
    [191] = "indicateahead",
    [187] = "laydown",

}

WarMenu.CreateMenu("emotes", "Emotes")
WarMenu.SetSubTitle("emotes", "Emote List")

WarMenu.SetMenuWidth("emotes", 0.5)
WarMenu.SetMenuX("emotes", 0.71)
WarMenu.SetMenuY("emotes", 0.017)
WarMenu.SetMenuMaxOptionCountOnScreen("emotes", 15)
WarMenu.SetTitleColor("emotes", 135, 206, 250, 255)
WarMenu.SetTitleBackgroundColor("emotes", 0 , 0, 0, 150)
WarMenu.SetMenuBackgroundColor("emotes", 0, 0, 0, 100)
WarMenu.SetMenuSubTextColor("emotes", 255, 255, 255, 255)


WarMenu.CreateSubMenu("favorites", "emotes", "Favorites (Press F to remove a favorite)")
WarMenu.SetMenuWidth("favorites", 0.5)
WarMenu.SetMenuMaxOptionCountOnScreen("favorites", 30)
WarMenu.SetTitleColor("favorites", 135, 206, 250, 255)
WarMenu.SetTitleBackgroundColor("favorites", 0 , 0, 0, 150)
WarMenu.SetMenuBackgroundColor("favorites", 0, 0, 0, 100)
WarMenu.SetMenuSubTextColor("favorites", 255, 255, 255, 255)

local selected_page = 1

local function DrawMenu()
    if WarMenu.Button("Page:", selected_page.."/"..#p_anims, {r = 135, g = 206, b = 250, a = 150}) then ClearPedTasks(PlayerPedId()) playing_emote = false end
    if WarMenu.Button("Favorites", "Press F to favorite an emote", {r = 135, g = 206, b = 250, a = 150}) then WarMenu.OpenMenu("favorites") end
    local key = ""
    for i,v in ipairs(currentKeys) do
        if v.key[2] ~= nil and "Cancel Emote" == v.anim then
             key = "Shift+"..Keys[v.key[1]]
        elseif v.key[1] ~= nil and "Cancel Emote" == v.anim then
           key = Keys[v.key[1]]
        end
    end 
    if WarMenu.Button("Cancel Emote",key, {r = 135, g = 206, b = 250, a = 150}) then ClearPedTasks(PlayerPedId()) playing_emote = false end

    for k,v in spairs(p_anims[selected_page], function(t, a, b) return string.lower(tostring(a)) < string.lower(tostring(b)) end) do
    local msg = ""
        for i,v in ipairs(currentKeys) do
            if v.key[2] ~= nil and k == v.anim then
                 msg = "Shift+"..Keys[v.key[1]]
            elseif v.key[1] ~= nil and k == v.anim then
               msg = Keys[v.key[1]]
            end
        end 
        if WarMenu.Button(k,msg) then TriggerEvent("animation:PlayAnimation", k) end
    end
end

local function DrawFavorites()
    if WarMenu.Button("Cancel Emote", nil, {r = 135, g = 206, b = 250, a = 150}) then ClearPedTasks(PlayerPedId()) playing_emote = false end
    if WarMenu.MenuButton("Back", "emotes", {r = 135, g = 206, b = 250, a = 150}) then end

    for k,v in spairs(favorites, function(t, a, b) return string.lower(tostring(t[a])) < string.lower(tostring(t[b])) end) do
        if WarMenu.Button(v) then TriggerEvent("animation:PlayAnimation", v) end
    end
end

function addKey(anim,keys)
    if anim == "Page:" or anim == "Favorites" or anim == "Back" then return end
    for i,v in ipairs(currentKeys) do
        if keys[2] ~= nil then
            if v.key[1] == keys[1] and v.key[2] == 21 then
                v.anim = anim
            end
        else 
            if v.key[1] == keys[1] and v.key[2] == nil then
                v.anim = anim
            end
        end
    end
    TriggerServerEvent("police:setEmoteData",currentKeys)
end

local function addFavorite(anim)
    if not anims[anim] then return end
    for k,v in pairs(favorites) do if v == anim then return end end

    local key = 0

    for k,v in pairs(favorites) do
        local c = tonumber(string.match(k, "%d+"))
        if c >= key then key = c end
    end

    key = key + 1

    favorites["fav:"..key] = anim
    SetResourceKvp("fav:"..key, anim)
end

local function removeFavorite(anim)
    for k,v in pairs(favorites) do
        if v == anim then
            DeleteResourceKvp(k)
            favorites[k] = nil
        end
    end
end

function DrawText3Ds(x,y,z, text)
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

end

Citizen.CreateThread(function()
    local c = 0
    local page = 1

    for k,v in spairs(anims, function(t, a, b) return string.lower(tostring(a)) < string.lower(tostring(b)) end) do
        p_anims[page] = p_anims[page] and p_anims[page] or {}
        p_anims[page][k] = v
        c = c + 1
        if c >= 7 then c = 0 page = page + 1 end
    end

    local KvpHandle = StartFindKvp("fav:")

    repeat
        local key = FindKvp(KvpHandle)
        if key then
            favorites[key] = GetResourceKvpString(key)
        end
    until not key

    while true do
        Citizen.Wait(1)
        if WarMenu.IsMenuOpened("emotes") then
            DrawMenu()

            WarMenu.Display()
            local plyCoords = GetEntityCoords(PlayerPedId())
            DrawText3Ds(plyCoords["x"],plyCoords["y"],plyCoords["z"]+0.4,"~g~Enter~s~ Plays Emote")
            DrawText3Ds(plyCoords["x"],plyCoords["y"],plyCoords["z"]+0.3,"~g~Arrows~s~ Navigate Pages")
            DrawText3Ds(plyCoords["x"],plyCoords["y"],plyCoords["z"]+0.2,"~g~Backspace~s~ Exits")
            DrawText3Ds(plyCoords["x"],plyCoords["y"],plyCoords["z"]+0.1,"~g~F2-F10~s~ Saves Emote")
            DrawText3Ds(plyCoords["x"],plyCoords["y"],plyCoords["z"],"~g~Shift~s~ with F keys saves also. (F8 Doesnt Save)")
            DrawText3Ds(plyCoords["x"],plyCoords["y"],plyCoords["z"]-0.1,"You can also type ~g~/e emotename~s~ in chat to perform them")
            if IsControlJustReleased(0, 174) then
                selected_page = selected_page > 1 and selected_page - 1 or #p_anims
            elseif IsControlJustReleased(0, 175) then
                selected_page = selected_page < #p_anims and selected_page + 1 or 1
            elseif IsControlJustReleased(0, 26) then
                for i,v in ipairs(currentKeys) do
                    local curButton = WarMenu.GetCurrentButton()
                    if v.anim == curButton.text then
                        v.anim = ""
                    end
                end
            elseif IsControlJustPressed(0, 23) then
                local curButton = WarMenu.GetCurrentButton()
                if curButton then
                    addFavorite(curButton.text)
                end
            end

            for i,v in ipairs(currentKeys) do
                if v.key[2] ~= nil then
                    if IsControlPressed(0,21) and IsControlJustReleased(0, v.key[1]) then
                       local curButton = WarMenu.GetCurrentButton()
                        if curButton then
                            addKey(curButton.text,{v.key[1],21})
                        end
                    end
                else
                    if not IsControlPressed(0,21) and IsControlJustReleased(0, v.key[1]) then
                       local curButton = WarMenu.GetCurrentButton()
                        if curButton then
                            addKey(curButton.text,{v.key[1]})
                        end
                    end
                end
            end

        elseif WarMenu.IsMenuOpened("favorites") then
            DrawFavorites()
            WarMenu.Display()

            if IsControlJustPressed(0, 23) then
                local curButton = WarMenu.GetCurrentButton()
                if curButton then
                    removeFavorite(curButton.text)
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

RegisterNetEvent("emotes:OpenMenu")
AddEventHandler("emotes:OpenMenu", function()
    TriggerServerEvent("police:getAnimData")
    TriggerServerEvent("police:getEmoteData")
    WarMenu.OpenMenu("emotes")
end)

RegisterNetEvent("emote:setEmotesFromDB");
AddEventHandler("emote:setEmotesFromDB", function(emotesResult)
    if emotesResult == nil or emotesResult[1] == nil then return print("emotes gg") end
    print(json.encode(emotesResult))
    currentKeys = emotesResult
end)

RegisterNetEvent("np-admin:currentDevmode")
AddEventHandler("np-admin:currentDevmode", function(devmode)
    dToggle = devmode
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if not dToggle then
            local model = GetEntityModel(PlayerPedId())

            for i,v in ipairs(currentKeys) do
                if v.key[2] ~= nil then
                    if IsControlPressed(0,21) and IsControlJustReleased(0, v.key[1]) then
                        if v.anim == "Cancel Emote" then
                            ClearPedTasks(PlayerPedId()) playing_emote = false
                        else
                            if model == GetHashKey("a_c_chop") then
                                TriggerEvent("animation:PlayAnimation", dogEmote[v.key[1]+21])
                            else
                                TriggerEvent("animation:PlayAnimation", v.anim)
                            end
                        end
                    end
                else
                    if not IsControlPressed(0,21) and IsControlJustReleased(0, v.key[1]) then
                        if v.anim == "Cancel Emote" then
                            ClearPedTasks(PlayerPedId()) playing_emote = false
                        else
                            if model == GetHashKey("a_c_chop") then
                                TriggerEvent("animation:PlayAnimation", dogEmote[v.key[1]])
                            else
                                TriggerEvent("animation:PlayAnimation", v.anim)
                            end
                        end
                    end
                end
            end
        end
    end
end)