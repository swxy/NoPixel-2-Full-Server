resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

server_script "@np-fml/server/lib.lua"

client_script "@np-errorlog/client/cl_errorlog.lua"

client_script {
  "cl_broadcast.lua"
}
server_script "sv_broadcast.lua"
