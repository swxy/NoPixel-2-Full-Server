local WeaponShots, WeaponObjectEqual, CurrentWeapon, IsArmed, PlayerPed = {}, nil, nil, false, PlayerPedId()

function AddCount(weapon)
  if WeaponShots[weapon] == nil then WeaponShots[weapon] = 0 end

  WeaponShots[weapon] =  WeaponShots[weapon] + 1
end

Citizen.CreateThread(function()
  while true do
    PlayerPed = PlayerPedId()
    IsArmed = IsPedArmed(PlayerPed, 6)
    if IsArmed then
      WeaponObjectEqual, CurrentWeapon = GetCurrentPedWeapon(PlayerPed, 1)
    else
      WeaponObjectEqual, CurrentWeapon = nil, nil
    end
    Citizen.Wait(200)
  end
end)

Citizen.CreateThread(function()
  while true do
    for weapon, shots in pairs(WeaponShots) do
      if shots > 0 then
        TriggerServerEvent('np:stats:weaponPopularity', weapon, WeaponShots[weapon])
        WeaponShots[weapon] = 0
      end
    end

    Citizen.Wait(10000)
  end
end)

Citizen.CreateThread(function()
  while true do
    local idle = 200
    if IsArmed and CurrentWeapon then
      if IsPedShooting(PlayerPed) then
        AddCount(CurrentWeapon)
      end
      idle = 0
    end
    Citizen.Wait(idle)
  end
end)