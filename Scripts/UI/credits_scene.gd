class_name CreditsScene
extends Control

@export var continue_button: Button
@export var credits: VBoxContainer

@export var fade_duration: float = 0.3

## The continue button behaves a bit different if the credits scene
## was accessed through the main menu.
var is_in_menu := false

func _ready() -> void:
	hide_button()
	
	await get_tree().create_timer(3).timeout
	show_with_fade(continue_button)

func hide_button() -> void:
	continue_button.hide()
	continue_button.modulate = Color.TRANSPARENT

func show_with_fade(node: Control = self, duration: float = fade_duration) -> void:
	# the first time it appears it's not transparent, so it need this
	node.modulate = Color.TRANSPARENT
	node.show()
	var tween := get_tree().create_tween()
	tween.tween_property(node, "modulate", Color.WHITE, duration)

func hide_with_fade(node: Control = self, duration: float = fade_duration) -> void:
	var tween := get_tree().create_tween()
	await tween.tween_property(node, "modulate", Color.TRANSPARENT, duration).finished
	node.hide()

func _on_continue_button_pressed() -> void:
	if is_in_menu:
		hide_with_fade()
	else:
		SceneLoader.load_scene(Constants.SCENE_PATHS.main_menu)
