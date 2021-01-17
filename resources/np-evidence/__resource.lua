resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_script "@np-errorlog/client/cl_errorlog.lua"

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/css/site.css',
	'html/css/materialize.min.css',
	'html/js/site.js',
	'html/js/materialize.min.js',
	'html/js/moment.min.js',
	'html/images/bag_texture.png',
	'html/images/cursor.png'
	--[[
	'html/ui.html',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js']]--
}

client_script	'client.lua'
server_script 'server.lua'
