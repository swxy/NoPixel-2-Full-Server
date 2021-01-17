resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"
client_script "@np-errorlog/client/cl_errorlog.lua"


client_script {
  "gui.lua",
  "cl_towgarage.lua",
  "sh_tow.lua"
}
server_script "sv_towgarage.lua"
