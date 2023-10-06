fx_version 'adamant'
game 'gta5'
lua54 'yes'
version '1.0.0'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}
client_script 'client.lua'

shared_script "config.lua"