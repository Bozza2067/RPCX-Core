RiotMode = false
Blackout = false

RichPresence = {
    Enabled = true,
    AppID = "", -- ID of the Discord Application you wish to use. Leave empty to use the default FiveM one.
    AssetID = "", -- Requires you to have set an AppID and added rich presence assets.
    Text = {
        Line1 = "Cfx.re Development Kit",
        Line2 = "Experimenting a little",
    },
    -- BELOW THIS LINE IS NOT FUNCTIONING! TO CHANGE PICTURES AND LINKS YOU WILL HAVE TO GO TO CLIENT.LUA FOR NOW!
    Button1 = { 
        Text = "Connect to the server", -- NOT YET FUNCTIONING
        Link = "fivem://connect/m633od", -- NOT YET FUNCTIONING
    },
    Button2 = {
        Text = "See our website and servers list", -- NOT YET FUNCTIONING
        Link = "https://www.policingmp.net", -- NOT YET FUNCTIONING
    }
}