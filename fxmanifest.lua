fx_version 'adamant'
games { 'gta5' }
lua54 'yes'

author 'sarmingo'
version '2.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'shared/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

client_scripts {
    'client/*.lua'
}
