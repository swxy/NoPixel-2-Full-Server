resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

dependencies {
  "PolyZone",
  "np-base"
}

server_script "@np-fml/server/lib.lua"
server_script "vehshop_s.lua"

client_scripts {
    "@PolyZone/client.lua",
    "@np-errorlog/client/cl_errorlog.lua",
    "vehshop.lua"
  }
