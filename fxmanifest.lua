fx_version 'adamant'
games {'gta5'} 
lua54 'yes'

author 'sarmingo'
version '2.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'shared/*.lua',
    '@oxmysql/lib/MySQL.lua'
}

server_scripts{
'server/*.lua',
}

client_scripts{
'client/*.lua'
}

dependencies {
    'sarmingo-ui',
    'screenshot-basic'
}
