local webhook = 'https://discord.com/api/webhooks/794144881588961310/6SJYFpSdmd8xyTgMcWWI3awUDoF7uQT7wbZ53uTNscMm0YIt_DMF7Ti16PAn3H3MX4JW'


RegisterServerEvent('sway:arthur-morgan-best-story-char-ever')
AddEventHandler('sway:arthur-morgan-best-story-char-ever', function()
    print('detekted ' .. GetPlayerName(source))
    sendToDiscord("Asshole Logged", GetPlayerName(source).." tried to use nui_devtools at "..os.time())
    DropPlayer(source, 'Hmm, what you wanna do in this inspector?')
end)

function sendToDiscord(name, args, color)
    local connect = {
          {
              ["color"] = 16711680,
              ["title"] = "".. name .."",
              ["description"] = args,
              ["footer"] = {
                  ["text"] = "Made by sway",
              },
          }
      }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Asshole Log", embeds = connect, avatar_url = "https://miro.medium.com/max/1000/1*MqFcwBk0Vr8UsFDVV-1Zfg.gif"}), { ['Content-Type'] = 'application/json' })
end



