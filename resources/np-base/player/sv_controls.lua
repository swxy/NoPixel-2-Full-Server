RegisterServerEvent("np-base:sv:player_control_set")
AddEventHandler("np-base:sv:player_control_set", function(controlsTable)
    local src = source
    NPX.DB:UpdateControls(src, controlsTable, function(UpdateControls, err)
            if UpdateControls then
                -- we are good here.
            end
    end)
end)

RegisterServerEvent("np-base:sv:player_controls")
AddEventHandler("np-base:sv:player_controls", function()
    local src = source
    NPX.DB:GetControls(src, function(loadedControls, err)
        if loadedControls ~= nil then 
            TriggerClientEvent("np-base:cl:player_control", src, loadedControls) 
        else 
            TriggerClientEvent("np-base:cl:player_control",src, nil) print('controls fucked') 
        end
    end)
end)
