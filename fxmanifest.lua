--resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

fx_version 'adamant'

game 'gta5'

client_scripts {
    "@NativeUI/NativeUI.lua",
    "@es_extended/locale.lua",
    "config.lua",
    "locales/en.lua",
    "locales/es.lua",
    "client/client.lua"

}

server_scripts {
    "@es_extended/locale.lua",
    "config.lua",
    "server/server.lua",
}

