resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

dependency "np-base"
dependency "ghmattimysql"


client_script "@np-errorlog/client/cl_errorlog.lua"

client_script "client/cl_storage.lua"


exports {
	'tryGet',
	'remove',
	'set'
} 