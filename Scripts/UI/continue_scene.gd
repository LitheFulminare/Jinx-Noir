extends Control

@export var continue_label: Label

func _ready() -> void:
	hide_text()
	
	await get_tree().create_timer(1).timeout
	show_with_fade(continue_label, 1)
	
	await get_tree().create_timer(1).timeout
	update_continue_text()
	
	await get_tree().create_timer(3).timeout
	SceneLoader.load_scene(Constants.SCENE_PATHS.credits)

func hide_text() -> void:
	continue_label.hide()
	continue_label.modulate = Color.TRANSPARENT

func show_with_fade(node: Control, duration) -> void:
	node.show()
	var tween := get_tree().create_tween()
	tween.tween_property(node, "modulate", Color.WHITE, duration)

func update_continue_text() -> void:
	continue_label.visible_characters += 1
	await get_tree().create_timer(1).timeout
	continue_label.visible_characters += 1
	await get_tree().create_timer(1).timeout
	continue_label.visible_characters += 1
