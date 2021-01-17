local curObject = 0
local obj = {}
local curObjectName = "None"
local modifiedObjects = {}
obj.x = 0.0
obj.y = 1.0
obj.z = 0.0
local rot = true
local cam = 0
local camX = 0
local camY = 0
local camZ = 0
local objX = 0
local objY = 0
local objZ = 0
local camCrds = { ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0 }
local camball = 0
local house_id = 0
local house_model = 0
function ResetVars()
    curObjectName = "None"
    curObject = 0
    obj.x = 0.0
    obj.y = 1.0
    obj.z = 0.0
    cam = 0
end

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


function openGui()
    guiEnabled = true
    SendNUIMessage({openFurniture = true})
    GenerateObjectLists()
    SetNuiFocus(true,true)
end

function closeGui()
    guiEnabled = false
    SendNUIMessage({closeProgress = true})
    SetNuiFocus(false,false)
    FreezeEntityPosition(PlayerPedId(),false)
    ClearPedTasks(PlayerPedId())
end

RegisterNUICallback('close', function(data, cb)
    updateDatabase(house_id,house_model)
    camOff() 
    closeGui()
    cb('ok')
end)

objectCategories = {
    [1] = { ["category"] = "sofas", ["name"] = "Sofas" },
    [2] = { ["category"] = "chairs", ["name"] = "Chairs" },
    [3] = { ["category"] = "beds", ["name"] = "Beds" },
    [4] = { ["category"] = "medical", ["name"] = "Medical" },
    [5] = { ["category"] = "small", ["name"] = "Small" },
    [6] = { ["category"] = "storage", ["name"] = "Storage" },
    [7] = { ["category"] = "electronics", ["name"] = "Electronics" },
    [8] = { ["category"] = "lighting", ["name"] = "Lighting" },
    [9] = { ["category"] = "tables", ["name"] = "Tables" },
    [10] = { ["category"] = "plants", ["name"] = "Plants" },
    [11] = { ["category"] = "general", ["name"] = "General" },
    [12] = { ["category"] = "general2", ["name"] = "General 2" },
    [13] = { ["category"] = "general3", ["name"] = "General 3" },
    [14] = { ["category"] = "general4", ["name"] = "General 4" },
    [15] = { ["category"] = "kitchen", ["name"] = "kitchen" }, 
    [16] = { ["category"] = "bathroom", ["name"] = "bathroom" },     
}

--[1] = { ["object"] = "v_res_d_coffeetable", ["price"] = 50, ["name"] = "Coffee Table 1" },

function GenerateObjectLists()

    SendNUIMessage({wipeCategories = true})

    for i = 1, #objectCategories do
        SendNUIMessage({newCategory = true, category = objectCategories[i]["category"], categoryname = objectCategories[i]["name"] })
    end
    
    for i = 1, #sofas do
        SendNUIMessage({newOption = true, category = "sofas", objectvar = sofas[i]["object"], objectname = sofas[i]["name"] })
    end

    for i = 1, #beds do
        SendNUIMessage({newOption = true, category = "beds", objectvar = beds[i]["object"], objectname = beds[i]["name"] })
    end

    for i = 1, #chairs do
        SendNUIMessage({newOption = true, category = "chairs", objectvar = chairs[i]["object"], objectname = chairs[i]["name"] })
    end

    for i = 1, #general do
        SendNUIMessage({newOption = true, category = "general", objectvar = general[i]["object"], objectname = general[i]["name"] })
    end

    for i = 1, #general2 do
        SendNUIMessage({newOption = true, category = "general2", objectvar = general2[i]["object"], objectname = general2[i]["name"] })
    end

    for i = 1, #general3 do
        SendNUIMessage({newOption = true, category = "general3", objectvar = general3[i]["object"], objectname = general3[i]["name"] })
    end

    for i = 1, #general4 do
        SendNUIMessage({newOption = true, category = "general4", objectvar = general4[i]["object"], objectname = general4[i]["name"] })
    end


    for i = 1, #small do
        SendNUIMessage({newOption = true, category = "small", objectvar = small[i]["object"], objectname = small[i]["name"] })
    end

    for i = 1, #storage do
        SendNUIMessage({newOption = true, category = "storage", objectvar = storage[i]["object"], objectname = storage[i]["name"] })
    end

    for i = 1, #electronics do
        SendNUIMessage({newOption = true, category = "electronics", objectvar = electronics[i]["object"], objectname = electronics[i]["name"] })
    end

    for i = 1, #lighting do
        SendNUIMessage({newOption = true, category = "lighting", objectvar = lighting[i]["object"], objectname = lighting[i]["name"] })
    end

    for i = 1, #tables do
        SendNUIMessage({newOption = true, category = "tables", objectvar = tables[i]["object"], objectname = tables[i]["name"] })
    end

    for i = 1, #plants do
        SendNUIMessage({newOption = true, category = "plants", objectvar = plants[i]["object"], objectname = plants[i]["name"] })
    end

    for i = 1, #kitchen do
        SendNUIMessage({newOption = true, category = "kitchen", objectvar = kitchen[i]["object"], objectname = kitchen[i]["name"] })
    end

    for i = 1, #bathroom do
        SendNUIMessage({newOption = true, category = "bathroom", objectvar = bathroom[i]["object"], objectname = bathroom[i]["name"] })
    end

    for i = 1, #medical do
        --SendNUIMessage({newOption = true, category = "medical", objectvar = medical[i]["object"], objectname = medical[i]["name"] })
    end

    SendNUIMessage({ redoCSS = true })
end

function scanObjects()
    local closestDist = 999.9
    local pass = false

    if(not DoesCamExist(cam)) then
        createCam()
    end

    for i = 1, #modifiedObjects do
        if (#(GetEntityCoords(modifiedObjects[i]["object"]) - GetCamCoord(cam)) < closestDist and #(GetEntityCoords(modifiedObjects[i]["object"]) - GetCamCoord(cam)) < 20.0) then
            curObject = modifiedObjects[i]["object"]
            closestDist = #(GetEntityCoords(modifiedObjects[i]["object"]) - GetCamCoord(cam))
            pass = true
        end
    end

    if pass then
        TriggerEvent("DoLongHudText","We have found an object - entering movement mode.")
        SetNuiFocus(false,false)
        FreezeEntityPosition(PlayerPedId(),true)
    else
        TriggerEvent("DoLongHudText","No objects near.")
        SetNuiFocus(true,true)
    end

    CamFocusObject()
end    

RegisterNUICallback('scanObject', function(data, cb)
    local closestDist = 999.9
    local pass = false

    if(not DoesCamExist(cam)) then
        createCam()
    end

    for i = 1, #modifiedObjects do
        if (#(GetEntityCoords(modifiedObjects[i]["object"]) - GetCamCoord(cam)) < closestDist and #(GetEntityCoords(modifiedObjects[i]["object"]) - GetCamCoord(cam)) < 20.0) then
            curObject = modifiedObjects[i]["object"]
            closestDist = #(GetEntityCoords(modifiedObjects[i]["object"]) - GetCamCoord(cam))
            pass = true
        end
    end

    if pass then
        TriggerEvent("DoLongHudText","We have found an object - entering movement mode.")
        SetNuiFocus(false,false)
        FreezeEntityPosition(PlayerPedId(),true)
    else
        TriggerEvent("DoLongHudText","No objects near.")
        SetNuiFocus(true,true)
    end
    CamFocusObject()
    cb('ok')
end)

function SaveCurObjectToTable()
    if curObject == 0 then
        TriggerEvent("DoLongHudText","Exiting Free-Cam or object was 0!")
        return
    end
    for i = 1, #modifiedObjects do
        if curObject == modifiedObjects[i]["object"] then
            local objCoords = GetEntityCoords(curObject)
            modifiedObjects[i]["x"] = math.ceil(objCoords["x"] * 1000) /1000
            modifiedObjects[i]["y"] = math.ceil(objCoords["y"] * 1000) /1000
            modifiedObjects[i]["z"] = math.ceil(objCoords["z"] * 1000) /1000
            modifiedObjects[i]["heading"] = math.ceil(GetEntityHeading(curObject) * 1000) /1000
            modifiedObjects[i]["hash"] = GetEntityModel(curObject)
        end
    end
    updateDatabase(house_id,house_model)
    TriggerEvent("DoLongHudText","You have saved the object!")
    curObject = 0
end

RegisterNUICallback('newObject', function(data, cb)
    if curOjbect == 0 then
        return
    end
    FreezeEntityPosition(PlayerPedId(),true)
    local objCoords = GetEntityCoords(curObject)
    modifiedObjects[#modifiedObjects+1] = { ["hash"] = GetEntityModel(curObject),["object"] = curObject, ["x"] = math.ceil(objCoords["x"] * 1000) /1000, ["y"] = math.ceil(objCoords["y"] * 1000) /1000, ["z"] = math.ceil(objCoords["z"] * 1000) /1000, ["heading"] = math.ceil(GetEntityHeading(curObject) * 1000) /1000 }
    if(not DoesCamExist(cam)) then
        createCam()
    end
    rot = false
    CamFocusObject()
    local oldobjects = modifiedObjects
    RestackFurniture(oldobjects)
    SetNuiFocus(false,false)
    cb('ok')
end)

RegisterNUICallback('selectObject', function(data, cb)
    if data.selectObject == "none" then
        return
    end
    if DoesEntityExist(camball) then
        DeleteEntity(camball)
    end
    if DoesEntityExist(curObject) then
        DeleteEntity(curObject)
    end
    ResetVars()
    createNewObject(data.selectObject)
    if(not DoesCamExist(cam)) then
        createCam()
    end 
    CamFocusObject()
    DoRotation()
    cb('ok')
end)

function DoRotation()
    local defhead = GetEntityHeading(curObject)
    local reshead = GetEntityHeading(curObject)
    while rot do
        Citizen.Wait(1)
        defhead = defhead + 1.0
        if defhead > 360.0 then
            defhead = 0.0
        end
        SetEntityHeading(curObject,defhead)
    end
    SetEntityHeading(curObject,reshead)
    CamFocusObject()
end

RegisterNUICallback('FreeCam', function(data, cb)
    camOff()
    curObject = 0
    createCam()
    SetNuiFocus(false,false)

    cb('ok')
end)
local delObj = 0

RegisterNUICallback('DelSelectedObj', function(data, cb)
    if #modifiedObjects == 0 then
        return
    end
    curObject = modifiedObjects[delObj]["object"]
    table.remove(modifiedObjects,delObj)
    DeleteEntity(curObject)
    delObj = 0
    curObject = 0
    prevObj()
    TriggerEvent("DoLongHudText","Object Deleted from Database.",2)
    updateDatabase(house_id,house_model)
    cb('ok')
end)

RegisterNUICallback('DelObj', function(data, cb)
    scanObjects()
    if #modifiedObjects == 0 then
        TriggerEvent("DoLongHudText","There are no objects in your house to delete?",2)
    end
    delObj = 1
    curObject = modifiedObjects[delObj]["object"]
    CamFocusObject()
    SetNuiFocus(true,true)
    cb('ok')
end)

RegisterNUICallback('NextObj', function(data, cb)
    prevObj()
    cb('ok')    
end)

function prevObj()
    if #modifiedObjects == 0 then
        return
    end
    if #modifiedObjects < (delObj + 1) then
        delObj = 1
    else
        delObj = delObj + 1
    end
    curObject = modifiedObjects[delObj]["object"]
    CamFocusObject()
    SetNuiFocus(true,true)
end

RegisterNUICallback('PrevObj', function(data, cb)
    nextObj()
    cb('ok')    
end)

function nextObj()
    if #modifiedObjects == 0 then
        return
    end

    if delObj == 1 then
        delObj = #modifiedObjects
    else
        delObj = delObj - 1
    end
    curObject = modifiedObjects[delObj]["object"]
    CamFocusObject()
    SetNuiFocus(true,true)
end


function createNewObject(objType)
    curObjectName = objType
    local objTypeKey = GetHashKey(objType)
    RequestModel(objTypeKey)
    local count = 6000
    SetNuiFocus(false,false)
    TriggerEvent("DoLongHudText","Loading Model - please wait.",2)
    while not HasModelLoaded(objTypeKey) do
        Citizen.Wait(0)
    end
    TriggerEvent("DoLongHudText","Loaded",2)  
    SetNuiFocus(true,true)

    local crds = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
    curObject = CreateObject(objTypeKey,crds["x"],crds["y"],crds["z"],false,false,false)
    FreezeEntityPosition(curObject, true)
    SetModelAsNoLongerNeeded(objTypeKey)
end

function camOff()
    rot = false
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    DeleteObject(camball)
end

function createCam()
    camOff()
    local crds = GetOffsetFromEntityInWorldCoords(curObject, 0.0, -2.0, 0.5)

    if curObject == 0 then
        crds = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -2.0, 0.5)
    end
    
    camball = CreateObject(`prop_golf_ball`, crds, true, true, true)
    FreezeEntityPosition(camball,true)
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(cam,  true)
    RenderScriptCams(true,  false,  0,  true,  true)
    CamFocusObject()
end

function CamFocusObject()
    local crds = GetOffsetFromEntityInWorldCoords(curObject, 0.0, -2.0, 0.5)

    if curObject == 0 then
        crds = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -2.0, 0.5)
    end
    
    SetEntityCoords(camball,crds)
    SetCamCoord(cam, crds)
    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(curObject))
    
end

Citizen.CreateThread(function()
    Citizen.Wait(3000)
    
    while true do
        Citizen.Wait(1)
        if guiEnabled then
            TaskStandStill(PlayerPedId(),1.0)
            CamControls()
        else
            Citizen.Wait(1000)
        end
    end
end)


function CamControls()

    if(DoesCamExist(cam)) then



        if curObject ~= 0 then
            local d1,d2 = GetModelDimensions(GetEntityModel(curObject))
            local top = GetOffsetFromEntityInWorldCoords(curObject, 0.0,0.0,d2["z"]+0.05)
            local bot = GetOffsetFromEntityInWorldCoords(curObject, 0.0,0.0,d1["z"]-0.05)

            DrawMarker(2,top["x"],top["y"],top["z"], 0.0, 0.0, 0.0, 0, 0, 0, d1["x"] * 2, d2["y"] * 2, 0.035, 0,110,0 , 150, false, true, false, false)
            DrawMarker(2,bot["x"],bot["y"],bot["z"], 0.0, 0.0, 0.0, 0, 0, 0, d1["x"] * 2, d2["y"] * 2, -0.035, 0,110,0 , 150, false, true, false, false)

        end

        if IsControlJustReleased(1, Keys["SPACE"]) then
            rot = false
            SaveCurObjectToTable()
            SetNuiFocus(true,true)
        end

        if IsControlPressed(1, Keys["RIGHTCTRL"]) then

            if IsControlPressed(1, Keys["Q"]) then
                rot = false
                local crds = GetOffsetFromEntityInWorldCoords(curObject, 0.0, 0.0, 0.01)
                SetEntityCoords(curObject,crds)   
            end

            if IsControlPressed(1, Keys["E"]) then
                rot = false
                local crds = GetOffsetFromEntityInWorldCoords(curObject, 0.0, 0.0, -0.01)
                SetEntityCoords(curObject,crds)
            end    

            if IsControlPressed(1, Keys["W"]) then
                rot = false
                local crds = GetOffsetFromEntityInWorldCoords(curObject, 0.0, 0.01, 0.0)
                SetEntityCoords(curObject,crds)   
            end

            if IsControlPressed(1, Keys["S"]) then
                rot = false
                local crds = GetOffsetFromEntityInWorldCoords(curObject, 0.0, -0.01, 0.0)
                SetEntityCoords(curObject,crds)
            end       

            if IsControlPressed(1, Keys["D"]) then
                rot = false
                local crds = GetOffsetFromEntityInWorldCoords(curObject, 0.01, 0.0, 0.0)
                SetEntityCoords(curObject,crds)     
            end

            if IsControlPressed(1, Keys["A"]) then
                rot = false
                local crds = GetOffsetFromEntityInWorldCoords(curObject, -0.01, 0.0, 0.0)
                SetEntityCoords(curObject,crds)   
            end 
            CheckObjectRotation(curObject, 0.0)
      
        else

            if IsControlPressed(1, Keys["Q"]) then
                rot = false
                local crds = GetOffsetFromEntityInWorldCoords(camball, 0.0, 0.0, 0.1)
                SetEntityCoords(camball,crds) 
                SetCamCoord(cam, crds) 
            end

            if IsControlPressed(1, Keys["E"]) then
                rot = false
                local crds = GetOffsetFromEntityInWorldCoords(camball, 0.0, 0.0, -0.1)
                SetEntityCoords(camball,crds)
                SetCamCoord(cam, crds)
            end    

            if IsControlPressed(1, Keys["W"]) then
                rot = false
                local crds = GetOffsetFromEntityInWorldCoords(camball, 0.0, 0.1, 0.0)
                SetEntityCoords(camball,crds)
                SetCamCoord(cam, crds)  
            end

            if IsControlPressed(1, Keys["S"]) then
                rot = false
                local crds = GetOffsetFromEntityInWorldCoords(camball, 0.0, -0.1, 0.0)
                SetEntityCoords(camball,crds)
                SetCamCoord(cam, crds)  
            end       

            if IsControlPressed(1, Keys["D"]) then
                rot = false
                local crds = GetOffsetFromEntityInWorldCoords(camball, 0.1, 0.0, 0.0)
                SetEntityCoords(camball,crds)
                SetCamCoord(cam, crds)    

            end

            if IsControlPressed(1, Keys["A"]) then
                rot = false
                local crds = GetOffsetFromEntityInWorldCoords(camball, -0.1, 0.0, 0.0)
                SetEntityCoords(camball,crds)
                SetCamCoord(cam, crds)  
            end 

            CheckInputRotation(cam, 0.0)

        end

    end

end
function CheckObjectRotation()
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        SetEntityHeading(curObject,GetEntityHeading(curObject) - rightAxisX * 2) 
    end
end
function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        new_z = rotation.z
        SetEntityHeading(camball,GetEntityHeading(camball) - rightAxisX * 5)  
        new_x = rotation.x - rightAxisY * 5 -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
        SetCamRot(cam, new_x, 0.0, GetEntityHeading(camball), 2)
    end
end


function updateDatabase(house_id,house_model)
    TriggerServerEvent("UpdateFurniture",house_id,house_model,modifiedObjects)
end

RegisterNetEvent("openFurnitureConfirm")
AddEventHandler("openFurnitureConfirm", function(house_id2,house_model2,furniture)
    house_id = house_id2
    house_model = house_model2
    local oldobjects = modifiedObjects
    modifiedObjects = furniture
    if #furniture > 0 then
        RestackFurniture(oldobjects)
    end
    openGui()
end)

RegisterNetEvent("placefurniture")
AddEventHandler("placefurniture", function(furniture)
    local oldobjects = modifiedObjects
    modifiedObjects = furniture
    if furniture == nil then
        return
    end
    if #furniture > 0 then
        RestackFurniture(oldobjects)
    end  
end)


function RestackFurniture(oldobjects)
    for i = 1, #modifiedObjects do
        if oldobjects[i] ~= nil then
            SetEntityAsNoLongerNeeded(oldobjects[i]["object"])
            SetEntityCoords(oldobjects[i]["object"],0.0,0.0,-20.0)
        end
        RequestModel(modifiedObjects[i]["hash"])
        local count = 10000
        while not HasModelLoaded(modifiedObjects[i]["hash"]) and count > 0 do
            count = count - 1
            Citizen.Wait(1)
        end  
        modifiedObjects[i]["object"] = CreateObject(modifiedObjects[i]["hash"],modifiedObjects[i]["x"],modifiedObjects[i]["y"],modifiedObjects[i]["z"],false,false,false)
        FreezeEntityPosition(modifiedObjects[i]["object"],true)
        SetEntityCoords(modifiedObjects[i]["object"],modifiedObjects[i]["x"],modifiedObjects[i]["y"],modifiedObjects[i]["z"])
        SetEntityHeading(modifiedObjects[i]["object"],modifiedObjects[i]["heading"])
        curObject = modifiedObjects[i]["object"]
    end
end















