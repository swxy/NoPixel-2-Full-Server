local x = "The server will restart in 15 minutes!"
local xx = "The server will restart in 10 minutes!"
local xxx = "The server will restart in 5 minutes!"
local xxxx = "The server will begin its restart process now!"

local TAX_LIST = {}

RegisterServerEvent("np-restart:checkRebootTime")
AddEventHandler('np-restart:checkRebootTime', function()
	ddd = os.date('%H:%M:%S', os.time())
	local dddd = ddd
	if dddd == '05:46:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, x)
	elseif dddd == '05:51:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xx)
	elseif dddd == '05:56:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxx)
	elseif dddd == '05:59:10' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '05:59:20' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '05:59:30' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '05:59:40' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '05:59:50' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '06:00:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '11:46:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, x)
	elseif dddd == '11:51:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xx)
	elseif dddd == '11:56:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxx)
	elseif dddd == '11:59:10' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '11:59:20' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '11:59:30' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '11:59:40' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '11:59:50' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '12:00:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '17:46:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, x)
	elseif dddd == '17:51:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xx)
	elseif dddd == '17:56:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxx)
	elseif dddd == '17:59:10' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '17:59:20' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '17:59:30' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '17:59:40' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '17:59:50' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '18:00:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '23:46:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, x)
	elseif dddd == '23:51:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xx)
	elseif dddd == '23:56:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxx)
	elseif dddd == '23:59:10' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '23:59:20' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '23:59:30' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '23:59:40' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '23:59:50' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	elseif dddd == '00:00:00' then
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, xxxx)
	end
end)

function restartNow() SetTimeout(1000, function() TriggerEvent('np-restart:checkRebootTime') restartNow() end) end
restartNow()

function getTax()
    local taxes = exports["np-votesystem"]:getTaxes()
    TAX_LIST[#TAX_LIST+1] = taxes
end