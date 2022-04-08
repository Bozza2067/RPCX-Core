fx_version 'cerulean'
game 'gta5'

author 'Boz'
description 'PolicingMP Core'
version '1.0.0'

resource_type 'map' { gameTypes = { ['basic-gamemode'] = true } }
map 'map.lua'

client_script 'client.lua'
server_script 'server.lua'
shared_script 'shared.lua'
