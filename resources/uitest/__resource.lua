resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"
client_script "@np-errorlog/client/cl_errorlog.lua"
client_script('client/client.lua')

ui_page('client/html/index.html')

files({
    'client/html/index.html',
    'client/html/script.js',
    'client/html/style.css',
    'client/html/cursor.png',
    'client/html/menuButton.png',
    'client/html/menuButtonJudge.png',
    'client/html/menuButtonEms.png',
    'client/html/menuButtonPolice.png'
})