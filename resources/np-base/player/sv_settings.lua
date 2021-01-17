RegisterServerEvent("np-base:sv:player_settings_set")
AddEventHandler("np-base:sv:player_settings_set", function(settingsTable)
    local src = source
    NPX.DB:UpdateSettings(src, settingsTable, function(UpdateSettings, err)
            if UpdateSettings then
                -- we are good here.
            end
    end)
end)

RegisterServerEvent("np-base:sv:player_settings")
AddEventHandler("np-base:sv:player_settings", function()
    local src = source
    NPX.DB:GetSettings(src, function(loadedSettings, err)
        if loadedSettings ~= nil then 
            TriggerClientEvent("np-base:cl:player_settings", src, loadedSettings) 
        else 
            TriggerClientEvent("np-base:cl:player_settings",src, nil) 
        end
    end)
end)
