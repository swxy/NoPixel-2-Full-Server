local customized = json.decode('{"colors":[12,70],"xenonColor":255,"neon":{"1":false,"2":false,"3":false,"0":false},"oldLiveries":-1,"mods":{"1":0,"2":-1,"3":-1,"4":1,"5":0,"6":-1,"7":4,"8":-1,"9":-1,"10":7,"11":2,"12":2,"13":2,"14":-1,"15":2,"16":2,"17":false,"18":1,"19":false,"20":false,"21":false,"22":1,"23":-1,"24":-1,"25":-1,"26":-1,"27":-1,"28":-1,"29":-1,"30":-1,"31":-1,"32":-1,"33":-1,"34":-1,"35":-1,"36":-1,"37":-1,"38":-1,"39":-1,"40":-1,"41":-1,"42":-1,"43":-1,"44":-1,"45":-1,"46":-1,"47":-1,"48":-1,"0":-1},"interColour":0,"lights":[255,0,255],"extras":[1,0,0,0,0,0,0,0,0,0,0,0],"platestyle":3,"extracolors":[107,70],"plateIndex":3,"smokecolor":[255,255,255],"tint":0,"wheeltype":7,"dashColour":0}')
local veh = 0
local blue = 0
local bluecoords = { ['x'] = 1059.67,['y'] = -386.55,['z'] = 67.85,['h'] = 131.56, ['info'] = ' blue' }

local drawable_names = {"face", "masks", "hair", "torsos", "legs", "bags", "shoes", "neck", "undershirts", "vest", "decals", "jackets"}
local prop_names = {"hats", "glasses", "earrings", "mouth", "lhand", "rhand", "watches", "braclets"}
local head_overlays = {"Blemishes","FacialHair","Eyebrows","Ageing","Makeup","Blush","Complexion","SunDamage","Lipstick","MolesFreckles","ChestHair","BodyBlemishes","AddBodyBlemishes"}
local face_features = {"Nose_Width","Nose_Peak_Hight","Nose_Peak_Lenght","Nose_Bone_High","Nose_Peak_Lowering","Nose_Bone_Twist","EyeBrown_High","EyeBrown_Forward","Cheeks_Bone_High","Cheeks_Bone_Width","Cheeks_Width","Eyes_Openning","Lips_Thickness","Jaw_Bone_Width","Jaw_Bone_Back_Lenght","Chimp_Bone_Lowering","Chimp_Bone_Lenght","Chimp_Bone_Width","Chimp_Hole","Neck_Thikness"}


local bluedrawables = '{"1":["masks",-1],"2":["hair",2],"3":["torsos",6],"4":["legs",9],"5":["bags",0],"6":["shoes",1],"7":["neck",0],"8":["undershirts",15],"9":["vest",0],"10":["decals",0],"11":["jackets",184],"0":["face",11]}'
local blueprops = '{"1":["glasses",0],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",139]}'
local bluedt = '[["face",0],["masks",255],["hair",2],["torsos",0],["legs",7],["bags",0],["shoes",2],["neck",0],["undershirts",0],["vest",0],["decals",0],["jackets",0]]'
local blueacc =  '[["hats",0],["glasses",0],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]]'
local bluehair =  '[3,17]'


local bluedata = {
    drawables = json.decode(bluedrawables),
    props = json.decode(blueprops),
    drawtextures = json.decode(bluedt),
    proptextures = json.decode(blueacc),
    hairColor = json.decode(bluehair),
    headBlend = json.decode('{"skinFirst":15,"skinMix":1.0,"skinThird":0,"hasParent":false,"thirdMix":0.0,"shapeMix":0.0,"skinSecond":0,"shapeFirst":0,"shapeSecond":0,"shapeThird":0}'),
    headOverlay = json.decode('[{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"Blemishes"},{"firstColour":18,"overlayValue":10,"colourType":1,"secondColour":18,"overlayOpacity":0.75,"name":"FacialHair"},{"firstColour":6,"overlayValue":1,"colourType":1,"secondColour":6,"overlayOpacity":1.0,"name":"Eyebrows"},{"firstColour":5,"overlayValue":255,"colourType":0,"secondColour":5,"overlayOpacity":1.0,"name":"Ageing"},{"firstColour":0,"overlayValue":255,"colourType":2,"secondColour":0,"overlayOpacity":1.0,"name":"Makeup"},{"firstColour":0,"overlayValue":255,"colourType":2,"secondColour":0,"overlayOpacity":1.0,"name":"Blush"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"Complexion"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"SunDamage"},{"firstColour":0,"overlayValue":255,"colourType":2,"secondColour":0,"overlayOpacity":1.0,"name":"Lipstick"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"MolesFreckles"},{"firstColour":0,"overlayValue":255,"colourType":1,"secondColour":0,"overlayOpacity":1.0,"name":"ChestHair"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"BodyBlemishes"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"AddBodyBlemishes"}]'),
    headStructure = json.decode('[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]'),
}


 --       "MP_Buis_M_Neck_000",
  --      "MP_Buis_M_Neck_001",
   --     "MP_Buis_M_Neck_002",
    --    "MP_Buis_M_Neck_003",



function penis()    

    local car = `rmodmustang`
    RequestModel(car)
    while not HasModelLoaded(car) do
        Citizen.Wait(0)
    end

    veh = CreateVehicle(car, 1056.84, -387.26, 67.86, 218.59, false, false)

    SetModelAsNoLongerNeeded(car)
    SetVehicleOnGroundProperly(veh)
    SetEntityInvincible(veh, true) 
    SetVehicleModKit(veh, 0)
    SetVehicleNumberPlateText(veh, "BLUE622")
    SetVehicleWheelType(veh, customized.wheeltype)
    SetVehicleNumberPlateTextIndex(veh, 3)

    for i = 0, 16 do
        SetVehicleMod(veh, i, customized.mods[tostring(i)])
    end

    for i = 17, 22 do
        ToggleVehicleMod(veh, i, customized.mods[tostring(i)])
    end

    for i = 23, 24 do
        local isCustom = customized.mods[tostring(i)]
        if (isCustom == nil or isCustom == "-1" or isCustom == false or isCustom == 0) then
            isSet = false
        else
            isSet = true
        end
        SetVehicleMod(veh, i, customized.mods[tostring(i)], isCustom)
    end

    for i = 23, 48 do
        SetVehicleMod(veh, i, customized.mods[tostring(i)])
    end

    for i = 0, 3 do
        SetVehicleNeonLightEnabled(veh, i, customized.neon[tostring(i)])
    end

    if customized.extras ~= nil then
        for i = 1, 12 do
            local onoff = tonumber(customized.extras[i])
            if onoff == 1 then
                SetVehicleExtra(veh, i, 0)
            else
                SetVehicleExtra(veh, i, 1)
            end
        end
    end

    if customized.oldLiveries ~= nil and customized.oldLiveries ~= 24  then
        SetVehicleLivery(veh, customized.oldLiveries)
    end

    if customized.plateIndex ~= nil and customized.plateIndex ~= 4 then
        SetVehicleNumberPlateTextIndex(veh, customized.plateIndex)
    end

    -- Xenon Colors
    SetVehicleXenonLightsColour(veh, (customized.xenonColor or -1))
    SetVehicleColours(veh, customized.colors[1], customized.colors[2])
    SetVehicleExtraColours(veh, customized.extracolors[1], customized.extracolors[2])
    SetVehicleNeonLightsColour(veh, customized.lights[1], customized.lights[2], customized.lights[3])
    SetVehicleTyreSmokeColor(veh, customized.smokecolor[1], customized.smokecolor[2], customized.smokecolor[3])
    SetVehicleWindowTint(veh, customized.tint)
    SetVehicleInteriorColour(veh, customized.dashColour)
    SetVehicleDashboardColour(veh, customized.interColour)
    SetEntityInvincible(veh,true)
    SetVehicleHandbrake(veh,true)
    FreezeEntityPosition(veh, true)
    SetEntityInvincible(veh, true)
    SetVehicleFuelLevel(veh, 0)
    SetVehicleDoorsLocked(veh, 3)
    SetVehicleLights(veh,2)
end

function balls(data)
    local hashKey = 1885233650
    RequestModel(hashKey)
    while not HasModelLoaded(hashKey) do
        RequestModel(hashKey)
        Citizen.Wait(100)
    end
    blue = CreatePed(27, hashKey, 1059.67, -386.55, 66.85, 131.56, 0, 0)
    DecorSetBool(blue, 'ScriptedPed', true)
    SetPedKeepTask(blue, false)
    TaskSetBlockingOfNonTemporaryEvents(blue, false)
    ClearPedTasks(blue)
    LoadPed(data)
    ApplyPedOverlay(blue, `mpbeach_overlays` , `MP_Bea_M_Neck_000`)
end

function LoadPed(data)
    SetClothing(data.drawables, data.props, data.drawtextures, data.proptextures)
    Citizen.Wait(500)
    
    SetPedHeadBlend(data.headBlend)
    SetHeadStructure(data.headStructure)
    SetHeadOverlayData(data.headOverlay)
    SetPedHairColor(blue, 3, 17)
    TaskStartScenarioInPlace(blue, "WORLD_HUMAN_SMOKING_POT", 0, true)
    SetEntityInvincible(blue,true)
    FreezeEntityPosition(blue,true)
    SetPedKeepTask(blue, true)
    SetPedDropsWeaponsWhenDead(blue,false)
    SetPedFleeAttributes(blue, 0, 0)
    SetPedCombatAttributes(blue, 17, 1)
    SetPedSeeingRange(blue, 0.0)
    SetPedHearingRange(blue, 0.0)
    SetPedAlertness(blue, 0.0)

    SetIgnoreLowPriorityShockingEvents(blue,true)
    SetBlockingOfNonTemporaryEvents(blue,true)

end

function SetPedHeadBlend(data)
    SetPedHeadBlendData(blue,
        tonumber(data['shapeFirst']),
        tonumber(data['shapeSecond']),
        tonumber(data['shapeThird']),
        tonumber(data['skinFirst']),
        tonumber(data['skinSecond']),
        tonumber(data['skinThird']),
        tonumber(data['shapeMix']),
        tonumber(data['skinMix']),
        tonumber(data['thirdMix']),
    false)
end

function SetHeadOverlayData(data)
    if json.encode(data) ~= "[]" then
        for i = 1, #head_overlays do
            SetPedHeadOverlay(blue,  i-1, tonumber(data[i].overlayValue),  tonumber(data[i].overlayOpacity))
            -- SetPedHeadOverlayColor(player, i-1, data[i].colourType, data[i].firstColour, data[i].secondColour)
        end

        SetPedHeadOverlayColor(blue, 0, 0, tonumber(data[1].firstColour), tonumber(data[1].secondColour))
        SetPedHeadOverlayColor(blue, 1, 1, tonumber(data[2].firstColour), tonumber(data[2].secondColour))
        SetPedHeadOverlayColor(blue, 2, 1, tonumber(data[3].firstColour), tonumber(data[3].secondColour))
        SetPedHeadOverlayColor(blue, 3, 0, tonumber(data[4].firstColour), tonumber(data[4].secondColour))
        SetPedHeadOverlayColor(blue, 4, 2, tonumber(data[5].firstColour), tonumber(data[5].secondColour))
        SetPedHeadOverlayColor(blue, 5, 2, tonumber(data[6].firstColour), tonumber(data[6].secondColour))
        SetPedHeadOverlayColor(blue, 6, 0, tonumber(data[7].firstColour), tonumber(data[7].secondColour))
        SetPedHeadOverlayColor(blue, 7, 0, tonumber(data[8].firstColour), tonumber(data[8].secondColour))
        SetPedHeadOverlayColor(blue, 8, 2, tonumber(data[9].firstColour), tonumber(data[9].secondColour))
        SetPedHeadOverlayColor(blue, 9, 0, tonumber(data[10].firstColour), tonumber(data[10].secondColour))
        SetPedHeadOverlayColor(blue, 10, 1, tonumber(data[11].firstColour), tonumber(data[11].secondColour))
        SetPedHeadOverlayColor(blue, 11, 0, tonumber(data[12].firstColour), tonumber(data[12].secondColour))
    end
end

function SetHeadStructure(data)
    for i = 1, #face_features do
        SetPedFaceFeature(blue, i-1, data[i])
    end
end

function SetClothing(drawables, props, drawTextures, propTextures)
    for i = 1, #drawable_names do
        if drawables[0] == nil then
            if drawable_names[i] == "undershirts" and drawables[tostring(i-1)][2] == -1 then
                SetPedComponentVariation(blue, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(blue, i-1, drawables[tostring(i-1)][2], drawTextures[i][2], 2)
            end
        else
            if drawable_names[i] == "undershirts" and drawables[i-1][2] == -1 then
                SetPedComponentVariation(blue, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(blue, i-1, drawables[i-1][2], drawTextures[i][2], 2)
            end
        end
    end

    for i = 1, #prop_names do
        local propZ = (drawables[0] == nil and props[tostring(i-1)][2] or props[i-1][2])
        ClearPedProp(blue, i-1)
        SetPedPropIndex(
            blue,
            i-1,
            propZ,
            propTextures[i][2], true)
    end
end


function SetSkin(model, setDefault)
    -- TODO: If not isCop and model not in copModellist, do below.
    -- Model is a hash, GetHashKey(modelName)
    
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while (not HasModelLoaded(model)) do
            Citizen.Wait(0)
        end
        SetPlayerModel(blue, model)
        SetModelAsNoLongerNeeded(model)
        FreezePedCameraRotation(blue, true)
        if setDefault and model ~= nil and not isCustomSkin(model) then
            if (model ~= `mp_f_freemode_01` and model ~= `mp_m_freemode_01`) then
                SetPedRandomComponentVariation(blue, true)
            else
                SetPedHeadBlendData(blue, 0, 0, 0, 15, 0, 0, 0, 1.0, 0, false)
                SetPedComponentVariation(blue, 11, 0, 11, 0)
                SetPedComponentVariation(blue, 8, 0, 1, 0)
                SetPedComponentVariation(blue, 6, 1, 2, 0)
                SetPedHeadOverlayColor(blue, 1, 1, 0, 0)
                SetPedHeadOverlayColor(blue, 2, 1, 0, 0)
                SetPedHeadOverlayColor(blue, 4, 2, 0, 0)
                SetPedHeadOverlayColor(blue, 5, 2, 0, 0)
                SetPedHeadOverlayColor(blue, 8, 2, 0, 0)
                SetPedHeadOverlayColor(blue, 10, 1, 0, 0)
                SetPedHeadOverlay(blue, 1, 0, 0.0)
                SetPedHairColor(blue, 1, 1)
            end
        end
    end

end

local memorialCoords =  vector3(1066.84, -387.26, 66.86)

local spawned = false

Citizen.CreateThread(function ()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        if not spawned and #(memorialCoords - playerCoords) <= 200.0 then
            penis()
            balls(bluedata)
            spawned = true
        elseif spawned and #(memorialCoords - playerCoords) > 200.0 then
            DeleteEntity(veh)
            DeleteEntity(blue)
            spawned = false
        end

        if spawned and not IsPedActiveInScenario(blue) then
            TaskStartScenarioInPlace(blue, "WORLD_HUMAN_SMOKING_POT", 0, true)
        end

        Citizen.Wait(3000)
    end
end)

AddEventHandler('onResourceStopped', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        DeleteEntity(veh)
        DeleteEntity(blue)
        spawned = false
    end
end)