extends Control

@export var intro_text: Label
@export var two_dots_label: Label
@export var timer: Timer

func _on_timer_timeout() -> void:
	two_dots_label.visible = !two_dots_label.visible

func go_to_office() -> void:
	SceneLoader.load_scene(Constants.SCENE_PATHS.office)
