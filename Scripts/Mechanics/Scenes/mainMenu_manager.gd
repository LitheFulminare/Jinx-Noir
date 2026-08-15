## Script para gerenciar como o menu deve agir
class_name MainMenuManager
extends Control

@onready var options_menu_ref = $Settings_Screen
@onready var options_animationPlayer = null
@onready var animation_player = $Transition_FX
@onready var background = $Menu_BG
@export var credits_scene: CreditsScene

func _ready() -> void:
	credits_scene.is_in_menu = true
	
	MusicManager.play_music(Constants.SONG_PATHS.Jinx_Noir)
	options_animationPlayer = options_menu_ref.get_node("Transition_FX")
	
	# Prevents audio from popping when returning to the menu from gameplay.
	await get_tree().create_timer(0.25).timeout
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)

## Quando o botão "Iniciar" for pressionado
func _on_start_pressed() -> void:
	MusicManager.play_music(Constants.SONG_PATHS.Uma_chamada_misteriosa, -6, true, 2)
	SceneLoader.load_scene(Constants.SCENE_PATHS.chapter_1_intro)

## Quando o botão "Opções" for pressionado
func _on_options_pressed() -> void:
	options_menu_ref.show_menu()

## Quando o botão "Sair" for pressionado
func _on_exit_pressed() -> void:
	animation_player.play("Fade-Out")
	await animation_player.animation_finished
	get_tree().quit()

func _on_credits_button_pressed() -> void:
	credits_scene.show_with_fade()
