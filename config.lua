RiotMode = false -- Default state of riot mode
Blackout = false -- Default state of blackout mode
BetterFlashlightInstalled = true -- Set this to true when BetterFlashlight is installed (https://miraf.tebex.io/package/4941283)

-- Set your map name and game type for the FiveM server browser
MapName = "San Andreas"
GameType = "Freeroam"

-- Discord Rich Presence
RichPresence = {
	Enabled = true,
	AppID = "", -- ID of the Discord Application you wish to use. Leave empty to use the default FiveM one.
	AssetID = "", -- Requires you to have set an AppID and added rich presence assets to that application.
	Text = {
		Line1 = "RPCX PolicingMP Experimental",
		Line2 = "Probably Testing stuff for PMP, SAR, or NWRP.",
	},
	-- BELOW THIS LINE IS NOT FUNCTIONING! TO CHANGE PICTURES AND LINKS YOU WILL HAVE TO GO TO CLIENT.LUA FOR NOW!
	Button1 = { 
		Text = "Connect to the server", -- NOT YET FUNCTIONING
		Link = "fivem://connect/m633od", -- NOT YET FUNCTIONING
	},
	Button2 = {
		Text = "See our website and servers list", -- NOT YET FUNCTIONING
		Link = "https://www.policingmp.net", -- NOT YET FUNCTIONING
	},
}

-- Map Blips
blips = {
	{
		type = "Coffee Shop", -- Type of location, best to keep this consistent with others of the same type.
		id = 76,  -- Blip ID to display (https://docs.fivem.net/docs/game-references/blips/)
		-- Coordinates
		x = -1281.38, 
		y = -1129.33, 
		z = 6.91, 
		name = "Bean Machine", -- Name of location
		image = "beanmachine_vespucci",  -- Name of 256x128 image in mapimages.ytd to use 
		address = "1/8106 Magellan Avenue, Los Santos, SA", -- Address of location
		description = "Rainier-based coffeehouse chain known for its signature roasts, light bites and WiFi availability.", -- Description of location. Leave empty to igmore.
		lowpriority = true, -- Setting this to false will make it appear on the minimap at all times, even if it's not visible there.
		--[[ THIS SECTION IS A WORK IN PROGRESS AND DOESN'T WORK!
			Check1 = { Title = "Dine-in", Value = 79, },
			Check2 = { Title = "Drive-through", Value = 80, },
			Check3 = { Title = "Delivery", Value = 79, },
		]]
		website = "beanmachinecoffee.com",
		phone = "+1 310-555-0134",
	},
	{
		type = "Coffee Shop",
		id = 76,
		x = -477.11, 
		y = 1116.29, 
		z = 320.23, 
		name = "Bean Machine",
		image = "beanmachine_galileo",
		address = "Galileo Observatory, Los Santos, SA",
		description = "Rainier-based coffeehouse chain known for its signature roasts, light bites and WiFi availability.",
		lowpriority = true,
		website = "beanmachinecoffee.com",
		phone = "+1 323-555-0231",
	},
}