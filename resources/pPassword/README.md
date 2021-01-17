# pPassword
A simple fivem password resource using adaptive cards.

# Useful links
- [FiveM's cookbook about adaptive cards](https://forum.fivem.net/t/adaptive-cards-in-deferrals/612598)
- [AdaptiveCards.io](https://adaptivecards.io/)
- [AdaptiveCards designer](https://adaptivecards.io/designer/)

# Installing
- Download the resource
- Drop everything in a folder called `ppassword` (whatever you want) in your `resources` folder.
- Start the resource

# Configuration
Everything you need is in `config.json`
```json
{
    "serverPassword": "12345",
    "serverName": "GTALife",
    "serverWebsite": "https://www.gtaliferp.fr",
    "serverLogo": "https://gtaliferp.fr/img/logo+hi.png",

    "cardTitle": "Access denied. Please enter server's password",
    "enterText": "Enter",
    "passwordPlaceholder": "Password",
    "wrongPasswordMessage" : "This is not the right password."
}
```

# Building
```
npm install
npm run build
```

# Preview
![preview](https://i.imgur.com/fJH1y9m.png)