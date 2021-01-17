-- Manifest
resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"


client_script "@np-errorlog/client/cl_errorlog.lua"

server_script "@np-fml/server/lib.lua"

client_script('chostility.lua')
client_script('taskconfig.lua')
client_script('client_gangtasks.lua')
server_script('server_gangtasks.lua')

server_script('sweed.lua')
server_script('smeth.lua')
server_script('slaunder.lua')
server_script('sgunrunner.lua')


-- gang 1 weed, gang 2 meth, gang 3 launder, gang 4 run runs
