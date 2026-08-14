extends Control

@export var continue_button: Button
@export var credits: VBoxContainer
@export var continue_label: Label

@export var fade_duration: float = 0.3

func _ready() -> void:
	hide_button()
	
	await get_tree().create_timer(3).timeout
	show_with_fade(continue_button, fade_duration)

func hide_button() -> void:
	continue_button.hide()
	continue_button.modulate = Color.TRANSPARENT

func show_with_fade(node: Control, duration) -> void:
	node.show()
	var tween := get_tree().create_tween()
	tween.tween_property(node, "modulate", Color.WHITE, duration)

func _on_continue_button_pressed() -> void:
	SceneLoader.load_scene(Constants.SCENE_PATHS.main_menu)
