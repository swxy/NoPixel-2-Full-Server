Citizen.CreateThread(function()
	local id = GetPlayerServerId() -- get player ID 
	while true do
        Wait(10000) -- time to refresh script (10 000 for every 1 seconds)
		ptable = GetPlayers()
		playerNumber = 0
		for _, i in ipairs(ptable) do
			playerNumber = playerNumber + 1
		end
		local name = GetPlayerName(PlayerId())		-- get player name
		TriggerServerEvent('sendSessionPlayerNumber', playerNumber, name, id)	-- Send infos of number players for client to server
	end
end)

function GetPlayers() -- function to get players
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end