fx_version('bodacious')
game('gta5')

author 'Akra'
description 'Cardealer'
version '1.0'

shared_scripts {
  'config.lua',
}

client_scripts {
  	'RageUIv6/RMenu.lua',
	'RageUIv6/menu/RageUI.lua',
	'RageUIv6/menu/Menu.lua',
	'RageUIv6/menu/MenuController.lua',
	'RageUIv6/components/*.lua',
	'RageUIv6/menu/elements/*.lua',
	'RageUIv6/menu/items/*.lua',
	'RageUIv6/menu/panels/*.lua',
	'RageUIv6/menu/panels/*.lua',
	'RageUIv6/menu/windows/*.lua',
 	---------------------
	------ Client -------
	---------------------
	'client.lua',
  
}
server_scripts {
	'server.lua'
}
