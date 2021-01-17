dead = false
handcuffed = false
job = "None"
bank = 10
cash = 10
local weaponsLicence = 0
licenses = "<b>Licenses</b> | None <br>"
PagerStatus = false
myCurrentSecondaryJob = "None"
HudStage = 1
phoneopen = false
Firstname = "None"
Lastname = "None"
handcuffedwalking = false
gang = 0
cid = 0
robbing = false
daytime = true
primetime = false
local passes = {}
local myhousekeys = {}
intrunk = false
curPolice = 0
curEms = 0
curTaxi = 0
curTow = 0
local curDoctors = 0
local gangType = 0
local incall = false
local drivingInstructor = false

activeTasks = {
  --[1] = { ["Gang"] = 2, ["TaskType"] = 1, ["TaskState"] = 2, ["TaskOwner"] = 12(cid), ["TaskInfo"] = , ["location"] = { ['x'] = -1248.52,['y'] = -1141.12,['z'] = 7.74,['h'] = 284.71, ['info'] = 'Down at Smokies on the Beach' }, }
}
--local NearNPC = exports["isPed"]:GetClosestNPC()
--local handcuffed = exports["isPed"]:isPed("handcuffed")
--local NearNPC = exports["isPed"]:GetRandomNPC()

function GlobalObject(object)
  --  NetworkRegisterEntityAsNetworked(object)
 --   local netid = ObjToNet(object)
  --  SetNetworkIdExistsOnAllMachines(netid, true)
  --  NetworkSetNetworkIdDynamic(netid, true)
  --  SetNetworkIdCanMigrate(netid, false) 
  --  for i = 1, 32 do
  --    SetNetworkIdSyncToPlayer(netid, i, true)
  --  end
  --  print("New networked object: " .. netid)
end
local pedsused = {}



function GetClosestNPC()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if canPedBeUsed(ped) and distance < 5.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
            pedsused["conf"..rped] = true
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if pedsused["conf"..ped] then
      return false
    end
    if ped == PlayerPedId() then
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

    if IsPedFleeing(ped) or IsPedRunning(ped) or IsPedSprinting(ped) then
        return false
    end

    if IsPedInCover(ped) or IsPedGoingIntoCover(ped) or IsPedGettingUp(ped) then
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

    if IsPedSittingInAnyVehicle(ped) or IsPedGettingIntoAVehicle(ped) or IsPedJumpingOutOfVehicle(ped) or IsPedBeingJacked(ped) then
        return false
    end

    if IsPedOnAnyBike(ped) or IsPedInAnyBoat(ped) or IsPedInFlyingVehicle(ped) then
        return false
    end

    local pedType = GetPedType(ped)
    if pedType == 6 or pedType == 27 or pedType == 29 or pedType == 28 then
        return false
    end

    return true
end

function IsPedNearCoords(x,y,z)
    local handle, ped = FindFirstPed()
    local pedfound = false
    local success
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(vector3(x,y,z) - pos)

        if distance < 5.0 then
          pedfound = true
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return pedfound
end


function GroupRank(groupid)
  local rank = 0
  for i=1, #passes do
    
    if passes[i]["pass_type"] == groupid then

      rank = passes[i]["rank"]
    end 
  end
  return rank
end


function isPed(checkType)
	local checkType = string.lower(checkType)
	local pass = false

    if checkType == "femaleclothes" then
        pass = femaleclothes
    end
    if checkType == "maleclothes" then
        pass = maleclothes
    end

    if checkType == "countpolice" then
        pass = curPolice
    end

    if checkType == "countems" then
        pass = curEms
    end

    if checkType == "counttaxi" then
        pass = curTaxi
    end

    if checkType == "counttow" then
        pass = curTow
    end

    if checkType == "countdoctors" then
        pass = curDoctors
    end

    if checkType == "intrunk" then
        pass = intrunk
    end

    if checkType == "robbing" then
        pass = robbing
    end

    if checkType == "passes" then
        pass = passes
    end

    if checkType == "myhousekeys" then
        pass = myhousekeys
    end

    if checkType == "dead" then
        pass = dead
    end

    if checkType == "gang" then
        pass = gang
    end

    if checkType == "cid" then
        pass = cid
    end

    if checkType == "incall" then
        pass = incall
    end

    if checkType == "handcuffed" then
        if handcuffedwalking or handcuffed then
            pass = true
        else
            pass = false
        end
    end

    if checkType == "phoneopen" then
        pass = phoneopen
    end

    if checkType == "twitterhandle" then
        pass = "@" .. Firstname .. "_" .. Lastname
    end

    if checkType == "fullname" then
      pass = Firstname .. " " .. Lastname
    end

    if checkType == "myjob" then
	    pass = job
    end

    if checkType == "mybank" then
	    pass = bank
    end

    if checkType == "mycash" then
	    pass = cash
    end

    if checkType == "weaponslicence" then
      if weaponsLicence == 1 then
        pass = true
      else
        pass = false
      end
    end
  
    if checkType == "licensestring" then
        pass = licenses
    end

    if checkType == "pagerstatus" then
        pass = PagerStatus
    end

    if checkType == "hud" then
        pass = HudStage
    end

    if checkType == "secondaryjob" then
        pass = myCurrentSecondaryJob
    end

    if checkType == "tasks" then
        pass = activeTasks
    end

    if checkType == "daytime" then
        pass = daytime
    end

    if checkType == "disabled" then
        if handcuffed or dead then
        	pass = true
        end
    end

    if checkType == "corner" then
        pass = gangType
    end

    if checkType == "drivinginstructor" then
      pass = drivingInstructor
    end

    return pass
    
end


RegisterNetEvent('client:updategang')
AddEventHandler('client:updategang', function(newGangType)
  gangType = newGangType
end)

RegisterNetEvent('incall')
AddEventHandler('incall', function(status)
  incall = status
end)


RegisterNetEvent("ped:intrunk")
AddEventHandler("ped:intrunk", function(trunksent)
  intrunk = trunksent
end)


RegisterNetEvent("gangTasks:updateClients")
AddEventHandler("gangTasks:updateClients", function(newTasks)
  activeTasks = newTasks
end)

local secondaryjobList = {
 [1] = {["name"]="Marijuana Dealer", ["id"]="weed"},
 [2] = {["name"]="Cocaine Dealer", ["id"]="cocaine"},
 [3] = {["name"]="Gun Dealer", ["id"]="guns"},
 [4] = {["name"]="Money Launderer", ["id"]="launder"},
 [5] = {["name"]="Marijuana Distributor", ["id"]="weedh"},
 [6] = {["name"]="Cocaine Distributor", ["id"]="cocaineh"},
 [7] = {["name"]="Gun Distributor", ["id"]="gunsh"},
 [8] = {["name"]="Money Distributor", ["id"]="launderh"},
 [9] = {["name"]="Gun Crafter", ["id"]="gunsmith"},
 [10] = {["name"]="Money Launderer", ["id"]="moneyCleaner"},
 [11] = {["name"]="None", ["id"]="none"}, 
}

local BusinessNames = {
	["gym"] = "LS Gym",
	["golf"] = "Golf Course",
	["strip_club"] = "Vanilla Unicorn",
	["illegal_carshop"] = "Camel Tows",
	["winery_factory"] = "Delmar & Caine",
	["carpet_factory"] = "Carpet Company",
	["life_invader"] = "Life Invader",
	["casino"] = "Los Santos Casino",
	["real_estate"] = "Los Santos Real Estate",
	["weed_factory"] = "The Greenery",
	["chop_shop"] = "Choppers",
	["parts_shop"] = "Parts Shop",
	["recycle_shop"] = "Recycle Centre",
	["car_shop"] = "Car Shop",
	["repairs_harmony"] = "Harmony Repairs",
	['tuner_carshop'] = "Tuner Carshop",
	['dock_worker'] = "Dock Worker",
	['lost_mc'] = "The Lost MC",
	['ug_racing'] = "Underground Racing",
	['hoa'] = "Home Owners Assoc.",
  ['rooster_academy'] = "The Rooster Academy",
  ['sahara_int'] = "Sahara International",
  ['drift_school'] = "Overboost Drift",
}

function retreiveBusinesses()
  local businesses = "Partnered to"
  for i = 1, #passes do
    if passes[i]["rank"] > 0 then
      businesses =  businesses .. " | " .. BusinessNames[passes[i]["pass_type"]] .. "("..passes[i]["rank"]..")"
    end
  end
  return businesses
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
  if not IsPedInAnyVehicle(PlayerPedId(), false) then

    for index,value in ipairs(players) do
      local target = GetPlayerPed(value)
      if(target ~= ply) then
        local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
        local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
        if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
          closestPlayer = value
          closestDistance = distance
        end
      end
    end
    
    return closestPlayer, closestDistance

  else
    TriggerEvent("DoShortHudText","Inside Vehicle.",2)
  end

end

RegisterNetEvent("job:counts")
AddEventHandler("job:counts", function(activePolice,activeEms,activeTaxi,activeTow, activeDoctors)

    curPolice = activePolice
    curEms = activeEms
    curTaxi = activeTaxi
    curTow = activeTow
    curDoctors = activeDoctors

end)

RegisterNetEvent("retreiveBusinesses")
AddEventHandler("retreiveBusinesses", function()
    TriggerServerEvent("showbusinesses",retreiveBusinesses())
end)

RegisterNetEvent('daytime')
AddEventHandler("daytime",function(passedTime)
    daytime = passedTime
end)
RegisterNetEvent('primetime')
AddEventHandler("primetime",function(passedPrimeTime)
    primetime = passedPrimeTime
end)

RegisterNetEvent('robbing')
AddEventHandler("robbing",function(passedR)
    robbing = passedR
end)

RegisterNetEvent("SecondaryJobUpdate")
AddEventHandler("SecondaryJobUpdate", function(mysecondaryjob)
    for i = 1, #secondaryjobList do
        if mysecondaryjob == secondaryjobList[i]["id"] then
            myCurrentSecondaryJob = secondaryjobList[i]["name"]
        end
    end
end)

RegisterNetEvent("returnPlayerKeys")
AddEventHandler("returnPlayerKeys", function(ownedhouses,keyedhouses,keyhouseIDs)
    myhousekeys = keyhouseIDs
end)

RegisterNetEvent("enablegangmember")
AddEventHandler("enablegangmember", function(gangtype,cidpassed)
    gang = gangtype
    cid = cidpassed
end)

RegisterNetEvent("updatecid")
AddEventHandler("updatecid", function(cidpassed)
    cid = cidpassed
end)

RegisterNetEvent("phoneEnabled")
AddEventHandler("phoneEnabled", function(phoneopensent)
 phoneopen = phoneopensent
end)

RegisterNetEvent("updateNameClient")
AddEventHandler("updateNameClient", function(firstname,lastname)
    Firstname = firstname
    Lastname = lastname
end)

RegisterNetEvent("disableHUD")
AddEventHandler("disableHUD", function(passedinfo)
  HudStage = passedinfo
end)

-- local countpolice = exports["isPed"]:isPed("femaleclothes")
RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
	dead = not dead
end)

-- local handcuffed = exports["isPed"]:isPed("handcuffed")
RegisterNetEvent('police:currentHandCuffedState')
AddEventHandler('police:currentHandCuffedState', function(handCuffed,handCuffedWalking)
	handcuffed = handCuffed
    handcuffedwalking = handCuffedWalking
end)

RegisterNetEvent('pagerStatus')
AddEventHandler('pagerStatus', function(PassedPagerStatus)
    PagerStatus = PassedPagerStatus
end)

--local myJob = exports["isPed"]:isPed("myJob")
RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(jobpassed, name, notify)
	job = jobpassed
    if not job then
        job = "None"
    end
end)


RegisterNetEvent('banking:updateBalance')
AddEventHandler('banking:updateBalance', function(amount)
	bank = math.ceil(amount)
end)

RegisterNetEvent('wtflols')
AddEventHandler('wtflols', function(amount,weaponPass)
  cash = math.ceil(amount)
  weaponsLicence = weaponPass
end)

RegisterNetEvent('isPed:UpdateCash')
AddEventHandler('isPed:UpdateCash', function(newCash)
  cash = newCash
end)

RegisterNetEvent('np-base:addedMoney')
AddEventHandler('np-base:addedMoney', function(blah,amount)
  cash = math.ceil(amount)
end)

RegisterNetEvent('np-base:removedMoney')
AddEventHandler('np-base:removedMoney', function(blah,amount)
  cash = math.ceil(amount)
end)

RegisterNetEvent('updateLicenseString')
AddEventHandler('updateLicenseString', function(newLicenseString)
    licenses = newLicenseString
end)
--updateLicenseString


RegisterNetEvent('drivingInstructor:update')
AddEventHandler('drivingInstructor:update', function(status)
  drivingInstructor = status
end)

drivingSkill = 0
bodyStrength = 0
gunHandling = 0
towTruckSkill = 0
taxiSkill = 0
newsReporterSkill = 0
entertainmentSkill = 0
truckerSkill = 0
farmingSkill = 0



-- the more you race, the less handling / power is removed from vehicles.

-- the more you work out, the harder you can hit with melee.

-- the more you shoot in certain areas the better at handling recoil you get.

-- 

--passes system

--passes
--gym
--stripclub
--golfcourse


-- result[i].id
-- result[i].cid
-- result[i].rank
-- result[i].name
-- result[i].giver
-- result[i].pass_type


RegisterNetEvent('cid:client:passes')
AddEventHandler('cid:client:passes', function(cidq)
  if cid == cidq then
    TriggerServerEvent("server:currentpasses")
  end
end)

RegisterNetEvent('client:passes')
AddEventHandler('client:passes', function(newpasses)
  passes = newpasses
  gang = 0
  local groupInformation = checkPasses("carpet_factory")
  if groupInformation ~= nil then
    if groupInformation.rank > 2 then
      TriggerServerEvent("gang:AllowAccess",1)
    end
  end
  local groupInformation2 = checkPasses("winery_factory")
  if groupInformation2 ~= nil then
    if groupInformation2.rank > 2 then
      TriggerServerEvent("gang:AllowAccess",2)
    end
  end
  local groupInformation3 = checkPasses("weed_factory")
  if groupInformation3 ~= nil then
    if groupInformation3.rank > 2 then
      TriggerServerEvent("gang:AllowAccess",4)
    end
  end  
end)

function checkPasses(passType)
  local returnNum = nil
  for i = 1, #passes do
    if passes[i].pass_type == passType then
      returnNum = passes[i]
    end
  end
  return returnNum
end

RegisterNetEvent('client:pass')
AddEventHandler('client:pass', function(passType,args)
    local passInfo = checkPasses(passType)
    if passInfo == nil then
      if passType == "real_estate" then
          TriggerEvent("housing:info")
        -- allow use of real estate commands here.
      end
      return
    end

    local rank = passInfo.rank
    if rank < 1 then
      if passType == "strip_club" then
        TriggerEvent("DoLongHudText","Hm, I wonder if I can join this club?",1)
      else
        TriggerEvent("DoLongHudText","You do not have permission to do this.",2)
      end
      return
    end
    if passType == "golfcourse" then
      TriggerServerEvent("GolfPay")
      TriggerEvent("DoLongHudText","Press E to swing, A-D to rotate, Y to swap club.",1)
    end
    if passType == "gym" then
      TriggerEvent("doworkout")
      TriggerEvent("DoLongHudText","Starting, hold still..",1)
    end
    if passType == "strip_club" then
      TriggerEvent("dostripstress")
      TriggerEvent("DoLongHudText","Ahhh, this is relaxing.",1)
    end    

    if passType == "illegal_carshop" then
      -- set whitelist on illegal carshop
      TriggerEvent("whitelist:illegal:mechanic")
    end  
    if passType == "real_estate" then
        TriggerEvent("housing:info:realtor",args)
      -- allow use of real estate commands here.
    end


end)

femaleclothes = {
'mp_f_freemode_01',
'a_f_m_beach_01',
'a_f_m_bevhills_01',
'a_f_m_bevhills_02',
'a_f_m_bodybuild_01',
'a_f_m_business_02',
'a_f_m_downtown_01',
'a_f_m_eastsa_01',
'a_f_m_eastsa_02',
'a_f_m_fatbla_01',
'a_f_m_fatcult_01',
'a_f_m_fatwhite_01',
'a_f_m_ktown_01',
'a_f_m_ktown_02',
'a_f_m_prolhost_01',
'a_f_m_salton_01',
'a_f_m_skidrow_01',
'a_f_m_soucentmc_01',
'a_f_m_soucent_01',
'a_f_m_soucent_02',
'a_f_m_tourist_01',
'a_f_m_trampbeac_01',
'a_f_m_tramp_01',
'a_f_o_genstreet_01',
'a_f_o_indian_01',
'a_f_o_ktown_01',
'a_f_o_salton_01',
'a_f_o_soucent_01',
'a_f_o_soucent_02',
'a_f_y_beach_01',
'a_f_y_bevhills_01',
'a_f_y_bevhills_02',
'a_f_y_bevhills_03',
'a_f_y_bevhills_04',
'a_f_y_business_01',
'a_f_y_business_02',
'a_f_y_business_03',
'a_f_y_business_04',
'a_f_y_eastsa_01',
'a_f_y_eastsa_02',
'a_f_y_eastsa_03',
'a_f_y_epsilon_01',
'a_f_y_fitness_01',
'a_f_y_fitness_02',
'a_f_y_genhot_01',
'a_f_y_golfer_01',
'a_f_y_hiker_01',
'a_f_y_hipster_01',
'a_f_y_hipster_02',
'a_f_y_hipster_03',
'a_f_y_hipster_04',
'a_f_y_indian_01',
'a_f_y_juggalo_01',
'a_f_y_runner_01',
'a_f_y_rurmeth_01',
'a_f_y_scdressy_01',
'a_f_y_skater_01',
'a_f_y_soucent_01',
'a_f_y_soucent_02',
'a_f_y_soucent_03',
'a_f_y_tennis_01',
'a_f_y_tourist_01',
'a_f_y_tourist_02',
'a_f_y_vinewood_01',
'a_f_y_vinewood_02',
'a_f_y_vinewood_03',
'a_f_y_vinewood_04',
'a_f_y_yoga_01',
'g_f_y_ballas_01',
'g_f_y_families_01',
'g_f_y_lost_01',
'g_f_y_vagos_01',
'mp_f_deadhooker',
'mp_f_freemode_01',
'mp_f_misty_01',
'mp_f_stripperlite',
'mp_s_m_armoured_01',
's_f_m_fembarber',
's_f_m_maid_01',
's_f_m_shop_high',
's_f_m_sweatshop_01',
's_f_y_airhostess_01',
's_f_y_bartender_01',
's_f_y_baywatch_01',
's_f_y_factory_01',
's_f_y_hooker_01',
's_f_y_hooker_02',
's_f_y_hooker_03',
's_f_y_migrant_01',
's_f_y_movprem_01',
'ig_kerrymcintosh',
'ig_janet',
'ig_jewelass',
'ig_magenta',
'ig_marnie',
'ig_patricia',
'ig_screen_writer',
'ig_tanisha',
'ig_tonya',
'ig_tracydisanto',
'u_f_m_corpse_01',
'u_f_m_miranda',
'u_f_m_promourn_01',
'u_f_o_moviestar',
'u_f_o_prolhost_01',
'u_f_y_bikerchic',
'u_f_y_comjane',
'u_f_y_corpse_01',
'u_f_y_corpse_02',
'u_f_y_hotposh_01',
'u_f_y_jewelass_01',
'u_f_y_mistress',
'u_f_y_poppymich',
'u_f_y_princess',
'u_f_y_spyactress',
'ig_amandatownley',
'ig_ashley',
'ig_andreas',
'ig_ballasog',
'ig_maryannn',
'ig_maude',
'ig_michelle',
'ig_mrs_thornhill',
'ig_natalia',
's_f_y_scrubs_01',
's_f_y_shop_low',
's_f_y_shop_mid',
's_f_y_stripperlite',
's_f_y_stripper_01',
's_f_y_stripper_02',
'ig_mrsphillips',
'ig_mrs_thornhill',
'ig_molly',
'ig_natalia',
's_f_y_sweatshop_01',
'ig_paige',
'a_f_y_femaleagent',
'a_f_y_hippie_01'
 }
 -- 101 grills
--429 male

maleclothes = {
'mp_m_freemode_01',
'hc_driver',
'hc_gunman',
'hc_hacker',
'ig_paige',
'ig_abigail',
'ig_bankman',
'ig_barry',
'ig_bestmen',
'ig_beverly',
'ig_brad',
'ig_bride',
'ig_car3guy1',
'ig_car3guy2',
'ig_casey',
'ig_chef',
'ig_chengsr',
'ig_chrisformage',
'ig_clay',
'ig_claypain',
'ig_cletus',
'ig_dale',
'ig_davenorton',
'ig_denise',
'ig_devin',
'ig_dom',
'ig_dreyfuss',
'ig_drfriedlander',
'ig_fabien',
'ig_fbisuit_01',
'ig_floyd',
'ig_groom',
'ig_hao',
'ig_hunter',
'csb_prolsec',
'ig_jay_norris',
'ig_jimmyboston',
'ig_jimmydisanto',
'ig_joeminuteman',
'ig_johnnyklebitz',
'ig_josef',
'ig_josh',
'ig_lamardavis',
'ig_lazlow',
'ig_lestercrest',
'ig_lifeinvad_01',
'ig_lifeinvad_02',
'ig_manuel',
'ig_milton',
'ig_mrk',
'ig_nervousron',
'ig_nigel',
'ig_old_man1a',
'ig_old_man2',
'ig_oneil',
'ig_orleans',
'ig_ortega',
'ig_paper',
'ig_priest',
'ig_prolsec_02',
'ig_ramp_gang',
'ig_ramp_hic',
'ig_ramp_hipster',
'ig_ramp_mex',
'ig_roccopelosi',
'ig_russiandrunk',
'ig_siemonyetarian',
'ig_solomon',
'ig_stevehains',
'ig_stretch',
'ig_talina',
'ig_taocheng',
'ig_taostranslator',
'ig_tenniscoach',
'ig_terry',
'ig_tomepsilon',
'ig_tylerdix',
'ig_wade',
'ig_zimbor',
's_m_m_paramedic_01',
'a_m_m_afriamer_01',
'a_m_m_beach_01',
'a_m_m_beach_02',
'a_m_m_bevhills_01',
'a_m_m_bevhills_02',
'a_m_m_business_01',
'a_m_m_eastsa_01',
'a_m_m_eastsa_02',
'a_m_m_farmer_01',
'a_m_m_fatlatin_01',
'a_m_m_genfat_01',
'a_m_m_genfat_02',
'a_m_m_golfer_01',
'a_m_m_hasjew_01',
'a_m_m_hillbilly_01',
'a_m_m_hillbilly_02',
'a_m_m_indian_01',
'a_m_m_ktown_01',
'a_m_m_malibu_01',
'a_m_m_mexcntry_01',
'a_m_m_mexlabor_01',
'a_m_m_og_boss_01',
'a_m_m_paparazzi_01',
'a_m_m_polynesian_01',
'a_m_m_prolhost_01',
'a_m_m_rurmeth_01',
'a_m_m_salton_01',
'a_m_m_salton_02',
'a_m_m_salton_03',
'a_m_m_salton_04',
'a_m_m_skater_01',
'a_m_m_skidrow_01',
'a_m_m_socenlat_01',
'a_m_m_soucent_01',
'a_m_m_soucent_02',
'a_m_m_soucent_03',
'a_m_m_soucent_04',
'a_m_m_stlat_02',
'a_m_m_tennis_01',
'a_m_m_tourist_01',
'a_m_m_trampbeac_01',
'a_m_m_tramp_01',
'a_m_m_tranvest_01',
'a_m_m_tranvest_02',
'a_m_o_beach_01',
'a_m_o_genstreet_01',
'a_m_o_ktown_01',
'a_m_o_salton_01',
'a_m_o_soucent_01',
'a_m_o_soucent_02',
'a_m_o_soucent_03',
'a_m_o_tramp_01',
'a_m_y_beachvesp_01',
'a_m_y_beachvesp_02',
'a_m_y_beach_01',
'a_m_y_beach_02',
'a_m_y_beach_03',
'a_m_y_bevhills_01',
'a_m_y_bevhills_02',
'a_m_y_breakdance_01',
'a_m_y_busicas_01',
'a_m_y_business_01',
'a_m_y_business_02',
'a_m_y_business_03',
'a_m_y_cyclist_01',
'a_m_y_dhill_01',
'a_m_y_downtown_01',
'a_m_y_eastsa_01',
'a_m_y_eastsa_02',
'a_m_y_epsilon_01',
'a_m_y_epsilon_02',
'a_m_y_gay_01',
'a_m_y_gay_02',
'a_m_y_genstreet_01',
'a_m_y_genstreet_02',
'a_m_y_golfer_01',
'a_m_y_hasjew_01',
'a_m_y_hiker_01',
'a_m_y_hipster_01',
'a_m_y_hipster_02',
'a_m_y_hipster_03',
'a_m_y_indian_01',
'a_m_y_jetski_01',
'a_m_y_juggalo_01',
'a_m_y_ktown_01',
'a_m_y_ktown_02',
'a_m_y_latino_01',
'a_m_y_methhead_01',
'a_m_y_mexthug_01',
'a_m_y_motox_01',
'a_m_y_motox_02',
'a_m_y_musclbeac_01',
'a_m_y_musclbeac_02',
'a_m_y_polynesian_01',
'a_m_y_roadcyc_01',
'a_m_y_runner_01',
'a_m_y_runner_02',
'a_m_y_salton_01',
'a_m_y_skater_01',
'a_m_y_skater_02',
'a_m_y_soucent_01',
'a_m_y_soucent_02',
'a_m_y_soucent_03',
'a_m_y_soucent_04',
'a_m_y_stbla_01',
'a_m_y_stbla_02',
'a_m_y_stlat_01',
'a_m_y_stwhi_01',
'a_m_y_stwhi_02',
'a_m_y_sunbathe_01',
'a_m_y_surfer_01',
'a_m_y_vindouche_01',
'a_m_y_vinewood_01',
'a_m_y_vinewood_02',
'a_m_y_vinewood_03',
'a_m_y_vinewood_04',
'a_m_y_yoga_01',
'g_m_m_armboss_01',
'g_m_m_armgoon_01',
'g_m_m_armlieut_01',
'g_m_m_chemwork_01',
'g_m_m_chiboss_01',
'g_m_m_chicold_01',
'g_m_m_chigoon_01',
'g_m_m_chigoon_02',
'g_m_m_korboss_01',
'g_m_m_mexboss_01',
'g_m_m_mexboss_02',
'g_m_y_armgoon_02',
'g_m_y_azteca_01',
'g_m_y_ballaeast_01',
'g_m_y_ballaorig_01',
'g_m_y_ballasout_01',
'g_m_y_famca_01',
'g_m_y_famdnf_01',
'g_m_y_famfor_01',
'g_m_y_korean_01',
'g_m_y_korean_02',
'g_m_y_korlieut_01',
'g_m_y_lost_01',
'g_m_y_lost_02',
'g_m_y_lost_03',
'g_m_y_mexgang_01',
'g_m_y_mexgoon_01',
'g_m_y_mexgoon_02',
'g_m_y_mexgoon_03',
'g_m_y_pologoon_01',
'g_m_y_pologoon_02',
'g_m_y_salvaboss_01',
'g_m_y_salvagoon_01',
'g_m_y_salvagoon_02',
'g_m_y_salvagoon_03',
'g_m_y_strpunk_01',
'g_m_y_strpunk_02',
'mp_m_claude_01',
'mp_m_exarmy_01',
'mp_m_shopkeep_01',
's_m_m_ammucountry',
's_m_m_autoshop_01',
's_m_m_autoshop_02',
's_m_m_bouncer_01',
's_m_m_chemsec_01',
's_m_m_cntrybar_01',
's_m_m_dockwork_01',
's_m_m_doctor_01',
's_m_m_fiboffice_01',
's_m_m_fiboffice_02',
's_m_m_gaffer_01',
's_m_m_gardener_01',
's_m_m_gentransport',
's_m_m_hairdress_01',
's_m_m_highsec_01',
's_m_m_highsec_02',
's_m_m_janitor',
's_m_m_lathandy_01',
's_m_m_lifeinvad_01',
's_m_m_linecook',
's_m_m_lsmetro_01',
's_m_m_mariachi_01',
's_m_m_marine_01',
's_m_m_marine_02',
's_m_m_migrant_01',
's_m_m_movalien_01',
's_m_m_movprem_01',
's_m_m_movspace_01',
's_m_m_pilot_01',
's_m_m_pilot_02',
's_m_m_postal_01',
's_m_m_postal_02',
's_m_m_scientist_01',
's_m_m_security_01',
's_m_m_strperf_01',
's_m_m_strpreach_01',
's_m_m_strvend_01',
's_m_m_trucker_01',
's_m_m_ups_01',
's_m_m_ups_02',
's_m_o_busker_01',
's_m_y_airworker',
's_m_y_ammucity_01',
's_m_y_armymech_01',
's_m_y_autopsy_01',
's_m_y_barman_01',
's_m_y_baywatch_01',
's_m_y_blackops_01',
's_m_y_blackops_02',
's_m_y_busboy_01',
's_m_y_chef_01',
's_m_y_clown_01',
's_m_y_construct_01',
's_m_y_construct_02',
's_m_y_dealer_01',
's_m_y_devinsec_01',
's_m_y_dockwork_01',
's_m_y_doorman_01',
's_m_y_dwservice_01',
's_m_y_dwservice_02',
's_m_y_factory_01',
's_m_y_garbage',
's_m_y_grip_01',
's_m_y_marine_01',
's_m_y_marine_02',
's_m_y_marine_03',
's_m_y_mime',
's_m_y_pestcont_01',
's_m_y_pilot_01',
's_m_y_prismuscl_01',
's_m_y_prisoner_01',
's_m_y_robber_01',
's_m_y_shop_mask',
's_m_y_strvend_01',
's_m_y_uscg_01',
's_m_y_valet_01',
's_m_y_waiter_01',
's_m_y_winclean_01',
's_m_y_xmech_01',
's_m_y_xmech_02',
'u_m_m_aldinapoli',
'u_m_m_bankman',
'u_m_m_bikehire_01',
'u_m_m_fibarchitect',
'u_m_m_filmdirector',
'u_m_m_glenstank_01',
'u_m_m_griff_01',
'u_m_m_jesus_01',
'u_m_m_jewelsec_01',
'u_m_m_jewelthief',
'u_m_m_markfost',
'u_m_m_partytarget',
'u_m_m_prolsec_01',
'u_m_m_promourn_01',
'u_m_m_rivalpap',
'u_m_m_spyactor',
'u_m_m_willyfist',
'u_m_o_finguru_01',
'u_m_o_taphillbilly',
'u_m_o_tramp_01',
'u_m_y_abner',
'u_m_y_antonb',
'u_m_y_babyd',
'u_m_y_baygor',
'u_m_y_burgerdrug_01',
'u_m_y_chip',
'u_m_y_cyclist_01',
'u_m_y_fibmugger_01',
'u_m_y_guido_01',
'u_m_y_gunvend_01',
'u_m_y_imporage',
'u_m_y_mani',
'u_m_y_militarybum',
'u_m_y_paparazzi',
'u_m_y_party_01',
'u_m_y_pogo_01',
'u_m_y_prisoner_01',
'u_m_y_proldriver_01',
'u_m_y_rsranger_01',
'u_m_y_sbike',
'u_m_y_staggrm_01',
'u_m_y_tattoo_01',
'u_m_y_zombie_01',
'u_m_y_hippie_01',
'a_m_y_hippy_01'
}