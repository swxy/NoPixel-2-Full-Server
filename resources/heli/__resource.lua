-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'FiveM LSPD Heli Cam by mraes'

server_script "@np-fml/server/lib.lua"
client_script "@np-infinity/client/cl_lib.lua"
server_script "@np-infinity/server/sv_lib.lua"

client_script 'heli_client.lua'
server_script 'heli_server.lua'
