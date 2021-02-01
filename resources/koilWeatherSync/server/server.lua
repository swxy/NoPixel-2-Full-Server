
local currentweather = "CLEAR"
local currenttime = 130000


RegisterServerEvent('kGetWeather')
AddEventHandler('kGetWeather', function()
    print('Set Weather', source, currentweather)
    print('Set Time', source, currenttime)
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
AddEventHandler('weather:time', function(src, time)
    currenttime = tonumber(time)
    TriggerClientEvent('kTimeSync', -1, time)
    TriggerClientEvent("timeheader", time)
end)

RegisterServerEvent('weather:setWeather')
AddEventHandler('weather:setWeather', function(src, weather)
    currentweather = tostring(weather)
    TriggerClientEvent('kWeatherSync', -1, weather)
end)


RegisterCommand('syncallweather', function()
    TriggerClientEvent('kWeatherSync', -1, currentweather)
    TriggerClientEvent('kTimeSync', -1, currenttime)
end, false)


RegisterServerEvent('weather:receivefromcl')
AddEventHandler('weather:receivefromcl', function(secondsofday)
currenttime = secondsofday
end)

