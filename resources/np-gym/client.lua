workoutAreas = {
  [1] = { ["x"] = -1196.9790039063,["y"] = -1572.8973388672,["z"] = 4.6126470565796, ["h"] = 211.11492919922, ["workType"] = "Weights", ["emote"] = "weights" },
  [2] = { ["x"] = -1199.0599365234,["y"] = -1574.4929199219,["z"] = 4.6096420288086, ["h"] = 213.6491394043, ["workType"] = "Weights", ["emote"] = "weights" },
  [3] = { ["x"] = -1200.5871582031,["y"] = -1577.504516601,["z"] = 4.6084971427918, ["h"] = 312.37738037109, ["workType"] = "Pushups", ["emote"] = "pushUps" },
  [4] = { ["x"] = -1196.0134277344,["y"] = -1567.369140625,["z"] = 4.6165833473206, ["h"] = 308.9084777832, ["workType"] = "Situps", ["emote"] = "situps" },
  [5] = { ["x"] = -1215.0224609375,["y"] = -1541.6857910156,["z"] = 4.7281851768494, ["h"] = 119.79830169678, ["workType"] = "Yoga", ["emote"] = "Yoga" },
  [6] = { ["x"] = -1217.5916748047,["y"] = -1543.162109375,["z"] = 4.7207465171814, ["h"] = 119.81834411621, ["workType"] = "Yoga", ["emote"] = "yoga" },
  [7] = { ["x"] = -1220.8453369141,["y"] = -1545.0277099609,["z"] = 4.6919565200806, ["h"] = 119.8260345459, ["workType"] = "Yoga", ["emote"] = "yoga" },
  [8] = { ["x"] = -1224.6988525391,["y"] = -1547.2470703125,["z"] = 4.6254777908325, ["h"] = 119.86821746826, ["workType"] = "Yoga", ["emote"] = "yoga" },
  [9] = { ["x"] = -1228.4945068359,["y"] = -1549.4294433594,["z"] = 4.5562300682068, ["h"] = 119.87698364258, ["workType"] = "Yoga", ["emote"] = "yoga" },

  [10] =  { ['x'] = -1253.41,['y'] = -1601.65,['z'] = 3.15,['h'] = 213.34, ['info'] = ' Chinups 1', ["workType"] = "Chinups", ["emote"] = "chinups" },
  [11] =  { ['x'] = -1252.43,['y'] = -1603.14,['z'] = 3.13,['h'] = 213.78, ['info'] = ' Chinups 2', ["workType"] = "Chinups", ["emote"] = "chinups" },
  [12] =  { ['x'] = -1251.26,['y'] = -1604.81,['z'] = 3.14,['h'] = 217.94, ['info'] = ' Chinups 3', ["workType"] = "Chinups", ["emote"] = "chinups" },

}
local inprocess = false
local returnedPass = false
local workoutType = 0


RegisterNetEvent('event:control:gym')
AddEventHandler('event:control:gym', function(useID)
  if not inprocess then
    returnedPass = false
    workoutType = useID
   -- TriggerServerEvent("server:pass","gym")
    TriggerEvent("doworkout")
  end
end)


function DrawText3DTest(x,y,z, text)
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


Citizen.CreateThread(function()
    while true do
      local playerped = PlayerPedId()
      local plyCoords = GetEntityCoords(playerped)        
      local waitCheck2 = #(GetEntityCoords( PlayerPedId() ) - vector3(-1253.41,-1601.65,4.556230068206))
      local waitCheck = #(GetEntityCoords( PlayerPedId() ) - vector3(-1228.4945068359,-1549.4294433594,4.556230068206))
      if (waitCheck > 40.0 and waitCheck2 > 40.0 ) or inprocess then
        Citizen.Wait(math.ceil(waitCheck))
      else
        Citizen.Wait(1)
        for i = 1, #workoutAreas do
          local distCheck = #(GetEntityCoords( PlayerPedId() ) - vector3(workoutAreas[i]["x"], workoutAreas[i]["y"], workoutAreas[i]["z"]))
          if distCheck < 4.0 then
            DrawText3DTest(workoutAreas[i]["x"], workoutAreas[i]["y"], workoutAreas[i]["z"], "[E] to do " .. workoutAreas[i]["workType"] .. "" )
          end
        end
      end
    end
end)

RegisterNetEvent('doworkout')
AddEventHandler('doworkout', function()
    inprocess = true
    SetEntityCoords(PlayerPedId(),workoutAreas[workoutType]["x"],workoutAreas[workoutType]["y"],workoutAreas[workoutType]["z"])
    SetEntityHeading(PlayerPedId(),workoutAreas[workoutType]["h"])
    TriggerEvent("animation:PlayAnimation",workoutAreas[workoutType]["emote"])
    Citizen.Wait(30000)
    TriggerEvent("client:newStress",false,math.ceil(450))
    TriggerEvent("animation:PlayAnimation","cancel")
    inprocess = false
end)