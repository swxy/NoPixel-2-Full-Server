fx_version 'bodacious'
games { 'rdr3', 'gta5' }

author 'whitewingz'
description 'One City Truckerjob'
version '1.0.0'
server_script "server.lua"
client_script "truckerjob.lua"
server_export 'AddJob' 

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
}