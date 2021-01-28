resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'


dependencies {
    "PolyZone"
}

client_script "@np-errorlog/client/cl_errorlog.lua"
client_script "@PolyZone/client.lua"

ui_page 'nui/ui.html'

files {
	"nui/ui.html",
	"nui/pricedown.ttf",
	"nui/default.png",
	"nui/background.png",
	"nui/weight-hanging-solid.png",
	"nui/hand-holding-solid.png",
	"nui/search-solid.png",
	"nui/invbg.png",
	"nui/styles.css",
	"nui/scripts.js",
	"nui/debounce.min.js",
	"nui/loading.gif",
	"nui/loading.svg",
	"nui/icons/*"
  }

server_script "@np-fml/server/lib.lua"
shared_script 'shared_list.js'
client_script 'client.js'
client_script 'functions.lua'
server_script 'server_degradation.js'
server_script 'server_shops.js'
server_script 'server.js'
server_script 'server.lua'


exports{
	'hasEnoughOfItem',
	'getQuantity',
	'GetCurrentWeapons',
	'GetItemInfo'
}
