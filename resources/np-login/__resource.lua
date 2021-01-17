resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

dependency "np-base"

--server_script "@np-fml/server/lib.lua"
ui_page "html/index.html"

files({
    "html/index.html",
    "html/script.js",
    "html/styles.css",
    "html/cursor.png",
    "html/header.png"
})

server_script "server/sv_login.lua"

--client_script "@np-errorlog/client/cl_errorlog.lua"
client_script "client/cl_login.lua"
client_script "client/cl_cswitch.lua"
