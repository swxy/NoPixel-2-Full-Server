activeTasks = {}

workArray = {
    [1] =  { ['x'] = 1062.82,['y'] = -3193.71,['z'] = -39.1,['h'] = 90.73, ['info'] = ' Replace Rubber Connectors', ["itemid"] = 33, ["name"] = "Rubber" },
    [2] =  { ['x'] = 1051.63,['y'] = -3190.59,['z'] = -39.13,['h'] = 218.47, ['info'] = ' Replace Rubber Connectors', ["itemid"] = 33, ["name"] = "Rubber" },
    [3] =  { ['x'] = 1057.61,['y'] = -3200.09,['z'] = -39.1,['h'] = 86.26, ['info'] = ' Replace Rubber Connectors', ["itemid"] = 33, ["name"] = "Rubber" },
    [4] =  { ['x'] = 1052.32,['y'] = -3200.44,['z'] = -39.12,['h'] = 87.33, ['info'] = ' Replace Rubber Connectors', ["itemid"] = 33, ["name"] = "Rubber" },
    [5] =  { ['x'] = 1051.33,['y'] = -3205.98,['z'] = -39.13,['h'] = 203.85, ['info'] = ' Replace Rubber Connectors', ["itemid"] = 33, ["name"] = "Rubber" },
    [6] =  { ['x'] = 1063.36,['y'] = -3203.75,['z'] = -39.13,['h'] = 85.81, ['info'] = ' Replace Rubber Connectors', ["itemid"] = 33, ["name"] = "Rubber" },
    [7] =  { ['x'] = 1054.39,['y'] = -3195.28,['z'] = -39.16,['h'] = 94.82, ['info'] = ' Repair Plastic Pots', ["name"] = "Plastic", ["itemid"] = 27 },
    [8] =  { ['x'] = 1056.83,['y'] = -3192.5,['z'] = -39.16,['h'] = 15.33, ['info'] = ' Repair Plastic Pots', ["name"] = "Plastic", ["itemid"] = 27 },
    [9] =  { ['x'] = 1060.07,['y'] = -3198.42,['z'] = -39.16,['h'] = 264.41, ['info'] = ' Repair Plastic Pots', ["name"] = "Plastic", ["itemid"] = 27 },
    [10] =  { ['x'] = 1057.84,['y'] = -3203.5,['z'] = -39.15,['h'] = 173.21, ['info'] = ' Repair Plastic Pots', ["name"] = "Plastic", ["itemid"] = 27 },
    [11] =  { ['x'] = 1064.76,['y'] = -3189.45,['z'] = -39.14,['h'] = 261.02, ['info'] = ' Repair Lighting with Glass', ["name"] = "Glass", ["itemid"] = 28 },
}


workArray2 = {
    [1] =  { ['x'] = 1089.95,['y'] = -3198.86,['z'] = -38.99,['h'] = 184.41, ['info'] = ' Check Product', ["itemid"] = 33, ["name"] = "Rubber" },
    [2] =  { ['x'] = 1093.53,['y'] = -3199.12,['z'] = -38.99,['h'] = 178.7, ['info'] = ' Check Product', ["itemid"] = 33, ["name"] = "Rubber" },
    [3] =  { ['x'] = 1100.16,['y'] = -3198.62,['z'] = -38.99,['h'] = 196.58, ['info'] = ' Check Product', ["itemid"] = 33, ["name"] = "Rubber" },
    [4] =  { ['x'] = 1100.93,['y'] = -3193.77,['z'] = -38.99,['h'] = 353.0, ['info'] = ' Check Product', ["itemid"] = 33, ["name"] = "Rubber" },
    [5] =  { ['x'] = 1087.29,['y'] = -3196.9,['z'] = -38.99,['h'] = 81.27, ['info'] = ' Check Product', ["itemid"] = 33, ["name"] = "Rubber" },
}


clientstockamount = {
  [1] = { ["value"] = 3.00 },
  [2] = { ["value"] = 0.00 },
  [3] = { ["value"] = 0.00 },
  [4] = { ["value"] = 0.00 },
  [5] = { ["value"] = 0.00 },
  [6] = { ["value"] = 0.00 },
}
RegisterNetEvent('stocks:clientvalueupdate');
AddEventHandler('stocks:clientvalueupdate', function(sentvalues)
    clientstockamount = sentvalues
end)


RegisterNetEvent('weed:currentStatus')
AddEventHandler('weed:currentStatus', function(weed_level,weed_percent,weed_status,weed_amount)
    TriggerEvent("chatMessage", "TASK ", { 195, 255, 255 }, "Current Batch: " .. weed_percent .. "% | Crates Available: " .. weed_amount)
end)

RegisterNetEvent('weed:currentStatusServer')
AddEventHandler('weed:currentStatusServer', function()
    TriggerServerEvent("weed:currentStatus")
end)

RegisterNetEvent('weed:weedCrate')
AddEventHandler('weed:weedCrate', function()
    TriggerServerEvent("weed:takeCrateServer")
end)

RegisterNetEvent('gunrunner:currentStatus')
AddEventHandler('gunrunner:currentStatus', function(gunrunner_level,gunrunner_percent,gunrunner_status,gunrunner_amount)
    if gunrunner_status == 0 then gunrunner_status = "No Task Being Done" else gunrunner_status = "Task In Process" end
    TriggerEvent("chatMessage", "TASK ", { 195, 255, 255 }, "Current Batch: " .. gunrunner_percent .. "% | Crates Available: " .. gunrunner_amount)
end)

RegisterNetEvent('gunrunner:currentStatusServer')
AddEventHandler('gunrunner:currentStatusServer', function()
    TriggerServerEvent("gunrunner:currentStatus")
end)

RegisterNetEvent('gunrunner:takeCrate')
AddEventHandler('gunrunner:takeCrate', function()
    TriggerServerEvent("gunrunner:takeCrateServer")

end)





RegisterNetEvent('launder:currentStatus')
AddEventHandler('launder:currentStatus', function(launder_level,launder_percent,launder_status,launder_amount)
    if launder_status == 0 then launder_status = "No Task Being Done" else launder_status = "Task In Process" end
    TriggerEvent("chatMessage", "TASK ", { 195, 255, 255 }, "Current Batch: " .. launder_percent .. "% | Crates Available: " .. launder_amount)
end)

RegisterNetEvent('launder:currentStatusServer')
AddEventHandler('launder:currentStatusServer', function()
    TriggerServerEvent("launder:currentStatus")
end)

RegisterNetEvent('launder:launderCrate')
AddEventHandler('launder:launderCrate', function()
    TriggerServerEvent("launder:launderCrateServer")
end)





RegisterNetEvent('cocaine:currentStatus')
AddEventHandler('cocaine:currentStatus', function(cocaine_level,cocaine_percent,cocaine_status,cocaine_amount)
    if cocaine_status == 0 then cocaine_status = "No Task Being Done" else cocaine_status = "Task In Process" end
    TriggerEvent("chatMessage", "TASK ", { 195, 255, 255 }, "Current Batch: " .. cocaine_percent .. "% | Crates Available: " .. cocaine_amount)
end)

RegisterNetEvent('cocaine:currentStatusServer')
AddEventHandler('cocaine:currentStatusServer', function()
   
    TriggerServerEvent("cocaine:currentStatus")
end)

RegisterNetEvent('cocaine:methCrate')
AddEventHandler('cocaine:methCrate', function()
    TriggerEvent("pixerium:check",15,"cocaine:takeCrateServer",true)
end)


























RegisterNetEvent("gangTasks:updateClients")
AddEventHandler("gangTasks:updateClients", function(newTasks)
	activeTasks = newTasks
end)

function DrawText3DTest(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.31, 0.31)
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

function loadModel(modelName)
    RequestModel(GetHashKey(modelName))
    while not HasModelLoaded(GetHashKey(modelName)) do
        RequestModel(GetHashKey(modelName))
        Citizen.Wait(1)
    end
end

function loadAnim( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 


function SetGps(TaskNumber)
    SetNewWaypoint(activeTasks[TaskNumber]["Location"]["x"],activeTasks[TaskNumber]["Location"]["y"])
end

deliveryCoords = {
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