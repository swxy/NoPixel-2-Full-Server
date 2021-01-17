resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'


client_script "@np-errorlog/client/cl_errorlog.lua"

server_script "@np-fml/server/lib.lua"
server_script 'nRobbery_list.lua'
client_script 'smallRobbery_client.lua'
server_script 'smallRobbery_server.lua'


client_script 'nRobbery_client.lua'
server_script 'nRobbery_server.lua'

client_script 'pedRobbery_client.lua'

client_script 'storeRobbery_client.lua'
server_script 'storeRobbery_server.lua'

server_export 'startRobbery'

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/button.png',
	'html/electronic.png',
	'html/gruppe622.png',
	'html/gruppe62.png',
	'html/lockpick.png',
	'html/thermite.png',
	'html/airlock.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}
