local emitters = {
	
  "se_walk_radio_d_picked",
}

Citizen.CreateThread(function()
  for i = 1, #emitters do
    SetStaticEmitterEnabled(emitters[i], false)
  end
end)

Citizen.CreateThread(function()


  RequestIpl("gabz_import_milo_")
  
    interiorID = GetInteriorAtCoords(941.00840000, -972.66450000, 39.14678000)
    
    
  if IsValidInterior(interiorID) then
    --EnableInteriorProp(interiorID, "basic_style_set")
    --EnableInteriorProp(interiorID, "urban_style_set")		
    EnableInteriorProp(interiorID, "branded_style_set")
    EnableInteriorProp(interiorID, "car_floor_hatch")
    
    RefreshInterior(interiorID)
    
  end
    
end)