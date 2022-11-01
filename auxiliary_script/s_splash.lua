Config.Splash = {
	Header_IMG = 'https://forum.cfx.re/uploads/default/original/3X/a/6/a6ad03c9fb60fa7888424e7c9389402846107c7e.png',
	Enabled = true,
	Wait = 10, -- How many seconds should splash page be shown for? (Max is 12)
	Heading1 = "Welcome to [ServerName]",
	Heading2 = "Make sure to join our Discord and check out our website!",
	Discord_Link = 'https://discord.gg',
	Website_Link = 'https://badger.store',
}

card = {
    "type":"AdaptiveCard",
    "$schema":"http://adaptivecards.io/schemas/adaptive-card.json",
    "version":"1.3",
    "body":[
       {
          "type":"Image",
          "url":"' .. Config.Splash.Header_IMG .. '",
          "horizontalAlignment":"Center"
       },
       {
          "type":"Container",
          "items":[
             {
                "type":"TextBlock",
                "text":"Badger_Discord_API",
                "wrap":true,
                "fontType":"Default",
                "size":"ExtraLarge",
                "weight":"Bolder",
                "color":"Light",
                "horizontalAlignment":"Center"
             },
             {
                "type":"TextBlock",
                "text":"' .. Config.Splash.Heading1 .. '",
                "wrap":true,
                "size":"Large",
                "weight":"Bolder",
                "color":"Light",
                "horizontalAlignment":"Center"
             },
             {
                "type":"TextBlock",
                "text":"' .. Config.Splash.Heading2 .. '",
                "wrap":true,
                "color":"Light",
                "size":"Medium",
                "horizontalAlignment":"Center"
             },
             {
                "type":"ColumnSet",
                "height":"stretch",
                "minHeight":"100px",
                "bleed":true,
                "horizontalAlignment":"Center",
                "columns":[
                   {
                      "type":"Column",
                      "width":"stretch",
                      "items":[
                         {
                            "type":"ActionSet",
                            "actions":[
                               {
                                  "type":"Action.OpenUrl",
                                  "title":"Discord",
                                  "url":"' .. Config.Splash.Discord_Link .. '",
                                  "style":"positive"
                               }
                            ]
                         }
                      ],
                      "height":"stretch"
                   },
                   {
                      "type":"Column",
                      "width":"stretch",
                      "items":[
                         {
                            "type":"ActionSet",
                            "actions":[
                               {
                                  "type":"Action.OpenUrl",
                                  "title":"Website",
                                  "style":"positive",
                                  "url":"' .. Config.Splash.Website_Link .. '"
                               }
                            ]
                         }
                      ]
                   }
                ]
             },
             {
                "type":"ActionSet",
                "actions":[
                   {
                      "type":"Action.OpenUrl",
                      "title":"Click to join Badger\\'s Discord",
                      "style":"destructive",
                      "iconUrl":"https://i.gyazo.com/0904b936e8e30d0104dec44924bd2294.gif",
                      "url":"https://discord.com/invite/WjB5VFz"
                   }
                ]
             }
          ],
          "style":"default",
          "bleed":true,
          "height":"stretch"
       },
       {
          "type":"Image",
          "url":"https://i.gyazo.com/7e896862b14be754ae8bad90b664a350.png",
          "selectAction":{
             "type":"Action.OpenUrl",
             "url":"https://zap-hosting.com/badger"
          },
          "horizontalAlignment":"Center"
       }
    ]
 }'

--[[ AddEventHandler('playerConnecting', function(name, setKickReason, deferrals) 
	-- Player is connecting
	deferrals.defer();
	local src = source;
	local toEnd = false;
	local count = 0;
	while not toEnd do 
		deferrals.presentCard(card,
		function(data, rawData)
		end)
		Wait((1000))
		count = count + 1;
		if count == Config.Splash.Wait then 
			toEnd = true;
		end
	end
	deferrals.done();
end) ]]