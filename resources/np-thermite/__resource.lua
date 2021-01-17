resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'


client_script "@np-errorlog/client/cl_errorlog.lua"

client_script 'thermite_client.lua'
server_script 'thermite_server.lua'

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/button.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/backgroundwhite.png',
	'html/sounds/failure.ogg',
	'html/sounds/hit.ogg',
	'html/sounds/success.ogg',
	'html/sounds/Thermite.ogg'
}


exports{
	'startFireAtLocation',
	'startGame'
}