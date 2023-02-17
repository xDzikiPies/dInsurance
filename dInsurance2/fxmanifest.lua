fx_version 'adamant'

game 'gta5'

lua54 'yes'

author 'DzikiPies'

version '1.0.3'

shared_scripts {'@es_extended/imports.lua', 'config.lua', '@ox_lib/init.lua'}



client_scripts {
    'client.lua'
}

server_scripts {
'server.lua',
'@mysql-async/lib/MySQL.lua'
}