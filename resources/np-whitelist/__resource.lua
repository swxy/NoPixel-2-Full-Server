resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

dependency "connectqueue"
dependency "ghmattimysql"


server_script "@connectqueue/connectqueue.lua"

server_script "sv_whitelist.lua"