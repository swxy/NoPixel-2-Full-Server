-- Settings
local guiEnabled = false
local hasOpened = false

local endloop = false

local ped = PlayerPedId()
local playerCoords = GetEntityCoords(ped)
local inveh = (IsPedInAnyVehicle(ped, false))
Citizen.CreateThread(function()
  while true do
    inveh = (IsPedInAnyVehicle(ped, false))
    ped = PlayerPedId()
    playerCoords = GetEntityCoords(ped)  
    Wait(500)
  end
end)

local carcolors = {
--[0] = "Metallic Black",

[1] = "Metallic Graphite Black",

[2] = "Metallic Black Steel",

[3] = "Metallic Dark Silver",

[4] = "Metallic Silver",

[5] = "Metallic Blue Silver",

[6] = "Metallic Steel Gray",

[7] = "Metallic Shadow Silver",

[8] = "Metallic Stone Silver",

[9] = "Metallic Midnight Silver",

[10] = "Metallic Gun Metal",

[11] = "Metallic Anthracite Grey",

[12] = "Matte Black",

[13] = "Matte Gray",

[14] = "Matte Light Grey",

[15] = "Util Black",

[16] = "Util Black Poly",

[17] = "Util Dark silver",

[18] = "Util Silver",

[19] = "Util Gun Metal",

[20] = "Util Shadow Silver",

[21] = "Worn Black",

[22] = "Worn Graphite",

[23] = "Worn Silver Grey",

[24] = "Worn Silver",

[25] = "Worn Blue Silver",

[26] = "Worn Shadow Silver",

[27] = "Metallic Red",

[28] = "Metallic Torino Red",

[29] = "Metallic Formula Red",

[30] = "Metallic Blaze Red",

[31] = "Metallic Graceful Red",

[32] = "Metallic Garnet Red",

[33] = "Metallic Desert Red",

[34] = "Metallic Cabernet Red",

[35] = "Metallic Candy Red",

[36] = "Metallic Sunrise Orange",

[37] = "Metallic Classic Gold",

[38] = "Metallic Orange",

[39] = "Matte Red",

[40] = "Matte Dark Red",

[41] = "Matte Orange",

[42] = "Matte Yellow",

[43] = "Util Red",

[44] = "Util Bright Red",

[45] = "Util Garnet Red",

[46] = "Worn Red",

[47] = "Worn Golden Red",

[48] = "Worn Dark Red",

[49] = "Metallic Dark Green",

[50] = "Metallic Racing Green",

[51] = "Metallic Sea Green",

[52] = "Metallic Olive Green",

[53] = "Metallic Green",

[54] = "Metallic Gasoline Blue Green",

[55] = "Matte Lime Green",

[56] = "Util Dark Green",

[57] = "Util Green",

[58] = "Worn Dark Green",

[59] = "Worn Green",

[60] = "Worn Sea Wash",

[61] = "Metallic Midnight Blue",

[62] = "Metallic Dark Blue",

[63] = "Metallic Saxony Blue",

[64] = "Metallic Blue",

[65] = "Metallic Mariner Blue",

[66] = "Metallic Harbor Blue",

[67] = "Metallic Diamond Blue",

[68] = "Metallic Surf Blue",

[69] = "Metallic Nautical Blue",

[70] = "Metallic Bright Blue",

[71] = "Metallic Purple Blue",

[72] = "Metallic Spinnaker Blue",

[73] = "Metallic Ultra Blue",

[74] = "Metallic Bright Blue",

[75] = "Util Dark Blue",

[76] = "Util Midnight Blue",

[77] = "Util Blue",

[78] = "Util Sea Foam Blue",

[79] = "Uil Lightning blue",

[80] = "Util Maui Blue Poly",

[81] = "Util Bright Blue",

[82] = "Matte Dark Blue",

[83] = "Matte Blue",

[84] = "Matte Midnight Blue",

[85] = "Worn Dark blue",

[86] = "Worn Blue",

[87] = "Worn Light blue",

[88] = "Metallic Taxi Yellow",

[89] = "Metallic Race Yellow",

[90] = "Metallic Bronze",

[91] = "Metallic Yellow Bird",

[92] = "Metallic Lime",

[93] = "Metallic Champagne",

[94] = "Metallic Pueblo Beige",

[95] = "Metallic Dark Ivory",

[96] = "Metallic Choco Brown",

[97] = "Metallic Golden Brown",

[98] = "Metallic Light Brown",

[99] = "Metallic Straw Beige",

[100] = "Metallic Moss Brown",

[101] = "Metallic Biston Brown",

[102] = "Metallic Beechwood",

[103] = "Metallic Dark Beechwood",

[104] = "Metallic Choco Orange",

[105] = "Metallic Beach Sand",

[106] = "Metallic Sun Bleeched Sand",

[107] = "Metallic Cream",

[108] = "Util Brown",

[109] = "Util Medium Brown",

[110] = "Util Light Brown",

[111] = "Metallic White",

[112] = "Metallic Frost White",

[113] = "Worn Honey Beige",

[114] = "Worn Brown",

[115] = "Worn Dark Brown",

[116] = "Worn straw beige",

[117] = "Brushed Steel",

[118] = "Brushed Black steel",

[119] = "Brushed Aluminium",

[120] = "Chrome",

[121] = "Worn Off White",

[122] = "Util Off White",

[123] = "Worn Orange",

[124] = "Worn Light Orange",

[125] = "Metallic Securicor Green",

[126] = "Worn Taxi Yellow",

[127] = "police car blue",

[128] = "Matte Green",

[129] = "Matte Brown",

[130] = "Worn Orange",

[131] = "Matte White",

[132] = "Worn White",

[133] = "Worn Olive Army Green",

[134] = "Pure White",

[135] = "Hot Pink",

[136] = "Salmon pink",

[137] = "Metallic Vermillion Pink",

[138] = "Orange",

[139] = "Green",

[140] = "Blue",

[141] = "Mettalic Black Blue",

[142] = "Metallic Black Purple",

[143] = "Metallic Black Red",

[144] = "hunter green",

[145] = "Metallic Purple",

[146] = "Metaillic V Dark Blue",

[147] = "MODSHOP BLACK1",

[148] = "Matte Purple",

[149] = "Matte Dark Purple",

[150] = "Metallic Lava Red",

[151] = "Matte Forest Green",

[152] = "Matte Olive Drab",

[153] = "Matte Desert Brown",

[154] = "Matte Desert Tan",

[155] = "Matte Foilage Green",

[156] = "DEFAULT ALLOY COLOR",

[157] = "Epsilon Blue",

[158] = "Unknown",

}







local weaponTypes = {
  ["2685387236"] =  "Unarmed" ,
  ["3566412244"] =  "Melee" ,
  ["-728555052"] =  "Melee" ,
  ["416676503"] =  "Pistol",
  ["3337201093"] =  "SMG", 
  ["970310034"] =  "AssaultRifle", 
  ["-957766203"] =  "AssaultRifle", 
  ["3539449195"] =  "DigiScanner", 
  ["4257178988"] =  "FireExtinguisher",
  ["1159398588"] =  "MG", 
  ["3493187224"] =  "NightVision",
  ["431593103"] =  "Parachute", 
  ["860033945"] =  "Shotgun", 
  ["3082541095"] =  "Sniper", 
  ["690389602"] =  "Stungun", 
  ["2725924767"] =  "Heavy", 
  ["1548507267"] =  "Thrown", 
  ["1595662460"] =  "PetrolCan", 
}

local Drops = {}
local currentInformation = 0

RegisterNetEvent("evidence:bulletInformation")
AddEventHandler("evidence:bulletInformation", function(information)
  currentInformation = information
end)

local Pooling = {}
local PoolingActive = false



local PoolCounter = 0
RegisterNetEvent("PoolingEvidence")
AddEventHandler("PoolingEvidence", function()

  if PoolingActive then
    return
  else
    PoolingActive = true
    PoolCounter = 5
    while PoolCounter > 0 do
      PoolCounter = PoolCounter - 1
      Wait(1000)
    end
    PoolingActive = false
    SendPooling()
  end

end)

function SendPooling()
  TriggerServerEvent("evidence:pooled",Drops)
  Drops = {}
end

local function CameraForwardVec()
    local rot = (math.pi / 180.0) * GetGameplayCamRot(2)
    return vector3(-math.sin(rot.z) * math.abs(math.cos(rot.x)), math.cos(rot.z) * math.abs(math.cos(rot.x)), math.sin(rot.x))
end
 
function Raycast(dist)
    local start = GetGameplayCamCoord()
    local target = start + (CameraForwardVec() * dist)
 
    local ray = StartShapeTestRay(start, target, -1, PlayerPedId(), 1)
    local a, b, c, d, ent = GetShapeTestResult(ray)
    return {
        a = a,
        b= b,
        HitPosition = c,
        HitCoords = d,
        HitEntity = ent
    }
end



-- TriggerEvent("PoolingEvidence") add this to prevent mass server brokenings :) it does thing

Citizen.CreateThread(function()

  while true do
    Wait(1)     
    
    if not IsPedArmed(ped, 7) then
      Wait(1000)
    else
      if WaterTest() then
        Wait(1000)
      else
        if IsPedShooting(ped) then

          local x = math.random(20)/10
          local y = math.random(20)/10

          if (math.random(2) == 1) then
            y = (0 - y)
          end

          x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, x, y, -0.7 ))
          if inveh then
            z = z +0.7
          end
          local uniqueEvidenceId = x .. "-" .. y .. "-" .. x


          TriggerEvent("PoolingEvidence")




                local a = Raycast(150.0)




                if a.HitPosition then
                  if IsEntityAVehicle(a.HitEntity) and math.random(4) > 1 then

                      local r --[[ integer ]], g --[[ integer ]], b --[[ integer ]] =
                        GetVehicleColor(
                          a.HitEntity --[[ Vehicle ]]
                        )

                      if color1 ~= 0 then

                        Drops[uniqueEvidenceId .. "-p"] = {
                          ["x"] = a.HitPosition.x,
                          ["y"] = a.HitPosition.y,
                          ["z"] = a.HitPosition.z,
                          ["deactivated"] = false,
                          ["meta"] = { 
                            ["evidenceType"] = "vehiclefragment",
                            ["identifier"] = { ["r"] = r, ["g"] = g, ["b"] = b },
                            ["other"] = "(r:" .. r .. ", g:" .. g .. ", b:" .. b .. ") Colored Vehicle Fragment"
                          },
                        } 
                      end
                  else
                    if a.HitPosition.x ~= 0.0 and a.HitPosition.y ~= 0.0 then

                      Drops[uniqueEvidenceId .. "-p"] = {
                        ["x"] = a.HitPosition.x,
                        ["y"] = a.HitPosition.y,
                        ["z"] = a.HitPosition.z,
                        ["deactivated"] = false,
                        ["meta"] = { 
                          ["evidenceType"] = "projectile",
                          ["identifier"] = currentInformation,
                          ["other"] = GetSelectedPedWeapon(ped),
                          ["casingClass"] = GetWeapontypeGroup(GetSelectedPedWeapon(ped))
                        },
                      }    

                    end           
                  end
                end


          Drops[uniqueEvidenceId] = {
            ["x"] = x,
            ["y"] = y,
            ["z"] = z,
            ["deactivated"] = false,
            ["meta"] = { 
              ["evidenceType"] = "casing",
              ["identifier"] = currentInformation,
              ["other"] = GetSelectedPedWeapon(ped),
              ["casingClass"] = GetWeapontypeGroup(GetSelectedPedWeapon(ped))
            },
          }
          Wait(100)
        end
      end
    end
  end
end)

function WaterTest()
   local fV, sV = TestVerticalProbeAgainstAllWater(playerCoords.x, playerCoords.y, playerCoords.z, 0, 1.0)
   return fV
end




local scannedEvidence = {}
local currentWeather = "SUNNY"
local override = false

RegisterNetEvent('kWeatherSync')
AddEventHandler('kWeatherSync', function(sentInfo)
  currentWeather = sentInfo
end)



RegisterNetEvent('inside:weather')
AddEventHandler('inside:weather', function(sentInfo)
  override = sentInfo
end)


RegisterNetEvent('evidence:clear:done')
AddEventHandler('evidence:clear:done', function(DeleteIds)
    for i = 1, #DeleteIds do
        scannedEvidence[DeleteIds[i]] = nil
    end
end)
RegisterNetEvent('evidence:remove:done')
AddEventHandler('evidence:remove:done', function(Id)
    scannedEvidence[Id] = nil
end)
RegisterNetEvent('evidence:clear')
AddEventHandler('evidence:clear', function()

    local DeleteIds = {}
    for k, v in pairs(scannedEvidence) do
      local evidenceDistance = Vdist(v.x, v.y, v.z, playerCoords)
      if evidenceDistance < 10.0 then
        DeleteIds[#DeleteIds + 1] = k
      end
    end
    TriggerServerEvent("evidence:clear",DeleteIds)
end)

RegisterNetEvent('evidence:bleeding')
AddEventHandler('evidence:bleeding', function()

    if inveh then
      return
    end

    if not WaterTest() then

        local ped = PlayerPedId()
        local cid = exports["isPed"]:isPed("cid")
        local blood = "DNA-"..cid

        local uniqueEvidenceId = playerCoords.x .. "-" .. playerCoords.y .. "-" .. playerCoords.x


        if Drops == nil then
          Drops = {}
        end

        TriggerEvent("PoolingEvidence")
        local raining = false
        if override or currentWeather == "RAIN" then
          raining = true
        end
        Drops[uniqueEvidenceId] = {
          ["x"] = playerCoords.x,
          ["y"] = playerCoords.y,
          ["z"] = playerCoords.z-0.7,
          ["deactivated"] = false,
          ["meta"] = { 
            ["evidenceType"] = "blood",
            ["identifier"] = blood,
            ["other"] = "Partial Human DNA",
            ["raining"] = raining,
          },
        }
    end
end)

local triggered = false
local counter = 0
RegisterNetEvent('evidence:trigger')
AddEventHandler('evidence:trigger', function()
  if triggered then
    counter = 5
    return
  else
    counter = 5
    triggered = true
    while counter > 0 do
      Wait(1000)
      if not IsPedUsingScenario(ped, "WORLD_HUMAN_PAPARAZZI") then
         counter = counter - 1
      end
     
    end
    triggered = false
  end


end)
RegisterNetEvent('evidence:pooled')
AddEventHandler('evidence:pooled', function(PooledData)
    for k, v in pairs(PooledData) do
        scannedEvidence[k] = v           
    end
end)


function DrawText3Ds(x,y,z, text)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 245)
    SetTextOutline(true)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end


local cached = false
local scannedEvidenceCache = {}

RegisterNetEvent('CacheEvidence')
AddEventHandler('CacheEvidence', function()
      scannedEvidenceCache = {}
      cached = true
      for k, v in pairs(scannedEvidence) do
        scandst = Vdist(v.x, v.y, v.z, playerCoords)
        if scandst < 80 then
          scannedEvidenceCache[k] = v
        end
      end 
      Wait(5000)
      cached = false
end)

Citizen.CreateThread(
  function()
    while true do
      Wait(1)
      if GetHashKey("WEAPON_FLASHLIGHT") == GetSelectedPedWeapon(ped) or triggered then

        if not cached then
          TriggerEvent("CacheEvidence")         
        end


        local minScan = 70

        local closestID = false

        for k, v in pairs(scannedEvidenceCache) do
          scandst = Vdist(v.x, v.y, v.z, playerCoords)
          if scandst < 20 then
            if scandst < minScan then
              minScan = scandst
              closestID = k
            end
          end
        end

        for k, v in pairs(scannedEvidenceCache) do
          local evidenceDistance = Vdist(v.x, v.y, v.z, playerCoords)
          if (IsPlayerFreeAiming(PlayerId()) or triggered) and (evidenceDistance < 20) then
            if v["meta"]["evidenceType"] == "blood" then
              DrawMarker(28, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 202, 22, 22, 141, 0, 0, 0, 0)
              DrawText3Ds(v.x, v.y, v.z+0.5, v["meta"]["other"] .. " | " .. v["meta"]["identifier"])
            elseif v["meta"]["evidenceType"] == "casing" then
              DrawText3Ds(v.x, v.y, v.z+0.25, v["meta"]["other"] .. " | " .. v["meta"]["identifier"])
              DrawMarker(25, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 252, 255, 1, 141, 0, 0, 0, 0)
            elseif v["meta"]["evidenceType"] == "projectile" then
              DrawText3Ds(v.x, v.y, v.z+0.5, v["meta"]["other"] .. " | " .. v["meta"]["identifier"])
              DrawMarker(41, v.x, v.y, v.z+0.2, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 13, 245, 1, 231, 0, 0, 0, 0)
            elseif v["meta"]["evidenceType"] == "glass" then
              DrawText3Ds(v.x, v.y, v.z+0.5, v["meta"]["other"] .. " | " .. v["meta"]["identifier"])
              DrawMarker(23, v.x, v.y, v.z+0.2, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 13, 10, 0, 191, 0, 0, 0, 0)
            elseif v["meta"]["evidenceType"] == "vehiclefragment" then
              DrawText3Ds(v.x, v.y, v.z+0.5, v["meta"]["other"])
              DrawMarker(36, v.x, v.y, v.z+0.2, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, v["meta"]["identifier"]["r"], v["meta"]["identifier"]["g"], v["meta"]["identifier"]["b"], 255, 0, 0, 0, 0)
            else
              DrawText3Ds(v.x, v.y, v.z+0.5, v["meta"]["other"] .. " | " .. v["meta"]["identifier"])
              DrawMarker(21, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 222, 255, 51, 91, 0, 0, 0, 0)
            end
            

          end
        end
        if IsControlJustReleased(0,38) and minScan < 2.0 then
          local myjob = exports["isPed"]:isPed("myjob")
          local finished = exports["np-taskbar"]:taskBar(3000,"Picking Up Item","What?",true)
          if finished == 100 then
            if myjob ~= "police" then
              Wait(3000)
             -- TriggerServerEvent("evidence:removal",Zone,closestID)
            --  PickUpItem(Zone,scannedEvidence[closestID]["meta"]["identifier"],scannedEvidence[closestID]["meta"]["evidenceType"],scannedEvidence[closestID]["meta"]["other"],"casing")
            else
              TriggerServerEvent("evidence:removal",closestID)
              PickUpItem(scannedEvidence[closestID]["meta"]["identifier"],scannedEvidence[closestID]["meta"]["evidenceType"],scannedEvidence[closestID]["meta"]["other"],"evidence")
              Wait(3000)
            end
          end
        end
        if minScan == 70 then
          local Timer = math.ceil(minScan * 10)
          Wait(Timer)
        end
      else
        Wait(1000)
      end
    end
  end
)

function PickUpItem(id,eType,other,item)
  information = {
    ["identifier"] = id,
    ["eType"] = eType,
    ["other"] = other,
  }
  TriggerEvent("player:receiveItem",item,1,true,information)
end