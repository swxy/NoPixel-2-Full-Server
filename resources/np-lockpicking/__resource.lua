resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'


client_script "@np-errorlog/client/cl_errorlog.lua"

server_script "@np-fml/server/lib.lua"
client_script 'lockpicking_client.lua'
server_export 'startRobbery'

export "lockpick"


ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/Drill.png',
	'html/LockFace.png',
	'html/DestroyPin.png',
	'html/HoldingPin.png',
	'html/HoldingBreak.png',
	'html/sounds/pinbreak.ogg',
	'html/sounds/lockUnlocked.ogg',
	'html/sounds/lockpick.ogg',
	'html/Drill2.png',
	'html/button.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/background2.png'
}
