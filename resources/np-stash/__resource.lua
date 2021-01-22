resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

dependency "ghmattimysql"

client_script 'stashhouse_client.lua'

server_scripts {
	'server/stashhouse_server.lua',
	'server/svstashes.lua',
}

export "stash"


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
