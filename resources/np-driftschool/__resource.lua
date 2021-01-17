resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependencies {
    "PolyZone",
    "np-base"
}
server_script "@np-fml/server/lib.lua"
server_script('server.lua')

ui_page('client/html/index.html')

files({
    'client/html/index.html',
    'client/html/script.js',
})

client_scripts {
    "@PolyZone/client.lua",
    'client.lua'
}
