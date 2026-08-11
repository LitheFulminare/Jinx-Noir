## Controlar como funciona o pause do jogo
class_name PauseScreenManager
extends CanvasLayer

@onready var animation_player = $Pause_FX
@onready var background = $Pause_BG
@onready var options_menu_ref = $Settings_Screen
@onready var options_animationPlayer = null

@export var pause_buttons: Control
@export var confirm_exit_buttons: Control

const SETTINGS_SCENE_PATH = preload("uid://d1fliddd0r1x8")
var settings_scene: SettingsManager

func _ready() -> void:
	options_animationPlayer = options_menu_ref.get_node("Transition_FX")
	settings_scene = SETTINGS_SCENE_PATH.instantiate()
	settings_scene.hide()
	add_child(settings_scene)
	visible = false

## Quando o jogador apertar o 'esc' para pausar, irá verificar se estava no menu ou in-game
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		settings_scene.hide()
		if get_tree().paused: # unpause
			get_tree().paused = false
			settings_scene.hide_menu()
			animation_player.play_backwards("Blur")
			await animation_player.animation_finished
			visible = false
		else: # pause
			_on_return_button_pressed()
			get_tree().paused = true
			visible = true
			animation_player.play("Blur")
			await animation_player.animation_finished

func _on_resume_pressed() -> void:
	get_tree().paused = false
	animation_player.play_backwards("Blur")
	await animation_player.animation_finished
	visible = false

func _on_settings_button_pressed() -> void:
	settings_scene.show_menu()

func _on_exit_pressed() -> void:
	pause_buttons.hide()
	confirm_exit_buttons.show()

func _on_confirm_button_pressed() -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)
	MusicManager.stop()
	if Dialogic.current_timeline:
		Dialogic.paused = true
	
	get_tree().paused = false
	SceneLoader.load_scene(Constants.SCENE_PATHS.main_menu)

func _on_return_button_pressed() -> void:
	pause_buttons.show()
	confirm_exit_buttons.hide()

func _on_tree_exiting() -> void:
	if Dialogic.current_timeline:
		Dialogic.paused = false
		Dialogic.end_timeline(true)
