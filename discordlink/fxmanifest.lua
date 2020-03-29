fx_version 'bodacious'

game 'gta5'

dependancy 'mysql-async'

client_script 'client.lua'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
} 

server_export 'GetDiscordID'
