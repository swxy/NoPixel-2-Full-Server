NPX.SettingsData = NPX.SettingsData or {}
NPX.Settings = NPX.Settings or {}

NPX.Settings.Current = {}
-- Current bind name and keys
NPX.Settings.Default = {
  ["tokovoip"] = {
    ["stereoAudio"] = true,
    ["localClickOn"] = true,
    ["localClickOff"] = true,
    ["remoteClickOn"] = true,
    ["remoteClickOff"] = true,
    ["mainVolume"] = 6.0,
    ["clickVolume"] = 10.0,
    ["radioVolume"] = 5.0,
  },
  ["hud"] = {

  }

}


function NPX.SettingsData.setSettingsTable(settingsTable,shouldSend)
  if settingsTable == nil then
    NPX.Settings.Current = NPX.Settings.Default
    TriggerServerEvent('np-base:sv:player_settings_set',NPX.Settings.Current)
    NPX.SettingsData.checkForMissing()
  else
    if shouldSend then
      NPX.Settings.Current = settingsTable
      TriggerServerEvent('np-base:sv:player_settings_set',NPX.Settings.Current)
      NPX.SettingsData.checkForMissing()
    else
       NPX.Settings.Current = settingsTable
       NPX.SettingsData.checkForMissing()
    end
  end

  TriggerEvent("event:settings:update",NPX.Settings.Current)

end

function NPX.SettingsData.setSettingsTableGlobal(self,settingsTable)
  NPX.SettingsData.setSettingsTable(settingsTable,true);
end

function NPX.SettingsData.getSettingsTable()
    return NPX.Settings.Current
end

function NPX.SettingsData.setVarible(self,tablename,atrr,val)
  NPX.Settings.Current[tablename][atrr] = val
  TriggerServerEvent('np-base:sv:player_settings_set',NPX.Settings.Current)
end

function NPX.SettingsData.getVarible(self,tablename,atrr)
  return NPX.Settings.Current[tablename][atrr]
end

function NPX.SettingsData.checkForMissing()
  local isMissing = false

  for j,h in pairs(NPX.Settings.Default) do
    if NPX.Settings.Current[j] == nil then
      isMissing = true
      NPX.Settings.Current[j] = h
    else
      for k,v in pairs(h) do
        if  NPX.Settings.Current[j][k] == nil then
           NPX.Settings.Current[j][k] = v
           isMissing = true
        end
      end
    end
  end
  

  if isMissing then
    TriggerServerEvent('np-base:sv:player_settings_set',NPX.Settings.Current)
  end


end

RegisterNetEvent("np-base:cl:player_settings")
AddEventHandler("np-base:cl:player_settings", function(settingsTable)
  NPX.SettingsData.setSettingsTable(settingsTable,false)
end)


RegisterNetEvent("np-base:cl:player_reset")
AddEventHandler("np-base:cl:player_reset", function(tableName)
  if NPX.Settings.Default[tableName] then
      if NPX.Settings.Current[tableName] then
        NPX.Settings.Current[tableName] = NPX.Settings.Default[tableName]
        NPX.SettingsData.setSettingsTable(NPX.Settings.Current,true)
      end
  end
end)