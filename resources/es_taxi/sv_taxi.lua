RegisterServerEvent('taskleavetaxi')
AddEventHandler('taskleavetaxi', function()
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)

	user:removeMoney(math.random(100,350))
end)