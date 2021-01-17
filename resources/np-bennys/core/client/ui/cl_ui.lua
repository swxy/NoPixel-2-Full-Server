--[[
cl_ui.lua
Functionality for everything that is the UI.
]]

--#[Local Variable]#--
local currentMenuItemID = 0
local currentMenuItem = ""
local currentMenuItem2 = ""
local currentMenu = "mainMenu"

local currentCategory = 0

local currentResprayCategory = 0
local currentResprayType = 0

local currentWheelCategory = 0

local currentNeonSide = 0

local menuStructure = {}

--#[Local Functions]#--
local function roundNum(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function toggleMenuContainer(state)
    SendNUIMessage({
        toggleMenuContainer = true,
        state = state
    })
end

local function createMenu(menu, heading, subheading)
    SendNUIMessage({
        createMenu = true,
        menu = menu,
        heading = heading,
        subheading = subheading
    })
end

local function destroyMenus()
    SendNUIMessage({
        destroyMenus = true
    })
end

local function populateMenu(menu, id, item, item2)
    SendNUIMessage({
        populateMenu = true,
        menu = menu,
        id = id,
        item = item,
        item2 = item2
    })
end

local function finishPopulatingMenu(menu)
    SendNUIMessage({
        finishPopulatingMenu = true,
        menu = menu
    })
end

local function updateMenuHeading(menu)
    SendNUIMessage({
        updateMenuHeading = true,
        menu = menu
    })
end

local function updateMenuSubheading(menu)
    SendNUIMessage({
        updateMenuSubheading = true,
        menu = menu
    })
end

local function updateMenuStatus(text)
    SendNUIMessage({
        updateMenuStatus = true,
        statusText = text
    })
end

local function toggleMenu(state, menu)
    SendNUIMessage({
        toggleMenu = true,
        state = state,
        menu = menu
    })
end

local function updateItem2Text(menu, id, text)
    SendNUIMessage({
        updateItem2Text = true,
        menu = menu,
        id = id,
        item2 = text
    })
end

local function updateItem2TextOnly(menu, id, text)
    SendNUIMessage({
        updateItem2TextOnly = true,
        menu = menu,
        id = id,
        item2 = text
    })
end

local function scrollMenuFunctionality(direction, menu)
    SendNUIMessage({
        scrollMenuFunctionality = true,
        direction = direction,
        menu = menu
    })
end

local function playSoundEffect(soundEffect, volume)
    SendNUIMessage({
        playSoundEffect = true,
        soundEffect = soundEffect,
        volume = volume
    })
end

local function isMenuActive(menu)
    local menuActive = false

    if menu == "modMenu" then
        for k, v in pairs(vehicleCustomisation) do 
            if (v.category:gsub("%s+", "") .. "Menu") == currentMenu then
                menuActive = true
    
                break
            else
                menuActive = false
            end
        end
    elseif menu == "ResprayMenu" then
        for k, v in pairs(vehicleResprayOptions) do
            if (v.category:gsub("%s+", "") .. "Menu") == currentMenu then
                menuActive = true
    
                break
            else
                menuActive = false
            end
        end
    elseif menu == "WheelsMenu" then
        for k, v in pairs(vehicleWheelOptions) do
            if (v.category:gsub("%s+", "") .. "Menu") == currentMenu then
                menuActive = true
    
                break
            else
                menuActive = false
            end
        end
    elseif menu == "NeonsSideMenu" then
        for k, v in pairs(vehicleNeonOptions.neonTypes) do
            if (v.name:gsub("%s+", "") .. "Menu") == currentMenu then
                menuActive = true
    
                break
            else
                menuActive = false
            end
        end
    end

    return menuActive
end

local function updateCurrentMenuItemID(id, item, item2)
    currentMenuItemID = id
    currentMenuItem = item
    currentMenuItem2 = item2

    if isMenuActive("modMenu") then
        if currentCategory ~= 18 then
            PreviewMod(currentCategory, currentMenuItemID)
        end
    elseif isMenuActive("ResprayMenu") then
        PreviewColour(currentResprayCategory, currentResprayType, currentMenuItemID)
    elseif isMenuActive("WheelsMenu") then
        if currentWheelCategory ~= -1 and currentWheelCategory ~= 20 then
            PreviewWheel(currentCategory, currentMenuItemID, currentWheelCategory)
        end
    elseif isMenuActive("NeonsSideMenu") then
        PreviewNeon(currentNeonSide, currentMenuItemID)
    elseif currentMenu == "WindowTintMenu" then
        PreviewWindowTint(currentMenuItemID)
    elseif currentMenu == "NeonColoursMenu" then
        local r = vehicleNeonOptions.neonColours[currentMenuItemID].r
        local g = vehicleNeonOptions.neonColours[currentMenuItemID].g
        local b = vehicleNeonOptions.neonColours[currentMenuItemID].b

        PreviewNeonColour(r, g, b)
    elseif currentMenu == "XenonColoursMenu" then
        PreviewXenonColour(currentMenuItemID)
    elseif currentMenu == "OldLiveryMenu" then
        PreviewOldLivery(currentMenuItemID)
    elseif currentMenu == "PlateIndexMenu" then
        PreviewPlateIndex(currentMenuItemID)
    end
end

--#[Global Functions]#--
function Draw3DText(x, y, z, str, r, g, b, a, font, scaleSize, enableProportional, enableCentre, enableOutline, enableShadow, sDist, sR, sG, sB, sA)
    local onScreen, worldX, worldY = World3dToScreen2d(x, y, z)
    local gameplayCamX, gameplayCamY, gameplayCamZ = table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(1.0, scaleSize)
        SetTextFont(font)
        SetTextColour(r, g, b, a)
        SetTextEdge(2, 0, 0, 0, 150)

        if enableProportional then
            SetTextProportional(1)
        end

        if enableOutline then
            SetTextOutline()
        end

        if enableShadow then
            SetTextDropshadow(sDist, sR, sG, sB, sA)
            SetTextDropShadow()
        end

        if enableCentre then
            SetTextCentre(1)
        end
        
        SetTextEntry("STRING")
        AddTextComponentString(str)
        DrawText(worldX, worldY)
    end
end

function InitiateMenus(isMotorcycle, vehicleHealth)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    --#[Repair Menu]#--
    if vehicleHealth < 1000.0 then
        local repairCost = math.ceil(1000 - vehicleHealth)

        TriggerServerEvent("np-bennys:updateRepairCost", repairCost)
        createMenu("repairMenu", "Welcome to Benny's Original Motorworks", "Repair Vehicle")
        populateMenu("repairMenu", -1, "Repair", "$" .. repairCost)
        finishPopulatingMenu("repairMenu")
    end

    --#[Main Menu]#--
    createMenu("mainMenu", "Welcome to Benny's Original Motorworks", "Choose a Category")

    for k, v in ipairs(vehicleCustomisation) do 
        local validMods, amountValidMods = CheckValidMods(v.category, v.id)
        
        if amountValidMods > 0 or v.id == 18 then
            populateMenu("mainMenu", v.id, v.category, "none")
        end
    end

    populateMenu("mainMenu", -1, "Respray", "none")

    if not isMotorcycle then
        populateMenu("mainMenu", -2, "Window Tint", "none")
        populateMenu("mainMenu", -3, "Neons", "none")
    end

    populateMenu("mainMenu", 22, "Xenons", "none")
    populateMenu("mainMenu", 23, "Wheels", "none")

    populateMenu("mainMenu", 24, "Old Livery", "none")
    populateMenu("mainMenu", 25, "Plate Index", "none")
    populateMenu("mainMenu", 26, "Vehicle Extras", "none")

    finishPopulatingMenu("mainMenu")

    --#[Mods Menu]#--
    for k, v in ipairs(vehicleCustomisation) do 
        local validMods, amountValidMods = CheckValidMods(v.category, v.id)
        local currentMod, currentModName = GetCurrentMod(v.id)

        if amountValidMods > 0 or v.id == 18 then
            if v.id == 11 or v.id == 12 or v.id == 13 or v.id == 15 or v.id == 16 then --Performance Upgrades
                local tempNum = 0
            
                createMenu(v.category:gsub("%s+", "") .. "Menu", v.category, "Choose an Upgrade")

                for m, n in pairs(validMods) do
                    tempNum = tempNum + 1

                    if maxVehiclePerformanceUpgrades == 0 then
                        populateMenu(v.category:gsub("%s+", "") .. "Menu", n.id, n.name, "$" .. vehicleCustomisationPrices.performance.prices[tempNum])

                        if currentMod == n.id then
                            updateItem2Text(v.category:gsub("%s+", "") .. "Menu", n.id, "Installed")
                        end
                    else
                        if tempNum <= (maxVehiclePerformanceUpgrades + 1) then
                            populateMenu(v.category:gsub("%s+", "") .. "Menu", n.id, n.name, "$" .. vehicleCustomisationPrices.performance.prices[tempNum])

                            if currentMod == n.id then
                                updateItem2Text(v.category:gsub("%s+", "") .. "Menu", n.id, "Installed")
                            end
                        end
                    end
                end
                
                finishPopulatingMenu(v.category:gsub("%s+", "") .. "Menu")
            elseif v.id == 18 then
                local currentTurboState = GetCurrentTurboState()
                createMenu(v.category:gsub("%s+", "") .. "Menu", v.category .. " Customisation", "Enable or Disable Turbo")

                populateMenu(v.category:gsub("%s+", "") .. "Menu", 0, "Disable", "$0")
                populateMenu(v.category:gsub("%s+", "") .. "Menu", 1, "Enable", "$" .. vehicleCustomisationPrices.turbo.price)

                updateItem2Text(v.category:gsub("%s+", "") .. "Menu", currentTurboState, "Installed")

                finishPopulatingMenu(v.category:gsub("%s+", "") .. "Menu")
            else
                createMenu(v.category:gsub("%s+", "") .. "Menu", v.category .. " Customisation", "Choose a Mod")

                for m, n in pairs(validMods) do
                    populateMenu(v.category:gsub("%s+", "") .. "Menu", n.id, n.name, "$" .. vehicleCustomisationPrices.cosmetics.price)

                    if currentMod == n.id then
                        updateItem2Text(v.category:gsub("%s+", "") .. "Menu", n.id, "Installed")
                    end
                end
                
                finishPopulatingMenu(v.category:gsub("%s+", "") .. "Menu")
            end
        end
    end

    --#[Respray Menu]#--
    createMenu("ResprayMenu", "Respray", "Choose a Colour Category")

    populateMenu("ResprayMenu", 0, "Primary Colour", "none")
    populateMenu("ResprayMenu", 1, "Secondary Colour", "none")
    populateMenu("ResprayMenu", 2, "Pearlescent Colour", "none")
    populateMenu("ResprayMenu", 3, "Wheel Colour", "none")
    populateMenu("ResprayMenu", 4, "Interior Colour", "none")
    populateMenu("ResprayMenu", 5, "Dashboard Colour", "none")

    finishPopulatingMenu("ResprayMenu")

    --#[Respray Types]#--
    createMenu("ResprayTypeMenu", "Respray Types", "Choose a Colour Type")

    for k, v in ipairs(vehicleResprayOptions) do
        populateMenu("ResprayTypeMenu", v.id, v.category, "none")
    end

    finishPopulatingMenu("ResprayTypeMenu")

    --#[Respray Colours]#--
    for k, v in ipairs(vehicleResprayOptions) do 
        createMenu(v.category .. "Menu", v.category .. " Colours", "Choose a Colour")

        for m, n in ipairs(v.colours) do
            populateMenu(v.category .. "Menu", n.id, n.name, "$" .. vehicleCustomisationPrices.respray.price)
        end

        finishPopulatingMenu(v.category .. "Menu")
    end

    --#[Wheel Categories Menu]#--
    createMenu("WheelsMenu", "Wheel Categories", "Choose a Category")

    for k, v in ipairs(vehicleWheelOptions) do 
        if isMotorcycle then
            if v.id == -1 or v.id == 20 or v.id == 6 then --Motorcycle Wheels
                populateMenu("WheelsMenu", v.id, v.category, "none")
            end
        else
            populateMenu("WheelsMenu", v.id, v.category, "none")
        end
    end

    finishPopulatingMenu("WheelsMenu")

    --#[Wheels Menu]#--
    for k, v in ipairs(vehicleWheelOptions) do 
        if v.id == -1 then
            local currentCustomWheelState = GetCurrentCustomWheelState()
            createMenu(v.category:gsub("%s+", "") .. "Menu", v.category, "Enable or Disable Custom Wheels")

            populateMenu(v.category:gsub("%s+", "") .. "Menu", 0, "Disable", "$0")
            populateMenu(v.category:gsub("%s+", "") .. "Menu", 1, "Enable", "$" .. vehicleCustomisationPrices.customwheels.price)

            updateItem2Text(v.category:gsub("%s+", "") .. "Menu", currentCustomWheelState, "Installed")

            finishPopulatingMenu(v.category:gsub("%s+", "") .. "Menu")
        elseif v.id ~= 20 then
            if isMotorcycle then
                if v.id == 6 then --Motorcycle Wheels
                    local validMods, amountValidMods = CheckValidMods(v.category, v.wheelID, v.id)

                    createMenu(v.category .. "Menu", v.category .. " Wheels", "Choose a Wheel")

                    for m, n in pairs(validMods) do
                        populateMenu(v.category .. "Menu", n.id, n.name, "$" .. vehicleCustomisationPrices.wheels.price)
                    end

                    finishPopulatingMenu(v.category .. "Menu")
                end
            else
                local validMods, amountValidMods = CheckValidMods(v.category, v.wheelID, v.id)

                createMenu(v.category .. "Menu", v.category .. " Wheels", "Choose a Wheel")

                for m, n in pairs(validMods) do
                    populateMenu(v.category .. "Menu", n.id, n.name, "$" .. vehicleCustomisationPrices.wheels.price)
                end

                finishPopulatingMenu(v.category .. "Menu")
            end
        end
    end

    --#[Wheel Smoke Menu]#--
    local currentWheelSmokeR, currentWheelSmokeG, currentWheelSmokeB = GetCurrentVehicleWheelSmokeColour()
    createMenu("TyreSmokeMenu", "Tyre Smoke Customisation", "Choose a Colour")

    for k, v in ipairs(vehicleTyreSmokeOptions) do
        populateMenu("TyreSmokeMenu", k, v.name, "$" .. vehicleCustomisationPrices.wheelsmoke.price)

        if v.r == currentWheelSmokeR and v.g == currentWheelSmokeG and v.b == currentWheelSmokeB then
            updateItem2Text("TyreSmokeMenu", k, "Installed")
        end
    end

    finishPopulatingMenu("TyreSmokeMenu")

    --#[Window Tint Menu]#--
    local currentWindowTint = GetCurrentWindowTint()
    createMenu("WindowTintMenu", "Window Tint Customisation", "Choose a Tint")

    for k, v in ipairs(vehicleWindowTintOptions) do 
        populateMenu("WindowTintMenu", v.id, v.name, "$" .. vehicleCustomisationPrices.windowtint.price)

        if currentWindowTint == v.id then
            updateItem2Text("WindowTintMenu", v.id, "Installed")
        end
    end

    finishPopulatingMenu("WindowTintMenu")

    --#[Old Livery Menu]#--
    local livCount = GetVehicleLiveryCount(plyVeh)
    if livCount > 0 then
        local tempOldLivery = GetVehicleLivery(plyVeh)
        createMenu("OldLiveryMenu", "Old Livery Customisation", "Choose a Livery")
        if GetVehicleClass(plyVeh) ~= 18 then
            for i=0, GetVehicleLiveryCount(plyVeh)-1 do
                populateMenu("OldLiveryMenu", i, "Livery", "$100")
                if tempOldLivery == i then
                    updateItem2Text("OldLiveryMenu", i, "Installed")
                end
            end
        end
        finishPopulatingMenu("OldLiveryMenu")
    end

    --#[Plate Colour Index Menu]#--

    local tempPlateIndex = GetVehicleNumberPlateTextIndex(plyVeh)
    createMenu("PlateIndexMenu", "Plate Colour", "Choose a Style")
    local plateTypes = {
        "Blue on White #1",
        "Yellow on Black",
        "Yellow on Blue",
        "Blue on White #2",
        "Blue on White #3",
        "North Yankton",
    }
    if GetVehicleClass(plyVeh) ~= 18 then
        for i=0, #plateTypes-1 do
            if i ~= 4 then
                populateMenu("PlateIndexMenu", i, plateTypes[i+1], "$1000")
                if tempPlateIndex == i then
                    updateItem2Text("PlateIndexMenu", i, "Installed")
                end
            end
        end
    end
    finishPopulatingMenu("PlateIndexMenu")

    --#[Vehicle Extras Menu]#--
    createMenu("VehicleExtrasMenu", "Vehicle Extras Customisation", "Toggle Extras")
    if GetVehicleClass(plyVeh) ~= 18 then
        for i=1, 12 do
            if DoesExtraExist(plyVeh, i) then
                populateMenu("VehicleExtrasMenu", i, "Extra "..tostring(i), "Toggle")
            else
                populateMenu("VehicleExtrasMenu", i, "No Option", "NONE")
            end
        end
    end
    finishPopulatingMenu("VehicleExtrasMenu")

    --#[Neons Menu]#--
    createMenu("NeonsMenu", "Neon Customisation", "Choose a Category")

    for k, v in ipairs(vehicleNeonOptions.neonTypes) do
        populateMenu("NeonsMenu", v.id, v.name, "none")
    end

    populateMenu("NeonsMenu", -1, "Neon Colours", "none")
    finishPopulatingMenu("NeonsMenu")

    --#[Neon State Menu]#--
    for k, v in ipairs(vehicleNeonOptions.neonTypes) do
        local currentNeonState = GetCurrentNeonState(v.id)
        createMenu(v.name:gsub("%s+", "") .. "Menu", "Neon Customisation", "Enable or Disable Neon")

        populateMenu(v.name:gsub("%s+", "") .. "Menu", 0, "Disabled", "$0")
        populateMenu(v.name:gsub("%s+", "") .. "Menu", 1, "Enabled", "$" .. vehicleCustomisationPrices.neonside.price)

        updateItem2Text(v.name:gsub("%s+", "") .. "Menu", currentNeonState, "Installed")

        finishPopulatingMenu(v.name:gsub("%s+", "") .. "Menu")
    end

    --#[Neon Colours Menu]#--
    local currentNeonR, currentNeonG, currentNeonB = GetCurrentNeonColour()
    createMenu("NeonColoursMenu", "Neon Colours", "Choose a Colour")

    for k, v in ipairs(vehicleNeonOptions.neonColours) do
        populateMenu("NeonColoursMenu", k, vehicleNeonOptions.neonColours[k].name, "$" .. vehicleCustomisationPrices.neoncolours.price)

        if currentNeonR == vehicleNeonOptions.neonColours[k].r and currentNeonG == vehicleNeonOptions.neonColours[k].g and currentNeonB == vehicleNeonOptions.neonColours[k].b then
            updateItem2Text("NeonColoursMenu", k, "Installed")
        end
    end

    finishPopulatingMenu("NeonColoursMenu")

    --#[Xenons Menu]#--
    createMenu("XenonsMenu", "Xenon Customisation", "Choose a Category")

    populateMenu("XenonsMenu", 0, "Headlights", "none")
    populateMenu("XenonsMenu", 1, "Xenon Colours", "none")

    finishPopulatingMenu("XenonsMenu")

    --#[Xenons Headlights Menu]#--
    local currentXenonState = GetCurrentXenonState()
    createMenu("HeadlightsMenu", "Headlights Customisation", "Enable or Disable Xenons")

    populateMenu("HeadlightsMenu", 0, "Disable Xenons", "$0")
    populateMenu("HeadlightsMenu", 1, "Enable Xenons", "$" .. vehicleCustomisationPrices.headlights.price)

    updateItem2Text("HeadlightsMenu", currentXenonState, "Installed")

    finishPopulatingMenu("HeadlightsMenu")

    --#[Xenons Colour Menu]#--
    local currentXenonColour = GetCurrentXenonColour()
    createMenu("XenonColoursMenu", "Xenon Colours", "Choose a Colour")

    for k, v in ipairs(vehicleXenonOptions.xenonColours) do
        populateMenu("XenonColoursMenu", v.id, v.name, "$" .. vehicleCustomisationPrices.xenoncolours.price)

        if currentXenonColour == v.id then
            updateItem2Text("XenonColoursMenu", v.id, "Installed")
        end
    end

    finishPopulatingMenu("XenonColoursMenu")
end

function DestroyMenus()
    destroyMenus()
end

function DisplayMenuContainer(state)
    toggleMenuContainer(state)
end

function DisplayMenu(state, menu)
    if state then
        currentMenu = menu
    end

    toggleMenu(state, menu)
    updateMenuHeading(menu)
    updateMenuSubheading(menu)
end

function MenuManager(state)
    if state then
        if currentMenuItem2 ~= "Installed" then
            if isMenuActive("modMenu") then
                if currentCategory == 18 then --Turbo
                    if AttemptPurchase("turbo") then
                        ApplyMod(currentCategory, currentMenuItemID)
                        playSoundEffect("wrench", 0.4)
                        updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                        updateMenuStatus("Purchased")
                    else
                        updateMenuStatus("Not Enough Money!")
                    end
                elseif currentCategory == 11 or currentCategory == 12 or currentCategory== 13 or currentCategory == 15 or currentCategory == 16 then --Performance Upgrades
                    if AttemptPurchase("performance", currentMenuItemID) then
                        ApplyMod(currentCategory, currentMenuItemID)
                        playSoundEffect("wrench", 0.4)
                        updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                        updateMenuStatus("Purchased")
                    else
                        updateMenuStatus("Not Enough Money")
                    end
                else
                    if AttemptPurchase("cosmetics") then
                        ApplyMod(currentCategory, currentMenuItemID)
                        playSoundEffect("wrench", 0.4)
                        updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                        updateMenuStatus("Purchased")
                    else
                        updateMenuStatus("Not Enough Money")
                    end
                end
            elseif isMenuActive("ResprayMenu") then
                if AttemptPurchase("respray") then
                    ApplyColour(currentResprayCategory, currentResprayType, currentMenuItemID)
                    playSoundEffect("respray", 1.0)
                    updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                    updateMenuStatus("Purchased")
                else
                    updateMenuStatus("Not Enough Money")
                end
            elseif isMenuActive("WheelsMenu") then
                if currentWheelCategory == 20 then
                    if AttemptPurchase("wheelsmoke") then
                        local r = vehicleTyreSmokeOptions[currentMenuItemID].r
                        local g = vehicleTyreSmokeOptions[currentMenuItemID].g
                        local b = vehicleTyreSmokeOptions[currentMenuItemID].b

                        ApplyTyreSmoke(r, g, b)
                        playSoundEffect("wrench", 0.4)
                        updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                        updateMenuStatus("Purchased")
                    else
                        updateMenuStatus("Not Enough Money")
                    end
                else
                    if currentWheelCategory == -1 then --Custom Wheels
                        local currentWheel = GetCurrentWheel()

                        if currentWheel == -1 then
                            updateMenuStatus("Can't Apply Custom Tyres to Stock Wheels")
                        else
                            if AttemptPurchase("customwheels") then
                                ApplyCustomWheel(currentMenuItemID)
                                playSoundEffect("wrench", 0.4)
                                updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                                updateMenuStatus("Purchased")
                            else
                                updateMenuStatus("Not Enough Money")
                            end
                        end
                    else
                        local currentWheel = GetCurrentWheel()
                        local currentCustomWheelState = GetOriginalCustomWheel()

                        if currentCustomWheelState and currentWheel == -1 then
                            updateMenuStatus("Can't Apply Stock Wheels With Custom Tyres")
                        else
                            if AttemptPurchase("wheels") then
                                ApplyWheel(currentCategory, currentMenuItemID, currentWheelCategory)
                                playSoundEffect("wrench", 0.4)
                                updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                                updateMenuStatus("Purchased")
                            else
                                updateMenuStatus("Not Enough Money")
                            end
                        end
                    end
                end
            elseif isMenuActive("NeonsSideMenu") then
                if AttemptPurchase("neonside") then
                    ApplyNeon(currentNeonSide, currentMenuItemID)
                    playSoundEffect("wrench", 0.4)
                    updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                    updateMenuStatus("Purchased")
                else
                    updateMenuStatus("Not Enough Money")
                end 
            else
                if currentMenu == "repairMenu" then
                    if AttemptPurchase("repair") then
                        currentMenu = "mainMenu"

                        RepairVehicle()

                        toggleMenu(false, "repairMenu")
                        toggleMenu(true, currentMenu)
                        updateMenuHeading(currentMenu)
                        updateMenuSubheading(currentMenu)
                        playSoundEffect("wrench", 0.4)
                        updateMenuStatus("")
                    else
                        updateMenuStatus("Not Enough Money")
                    end
                elseif currentMenu == "mainMenu" then
                    currentMenu = currentMenuItem:gsub("%s+", "") .. "Menu"
                    currentCategory = currentMenuItemID

                    toggleMenu(false, "mainMenu")
                    toggleMenu(true, currentMenu)
                    updateMenuHeading(currentMenu)
                    updateMenuSubheading(currentMenu)
                elseif currentMenu == "ResprayMenu" then
                    currentMenu = "ResprayTypeMenu"
                    currentResprayCategory = currentMenuItemID

                    toggleMenu(false, "ResprayMenu")
                    toggleMenu(true, currentMenu)
                    updateMenuHeading(currentMenu)
                    updateMenuSubheading(currentMenu)
                elseif currentMenu == "ResprayTypeMenu" then
                    currentMenu = currentMenuItem:gsub("%s+", "") .. "Menu"
                    currentResprayType = currentMenuItemID

                    toggleMenu(false, "ResprayTypeMenu")
                    toggleMenu(true, currentMenu)
                    updateMenuHeading(currentMenu)
                    updateMenuSubheading(currentMenu)
                elseif currentMenu == "WheelsMenu" then
                    local currentWheel, currentWheelName, currentWheelType = GetCurrentWheel()

                    currentMenu = currentMenuItem:gsub("%s+", "") .. "Menu"
                    currentWheelCategory = currentMenuItemID
                    
                    if currentWheelType == currentWheelCategory then
                        updateItem2Text(currentMenu, currentWheel, "Installed")
                    end

                    toggleMenu(false, "WheelsMenu")
                    toggleMenu(true, currentMenu)
                    updateMenuHeading(currentMenu)
                    updateMenuSubheading(currentMenu)
                elseif currentMenu == "NeonsMenu" then
                    currentMenu = currentMenuItem:gsub("%s+", "") .. "Menu"
                    currentNeonSide = currentMenuItemID

                    toggleMenu(false, "NeonsMenu")
                    toggleMenu(true, currentMenu)
                    updateMenuHeading(currentMenu)
                    updateMenuSubheading(currentMenu)
                elseif currentMenu == "XenonsMenu" then
                    currentMenu = currentMenuItem:gsub("%s+", "") .. "Menu"

                    toggleMenu(false, "XenonsMenu")
                    toggleMenu(true, currentMenu)
                    updateMenuHeading(currentMenu)
                    updateMenuSubheading(currentMenu)
                elseif currentMenu == "WindowTintMenu" then
                    if AttemptPurchase("windowtint") then
                        ApplyWindowTint(currentMenuItemID)
                        playSoundEffect("respray", 1.0)
                        updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                        updateMenuStatus("Purchased")
                    else
                        updateMenuStatus("Not Enough Money")
                    end
                elseif currentMenu == "NeonColoursMenu" then
                    if AttemptPurchase("neoncolours") then
                        local r = vehicleNeonOptions.neonColours[currentMenuItemID].r
                        local g = vehicleNeonOptions.neonColours[currentMenuItemID].g
                        local b = vehicleNeonOptions.neonColours[currentMenuItemID].b

                        ApplyNeonColour(r, g, b)
                        playSoundEffect("respray", 1.0)
                        updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                        updateMenuStatus("Purchased")
                    else
                        updateMenuStatus("Not Enough Money")
                    end
                elseif currentMenu == "HeadlightsMenu" then
                    if AttemptPurchase("headlights") then
                        ApplyXenonLights(currentCategory, currentMenuItemID)
                        playSoundEffect("wrench", 0.4)
                        updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                        updateMenuStatus("Purchased")
                    else
                        updateMenuStatus("Not Enough Money")
                    end
                elseif currentMenu == "XenonColoursMenu" then
                    if AttemptPurchase("xenoncolours") then
                        ApplyXenonColour(currentMenuItemID)
                        playSoundEffect("respray", 1.0)
                        updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                        updateMenuStatus("Purchased")
                    else
                        updateMenuStatus("Not Enough Money")
                    end
                elseif currentMenu == "OldLiveryMenu" then
                    local plyPed = PlayerPedId()
                    local plyVeh = GetVehiclePedIsIn(plyPed, false)
                    if GetVehicleClass(plyVeh) ~= 18 then
                        if AttemptPurchase("oldlivery") then
                            ApplyOldLivery(currentMenuItemID)
                            playSoundEffect("wrench", 0.1)
                            updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                            updateMenuStatus("Purchased")
                        else
                            updateMenuStatus("Not Enough Money")   
                        end
                    end
                elseif currentMenu == "PlateIndexMenu" then
                    local plyPed = PlayerPedId()
                    local plyVeh = GetVehiclePedIsIn(plyPed, false)
                    if GetVehicleClass(plyVeh) ~= 18 then
                        if AttemptPurchase("plateindex") then
                            ApplyPlateIndex(currentMenuItemID)
                            playSoundEffect("wrench", 0.1)
                            updateItem2Text(currentMenu, currentMenuItemID, "Installed")
                            updateMenuStatus("Purchased")
                        else
                            updateMenuStatus("Not Enough Money")   
                        end
                    end
                elseif currentMenu == "VehicleExtrasMenu" then
                    ApplyExtra(currentMenuItemID)
                    playSoundEffect("wrench", 0.1)
                    updateItem2TextOnly(currentMenu, currentMenuItemID, "Toggle")
                    updateMenuStatus("Purchased")
                end
            end
        else
            if currentMenu == "VehicleExtrasMenu" then
                ApplyExtra(currentMenuItemID)
                playSoundEffect("wrench", 0.1)
                updateItem2TextOnly(currentMenu, currentMenuItemID, "Toggle")
                updateMenuStatus("Purchased")
            end
        end
    else
        updateMenuStatus("")

        if isMenuActive("modMenu") then
            toggleMenu(false, currentMenu)

            currentMenu = "mainMenu"

            if currentCategory ~= 18 then
                RestoreOriginalMod()
            end

            toggleMenu(true, currentMenu)
            updateMenuHeading(currentMenu)
            updateMenuSubheading(currentMenu)
        elseif isMenuActive("ResprayMenu") then
            toggleMenu(false, currentMenu)

            currentMenu = "ResprayTypeMenu"

            RestoreOriginalColours()

            toggleMenu(true, currentMenu)
            updateMenuHeading(currentMenu)
            updateMenuSubheading(currentMenu)
        elseif isMenuActive("WheelsMenu") then            
            if currentWheelCategory ~= 20 and currentWheelCategory ~= -1 then
                local currentWheel = GetOriginalWheel()

                updateItem2Text(currentMenu, currentWheel, "$" .. vehicleCustomisationPrices.wheels.price)

                RestoreOriginalWheels()
            end

            toggleMenu(false, currentMenu)

            currentMenu = "WheelsMenu"


            toggleMenu(true, currentMenu)
            updateMenuHeading(currentMenu)
            updateMenuSubheading(currentMenu)
        elseif isMenuActive("NeonsSideMenu") then
            toggleMenu(false, currentMenu)

            currentMenu = "NeonsMenu"

            RestoreOriginalNeonStates()

            toggleMenu(true, currentMenu)
            updateMenuHeading(currentMenu)
            updateMenuSubheading(currentMenu)
        else
            if currentMenu == "mainMenu" or currentMenu == "repairMenu" then
                ExitBennys()
            elseif currentMenu == "ResprayMenu" or currentMenu == "WindowTintMenu" or currentMenu == "WheelsMenu" or currentMenu == "NeonsMenu" or currentMenu == "XenonsMenu" or currentMenu == "OldLiveryMenu" or currentMenu == "PlateIndexMenu" or currentMenu == "VehicleExtrasMenu" then
                toggleMenu(false, currentMenu)

                if currentMenu == "WindowTintMenu" then
                    RestoreOriginalWindowTint()
                end

                local plyPed = PlayerPedId()
                local plyVeh = GetVehiclePedIsIn(plyPed, false)
                if currentMenu == "OldLiveryMenu" and GetVehicleClass(plyVeh) ~= 18 then
                    RestoreOldLivery()
                end
                if currentMenu == "PlateIndexMenu" and GetVehicleClass(plyVeh) ~= 18 then
                    RestorePlateIndex()
                end

                currentMenu = "mainMenu"

                toggleMenu(true, currentMenu)
                updateMenuHeading(currentMenu)
                updateMenuSubheading(currentMenu)
            elseif currentMenu == "ResprayTypeMenu" then
                toggleMenu(false, currentMenu)

                currentMenu = "ResprayMenu"

                toggleMenu(true, currentMenu)
                updateMenuHeading(currentMenu)
                updateMenuSubheading(currentMenu)
            elseif currentMenu == "NeonColoursMenu" then
                toggleMenu(false, currentMenu)

                currentMenu = "NeonsMenu"

                RestoreOriginalNeonColours()

                toggleMenu(true, currentMenu)
                updateMenuHeading(currentMenu)
                updateMenuSubheading(currentMenu)
            elseif currentMenu == "HeadlightsMenu" then
                toggleMenu(false, currentMenu)

                currentMenu = "XenonsMenu"

                toggleMenu(true, currentMenu)
                updateMenuHeading(currentMenu)
                updateMenuSubheading(currentMenu)
            elseif currentMenu == "XenonColoursMenu" then
                toggleMenu(false, currentMenu)

                currentMenu = "XenonsMenu"

                RestoreOriginalXenonColour()

                toggleMenu(true, currentMenu)
                updateMenuHeading(currentMenu)
                updateMenuSubheading(currentMenu)
            end
        end
    end
end

function MenuScrollFunctionality(direction)
    scrollMenuFunctionality(direction, currentMenu)
end

--#[NUI Callbacks]#--
RegisterNUICallback("selectedItem", function(data, cb)
    updateCurrentMenuItemID(tonumber(data.id), data.item, data.item2)
    cb("ok")
end)

RegisterNUICallback("updateItem2", function(data, cb)
    currentMenuItem2 = data.item

    cb("ok")
end)