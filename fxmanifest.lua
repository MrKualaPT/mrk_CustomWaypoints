fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
author 'MrKuala'
version '1.0'
description 'Save and mark your favorite spots! Create custom waypoints anywhere on the map.'

shared_scripts {
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'