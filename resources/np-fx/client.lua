local Mario = {
  cols = {
    [16] =  {r=55,  g=55,   b=55},
    [18] =  {r=55,  g=55,   b=135},
    [24] =  {r=55,  g=95,   b=135},
    [52] =  {r=95,  g=55,   b=55},
    [67] =  {r=95,  g=135,  b=175},
    [88] =  {r=135, g=55,   b=55},
    [95] =  {r=135, g=95,   b=95},
    [124] = {r=175, g=55,   b=55},
    [133] = {r=175, g=95,   b=175},
    [173] = {r=215, g=135,  b=95},
    [203] = {r=255, g=95,   b=95},
    [210] = {r=255, g=135,  b=135},
    [216] = {r=255, g=175,  b=135},
    [222] = {r=255, g=215,  b=135},
    [231] = {r=255, g=255,  b=255},
  },
  bits = {
    {
      133,133,133,133,88,88,88,88,88,88,133,133,133,133,133,133,
      133,133,133,88,124,222,222,124,124,124,88,133,133,133,133,133,
      133,133,133,88,124,231,231,203,203,203,124,88,133,133,133,133,
      133,133,88,88,88,88,88,88,88,203,203,124,88,88,133,133,
      133,88,124,203,203,203,203,124,124,88,203,203,124,124,88,133,
      133,88,88,88,88,88,88,88,88,88,124,203,203,124,88,133,
      133,133,133,95,231,231,210,231,231,210,88,88,88,88,88,133,
      133,133,133,95,231,67,216,67,231,210,210,52,52,95,133,133,
      133,133,133,95,231,16,216,16,231,216,210,52,52,216,95,133,
      133,133,95,216,216,216,216,216,216,216,52,52,52,216,95,133,
      133,133,16,210,216,216,210,210,16,216,216,52,210,95,133,133,
      133,16,16,16,210,210,16,16,16,16,216,210,210,52,52,133,
      133,133,133,16,16,16,16,16,216,216,210,210,52,52,133,133,
      133,133,133,133,95,210,210,210,210,210,210,95,133,133,133,133,
      133,133,95,95,24,18,88,88,88,18,18,88,88,88,133,133,
      133,95,231,24,18,124,124,124,18,24,203,203,203,124,88,133,
      95,231,222,18,124,203,203,18,24,124,95,95,95,203,124,88,
      95,222,222,18,124,124,124,18,24,95,231,231,231,95,124,88,
      133,95,18,24,18,18,18,24,95,231,231,231,231,222,95,88,
      133,133,18,222,67,67,222,222,95,231,231,231,222,222,95,133,
      133,52,52,222,67,67,222,222,67,95,222,222,222,95,133,133,
      52,173,173,52,24,67,67,67,67,24,95,95,95,52,133,133,
      52,95,95,173,52,67,24,24,67,67,24,24,18,95,52,133,
      52,52,95,95,52,24,24,18,24,67,67,67,18,95,52,52,
      52,52,95,95,52,24,18,18,18,24,24,67,18,95,95,52,
      133,52,52,95,52,18,133,133,133,18,18,24,18,173,95,52,
      133,52,52,52,133,133,133,133,133,133,133,18,18,173,95,52,
      133,133,133,133,133,133,133,133,133,133,133,133,133,52,52,133
    },
    {
      133,133,133,133,88,88,88,88,88,88,133,133,133,133,133,133,
      133,133,133,88,124,222,222,124,124,124,88,133,133,133,133,133,
      133,133,133,88,124,231,231,203,203,203,124,88,133,133,133,133,
      133,133,88,88,88,88,88,88,88,203,203,124,88,88,133,133,
      133,88,124,203,203,203,203,124,124,88,203,203,124,124,88,133,
      133,88,88,88,88,88,88,88,88,88,124,203,203,124,88,133,
      133,133,133,95,231,231,210,231,231,210,88,88,88,88,88,133,
      133,133,133,95,231,67,216,67,231,210,210,52,52,95,133,133,
      133,133,133,95,231,16,216,16,231,216,210,52,52,216,95,133,
      133,133,95,216,216,216,216,216,216,216,52,52,52,216,95,133,
      133,133,16,210,216,216,210,210,16,216,216,52,210,95,133,133,
      133,16,16,16,210,210,16,16,16,16,216,210,210,52,52,133,
      133,133,133,16,16,16,16,16,216,216,210,210,52,52,133,133,
      133,133,133,133,95,210,210,210,210,210,210,95,133,133,133,133,
      133,133,133,133,18,88,88,88,18,18,88,88,88,133,133,133,
      133,133,95,18,124,124,124,18,95,95,95,203,203,88,133,133,
      133,95,231,18,124,203,203,95,231,231,231,95,203,203,88,133,
      133,95,222,18,124,124,95,231,231,231,231,222,95,124,88,133,
      133,95,18,24,18,18,95,231,231,231,222,222,95,124,88,133,
      133,133,18,222,67,67,222,95,222,222,222,95,88,88,133,133,
      133,133,18,222,67,67,222,222,95,95,95,24,24,18,133,133,
      133,18,24,24,67,67,24,24,67,67,24,24,18,133,133,133,
      133,52,52,24,24,24,24,18,24,67,67,24,18,52,133,133,
      52,173,173,52,24,24,24,18,24,24,24,24,52,95,52,133,
      52,95,95,173,52,24,18,133,18,24,24,24,52,95,52,133,
      133,52,95,95,95,52,133,133,133,52,52,52,173,95,52,133,
      133,133,52,95,95,52,133,133,52,173,173,95,95,52,133,133,
      133,133,133,52,52,52,133,133,52,52,52,52,52,133,133,133
    },
    {
      133,133,133,133,88,88,88,88,88,88,133,133,133,133,133,133,
      133,133,133,88,124,222,222,124,124,124,88,133,133,133,133,133,
      133,133,133,88,124,231,231,203,203,203,124,88,133,133,133,133,
      133,133,88,88,88,88,88,88,88,124,203,124,88,88,133,133,
      133,88,124,203,203,203,203,124,124,88,203,203,124,124,88,133,
      133,88,88,88,88,88,88,88,88,88,124,203,203,124,88,133,
      133,133,133,95,231,231,210,231,231,210,88,88,88,88,88,133,
      133,133,133,95,231,67,216,67,231,210,210,52,52,95,133,133,
      133,133,133,95,231,16,216,16,231,216,210,52,52,210,95,133,
      133,133,95,216,216,216,216,216,216,216,52,52,52,210,95,133,
      133,133,16,210,216,216,210,210,16,216,216,52,210,95,133,133,
      133,16,16,16,210,210,16,16,16,16,216,210,210,52,52,133,
      133,133,133,16,16,16,16,16,216,216,210,210,52,52,133,133,
      133,133,133,133,95,210,210,210,210,210,210,95,133,133,133,133,
      133,133,133,133,18,88,95,95,95,88,88,88,88,133,133,133,
      133,133,133,18,88,95,231,231,231,95,203,203,124,88,133,133,
      133,133,133,18,95,231,231,231,231,222,95,203,203,88,133,133,
      133,133,18,88,95,231,231,231,222,222,95,203,124,88,133,133,
      133,133,18,18,18,95,222,222,222,95,124,124,124,88,133,133,
      133,133,18,222,67,222,95,95,95,88,88,88,88,18,133,133,
      133,133,18,222,67,222,222,67,24,24,24,24,24,18,133,133,
      133,133,133,18,67,67,67,67,67,24,24,24,18,133,133,133,
      133,133,133,18,24,18,67,67,67,24,24,24,18,133,133,133,
      133,133,133,133,18,24,18,67,24,24,24,18,133,133,133,133,
      133,133,133,133,18,18,18,18,18,18,18,18,133,133,133,133,
      133,133,133,133,52,95,52,173,173,95,95,52,133,133,133,133,
      133,133,133,52,95,52,173,173,95,95,95,52,133,133,133,133,
      133,133,133,52,52,52,52,52,52,52,52,52,133,133,133,133
    },
  },
}

local Cubes = {}

local LastPedInteraction = 0
local LastPedTurn
local MarioInit
local PedSpawned
local EvilPed

local MarioState = 1
local MarioTimer = 0
local MarioLength = 15
local MarioAlpha = 0
local MarioAdder = 1
local MarioZOff = -20.0
local MarioZAdd = 0.01
local firstTick = false

local drunkFactor = 0.0
local origAnimClipset = nil
local isDrunk = false

-- Random Events when drunk
local nextStumble = 0
local nextRandomControl = 0
local nextBlackout = 0
local nextPuke = 0

local currentLevel = 0
local newDrunkLevel = true

local enableDrunkCamera = true

local isHigh = false
local isBadLSD = false
local isAbsinthe = false

local animals = {
  `a_c_rabbit_01`,
  `a_c_pig`,
  `a_c_shepherd`,
  `a_c_mtlion`,
  `a_c_coyote`,
  `a_c_boar`
}

local randomDrivingActions = {
  7,
  8,
  10,
  11,
  32
}

FXAcid = function(time)
  Citizen.CreateThread(function()
    AnimpostfxPlay("DMT_flight", time * 1000, 1)
    -- AnimpostfxPlay("DrugsMichaelAliensFight", time, 1)
    -- SendNUIMessage({type = "playMusic"})
    -- for i=1,15 do
    --   Wait(200)
    --   createAnimal(animals[math.random(1, #animals)])
    -- end
    InitCubes()
    isHigh = true
    local step = 0
    local timer = GetCloudTimeAsInt() + time
    local ped = PlayerPedId()
    local lastPos = GetEntityCoords(ped)
    while GetCloudTimeAsInt() < timer do
      if not PedSpawned and not firstTick and (isBadLSD or (math.random() > 0.85)) then
        PedSpawned = true
        Citizen.CreateThread(InitPed)
      end
      firstTick = true
      --DrawToons()
      DrawCubes()
      Wait(0)
    end
    ClearTimecycleModifier()
    if drunkFactor <= 0.0 then
      ShakeGameplayCam('DRUNK_SHAKE', 0.0)
      SetPedMotionBlur(PlayerPedId(), false)
    end
    SetEntityAsMissionEntity(EvilPed,true,true)
    DeleteEntity(EvilPed)
    AnimpostfxStop("DMT_flight")
    AnimpostfxPlay("DrugsDrivingOut", 3000, 0)
    Wait(3000)
    AnimpostfxStop("DrugsDrivingOut")
    RemoveRelationshipGroup(`SPECIAL`)
    isHigh = false

    Cubes = {}

    LastPedInteraction = 0
    LastPedTurn = nil
    MarioInit = nil
    PedSpawned = nil
    EvilPed = nil
    isBadLSD = false
    MarioState = 1
    MarioTimer = 0
    MarioLength = 15
    MarioAlpha = 0
    MarioAdder = 1
    MarioZOff = -20.0
    MarioZAdd = 0.01
  end)
end

FXAlcohol = function(time, pAlcoholStrength)
  Citizen.CreateThread(function()
    drunkFactor = drunkFactor + pAlcoholStrength
    if not HasAnimSetLoaded("move_m@drunk@slightlydrunk") then
      RequestAnimSet("move_m@drunk@slightlydrunk")
      while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
        Citizen.Wait(0)
      end
    end
    if not HasAnimSetLoaded("move_m@drunk@moderatedrunk") then
      RequestAnimSet("move_m@drunk@moderatedrunk")
      while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
        Citizen.Wait(0)
      end
    end
    if not HasAnimSetLoaded("move_m@drunk@verydrunk") then
      RequestAnimSet("move_m@drunk@verydrunk")
      while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
        Citizen.Wait(0)
      end
    end
    isDrunk = true
    TriggerEvent("client:blockShake",true)
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedIsDrunk(PlayerPedId(), true)
    SetPedConfigFlag(PlayerPedId(), 100, true)
  end)
end

FXWeed = function(time)
  Citizen.CreateThread(function()
    --AnimpostfxPlay("DrugsMichaelAliensFight", time * 1000, 1)
    SetTimecycleModifier("glasses_green")
    SetTimecycleModifierStrength(1.4)
    SetExtraTimecycleModifier("drug_wobbly")
    SetExtraTimecycleModifierStrength(1.2)
    SetPedMotionBlur(PlayerPedId(), true)
    isHigh = true
    local timer = GetCloudTimeAsInt() + time
    while GetCloudTimeAsInt() < timer do
      Wait(0)
    end
    ClearTimecycleModifier()
    ClearExtraTimecycleModifier()
    if drunkFactor <= 0.0 then
      ShakeGameplayCam('DRUNK_SHAKE', 0.0)
      SetPedMotionBlur(PlayerPedId(), false)
    end
    SetPedMotionBlur(PlayerPedId(), false)
    -- AnimpostfxStop("DrugsMichaelAliensFight")
    AnimpostfxPlay("DrugsDrivingOut", 3000, 0)
    Wait(3000)
    AnimpostfxStop("DrugsDrivingOut")
    isHigh = false
  end)
end

FXCocaine = function(time)
  Citizen.CreateThread(function()
    StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
    local timer = GetCloudTimeAsInt() + time
    while GetCloudTimeAsInt() < timer do
      Wait(0)
    end
    StopScreenEffect("DrugsMichaelAliensFight")
  end)
end

FXCrack = function(time)
  Citizen.CreateThread(function()
    StartScreenEffect("DrugsTrevorClownsFight", 3.0, 0)
    local timer = GetCloudTimeAsInt() + time
    while GetCloudTimeAsInt() < timer do
      Wait(0)
    end
    StopScreenEffect("DrugsTrevorClownsFight")
  end)
end

FXAbsinthe = function(time, pAlcoholStrength)
  Citizen.CreateThread(function()
    drunkFactor = drunkFactor + pAlcoholStrength
    if not HasAnimSetLoaded("move_m@drunk@slightlydrunk") then
      RequestAnimSet("move_m@drunk@slightlydrunk")
      while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
        Citizen.Wait(0)
      end
    end
    if not HasAnimSetLoaded("move_m@drunk@moderatedrunk") then
      RequestAnimSet("move_m@drunk@moderatedrunk")
      while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
        Citizen.Wait(0)
      end
    end
    if not HasAnimSetLoaded("move_m@drunk@verydrunk") then
      RequestAnimSet("move_m@drunk@verydrunk")
      while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
        Citizen.Wait(0)
      end
    end
    isDrunk = true
    TriggerEvent("client:blockShake",true)
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedIsDrunk(PlayerPedId(), true)
    SetPedConfigFlag(PlayerPedId(), 100, true)
  end)
end

InitPed = function()
  local plyPed = PlayerPedId()
  local pos = GetEntityCoords(plyPed)
  SetPedRelationshipGroupDefaultHash(plyPed,`SPECIAL`)
  SetPedRelationshipGroupHash(plyPed,`SPECIAL`)
  local randomAlt     = math.random(0,359)
  local randomDist    = math.random(50,80)
  local spawnPos      = pos + PointOnSphere(0.0,randomAlt,randomDist)
  while World3dToScreen2d(spawnPos.x,spawnPos.y,spawnPos.z) and not IsPointOnRoad(spawnPos.x,spawnPos.y,spawnPos.z) do
    randomAlt   = math.random(0,359)
    randomDist  = math.random(50,80)
    spawnPos    = GetEntityCoords(PlayerPedId()) + PointOnSphere(0.0,randomAlt,randomSphere)
    Citizen.Wait(0)
  end
  local hashKey = `s_m_y_clown_01`
	local pedType = GetPedType(hashKey)
  RequestModel(hashKey)
  while not HasModelLoaded(hashKey) do
      RequestModel(hashKey)
      Citizen.Wait(100)
  end

  EvilPed = CreatePed(pedType, hashKey, spawnPos, GetEntityHeading(plyPed), false, false) --ClonePed(plyPed, GetEntityHeading(plyPed), false, false)
  SetPedRelationshipGroupDefaultHash(EvilPed,`SPECIAL`)
  SetPedRelationshipGroupHash(EvilPed,`SPECIAL`)
  SetEntityCanBeDamagedByRelationshipGroup(PlayerPedId(), false, `SPECIAL`)
  SetPedDropsWeaponsWhenDead(EvilPed, false)
  DecorSetBool(EvilPed, 'ScriptedPed', true)
  Wait(500)
  if isBadLSD then
    local weapon = GetHashKey("weapon_battleaxe")
    GiveWeaponToPed(EvilPed, weapon, 80, false, true)
    SetCurrentPedWeapon(EvilPed, weapon, 1)
    SendNUIMessage({
      transactionType = 'playSound',
      transactionFile = "clown",
      transactionVolume = 0.45
    })
  end
  SetEntityCoordsNoOffset(EvilPed, spawnPos.x,spawnPos.y,spawnPos.z + 1.0)
  SetPedComponentVariation(EvilPed, 1, 60, 0, 0, 0)
  SetEntityInvincible(EvilPed,true)
  SetBlockingOfNonTemporaryEvents(EvilPed,true)
  SetModelAsNoLongerNeeded(hashKey)
  Wait(100)
  Citizen.CreateThread(TrackSpotlight)
  Wait(100)
  Citizen.CreateThread(TrackEnt)
end

TrackEnt = function()
  while true do
    local dist = GetVecDist(GetEntityCoords(PlayerPedId()), GetEntityCoords(EvilPed))
    if dist > 5.0 then
      TaskGoToEntity(EvilPed, PlayerPedId(), -1, 4.0, 100.0, 1073741824, 0)
      Wait(1000)
    else
      if not IsTaskMoveNetworkActive(EvilPed) then
        RequestAnimDict("anim@mp_point")
        while not HasAnimDictLoaded("anim@mp_point") do Wait(0); end
        TaskMoveNetworkByName(EvilPed, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
        SetPedCurrentWeaponVisible(EvilPed, 1, 1, 1, 1)
        SetPedConfigFlag(EvilPed, 36, 1)
      end

      
      TaskCombatPed(EvilPed, PlayerPedId(), 0, 16)

      if not LastPedTurn or (GetCloudTimeAsInt() - LastPedTurn) > 1000 then
        LastPedTurn = GetCloudTimeAsInt()
        TaskTurnPedToFaceEntity(EvilPed, PlayerPedId(), -1)
      end

      SetTaskMoveNetworkSignalFloat (EvilPed, "Pitch",          0.4)
      SetTaskMoveNetworkSignalFloat (EvilPed, "Heading",        0.5)
      SetTaskMoveNetworkSignalBool  (EvilPed, "isBlocked",      false)
      SetTaskMoveNetworkSignalBool  (EvilPed, "isFirstPerson",  false)

      if IsPedRagdoll(EvilPed) then
        while IsPedRagdoll(EvilPed) do Wait(0); end
        ClearPedTasksImmediately(EvilPed)
        Wait(10)
      end
      Wait(0)
    end
    Wait(0)
  end
end

TrackSpotlight = function()
  while true do
    local evilPedCoords = GetEntityCoords(EvilPed)
    DrawSpotLight(evilPedCoords.x, evilPedCoords.y, evilPedCoords.z + 15.0, 0.0, 0.0, -25.0, 255, 255, 255, 25.0, 50.0, 1.0, 3.0, 25.0)
    Wait(0)
  end
end

InitCubes = function()
  Citizen.CreateThread(function()
    for i=1,10,1 do
      local r = math.random(5,255)
      local g = math.random(5,255)
      local b = math.random(5,255)
      local a = math.random(45,75)

      local x = math.random(1,180)
      local y = math.random(1,359)
      local z = math.random(15,35)

      Cubes[i] = {pos=PointOnSphere(x,y,z),points={x=x,y=y,z=z},col={r=r, g=g, b=b, a=a}}
    end

    SetTimecycleModifierStrength(0.0)
    SetTimecycleModifier("BikerFilter")
    SetPedMotionBlur(PlayerPedId(), true)

    local counter = 4000
    local tick = 0
    while tick < counter do
      tick = tick + 1
      local plyPos = GetEntityCoords(PlayerPedId())
      local adder = 0.1 * (tick/60)
      SetTimecycleModifierStrength(math.min(0.1 * (tick/(counter/60)),1.5))
      if drunkFactor <= 0.0 and enableDrunkCamera then
        ShakeGameplayCam('DRUNK_SHAKE', math.min(0.1 * (tick/(counter/60)),1.5))
      end
      for k,v in pairs(Cubes) do
        local pos = plyPos + v.pos + vector3(20, 20, 20)
        DrawBox(pos.x+adder,pos.y+adder,pos.z+adder,pos.x-adder,pos.y-adder,pos.z-adder, v.col.r,v.col.g,v.col.b,v.col.a)
        local points = {x=v.points.x+0.1,y=v.points.y+0.1,z=v.points.z}
        Cubes[k].points = points
        Cubes[k].pos = PointOnSphere(points.x,points.y,points.z)
      end
      Wait(0)
    end
    
  end)
end

DrawCubes = function()
  Citizen.CreateThread(function()
    local position = GetEntityCoords(PlayerPedId())
    local adder = 10
    for k,v in pairs(Cubes) do
      local addX = 0.1
      local addY = 0.1

      if k%4 == 0 then
        addY = -0.1
      elseif k%3 == 0 then
        addX = -0.1
      elseif k%2 == 0 then
        addX = -0.1
        addY = -0.1
      end

      local pos = position + v.pos
      DrawBox(pos.x+adder,pos.y+adder,pos.z+adder,pos.x-adder,pos.y-adder,pos.z-adder, v.col.r,v.col.g,v.col.b,v.col.a)
      local points = {x=v.points.x+addX,y=v.points.y+addY,z=v.points.z}
      Cubes[k].points = points
      Cubes[k].pos = PointOnSphere(points.x,points.y,points.z)
    end
  end)
end

DrawToons = function()
  local plyPed = PlayerPedId()
  local plyPos = GetEntityCoords(plyPed)

  local infront = vector3(plyPos.x+35.0, plyPos.y-8.0,plyPos.z)
  local behind  = vector3(plyPos.x-35.0, plyPos.y-8.0,plyPos.z)

  if (GetCloudTimeAsInt() - MarioTimer) > 1000 then
    MarioTimer = GetCloudTimeAsInt()
    MarioState = MarioState + MarioAdder

    if MarioState > #Mario.bits then
      MarioAdder = -1
      MarioState = 2
    elseif MarioState <= 0 then
      MarioState = 2
      MarioAdder = 1
    end
  end

  DrawMario(infront)
  DrawMario(behind)
end

DrawMario = function(loc)
  local height = 0
  local width = 0

  if MarioZOff < 0.0 then MarioZOff = MarioZOff + MarioZAdd; end
  for k = #Mario.bits[MarioState],1,-1 do
    local v = Mario.bits[MarioState][k]
    local pos = vector3(loc.x,loc.y+width,loc.z+height)
    local col = Mario.cols[v]

    if MarioAlpha < 255 then
      if not MarioInit then MarioInit = true; end
      MarioAlpha = MarioAlpha + 0.001
    end

    if v ~= 133 then
      DrawBox(pos.x+0.5,pos.y+0.5,pos.z+0.5 + MarioZOff, pos.x-0.5,pos.y-0.5,pos.z-0.5 + MarioZOff, col.r,col.g,col.b,math.floor(MarioAlpha))
    end

    width = width + 1
    if width > MarioLength then
      width = 0
      height = height + 1
    end
  end
end

GetVecDist = function(v1,v2)
  if not v1 or not v2 or not v1.x or not v2.x then return 0; end
  return math.sqrt(  ( (v1.x or 0) - (v2.x or 0) )*(  (v1.x or 0) - (v2.x or 0) )+( (v1.y or 0) - (v2.y or 0) )*( (v1.y or 0) - (v2.y or 0) )+( (v1.z or 0) - (v2.z or 0) )*( (v1.z or 0) - (v2.z or 0) )  )
end

PointOnSphere = function(alt,azu,radius,orgX,orgY,orgZ)
  local toradians = 0.017453292384744
  alt,azu,radius,orgX,orgY,orgZ = ( tonumber(alt or 0) or 0 ) * toradians, ( tonumber(azu or 0) or 0 ) * toradians, tonumber(radius or 0) or 0, tonumber(orgX or 0) or 0, tonumber(orgY or 0) or 0, tonumber(orgZ or 0) or 0
  if      vector3
  then
      return
      vector3(
           orgX + radius * math.sin( azu ) * math.cos( alt ),
           orgY + radius * math.cos( azu ) * math.cos( alt ),
           orgZ + radius * math.sin( alt )
      )
  end
end

TrackPed = function(pTrackingPed)
  Citizen.CreateThread(function()
    while true do
      local dist = GetVecDist(GetEntityCoords(PlayerPedId()), GetEntityCoords(pTrackingPed))
      if dist > 5.0 then
        TaskGoToEntity(pTrackingPed, PlayerPedId(), -1, 4.0, 100.0, 1073741824, 0)
        Wait(1000)
      end
      Citizen.Wait(0)
    end
  end)
end

createAnimal = function(pAnimalModel)
  Citizen.CreateThread(function()
    local animal = pAnimalModel
    local playerPed = PlayerPedId()
    local GroupHandle = GetPlayerGroup(PlayerId())
    local coords = GetEntityCoords(PlayerPedId())
    DoRequestModel(animal)
    local ped = CreatePed(28, animal, coords.x + 1, coords.y + 1, coords.z + 5, 1, 1)
    SetPedAsGroupLeader(playerPed, GroupHandle)
    SetPedAsGroupMember(ped, GroupHandle)
    SetPedNeverLeavesGroup(ped, true)
    SetPedCanBeTargetted(ped, false)
    SetEntityAsMissionEntity(ped, true,true)
    SetEntityInvincible(ped,true)
    SetBlockingOfNonTemporaryEvents(ped,true)
    TrackPed(ped)
    Wait(150000)
    DeletePed(ped)
    SetModelAsNoLongerNeeded(animal)
  end)
end

function DoRequestModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end
end

local FXLIST = {
  ["lsd"] = {
    FadeInFx = "DrugsDrivingIn",
    FadeOutFx = "DrugsDrivingOut",
    Execute = FXAcid
  },
  ["alcohol"] = {
    FadeInFx = nil,
    FadeOutFx = nil,
    Execute = FXAlcohol
  },
  ["weed"] = {
    FadeInFx = "DrugsDrivingIn",
    FadeOutFx = "DrugsDrivingOut",
    Execute = FXWeed
  },
  ["cocaine"] = {
    FadeInFx = "DrugsMichaelAliensFightIn",
    FadeOutFx = "DrugsMichaelAliensFightOut",
    Execute = FXCocaine
  },
  ["crack"] = {
    FadeInFx = "DrugsTrevorClownsFightIn",
    FadeOutFx = "DrugsTrevorClownsFightOut",
    Execute = FXCrack
  },
}

RegisterNetEvent("fx:run")
AddEventHandler("fx:run", function(pFXName, pFXTime, pAlcoholStrength, pIsBadLSD, pIsAbsinthe)
  local fxName = pFXName == nil and "alcohol" or pFXName
  local fxTime = pFXTime == nil and 180 or pFXTime
  local alcoholStrength = pAlcoholStrength == nil and 0.5 or pAlcoholStrength
  isBadLSD = (isBadLSD == true and true or (pIsBadLSD == -1 and false or pIsBadLSD))
  isAbsinthe = (isAbsinthe == true and true or (pIsAbsinthe == -1 and false or pIsAbsinthe))
  --Wait(math.random(2000,5000))
  local currentFX = FXLIST[fxName]
  if currentFX then
    if currentFX.FadeInFx then
      AnimpostfxPlay(currentFX.FadeInFx, 10000, 0)
      Wait(10000)
      AnimpostfxStop(currentFX.FadeInFx)
    end
    -- local particleDict = "scr_family5"
    -- local particleName = "scr_trev_puke"
    -- RequestNamedPtfxAsset(particleDict)
    -- while not HasNamedPtfxAssetLoaded(particleDict) do Citizen.Wait(0) end
    -- UseParticleFxAssetNextCall(particleDict)
    -- StartParticleFxLoopedOnEntityBone("SCR_TREV_PUKE", PlayerPedId(), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 31086, 1.0, false, false, false)
    currentFX.Execute(fxTime, alcoholStrength)
  end
end)

local function calculateDrunkLevel()
  if drunkFactor >= 1.0 and drunkFactor < 2.0 then
    return 1
  elseif drunkFactor >= 2.0 and drunkFactor < 3.0 then
    return 2
  elseif drunkFactor > 3.0 then
    return math.floor(drunkFactor)
  end
  return 0
end

Citizen.CreateThread(function()
  while true do
    local curTime = GetCloudTimeAsInt()
    if drunkFactor <= 0.0 and isDrunk then
      isDrunk = false
      TriggerEvent("client:blockShake", false)
      ShakeGameplayCam("DRUNK_SHAKE", 0.0)
      SetPedIsDrunk(PlayerPedId(), false)
      SetPedMotionBlur(PlayerPedId(), false)
      SetPedConfigFlag(PlayerPedId(), 100, false)
      ResetPedMovementClipset(PlayerPedId(), 0.0)
      if isAbsinthe and not isHigh then
        ClearTimecycleModifier()
      end
      isAbsinthe = false
    end

    if math.floor(drunkFactor) ~= currentLevel then
      newDrunkLevel = true
      currentLevel = calculateDrunkLevel()
      if enableDrunkCamera then
        ShakeGameplayCam("DRUNK_SHAKE", math.min(currentLevel + 0.0, 3.0))
      end
      if isAbsinthe and not isHigh then
        SetTimecycleModifier("drug_wobbly")
        SetTimecycleModifierStrength(1.3)
      end
    end

    if currentLevel == 0 and newDrunklevel then
      newDrunkLevel = false
    elseif currentLevel == 1 and newDrunkLevel then
      SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", 1.0)
      newDrunkLevel = false
    elseif currentLevel == 2 and newDrunkLevel then
      SetPedMovementClipset(PlayerPedId(), "move_m@drunk@moderatedrunk", 1.0)
      nextRandomControl = curTime + math.random(5,10)
      newDrunkLevel = false
    elseif currentLevel == 3 and newDrunkLevel then
      nextStumble = curTime + math.random(5,10)
      SetPedMovementClipset(PlayerPedId(), "move_m@drunk@verydrunk", 1.0)
      newDrunkLevel = false
    elseif currentLevel >= 4 and newDrunkLevel then
      nextBlackout = curTime + math.random(10,30)
      nextPuke = curTime + math.random(30, 60)
      SetPedMovementClipset(PlayerPedId(), "move_m@drunk@verydrunk", 1.0)
      newDrunkLevel = false
    end

    if drunkFactor > 3.0 and curTime > nextStumble then
      SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, 0, 0, 0)
      nextStumble = curTime + math.random(35, 55)
    end

    if currentLevel > 4.0 and curTime > nextBlackout then
      FxFadeOut()
      nextBlackout = curTime + math.random(55, 105)
    end

    if currentLevel > 4.0 and curTime > nextPuke then
      TriggerServerEvent("fx:puke")
      nextPuke = curTime + math.random(55, 105)
    end

    local curVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    if drunkFactor > 2.0 and curVeh ~= 0 and GetPedInVehicleSeat(curVeh, -1) and curTime > nextRandomControl then
      if IsPedInAnyHeli(PlayerPedId()) then
        Citizen.CreateThread(function()
          local counter = 0
          while counter < 500 do
            SetControlNormal(0, 107, 1.0)
            counter = counter + 1
          end
        end)
      else
        TaskVehicleTempAction(PlayerPedId(), curVeh, randomDrivingActions[math.random(#randomDrivingActions)], 3000)
      end
      nextRandomControl = curTime + math.random(10, 25)
    end

    drunkFactor = (drunkFactor <= 0) and 0.0 or drunkFactor - 0.0083 -- Drunk for 120s
    Wait(1000)
  end
end)

RegisterNetEvent("fx:clear")
AddEventHandler("fx:clear", function()
  ClearTimecycleModifier()
  ClearExtraTimecycleModifier()
  ShakeGameplayCam('DRUNK_SHAKE', 0.0)
  SetPedMotionBlur(PlayerPedId(), false)
  AnimpostfxStop("DMT_flight")
  ResetPedMovementClipset(PlayerPedId(), 0.0)
  TriggerEvent("client:blockShake", false)
  drunkFactor = 0.0
end)

RegisterNetEvent('fx:toggleDrunkCamera')
AddEventHandler('fx:toggleDrunkCamera', function(state)
    state = string.lower(state)
    if state == "on" then
        enableDrunkCamera = true
        TriggerEvent('DoLongHudText', "Drunk camera is now enabled.")
    elseif state == "off" then
        enableDrunkCamera = false
        if isDrunk then
          ShakeGameplayCam('DRUNK_SHAKE', 0.0)
        end
        TriggerEvent('DoLongHudText', "Drunk camera is now disabled.")
    else
        TriggerEvent('DoLongHudText', "You need to type in 'on' or 'off'.")
    end
end)

FxFadeOut = function()
  Citizen.CreateThread(function()
    AnimpostfxPlay("MinigameTransitionIn", 300, 1)
    Wait(600)
    DoScreenFadeOut(200)
    Wait(200)
    DoScreenFadeIn(200)
    Wait(200)
    DoScreenFadeOut(400)
    Wait(400)
    DoScreenFadeIn(400)
    SetPedToRagdoll(PlayerPedId(), 10000, 10000, 0, 0, 0, 0)
    Wait(600)
    DoScreenFadeOut(800)
    Wait(4000)
    DoScreenFadeIn(700)
    Wait(300)
    AnimpostfxStop("MinigameTransitionIn")
    AnimpostfxPlay("MinigameTransitionOut", 3500, 1)
    Wait(3500)
    AnimpostfxStop("MinigameTransitionOut")
  end)
end

AddEventHandler("onResourceStart", function(resource)
  if resource == GetCurrentResourceName() then
    TriggerEvent("fx:clear")
    --TriggerEvent("fx:run", "alcohol", 15, 3.3, -1, true)
  end
end)