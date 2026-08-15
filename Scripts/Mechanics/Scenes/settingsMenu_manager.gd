## Controla como o menu de opções funciona
class_name SettingsManager
extends Control

@export_category("Valores Iniciais")
@export_range(0, 1, 0.01, "prefer_slider") var volume_default: float = 0.7

@export_category("Components")
@export_group("Audio")
@export var master_volume_slider: HSlider
@export var music_volume_slider: HSlider
@export var sfx_volume_slider: HSlider
@export var master_mute_button: CheckBox
@export var music_mute_button: CheckBox
@export var sfx_mute_button: CheckBox
@export_group("Video")
@export var screen_mode_button: OptionButton

var current_parent: Node
## Variáveis dos nodes na cena do menu de opções
@onready var animation_player = $Transition_FX
@onready var background = $Settings_BG	

# usado na hora de mudar o volume de cada bus de áudio
var music_bus_index: int
var sfx_bus_index: int

var buttons: Array[Control]

func _ready() -> void:
	buttons.append_array([
		master_volume_slider,
		music_volume_slider,
		sfx_volume_slider,
		master_mute_button,
		music_mute_button,
		sfx_mute_button,
		screen_mode_button
		])
	
	current_parent = get_parent()
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	load_settings()
	
func show_menu() -> void:
	visible = true
	animation_player.play("Fade-In")
	await animation_player.animation_finished
	_set_mouse_filter(MOUSE_FILTER_STOP)

func hide_menu() -> void:
	save_settings()
	_set_mouse_filter(MOUSE_FILTER_IGNORE)
	animation_player.play_backwards("Fade-In")
	await animation_player.animation_finished
	visible = false

func _set_mouse_filter(filter: Control.MouseFilter) -> void:
	for button in buttons:
		button.mouse_filter = filter

## Aplica no jogo os valores do arquivo "config.ini". Caso não exista, usa os valores default
func load_settings() -> void:
	var config: ConfigFile = ConfigFileManager.load_settings()

	master_volume_slider.value = config.get_value("audio", "master_volume", volume_default)
	music_volume_slider.value = config.get_value("audio", "music_volume", volume_default)
	sfx_volume_slider.value = config.get_value("audio", "sfx_volume", volume_default)
	
	master_mute_button.button_pressed = config.get_value("audio", "master_muted", false)
	music_mute_button.button_pressed = config.get_value("audio", "music_muted", false)
	sfx_mute_button.button_pressed = config.get_value("audio", "sfx_muted", false)
	
	screen_mode_button.selected = config.get_value("video", "screen_mode", 2) #      2 = 
	_on_screen_options_selected(config.get_value("video", "screen_mode", 2)) # borderless window

## Pega os valores nos nós de Control e salva no arquivo config.ini
func save_settings() -> void:
	ConfigFileManager.save_settings({
	"master_volume": master_volume_slider.value,
	"music_volume": music_volume_slider.value,
	"sfx_volume": sfx_volume_slider.value,

	"master_muted": master_mute_button.button_pressed,
	"music_muted": music_mute_button.button_pressed,
	"sfx_muted": sfx_mute_button.button_pressed,

	"screen_mode": screen_mode_button.selected
	})

## Altera o volume do bus Master
func _on_master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

## Muta e desmuta o bus Master
func _on_master_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

## Altera o volume do bus de música
func _on_music_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))

## Muta e desmuta o bus de música
func _on_music_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(music_bus_index, toggled_on)
	
## Altera o volume do bus de SFX
func _on_sfx_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))

## Muta e desmuta o bus de SFX
func _on_sfx_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(sfx_bus_index, toggled_on)

## Essa função verifica qual opção de tela foi selecionada
func _on_screen_options_selected(index: int) -> void:
	match index:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_done_pressed() -> void:
	hide_menu()
