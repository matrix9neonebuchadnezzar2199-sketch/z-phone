fx_version "cerulean"
game "gta5"
lua54 "yes"
author "Alfaben"
description "iPhone 15"
version "1.0.0"

dependencies {
	"ox_lib",
	"oxmysql",
	"pma-voice",
}

-- ui_page "http://localhost:5173"
ui_page "html/index.html"

client_scripts {
	"client/**"
}

server_scripts {
  	"@oxmysql/lib/MySQL.lua",
	"server/**"
}

shared_scripts {
  	"@ox_lib/init.lua",
	"locales/init.lua",
	"locales/ja.lua",
	"config/**"
}

files {
  	"html/index.html",
	"html/**/*.png",
	"html/**/*.svg",
	"html/**/*.json",
	"html/**/*.jpg",
	"html/assets/*.css",
	"html/assets/*.js",
}