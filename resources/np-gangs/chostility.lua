local curWatchingPeds = {}
local relationshipTypes = {
  "PLAYER",
  "COP",
  "MISSION2",
  "MISSION3",
  "MISSION4",
  "MISSION5",
  "MISSION6",
  "MISSION7",
  "MISSION8",
}


--- Utility generate UUID for Event
local function uuid()
  math.randomseed(GetCloudTimeAsInt())
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
      local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
      return string.format('%x', v)
  end)
end


colors = {
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
--[[
"PLAYER",
"CIVMALE",
"CIVFEMALE",
"COP",
"SECURITY_GUARD",
"PRIVATE_SECURITY",
"FIREMAN",
"GANG_1",
"GANG_2",
"GANG_9",
"GANG_10",
"AMBIENT_GANG_LOST",
"AMBIENT_GANG_MEXICAN",
"AMBIENT_GANG_FAMILY",
"AMBIENT_GANG_BALLAS", --15
"AMBIENT_GANG_MARABUNTE",
"AMBIENT_GANG_CULT",
"AMBIENT_GANG_SALVA",
"AMBIENT_GANG_WEICHENG",
"AMBIENT_GANG_HILLBILLY",
"DEALER",
"HATES_PLAYER",
"HEN",
"WILD_ANIMAL",
"SHARK",
"COUGAR",
"NO_RELATIONSHIP",
"SPECIAL",
"MISSION2",
"MISSION3",
"MISSION4",
"MISSION5",
"MISSION6",
"MISSION7",
"MISSION8",
"ARMY",
"GUARD_DOG",
"AGGRESSIVE_INVESTIGATE",
"MEDIC",
"CAT"
]]

    --[[ GTA PED Default Relationship Groups 
    RelationGroups = Enum.Map("RelationGroup", {
        AggressiveInvestigate = -347613984,
        AmbientGangBallas = -1033021910,
        AmbientGangCult = 2017343592,
        AmbientGangFamily = 1166638144,
        AmbientGangHillbilly = -1285976420,
        AmbientGangLost = -1865950624,
        AmbientGangMarabunte = 2037579709,
        AmbientGangMexican = 296331235,
        AmbientGangSalva = -1821475077,
        AmbientGangWeicheng = 1782292358,
        Army = -472287501,
        Cat = 1157867945,
        Civfemale = 1191392768,
        Civmale = 45677184,
        Cop = -1533126372,
        Cougar = -837599880,
        Dealer = -2104069826,
        Fireman = -64182425,
        Gang1 = 1126561930,
        Gang10 = 230631217,
        Gang2 = 299800060,
        Gang9 = -1916596797,
        GuardDog = 1378588234,
        HatesPlayer = -2065892691,
        Hen = -1072679431,
        Medic = -1337836896,
        Mission2 = -2143285144,
        Mission3 = 1227432503,
        Mission4 = 1531823744,
        Mission5 = 654990842,
        Mission6 = 959218238,
        Mission7 = 38769797,
        Mission8 = 348830075,
        NoRelationship = -86095805,
        Player = 1862763509,
        PrivateSecurity = -1467815081,
        SecurityGuard = -183807561,
        Shark = 580191176,
        Special = -640645303,
        WildAnimal = 2078959127,
    }),
--]]

-- make AI come aids downed people today

--0 = Companion
--1 = Respect
--2 = Like
--3 = Neutral
--4 = Dislike
--5 = Hate
--255 = Pedestrians



-- "AMBIENT_GANG_HILLBILLY" -- sandy shores + random trash {1813.9053955078,3780.8464355469,33.536880493164},
-- "AMBIENT_GANG_CULT" -- hillbillys with their dicks out {-1109.9310302734,4915.4189453125,217.24272155762},
--"AMBIENT_GANG_LOST" - All lost gang members



--"MISSION4",
--"MISSION5",
--"MISSION6",

-- "AMBIENT_GANG_FAMILY" -- family (Green clothes near grove) {-173.74082946777,-1621.7894287109,33.628547668457},
--"AMBIENT_GANG_BALLAS" - Grove Stret Gangs

-- "AMBIENT_GANG_MEXICAN" - mexican gang around {326.61358642578,-2034.1141357422,20.908306121826},
-- "AMBIENT_GANG_SALVA" || "AMBIENT_GANG_MARABUNTE" -- gang bangers in fudge lane area - east side LS {1236.2904052734,-1616.4357910156,51.829231262207},

-- "AMBIENT_GANG_WEICHENG" -- little seoul {-759.36694335938,-927.24609375,18.555536270142},

 --   SetRelationshipBetweenGroups(0, `PLAYER`,GetHashKey(group))
 --   SetRelationshipBetweenGroups(0, GetHashKey(group), `PLAYER`)
 --   SetPedRelationshipGroupHash(PlayerPedId(),`MISSION8`)
 --   SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION8`)

--mission 8 is the group we set to when we want all civilians to attack them, or gangs etc.


--"MISSION4", ---- WEST
--"MISSION5", --- CENTRAL
--"MISSION6", --- EAST


-- "AMBIENT_GANG_WEICHENG" -- little seoul {-759.36694335938,-927.24609375,18.555536270142},

-- "AMBIENT_GANG_FAMILY" -- family (Green clothes near grove) {-173.74082946777,-1621.7894287109,33.628547668457},
--"AMBIENT_GANG_BALLAS" - Grove Stret Gangs

-- "AMBIENT_GANG_MEXICAN" - mexican gang around {326.61358642578,-2034.1141357422,20.908306121826},
-- "AMBIENT_GANG_SALVA" || "AMBIENT_GANG_MARABUNTE" -- gang bangers in fudge lane area - east side LS {1236.2904052734,-1616.4357910156,51.829231262207},



 --   SetRelationshipBetweenGroups(0, `PLAYER`,GetHashKey(group))
 --   SetRelationshipBetweenGroups(0, GetHashKey(group), `PLAYER`)
 --   SetPedRelationshipGroupHash(PlayerPedId(),`MISSION8`)
 --   SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION8`)


Citizen.CreateThread(function()
  while true do
  Wait(600)
      for _, group in ipairs(relationshipTypes) do
        if group == "COP" then
          SetRelationshipBetweenGroups(3, `PLAYER`,GetHashKey(group))
          SetRelationshipBetweenGroups(3, GetHashKey(group), `PLAYER`)
          SetRelationshipBetweenGroups(0, `MISSION2`,GetHashKey(group))
          SetRelationshipBetweenGroups(0, GetHashKey(group), `MISSION2`)

        else
          SetRelationshipBetweenGroups(0, `PLAYER`,GetHashKey(group))
          SetRelationshipBetweenGroups(0, GetHashKey(group), `PLAYER`)
          SetRelationshipBetweenGroups(0, `MISSION2`,GetHashKey(group))
          SetRelationshipBetweenGroups(0, GetHashKey(group), `MISSION2`)
        end  
      SetRelationshipBetweenGroups(5, GetHashKey(group), `MISSION8`)
    end


    SetRelationshipBetweenGroups(1, `PLAYER`, `AMBIENT_GANG_WEICHENG`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_WEICHENG`, `PLAYER`)
    SetRelationshipBetweenGroups(1, `PLAYER`, `AMBIENT_GANG_FAMILY`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_FAMILY`, `PLAYER`)
    SetRelationshipBetweenGroups(1, `PLAYER`, `AMBIENT_GANG_BALLAS`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_BALLAS`, `PLAYER`)

    SetRelationshipBetweenGroups(1, `PLAYER`, `AMBIENT_GANG_SALVA`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_SALVA`, `PLAYER`)
    SetRelationshipBetweenGroups(1, `PLAYER`, `AMBIENT_GANG_MEXICAN`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_MEXICAN`, `PLAYER`)



    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_LOST`, `AMBIENT_GANG_WEICHENG`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_WEICHENG`, `AMBIENT_GANG_LOST`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_LOST`, `AMBIENT_GANG_FAMILY`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_FAMILY`, `AMBIENT_GANG_LOST`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_LOST`, `AMBIENT_GANG_BALLAS`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_BALLAS`, `AMBIENT_GANG_LOST`)

    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_LOST`, `AMBIENT_GANG_SALVA`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_SALVA`, `AMBIENT_GANG_LOST`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_LOST`, `AMBIENT_GANG_MEXICAN`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_MEXICAN`, `AMBIENT_GANG_LOST`)



--WEST SIDE
    SetRelationshipBetweenGroups(1, `MISSION4`, `AMBIENT_GANG_WEICHENG`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_WEICHENG`, `MISSION4`)

-- MEDIC / POLICE WEST SIDE
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_WEICHENG`, `MISSION2`)
    SetRelationshipBetweenGroups(1, `MISSION2`, `AMBIENT_GANG_WEICHENG`)



--CENTRAL
    SetRelationshipBetweenGroups(1, `MISSION5`, `AMBIENT_GANG_FAMILY`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_FAMILY`, `MISSION5`)
    SetRelationshipBetweenGroups(1, `MISSION5`, `AMBIENT_GANG_BALLAS`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_BALLAS`, `MISSION5`)

-- MEDIC / POLICE CENTRAL
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_BALLAS`, `MISSION2`)
    SetRelationshipBetweenGroups(1, `MISSION2`, `AMBIENT_GANG_BALLAS`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_FAMILY`, `MISSION2`)
    SetRelationshipBetweenGroups(1, `MISSION2`, `AMBIENT_GANG_FAMILY`)






--EAST SIDE
    SetRelationshipBetweenGroups(1, `MISSION6`, `AMBIENT_GANG_SALVA`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_SALVA`, `MISSION6`)
    SetRelationshipBetweenGroups(1, `MISSION6`, `AMBIENT_GANG_MEXICAN`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_MEXICAN`, `MISSION6`)

-- MEDIC / POLICE EAST SIDE
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_SALVA`, `MISSION2`)
    SetRelationshipBetweenGroups(1, `MISSION2`, `AMBIENT_GANG_SALVA`)
    SetRelationshipBetweenGroups(1, `MISSION2`, `AMBIENT_GANG_MEXICAN`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_MEXICAN`, `MISSION2`)





    SetRelationshipBetweenGroups(1, -86095805, `MISSION2`)
    SetRelationshipBetweenGroups(1, `MISSION2`, -86095805)

    SetRelationshipBetweenGroups(1,1191392768, `MISSION2`)
    SetRelationshipBetweenGroups(1, `MISSION2`,1191392768)
    
    SetRelationshipBetweenGroups(1, `MISSION2`, 45677184)
    SetRelationshipBetweenGroups(1, 45677184, `MISSION2`)




    SetRelationshipBetweenGroups(3, `PLAYER`, `MISSION7`)
    SetRelationshipBetweenGroups(3, `MISSION7`, `PLAYER`)

    SetRelationshipBetweenGroups(0, `MISSION7`, `COP`)
    SetRelationshipBetweenGroups(0, `COP`, `MISSION7`)

    SetRelationshipBetweenGroups(0, `MISSION2`, `MISSION7`)
    SetRelationshipBetweenGroups(0, `MISSION7`, `MISSION2`)

    SetRelationshipBetweenGroups(0, `MISSION7`, `MISSION7`)

    SetRelationshipBetweenGroups(3, `COP`,`PLAYER`)
    SetRelationshipBetweenGroups(3, `PLAYER`, `COP`)

    SetRelationshipBetweenGroups(0, `PLAYER`, `MISSION3`)
    SetRelationshipBetweenGroups(0, `MISSION3`,`PLAYER`)

    -- LOST MC
    SetRelationshipBetweenGroups(1, `PLAYER`, `AMBIENT_GANG_LOST`)
    SetRelationshipBetweenGroups(1, `AMBIENT_GANG_LOST`, `PLAYER`)
    SetRelationshipBetweenGroups(1,  `COP`, `AMBIENT_GANG_LOST`)
    SetRelationshipBetweenGroups(1,  `AMBIENT_GANG_LOST`, `COP`)

  end
end)

RegisterNetEvent('gangs:setDefaultRelations')
AddEventHandler("gangs:setDefaultRelations",function() 
    Citizen.Wait(1000)
    for _, group in ipairs(relationshipTypes) do
      SetRelationshipBetweenGroups(0, `PLAYER`,GetHashKey(group))
      SetRelationshipBetweenGroups(0, GetHashKey(group), `PLAYER`)
      SetRelationshipBetweenGroups(0, `MISSION2`,GetHashKey(group))
      SetRelationshipBetweenGroups(0, GetHashKey(group), `MISSION2`)
      
      SetRelationshipBetweenGroups(5, GetHashKey(group), `MISSION8`)
    end
    -- mission 7 is guards at vinewood and security guards
    SetRelationshipBetweenGroups(3, `PLAYER`, `MISSION7`)
    SetRelationshipBetweenGroups(3, `MISSION7`, `PLAYER`)

    SetRelationshipBetweenGroups(0, `MISSION7`, `COP`)
    SetRelationshipBetweenGroups(0, `COP`, `MISSION7`)

    SetRelationshipBetweenGroups(0, `MISSION2`, `MISSION7`)
     SetRelationshipBetweenGroups(0, `MISSION7`, `MISSION2`)

    SetRelationshipBetweenGroups(0, `MISSION7`, `MISSION7`)




    -- players love each other even if full hatred
    SetRelationshipBetweenGroups(0, `PLAYER`, `MISSION8`)

    -- cops from scenarios love cops and ems logged in
    SetRelationshipBetweenGroups(0, `COP`, `MISSION2`)

    -- players love cops and ems
    SetRelationshipBetweenGroups(0, `PLAYER`, `MISSION2`)

    SetRelationshipBetweenGroups(0, `PLAYER`, `MISSION3`)
    SetRelationshipBetweenGroups(0, `MISSION3`,`PLAYER`)
end)
--TriggerEvent("gangs:setHatredFull")

RegisterNetEvent('gangs:setHatredFull')
AddEventHandler("gangs:setHatredFull",function()
    local startcoords = GetEntityCoords(PlayerPedId())
    SetPedRelationshipGroupHash(PlayerPedId(),`MISSION8`)
    SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION8`)
    timer = 120000
    while timer > 0 do 
      timer = timer - 1
      curcoords = GetEntityCoords(PlayerPedId())
      if #(curcoords - startcoords) > 25.0 or IsPedFatallyInjured(PlayerPedId()) then
        timer = 0
      end
      Citizen.Wait(1)
    end
    TriggerEvent("ressurection:relationships:norevive")
    TriggerEvent("gangs:setDefaultRelations")
end)

--TriggerEvent("civilian:alertPolice",20.0,"lockpick",0)
local daytime = false
RegisterNetEvent('daytime')
AddEventHandler("daytime",function(passedTime)
    daytime = passedTime
end)
local robbing = false
RegisterNetEvent('robbing')
AddEventHandler("robbing",function(passedrobbing)
    robbing = passedrobbing
end)

imcollapsed = 0
imdead = 0
RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
  if imdead == 0 then 
    imdead = 1
  else
    beingDragged = false
    dragging = false
    imdead = 0
  end
end)

RegisterNetEvent('collapsecheck')
AddEventHandler('collapsecheck', function()
  if imcollapsed == 0 then 
    imcollapsed = 1
  else
    beingDragged = false
    dragging = false
    imcollapsed = 0
  end
end)

function LoadAnimationDictionary(animationD) -- Simple way to load animation dictionaries to save lines.
  while(not HasAnimDictLoaded(animationD)) do
    RequestAnimDict(animationD)
    Citizen.Wait(1)
  end
end

RegisterNetEvent('alert:noPedCheck')
AddEventHandler('alert:noPedCheck', function(alertType)
  if alertType == "banktruck" then
    AlertBankTruck()
  end
end)


RegisterNetEvent('civilian:alertPolice')
AddEventHandler("civilian:alertPolice",function(basedistance,alertType,objPassed,isGunshot,isSpeeder)
    if not CallChance() then
      return
    end
    local job = exports["isPed"]:isPed("myjob")
    local pd = false
    print('MY JOB ',job)
    -- if job == "police" then
    --     pd = false --must be true after editing this script
    --     print("YES IM POLICE")
    -- end

    local object = objPassed

    if not daytime then
      basedistance = basedistance * 8.2
    else
      basedistance = basedistance * 3.45
    end

    if alertType == "personRobbed" and not pd then
      AlertpersonRobbed(object)
    end

    if isGunshot == nil then 
      isGunshot = false 
    end
    if isSpeeder == nil then 
      isSpeeder = false 
    end

    local nearNPC = getRandomNpc(basedistance,isGunshot,isSpeeder)
    local dst = 0

    if nearNPC then
        dst = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(nearNPC))
    end

    if alertType == "lockpick" and math.random(100) > 88 and not pd then
      nearNPC = true
    end

    if nearNPC == nil and alertType ~= "robberyhouseMansion" and not pd then
      --nobody around for the police call.deat
      return
    else
      if alertType == "robberyhouseMansion" and not pd then 
        alertType = "robberyhouse" 
      end

      if not isSpeeder and alertType ~= "robberyhouse" then
        RequestAnimDict("amb@code_human_wander_texting@male@base")
        while not HasAnimDictLoaded("amb@code_human_wander_texting@male@base") do
          Citizen.Wait(0)
        end
        Citizen.Wait(1000)
        if GetEntityHealth(nearNPC) < GetEntityMaxHealth(nearNPC) then
          return
        end
        if not DoesEntityExist(nearNPC) then
            return
        end
        if IsPedFatallyInjured(nearNPC) then
            return
        end
        if IsPedInMeleeCombat(nearNPC) then
            return
        end
        ClearPedTasks(nearNPC)
        TaskPlayAnim(nearNPC, "cellphone@", "cellphone_call_listen_base", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
      end
    end

    local plyCoords = GetEntityCoords(PlayerPedId())
    local underground = false
    if plyCoords["z"] < -25 or aids then
        underground = true
    end        

    Citizen.Wait(math.random(5000))

    if alertType == "drugsale" and not underground and not pd then
      if dst > 12.0 and dst < 18.0 then
          DrugSale()
      end
    end

    if alertType == "druguse" and not underground and not pd then
      if dst > 12.0 and dst < 18.0 then
          DrugUse()
      end
    end

    if alertType == "carcrash" then
      CarCrash()
    end

    if alertType == "death" and not underground then
      AlertDeath()
      local roadtest2 = IsPointOnRoad(GetEntityCoords(PlayerPedId()), PlayerPedId())

      if roadtest2 then
        return
      end

      BringNpcs()
    end

    if alertType == "PDOF" and not robbing and not underground and not pd then
      if dst > 12.0 and dst < 18.0 then
        AlertPdof()
      end
    end

    if alertType == "Suspicious" then
      AlertSuspicious()
    end

    if alertType == "fight" then
      print("THIS IS ALERT FIGHT EVIDENCE")
      AlertFight()      
    end

    if (alertType == "gunshot" or alertType == "gunshotvehicle") and not pd then
      print("ALERT FOR GUNSHOT")
      AlertGunShot()
    end

    if alertType == "lockpick" then
      if dst > 12.0 and dst < 18.0 then
          AlertCheckLockpick(object)
      end
    end


    if alertType == "robberyhouse" and not pd then
      AlertCheckRobbery2()
    end
end)

function checkedLocations()
  local coords = GetEntityCoords(PlayerPedId())
  local aDist = #(vector3(coords["x"], coords["y"],coords["z"]) - vector3(2100.650390625,2927.7692871094,-61.901878356934))

  if aDist < 200.0 and coords["z"] < -55 then
    TriggerServerEvent('AlertSuspicious', "Vinewood HQ", "N/A", 2100.650390625, 2927.7692871094, -61.901878356934)
    return true
  end

  return false

end



local NoCalls = {
[1] =  { ['x'] = 115.16,['y'] = -1289.47,['z'] = 28.27,['h'] = 80.06, ['info'] = ' No Call' },
[2] =  { ['x'] = 983.53,['y'] = -96.38,['z'] = 74.85,['h'] = 147.14, ['info'] = ' No Call' },
[3] =  { ['x'] = 717.23,['y'] = -965.79,['z'] = 30.4,['h'] = 210.21, ['info'] = ' No Call' },
}
local lowCalls = {
  [1] =  { ['x'] = 361.78,['y'] = -1754.26,['z'] = 29.24,['h'] = 84.65, ['info'] = ' Low Chance' },
}

function CallChance()

  local coords = GetEntityCoords(PlayerPedId())
  local aDist = #(vector3(NoCalls[1]["x"], NoCalls[1]["y"],NoCalls[1]["z"]) - vector3(coords["x"],coords["y"],coords["z"]))
  local bDist = #(vector3(NoCalls[2]["x"], NoCalls[2]["y"],NoCalls[2]["z"]) - vector3(coords["x"],coords["y"],coords["z"]))
  local cDist = #(vector3(NoCalls[3]["x"], NoCalls[3]["y"],NoCalls[3]["z"]) - vector3(coords["x"],coords["y"],coords["z"]))
  local dDist = #(vector3(lowCalls[1]["x"], lowCalls[1]["y"],lowCalls[1]["z"]) - vector3(coords["x"],coords["y"],coords["z"]))

  if aDist < 25.0 or bDist < 25.0 or cDist < 25.0 then
    return false
  end

  if dDist < 25.0 and math.random(100) < 15 then
    return false
  end

  if math.random(50) < 25 then
    return false
  end

  return true

end


function GetStreetAndZone()
    local plyPos = GetEntityCoords(PlayerPedId(), true)
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local zone = GetLabelText(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
    local street = street1 .. ", " .. zone
    return street
end

function AlertSuspicious()

  local street1 = GetStreetAndZone()
  local plyPos = GetEntityCoords(PlayerPedId(), true)
  local gender = IsPedMale(PlayerPedId())

  if checkedLocations() then
    return
  end

  local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
  local dispatchCode = "10-37"
  local eventId = uuid()


  TriggerServerEvent('dispatch:svNotify', {
    dispatchCode = dispatchCode,
    firstStreet = street1,
    gender = gender,
    eventId = eventId,
    isImportant = false,
    priority = 1,
    origin = {
      x = plyPos.x,
      y = plyPos.y,
      z = plyPos.z
    }
  })
  Wait(math.random(5000,15000))

  if math.random(1,10) > 3 and IsPedInAnyVehicle(PlayerPedId()) and not isInVehicle then
    vehicleData = GetVehicleDescription() or {}
    plyPos = GetEntityCoords(PlayerPedId(), true)
    TriggerServerEvent('dispatch:svNotify', {
      dispatchCode = 'CarFleeing',
      relatedCode = dispatchCode,
      firstStreet = street1,
      gender = gender,
      model = vehicleData.model,
      plate = vehicleData.plate,
      firstColor = vehicleData.firstColor,
      secondColor = vehicleData.secondColor,
      heading = vehicleData.heading,
      eventId = eventId,
      isImportant = false,
      priority = 1,
      dispatchMessage = "Vehicle seen at scene",
      blipSprite = 225,
      blipColor = 0,
      origin = {
        x = plyPos.x,
        y = plyPos.y,
        z = plyPos.z
      }
    })
  end
end

function DrugSale()
  local street1 = GetStreetAndZone()
  local plyPos = GetEntityCoords(PlayerPedId(), true)
  if checkedLocations() then
    return
  end
    local gender = IsPedMale(PlayerPedId())

    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local dispatchCode = "10-34"
    local eventId = uuid()

    TriggerServerEvent('dispatch:svNotify', {
      dispatchCode = dispatchCode,
      firstStreet = street1,
      gender = gender,
      eventId = eventId,
      isImportant = false,
      priority = 1,
      origin = {
        x = plyPos.x,
        y = plyPos.y,
        z = plyPos.z
      }
    })

    Wait(math.random(5000,15000))

    if math.random(1,10) > 3 and IsPedInAnyVehicle(PlayerPedId()) and not isInVehicle then
      vehicleData = GetVehicleDescription() or {}
      plyPos = GetEntityCoords(PlayerPedId(), true)
      TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = 'CarFleeing',
        relatedCode = dispatchCode,
        firstStreet = street1,
        gender = gender,
        model = vehicleData.model,
        plate = vehicleData.plate,
        firstColor = vehicleData.firstColor,
        secondColor = vehicleData.secondColor,
        heading = vehicleData.heading,
        eventId = eventId,
        isImportant = false,
      priority = 1,
        origin = {
          x = plyPos.x,
          y = plyPos.y,
          z = plyPos.z
        }
      })
    end
end


function DrugUse()
  local street1 = GetStreetAndZone()
  local plyPos = GetEntityCoords(PlayerPedId(), true)
  if checkedLocations() then
    return
  end
    local gender = IsPedMale(PlayerPedId())

    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local dispatchCode = "10-56"
    local eventId = uuid()

    TriggerServerEvent('dispatch:svNotify', {
      dispatchCode = dispatchCode,
      firstStreet = street1,
      gender = gender,
      eventId = eventId,
      isImportant = false,
      priority = 1,
      origin = {
        x = plyPos.x,
        y = plyPos.y,
        z = plyPos.z
      }
    })

    Wait(math.random(5000,15000))

    if math.random(1,10) > 3 and IsPedInAnyVehicle(PlayerPedId()) and not isInVehicle then
      vehicleData = GetVehicleDescription() or {}
      plyPos = GetEntityCoords(PlayerPedId(), true)
      TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = 'CarFleeing',
        relatedCode = dispatchCode,
        firstStreet = street1,
        gender = gender,
        model = vehicleData.model,
        plate = vehicleData.plate,
        firstColor = vehicleData.firstColor,
        secondColor = vehicleData.secondColor,
        heading = vehicleData.heading,
        eventId = eventId,
        isImportant = false,
      priority = 1,
        origin = {
          x = plyPos.x,
          y = plyPos.y,
          z = plyPos.z
        }
      })
    end
end

function CarCrash()
  local street1 = GetStreetAndZone()
  local plyPos = GetEntityCoords(PlayerPedId(), true)
  if checkedLocations() then
    return
  end
  local gender = IsPedMale(PlayerPedId())

  local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
  local dispatchCode = "10-50"
  local eventId = uuid()

  TriggerServerEvent('dispatch:svNotify', {
    dispatchCode = dispatchCode,
    firstStreet = street1,
    gender = gender,
    eventId = eventId,
    recipientList = {
      police = "police", ambulance = "ambulance"
    },
    dispatchMessage = "Car crash",
    isImportant = false,
    priority = 1,
    blipSprite = 84,
    blipColor = 0,
    origin = {
      x = plyPos.x,
      y = plyPos.y,
      z = plyPos.z
    }
  })

  Wait(math.random(5000,15000))

  local job = exports["isPed"]:isPed("job")
  if math.random(1,10) > 3 and IsPedInAnyVehicle(PlayerPedId()) and not isInVehicle and job == "police" then
    vehicleData = GetVehicleDescription() or {}
    plyPos = GetEntityCoords(PlayerPedId(), true)
    TriggerServerEvent('dispatch:svNotify', {
      dispatchCode = 'CarFleeing',
      relatedCode = dispatchCode,
      firstStreet = street1,
      gender = gender,
      model = vehicleData.model,
      plate = vehicleData.plate,
      firstColor = vehicleData.firstColor,
      secondColor = vehicleData.secondColor,
      heading = vehicleData.heading,
      isImportant = false,
      priority = 1,
      recipientList = {
        police = "police", ambulance = "ambulance"
      },
      blipSprite = 84,
      blipColor = 0,
      eventId = eventId,
      origin = {
        x = plyPos.x,
        y = plyPos.y,
        z = plyPos.z
      }
    })
  end
end





function AlertDeath()
  local street1 = GetStreetAndZone()
  local plyPos = GetEntityCoords(PlayerPedId(), true)
  if checkedLocations() then
    return
  end
  local gender = IsPedMale(PlayerPedId())

  TriggerServerEvent('dispatch:svNotify', {
    dispatchCode = "10-47",  --injured person
    dispatchMessage = 'Injured person',
    firstStreet = street1,
    gender = gender,
    isImportant = false,
      priority = 1,
    recipientList = {
      police = "police", ambulance = "ambulance"
    },
    blipSprite = 84,
    blipColor = 0,
    origin = {
      x = plyPos.x,
      y = plyPos.y,
      z = plyPos.z
    }
  })

end

function AlertFight()
  local street1 = GetStreetAndZone()
  local gender = IsPedMale(PlayerPedId())
  local armed = IsPedArmed(PlayerPedId(), 7)
  local plyPos = GetEntityCoords(PlayerPedId(), true)
  print('ALERT FIGHTING')
  if checkedLocations() then
    return
  end

  local dispatchCode = "10-10"

  if armed then
    dispatchCode = "10-11"
    dispatchMessage = "Deadly weapon"
    blipSprite = 311
    blipColor = 40
  end

  local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
  local eventId = uuid()

  TriggerServerEvent('dispatch:svNotify', {
    dispatchCode = dispatchCode,
    firstStreet = street1,
    isImportant = false,
    priority = 1,
    gender = gender,
    eventId = eventId,
    recipientList = {
      police = "police"
    },
    blipSprite = 154,
    dispatchMessage = "Fight in progress",
    blipColor = 40,
    origin = {
      x = plyPos.x,
      y = plyPos.y,
      z = plyPos.z
    }
  })

  Wait(math.random(5000,15000))

  if math.random(1,10) > 3 and IsPedInAnyVehicle(PlayerPedId()) and not isInVehicle then
    vehicleData = GetVehicleDescription() or {}
    plyPos = GetEntityCoords(PlayerPedId(), true)
    TriggerServerEvent('dispatch:svNotify', {
      dispatchCode = 'CarFleeing',
      relatedCode = dispatchCode,
      firstStreet = street1,
      gender = gender,
      model = vehicleData.model,
      plate = vehicleData.plate,
      firstColor = vehicleData.firstColor,
      secondColor = vehicleData.secondColor,
      heading = vehicleData.heading,
      isImportant = false,
      priority = 1,
      blipSprite = 84,
      blipColor = 0,
      eventId = eventId,
      origin = {
        x = plyPos.x,
        y = plyPos.y,
        z = plyPos.z
      }
    })
  end
end

function AlertPdof()
  local street1 = GetStreetAndZone()
  local gender = IsPedMale(PlayerPedId())
  local plyPos = GetEntityCoords(PlayerPedId(), true)

  if checkedLocations() then
    return
  end

  local dispatchCode = "10-32"
  local eventId = uuid()

  local isInVehicle = IsPedInAnyVehicle(PlayerPedId())

  TriggerServerEvent('dispatch:svNotify', {
    dispatchCode = dispatchCode,
    firstStreet = street1,
    gender = gender,
    dispatchMessage = "Robbery at gun point",
    eventId = eventId,
    isImportant = false,
    priority = 1,
    blipSprite = 458,
    blipColor = 0,
    recipientList = {
      police = "police"
    },
    origin = {
      x = plyPos.x,
      y = plyPos.y,
      z = plyPos.z
    }
  })

  Wait(math.random(5000,15000))

  if math.random(1,10) > 3 and IsPedInAnyVehicle(PlayerPedId()) and not isInVehicle then
    vehicleData = GetVehicleDescription() or {}
    plyPos = GetEntityCoords(PlayerPedId(), true)
    TriggerServerEvent('dispatch:svNotify', {
      dispatchCode = 'CarFleeing',
      relatedCode = dispatchCode,
      firstStreet = street1,
      gender = gender,
      model = vehicleData.model,
      plate = vehicleData.plate,
      firstColor = vehicleData.firstColor,
      secondColor = vehicleData.secondColor,
      heading = vehicleData.heading,
      eventId = eventId,
      isImportant = false,
      priority = 1,
      recipientList = {
      police = "police"
      },
      dispatchMessage = "Robbery at gunpoint",
      blipSprite = 458,
      blipColor = 0,
      origin = {
        x = plyPos.x,
        y = plyPos.y,
        z = plyPos.z
      }
    })
  end
  -- TriggerServerEvent('PdofInProgressS1', street1, sex)
  -- ReportPreviousVehicle()
end

function AlertpersonRobbed(vehicle)
  local street1 = GetStreetAndZone()
  local gender = IsPedMale(PlayerPedId())
  local plyPos = GetEntityCoords(PlayerPedId(), true)


  if checkedLocations() then
    return
  end

  local dispatchCode = "10-31B"
  local eventId = uuid()

  TriggerServerEvent('dispatch:svNotify', {
    dispatchCode = dispatchCode,
    firstStreet = street1,
    gender = gender,
    eventId = eventId,
    isImportant = false,
    priority = 1,
    dispatchMessage = "Robbery at gun point",
    blipSprite = 458,
    blipColor = 0,
    recipientList = {
      police = "police"
    },
    origin = {
      x = plyPos.x,
      y = plyPos.y,
      z = plyPos.z
    }
  })

  Wait(math.random(5000,15000))

  if math.random(1,10) > 3 and IsPedInAnyVehicle(PlayerPedId()) then
    vehicleData = GetVehicleDescription() or {}
    plyPos = GetEntityCoords(PlayerPedId(), true)
    TriggerServerEvent('dispatch:svNotify', {
      dispatchCode = 'CarFleeing',
      relatedCode = dispatchCode,
      firstStreet = street1,
      gender = gender,
      model = vehicleData.model,
      plate = vehicleData.plate,
      firstColor = vehicleData.firstColor,
      secondColor = vehicleData.secondColor,
      heading = vehicleData.heading,
      isImportant = false,
      priority = 1,
      eventId = eventId,
      dispatchMessage = "Vehicle seen at scene",
      blipSprite = 84,
      blipColor = 0,
      recipientList = {
        police = "police"
      },
      origin = {
        x = plyPos.x,
        y = plyPos.y,
        z = plyPos.z
      }
    })
  end
end

function AlertCheckRobbery2()
  local street1 = GetStreetAndZone()
  local gender = IsPedMale(PlayerPedId()) 
  local plyPos = GetEntityCoords(PlayerPedId(), true)

  if checkedLocations() then
    return
  end
  local alertX, alertY, alertZ = table.unpack(GetEntityCoords(PlayerPedId()))
  TriggerServerEvent('phone:triggerHOAAlert', street1, alertX, alertY, alertZ)

  local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
  local dispatchCode = "10-31A"
  local eventId = uuid()

  TriggerServerEvent('dispatch:svNotify', {
    dispatchCode = dispatchCode,
    firstStreet = street1,
    gender = gender,
    eventId = eventId,
    isImportant = false,
    priority = 1,
    recipientList = {
      police = "police"
    },
    blipSprite = 458,
    blipColor = 0,
    dispatchMessage = "Robbery at gunpoint",
    origin = {
      x = plyPos.x,
      y = plyPos.y,
      z = plyPos.z
    }
  })

  Wait(math.random(5000,15000))

  if math.random(1,10) > 3 and IsPedInAnyVehicle(PlayerPedId()) and not isInVehicle then
    vehicleData = GetVehicleDescription() or {}
    plyPos = GetEntityCoords(PlayerPedId(), true)
    TriggerServerEvent('dispatch:svNotify', {
      dispatchCode = 'CarFleeing',
      relatedCode = dispatchCode,
      firstStreet = street1,
      gender = gender,
      model = vehicleData.model,
      plate = vehicleData.plate,
      firstColor = vehicleData.firstColor,
      secondColor = vehicleData.secondColor,
      heading = vehicleData.heading,
      eventId = eventId,
      isImportant = false,
      priority = 1,
      recipientList = {
      police = "police"
      },
      blipSprite = 458,
      blipColor = 0,
      dispatchMessage = "Robbery at gunpoint",
      origin = {
        x = plyPos.x,
        y = plyPos.y,
        z = plyPos.z
      }
    })
  end
end

function AlertBankTruck()
  local street1 = GetStreetAndZone()
  local gender = IsPedMale(PlayerPedId())
  local plyPos = GetEntityCoords(PlayerPedId())

  if checkedLocations() then
    return
  end

  TriggerServerEvent('phone:triggerHOAAlert', street1)

  local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
  local dispatchCode = "10-90D"
  local eventId = uuid()

  TriggerServerEvent('dispatch:svNotify', {
    dispatchCode = dispatchCode,
    firstStreet = street1,
    gender = gender,
    eventId = eventId,
    isImportant = true,
    priority = 3,
    blipSprite = 500,
    blipColor = 1,
    dispatchMessage = "Bank truck robbery in progress",
    playSound = true,
    recipientList = {
      police = "police"
    },

    origin = {
      x = plyPos.x,
      y = plyPos.y,
      z = plyPos.z
    }
  })

  Wait(math.random(5000,15000))

  if math.random(1,10) > 3 and IsPedInAnyVehicle(PlayerPedId()) and not isInVehicle then
    plyPos = GetEntityCoords(PlayerPedId())
    vehicleData = GetVehicleDescription() or {}
    TriggerServerEvent('dispatch:svNotify', {
      dispatchCode = 'CarFleeing',
      relatedCode = dispatchCode,
      firstStreet = street1,
      gender = gender,
      model = vehicleData.model,
      plate = vehicleData.plate,
      firstColor = vehicleData.firstColor,
      secondColor = vehicleData.secondColor,
      heading = vehicleData.heading,
      eventId = eventId,
      isImportant = false,
      priority = 1,
      recipientList = {
        police = "police"
      },
      blipSprite = 500,
      dispatchMessage = "Bank robbery in progress",
      playSound = true,
      blipColor = 1,
      origin = {
        x = plyPos.x,
        y = plyPos.y,
        z = plyPos.z
      }
    })
  end
end


RegisterNetEvent('powerplant:alert')
AddEventHandler('powerplant:alert', function()
  AlertPowerPlant()
  print('cunt')
end)
RegisterNetEvent('vault:alert')
AddEventHandler('vault:alert', function()
  AlertVault()
end)

function AlertPowerPlant()
  local street1 = GetStreetAndZone()
  local gender = IsPedMale(PlayerPedId())
  local plyPos = GetEntityCoords(PlayerPedId())

  if checkedLocations() then
    return
  end


  local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
  local dispatchCode = "10-90C"
  local eventId = uuid()

  TriggerServerEvent('dispatch:svNotify', {
    dispatchCode = dispatchCode,
    firstStreet = street1,
    gender = gender,
    eventId = eventId,
    isImportant = true,
    priority = 3,
    blipSprite = 500,
    blipColor = 1,
    dispatchMessage = "Power Plant Disturbance",
    playSound = true,
    recipientList = {
      police = "police"
    },

    origin = {
      x = plyPos.x,
      y = plyPos.y,
      z = plyPos.z
    }
  })
end

function AlertVault()
    local street1 = GetStreetAndZone()
    local gender = IsPedMale(PlayerPedId())
    local plyPos = GetEntityCoords(PlayerPedId())
  
    if checkedLocations() then
      return
    end
  
  
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local dispatchCode = "10-90A"
    local eventId = uuid()
  
    TriggerServerEvent('dispatch:svNotify', {
      dispatchCode = dispatchCode,
      firstStreet = street1,
      gender = gender,
      eventId = eventId,
      isImportant = true,
      priority = 3,
      blipSprite = 500,
      blipColor = 1,
      dispatchMessage = "Pacific Standard Bank Alarm Triggered",
      playSound = true,
      recipientList = {
        police = "police"
      },
  
      origin = {
        x = plyPos.x,
        y = plyPos.y,
        z = plyPos.z
      }
    })
  end

function AlertGunShot()
  Citizen.CreateThread(function() 
    local street1 = GetStreetAndZone()
    local gender = IsPedMale(PlayerPedId())
    local plyPos = GetEntityCoords(PlayerPedId())

    if checkedLocations() then
      return
    end

    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local vehicleData = GetVehicleDescription() or {}
    local initialTenCode = (not isInVehicle and '10-71A' or '10-71B')
    local initialDispatchMsg = (not isInVehicle and 'Vehicle seen at scene' or 'Gun shot from a vehicle')
    local eventId = uuid()
    Wait(math.random(30000))
    TriggerServerEvent('dispatch:svNotify', {
      dispatchCode = initialTenCode,
      firstStreet = street1,
      gender = gender,
      model = vehicleData.model,
      plate = vehicleData.plate,
      firstColor = vehicleData.firstColor,
      secondColor = vehicleData.secondColor,
      heading = vehicleData.heading,
      eventId = eventId,
      isImportant = false,
      priority = 1,
      recipientList = {
        police = "police"
      },
      blipSprite = 119,
      dispatchMessage = "Gun shots reported",
      blipColor = 1,
      origin = {
        x = plyPos.x,
        y = plyPos.y,
        z = plyPos.z
      }
    })

    Wait(math.random(5000,10000))

    if math.random(1,10) > 3 and IsPedInAnyVehicle(PlayerPedId()) and not isInVehicle then
      vehicleData = GetVehicleDescription() or {}
      plyPos = GetEntityCoords(PlayerPedId())
      TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = 'CarFleeing',
        relatedCode = initialTenCode,
        firstStreet = street1,
        gender = gender,
        model = vehicleData.model,
        plate = vehicleData.plate,
        firstColor = vehicleData.firstColor,
        secondColor = vehicleData.secondColor,
        heading = vehicleData.heading,
        eventId = eventId,
        isImportant = false,
        priority = 1,
        recipientList = {
          police = "police"
        },
        blipSprite = 225,
        dispatchMessage = initialDispatchMsg,
        blipColor = 1,
        origin = {
          x = plyPos.x,
          y = plyPos.y,
          z = plyPos.z
        }
      })
    end
  end)
end

function GetVehicleDescription()
  local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
  if not DoesEntityExist(currentVehicle) then
    return
  end

  plate = GetVehicleNumberPlateText(currentVehicle)
  make = GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle))
  color1, color2 = GetVehicleColours(currentVehicle)

  if color1 == 0 then color1 = 1 end
  if color2 == 0 then color2 = 2 end
  if color1 == -1 then color1 = 158 end
  if color2 == -1 then color2 = 158 end 

  if math.random(100) > 25 then
    plate = "Unknown"
  end

  local dir = getCardinalDirectionFromHeading()

  local vehicleData  = {
    model = make,
    plate = plate,
    firstColor = colors[color1],
    secondColor = colors[color2],
    heading = dir
  }
  return vehicleData
end

function AlertCheckLockpick(object)
    local street1 = GetStreetAndZone()
    local gender = IsPedMale(PlayerPedId())
    local targetVehicle = object
    local origin = GetEntityCoords(PlayerPedId())
    if not DoesEntityExist(targetVehicle) then
      TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = '10-60',
        dispatchMesasge = 'Car lock picking',
        firstStreet = street1,
        isImportant = false,
        priority = 1,
        blipSprite = 255,
        blipColor = 1,
        recipientList = {
          police = "police"
        },
        gender = gender,
        origin = {
          x = origin.x,
          y = origin.y,
          z = origin.z
        }
      })
      return
    end

    if checkedLocations() then
      return
    end
    
    plate = GetVehicleNumberPlateText(targetVehicle)
    make = GetDisplayNameFromVehicleModel(GetEntityModel(targetVehicle))
    color1, color2 = GetVehicleColours(targetVehicle)
    TriggerServerEvent('thiefInProgressS1', street1, gender, plate, make, color1, color2, { x = origin.x, y = origin.y, z = origin.z })
end

function getCardinalDirectionFromHeading()
    local heading = GetEntityHeading(PlayerPedId())
    if heading >= 315 or heading < 45 then
        return "North Bound"
    elseif heading >= 45 and heading < 135 then
        return "West Bound"
    elseif heading >=135 and heading < 225 then
        return "South Bound"
    elseif heading >= 225 and heading < 315 then
        return "East Bound"
    end
end


function AlertReckless()
  local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
  local plyPos = GetEntityCoords(PlayerPedId())
  plate = GetVehicleNumberPlateText(currentVehicle)
  make = GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle))
  color1, color2 = GetVehicleColours(currentVehicle)

  local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
  local street1 = GetStreetNameFromHashKey(s1)

  local zone = GetLabelText(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
  local dir = getCardinalDirectionFromHeading()
  local street1 = street1 .. ", " .. zone
  local street2 = GetStreetNameFromHashKey(s2) .. " " .. dir
  
  if s2 == 0 then
   street2 = " " .. dir
  end

  local gender = IsPedMale(PlayerPedId())

  TriggerServerEvent('AlertReckless', street1, gender, plate, make, color1, color2, street2)

end

function canPedBeUsed(ped,isGunshot,isSpeeder)

    if math.random(100) > 15 then
      return false
    end

    if ped == nil then
        return false
    end

    if isSpeeder == nil then
        isSpeeder = false
    end

    if ped == PlayerPedId() then
        return false
    end

    if GetEntityHealth(ped) < GetEntityMaxHealth(ped) then
      return false
    end

    if isSpeeder then
      if not IsPedInAnyVehicle(ped, false) then
          return false
      end
    end

    if `mp_f_deadhooker` == GetEntityModel(ped) then
      return false
    end

    local curcoords = GetEntityCoords(PlayerPedId())
    local startcoords = GetEntityCoords(ped)

    if #(curcoords - startcoords) < 10.0 then
      return false
    end    

    -- here we add areas that peds can not alert the police
    if #(curcoords - vector3( 1088.76, -3187.51, -38.99)) < 15.0 then
      return false
    end  

    if not HasEntityClearLosToEntity( GetPlayerPed( -1 ), ped , 17 ) and not isGunshot then
      return false
    end

    if not DoesEntityExist(ped) then
        return false
    end

    if IsPedAPlayer(ped) then
        return false
    end

    if IsPedFatallyInjured(ped) then
        return false
    end
    
    if IsPedArmed(ped, 7) then
        return false
    end

    if IsPedInMeleeCombat(ped) then
        return false
    end

    if IsPedShooting(ped) then
        return false
    end

    if IsPedDucking(ped) then
        return false
    end

    if IsPedBeingJacked(ped) then
        return false
    end

    if IsPedSwimming(ped) then
        return false
    end

    if IsPedJumpingOutOfVehicle(ped) or IsPedBeingJacked(ped) then
        return false
    end

    local pedType = GetPedType(ped)
    if pedType == 6 or pedType == 27 or pedType == 29 or pedType == 28 then
        return false
    end
    return true
end

function getRandomNpc(basedistance,isGunshot)

    local basedistance = basedistance
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if canPedBeUsed(ped,isGunshot) and distance < basedistance and distance > 2.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
        end
        success, ped = FindNextPed(handle)
    until not success

    EndFindPed(handle)

    return rped
end

function BringNpcs()
    for i = 1, #curWatchingPeds do
      if DoesEntityExist(curWatchingPeds[i]) then
        ClearPedTasks(curWatchingPeds[i])
        SetEntityAsNoLongerNeeded(curWatchingPeds[i])
      end
    end
    curWatchingPeds = {}
    local basedistance = 35.0
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat

        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if canPedBeUsed(ped,false) and distance < basedistance and distance > 3.0 then

          if math.random(75) > 45 and #curWatchingPeds < 5 then

            TriggerEvent("TriggerAIRunning",ped)
            curWatchingPeds[#curWatchingPeds] = ped

          end

        end

        success, ped = FindNextPed(handle)

    until not success

    EndFindPed(handle)

end

tasksIdle = {
  [1] = "CODE_HUMAN_MEDIC_KNEEL",
  [2] = "WORLD_HUMAN_STAND_MOBILE",
}

RegisterNetEvent('TriggerAIRunning')
AddEventHandler("TriggerAIRunning",function(p)
    local usingped = p

    local nm1 = math.random(6,9) / 100
    local nm2 = math.random(6,9) / 100
    nm1 = nm1 + 0.3
    nm2 = nm2 + 0.3
    if math.random(10) > 5 then
      nm1 = 0.0 - nm1
    end

    if math.random(10) > 5 then
      nm2 = 0.0 - nm2
    end

    local moveto = GetOffsetFromEntityInWorldCoords(PlayerPedId(), nm1, nm2, 0.0)
    TaskGoStraightToCoord(usingped, moveto, 2.5, -1, 0.0, 0.0)
    SetPedKeepTask(usingped, true) 

    local dist = #(moveto - GetEntityCoords(usingped))
    while dist > 3.5 and (imdead == 1 or imcollapsed == 1) do
      TaskGoStraightToCoord(usingped, moveto, 2.5, -1, 0.0, 0.0)
      dist = #(moveto - GetEntityCoords(usingped))
      Citizen.Wait(100)
    end

    ClearPedTasksImmediately(ped)
  
    TaskLookAtEntity(usingped, PlayerPedId(), 5500.0, 2048, 3)

    TaskTurnPedToFaceEntity(usingped, PlayerPedId(), 5500)

    Citizen.Wait(3000)

    if math.random(3) == 2 then
      TaskStartScenarioInPlace(usingped, tasksIdle[2], 0, 1)
    elseif math.random(2) == 1 then
      TaskStartScenarioInPlace(usingped, tasksIdle[1], 0, 1)
    else
      TaskStartScenarioInPlace(usingped, tasksIdle[2], 0, 1)
      TaskStartScenarioInPlace(usingped, tasksIdle[1], 0, 1)
    end
   
    SetPedKeepTask(usingped, true) 

    while imdead == 1 or imcollapsed == 1 do
      Citizen.Wait(1)
      if not IsPedFacingPed(usingped, PlayerPedId(), 15.0) then
          ClearPedTasksImmediately(ped)
          TaskLookAtEntity(usingped, PlayerPedId(), 5500.0, 2048, 3)
          TaskTurnPedToFaceEntity(usingped, PlayerPedId(), 5500)
          Citizen.Wait(3000)
      end
    end

    SetEntityAsNoLongerNeeded(usingped)
    ClearPedTasks(usingped)

end)
