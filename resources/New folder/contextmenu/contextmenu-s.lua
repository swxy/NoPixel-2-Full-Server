RegisterServerEvent("exportEntity")
AddEventHandler( "exportEntity", function(target, type, hash, model, coords, heading, rotation)
    --Opens a file in Append mode ("a"), stores entity data
    local file = io.open("entity-data.txt", "a")
    io.output(file)
    io.write("(Entity: ", target, 
        ", \nEntity type: ", type, 
        ", \nEntity Hash: ", hash, 
        ", \nEntity Model: ", model, 
        ", \nEntity Coords: ", coords, 
        ", \nEntity Heading: ", heading, 
        ", \nEntity Rotation: ", rotation, "), \n")
    io.close(file)
end)

RegisterServerEvent("stealing")
AddEventHandler("stealing", function(entityCoords)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    local marginOfError = 0.2
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then --If the target isnt yourself
            local targetCoords = GetEntityCoords(target, 0)
            local distance = #(targetCoords - plyCoords)
            if(closestDistance == -1 or closestDistance > distance) then
                if #(entityCoords - targetCoords) < marginOfError then
                    closestPlayer = value --Use this to grab the player from the database
                    closestDistance = distance
                    --Database call to take money from the other player and give it to yourself.
                end
            end
        end
    end
end)