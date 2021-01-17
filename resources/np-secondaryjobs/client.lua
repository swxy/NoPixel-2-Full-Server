-- server will update this for us.
local decrypting = false
local decryptType = 1
local globalReputation = {
    ["mexican"] = { ["weed"] = 0, ["cocaine"] = 0, ["guns"] = 0, ["launder"] = 0 },
    ["salva"] = { ["weed"] = 0, ["cocaine"] = 0, ["guns"] = 0, ["launder"] = 0 },
    ["weicheng"] = { ["weed"] = 0, ["cocaine"] = 0, ["guns"] = 0, ["launder"] = 0 },   
    ["family"] = { ["weed"] = 0, ["cocaine"] = 0, ["guns"] = 0, ["launder"] = 0 },
    ["ballas"] = { ["weed"] = 0, ["cocaine"] = 0, ["guns"] = 0, ["launder"] = 0 },        
}

vehSpawnResult = { ["x"] = 0.0, ["y"] = 0.0,["z"] = 0.0 }
endResult = { ["x"] = 0.0, ["y"] = 0.0,["z"] = 0.0 }

local moneyhouses = {
}

local crafthouses = {
}
--max these at 20

local myGangReputation = {
    ["mexican"] = 0,
    ["salva"] = 0,
    ["weicheng"] = 0,   
    ["family"] = 0,
    ["ballas"] = 0,
    ["robbery"] = 0,           
}



local weedStartLocations = {
    [1] =  { ['x'] = -400.22,['y'] = 6378.4,['z'] = 14.08,['h'] = 22.69, ['info'] = ' old shack along the beach road.' },
    [2] =  { ['x'] = 830.78,['y'] = -2171.64,['z'] = 30.28,['h'] = 270.14, ['info'] = ' old green ammunation with mpfuk written on the door near the slaughter house.' },
    [3] =  { ['x'] = 892.33,['y'] = -2172.22,['z'] = 32.29,['h'] = 171.6, ['info'] = ' Green Electrical door with a Gas Tank on the roof near the slaughter house.' },
    [4] =  { ['x'] = 940.78,['y'] = -2142.02,['z'] = 30.98,['h'] = 175.97, ['info'] = ' Green Visitors door near the Slaughter House' },
    [5] =  { ['x'] = 983.3,['y'] = -2281.23,['z'] = 30.51,['h'] = 261.17, ['info'] = ' Blue door near the old rail tracks in south east LS.' },
    [6] =  { ['x'] = 975.6,['y'] = -2357.92,['z'] = 31.83,['h'] = 174.38, ['info'] = ' Blue door near where the rail tracks cross in south east LS.' },
    [7] =  { ['x'] = 1017.67,['y'] = -2529.17,['z'] = 28.31,['h'] = 67.23, ['info'] = ' white door next to a triple garage and gas tank in south east LS.' },
    [8] =  { ['x'] = 861.18,['y'] = -2535.75,['z'] = 28.45,['h'] = 189.36, ['info'] = ' double doors at the factory just below the bridge on the docks.' },
    [9] =  { ['x'] = 681.45,['y'] = -2700.71,['z'] = 7.18,['h'] = 269.88, ['info'] = ' green door next to the road and a few silos on the docks' },
    [10] =  { ['x'] = 270.06,['y'] = -3075.74,['z'] = 5.78,['h'] = 224.85, ['info'] = ' port of los santos in an old factory building.' },
    [11] =  { ['x'] = 116.12,['y'] = -2689.04,['z'] = 6.01,['h'] = 267.74, ['info'] = ' old pacific bait building.' },
    [12] =  { ['x'] = -69.04,['y'] = -2655.35,['z'] = 6.01,['h'] = 357.45, ['info'] = ' old green walker building.' },
    [13] =  { ['x'] = -293.42,['y'] = -2668.3,['z'] = 6.39,['h'] = 40.11, ['info'] = ' storage building across from the train loading area on the docks' },
    [14] =  { ['x'] = -477.85,['y'] = -2688.95,['z'] = 8.77,['h'] = 312.48, ['info'] = ' unused boat near the los santos marine area' },
    [15] =  { ['x'] = -263.9,['y'] = -2485.82,['z'] = 7.3,['h'] = 229.29, ['info'] = ' port of los santos, berth 25.' },
    [16] =  { ['x'] = -629.09,['y'] = -1634.98,['z'] = 25.98,['h'] = 180.9, ['info'] = ' green electrical door near the old rogers building.' },
    [17] =  { ['x'] = -583.49,['y'] = -1767.84,['z'] = 23.19,['h'] = 144.67, ['info'] = ' white door near the old ice and storage building.' },
    [18] =  { ['x'] = -511.66,['y'] = -1747.41,['z'] = 19.25,['h'] = 237.66, ['info'] = ' green electrical door inside the rogers scrap yard.' },
    [19] =  { ['x'] = 350.87,['y'] = -968.33,['z'] = 29.44,['h'] = 80.85, ['info'] = ' LS Gentstyle building.' },
    [20] =  { ['x'] = 307.95,['y'] = -911.18,['z'] = 29.3,['h'] = 339.05, ['info'] = ' old los santos theatre, in the alley with the dirty bums.' },
    [21] =  { ['x'] = 371.77,['y'] = -827.18,['z'] = 29.3,['h'] = 75.39, ['info'] = ' white door in the back alley across from Los Santos Theatre' },
    [22] =  { ['x'] = 440.59,['y'] = -708.47,['z'] = 35.73,['h'] = 85.29, ['info'] = ' ladder, just above simmet alley.' },
    [23] =  { ['x'] = 465.92,['y'] = -735.74,['z'] = 27.37,['h'] = 81.52, ['info'] = ' old unused store in simmet alley.' },
    [24] =  { ['x'] = 5.56,['y'] = -648.69,['z'] = 31.77,['h'] = 219.84, ['info'] = ' green electrical door above the tunnel construction in the city.' },
    [25] =  { ['x'] = -39.32,['y'] = -614.21,['z'] = 35.27,['h'] = 246.38, ['info'] = ' enclosed garage near the construction in the middle of the city.' },
    [26] =  { ['x'] = -36.13,['y'] = -569.48,['z'] = 38.84,['h'] = 334.78, ['info'] = ' just across from arcadius.' },
    [27] =  { ['x'] = -159.44,['y'] = -577.96,['z'] = 32.43,['h'] = 156.64, ['info'] = ' toilet in the underground carpark in the middle of the city.' },
    [28] =  { ['x'] = -1273.31,['y'] = -1370.83,['z'] = 4.31,['h'] = 12.87, ['info'] = ' white door near the 5 garages in the back alley along the beachside.' },
    [29] =  { ['x'] = -1245.67,['y'] = 376.3,['z'] = 75.35,['h'] = 16.41, ['info'] = ' back of the richman hotel.' },
    [30] =  { ['x'] = 2842.28,['y'] = 1457.1,['z'] = 24.74,['h'] = 72.95, ['info'] = ' old green electrical door in the big factory on the east coast, ocean side.' },
    [31] =  { ['x'] = 1536.71,['y'] = 3797.63,['z'] = 34.46,['h'] = 14.38, ['info'] = ' back of the boat shop.' },
    [32] =  { ['x'] = 916.56,['y'] = 3576.93,['z'] = 33.56,['h'] = 271.57, ['info'] = ' old greenish building.' },
    [33] =  { ['x'] = 387.76,['y'] = 3585.28,['z'] = 33.3,['h'] = 342.36, ['info'] = ' old tractor factory.' },
    [34] =  { ['x'] = 287.71,['y'] = 2843.76,['z'] = 44.71,['h'] = 119.34, ['info'] = ' old loading factory.' },
    [35] =  { ['x'] = 182.75,['y'] = 2790.7,['z'] = 45.62,['h'] = 10.39, ['info'] = ' old factory.' },
    [36] =  { ['x'] = 255.66,['y'] = 2585.8,['z'] = 44.95,['h'] = 94.83, ['info'] = ' back of the old service station on rt 68.' },
    [37] =  { ['x'] = 541.44,['y'] = 2663.5,['z'] = 42.17,['h'] = 99.07, ['info'] = ' back of the old 24/7 around rt 68' },
    [38] =  { ['x'] = 591.96,['y'] = 2782.56,['z'] = 43.49,['h'] = 3.32, ['info'] = ' out back of the dollar pills store.' },
    [39] =  { ['x'] = 2335.64,['y'] = 4859.79,['z'] = 41.81,['h'] = 225.16, ['info'] = ' old skivers autos shed.' },
    [40] =  { ['x'] = 2030.27,['y'] = 4980.36,['z'] = 42.1,['h'] = 220.41, ['info'] = ' old union grain building.' },
    [41] =  { ['x'] = 1673.06,['y'] = 4957.83,['z'] = 42.35,['h'] = 223.4, ['info'] = ' old abandoned factory near sandy shores.' },
    [42] =  { ['x'] = 1722.43,['y'] = 4734.88,['z'] = 42.14,['h'] = 284.23, ['info'] = ' back of the old feed store.' },
    [43] =  { ['x'] = 2911.1,['y'] = 4492.52,['z'] = 48.11,['h'] = 234.6, ['info'] = ' old shed near the weed farms.' },
    [44] =  { ['x'] = 2932.37,['y'] = 4624.17,['z'] = 48.73,['h'] = 46.89, ['info'] = ' old red wooden shed near the weed farms.' },
    [45] =  { ['x'] = 1417.13,['y'] = 6339.2,['z'] = 24.4,['h'] = 8.82, ['info'] = ' old commune building.' },
    [46] =  { ['x'] = 413.08,['y'] = 6539.24,['z'] = 27.74,['h'] = 351.67, ['info'] = ' old tin shed near the farms.' },
}



function MyRep()
    local myRep = 0
    myRep = myGangReputation["mexican"] + myGangReputation["salva"] + myGangReputation["weicheng"] + myGangReputation["family"] + myGangReputation["ballas"]
    myRep = myRep + (myGangReputation["robbery"]/10)
    return myRep
end

local weedtaskloc = {  ['x'] = 1413.08,['y'] = 1539.24,['z'] = -227.74 }

local candecrypt = false
local encryptlink = 0
RegisterNetEvent('weed:allowevent')
AddEventHandler('weed:allowevent', function(link)
    TriggerEvent("phone:addnotification","Highly Encrypted Email","This email can only be decrypted with certain devices.")
    candecrypt = true
    encryptlink = link
end)

RegisterNetEvent('redopasses')
AddEventHandler('redopasses', function()
    TriggerServerEvent("updatePasses")
end)

RegisterNetEvent('weedpassupdate')
AddEventHandler('weedpassupdate', function()
    local gangNum = exports["isPed"]:isPed("gang")
    if gangNum == 4 then
        TriggerServerEvent("updatePasses")
    end
end)



function hasDecryptGod()
    if exports["np-inventory"]:hasEnoughOfItem("decrypterenzo",1,false,false) then
      return true
    else
      return false
    end
end

local weedtaskinprogress = false
function decryptWeedTask()
    candecrypt = false
    weedtaskloc = weedStartLocations[encryptlink]
    weedtaskinprogress = true
    TriggerEvent("phone:addnotification","The Boss","Sup, I heard about you, if you want to run shit in my streets, I got a deal, you gota show me you're smart and find it first, heres the one and only hint.. its near the" .. weedStartLocations[encryptlink]["info"])
    if encryptlink ~= 0 then
        TriggerEvent("weedtask")
    end
    encryptlink = 0
end

RegisterNetEvent('endweedtasks')
AddEventHandler('endweedtasks', function()
    encryptlink = 0
    weedtaskinprogress = false
    candecrypt = false
    TriggerEvent("phone:addnotification","The Boss","Okay, someone has the spot, the shows over. Stay clean and ill be sure to hit you up again if needed!")
end)

RegisterNetEvent('weedtask')
AddEventHandler('weedtask', function()
    while weedtaskinprogress do
        Citizen.Wait(1)
        local dst = #(GetEntityCoords(PlayerPedId()) - vector3(weedtaskloc["x"],weedtaskloc["y"],weedtaskloc["z"]))
        if dst < 2.0 then
            TriggerEvent("phone:addnotification","The Boss","Nice, you found it, type /ganglock in your phone to unlock/lock the door. Make sure you remember the location, I wont tell you it again!")
            weedtaskinprogress = false
        end
    end
end)

RegisterNetEvent('weed:opened')
AddEventHandler('weed:opened', function()
    local myRep = MyRep()
    TriggerServerEvent("weed:reputationcheck",myRep)
end)

taskenabled = false
recentconvictions = {}

RegisterNetEvent('robbery:change:house')
AddEventHandler('robbery:change:house', function(positive)
    if math.random(100) > 48 or not positive then
        if positive then
            myGangReputation["robbery"] = myGangReputation["robbery"] + 1
        else
            myGangReputation["robbery"] = myGangReputation["robbery"] - 1
        end
        if myGangReputation["robbery"] < 0 then
            myGangReputation["robbery"] = 0
        end
        if myGangReputation["robbery"] > 200 then
            myGangReputation["robbery"] = 200
        end
       -- TriggerServerEvent("gang:updateClientRobberyReputation",myGangReputation["robbery"])
    end    
end)

local hotSpots = {
    ["Strawberry"] = { ["ratio"] = 0, ["zone"] = 1 },
    ["Rancho"] = { ["ratio"] = 0, ["zone"] = 1 },
    ["Chamberlain Hills"] = { ["ratio"] = 0, ["zone"] = 1 },
    ["Davis"] = { ["ratio"] = 0, ["zone"] = 1 },
    ["West Vinewood"] = { ["ratio"] = 0, ["zone"] = 2 },
    ["Downtown Vinewood"] = { ["ratio"] = 0, ["zone"] = 2 },
}



RegisterNetEvent('drugs:hotSpots')
AddEventHandler('drugs:hotSpots', function(newhotSpots)
    hotSpots = newhotSpots
end)



RegisterNetEvent('lastconvictionlist')
AddEventHandler('lastconvictionlist', function(newconv)
    recentconvictions = newconv
end)
RegisterNetEvent('stringGangGlobalReputations')
AddEventHandler('stringGangGlobalReputations', function()

    local strg = "<font size='5'>Daily Crime Statistics</font> <br><br> <br> <b> Crack epidemic around "


    if hotSpots["Strawberry"]["ratio"] > 0 then
        strg = strg .. " Strawberry Ave, "
    end

    if hotSpots["Rancho"]["ratio"] > 0 then
        strg = strg .. " Rancho, "
    end

    if hotSpots["Chamberlain Hills"]["ratio"] > 0 then
        strg = strg .. " Chamberlain Hills, "
    end

    if hotSpots["Davis"]["ratio"] > 0 then
        strg = strg .. " Davis, "
    end
    strg = strg .. " according to recent statistics and "
    if hotSpots["West Vinewood"]["ratio"] > 0 then
        strg = strg .. " Cocaine is the most sought after drug around West Vinewood according to LSPD investigations "
    end

    if hotSpots["Downtown Vinewood"]["ratio"] > 0 then
        strg = strg .. " Cocaine is the most sought after drug around Downtown Vinewood according to LSPD investigations <br> "
    end

    count = #recentconvictions
    strg = strg .. " <br><br><br><br><font size='5'>Recent Incarcerations</font>" 
            
    while count > 0 do
        strg = strg .. "<br><br>" .. recentconvictions[count] 
        count = count - 1
    end

    local currenttax = exports["np-votesystem"]:getTax()
    local strg2 = "<font size='5'>Government Statistics</font> <br><br> The current Tax is set to " .. currenttax .. "%"
    
    TriggerServerEvent("NewsStandCheckMayorStuff", strg, strg2 )

end)

-- 1 = Weed Oz, 2 = Weed Brick
-- 38 = Gun Part, 39 = Gun Crate
-- 7 = cocaine Bag, 8 = cocaine Brick
-- 9 = Money Bag, 10 = Money Brick
--weed,cocaine,guns,launder,stolengoods = getQuantitys()
function getQuantitys()
    local weed = exports["np-inventory"]:getQuantity("weedoz")
    local cocaine = exports["np-inventory"]:getQuantity("coke5g")
    local guns = exports["np-inventory"]:getQuantity("riflebody")
    local launder = exports["np-inventory"]:getQuantity("inkset")
    local stolengoods = exports["np-inventory"]:getQuantity("valuablegoods")
    return weed,cocaine,guns,launder,stolengoods
end


local dropoffs = {
    [1] =  { ['x'] = 483.17,['y'] = -1827.35,['z'] = 27.86,['h'] = 135.87, ['info'] = ' East Side 1' },
    [2] =  { ['x'] = 475.87,['y'] = -1798.45,['z'] = 28.49,['h'] = 229.85, ['info'] = ' East Side 2' },
    [3] =  { ['x'] = 503.54,['y'] = -1765.06,['z'] = 28.51,['h'] = 67.61, ['info'] = ' East Side 3' },
    [4] =  { ['x'] = 512.0,['y'] = -1842.13,['z'] = 27.9,['h'] = 138.1, ['info'] = ' East Side 4' },
    [5] =  { ['x'] = 466.89,['y'] = -1852.81,['z'] = 27.72,['h'] = 310.97, ['info'] = ' East Side 5' },
    [6] =  { ['x'] = 431.33,['y'] = -1882.85,['z'] = 26.85,['h'] = 39.7, ['info'] = ' East Side 6' },
    [7] =  { ['x'] = 410.64,['y'] = -1908.57,['z'] = 25.46,['h'] = 80.03, ['info'] = ' East Side 7' },
    [8] =  { ['x'] = 192.93,['y'] = -2027.95,['z'] = 18.29,['h'] = 251.25, ['info'] = ' East Side 8' },
    [9] =  { ['x'] = 184.05,['y'] = -2004.77,['z'] = 18.31,['h'] = 49.81, ['info'] = ' East Side 9' },
    [10] =  { ['x'] = 212.4,['y'] = -1971.66,['z'] = 20.31,['h'] = 63.83, ['info'] = ' East Side 10' },
    [11] =  { ['x'] = 266.85,['y'] = -1964.41,['z'] = 23.0,['h'] = 49.59, ['info'] = ' East Side 11' },
    [12] =  { ['x'] = 313.05,['y'] = -1918.57,['z'] = 25.65,['h'] = 315.88, ['info'] = ' East Side 12' },
    [13] =  { ['x'] = 282.63,['y'] = -1948.96,['z'] = 24.39,['h'] = 40.21, ['info'] = ' East Side 13' },
    [14] =  { ['x'] = 250.44,['y'] = -1995.9,['z'] = 20.32,['h'] = 324.5, ['info'] = ' East Side 14' },
    [15] =  { ['x'] = 270.54,['y'] = -1706.13,['z'] = 29.31,['h'] = 46.82, ['info'] = ' Central 1' },
    [16] =  { ['x'] = 167.78,['y'] = -1635.0,['z'] = 29.3,['h'] = 22.04, ['info'] = ' Central 2' },

    [17] =  { ['x'] = 175.98,['y'] = -1542.48,['z'] = 29.27,['h'] = 316.21, ['info'] = ' Central 3' },

    [18] =  { ['x'] = -99.69,['y'] = -1577.74,['z'] = 31.73,['h'] = 231.66, ['info'] = ' Central 4' },
    [19] =  { ['x'] = -171.68,['y'] = -1659.11,['z'] = 33.47,['h'] = 85.41, ['info'] = ' Central 5' },
    [20] =  { ['x'] = -209.75,['y'] = -1632.29,['z'] = 33.9,['h'] = 177.99, ['info'] = ' Central 6' },
    [21] =  { ['x'] = -262.65,['y'] = -1580.04,['z'] = 31.86,['h'] = 251.02, ['info'] = ' Central 7' },
    [22] =  { ['x'] = -182.0,['y'] = -1433.79,['z'] = 31.31,['h'] = 210.92, ['info'] = ' Central 8' },
    [23] =  { ['x'] = -83.37,['y'] = -1415.39,['z'] = 29.33,['h'] = 180.98, ['info'] = ' Central 9' },
    [24] =  { ['x'] = -39.13,['y'] = -1473.67,['z'] = 31.65,['h'] = 5.17, ['info'] = ' Central 10' },
    [25] =  { ['x'] = 45.16,['y'] = -1475.65,['z'] = 29.36,['h'] = 136.92, ['info'] = ' Central 11' },
    [26] =  { ['x'] = 158.52,['y'] = -1496.02,['z'] = 29.27,['h'] = 133.49, ['info'] = ' Central 12' },
    [27] =  { ['x'] = 43.58,['y'] = -1599.87,['z'] = 29.61,['h'] = 50.3, ['info'] = ' Central 13' },
    [28] =  { ['x'] = 7.97,['y'] = -1662.14,['z'] = 29.33,['h'] = 318.63, ['info'] = ' Central 14' },
    [29] =  { ['x'] = -726.92,['y'] = -854.64,['z'] = 22.8,['h'] = 2.0, ['info'] = ' West 1' },
    [30] =  { ['x'] = -713.09,['y'] = -886.66,['z'] = 23.81,['h'] = 357.65, ['info'] = ' West 2' },
    [31] =  { ['x'] = -591.45,['y'] = -891.2,['z'] = 25.95,['h'] = 91.53, ['info'] = ' West 3' },
    [32] =  { ['x'] = -683.59,['y'] = -945.62,['z'] = 20.85,['h'] = 180.74, ['info'] = ' West 4' },
    [33] =  { ['x'] = -765.92,['y'] = -920.94,['z'] = 18.94,['h'] = 180.44, ['info'] = ' West 5' },
    [34] =  { ['x'] = -807.45,['y'] = -957.09,['z'] = 15.29,['h'] = 340.4, ['info'] = ' West 6' },
    [35] =  { ['x'] = -822.88,['y'] = -973.96,['z'] = 14.72,['h'] = 126.28, ['info'] = ' West 7' },
    [36] =  { ['x'] = -657.53,['y'] = -729.91,['z'] = 27.84,['h'] = 309.58, ['info'] = ' West 8' },
    [37] =  { ['x'] = -618.39,['y'] = -750.71,['z'] = 26.66,['h'] = 85.6, ['info'] = ' West 9' },
    [38] =  { ['x'] = -548.36,['y'] = -854.53,['z'] = 28.82,['h'] = 352.84, ['info'] = ' West 10' },
    [39] =  { ['x'] = -518.18,['y'] = -804.65,['z'] = 30.8,['h'] = 267.32, ['info'] = ' West 11' },
    [40] =  { ['x'] = -509.05,['y'] = -737.77,['z'] = 32.6,['h'] = 174.97, ['info'] = ' West 12' },
    [41] =  { ['x'] = -567.5,['y'] = -717.77,['z'] = 33.43,['h'] = 268.02, ['info'] = ' West 13' },
    [42] =  { ['x'] = -654.89,['y'] = -732.13,['z'] = 27.56,['h'] = 309.15, ['info'] = ' West 14' },

    [43] =  { ['x'] = 1983.84,['y'] = 3063.02,['z'] = 47.19,['h'] = 309.12, ['info'] = ' 1' },
    [44] =  { ['x'] = 1958.01,['y'] = 3739.43,['z'] = 32.39,['h'] = 114.6, ['info'] = ' 2' },
    [45] =  { ['x'] = 1971.21,['y'] = 3741.71,['z'] = 32.33,['h'] = 211.38, ['info'] = ' 3' },
    [46] =  { ['x'] = 1997.01,['y'] = 3777.79,['z'] = 32.24,['h'] = 213.46, ['info'] = ' 4' },
    [47] =  { ['x'] = 1776.25,['y'] = 3644.02,['z'] = 34.51,['h'] = 22.07, ['info'] = ' 4' },
    [48] =  { ['x'] = 1407.26,['y'] = 3602.08,['z'] = 35.0,['h'] = 196.03, ['info'] = ' 5' },
    [49] =  { ['x'] = 1732.84,['y'] = 3844.72,['z'] = 34.87,['h'] = 197.98, ['info'] = ' 6' },
    [50] =  { ['x'] = 1883.93,['y'] = 3891.56,['z'] = 33.06,['h'] = 101.74, ['info'] = ' 6' },
    [51] =  { ['x'] = 1664.96,['y'] = 4771.26,['z'] = 42.0,['h'] = 215.27, ['info'] = ' 6' },
    [52] =  { ['x'] = 1680.66,['y'] = 4836.48,['z'] = 42.18,['h'] = 115.28, ['info'] = ' 6' },
    [53] =  { ['x'] = 1656.53,['y'] = 4883.09,['z'] = 42.0,['h'] = 273.68, ['info'] = ' 6' },
    [54] =  { ['x'] = 1693.39,['y'] = 4922.68,['z'] = 42.24,['h'] = 66.38, ['info'] = ' 6' },
    [55] =  { ['x'] = -330.57,['y'] = 6221.79,['z'] = 31.49,['h'] = 221.93, ['info'] = ' 6' },
    [56] =  { ['x'] = -330.82,['y'] = 6153.0,['z'] = 32.32,['h'] = 39.85, ['info'] = ' 6' },
    [57] =  { ['x'] = -137.01,['y'] = 6284.25,['z'] = 31.49,['h'] = 222.15, ['info'] = ' 6' },
    [58] =  { ['x'] = -101.02,['y'] = 6345.31,['z'] = 31.58,['h'] = 219.06, ['info'] = ' 66' },
    [59] =  { ['x'] = 136.12,['y'] = 6638.45,['z'] = 31.76,['h'] = 217.11, ['info'] = ' 66' },
    [60] =  { ['x'] = -198.62,['y'] = 133.24,['z'] = 69.66,['h'] = 167.46, ['info'] = ' 66' },
    [61] =  { ['x'] = -119.32,['y'] = 209.02,['z'] = 93.13,['h'] = 179.47, ['info'] = ' 66' },
    [62] =  { ['x'] = 137.39,['y'] = 168.07,['z'] = 104.98,['h'] = 248.0, ['info'] = ' 66' },
    [63] =  { ['x'] = 106.22,['y'] = 161.61,['z'] = 104.55,['h'] = 334.66, ['info'] = ' 66' },
    [64] =  { ['x'] = -216.7,['y'] = 312.32,['z'] = 96.95,['h'] = 264.62, ['info'] = ' 66' },
    [65] =  { ['x'] = -377.5,['y'] = 277.05,['z'] = 84.8,['h'] = 30.17, ['info'] = ' 66' },
    [66] =  { ['x'] = -395.2,['y'] = 205.61,['z'] = 83.61,['h'] = 81.62, ['info'] = ' 66' },
    [67] =  { ['x'] = -501.24,['y'] = -55.76,['z'] = 40.04,['h'] = 246.27, ['info'] = ' 66' },
    [68] =  { ['x'] = 479.25,['y'] = 74.13,['z'] = 96.97,['h'] = 331.37, ['info'] = ' 66' },
    [69] =  { ['x'] = 394.67,['y'] = 263.72,['z'] = 103.03,['h'] = 152.47, ['info'] = ' 66' },
    [70] =  { ['x'] = 368.8,['y'] = 323.94,['z'] = 103.59,['h'] = 161.19, ['info'] = ' 66' },
}



function createLocation()
    endResult = dropoffs[math.random(#dropoffs)]
end


local salecost = { ["weed"] = 0, ["cocaine"] = 0, ["guns"] = 0, ["launder"] = 0, ["stolengoods"] = 0 }
local salenames = { [1] = "Weed Ounce", [2] = "Cocaine Bag", [3] = "Gun Part", [4] = "Money Ink Set", [5] = "Valuable Goods" }
local bonusRun = false

mysecondaryjob = "weed"

local secondaryjobList = {
  {name="Marijuana Dealer", id="weed"},
  {name="Cocaine Dealer", id="cocaine"},
  {name="Gun Dealer", id="guns"},
  {name="Money Launderer", id="launder"},
  {name="Marijuana Distributor", id="weedh"},
  {name="Cocaine Distributor", id="cocaineh"},
  {name="Gun Distributor", id="gunsh"},
  {name="Money Distributor", id="launderh"},
}
function hasEncryption()
    if (exports["np-inventory"]:hasEnoughOfItem("decryptersess",1,false) or exports["np-inventory"]:hasEnoughOfItem("decrypterfv2",1,false)) and not exports["isPed"]:isPed("disabled") then
      return true
    else
      return false
    end
end

function hasDevice()
    if exports["np-inventory"]:hasEnoughOfItem("mk2usbdevice",1,false) and not exports["isPed"]:isPed("disabled") then
      return true
    else
      return false
    end
end

function hasPhone()
    if exports["np-inventory"]:hasEnoughOfItem("mobilephone",1,false) and not exports["isPed"]:isPed("disabled") then
      return true
    else
      return false
    end
end
function getDeal()

    bonusRun = false


    local chance = math.random(100)
    if decryptType == 2 then
        chance = math.random(120)
    elseif decryptType == 3 then
        chance = math.random(140)
    end
    if chance > 80 then
        bonusRun = true
    end

    salecost["weed"] = 0
    salecost["cocaine"] = 0
    salecost["guns"] = 0
    salecost["launder"] = 0
    if mysecondaryjob == "weed" then
        salecost["weed"] = math.random(2)
        if bonusRun then addSecondary(1) end
    end

    if mysecondaryjob == "cocaine" then
        salecost["cocaine"] = math.random(3)
        if salecost["cocaine"] > 3 then
            salecost["cocaine"] = 3
        end
        if bonusRun then addSecondary(2) end
    end

    if mysecondaryjob == "guns" then
        salecost["guns"] = math.random(4)
        if salecost["guns"] > 3 then
            salecost["guns"] = 3
        end
        if bonusRun then addSecondary(3) end
    end

    if mysecondaryjob == "launder" then
        salecost["launder"] = math.random(1)
        if salecost["launder"] > 3 then
            salecost["launder"] = 3
        end
        if bonusRun then addSecondary(4) end
    end 

end

function addSecondary(passedNum)


    local randn = math.random(1,5)
    if randn == 1 and randn ~= passedNum then
        salecost["weed"] = math.random(2)
        return
    elseif randn == 2 and randn ~= passedNum then  
        salecost["cocaine"] = math.random(2)
        return
    elseif randn == 3 and randn ~= passedNum then 
        salecost["guns"] = math.random(2)
        return
    elseif randn == 4 and randn ~= passedNum then  
        salecost["launder"] = math.random(2)
        return
    else
        salecost["stolengoods"] = math.random(1)
    end  


end

onduty = false
function signOnJob(passedJob)
    mysecondaryjob = passedJob
    onduty = true
end

function getTaskName()
    if mysecondaryjob == "weed" then
        return secondaryjobList[1].name
    end
    if mysecondaryjob == "cocaine" then
        return secondaryjobList[2].name
    end
    if mysecondaryjob == "guns" then
        return secondaryjobList[3].name
    end
    if mysecondaryjob == "launder" then
        return secondaryjobList[4].name
    end 
    if mysecondaryjob == "weedh" then
        return secondaryjobList[5].name
    end
    if mysecondaryjob == "cocaineh" then
        return secondaryjobList[6].name
    end
    if mysecondaryjob == "gunsh" then
        return secondaryjobList[7].name
    end
    if mysecondaryjob == "launderh" then
        return secondaryjobList[8].name
    end
end

function distributor()
    if mysecondaryjob == "weed" then
        return false
    end
    if mysecondaryjob == "cocaine" then
        return false
    end
    if mysecondaryjob == "guns" then
        return false
    end
    if mysecondaryjob == "launder" then
        return false
    end 
    if mysecondaryjob == "weedh" then
        return true
    end
    if mysecondaryjob == "cocaineh" then
        return true
    end
    if mysecondaryjob == "gunsh" then
        return true
    end
    if mysecondaryjob == "launderh" then
        return true
    end 
    return false
end

RegisterNetEvent('gangs:updateReputations')
AddEventHandler('gangs:updateReputations', function(serverGangReputation)
    globalReputation = serverGangReputation
end)

RegisterNetEvent('gangs:updateMyReputations')
AddEventHandler('gangs:updateMyReputations', function(mexican,salva,weicheng,family,ballas,robbery)
    myGangReputation["mexican"] = mexican
    myGangReputation["salva"] = salva
    myGangReputation["weicheng"] = weicheng
    myGangReputation["family"] = family
    myGangReputation["ballas"] = ballas
    myGangReputation["robbery"] = robbery
end)


function writeTaskBrief()
    local extra = false
    string = ""
    if salecost["weed"] > 0 then
        string = salecost["weed"] .. " " .. salenames[1]
            if salecost["weed"] > 1 then
                string = string .. "s"
            end
        extra = true
    end
    if salecost["cocaine"] > 0 then
        if extra then
            string = string .. " and " .. salecost["cocaine"] .. " " .. salenames[2]
        else
            string = salecost["cocaine"] .. " " .. salenames[2]
        end

        if salecost["cocaine"] > 1 then
            string = string .. "s"
        end

        extra = true
    end
    if salecost["guns"] > 0 then
        if extra then
            string = string .. " and " .. salecost["guns"] .. " " .. salenames[3]
        else
            string = salecost["guns"] .. " " .. salenames[3]
        end      

        if salecost["guns"] > 1 then
            string = string .. "s"
        end

        extra = true
    end
    if salecost["launder"] > 0 then
        if extra then
            string = string .. " and " .. salecost["launder"] .. " " .. salenames[4]
        else
            string = salecost["launder"] .. " " .. salenames[4]
        end    

        if salecost["launder"] > 1 then
            string = string .. "s"
        end

        extra = true
    end 

    if salecost["stolengoods"] > 0 then
        if extra then
            string = string .. " and " .. salecost["stolengoods"] .. " " .. salenames[5]
        else
            string = salecost["stolengoods"] .. " " .. salenames[5]
        end    

        if salecost["stolengoods"] > 1 then
            string = string .. "s"
        end

        extra = true
    end 

    return string   
end


local taskLocation = { ["x"] = 105.10749053955, ["y"] = -1941.2779541016, ["z"] = 20.803716659546 }
local gangTaskArea = "local"
local taskinprogress = false
local taskBrief = "None"
local clothing = "s_m_y_garbage"
function selectSecondaryTask()

    if not distributor() then
        getDeal()
    end

    local string = writeTaskBrief()
    local areachance = math.random(100)
    taskinprogress = true

    if areachance < 33 then
        createLocation()
        gangTaskArea = "mexican"
        clothing = 'a_m_y_mexthug_01'
        if distributor() then
            taskBrief = "Someone wants to help break down product"
        else
            taskBrief = "Someone wants " .. string
        end

    elseif areachance < 66 then
        createLocation()
        gangTaskArea = "weicheng"
        clothing = 'g_m_y_korean_01'
        if distributor() then
            taskBrief = "Someone wants to help break down product"
        else
            taskBrief = "Someone wants " .. string
        end

    elseif areachance < 100 then
        createLocation()
        gangTaskArea = "ballas"
        clothing = 'ig_ballasog'
        if distributor() then
            taskBrief = "Someone wants to help break down product"
        else
            taskBrief = "Someone wants " .. string
        end
    else
        -- make this a generic location anywhere? maybe use the racing car location script
        createLocation()
        clothing = "s_m_y_garbage"
        gangTaskArea = "local"
        taskBrief = "Someone wants " .. string
    end
    taskBrief = taskBrief .. " - decrypt message to review the email and update your GPS location again."
    local tasknamelol = getTaskName()
    TriggerEvent("phone:addnotification",tasknamelol,taskBrief)
    setLocation()
    taskStarted()
end

ped = 0
taskveh = 0
car = 0

Controlkey = {["generalUse"] = {38,"E"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
    Controlkey["generalUse"] = table["generalUse"]
end)

function deliveryVehicle()

    local pedmodel = GetHashKey(clothing)

    RequestModel(pedmodel)
    while not HasModelLoaded(pedmodel) do
        RequestModel(pedmodel)
        Citizen.Wait(100)
    end

    local pedType = GetPedType(pedmodel)


    ped = CreatePed(5, pedmodel, endResult["x"],endResult["y"],endResult["z"]-0.5, endResult["h"], 1, 1)
    DecorSetBool(ped, 'ScriptedPed', true)
    local continuepause = false
 
    ClearPedTasks(ped)
    ClearPedSecondaryTask(ped)
    TaskSetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedCombatAttributes(ped, 17, 1)
    --SetEntityAsMissionEntity(ped,false,true)
    SetPedSeeingRange(ped, 0.0)
    SetPedHearingRange(ped, 0.0)
    SetPedAlertness(ped, 0)
    SetPedKeepTask(ped, true)


    count = 300000
    local taskstart = false
    while count > 0 do
        count = count - 1
        local coords = GetEntityCoords(ped)
        local mycoords = GetEntityCoords(PlayerPedId())
        local bDist = #(vector3(coords["x"], coords["y"],coords["z"]) - vector3(mycoords["x"],mycoords["y"],mycoords["z"]))

        if bDist < 100.0 then

            if bDist < 2.2 then
                if IsControlJustReleased(1,Controlkey["generalUse"][1]) and not taskstart then
                    TriggerEvent("endTaskSuccess")
                    Citizen.Wait(100)
                    taskstart=true
                end
                if not taskstart then
                    DrawText3Ds(coords["x"], coords["y"],coords["z"], "["..Controlkey["generalUse"][2].."]")     
                end    
            end
        end

        if IsPedFatallyInjured(ped) then
            Citizen.Wait(20000)
            endTask()
        end

        if count < 10 then

 
            Citizen.Wait(1000)
            endTask()
            count = 0
        end

        Citizen.Wait(1)

    end

    endTask()
    TriggerEvent("DoLongHudText", "Task Complete.")
    --TaskEveryoneLeaveVehicle(vehicle)
    --TaskLeaveVehicle(ped, vehicle, flags)
end

-- 1 = Weed Oz, 2 = Weed Brick
-- 38 = Gun Part, 39 = Gun Crate
-- 7 = Cocaine Bag, 8 = Cocaine Brick
-- 9 = Money Bag, 10 = Money Brick

function DropDrugs(ai,highvalue)
    local ai = ai
    local drugs = 4
    local highvalue = highvalue
    local pos = GetEntityCoords(ai)
    if not highvalue then
        drugs = 2
    end

    local launder = math.random(1,drugs)
    TriggerEvent("inv:CreatedropItem",9,math.random(launder))


    local robparts = math.random(0,400)
    local part = 53

    if robparts < 10 then
        part = 47
    elseif robparts < 24 then
        part = 48
    elseif robparts < 57 then
        part = 50
    elseif robparts < 97 then
        part = 51
    elseif robparts < 150 then
        part = 52
    elseif robparts < 200 then
        part = 53
    elseif robparts < 230 then
        part = 79
    elseif robparts < 240 then
        part = 80
    elseif robparts < 250 then
        part = 81
    end

    if robparts < 250 then
        TriggerEvent("inv:CreatedropItem",part,math.random(5))
    end

end






function DropItemPed(ai)

    local ai = ai
    local chance = math.random(100)
    if chance > 45 then
        DropDrugs(ai,true)
    elseif chance > 25 and chance < 32 then
        DropDrugs(ai,false)
    end
end

function SearchPockets(ai)
    local timer = 3000
    local ai = ai
    local searching = false
    
    while timer > 0 do
        timer = timer - 1
        local pos = GetEntityCoords(ai)
        Citizen.Wait(1)
        if math.random(100) > 90 then
            Citizen.Trace(timer)
        end
        if not searching then
            DrawText3Ds(pos["x"], pos["y"],pos["z"], "Press "..Controlkey["generalUse"][2].." to search thug.")
            if IsControlJustReleased(1,Controlkey["generalUse"][1]) then
                searching = true
                TriggerEvent("animation:PlayAnimation","search")
                local finished = exports["np-taskbar"]:taskBar(25000,"Searching Thug")
                if finished == 100 then
                    DropItemPed(ai)
                end
                ClearPedTasks(PlayerPedId())
                timer = 0
            end
        else

        end
    end
    searching = false
end
local fighting = 0
function startAiFight()

    if fighting > 0 then
        return
    end    

    fighting = 10000
    taskinprogress = false
    TaskEveryoneLeaveVehicle(taskveh)
    Citizen.Wait(700)
    GiveWeaponToPed(ped, `WEAPON_BAT`, 1, 0, 1)
    TaskCombatPed(ped, PlayerPedId(), 0, 16)  
    local killerPed = ped  
    TriggerEvent("DoLongHudText", "Its a setup, do what it takes to get out alive!.")

    while fighting > 0 do
        Citizen.Wait(1)
        fighting = fighting - 1
        if IsEntityDead(killerPed) then
                      
            SearchPockets(killerPed)
            endTask()  
            fighting = 0
        end
        if IsEntityDead(PlayerPedId()) or fighting < 10 then
            TaskEnterVehicle(ped, taskveh, 30, -1,10.0, 0, 0)
            Citizen.Wait(10000)
            endTask()
            fighting = 0
        end
    end

    fighting = 0
end

function endTask()
    taskinprogress = false
    taskenabled = false
    count = 2  
    fighting = 0
    if not IsPedAPlayer(GetPedInVehicleSeat(taskveh, -1)) then
        TaskVehicleDriveToCoord(GetPedInVehicleSeat(taskveh, -1), taskveh, 0.0, 0.0,0.0, 40.0, 1, car, 786603, 0, -1)
        SetVehicleHasBeenOwnedByPlayer(taskveh,false)
        SetPedKeepTask(GetPedInVehicleSeat(taskveh, -1), false)
        SetPedAsNoLongerNeeded(ped)         
        SetVehicleAsNoLongerNeeded(taskveh)
        SetEntityAsNoLongerNeeded(ped)
        SetEntityAsNoLongerNeeded(taskveh)
        SetEntityAsMissionEntity(taskveh,false,false)
        SetEntityAsMissionEntity(ped,false,false)
        DecorSetBool(ped, 'ScriptedPed', false)
    end
    ClearPedTasks(ped)
    ped = 0
    taskveh = 0
    
end

function breakdownproduct()
    Citizen.Trace("Breakdown checking")
    weed,cocaine,guns,launder = getQuantitysH()
    if mysecondaryjob == "weedh" and weed > 0 then
        TriggerEvent("inventory:removeItem", "weed5oz", 1)
        TriggerEvent("attachItemDrugs","drugtest01")
        return true
    end
    if mysecondaryjob == "cocaineh" and cocaine > 0 then
        TriggerEvent("inventory:removeItem","coke50g", 1)
        TriggerEvent("attachItemDrugs","drugtest02")        
        return true
    end
    if mysecondaryjob == "gunsh" and guns > 0 then
        TriggerEvent("inventory:removeItem","riflebodybox", 1)
        TriggerEvent("attachItemDrugs","gunbox1")        
        return true
    end
    if mysecondaryjob == "launderh" and launder > 0 then
        TriggerEvent("inventory:removeItem","inkcrate", 1)
        TriggerEvent("attachItemDrugs","cashcase3")        
        return true
    end 
end

RegisterNetEvent('addGangReputationSpecific')
AddEventHandler('addGangReputationSpecific', function(gangType)
    myGangReputation[gangType] = myGangReputation[gangType] + 1
    ensureLimits()
end)


RegisterNetEvent('loseGangReputationSpecific')
AddEventHandler('loseGangReputationSpecific', function(gangType)
    myGangReputation[gangType] = myGangReputation[gangType] - 2
    ensureLimits()
end)


RegisterNetEvent('loseGangReputation')
AddEventHandler('loseGangReputation', function(minutes)
    myGangReputation["mexican"] = myGangReputation["mexican"] - minutes
    myGangReputation["salva"] = myGangReputation["salva"] - minutes
    myGangReputation["weicheng"] = myGangReputation["weicheng"] - minutes
    myGangReputation["family"] = myGangReputation["family"] - minutes
    myGangReputation["ballas"] = myGangReputation["ballas"] - minutes
    myGangReputation["robbery"] = myGangReputation["robbery"] - minutes
    ensureLimits()
end)

function doBreakDown()

    local income = 0
    local count = 5

    while count > 0 do

        TriggerEvent("DoLongHudText", "Hold tight while he gives you the broken down product. (May take some time..)")

        Citizen.Wait(6000)

        TaskTurnPedToFaceEntity(PlayerPedId(), ped, 1.0)

        if mysecondaryjob == "weedh" then
            
            TriggerEvent('player:receiveItem',"weedoz", 1)



            TriggerEvent("attachItemDrugs2","drugtest01")
            TriggerEvent("Evidence:StateSet",4,1200)
        end

        if mysecondaryjob == "cocaineh" then


            TriggerEvent('player:receiveItem',"coke5g", 1)
            TriggerEvent("attachItemDrugs2","drugtest02")   
            TriggerEvent("Evidence:StateSet",11,1200)     
        end

        if mysecondaryjob == "gunsh" then

            TriggerEvent('player:receiveItem',"riflebody", 1)
            TriggerEvent("attachItemDrugs2","gunbox1") 
            TriggerEvent("Evidence:StateSet",12,1200)       
        end

        if mysecondaryjob == "launderh" then

            TriggerEvent('player:receiveItem',"inkset", 1)
            TriggerEvent("attachItemDrugs2","cashcase3") 
            TriggerEvent("Evidence:StateSet",13,1200)  
        end 

        Citizen.Wait(1000)

        count = count - 1

    end

    TriggerEvent("DoLongHudText", "The deals over, move out..")

end




function getQuantitysH()
    local weed = exports["np-inventory"]:getQuantity("weed5oz")
    local cocaine = exports["np-inventory"]:getQuantity("coke50g")
    local guns = exports["np-inventory"]:getQuantity("riflebodybox")
    local launder = exports["np-inventory"]:getQuantity("inkcrate")
    return weed,cocaine,guns,launder
end


RegisterNetEvent("endTaskSuccess")
AddEventHandler("endTaskSuccess", function()
        -- do events here
    local odds = math.random(100)



    if distributor() and breakdownproduct() then

        doBreakDown()
    end

    if checkAmounts() and not distributor() then
        removeAmounts()
        payClient()     
    end


    taskinprogress = false
    count = 0

end)

function removeAmounts()
    weed,cocaine,guns,launder,stolengoods = getQuantitys()
    if salecost["weed"] > 0 then

        TriggerEvent("inventory:removeItem", "weedoz", salecost["weed"])
        TriggerEvent("attachItemDrugs","cashcase01")
        TriggerEvent("civilian:alertPolice",8.0,"druguse",0)
        TriggerEvent("Evidence:StateSet",4,1200)
        Citizen.Wait(3500)

    end
    if salecost["cocaine"] > 0 then

        TriggerEvent("inventory:removeItem", "coke5g", salecost["cocaine"])
        TriggerEvent("attachItemDrugs","cashcase01")
        TriggerEvent("civilian:alertPolice",8.0,"druguse",0)
        TriggerEvent("Evidence:StateSet",11,1200) 
        Citizen.Wait(3500)

    end
    
    if salecost["guns"] > 0 then

        TriggerEvent("inventory:removeItem","riflebody", salecost["guns"])
        TriggerEvent("attachItemDrugs","cashcase01")
        TriggerEvent("civilian:alertPolice",8.0,"PDOF",0)
        TriggerEvent("Evidence:StateSet",12,1200)  
        Citizen.Wait(3500)

    end
    if salecost["launder"] > 0 then

        TriggerEvent("inventory:removeItem","inkset", salecost["launder"])
        TriggerEvent("civilian:alertPolice",8.0,"Suspicious",0)
        TriggerEvent("attachItemDrugs","cashcase01")
        Citizen.Wait(3500)
      
    end

    if salecost["stolengoods"] > 0 then

        TriggerEvent("inventory:removeItem","valuablegoods", salecost["stolengoods"])
        TriggerEvent("civilian:alertPolice",8.0,"Suspicious",0)
        TriggerEvent("attachItemDrugs","cashcase01")
        Citizen.Wait(3500)
       
    end

end


function payClient()


    local payment = (250 * salecost["weed"]) + (250 * salecost["cocaine"]) + (100 * salecost["guns"]) + (200 * salecost["launder"]) + (9000 * salecost["stolengoods"])
    if gangTaskArea == "mexican" then
        payment = payment
        gangUp("mexican")
    end

    if gangTaskArea == "salva" then
        payment = payment
        gangUp("salva")
    end

    if gangTaskArea == "weicheng" then
        payment = payment
        gangUp("weicheng")
    end

    if gangTaskArea == "family" then
        payment = payment
        gangUp("family")
    end

    if gangTaskArea == "ballas" then
        payment = payment
        gangUp("ballas")
    end 

    if not distributor() then
        payment = math.ceil(payment) 
        TriggerServerEvent("job:Pay", gangTaskArea .. " " .. mysecondaryjob, payment)
    end 
end

function gangUp(uppedGang)

    if math.random(100) > 66 then
        myGangReputation["mexican"] = myGangReputation["mexican"] - 1
        myGangReputation["salva"] = myGangReputation["salva"] - 1
        myGangReputation["weicheng"] = myGangReputation["weicheng"] - 1
        myGangReputation["family"] = myGangReputation["family"] - 1
        myGangReputation["ballas"] = myGangReputation["ballas"] - 1
    end

    local amount = 1
    if myGangReputation[uppedGang] > 80 and math.random(100) > 65 then
        amount = amount + 1
    end

    if myGangReputation[uppedGang] > 150 then
        amount = amount + math.random(2)
    end

    myGangReputation[uppedGang] = myGangReputation[uppedGang] + amount

    ensureLimits()

    gangUpAI(uppedGang)

end


RegisterNetEvent('gangUp')
AddEventHandler('gangUp', function(uppedGang)
    gangUp(uppedGang)
end)


function gangUpAI(uppedGang)

    gangNum = 0
    if mysecondaryjob == "weed" then
        gangNum = 1
    end
    if mysecondaryjob == "cocaine" then
        gangNum = 2
    end
    if mysecondaryjob == "guns" then
        gangNum = 3
    end
    if mysecondaryjob == "launder" then
        gangNum = 4
    end
    if mysecondaryjob == "weedh" then
        gangNum = 1
    end
    if mysecondaryjob == "cocaineh" then
        gangNum = 2
    end
    if mysecondaryjob == "gunsh" then
        gangNum = 3
    end
    if mysecondaryjob == "launderh" then
        gangNum = 4
    end

    local amount = 2

    if myGangReputation[uppedGang] > 80 and math.random(100) > 65 then
        amount = amount + 1
    end

    if myGangReputation[uppedGang] > 150 then
        amount = amount + math.random(2)
    end

    TriggerServerEvent("gang:updateAILevel",gangNum,uppedGang,amount)

end








function ensureLimits()
 
    if myGangReputation["mexican"] < 0 then
        myGangReputation["mexican"] = 0
    end

    if myGangReputation["mexican"] > 200 then
        myGangReputation["mexican"] = 200
    end

    if myGangReputation["salva"] < 0 then
        myGangReputation["salva"] = 0
    end

    if myGangReputation["salva"] > 200 then
        myGangReputation["salva"] = 200
    end

    if myGangReputation["weicheng"] < 0 then
        myGangReputation["weicheng"] = 0
    end
    if myGangReputation["weicheng"] > 200 then
        myGangReputation["weicheng"] = 200
    end

    if myGangReputation["family"] < 0 then
        myGangReputation["family"] = 0
    end

    if myGangReputation["family"] > 200 then
        myGangReputation["family"] = 200
    end

    if myGangReputation["ballas"] < 0 then
        myGangReputation["ballas"] = 0
    end

    if myGangReputation["ballas"] > 200 then
        myGangReputation["ballas"] = 200
    end 

    if myGangReputation["robbery"] < 0 then
        myGangReputation["robbery"] = 0
    end

    if myGangReputation["robbery"] > 200 then
        myGangReputation["robbery"] = 200
    end 

    TriggerEvent("gang:updateClientReputation",myGangReputation["mexican"], myGangReputation["salva"], myGangReputation["weicheng"], myGangReputation["family"], myGangReputation["ballas"], myGangReputation["robbery"])         

    TriggerServerEvent("gang:updateClientReputation",myGangReputation["mexican"], myGangReputation["salva"], myGangReputation["weicheng"], myGangReputation["family"], myGangReputation["ballas"], myGangReputation["robbery"])         


end


function checkAmounts()
    weed,cocaine,guns,launder,stolengoods = getQuantitys()


    if salecost["weed"] <= weed and salecost["cocaine"] <= cocaine and salecost["guns"] <= guns and salecost["launder"] <= launder and salecost["stolengoods"] <= stolengoods then
        Citizen.Trace("You had the product")
        return true
    else
        TriggerEvent("DoLongHudText","You dont have the required product - task failed.",18)
        return false
    end
end

plycoords = GetEntityCoords(PlayerPedId())
function setLocation()
    if taskinprogress then
        plycoords = GetEntityCoords(PlayerPedId())
        SetNewWaypoint(endResult["x"], endResult["y"])
        TriggerEvent("DoLongHudText","Delivery point updated. - " .. taskBrief,18)    
    else
        TriggerEvent("DoLongHudText","You are not currently on a delivery.",2)
    end
end

function taskStarted()

    local noticed = false
    timelimit = 600000
    while taskinprogress and timelimit > 0 do
        Citizen.Wait(1)
        timelimit = timelimit - 1
        endDistance = #(vector3(endResult["x"], endResult["y"], endResult["z"]) - GetEntityCoords(PlayerPedId()))
        if endDistance < 50.0 then
            plycoords = GetEntityCoords(PlayerPedId())
            taskDoDeliveryEnd()
        end
    end
    Citizen.Wait(15000)
    endTask()
end

function taskDoDeliveryEnd()
    local allowdropoff = false
    TriggerEvent("DoLongHudText","Do the deal!",18)
    deliveryVehicle()
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
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end



function FindEndPointCar(x,y)   
    local raceend = {}
    raceend["x"] = 0.0
    raceend["y"] = 0.0
    raceend["z"] = 30.0

    raceend["x"] = x + math.random(-500,500) + 1.0  
    raceend["y"] = y + math.random(-500,500) + 1.0  

    roadtest, vehSpawnResult, outHeading = GetClosestVehicleNode(raceend["x"], raceend["y"], raceend["z"],  0, 55.0, 55.0)

    return vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], outHeading
    --endResult["x"], endResult["y"], endResult["z"]
end

function FindEndPointLocal(x,y)   
    local raceend = {}
    raceend["x"] = 0.0
    raceend["y"] = 0.0
    raceend["z"] = 30.0

    raceend["x"] = x + math.random(-500,500) + 1.0  
    raceend["y"] = y + math.random(-500,500) + 1.0  

    roadtest, endResult, outHeading = GetClosestVehicleNode(raceend["x"], raceend["y"], raceend["z"], 21, 999.9, 999.9)

    return endResult["x"], endResult["y"], endResult["z"]
    --endResult["x"], endResult["y"], endResult["z"]
end

function FindEndPointGlobal()   
    local raceend = {}
    raceend["x"] = 0.0
    raceend["y"] = 0.0
    raceend["z"] = 30.0

    raceend["x"] = math.random(-3000,3000) + 1.0  
    raceend["y"] = math.random(-1000,6500) + 1.0  

    roadtest, endResult, outHeading = GetClosestVehicleNode(raceend["x"], raceend["y"], raceend["z"], 21, 999.9, 999.9)

    return endResult["x"], endResult["y"], endResult["z"]
    --endResult["x"], endResult["y"], endResult["z"]
end

local canchangejob = false

local pagerON = false

RegisterNetEvent('togglePager')
AddEventHandler('togglePager', function()
    local extra = "OFF"
    pagerON = not pagerON
    if pagerON then extra = "ON" else extra = "OFF" end
    TriggerEvent("DoLongHudText", "Your email is now switched: " .. extra, 18)
    TriggerEvent("pagerStatus",pagerON)
end)

function DisplayPagerStatus()
    if pagerON then extra = "ON" else extra = "OFF" end
    TriggerEvent("DoLongHudText", "Your email filter settings are: " .. extra, 18)
    remBlips()
end

RegisterNetEvent('secondaryjob:ClientReturnDate')
AddEventHandler('secondaryjob:ClientReturnDate', function(varPassed)
    canchangejob = varPassed
end)

RegisterNetEvent('secondaryjob:weedStreet')
AddEventHandler('secondaryjob:weedStreet', function()
    if not canchangejob then
        TriggerEvent("DoLongHudText", "You can not change your job yet.",20)
        return 
    else
        mysecondaryjob = "weed"
        TriggerEvent("DoLongHudText", "You have updated your email filter Weed Street Dealer.",20)
        DisplayPagerStatus()
    end
    TriggerServerEvent("secondary:NewJobServer",mysecondaryjob)
    TriggerEvent("SecondaryJobUpdate",mysecondaryjob)
end)

RegisterNetEvent('secondaryjob:weedHigh')
AddEventHandler('secondaryjob:weedHigh', function()
    if not canchangejob then
        TriggerEvent("DoLongHudText", "You can not change your job yet.",20)
        return 
    else
        mysecondaryjob = "weedh"
        TriggerEvent("DoLongHudText", "You have updated your email filter Weed Distributor.",20)
        DisplayPagerStatus()
    end
    TriggerServerEvent("secondary:NewJobServer",mysecondaryjob)
    TriggerEvent("SecondaryJobUpdate",mysecondaryjob)
end)

RegisterNetEvent('secondaryjob:cocaineStreet')
AddEventHandler('secondaryjob:cocaineStreet', function()
    if not canchangejob then
        TriggerEvent("DoLongHudText", "You can not change your job yet.",20)
        return 
    else
        mysecondaryjob = "cocaine"
        TriggerEvent("DoLongHudText", "You have updated your email filter to Cocaine Street Dealer.",20)
        DisplayPagerStatus()
    end
    TriggerServerEvent("secondary:NewJobServer",mysecondaryjob)
    TriggerEvent("SecondaryJobUpdate",mysecondaryjob)
end)

RegisterNetEvent('secondaryjob:cocaineHigh')
AddEventHandler('secondaryjob:cocaineHigh', function()
    if not canchangejob then
        TriggerEvent("DoLongHudText", "You can not change your job yet.",20)
        return 
    else
        mysecondaryjob = "cocaineh"
        TriggerEvent("DoLongHudText", "You have updated your email filter to Cocaine Distributor.",20)
        DisplayPagerStatus()
    end
    TriggerServerEvent("secondary:NewJobServer",mysecondaryjob)
    TriggerEvent("SecondaryJobUpdate",mysecondaryjob)
end)

RegisterNetEvent('secondaryjob:gunStreet')
AddEventHandler('secondaryjob:gunStreet', function()
    if not canchangejob then
        TriggerEvent("DoLongHudText", "You can not change your job yet.",20)
        return 
    else
        mysecondaryjob = "guns"
        TriggerEvent("DoLongHudText", "You have updated your email filter to Gun Street Dealer.",20)
        DisplayPagerStatus()
    end
    TriggerServerEvent("secondary:NewJobServer",mysecondaryjob)
    TriggerEvent("SecondaryJobUpdate",mysecondaryjob)
end)

RegisterNetEvent('secondaryjob:gunHigh')
AddEventHandler('secondaryjob:gunHigh', function()
    if not canchangejob then
        TriggerEvent("DoLongHudText", "You can not change your job yet.",20)
        return 
    else
        mysecondaryjob = "gunsh"
        TriggerEvent("DoLongHudText", "You have updated your email filter to Gun Distributor.",20)
        DisplayPagerStatus()
    end
    TriggerServerEvent("secondary:NewJobServer",mysecondaryjob)
    TriggerEvent("SecondaryJobUpdate",mysecondaryjob)
end)




RegisterNetEvent('secondaryjob:gunSmith')
AddEventHandler('secondaryjob:gunSmith', function()
    if not canchangejob then
        TriggerEvent("DoLongHudText", "You can not change your job yet.",20)
        return 
    else
        mysecondaryjob = "gunsmith"
        TriggerEvent("DoLongHudText", "You have updated your email filter to Gun Crafter.",20)
        DisplayPagerStatus()
    end
    TriggerServerEvent("secondary:NewJobServer",mysecondaryjob)
    TriggerEvent("SecondaryJobUpdate",mysecondaryjob)
end)

RegisterNetEvent('secondaryjob:moneyStreet')
AddEventHandler('secondaryjob:moneyStreet', function()
    if not canchangejob then
        TriggerEvent("DoLongHudText", "You can not change your job yet.",20)
        return 
    else
        mysecondaryjob = "launder"
        TriggerEvent("DoLongHudText", "You have updated your email filter to Money Street Dealer.",20)
        DisplayPagerStatus()
    end
    TriggerServerEvent("secondary:NewJobServer",mysecondaryjob)
    TriggerEvent("SecondaryJobUpdate",mysecondaryjob)
end)

RegisterNetEvent('secondaryjob:moneyHigh')
AddEventHandler('secondaryjob:moneyHigh', function()
    if not canchangejob then
        TriggerEvent("DoLongHudText", "You can not change your job yet.",20)
        return 
    else
        mysecondaryjob = "launderh"
        TriggerEvent("DoLongHudText", "You have updated your email filter to Money Distributor.",20)
        DisplayPagerStatus()
    end
    TriggerServerEvent("secondary:NewJobServer",mysecondaryjob)
    TriggerEvent("SecondaryJobUpdate",mysecondaryjob)
end)


RegisterNetEvent('secondaryjob:moneyCleaner')
AddEventHandler('secondaryjob:moneyCleaner', function()
    if not canchangejob then
        TriggerEvent("DoLongHudText", "You can not change your job yet.",20)
        return 
    else
        mysecondaryjob = "moneyCleaner"
        TriggerEvent("DoLongHudText", "You have updated your email filter to Money Launderer.",20)
        DisplayPagerStatus()
    end
    TriggerServerEvent("secondary:NewJobServer",mysecondaryjob)
    TriggerEvent("SecondaryJobUpdate",mysecondaryjob)
end)





RegisterNetEvent('secondaryjob:startoffjob')
AddEventHandler('secondaryjob:startoffjob', function(job)
    mysecondaryjob = job
    if mysecondaryjob == "gunsmith" then
        drawGunCraftingMarkers()
    end
    if mysecondaryjob == "moneyCleaner" then
        drawMoneyCraftingMarkers()
    end

    TriggerEvent("SecondaryJobUpdate",mysecondaryjob)
end)

RegisterNetEvent('secondaryjob:removejob')
AddEventHandler('secondaryjob:removejob', function()
    mysecondaryjob = "none"
    TriggerServerEvent("secondary:NewJobServerWipe")
    TriggerEvent("DoLongHudText", "Your email filter has been removed.",20)
    TriggerEvent("SecondaryJobUpdate",mysecondaryjob)
end)

-- START DAT SHIT BOII selectSecondaryTask(mysecondaryjob)

--791 aids


function attemptDecrypt()
    if decrypting then
        TriggerEvent("DoLongHudText","Already in Progress",2)
        return
    end
    decryptType = 1
    TriggerEvent("DoLongHudText","Attempting Decryption")
    decrypting = true
  
    local usb = exports["np-inventory"]:hasEnoughOfItem("mk2usbdevice",1,false)
    local usb2 = exports["np-inventory"]:hasEnoughOfItem("usbdevice",1,false)
    local base = exports["np-inventory"]:hasEnoughOfItem("decryptersess",1,false)
    local expert = exports["np-inventory"]:hasEnoughOfItem("decrypterfv2",1,false)
    local expert2 = exports["np-inventory"]:hasEnoughOfItem("decrypterenzo",1,false)

    if usb2 then
        TriggerEvent("DoLongHudText","Conflicting USB device detected",2)
        decrypting = false
        return false
    end

    if not usb then
        TriggerEvent("DoLongHudText","No USB device detected",2)
        decrypting = false
        return false
    end

    if not expert and not base and not expert2 then
        TriggerEvent("DoLongHudText","No decryption device detected",2)
        decrypting = false
        return false
    end

    if expert2 then
        Citizen.Wait(3000)
        decryptType = 3
    elseif expert then
        Citizen.Wait(15000)
        decryptType = 2
    elseif base then
        Citizen.Wait(30000)
        decryptType = 1
    end

    local vol = 0.9
    local pickS = math.random(4)
    if pickS == 4 then
        TriggerEvent("InteractSound_CL:PlayOnOne","radiostatic1",vol)
    elseif pickS == 3 then
        TriggerEvent("InteractSound_CL:PlayOnOne","radiostatic2",vol)
    elseif pickS == 2 then
        TriggerEvent("InteractSound_CL:PlayOnOne","radiostatic3",vol)
    else
        TriggerEvent("InteractSound_CL:PlayOnOne","radioclick",vol)
    end
    TriggerEvent("DoLongHudText","Decryption Successful",2)

    decrypting = false
    return true
end

RegisterNetEvent('secondaryjob:accepttask')
AddEventHandler('secondaryjob:accepttask', function()

    local decrypted = attemptDecrypt()
    if not decrypted then
        return
    end



    if taskinprogress then
        SetNewWaypoint(endResult["x"], endResult["y"])
    else
        if taskenabled then
            selectSecondaryTask(mysecondaryjob)
            taskenabled = false
        end
        if not candecrypt then
            TriggerEvent("DoLongHudText", "Nothing to Decrypt!")
        end
    end
end)

RegisterNetEvent('secondaryjob:endtask')
AddEventHandler('secondaryjob:endtask', function()
    if taskenabled then
        TriggerEvent("DoLongHudText", "Cleared out last task!")
    else
        TriggerEvent("DoLongHudText", "You currently have no task!")
    end
    endTask()
end)

taskenabled = false


local markerNames = {
    [1] = { ["name"] = "mexican", ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0 },
    [2] = { ["name"] = "salva", ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0 },
    [3] = { ["name"] = "weicheng", ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0 },   
    [4] = { ["name"] = "family", ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0 },
    [5] = { ["name"] = "ballas", ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0 },
}

local curCraftGang = "none"
local dist = 0
--craft:freeCraft

function BreakDownCrate()

end


function DrawText3Ds2(x,y,z, text,dist)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.29, (0.50 - (dist / 120)))
    local dist = math.floor(dist - (dist * 5))
    SetTextFont(2)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, dist)
    SetTextDropshadow(0, 0, 0, 0, dist)
    SetTextEdge(1, 0, 0, 0, 250)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end



local firstspawn = false
local blips = {

}
local blipresult = {}
function drawMoneyCraftingMarkers()

    if firstspawn then
        for i = 1, #blips do
            RemoveBlip(blips[i])
        end
    end
    TriggerEvent("resetmoneyhouses")
    for i = 1, #markerNames do
        local houseluck = math.random(500)
        TriggerEvent("moneyhouse",houseluck,markerNames[i]["name"])
        moneyhouses["house"..i] = houseluck
        blipResult = crafthouses[houseluck]
        markerNames[i]["x"] = blipResult["x"]
        markerNames[i]["y"] = blipResult["y"]
        markerNames[i]["z"] = blipResult["z"]        
        blips[i] = AddBlipForCoord(markerNames[i]["x"],markerNames[i]["y"],markerNames[i]["z"])
        SetBlipSprite(blips[i], 108)
        SetBlipScale(blips[i], 0.35)
        SetBlipAsShortRange(blips[i], true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Money Cleaning: " .. markerNames[i]["name"])
        EndTextCommandSetBlipName(blips[i])
    end

    TriggerEvent("DoLongHudText", "Money Cleaning Locations have been updated - crafting in specific zones increases the launder trades reputation for that gang. The more areas they control, the more sets they can supply.")

    firstspawn = true
end
    
function drawGunCraftingMarkers()

    if firstspawn then
        for i = 1, #blips do
            RemoveBlip(blips[i])
        end
    end
    TriggerEvent("resetcraftinghouses")
    for i = 1, #markerNames do
        local houseluck = math.random(500)
        TriggerEvent("crafthouse",houseluck,markerNames[i]["name"])
        crafthouses["house"..i] = houseluck
        blipResult = crafthouses[houseluck]
        markerNames[i]["x"] = blipResult["x"]
        markerNames[i]["y"] = blipResult["y"]
        markerNames[i]["z"] = blipResult["z"]        
        blips[i] = AddBlipForCoord(markerNames[i]["x"],markerNames[i]["y"],markerNames[i]["z"])
        SetBlipSprite(blips[i], 110)
        SetBlipScale(blips[i], 0.35)
        SetBlipAsShortRange(blips[i], true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Gun Creation: " .. markerNames[i]["name"])
        EndTextCommandSetBlipName(blips[i])
    end

    TriggerEvent("DoLongHudText", "Gun Crafting Locations have been updated - crafting in specific zones increases the gun trades reputation for that gang. The more areas they control, the more parts they can supply.")

    firstspawn = true
end
    


function blipLocation(x,y,z)
    while true do
        blipResult = {}
        blipResult["x"], blipResult["y"], blipResult["z"] = FindEndPointLocal(x,y)
        Citizen.Wait(10)
        if blipResult["z"] ~= 0.0 then
            Citizen.Trace(blipResult["x"])
            return
        end
    end
end

function remBlips()
    for i = 1, #blips do
        RemoveBlip(blips[i])
    end
end















crafthouses = {
[1] =  { ['x'] = 1061.04,['y'] = -378.61,['z'] = 68.24,['h'] = 37.87, ['info'] = ' West Mirror Drive 1' },
[2] =  { ['x'] = 1029.42,['y'] = -408.96,['z'] = 65.95,['h'] = 38.91, ['info'] = ' West Mirror Drive 2' },
[3] =  { ['x'] = 1011.27,['y'] = -422.89,['z'] = 64.96,['h'] = 121.8, ['info'] = ' West Mirror Drive 3' },
[4] =  { ['x'] = 988.2,['y'] = -433.74,['z'] = 63.9,['h'] = 34.72, ['info'] = ' West Mirror Drive 4' },
[5] =  { ['x'] = 967.9,['y'] = -452.62,['z'] = 62.41,['h'] = 32.83, ['info'] = ' West Mirror Drive 5' },
[6] =  { ['x'] = 943.26,['y'] = -463.9,['z'] = 61.4,['h'] = 299.36, ['info'] = ' West Mirror Drive 6' },
[7] =  { ['x'] = 922.18,['y'] = -478.69,['z'] = 61.09,['h'] = 22.83, ['info'] = ' West Mirror Drive 7' },
[8] =  { ['x'] = 906.58,['y'] = -489.69,['z'] = 59.44,['h'] = 29.93, ['info'] = ' West Mirror Drive 8' },
[9] =  { ['x'] = 878.99,['y'] = -498.51,['z'] = 57.88,['h'] = 46.17, ['info'] = ' West Mirror Drive 9' },
[10] =  { ['x'] = 862.28,['y'] = -509.58,['z'] = 57.33,['h'] = 48.03, ['info'] = ' West Mirror Drive 10' },
[11] =  { ['x'] = 851.09,['y'] = -532.73,['z'] = 57.93,['h'] = 84.22, ['info'] = ' West Mirror Drive 11' },
[12] =  { ['x'] = 844.37,['y'] = -563.77,['z'] = 57.84,['h'] = 15.0, ['info'] = ' West Mirror Drive 12' },
[13] =  { ['x'] = 861.92,['y'] = -582.26,['z'] = 58.16,['h'] = 170.48, ['info'] = ' West Mirror Drive 13' },
[14] =  { ['x'] = 887.43,['y'] = -607.54,['z'] = 58.22,['h'] = 133.7, ['info'] = ' West Mirror Drive 14' },
[15] =  { ['x'] = 903.47,['y'] = -615.87,['z'] = 58.46,['h'] = 48.6, ['info'] = ' West Mirror Drive 15' },
[16] =  { ['x'] = 929.51,['y'] = -639.12,['z'] = 58.25,['h'] = 139.34, ['info'] = ' West Mirror Drive 16' },
[17] =  { ['x'] = 943.4,['y'] = -653.71,['z'] = 58.43,['h'] = 36.32, ['info'] = ' West Mirror Drive 17' },
[18] =  { ['x'] = 960.54,['y'] = -669.38,['z'] = 58.45,['h'] = 122.8, ['info'] = ' West Mirror Drive 18' },
[19] =  { ['x'] = 970.9,['y'] = -701.41,['z'] = 58.49,['h'] = 168.31, ['info'] = ' West Mirror Drive 19' },
[20] =  { ['x'] = 979.49,['y'] = -715.95,['z'] = 58.22,['h'] = 131.16, ['info'] = ' West Mirror Drive 20' },
[21] =  { ['x'] = 997.52,['y'] = -729.0,['z'] = 57.82,['h'] = 128.93, ['info'] = ' West Mirror Drive 21' },
[22] =  { ['x'] = 979.92,['y'] = -627.24,['z'] = 59.24,['h'] = 215.31, ['info'] = ' West Mirror Drive 22' },
[23] =  { ['x'] = 892.79,['y'] = -540.7,['z'] = 58.51,['h'] = 295.06, ['info'] = ' West Mirror Drive 23' },
[24] =  { ['x'] = 924.02,['y'] = -525.3,['z'] = 59.58,['h'] = 208.51, ['info'] = ' West Mirror Drive 24' },
[25] =  { ['x'] = 946.26,['y'] = -518.79,['z'] = 60.63,['h'] = 122.26, ['info'] = ' West Mirror Drive 25' },
[26] =  { ['x'] = 969.57,['y'] = -502.1,['z'] = 62.15,['h'] = 253.28, ['info'] = ' West Mirror Drive 26' },
[27] =  { ['x'] = 1014.14,['y'] = -468.72,['z'] = 64.29,['h'] = 214.9, ['info'] = ' West Mirror Drive 27' },
[28] =  { ['x'] = 1112.37,['y'] = -390.29,['z'] = 68.74,['h'] = 244.07, ['info'] = ' West Mirror Drive 28' },
[29] =  { ['x'] = 1263.96,['y'] = -429.2,['z'] = 69.81,['h'] = 111.8, ['info'] = ' East Mirror Drive 1' },
[30] =  { ['x'] = 1266.76,['y'] = -457.85,['z'] = 70.52,['h'] = 97.77, ['info'] = ' East Mirror Drive 2' },
[31] =  { ['x'] = 1260.28,['y'] = -479.9,['z'] = 70.19,['h'] = 112.32, ['info'] = ' East Mirror Drive 3' },
[32] =  { ['x'] = 1251.86,['y'] = -494.2,['z'] = 69.91,['h'] = 78.13, ['info'] = ' East Mirror Drive 4' },
[33] =  { ['x'] = 1251.5,['y'] = -515.63,['z'] = 69.35,['h'] = 75.67, ['info'] = ' East Mirror Drive 5' },
[34] =  { ['x'] = 1242.17,['y'] = -565.88,['z'] = 69.66,['h'] = 125.6, ['info'] = ' East Mirror Drive 6' },
[35] =  { ['x'] = 1241.1,['y'] = -601.67,['z'] = 69.59,['h'] = 92.86, ['info'] = ' East Mirror Drive 7' },
[36] =  { ['x'] = 1251.6,['y'] = -621.98,['z'] = 69.41,['h'] = 26.0, ['info'] = ' East Mirror Drive 8' },
[37] =  { ['x'] = 1265.41,['y'] = -647.89,['z'] = 67.93,['h'] = 199.31, ['info'] = ' East Mirror Drive 9' },
[38] =  { ['x'] = 1271.13,['y'] = -683.04,['z'] = 66.04,['h'] = 178.05, ['info'] = ' East Mirror Drive 10' },
[39] =  { ['x'] = 1265.94,['y'] = -703.52,['z'] = 64.56,['h'] = 61.26, ['info'] = ' East Mirror Drive 11' },
[40] =  { ['x'] = 1302.79,['y'] = -528.61,['z'] = 71.47,['h'] = 339.7, ['info'] = ' Nikola Place 1' },
[41] =  { ['x'] = 1327.76,['y'] = -535.86,['z'] = 72.45,['h'] = 255.65, ['info'] = ' Nikola Place 2' },
[42] =  { ['x'] = 1347.87,['y'] = -548.01,['z'] = 73.9,['h'] = 336.0, ['info'] = ' Nikola Place 3' },
[43] =  { ['x'] = 1372.97,['y'] = -555.69,['z'] = 74.69,['h'] = 244.2, ['info'] = ' Nikola Place 4' },
[44] =  { ['x'] = 1388.3,['y'] = -569.93,['z'] = 74.5,['h'] = 293.08, ['info'] = ' Nikola Place 5' },
[45] =  { ['x'] = 1385.47,['y'] = -592.93,['z'] = 74.49,['h'] = 231.77, ['info'] = ' Nikola Place 6' },
[46] =  { ['x'] = 1367.28,['y'] = -605.44,['z'] = 74.72,['h'] = 169.15, ['info'] = ' Nikola Place 7' },
[47] =  { ['x'] = 1341.63,['y'] = -597.5,['z'] = 74.71,['h'] = 50.55, ['info'] = ' Nikola Place 8' },
[48] =  { ['x'] = 1323.76,['y'] = -582.45,['z'] = 73.25,['h'] = 154.05, ['info'] = ' Nikola Place 9' },
[49] =  { ['x'] = 1301.24,['y'] = -573.21,['z'] = 71.74,['h'] = 160.82, ['info'] = ' Nikola Place 10' },
[50] =  { ['x'] = 1437.15,['y'] = -1492.97,['z'] = 63.44,['h'] = 340.13, ['info'] = ' Fudge Lane 1' },
[51] =  { ['x'] = 1379.49,['y'] = -1515.41,['z'] = 58.04,['h'] = 28.29, ['info'] = ' Fudge Lane 2' },
[52] =  { ['x'] = 1338.24,['y'] = -1524.22,['z'] = 54.59,['h'] = 354.77, ['info'] = ' Fudge Lane 3' },
[53] =  { ['x'] = 1316.2,['y'] = -1528.01,['z'] = 51.42,['h'] = 13.96, ['info'] = ' Fudge Lane 4' },
[54] =  { ['x'] = 1231.17,['y'] = -1591.76,['z'] = 53.56,['h'] = 31.72, ['info'] = ' Fudge Lane 5' },
[55] =  { ['x'] = 1205.91,['y'] = -1607.85,['z'] = 50.54,['h'] = 29.31, ['info'] = ' Fudge Lane 6' },
[56] =  { ['x'] = 1192.94,['y'] = -1622.69,['z'] = 45.23,['h'] = 304.06, ['info'] = ' Fudge Lane 7' },
[57] =  { ['x'] = 1192.82,['y'] = -1655.06,['z'] = 43.03,['h'] = 211.63, ['info'] = ' Fudge Lane 8' },
[58] =  { ['x'] = 1214.11,['y'] = -1643.33,['z'] = 48.65,['h'] = 207.97, ['info'] = ' Fudge Lane 9' },
[59] =  { ['x'] = 1244.78,['y'] = -1625.69,['z'] = 53.29,['h'] = 210.54, ['info'] = ' Fudge Lane 10' },
[60] =  { ['x'] = 1261.31,['y'] = -1616.26,['z'] = 54.75,['h'] = 210.56, ['info'] = ' Fudge Lane 11' },
[61] =  { ['x'] = 1286.4,['y'] = -1603.31,['z'] = 54.83,['h'] = 193.95, ['info'] = ' Fudge Lane 12' },
[62] =  { ['x'] = 1327.22,['y'] = -1552.61,['z'] = 54.06,['h'] = 228.68, ['info'] = ' Fudge Lane 13' },
[63] =  { ['x'] = 1360.39,['y'] = -1554.92,['z'] = 55.95,['h'] = 190.45, ['info'] = ' Fudge Lane 14' },
[64] =  { ['x'] = 1382.68,['y'] = -1544.46,['z'] = 57.11,['h'] = 124.25, ['info'] = ' Fudge Lane 15' },
[65] =  { ['x'] = 1365.25,['y'] = -1720.38,['z'] = 65.64,['h'] = 193.47, ['info'] = ' Amarillo Vista 1' },
[66] =  { ['x'] = 1315.17,['y'] = -1732.63,['z'] = 54.71,['h'] = 115.0, ['info'] = ' Amarillo Vista 2' },
[67] =  { ['x'] = 1295.86,['y'] = -1739.44,['z'] = 54.28,['h'] = 109.9, ['info'] = ' Amarillo Vista 3' },
[68] =  { ['x'] = 1258.81,['y'] = -1761.27,['z'] = 49.67,['h'] = 202.25, ['info'] = ' Amarillo Vista 4' },
[69] =  { ['x'] = 1251.01,['y'] = -1735.07,['z'] = 52.03,['h'] = 21.33, ['info'] = ' Amarillo Vista 5' },
[70] =  { ['x'] = 1289.66,['y'] = -1711.45,['z'] = 55.28,['h'] = 21.9, ['info'] = ' Amarillo Vista 7' },
[71] =  { ['x'] = 1316.97,['y'] = -1699.67,['z'] = 57.84,['h'] = 9.87, ['info'] = ' Amarillo Vista 8' },
[72] =  { ['x'] = 1355.45,['y'] = -1690.85,['z'] = 60.5,['h'] = 79.86, ['info'] = ' Amarillo Vista 9' },
[73] =  { ['x'] = -51.01,['y'] = -1783.87,['z'] = 28.31,['h'] = 314.06, ['info'] = ' Grove Street 1' },
[74] =  { ['x'] = -42.56,['y'] = -1792.78,['z'] = 27.83,['h'] = 313.07, ['info'] = ' Grove Street 2' },
[75] =  { ['x'] = 20.57,['y'] = -1844.12,['z'] = 24.61,['h'] = 227.62, ['info'] = ' Grove Street 3' },
[76] =  { ['x'] = 29.32,['y'] = -1853.94,['z'] = 24.07,['h'] = 226.91, ['info'] = ' Grove Street 4' },
[77] =  { ['x'] = 45.32,['y'] = -1864.99,['z'] = 23.28,['h'] = 314.88, ['info'] = ' Grove Street 5' },
[78] =  { ['x'] = 54.44,['y'] = -1873.17,['z'] = 22.81,['h'] = 313.76, ['info'] = ' Grove Street 6' },
[79] =  { ['x'] = 100.48,['y'] = -1913.0,['z'] = 21.21,['h'] = 331.75, ['info'] = ' Grove Street 7' },
[80] =  { ['x'] = 117.81,['y'] = -1920.55,['z'] = 21.33,['h'] = 237.12, ['info'] = ' Grove Street 8' },
[81] =  { ['x'] = 126.4,['y'] = -1929.47,['z'] = 21.39,['h'] = 208.24, ['info'] = ' Grove Street 9' },
[82] =  { ['x'] = 114.05,['y'] = -1960.69,['z'] = 21.34,['h'] = 201.85, ['info'] = ' Grove Street 10' },
[83] =  { ['x'] = 85.31,['y'] = -1959.0,['z'] = 21.13,['h'] = 231.11, ['info'] = ' Grove Street 11' },
[84] =  { ['x'] = 76.92,['y'] = -1948.61,['z'] = 21.18,['h'] = 47.14, ['info'] = ' Grove Street 12' },
[85] =  { ['x'] = 72.94,['y'] = -1938.5,['z'] = 21.17,['h'] = 134.56, ['info'] = ' Grove Street 13' },
[86] =  { ['x'] = 57.03,['y'] = -1922.37,['z'] = 21.92,['h'] = 138.82, ['info'] = ' Grove Street 14' },
[87] =  { ['x'] = 39.59,['y'] = -1911.99,['z'] = 21.96,['h'] = 48.9, ['info'] = ' Grove Street 15' },
[88] =  { ['x'] = 23.75,['y'] = -1895.77,['z'] = 22.78,['h'] = 138.51, ['info'] = ' Grove Street 16' },
[89] =  { ['x'] = 4.58,['y'] = -1883.77,['z'] = 23.7,['h'] = 230.16, ['info'] = ' Grove Street 17' },
[90] =  { ['x'] = -5.8,['y'] = -1871.52,['z'] = 24.16,['h'] = 231.79, ['info'] = ' Grove Street 18' },
[91] =  { ['x'] = -21.18,['y'] = -1858.15,['z'] = 25.4,['h'] = 231.24, ['info'] = ' Grove Street 19' },
[92] =  { ['x'] = -33.71,['y'] = -1847.46,['z'] = 26.2,['h'] = 50.24, ['info'] = ' Grove Street 20' },
[93] =  { ['x'] = -157.6,['y'] = -1680.11,['z'] = 33.44,['h'] = 48.52, ['info'] = ' Forum Drive 1/Apt1' },
[94] =  { ['x'] = -148.39,['y'] = -1688.04,['z'] = 32.88,['h'] = 318.72, ['info'] = ' Forum Drive 1/Apt2' },
[95] =  { ['x'] = -147.3,['y'] = -1688.99,['z'] = 32.88,['h'] = 318.81, ['info'] = ' Forum Drive 1/Apt3' },
[96] =  { ['x'] = -143.08,['y'] = -1692.38,['z'] = 32.88,['h'] = 277.39, ['info'] = ' Forum Drive 1/Apt4' },
[97] =  { ['x'] = -141.89,['y'] = -1693.43,['z'] = 32.88,['h'] = 225.74, ['info'] = ' Forum Drive 1/Apt5' },
[98] =  { ['x'] = -141.79,['y'] = -1693.55,['z'] = 36.17,['h'] = 229.58, ['info'] = ' Forum Drive 1/Apt6' },
[99] =  { ['x'] = -142.19,['y'] = -1692.69,['z'] = 36.17,['h'] = 321.38, ['info'] = ' Forum Drive 1/Apt7' },
[100] =  { ['x'] = -147.39,['y'] = -1688.39,['z'] = 36.17,['h'] = 318.94, ['info'] = ' Forum Drive 1/Apt8' },
[101] =  { ['x'] = -148.69,['y'] = -1687.35,['z'] = 36.17,['h'] = 313.56, ['info'] = ' Forum Drive 1/Apt9' },
[102] =  { ['x'] = -157.54,['y'] = -1679.61,['z'] = 36.97,['h'] = 354.25, ['info'] = ' Forum Drive 1/Apt10' },
[103] =  { ['x'] = -158.86,['y'] = -1680.02,['z'] = 36.97,['h'] = 38.57, ['info'] = ' Forum Drive 1/Apt11' },
[104] =  { ['x'] = -160.83,['y'] = -1637.93,['z'] = 34.03,['h'] = 157.6, ['info'] = ' Forum Drive 2/Apt1' },
[105] =  { ['x'] = -160.0,['y'] = -1636.41,['z'] = 34.03,['h'] = 324.29, ['info'] = ' Forum Drive 2/Apt2' },
[106] =  { ['x'] = -153.87,['y'] = -1641.77,['z'] = 36.86,['h'] = 331.14, ['info'] = ' Forum Drive 2/Apt3' },
[107] =  { ['x'] = -159.85,['y'] = -1636.42,['z'] = 37.25,['h'] = 321.05, ['info'] = ' Forum Drive 2/Apt4' },
[108] =  { ['x'] = -161.31,['y'] = -1638.13,['z'] = 37.25,['h'] = 142.21, ['info'] = ' Forum Drive 2/Apt5' },
[109] =  { ['x'] = -150.79,['y'] = -1625.26,['z'] = 33.66,['h'] = 233.56, ['info'] = ' Forum Drive 2/Apt6' },
[110] =  { ['x'] = -150.74,['y'] = -1622.68,['z'] = 33.66,['h'] = 57.73, ['info'] = ' Forum Drive 2/Apt7' },
[111] =  { ['x'] = -145.59,['y'] = -1617.88,['z'] = 36.05,['h'] = 222.51, ['info'] = ' Forum Drive 2/Apt8' },
[112] =  { ['x'] = -145.84,['y'] = -1614.71,['z'] = 36.05,['h'] = 67.64, ['info'] = ' Forum Drive 2/Apt9' },
[113] =  { ['x'] = -152.23,['y'] = -1624.37,['z'] = 36.85,['h'] = 52.69, ['info'] = ' Forum Drive 2/Apt10' },
[114] =  { ['x'] = -150.38,['y'] = -1625.5,['z'] = 36.85,['h'] = 233.14, ['info'] = ' Forum Drive 2/Apt11' },
[115] =  { ['x'] = -120.58,['y'] = -1575.04,['z'] = 34.18,['h'] = 323.0, ['info'] = ' Forum Drive 3/Apt1' },
[116] =  { ['x'] = -114.73,['y'] = -1579.95,['z'] = 34.18,['h'] = 318.74, ['info'] = ' Forum Drive 3/Apt2' },
[117] =  { ['x'] = -119.6,['y'] = -1585.41,['z'] = 34.22,['h'] = 231.94, ['info'] = ' Forum Drive 3/Apt3' },
[118] =  { ['x'] = -123.81,['y'] = -1590.67,['z'] = 34.21,['h'] = 234.7, ['info'] = ' Forum Drive 3/Apt4' },
[119] =  { ['x'] = -139.85,['y'] = -1598.7,['z'] = 34.84,['h'] = 158.58, ['info'] = ' Forum Drive 3/Apt6' },
[120] =  { ['x'] = -146.85,['y'] = -1596.64,['z'] = 34.84,['h'] = 69.8, ['info'] = ' Forum Drive 3/Apt7' },
[121] =  { ['x'] = -139.49,['y'] = -1588.39,['z'] = 34.25,['h'] = 47.69, ['info'] = ' Forum Drive 3/Apt8' },
[122] =  { ['x'] = -133.47,['y'] = -1581.2,['z'] = 34.21,['h'] = 49.62, ['info'] = ' Forum Drive 3/Apt9' },
[123] =  { ['x'] = -120.63,['y'] = -1575.05,['z'] = 37.41,['h'] = 320.29, ['info'] = ' Forum Drive 3/Apt10' },
[124] =  { ['x'] = -114.71,['y'] = -1580.4,['z'] = 37.41,['h'] = 322.64, ['info'] = ' Forum Drive 3/Apt11' },
[125] =  { ['x'] = -119.53,['y'] = -1585.26,['z'] = 37.41,['h'] = 228.33, ['info'] = ' Forum Drive 3/Apt12' },
[126] =  { ['x'] = -123.67,['y'] = -1590.39,['z'] = 37.41,['h'] = 223.58, ['info'] = ' Forum Drive 3/Apt13' },
[127] =  { ['x'] = -140.08,['y'] = -1598.75,['z'] = 38.22,['h'] = 157.57, ['info'] = ' Forum Drive 3/Apt15' },
[128] =  { ['x'] = -145.81,['y'] = -1597.55,['z'] = 38.22,['h'] = 99.24, ['info'] = ' Forum Drive 3/Apt16' },
[129] =  { ['x'] = -147.47,['y'] = -1596.26,['z'] = 38.22,['h'] = 55.87, ['info'] = ' Forum Drive 3/Apt17' },
[130] =  { ['x'] = -139.77,['y'] = -1587.8,['z'] = 37.41,['h'] = 50.77, ['info'] = ' Forum Drive 3/Apt18' },
[131] =  { ['x'] = -133.78,['y'] = -1580.56,['z'] = 37.41,['h'] = 54.61, ['info'] = ' Forum Drive 3/Apt19' },
[132] =  { ['x'] = 16.5,['y'] = -1443.77,['z'] = 30.95,['h'] = 336.17, ['info'] = ' Forum Drive 4' },
[133] =  { ['x'] = -1.98,['y'] = -1442.55,['z'] = 30.97,['h'] = 1.65, ['info'] = ' Forum Drive 5' },
[134] =  { ['x'] = -32.87,['y'] = -1446.34,['z'] = 31.9,['h'] = 269.71, ['info'] = ' Forum Drive 7' },
[135] =  { ['x'] = -45.73,['y'] = -1445.58,['z'] = 32.43,['h'] = 274.72, ['info'] = ' Forum Drive 8' },
[136] =  { ['x'] = -64.48,['y'] = -1449.57,['z'] = 32.53,['h'] = 99.6, ['info'] = ' Forum Drive 9' },
[137] =  { ['x'] = -167.71,['y'] = -1534.71,['z'] = 35.1,['h'] = 320.29, ['info'] = ' Forum Drive 10/Apt1' },
[138] =  { ['x'] = -180.71,['y'] = -1553.51,['z'] = 35.13,['h'] = 227.11, ['info'] = ' Forum Drive 10/Apt2' },
[139] =  { ['x'] = -187.47,['y'] = -1562.96,['z'] = 35.76,['h'] = 220.56, ['info'] = ' Forum Drive 10/Apt3' },
[140] =  { ['x'] = -191.86,['y'] = -1559.4,['z'] = 34.96,['h'] = 124.57, ['info'] = ' Forum Drive 10/Apt4' },
[141] =  { ['x'] = -195.55,['y'] = -1556.06,['z'] = 34.96,['h'] = 45.83, ['info'] = ' Forum Drive 10/Apt5' },
[142] =  { ['x'] = -183.81,['y'] = -1540.59,['z'] = 34.36,['h'] = 41.2, ['info'] = ' Forum Drive 10/Apt6' },
[143] =  { ['x'] = -179.69,['y'] = -1534.66,['z'] = 34.36,['h'] = 44.71, ['info'] = ' Forum Drive 10/Apt7' },
[144] =  { ['x'] = -175.06,['y'] = -1529.53,['z'] = 34.36,['h'] = 321.99, ['info'] = ' Forum Drive 10/Apt8' },
[145] =  { ['x'] = -167.62,['y'] = -1534.9,['z'] = 38.33,['h'] = 320.46, ['info'] = ' Forum Drive 10/Apt10' },
[146] =  { ['x'] = -180.19,['y'] = -1553.89,['z'] = 38.34,['h'] = 232.72, ['info'] = ' Forum Drive 10/Apt11' },
[147] =  { ['x'] = -186.63,['y'] = -1562.32,['z'] = 39.14,['h'] = 198.53, ['info'] = ' Forum Drive 10/Apt12' },
[148] =  { ['x'] = -188.32,['y'] = -1562.5,['z'] = 39.14,['h'] = 136.16, ['info'] = ' Forum Drive 10/Apt13' },
[149] =  { ['x'] = -192.14,['y'] = -1559.64,['z'] = 38.34,['h'] = 136.93, ['info'] = ' Forum Drive 10/Apt14' },
[150] =  { ['x'] = -195.77,['y'] = -1555.92,['z'] = 38.34,['h'] = 48.33, ['info'] = ' Forum Drive 10/Apt15' },
[151] =  { ['x'] = -184.06,['y'] = -1539.83,['z'] = 37.54,['h'] = 47.47, ['info'] = ' Forum Drive 10/Apt16' },
[152] =  { ['x'] = -179.58,['y'] = -1534.93,['z'] = 37.54,['h'] = 48.0, ['info'] = ' Forum Drive 10/Apt17' },
[153] =  { ['x'] = -174.87,['y'] = -1529.18,['z'] = 37.54,['h'] = 321.05, ['info'] = ' Forum Drive 10/Apt18' },
[154] =  { ['x'] = -208.75,['y'] = -1600.32,['z'] = 34.87,['h'] = 259.54, ['info'] = ' Forum Drive 11/Apt1' },
[155] =  { ['x'] = -210.05,['y'] = -1607.17,['z'] = 34.87,['h'] = 259.85, ['info'] = ' Forum Drive 11/Apt2' },
[156] =  { ['x'] = -212.05,['y'] = -1616.86,['z'] = 34.87,['h'] = 244.26, ['info'] = ' Forum Drive 11/Apt3' },
[157] =  { ['x'] = -213.8,['y'] = -1618.07,['z'] = 34.87,['h'] = 180.98, ['info'] = ' Forum Drive 11/Apt4' },
[158] =  { ['x'] = -221.82,['y'] = -1617.45,['z'] = 34.87,['h'] = 88.95, ['info'] = ' Forum Drive 11/Apt5' },
[159] =  { ['x'] = -223.06,['y'] = -1601.38,['z'] = 34.89,['h'] = 97.48, ['info'] = ' Forum Drive 11/Apt6' },
[160] =  { ['x'] = -222.52,['y'] = -1585.71,['z'] = 34.87,['h'] = 84.43, ['info'] = ' Forum Drive 11/Apt7' },
[161] =  { ['x'] = -218.91,['y'] = -1580.06,['z'] = 34.87,['h'] = 47.27, ['info'] = ' Forum Drive 11/Apt8' },
[162] =  { ['x'] = -216.48,['y'] = -1577.45,['z'] = 34.87,['h'] = 321.55, ['info'] = ' Forum Drive 11/Apt9' },
[163] =  { ['x'] = -206.23,['y'] = -1585.55,['z'] = 34.87,['h'] = 260.2, ['info'] = ' Forum Drive 11/Apt10' },
[164] =  { ['x'] = -206.63,['y'] = -1585.8,['z'] = 38.06,['h'] = 275.39, ['info'] = ' Forum Drive 11/Apt12' },
[165] =  { ['x'] = -216.05,['y'] = -1576.86,['z'] = 38.06,['h'] = 319.06, ['info'] = ' Forum Drive 11/Apt13' },
[166] =  { ['x'] = -218.37,['y'] = -1579.89,['z'] = 38.06,['h'] = 67.83, ['info'] = ' Forum Drive 11/Apt14' },
[167] =  { ['x'] = -222.25,['y'] = -1585.37,['z'] = 38.06,['h'] = 96.11, ['info'] = ' Forum Drive 11/Apt15' },
[168] =  { ['x'] = -222.26,['y'] = -1600.93,['z'] = 38.06,['h'] = 90.9, ['info'] = ' Forum Drive 11/Apt16' },
[169] =  { ['x'] = -222.21,['y'] = -1617.39,['z'] = 38.06,['h'] = 93.88, ['info'] = ' Forum Drive 11/Apt17' },
[170] =  { ['x'] = -214.12,['y'] = -1617.62,['z'] = 38.06,['h'] = 218.57, ['info'] = ' Forum Drive 11/Apt18' },
[171] =  { ['x'] = -212.29,['y'] = -1617.34,['z'] = 38.06,['h'] = 253.87, ['info'] = ' Forum Drive 11/Apt19' },
[172] =  { ['x'] = -210.46,['y'] = -1607.36,['z'] = 38.05,['h'] = 263.82, ['info'] = ' Forum Drive 11/Apt20' },
[173] =  { ['x'] = -209.45,['y'] = -1600.57,['z'] = 38.05,['h'] = 269.99, ['info'] = ' Forum Drive 11/Apt21' },
[174] =  { ['x'] = -216.64,['y'] = -1673.73,['z'] = 34.47,['h'] = 179.38, ['info'] = ' Forum Drive 12/Apt1' },
[175] =  { ['x'] = -224.15,['y'] = -1673.67,['z'] = 34.47,['h'] = 169.52, ['info'] = ' Forum Drive 12/Apt2' },
[176] =  { ['x'] = -224.17,['y'] = -1666.14,['z'] = 34.47,['h'] = 82.29, ['info'] = ' Forum Drive 12/Apt3' },
[177] =  { ['x'] = -224.32,['y'] = -1649.0,['z'] = 34.86,['h'] = 85.83, ['info'] = ' Forum Drive 12/Apt4' },
[178] =  { ['x'] = -216.34,['y'] = -1648.94,['z'] = 34.47,['h'] = 356.29, ['info'] = ' Forum Drive 12/Apt5' },
[179] =  { ['x'] = -212.92,['y'] = -1660.54,['z'] = 34.47,['h'] = 256.79, ['info'] = ' Forum Drive 12/Apt6' },
[180] =  { ['x'] = -212.95,['y'] = -1667.96,['z'] = 34.47,['h'] = 264.8, ['info'] = ' Forum Drive 12/Apt7' },
[181] =  { ['x'] = -216.55,['y'] = -1673.88,['z'] = 37.64,['h'] = 175.17, ['info'] = ' Forum Drive 12/Apt8' },
[182] =  { ['x'] = -224.34,['y'] = -1673.79,['z'] = 37.64,['h'] = 175.13, ['info'] = ' Forum Drive 12/Apt9' },
[183] =  { ['x'] = -223.99,['y'] = -1666.29,['z'] = 37.64,['h'] = 86.27, ['info'] = ' Forum Drive 12/Apt10' },
[184] =  { ['x'] = -224.44,['y'] = -1653.99,['z'] = 37.64,['h'] = 87.81, ['info'] = ' Forum Drive 12/Apt11' },
[185] =  { ['x'] = -223.96,['y'] = -1649.16,['z'] = 38.45,['h'] = 353.99, ['info'] = ' Forum Drive 12/Apt12' },
[186] =  { ['x'] = -216.44,['y'] = -1649.13,['z'] = 37.64,['h'] = 352.36, ['info'] = ' Forum Drive 12/Apt13' },
[187] =  { ['x'] = -212.85,['y'] = -1660.74,['z'] = 37.64,['h'] = 269.04, ['info'] = ' Forum Drive 12/Apt14' },
[188] =  { ['x'] = -212.72,['y'] = -1668.23,['z'] = 37.64,['h'] = 272.59, ['info'] = ' Forum Drive 12/Apt15' },
[189] =  { ['x'] = 207.81,['y'] = -1894.66,['z'] = 24.82,['h'] = 226.76, ['info'] = ' Covenant Avenue 1' },
[190] =  { ['x'] = 192.27,['y'] = -1884.01,['z'] = 24.86,['h'] = 333.42, ['info'] = ' Covenant Avenue 2' },
[191] =  { ['x'] = 170.9,['y'] = -1871.29,['z'] = 24.41,['h'] = 238.08, ['info'] = ' Covenant Avenue 3' },
[192] =  { ['x'] = 149.69,['y'] = -1865.39,['z'] = 24.6,['h'] = 339.99, ['info'] = ' Covenant Avenue 4' },
[193] =  { ['x'] = 130.2,['y'] = -1854.03,['z'] = 25.06,['h'] = 331.31, ['info'] = ' Covenant Avenue 5' },
[194] =  { ['x'] = 104.32,['y'] = -1884.78,['z'] = 24.32,['h'] = 143.76, ['info'] = ' Covenant Avenue 6' },
[195] =  { ['x'] = 114.95,['y'] = -1887.7,['z'] = 23.93,['h'] = 241.36, ['info'] = ' Covenant Avenue 7' },
[196] =  { ['x'] = 127.69,['y'] = -1896.79,['z'] = 23.68,['h'] = 248.34, ['info'] = ' Covenant Avenue 8' },
[197] =  { ['x'] = 148.81,['y'] = -1904.41,['z'] = 23.54,['h'] = 155.7, ['info'] = ' Covenant Avenue 9' },

[198] =  { ['x'] = -1071.77,['y'] = -1566.08,['z'] = 4.39,['h'] = 99.92, ['info'] = ' Beachside Court 13' },
[199] =  { ['x'] = -1073.94,['y'] = -1562.36,['z'] = 4.46,['h'] = 300.25, ['info'] = ' Beachside Court 14' },
[200] =  { ['x'] = -1066.23,['y'] = -1545.34,['z'] = 4.91,['h'] = 208.82, ['info'] = ' Beachside Court 15' },


[201] =  { ['x'] = -113.52,['y'] = -1478.46,['z'] = 33.83,['h'] = 226.49, ['info'] = ' Carson Avenue 1/Apt1' },
[202] =  { ['x'] = -108.04,['y'] = -1473.11,['z'] = 33.83,['h'] = 225.6, ['info'] = ' Carson Avenue 1/Apt2' },
[203] =  { ['x'] = -113.89,['y'] = -1468.64,['z'] = 33.83,['h'] = 321.96, ['info'] = ' Carson Avenue 1/Apt3' },
[204] =  { ['x'] = -123.05,['y'] = -1460.05,['z'] = 33.83,['h'] = 317.58, ['info'] = ' Carson Avenue 1/Apt4' },
[205] =  { ['x'] = -126.68,['y'] = -1456.71,['z'] = 34.57,['h'] = 320.2, ['info'] = ' Carson Avenue 1/Apt5' },
[206] =  { ['x'] = -131.8,['y'] = -1463.15,['z'] = 33.83,['h'] = 49.07, ['info'] = ' Carson Avenue 1/Apt6' },
[207] =  { ['x'] = -125.47,['y'] = -1473.1,['z'] = 33.83,['h'] = 142.11, ['info'] = ' Carson Avenue 1/Apt7' },
[208] =  { ['x'] = -119.61,['y'] = -1478.11,['z'] = 33.83,['h'] = 135.81, ['info'] = ' Carson Avenue 1/Apt8' },
[209] =  { ['x'] = -122.98,['y'] = -1460.25,['z'] = 37.0,['h'] = 320.71, ['info'] = ' Carson Avenue 1/Apt9' },
[210] =  { ['x'] = -127.02,['y'] = -1457.18,['z'] = 37.8,['h'] = 52.77, ['info'] = ' Carson Avenue 1/Apt10' },
[211] =  { ['x'] = -131.92,['y'] = -1463.16,['z'] = 37.0,['h'] = 49.86, ['info'] = ' Carson Avenue 1/Apt11' },
[212] =  { ['x'] = -138.15,['y'] = -1470.49,['z'] = 37.0,['h'] = 139.34, ['info'] = ' Carson Avenue 1/Apt12' },
[213] =  { ['x'] = -125.48,['y'] = -1473.39,['z'] = 37.0,['h'] = 144.5, ['info'] = ' Carson Avenue 1/Apt13' },
[214] =  { ['x'] = -119.87,['y'] = -1477.81,['z'] = 37.0,['h'] = 143.58, ['info'] = ' Carson Avenue 1/Apt14' },
[215] =  { ['x'] = -77.1,['y'] = -1515.61,['z'] = 34.25,['h'] = 44.81, ['info'] = ' Carson Avenue 2/Apt1' },
[216] =  { ['x'] = -71.74,['y'] = -1508.33,['z'] = 33.44,['h'] = 40.4, ['info'] = ' Carson Avenue 2/Apt2' },
[217] =  { ['x'] = -65.73,['y'] = -1513.55,['z'] = 33.44,['h'] = 318.02, ['info'] = ' Carson Avenue 2/Apt3' },
[218] =  { ['x'] = -60.39,['y'] = -1517.48,['z'] = 33.44,['h'] = 319.04, ['info'] = ' Carson Avenue 2/Apt4' },
[219] =  { ['x'] = -54.1,['y'] = -1523.19,['z'] = 33.44,['h'] = 235.48, ['info'] = ' Carson Avenue 2/Apt5' },
[220] =  { ['x'] = -59.84,['y'] = -1530.35,['z'] = 34.24,['h'] = 231.22, ['info'] = ' Carson Avenue 2/Apt6' },
[221] =  { ['x'] = -62.18,['y'] = -1532.27,['z'] = 34.24,['h'] = 136.83, ['info'] = ' Carson Avenue 2/Apt7' },
[222] =  { ['x'] = -68.86,['y'] = -1526.34,['z'] = 34.24,['h'] = 132.44, ['info'] = ' Carson Avenue 2/Apt8' },
[223] =  { ['x'] = -77.3,['y'] = -1515.62,['z'] = 37.42,['h'] = 48.47, ['info'] = ' Carson Avenue 2/Apt9' },
[224] =  { ['x'] = -71.37,['y'] = -1508.76,['z'] = 36.63,['h'] = 42.69, ['info'] = ' Carson Avenue 2/Apt10' },
[225] =  { ['x'] = -65.85,['y'] = -1513.39,['z'] = 36.63,['h'] = 319.16, ['info'] = ' Carson Avenue 2/Apt11' },
[226] =  { ['x'] = -61.03,['y'] = -1517.82,['z'] = 36.63,['h'] = 316.66, ['info'] = ' Carson Avenue 2/Apt12' },
[227] =  { ['x'] = -54.23,['y'] = -1523.33,['z'] = 36.63,['h'] = 229.97, ['info'] = ' Carson Avenue 2/Apt13' },
[228] =  { ['x'] = -60.03,['y'] = -1530.35,['z'] = 37.42,['h'] = 226.15, ['info'] = ' Carson Avenue 2/Apt14' },
[229] =  { ['x'] = -61.53,['y'] = -1532.14,['z'] = 37.42,['h'] = 136.13, ['info'] = ' Carson Avenue 2/Apt15' },
[230] =  { ['x'] = -68.59,['y'] = -1526.2,['z'] = 37.42,['h'] = 137.9, ['info'] = ' Carson Avenue 2/Apt16' },
[231] =  { ['x'] = -35.11,['y'] = -1554.6,['z'] = 30.68,['h'] = 129.72, ['info'] = ' Strawberry Avenue 1/Apt1' },
[232] =  { ['x'] = -44.33,['y'] = -1547.29,['z'] = 31.27,['h'] = 51.34, ['info'] = ' Strawberry Avenue 1/Apt2' },
[233] =  { ['x'] = -36.07,['y'] = -1537.29,['z'] = 31.25,['h'] = 47.34, ['info'] = ' Strawberry Avenue 1/Apt3' },
[234] =  { ['x'] = -26.48,['y'] = -1544.33,['z'] = 30.68,['h'] = 310.44, ['info'] = ' Strawberry Avenue 1/Apt4' },
[235] =  { ['x'] = -20.54,['y'] = -1550.16,['z'] = 30.68,['h'] = 230.04, ['info'] = ' Strawberry Avenue 1/Apt5' },
[236] =  { ['x'] = -25.49,['y'] = -1556.28,['z'] = 30.69,['h'] = 224.38, ['info'] = ' Strawberry Avenue 1/Apt6' },
[237] =  { ['x'] = -34.37,['y'] = -1566.55,['z'] = 33.03,['h'] = 227.02, ['info'] = ' Strawberry Avenue 1/Apt7' },
[238] =  { ['x'] = -35.36,['y'] = -1555.08,['z'] = 33.83,['h'] = 138.59, ['info'] = ' Strawberry Avenue 1/Apt8' },
[239] =  { ['x'] = -43.9,['y'] = -1547.83,['z'] = 34.63,['h'] = 50.27, ['info'] = ' Strawberry Avenue 1/Apt9' },
[240] =  { ['x'] = -28.52,['y'] = -1560.41,['z'] = 33.83,['h'] = 234.04, ['info'] = ' Strawberry Avenue 1/Apt14' },
[241] =  { ['x'] = -14.63,['y'] = -1543.73,['z'] = 33.03,['h'] = 222.98, ['info'] = ' Strawberry Avenue 1/Apt12' },
[242] =  { ['x'] = -20.69,['y'] = -1550.0,['z'] = 33.83,['h'] = 225.08, ['info'] = ' Strawberry Avenue 1/Apt13' },
[243] =  { ['x'] = -26.96,['y'] = -1544.93,['z'] = 33.83,['h'] = 320.18, ['info'] = ' Strawberry Avenue 1/Apt11' },
[244] =  { ['x'] = -35.82,['y'] = -1537.25,['z'] = 34.63,['h'] = 48.69, ['info'] = ' Strawberry Avenue 1/Apt10' },
[245] =  { ['x'] = -84.12,['y'] = -1622.47,['z'] = 31.48,['h'] = 230.69, ['info'] = ' Strawberry Avenue 2/Apt1' },
[246] =  { ['x'] = -90.44,['y'] = -1629.08,['z'] = 31.51,['h'] = 226.67, ['info'] = ' Strawberry Avenue 2/Apt2' },
[247] =  { ['x'] = -97.46,['y'] = -1638.56,['z'] = 32.11,['h'] = 225.22, ['info'] = ' Strawberry Avenue 2/Apt3' },
[248] =  { ['x'] = -105.34,['y'] = -1632.48,['z'] = 32.91,['h'] = 137.22, ['info'] = ' Strawberry Avenue 2/Apt4' },
[249] =  { ['x'] = -108.73,['y'] = -1629.04,['z'] = 32.91,['h'] = 45.99, ['info'] = ' Strawberry Avenue 2/Apt5' },
[250] =  { ['x'] = -96.87,['y'] = -1613.02,['z'] = 32.32,['h'] = 52.37, ['info'] = ' Strawberry Avenue 2/Apt6' },
[251] =  { ['x'] = -92.45,['y'] = -1608.14,['z'] = 32.32,['h'] = 47.32, ['info'] = ' Strawberry Avenue 2/Apt7' },
[252] =  { ['x'] = -88.5,['y'] = -1602.39,['z'] = 32.32,['h'] = 323.29, ['info'] = ' Strawberry Avenue 2/Apt8' },
[253] =  { ['x'] = -81.05,['y'] = -1608.75,['z'] = 31.49,['h'] = 322.94, ['info'] = ' Strawberry Avenue 2/Apt9' },
[254] =  { ['x'] = -84.11,['y'] = -1622.43,['z'] = 34.69,['h'] = 229.53, ['info'] = ' Strawberry Avenue 2/Apt10' },
[255] =  { ['x'] = -90.11,['y'] = -1629.4,['z'] = 34.69,['h'] = 227.58, ['info'] = ' Strawberry Avenue 2/Apt11' },
[256] =  { ['x'] = -96.25,['y'] = -1637.41,['z'] = 35.49,['h'] = 164.78, ['info'] = ' Strawberry Avenue 2/Apt12' },
[257] =  { ['x'] = -98.24,['y'] = -1638.72,['z'] = 35.49,['h'] = 139.02, ['info'] = ' Strawberry Avenue 2/Apt13' },
[258] =  { ['x'] = -104.94,['y'] = -1632.23,['z'] = 36.29,['h'] = 135.05, ['info'] = ' Strawberry Avenue 2/Apt14' },
[259] =  { ['x'] = -108.73,['y'] = -1628.99,['z'] = 36.29,['h'] = 50.81, ['info'] = ' Strawberry Avenue 2/Apt15' },
[260] =  { ['x'] = -97.08,['y'] = -1612.9,['z'] = 35.49,['h'] = 50.06, ['info'] = ' Strawberry Avenue 2/Apt16' },
[261] =  { ['x'] = -92.88,['y'] = -1607.79,['z'] = 35.49,['h'] = 47.31, ['info'] = ' Strawberry Avenue 2/Apt17' },
[262] =  { ['x'] = -88.13,['y'] = -1602.14,['z'] = 35.49,['h'] = 318.46, ['info'] = ' Strawberry Avenue 2/Apt18' },
[263] =  { ['x'] = -80.67,['y'] = -1608.63,['z'] = 34.69,['h'] = 317.01, ['info'] = ' Strawberry Avenue 2/Apt19' },
[264] =  { ['x'] = 252.35,['y'] = -1671.55,['z'] = 29.67,['h'] = 321.56, ['info'] = ' Brouge Avenue 1' },
[265] =  { ['x'] = 241.38,['y'] = -1688.28,['z'] = 29.52,['h'] = 51.92, ['info'] = ' Brouge Avenue 2' },
[266] =  { ['x'] = 223.35,['y'] = -1703.33,['z'] = 29.49,['h'] = 37.67, ['info'] = ' Brouge Avenue 3' },
[267] =  { ['x'] = 216.83,['y'] = -1717.15,['z'] = 29.48,['h'] = 123.44, ['info'] = ' Brouge Avenue 4' },
[268] =  { ['x'] = 198.59,['y'] = -1725.5,['z'] = 29.67,['h'] = 115.99, ['info'] = ' Brouge Avenue 5' },
[269] =  { ['x'] = 152.28,['y'] = -1823.45,['z'] = 27.87,['h'] = 234.41, ['info'] = ' Brouge Avenue 6' },
[270] =  { ['x'] = 249.48,['y'] = -1730.38,['z'] = 29.67,['h'] = 229.2, ['info'] = ' Brouge Avenue 7' },
[271] =  { ['x'] = 257.05,['y'] = -1723.09,['z'] = 29.66,['h'] = 313.23, ['info'] = ' Brouge Avenue 8' },
[272] =  { ['x'] = 269.23,['y'] = -1713.34,['z'] = 29.67,['h'] = 318.18, ['info'] = ' Brouge Avenue 9' },
[273] =  { ['x'] = 281.13,['y'] = -1694.16,['z'] = 29.26,['h'] = 232.69, ['info'] = ' Brouge Avenue 10' },
[274] =  { ['x'] = 332.58,['y'] = -1741.63,['z'] = 29.74,['h'] = 319.91, ['info'] = ' Roy Lowenstein Blvd 1' },
[275] =  { ['x'] = 320.66,['y'] = -1759.78,['z'] = 29.64,['h'] = 60.41, ['info'] = ' Roy Lowenstein Blvd 2' },
[276] =  { ['x'] = 305.15,['y'] = -1775.86,['z'] = 29.1,['h'] = 49.68, ['info'] = ' Roy Lowenstein Blvd 3' },
[277] =  { ['x'] = 299.84,['y'] = -1784.04,['z'] = 28.44,['h'] = 324.93, ['info'] = ' Roy Lowenstein Blvd 4' },
[278] =  { ['x'] = 289.25,['y'] = -1791.99,['z'] = 28.09,['h'] = 141.95, ['info'] = ' Roy Lowenstein Blvd 5' },
[279] =  { ['x'] = 179.23,['y'] = -1923.86,['z'] = 21.38,['h'] = 322.58, ['info'] = ' Roy Lowenstein Blvd 6' },
[280] =  { ['x'] = 165.55,['y'] = -1945.18,['z'] = 20.24,['h'] = 48.7, ['info'] = ' Roy Lowenstein Blvd 7' },
[281] =  { ['x'] = 149.99,['y'] = -1961.59,['z'] = 19.08,['h'] = 43.72, ['info'] = ' Roy Lowenstein Blvd 8' },
[282] =  { ['x'] = 144.14,['y'] = -1969.72,['z'] = 18.86,['h'] = 332.82, ['info'] = ' Roy Lowenstein Blvd 9' },
[283] =  { ['x'] = 140.98,['y'] = -1983.14,['z'] = 18.33,['h'] = 57.43, ['info'] = ' Roy Lowenstein Blvd 10' },
[284] =  { ['x'] = 250.07,['y'] = -1934.4,['z'] = 24.51,['h'] = 231.59, ['info'] = ' Roy Lowenstein Blvd 11' },
[285] =  { ['x'] = 257.39,['y'] = -1927.69,['z'] = 25.45,['h'] = 312.69, ['info'] = ' Roy Lowenstein Blvd 12' },
[286] =  { ['x'] = 269.71,['y'] = -1917.57,['z'] = 26.19,['h'] = 317.5, ['info'] = ' Roy Lowenstein Blvd 13' },
[287] =  { ['x'] = 281.88,['y'] = -1898.45,['z'] = 26.88,['h'] = 230.17, ['info'] = ' Roy Lowenstein Blvd 14' },
[288] =  { ['x'] = 319.74,['y'] = -1853.49,['z'] = 27.53,['h'] = 227.79, ['info'] = ' Roy Lowenstein Blvd 15' },
[289] =  { ['x'] = 328.0,['y'] = -1844.52,['z'] = 27.76,['h'] = 225.99, ['info'] = ' Roy Lowenstein Blvd 16' },
[290] =  { ['x'] = 339.22,['y'] = -1829.24,['z'] = 28.34,['h'] = 136.63, ['info'] = ' Roy Lowenstein Blvd 17' },
[291] =  { ['x'] = 348.85,['y'] = -1820.62,['z'] = 28.9,['h'] = 142.65, ['info'] = ' Roy Lowenstein Blvd 18' },
[292] =  { ['x'] = 405.64,['y'] = -1751.29,['z'] = 29.72,['h'] = 324.51, ['info'] = ' Roy Lowenstein Blvd 19' },
[293] =  { ['x'] = 418.53,['y'] = -1735.9,['z'] = 29.61,['h'] = 315.07, ['info'] = ' Roy Lowenstein Blvd 20' },
[294] =  { ['x'] = 430.99,['y'] = -1725.5,['z'] = 29.61,['h'] = 310.19, ['info'] = ' Roy Lowenstein Blvd 21' },
[295] =  { ['x'] = 442.72,['y'] = -1706.93,['z'] = 29.49,['h'] = 231.07, ['info'] = ' Roy Lowenstein Blvd 22' },
[296] =  { ['x'] = 471.16,['y'] = -1561.47,['z'] = 32.8,['h'] = 50.68, ['info'] = ' Roy Lowenstein Blvd 23/Apt1' },
[297] =  { ['x'] = 465.83,['y'] = -1567.54,['z'] = 32.8,['h'] = 54.01, ['info'] = ' Roy Lowenstein Blvd 23/Apt2' },
[298] =  { ['x'] = 461.39,['y'] = -1573.95,['z'] = 32.8,['h'] = 49.46, ['info'] = ' Roy Lowenstein Blvd 23/Apt3' },
[299] =  { ['x'] = 455.53,['y'] = -1579.34,['z'] = 32.8,['h'] = 141.19, ['info'] = ' Roy Lowenstein Blvd 23/Apt4' },
[300] =  { ['x'] = 442.13,['y'] = -1569.43,['z'] = 32.8,['h'] = 134.84, ['info'] = ' Roy Lowenstein Blvd 23/Apt5' },
[301] =  { ['x'] = 436.5,['y'] = -1563.9,['z'] = 32.8,['h'] = 136.21, ['info'] = ' Roy Lowenstein Blvd 23/Apt6' },
[302] =  { ['x'] = 431.15,['y'] = -1558.66,['z'] = 32.8,['h'] = 136.11, ['info'] = ' Roy Lowenstein Blvd 23/Apt7' },
[303] =  { ['x'] = 500.25,['y'] = -1697.49,['z'] = 29.79,['h'] = 322.98, ['info'] = ' Jamestown Street 1' },
[304] =  { ['x'] = 490.6,['y'] = -1714.39,['z'] = 29.5,['h'] = 70.57, ['info'] = ' Jamestown Street 2' },
[305] =  { ['x'] = 479.51,['y'] = -1736.71,['z'] = 29.16,['h'] = 344.06, ['info'] = ' Jamestown Street 3' },
[306] =  { ['x'] = 475.44,['y'] = -1757.74,['z'] = 28.9,['h'] = 79.05, ['info'] = ' Jamestown Street 4' },
[307] =  { ['x'] = 472.88,['y'] = -1775.22,['z'] = 29.07,['h'] = 86.89, ['info'] = ' Jamestown Street 5' },
[308] =  { ['x'] = 440.01,['y'] = -1830.31,['z'] = 28.37,['h'] = 328.16, ['info'] = ' Jamestown Street 6' },
[309] =  { ['x'] = 428.12,['y'] = -1841.33,['z'] = 28.47,['h'] = 135.91, ['info'] = ' Jamestown Street 7' },
[310] =  { ['x'] = 412.58,['y'] = -1856.23,['z'] = 27.33,['h'] = 137.19, ['info'] = ' Jamestown Street 8' },
[311] =  { ['x'] = 399.67,['y'] = -1864.78,['z'] = 26.72,['h'] = 132.43, ['info'] = ' Jamestown Street 9' },
[312] =  { ['x'] = 386.04,['y'] = -1882.27,['z'] = 25.79,['h'] = 47.42, ['info'] = ' Jamestown Street 10' },
[313] =  { ['x'] = 368.05,['y'] = -1896.76,['z'] = 25.18,['h'] = 317.81, ['info'] = ' Jamestown Street 11' },
[314] =  { ['x'] = 324.15,['y'] = -1937.81,['z'] = 25.02,['h'] = 327.68, ['info'] = ' Jamestown Street 12' },
[315] =  { ['x'] = 312.81,['y'] = -1956.66,['z'] = 24.43,['h'] = 44.18, ['info'] = ' Jamestown Street 13' },
[316] =  { ['x'] = 296.54,['y'] = -1972.44,['z'] = 22.7,['h'] = 43.25, ['info'] = ' Jamestown Street 14' },
[317] =  { ['x'] = 291.23,['y'] = -1980.74,['z'] = 21.61,['h'] = 323.31, ['info'] = ' Jamestown Street 15' },
[318] =  { ['x'] = 280.23,['y'] = -1993.25,['z'] = 20.81,['h'] = 139.93, ['info'] = ' Jamestown Street 16' },
[319] =  { ['x'] = 257.12,['y'] = -2023.84,['z'] = 19.27,['h'] = 55.76, ['info'] = ' Jamestown Street 17' },
[320] =  { ['x'] = 251.39,['y'] = -2029.73,['z'] = 18.51,['h'] = 137.79, ['info'] = ' Jamestown Street 18' },
[321] =  { ['x'] = 236.5,['y'] = -2045.73,['z'] = 18.38,['h'] = 134.85, ['info'] = ' Jamestown Street 19' },
[322] =  { ['x'] = 296.87,['y'] = -2097.86,['z'] = 17.67,['h'] = 285.59, ['info'] = ' Jamestown Street 20/Apt1' },
[323] =  { ['x'] = 295.78,['y'] = -2093.31,['z'] = 17.67,['h'] = 291.54, ['info'] = ' Jamestown Street 20/Apt2' },
[324] =  { ['x'] = 293.68,['y'] = -2087.92,['z'] = 17.67,['h'] = 287.12, ['info'] = ' Jamestown Street 20/Apt3' },
[325] =  { ['x'] = 292.59,['y'] = -2086.38,['z'] = 17.67,['h'] = 290.15, ['info'] = ' Jamestown Street 20/Apt4' },
[326] =  { ['x'] = 289.53,['y'] = -2077.1,['z'] = 17.67,['h'] = 291.26, ['info'] = ' Jamestown Street 20/Apt5' },
[327] =  { ['x'] = 288.21,['y'] = -2072.75,['z'] = 17.67,['h'] = 288.69, ['info'] = ' Jamestown Street 20/Apt6' },
[328] =  { ['x'] = 279.29,['y'] = -2043.26,['z'] = 19.77,['h'] = 232.08, ['info'] = ' Jamestown Street 20/Apt7' },
[329] =  { ['x'] = 280.6,['y'] = -2041.64,['z'] = 19.77,['h'] = 224.82, ['info'] = ' Jamestown Street 20/Apt8' },
[330] =  { ['x'] = 286.69,['y'] = -2034.4,['z'] = 19.77,['h'] = 231.33, ['info'] = ' Jamestown Street 20/Apt9' },
[331] =  { ['x'] = 289.76,['y'] = -2030.74,['z'] = 19.77,['h'] = 231.61, ['info'] = ' Jamestown Street 20/Apt10' },
[332] =  { ['x'] = 323.53,['y'] = -1990.66,['z'] = 24.17,['h'] = 229.59, ['info'] = ' Jamestown Street 20/Apt11' },
[333] =  { ['x'] = 324.82,['y'] = -1988.95,['z'] = 24.17,['h'] = 226.72, ['info'] = ' Jamestown Street 20/Apt12' },
[334] =  { ['x'] = 331.63,['y'] = -1982.15,['z'] = 24.17,['h'] = 233.06, ['info'] = ' Jamestown Street 20/Apt13' },
[335] =  { ['x'] = 333.9,['y'] = -1978.33,['z'] = 24.17,['h'] = 241.31, ['info'] = ' Jamestown Street 20/Apt14' },
[336] =  { ['x'] = 362.6,['y'] = -1986.24,['z'] = 24.13,['h'] = 159.57, ['info'] = ' Jamestown Street 20/Apt15' },
[337] =  { ['x'] = 364.17,['y'] = -1986.78,['z'] = 24.14,['h'] = 160.3, ['info'] = ' Jamestown Street 20/Apt16' },
[338] =  { ['x'] = 375.15,['y'] = -1990.66,['z'] = 24.13,['h'] = 157.46, ['info'] = ' Jamestown Street 20/Apt18' },
[339] =  { ['x'] = 384.27,['y'] = -1994.33,['z'] = 24.24,['h'] = 162.11, ['info'] = ' Jamestown Street 20/Apt19' },
[340] =  { ['x'] = 385.74,['y'] = -1995.01,['z'] = 24.24,['h'] = 162.4, ['info'] = ' Jamestown Street 20/Apt20' },
[341] =  { ['x'] = 405.02,['y'] = -2018.35,['z'] = 23.33,['h'] = 67.11, ['info'] = ' Jamestown Street 20/Apt21' },
[342] =  { ['x'] = 402.43,['y'] = -2024.68,['z'] = 23.25,['h'] = 64.89, ['info'] = ' Jamestown Street 20/Apt22' },
[343] =  { ['x'] = 400.7,['y'] = -2028.47,['z'] = 23.25,['h'] = 64.86, ['info'] = ' Jamestown Street 20/Apt23' },
[344] =  { ['x'] = 397.38,['y'] = -2034.67,['z'] = 23.21,['h'] = 62.87, ['info'] = ' Jamestown Street 20/Apt24' },
[345] =  { ['x'] = 396.04,['y'] = -2037.9,['z'] = 23.04,['h'] = 66.18, ['info'] = ' Jamestown Street 20/Apt25' },
[346] =  { ['x'] = 392.7,['y'] = -2044.32,['z'] = 22.93,['h'] = 64.93, ['info'] = ' Jamestown Street 20/Apt26' },
[347] =  { ['x'] = 382.56,['y'] = -2061.38,['z'] = 21.78,['h'] = 52.06, ['info'] = ' Jamestown Street 20/Apt27' },
[348] =  { ['x'] = 378.73,['y'] = -2067.02,['z'] = 21.38,['h'] = 52.18, ['info'] = ' Jamestown Street 20/Apt28' },
[349] =  { ['x'] = 375.83,['y'] = -2069.96,['z'] = 21.55,['h'] = 52.97, ['info'] = ' Jamestown Street 20/Apt29' },
[350] =  { ['x'] = 371.63,['y'] = -2074.86,['z'] = 21.56,['h'] = 47.53, ['info'] = ' Jamestown Street 20/Apt30' },
[351] =  { ['x'] = 368.99,['y'] = -2078.37,['z'] = 21.38,['h'] = 49.85, ['info'] = ' Jamestown Street 20/Apt31' },
[352] =  { ['x'] = 364.48,['y'] = -2083.31,['z'] = 21.57,['h'] = 55.19, ['info'] = ' Jamestown Street 20/Apt32' },
[353] =  { ['x'] = 341.08,['y'] = -2098.49,['z'] = 18.21,['h'] = 110.37, ['info'] = ' Jamestown Street 20/Apt33' },
[354] =  { ['x'] = 333.01,['y'] = -2106.72,['z'] = 18.02,['h'] = 38.79, ['info'] = ' Jamestown Street 20/Apt34' },
[355] =  { ['x'] = 329.57,['y'] = -2108.85,['z'] = 17.91,['h'] = 31.98, ['info'] = ' Jamestown Street 20/Apt35' },
[356] =  { ['x'] = 324.18,['y'] = -2112.44,['z'] = 17.76,['h'] = 46.63, ['info'] = ' Jamestown Street 20/Apt36' },
[357] =  { ['x'] = 306.34,['y'] = -2098.09,['z'] = 17.53,['h'] = 17.58, ['info'] = ' Jamestown Street 20/Apt37' },
[358] =  { ['x'] = 306.07,['y'] = -2086.4,['z'] = 17.61,['h'] = 103.49, ['info'] = ' Jamestown Street 20/Apt38' },
[359] =  { ['x'] = 303.8,['y'] = -2079.71,['z'] = 17.66,['h'] = 108.49, ['info'] = ' Jamestown Street 20/Apt39' },
[360] =  { ['x'] = 302.18,['y'] = -2076.06,['z'] = 17.69,['h'] = 99.21, ['info'] = ' Jamestown Street 20/Apt40' },
[361] =  { ['x'] = 295.03,['y'] = -2067.07,['z'] = 17.66,['h'] = 190.42, ['info'] = ' Jamestown Street 20/Apt41' },
[362] =  { ['x'] = 286.77,['y'] = -2053.13,['z'] = 19.43,['h'] = 52.79, ['info'] = ' Jamestown Street 20/Apt42' },
[363] =  { ['x'] = 291.13,['y'] = -2047.6,['z'] = 19.66,['h'] = 44.61, ['info'] = ' Jamestown Street 20/Apt43' },
[364] =  { ['x'] = 293.65,['y'] = -2044.56,['z'] = 19.64,['h'] = 39.9, ['info'] = ' Jamestown Street 20/Apt44' },
[365] =  { ['x'] = 331.18,['y'] = -2000.79,['z'] = 23.81,['h'] = 47.06, ['info'] = ' Jamestown Street 20/Apt45' },
[366] =  { ['x'] = 335.45,['y'] = -1995.13,['z'] = 24.05,['h'] = 47.08, ['info'] = ' Jamestown Street 20/Apt46' },
[367] =  { ['x'] = 338.11,['y'] = -1992.45,['z'] = 23.61,['h'] = 40.95, ['info'] = ' Jamestown Street 20/Apt47' },
[368] =  { ['x'] = 356.72,['y'] = -1997.29,['z'] = 24.07,['h'] = 336.83, ['info'] = ' Jamestown Street 20/Apt48' },
[369] =  { ['x'] = 363.17,['y'] = -1999.61,['z'] = 24.05,['h'] = 336.99, ['info'] = ' Jamestown Street 20/Apt49' },
[370] =  { ['x'] = 366.89,['y'] = -2000.92,['z'] = 24.24,['h'] = 334.73, ['info'] = ' Jamestown Street 20/Apt50' },
[371] =  { ['x'] = 373.56,['y'] = -2003.08,['z'] = 24.27,['h'] = 340.6, ['info'] = ' Jamestown Street 20/Apt51' },
[372] =  { ['x'] = 376.97,['y'] = -2004.75,['z'] = 24.05,['h'] = 334.25, ['info'] = ' Jamestown Street 20/Apt52' },
[373] =  { ['x'] = 383.31,['y'] = -2007.28,['z'] = 23.88,['h'] = 331.42, ['info'] = ' Jamestown Street 20/Apt53' },
[374] =  { ['x'] = 393.38,['y'] = -2015.4,['z'] = 23.41,['h'] = 241.2, ['info'] = ' Jamestown Street 20/Apt54' },
[375] =  { ['x'] = 391.99,['y'] = -2016.96,['z'] = 23.41,['h'] = 242.17, ['info'] = ' Jamestown Street 20/Apt55' },
[376] =  { ['x'] = 388.18,['y'] = -2025.47,['z'] = 23.41,['h'] = 236.34, ['info'] = ' Jamestown Street 20/Apt56' },
[377] =  { ['x'] = 383.87,['y'] = -2036.12,['z'] = 23.41,['h'] = 243.42, ['info'] = ' Jamestown Street 20/Apt58' },
[378] =  { ['x'] = 382.6,['y'] = -2037.41,['z'] = 23.41,['h'] = 243.12, ['info'] = ' Jamestown Street 20/Apt59' },
[379] =  { ['x'] = 372.04,['y'] = -2055.52,['z'] = 21.75,['h'] = 221.27, ['info'] = ' Jamestown Street 20/Apt60' },
[380] =  { ['x'] = 370.9,['y'] = -2056.9,['z'] = 21.75,['h'] = 226.86, ['info'] = ' Jamestown Street 20/Apt61' },
[381] =  { ['x'] = 364.62,['y'] = -2064.18,['z'] = 21.75,['h'] = 226.55, ['info'] = ' Jamestown Street 20/Apt62' },
[382] =  { ['x'] = 357.72,['y'] = -2073.24,['z'] = 21.75,['h'] = 231.66, ['info'] = ' Jamestown Street 20/Apt64' },
[383] =  { ['x'] = 356.57,['y'] = -2074.62,['z'] = 21.75,['h'] = 227.21, ['info'] = ' Jamestown Street 20/Apt65' },
[384] =  { ['x'] = 334.14,['y'] = -2092.86,['z'] = 18.25,['h'] = 209.74, ['info'] = ' Jamestown Street 20/Apt66' },
[385] =  { ['x'] = 329.88,['y'] = -2094.65,['z'] = 18.25,['h'] = 208.97, ['info'] = ' Jamestown Street 20/Apt67' },
[386] =  { ['x'] = 321.57,['y'] = -2099.85,['z'] = 18.25,['h'] = 208.4, ['info'] = ' Jamestown Street 20/Apt68' },
[387] =  { ['x'] = 319.72,['y'] = -2100.29,['z'] = 18.25,['h'] = 207.21, ['info'] = ' Jamestown Street 20/Apt69' },
[388] =  { ['x'] = 332.15,['y'] = -2070.86,['z'] = 20.95,['h'] = 321.11, ['info'] = ' Jamestown Street 20/Apt70' },
[389] =  { ['x'] = 324.11,['y'] = -2063.77,['z'] = 20.72,['h'] = 327.76, ['info'] = ' Jamestown Street 20/Apt72' },
[390] =  { ['x'] = 321.03,['y'] = -2061.05,['z'] = 20.74,['h'] = 319.9, ['info'] = ' Jamestown Street 20/Apt73' },
[391] =  { ['x'] = 315.26,['y'] = -2056.94,['z'] = 20.72,['h'] = 321.74, ['info'] = ' Jamestown Street 20/Apt74' },
[392] =  { ['x'] = 312.31,['y'] = -2054.58,['z'] = 20.72,['h'] = 320.28, ['info'] = ' Jamestown Street 20/Apt75' },
[393] =  { ['x'] = 305.98,['y'] = -2044.77,['z'] = 20.9,['h'] = 229.17, ['info'] = ' Jamestown Street 20/Apt76' },
[394] =  { ['x'] = 313.74,['y'] = -2040.53,['z'] = 20.94,['h'] = 140.85, ['info'] = ' Jamestown Street 20/Apt77' },
[395] =  { ['x'] = 317.47,['y'] = -2043.3,['z'] = 20.94,['h'] = 139.1, ['info'] = ' Jamestown Street 20/Apt78' },
[396] =  { ['x'] = 324.69,['y'] = -2049.25,['z'] = 20.94,['h'] = 139.12, ['info'] = ' Jamestown Street 20/Apt79' },
[397] =  { ['x'] = 326.2,['y'] = -2050.54,['z'] = 20.94,['h'] = 139.05, ['info'] = ' Jamestown Street 20/Apt80' },
[398] =  { ['x'] = 333.56,['y'] = -2056.94,['z'] = 20.94,['h'] = 136.48, ['info'] = ' Jamestown Street 20/Apt81' },
[399] =  { ['x'] = 334.57,['y'] = -2058.3,['z'] = 20.94,['h'] = 143.73, ['info'] = ' Jamestown Street 20/Apt82' },
[400] =  { ['x'] = 341.86,['y'] = -2064.11,['z'] = 20.95,['h'] = 143.43, ['info'] = ' Jamestown Street 20/Apt83' },
[401] =  { ['x'] = 345.23,['y'] = -2067.37,['z'] = 20.94,['h'] = 139.82, ['info'] = ' Jamestown Street 20/Apt84' },
[402] =  { ['x'] = 363.43,['y'] = -2046.13,['z'] = 22.2,['h'] = 318.31, ['info'] = ' Jamestown Street 20/Apt85' },
[403] =  { ['x'] = 359.88,['y'] = -2043.38,['z'] = 22.2,['h'] = 320.76, ['info'] = ' Jamestown Street 20/Apt86' },
[404] =  { ['x'] = 352.51,['y'] = -2037.24,['z'] = 22.09,['h'] = 318.37, ['info'] = ' Jamestown Street 20/Apt87' },
[405] =  { ['x'] = 352.15,['y'] = -2034.96,['z'] = 22.36,['h'] = 318.55, ['info'] = ' Jamestown Street 20/Apt88' },
[406] =  { ['x'] = 344.83,['y'] = -2028.81,['z'] = 22.36,['h'] = 319.14, ['info'] = ' Jamestown Street 20/Apt89' },
[407] =  { ['x'] = 343.63,['y'] = -2027.94,['z'] = 22.36,['h'] = 320.6, ['info'] = ' Jamestown Street 20/Apt90' },
[408] =  { ['x'] = 336.17,['y'] = -2021.61,['z'] = 22.36,['h'] = 318.01, ['info'] = ' Jamestown Street 20/Apt91' },
[409] =  { ['x'] = 331.93,['y'] = -2019.28,['z'] = 22.35,['h'] = 332.68, ['info'] = ' Jamestown Street 20/Apt92' },
[410] =  { ['x'] = 335.78,['y'] = -2010.93,['z'] = 22.32,['h'] = 219.48, ['info'] = ' Jamestown Street 20/Apt93' },
[411] =  { ['x'] = 345.65,['y'] = -2014.72,['z'] = 22.4,['h'] = 156.47, ['info'] = ' Jamestown Street 20/Apt94' },
[412] =  { ['x'] = 354.15,['y'] = -2021.71,['z'] = 22.31,['h'] = 161.59, ['info'] = ' Jamestown Street 20/Apt96' },
[413] =  { ['x'] = 357.26,['y'] = -2024.55,['z'] = 22.3,['h'] = 138.06, ['info'] = ' Jamestown Street 20/Apt97' },
[414] =  { ['x'] = 362.71,['y'] = -2028.26,['z'] = 22.25,['h'] = 146.16, ['info'] = ' Jamestown Street 20/Apt98' },
[415] =  { ['x'] = 365.22,['y'] = -2031.53,['z'] = 22.4,['h'] = 229.42, ['info'] = ' Jamestown Street 20/Apt99' },
[416] =  { ['x'] = 371.47,['y'] = -2040.7,['z'] = 22.2,['h'] = 48.81, ['info'] = ' Jamestown Street 20/Apt100' },
[417] =  { ['x'] = -903.43,['y'] = -1005.12,['z'] = 2.16,['h'] = 210.68, ['info'] = ' Coopenmartha Court 1' },
[418] =  { ['x'] = -902.68,['y'] = -997.07,['z'] = 2.16,['h'] = 28.56, ['info'] = ' Coopenmartha Court 2' },
[419] =  { ['x'] = -900.17,['y'] = -981.97,['z'] = 2.17,['h'] = 122.33, ['info'] = ' Coopenmartha Court 3' },
[420] =  { ['x'] = -913.66,['y'] = -989.39,['z'] = 2.16,['h'] = 206.18, ['info'] = ' Coopenmartha Court 4' },
[421] =  { ['x'] = -908.07,['y'] = -976.76,['z'] = 2.16,['h'] = 32.27, ['info'] = ' Coopenmartha Court 5' },
[422] =  { ['x'] = -922.48,['y'] = -983.07,['z'] = 2.16,['h'] = 117.2, ['info'] = ' Coopenmartha Court 6' },
[423] =  { ['x'] = -927.84,['y'] = -973.27,['z'] = 2.16,['h'] = 215.49, ['info'] = ' Coopenmartha Court 6' },
[424] =  { ['x'] = -927.7,['y'] = -949.4,['z'] = 2.75,['h'] = 129.72, ['info'] = ' Coopenmartha Court 8' },
[425] =  { ['x'] = -934.92,['y'] = -938.93,['z'] = 2.15,['h'] = 119.33, ['info'] = ' Coopenmartha Court 9' },
[426] =  { ['x'] = -947.13,['y'] = -927.75,['z'] = 2.15,['h'] = 118.67, ['info'] = ' Coopenmartha Court 10' },
[427] =  { ['x'] = -947.68,['y'] = -910.11,['z'] = 2.35,['h'] = 122.31, ['info'] = ' Coopenmartha Court 11' },
[428] =  { ['x'] = -950.41,['y'] = -905.28,['z'] = 2.35,['h'] = 118.74, ['info'] = ' Coopenmartha Court 12' },
[429] =  { ['x'] = -986.43,['y'] = -866.38,['z'] = 2.2,['h'] = 208.66, ['info'] = ' Coopenmartha Court 13' },
[430] =  { ['x'] = -996.44,['y'] = -875.87,['z'] = 2.16,['h'] = 196.75, ['info'] = ' Coopenmartha Court 14' },
[431] =  { ['x'] = -1011.47,['y'] = -880.83,['z'] = 2.16,['h'] = 208.65, ['info'] = ' Coopenmartha Court 15' },
[432] =  { ['x'] = -1005.53,['y'] = -897.67,['z'] = 2.55,['h'] = 296.35, ['info'] = ' Coopenmartha Court 16' },
[433] =  { ['x'] = -975.57,['y'] = -909.16,['z'] = 2.16,['h'] = 222.04, ['info'] = ' Coopenmartha Court 17' },
[434] =  { ['x'] = -1010.99,['y'] = -909.64,['z'] = 2.14,['h'] = 33.62, ['info'] = ' Coopenmartha Court 18' },
[435] =  { ['x'] = -1022.89,['y'] = -896.58,['z'] = 5.42,['h'] = 207.75, ['info'] = ' Coopenmartha Court 19' },
[436] =  { ['x'] = -1031.35,['y'] = -903.04,['z'] = 3.7,['h'] = 208.79, ['info'] = ' Coopenmartha Court 20' },
[437] =  { ['x'] = -1027.9,['y'] = -919.72,['z'] = 5.05,['h'] = 22.53, ['info'] = ' Coopenmartha Court 21' },
[438] =  { ['x'] = -1024.41,['y'] = -912.11,['z'] = 6.97,['h'] = 126.42, ['info'] = ' Coopenmartha Court 22' },
[439] =  { ['x'] = -1043.03,['y'] = -924.86,['z'] = 3.16,['h'] = 28.04, ['info'] = ' Coopenmartha Court 23' },
[440] =  { ['x'] = -1053.82,['y'] = -933.09,['z'] = 3.36,['h'] = 23.91, ['info'] = ' Coopenmartha Court 24' },
[441] =  { ['x'] = -1090.89,['y'] = -926.24,['z'] = 3.14,['h'] = 204.58, ['info'] = ' Coopenmartha Court 25' },
[442] =  { ['x'] = -1085.1,['y'] = -934.97,['z'] = 3.09,['h'] = 121.56, ['info'] = ' Coopenmartha Court 26' },
[443] =  { ['x'] = -1075.69,['y'] = -939.49,['z'] = 2.36,['h'] = 303.99, ['info'] = ' Coopenmartha Court 27' },
[444] =  { ['x'] = -1084.41,['y'] = -951.81,['z'] = 2.37,['h'] = 310.7, ['info'] = ' Coopenmartha Court 28' },
[445] =  { ['x'] = -989.35,['y'] = -975.21,['z'] = 4.23,['h'] = 117.27, ['info'] = ' Imagination Court 1' },
[446] =  { ['x'] = -994.98,['y'] = -966.47,['z'] = 2.55,['h'] = 116.74, ['info'] = ' Imagination Court 2' },
[447] =  { ['x'] = -978.21,['y'] = -990.68,['z'] = 4.55,['h'] = 121.89, ['info'] = ' Imagination Court 3' },
[448] =  { ['x'] = -1019.04,['y'] = -963.69,['z'] = 2.16,['h'] = 201.18, ['info'] = ' Imagination Court 4' },
[449] =  { ['x'] = -1028.21,['y'] = -968.02,['z'] = 2.16,['h'] = 204.49, ['info'] = ' Imagination Court 5' },
[450] =  { ['x'] = -1032.18,['y'] = -982.48,['z'] = 2.16,['h'] = 202.74, ['info'] = ' Imagination Court 6' },
[451] =  { ['x'] = -1056.67,['y'] = -1001.26,['z'] = 2.16,['h'] = 277.45, ['info'] = ' Imagination Court 7' },
[452] =  { ['x'] = -1054.81,['y'] = -1000.95,['z'] = 6.42,['h'] = 307.44, ['info'] = ' Imagination Court 8' },
[453] =  { ['x'] = -1055.75,['y'] = -998.78,['z'] = 6.42,['h'] = 305.55, ['info'] = ' Imagination Court 9' },
[454] =  { ['x'] = -1042.39,['y'] = -1024.61,['z'] = 2.16,['h'] = 211.23, ['info'] = ' Imagination Court 10' },
[455] =  { ['x'] = -1022.48,['y'] = -1022.42,['z'] = 2.16,['h'] = 205.65, ['info'] = ' Imagination Court 11' },
[456] =  { ['x'] = -1008.47,['y'] = -1015.29,['z'] = 2.16,['h'] = 208.97, ['info'] = ' Imagination Court 12' },
[457] =  { ['x'] = -997.35,['y'] = -1012.6,['z'] = 2.16,['h'] = 302.07, ['info'] = ' Imagination Court 13' },
[458] =  { ['x'] = -967.46,['y'] = -1008.5,['z'] = 2.16,['h'] = 218.76, ['info'] = ' Imagination Court 14' },
[459] =  { ['x'] = -942.71,['y'] = -1076.35,['z'] = 2.54,['h'] = 29.74, ['info'] = ' Invention Court 1' },
[460] =  { ['x'] = -951.94,['y'] = -1078.52,['z'] = 2.16,['h'] = 29.92, ['info'] = ' Invention Court 2' },
[461] =  { ['x'] = -982.64,['y'] = -1066.94,['z'] = 2.55,['h'] = 207.21, ['info'] = ' Invention Court 3' },
[462] =  { ['x'] = -977.79,['y'] = -1091.85,['z'] = 4.23,['h'] = 132.57, ['info'] = ' Invention Court 4' },
[463] =  { ['x'] = -982.64,['y'] = -1083.86,['z'] = 2.55,['h'] = 121.26, ['info'] = ' Invention Court 5' },
[464] =  { ['x'] = -991.11,['y'] = -1103.85,['z'] = 2.16,['h'] = 38.51, ['info'] = ' Invention Court 6' },
[465] =  { ['x'] = -986.66,['y'] = -1122.15,['z'] = 4.55,['h'] = 301.76, ['info'] = ' Invention Court 7' },
[466] =  { ['x'] = -976.25,['y'] = -1140.3,['z'] = 2.18,['h'] = 296.42, ['info'] = ' Invention Court 8' },
[467] =  { ['x'] = -978.06,['y'] = -1108.25,['z'] = 2.16,['h'] = 199.34, ['info'] = ' Invention Court 9' },
[468] =  { ['x'] = -960.05,['y'] = -1109.07,['z'] = 2.16,['h'] = 202.32, ['info'] = ' Invention Court 11' },
[469] =  { ['x'] = -963.15,['y'] = -1110.02,['z'] = 2.18,['h'] = 117.39, ['info'] = ' Invention Court 10' },
[470] =  { ['x'] = -948.72,['y'] = -1107.7,['z'] = 2.18,['h'] = 299.33, ['info'] = ' Invention Court 12' },
[471] =  { ['x'] = -939.32,['y'] = -1088.27,['z'] = 2.16,['h'] = 273.12, ['info'] = ' Invention Court 13' },
[472] =  { ['x'] = -931.12,['y'] = -1100.18,['z'] = 2.18,['h'] = 215.78, ['info'] = ' Invention Court 14' },
[473] =  { ['x'] = -921.36,['y'] = -1095.44,['z'] = 2.16,['h'] = 118.76, ['info'] = ' Invention Court 15' },
[474] =  { ['x'] = -1176.2,['y'] = -1072.88,['z'] = 5.91,['h'] = 115.96, ['info'] = ' Imagination Court 15' },
[475] =  { ['x'] = -1180.93,['y'] = -1056.36,['z'] = 2.16,['h'] = 209.3, ['info'] = ' Imagination Court 16' },
[476] =  { ['x'] = -1183.71,['y'] = -1044.88,['z'] = 2.16,['h'] = 125.29, ['info'] = ' Imagination Court 17' },
[477] =  { ['x'] = -1188.65,['y'] = -1041.64,['z'] = 2.3,['h'] = 27.41, ['info'] = ' Imagination Court 18' },
[478] =  { ['x'] = -1198.67,['y'] = -1023.73,['z'] = 2.16,['h'] = 202.18, ['info'] = ' Imagination Court 19' },
[479] =  { ['x'] = -1203.28,['y'] = -1021.27,['z'] = 5.96,['h'] = 121.76, ['info'] = ' Imagination Court 20' },
[480] =  { ['x'] = -1098.74,['y'] = -1679.17,['z'] = 4.37,['h'] = 300.45, ['info'] = ' Beachside Avenue 1' },
[481] =  { ['x'] = -1097.58,['y'] = -1673.07,['z'] = 8.4,['h'] = 303.36, ['info'] = ' Beachside Avenue 2' },
[482] =  { ['x'] = -1349.59,['y'] = -1187.7,['z'] = 4.57,['h'] = 271.19, ['info'] = ' Beachside Avenue 3' },
[483] =  { ['x'] = -1347.14,['y'] = -1167.87,['z'] = 4.58,['h'] = 326.75, ['info'] = ' Beachside Avenue 4' },
[484] =  { ['x'] = -1350.2,['y'] = -1161.41,['z'] = 4.51,['h'] = 268.7, ['info'] = ' Beachside Avenue 5' },
[485] =  { ['x'] = -1347.23,['y'] = -1145.91,['z'] = 4.34,['h'] = 236.95, ['info'] = ' Beachside Avenue 6' },
[486] =  { ['x'] = -1336.27,['y'] = -1145.51,['z'] = 6.74,['h'] = 177.62, ['info'] = ' Beachside Avenue 7' },
[487] =  { ['x'] = -1374.53,['y'] = -1074.28,['z'] = 4.32,['h'] = 300.62, ['info'] = ' Beachside Avenue 8' },
[488] =  { ['x'] = -1376.91,['y'] = -1070.31,['z'] = 4.35,['h'] = 300.36, ['info'] = ' Beachside Avenue 9' },
[489] =  { ['x'] = -1379.84,['y'] = -1066.37,['z'] = 4.35,['h'] = 300.43, ['info'] = ' Beachside Avenue 10' },
[490] =  { ['x'] = -1381.87,['y'] = -1062.06,['z'] = 4.35,['h'] = 299.36, ['info'] = ' Beachside Avenue 11' },
[491] =  { ['x'] = -1384.78,['y'] = -1058.38,['z'] = 4.36,['h'] = 301.37, ['info'] = ' Beachside Avenue 12' },
[492] =  { ['x'] = -1386.93,['y'] = -1054.22,['z'] = 4.34,['h'] = 303.25, ['info'] = ' Beachside Avenue 13' },
[493] =  { ['x'] = -1370.18,['y'] = -1042.84,['z'] = 4.26,['h'] = 212.96, ['info'] = ' Beachside Avenue 14' },
[494] =  { ['x'] = -1366.28,['y'] = -1039.9,['z'] = 4.26,['h'] = 207.39, ['info'] = ' Beachside Avenue 15' },
[495] =  { ['x'] = -1362.4,['y'] = -1037.3,['z'] = 4.25,['h'] = 208.56, ['info'] = ' Beachside Avenue 16' },
[496] =  { ['x'] = -1358.3,['y'] = -1035.08,['z'] = 4.24,['h'] = 206.68, ['info'] = ' Beachside Avenue 17' },
[497] =  { ['x'] = -1754.06,['y'] = -725.21,['z'] = 10.29,['h'] = 315.01, ['info'] = ' Beachside Avenue 18' },
[498] =  { ['x'] = -1754.74,['y'] = -708.34,['z'] = 10.4,['h'] = 228.16, ['info'] = ' Beachside Avenue 19' },
[499] =  { ['x'] = -1764.34,['y'] = -708.4,['z'] = 10.62,['h'] = 330.2, ['info'] = ' Beachside Avenue 20' },
[500] =  { ['x'] = -1777.02,['y'] = -701.53,['z'] = 10.53,['h'] = 321.14, ['info'] = ' Beachside Avenue 21' },
[501] =  { ['x'] = -1770.67,['y'] = -677.27,['z'] = 10.38,['h'] = 132.13, ['info'] = ' Beachside Avenue 22' },
[502] =  { ['x'] = -1765.69,['y'] = -681.05,['z'] = 10.29,['h'] = 141.89, ['info'] = ' Beachside Avenue 23' },
[503] =  { ['x'] = -1791.69,['y'] = -683.89,['z'] = 10.65,['h'] = 322.32, ['info'] = ' Beachside Avenue 24' },
[504] =  { ['x'] = -1793.69,['y'] = -663.88,['z'] = 10.6,['h'] = 313.3, ['info'] = ' Beachside Avenue 25' },
[505] =  { ['x'] = -1803.64,['y'] = -662.45,['z'] = 10.73,['h'] = 10.28, ['info'] = ' Beachside Avenue 26' },
[506] =  { ['x'] = -1813.82,['y'] = -657.05,['z'] = 10.89,['h'] = 57.95, ['info'] = ' Beachside Avenue 27' },
[507] =  { ['x'] = -1819.73,['y'] = -650.15,['z'] = 10.98,['h'] = 36.31, ['info'] = ' Beachside Avenue 28' },
[508] =  { ['x'] = -1834.74,['y'] = -642.54,['z'] = 11.48,['h'] = 288.8, ['info'] = ' Beachside Avenue 29' },
[509] =  { ['x'] = -1836.49,['y'] = -631.61,['z'] = 10.76,['h'] = 260.79, ['info'] = ' Beachside Avenue 30' },
[510] =  { ['x'] = -1838.56,['y'] = -629.2,['z'] = 11.25,['h'] = 76.98, ['info'] = ' Beachside Avenue 31' },
[511] =  { ['x'] = -1872.51,['y'] = -604.06,['z'] = 11.89,['h'] = 50.69, ['info'] = ' Beachside Avenue 32' },
[512] =  { ['x'] = -1874.66,['y'] = -593.01,['z'] = 11.89,['h'] = 50.96, ['info'] = ' Beachside Avenue 33' },
[513] =  { ['x'] = -1883.28,['y'] = -578.94,['z'] = 11.82,['h'] = 138.0, ['info'] = ' Beachside Avenue 34' },
[514] =  { ['x'] = -1901.72,['y'] = -586.55,['z'] = 11.88,['h'] = 300.26, ['info'] = ' Beachside Avenue 35' },
[515] =  { ['x'] = -1913.45,['y'] = -574.22,['z'] = 11.44,['h'] = 317.93, ['info'] = ' Beachside Avenue 36' },
[516] =  { ['x'] = -1917.79,['y'] = -558.82,['z'] = 11.85,['h'] = 274.38, ['info'] = ' Beachside Avenue 37' },
[517] =  { ['x'] = -1924.05,['y'] = -559.33,['z'] = 12.07,['h'] = 45.74, ['info'] = ' Beachside Avenue 38' },
[518] =  { ['x'] = -1918.64,['y'] = -542.55,['z'] = 11.83,['h'] = 145.81, ['info'] = ' Beachside Avenue 39' },
[519] =  { ['x'] = -1947.03,['y'] = -544.07,['z'] = 11.87,['h'] = 54.28, ['info'] = ' Beachside Avenue 40' },
[520] =  { ['x'] = -1947.95,['y'] = -531.65,['z'] = 11.83,['h'] = 44.17, ['info'] = ' Beachside Avenue 41' },
[521] =  { ['x'] = -1968.27,['y'] = -532.39,['z'] = 12.18,['h'] = 317.83, ['info'] = ' Beachside Avenue 42' },
[522] =  { ['x'] = -1968.36,['y'] = -523.33,['z'] = 11.85,['h'] = 52.01, ['info'] = ' Beachside Avenue 43' },
[523] =  { ['x'] = -1980.0,['y'] = -520.54,['z'] = 11.9,['h'] = 316.92, ['info'] = ' Beachside Avenue 44' },
[524] =  { ['x'] = -1070.57,['y'] = -1653.81,['z'] = 4.41,['h'] = 306.97, ['info'] = ' Beachside Court 1' },
[525] =  { ['x'] = -1076.09,['y'] = -1645.79,['z'] = 4.51,['h'] = 313.53, ['info'] = ' Beachside Court 2' },
[526] =  { ['x'] = -1082.93,['y'] = -1631.47,['z'] = 4.74,['h'] = 303.72, ['info'] = ' Beachside Court 3' },
[527] =  { ['x'] = -1088.77,['y'] = -1623.08,['z'] = 4.74,['h'] = 299.0, ['info'] = ' Beachside Court 4' },
[528] =  { ['x'] = -1092.39,['y'] = -1607.42,['z'] = 8.47,['h'] = 124.17, ['info'] = ' Beachside Court 5' },
[529] =  { ['x'] = -1106.29,['y'] = -1596.34,['z'] = 4.6,['h'] = 228.18, ['info'] = ' Beachside Court 6' },
[530] =  { ['x'] = -1038.86,['y'] = -1609.53,['z'] = 5.0,['h'] = 152.83, ['info'] = ' Beachside Court 7' },
[531] =  { ['x'] = -1029.29,['y'] = -1603.62,['z'] = 4.97,['h'] = 129.41, ['info'] = ' Beachside Court 8' },
[532] =  { ['x'] = -1032.69,['y'] = -1582.77,['z'] = 5.14,['h'] = 24.53, ['info'] = ' Beachside Court 9' },
[533] =  { ['x'] = -1043.47,['y'] = -1580.43,['z'] = 5.04,['h'] = 235.83, ['info'] = ' Beachside Court 10' },
[534] =  { ['x'] = -1041.27,['y'] = -1591.25,['z'] = 4.99,['h'] = 31.37, ['info'] = ' Beachside Court 11' },
[535] =  { ['x'] = -1057.06,['y'] = -1587.44,['z'] = 4.61,['h'] = 40.1, ['info'] = ' Beachside Court 12' },
[536] =  { ['x'] = -1058.16,['y'] = -1540.21,['z'] = 5.05,['h'] = 217.14, ['info'] = ' Beachside Court 16' },
}