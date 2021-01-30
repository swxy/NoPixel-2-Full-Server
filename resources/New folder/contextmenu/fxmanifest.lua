fx_version 'cerulean' --bodacious, adamant
games { 'rdr3', 'gta5' }

author 'Captain Darkenss (fluffebunneh twitch)'
description 'Context menu triggered via NUI and right clicking on Entities to prompt actions based on Entity type.'

client_script 'contextmenu-c.lua'
server_script 'contextmenu-s.lua'

ui_page('html/index.html')

files {
    'html/index.html',
    'html/index.js',
    'html/index.css',
    'html/reset.css'
}