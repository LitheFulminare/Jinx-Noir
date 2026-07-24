## Script para gerenciar como o menu deve agir
class_name MainMenuManager
extends Control

@onready var options_menu_ref = $Settings_Screen
@onready var options_animationPlayer = null
@onready var animation_player = $Transition_FX
@onready var background = $Menu_BG

var menu_theme := preload("res://Assets/Audio/Music/Menu Theme.ogg")
var gameplay_theme := preload("res://Assets/Audio/Music/Escritório.ogg")

func _ready() -> void:
	MusicManager.play_music(menu_theme)
	options_animationPlayer = options_menu_ref.get_node("Transition_FX")
	
## Quando o botão "Iniciar" for pressionado
func _on_start_pressed() -> void:
	MusicManager.play_music(gameplay_theme, -6, true, 2)
	SceneLoader.load_scene(Constants.SCENE_PATHS.office)

## Quando o botão "Opções" for pressionado
func _on_options_pressed() -> void:
	animation_player.play("Fade-Out")
	await animation_player.animation_finished
	background = false
	options_menu_ref.visible = true
	options_animationPlayer.play("Fade-In")
	
## Quando o botão "Sair" for pressionado
func _on_exit_pressed() -> void:
	animation_player.play("Fade-Out")
	await animation_player.animation_finished
	get_tree().quit()
