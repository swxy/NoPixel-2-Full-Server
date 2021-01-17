resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_script "@np-errorlog/client/cl_errorlog.lua"

server_script "@np-fml/server/lib.lua"
client_script 'weashop.lua'
server_script 'sv_weashop.lua'

export 'ShowWeashopBlips'
