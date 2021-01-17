local blips = {}

local reasonsColor = {
  [1] = {"Game crashed: green-music-cola (gta-core-five.dll+4A8E0)",2},
  [2] = {"Game crashed: mockingbird-two-purple (GTA5+AA7719)",58}
}



function clearHeatMap()
  for k,v in pairs(blips) do
    RemoveBlip(v)
    blips[k] = nil
  end

end
RegisterNetEvent("heatmap:clear");
AddEventHandler("heatmap:clear", clearHeatMap);


function setHeatMap(locations)
  for k,v in pairs(locations) do
    local pos = json.decode(v[1])
    local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
    SetBlipCategory(blip, 2)
    SetBlipAsShortRange(blip, false)
    local custColor = 0
    for i=1,#reasonsColor do
      if v[2] == reasonsColor[i][1] then 
        custColor = reasonsColor[i][2]
      end
    end
    if custColor ~= 0 then
      SetBlipColour(blip,custColor)
    else
      SetBlipColour(blip, 81)
    end
    SetBlipScale(blip, 1.0)

    blips[k] = blip
  end
end
RegisterNetEvent("heatmap:set");
AddEventHandler("heatmap:set", setHeatMap);