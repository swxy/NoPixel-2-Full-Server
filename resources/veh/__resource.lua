
client_script "@np-errorlog/client/cl_errorlog.lua"

server_scripts {
	"server.lua"
}

client_scripts {
	"client.lua"
}

exports {
	"checkPlayerOwnedVehicle",
	"setPlayerOwnedVehicle",
	"trackVehicleHealth"
}