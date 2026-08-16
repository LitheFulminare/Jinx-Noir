## Salva e carrega o arquivo config.ini que salva as configurações do jogador
extends Node

# Arquivo de configs
var config: ConfigFile = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

## Escreve as configurações atuais no config.ini
func save_settings(settings: Dictionary) -> void:
	config.set_value("audio", "master_volume", settings.master_volume)
	config.set_value("audio", "music_volume", settings.music_volume)
	config.set_value("audio", "sfx_volume", settings.sfx_volume)

	config.set_value("audio", "master_muted", settings.master_muted)
	config.set_value("audio", "music_muted", settings.music_muted)
	config.set_value("audio", "sfx_muted", settings.sfx_muted)

	config.set_value("video", "screen_mode", settings.screen_mode)

	config.save(SETTINGS_FILE_PATH)
	
## Carrega o arquivo config.ini
func load_settings() -> ConfigFile:
	config.load(SETTINGS_FILE_PATH)
	return config
