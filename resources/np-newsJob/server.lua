
local currentArray = {}

RegisterServerEvent('light:addNews')
AddEventHandler('light:addNews', function(rgb,id,coordx,coordy,coordz)
local src = source
local array = {
    pos = {x = coordx, y = coordy, z = coordz},
    Object = id,
    rgb = rgb
}
currentArray = array
TriggerClientEvent('news:updateLights', -1, array)
end)

RegisterServerEvent('news:removeLight')
AddEventHandler('news:removeLight', function()
local src = source
for i,v in ipairs(currentArray) do
TriggerClientEvent('light:removeLight', -1, v.Object)
    end
end)