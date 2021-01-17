resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'


client_script "@np-errorlog/client/cl_errorlog.lua"

server_script "@np-fml/server/lib.lua"
ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

client_script	'client.lua'
server_script 'server.lua'
