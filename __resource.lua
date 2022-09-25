resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
description 'ESX Speedcamera'

version '1.1'

server_scripts {
  '@es_extended/locale.lua',
  'locales/en.lua',
  'locales/nl.lua',
  'config.lua',
  'server/main.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  'locales/en.lua',
  'locales/nl.lua',
  'config.lua',
  'client/main.lua'
}

ui_page('html/index.html')

files {
    'html/index.html'
}