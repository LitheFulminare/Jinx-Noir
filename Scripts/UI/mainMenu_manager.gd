## Script para gerenciar como o menu deve agir
class_name MainMenuManager
extends Control

@onready var options_animationPlayer = null
@onready var animation_player = $Transition_FX
@onready var background = $Menu_BG
@export var credits_scene: CreditsScene
@export var settings_screen: SettingsManager

@export var phone_call_timeline: DialogicTimeline
## Dialogic style used on the timelines so it can be prepared beforehand.
@export var dialogic_style: DialogicStyle

func _ready() -> void:
	Dialogic.VAR.reset()
	
	# Decrease lag on the first interaction
	dialogic_style.prepare()
	
	# The preloaded timeline has to be stored, so this is probably useless
	#Dialogic.preload_timeline(phone_call_timeline)
	
	credits_scene.is_in_menu = true
	
	settings_screen.load_settings()
	
	MusicManager.play_music(Constants.SONG_PATHS.Jinx_Noir, -6)
	options_animationPlayer = settings_screen.get_node("Transition_FX")
	
	# Prevents audio from popping when returning to the menu from gameplay.
	await get_tree().create_timer(0.25).timeout
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)

func _any_button_down() -> void:
	return
	# I decided not to used this because doing I don't want to do it for 
	# every control node.
	#Input.set_custom_mouse_cursor(CursorManager.PATACLICK)

func _mouse_entered_any_button() -> void:
	Input.set_custom_mouse_cursor(CursorManager.PATAHOVER)

func mouse_exited_any_button() -> void:
	Input.set_custom_mouse_cursor(CursorManager.PATA)

## Quando o botão "Iniciar" for pressionado
func _on_start_pressed() -> void:
	MusicManager.play_music(Constants.SONG_PATHS.Uma_chamada_misteriosa, -6, true, 2)
	SceneLoader.load_scene(Constants.SCENE_PATHS.chapter_1_intro)

## Quando o botão "Opções" for pressionado
func _on_options_pressed() -> void:
	settings_screen.show_menu()

## Quando o botão "Sair" for pressionado
func _on_exit_pressed() -> void:
	animation_player.play("Fade-Out")
	await animation_player.animation_finished
	get_tree().quit()

func _on_credits_button_pressed() -> void:
	credits_scene.show_with_fade()
