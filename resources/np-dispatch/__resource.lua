resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependencies {
    "ghmattimysql",
    -- "yarn"
} 

files {
    'client/dist/index.html',
    'client/dist/js/app.js',
    'client/dist/css/app.css',
}
-- I started work on a server component in NodeJS, it's going to require
-- a lot more work tho...
client_script 'client/*.lua'
-- server_script "@np-fml/server/lib.lua"
server_script {
    'server/*.lua',
    -- 'server/*.js'
}

ui_page 'client/dist/index.html'
