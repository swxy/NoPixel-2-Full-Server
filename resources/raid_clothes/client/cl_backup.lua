local face_features = { "Nose_Width", "Nose_Peak_Hight", "Nose_Peak_Lenght", "Nose_Bone_High", "Nose_Peak_Lowering", "Nose_Bone_Twist", "EyeBrown_High", "EyeBrown_Forward", "Cheeks_Bone_High", "Cheeks_Bone_Width", "Cheeks_Width", "Eyes_Openning", "Lips_Thickness", "Jaw_Bone_Width", "Jaw_Bone_Back_Lenght", "Chimp_Bone_Lowering", "Chimp_Bone_Lenght", "Chimp_Bone_Width", "Chimp_Hole", "Neck_Thikness" }

function GetCurrentPedFace()
    return {
        face = {
            headBlend = GetPedHeadBlendData(),
            headOverlay = GetHeadOverlayData(),
            headStructure = GetHeadStructure(),
            hairColor = GetPedHair(),

        },
    }
end

function LoadPlayerFace(data)
    if data.headBlend then
        SetPlayerHeadBlend(data.headBlend)
    end

    if data.headStructure then
        SetPlayerHeadStructure(data.headStructure)
    end

    if data.headOverlay then
        SetHeadOverlayData(data.headOverlay)
    end

    if data.hairColor then
        SetPedHairColor(player,table.unpack(data.hairColor))
    end

    RefreshUI()
end

function SetPlayerHeadBlend(data)
    SetPedHeadBlendData(player,
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

function SetPlayerHeadStructure(data)
    for i = 1, #face_features do
        SetPedFaceFeature(player, i - 1, data[i])
    end
end



RegisterNUICallback('getPlayerFace', function(data, cb)
    SendNUIMessage({
        type = "playerFaceData",
        backup = json.encode(GetCurrentPedFace()),
    })
    cb('ok')
end)

RegisterNUICallback('setPlayerFace', function(data, cb)
    player = GetPlayerPed(-1)
    LoadPlayerFace(data.face)

    cb('ok')
end)

