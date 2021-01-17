description "Simple Notification Script using https://notifyjs.com/"

ui_page "html/index.html"

client_script "@np-errorlog/client/cl_errorlog.lua"
client_script "cl_notify.lua"

export "SetQueueMax"
export "SendNotification"

files {
    "html/index.html",
    "html/pNotify.js",
    "html/noty.js",
    "html/noty.css",
    "html/themes.css",
    "html/sound-example.wav"
}