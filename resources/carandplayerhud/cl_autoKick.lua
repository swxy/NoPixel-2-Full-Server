


-- Citizen.CreateThread(function()
-- 	Citizen.Wait(300000)
-- 	local id = GetPlayerServerId() -- get player ID 
-- 	while true do
--         Wait(60000) -- time to refresh script (1000 for every 1 seconds)
-- 		ptable = GetPlayers()
-- 		playerNumber = 0
-- 		for _, i in ipairs(ptable) do
-- 			playerNumber = playerNumber + 1
-- 		end
-- 		local name = GetPlayerName(PlayerId())		-- get player name
-- 		TriggerServerEvent('sendSessionPlayerNumber', playerNumber, name, id)	-- Send infos of number players for client to server
-- 	end
-- end)

-- function GetPlayers() -- function to get players
--     local players = {}

--     for i = 0, 255 do
--         if NetworkIsPlayerActive(i) then
--             players[#players+1]= i
--         end
--     end

--     return players
-- end