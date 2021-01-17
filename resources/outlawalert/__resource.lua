resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

--resource_type 'gametype' { name = 'Hot Putsuit' }
client_script "@np-errorlog/client/cl_errorlog.lua"

-- server_script "@np-fml/server/lib.lua"
client_script "@np-infinity/client/cl_lib.lua"
server_script "@np-infinity/server/sv_lib.lua"

server_script "server.lua"
client_script "client.lua"
