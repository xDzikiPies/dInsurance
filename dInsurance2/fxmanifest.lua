fx_version 'adamant'

game 'gta5'

author 'DzikiPies'

version '1.0.0'

shared_scripts {'@es_extended/imports.lua', 'config.lua'}



client_scripts {
    'client.lua'
}

server_scripts {
'server.lua',
'@mysql-async/lib/MySQL.lua',
}