local currentweather = "clear"
local currenttime = 130000


RegisterServerEvent('kGetWeather')
AddEventHandler('kGetWeather', function()
TriggerClientEvent('kWeatherSync', source, currentweather)
TriggerClientEvent('kTimeSync', source, currenttime)
end)

RegisterServerEvent('kTimeSync')
AddEventHandler("kTimeSync", function(data)
    currenttime = data
    TriggerClientEvent('kTimeSync', -1, data)
end)

RegisterServerEvent('kWeatherSync')
AddEventHandler("kWeatherSync", function(wfer)
    currentweather = wfer
    TriggerClientEvent('kWeatherSync', -1, wfer)
end)

RegisterServerEvent('weather:time')
AddEventHandler('weather:time', function(src,time)
    currenttime = tonumber(time)
    TriggerClientEvent('kTimeSync', -1, time)
    TriggerClientEvent("timeheader",time)
end)

RegisterServerEvent('weather:setWeather')
AddEventHandler('weather:setWeather', function(src,weather)
    currentweather = tostring(weather)
    TriggerClientEvent('kWeatherSync', -1, weather)
end)

RegisterServerEvent('weather:setCycle')
AddEventHandler('weather:setCycle', function(src,weather)
    TriggerClientEvent('weather:setCycle', -1, weather)
end)

RegisterServerEvent('weather:blackout')
AddEventHandler('weather:blackout', function(src,boolean)
    TriggerClientEvent('weather:blackout', -1, boolean)
end)