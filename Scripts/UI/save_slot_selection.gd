class_name SaveSlotSelection
extends Control

@export var slot_1: Control
@export var slot_2: Control
@export var slot_3: Control

var fade_duration: float = 0.3

enum selection_mode {
	NEW_GAME,
	CONTINUE,
	}

var current_selection_mode := selection_mode.CONTINUE

func _ready() -> void:
	SaveManager.connect("game_loaded", on_game_loaded)
	
	show_continue_save_slots()

func show_menu() -> void:
	# the first time it appears it's not transparent, so it need this
	modulate = Color.TRANSPARENT
	show()
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, fade_duration)

func hide_menu() -> void:
	var tween := get_tree().create_tween()
	await tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_duration).finished
	hide()

func _on_save_slot_button_pressed(slot: int) -> void:
	if SaveManager._has_save(slot):
		print("Loading game on slot ", slot)
		SaveManager.current_save_slot = slot
		SaveManager.load_game(slot)
	else:
		print("Doesn't have save on slot ", slot)

func on_game_loaded() -> void:
	SceneLoader.load_scene(GameState.current_scene_uid)

func set_selection_mode(mode: selection_mode) -> void:
	current_selection_mode = mode
	
	match current_selection_mode:
		selection_mode.NEW_GAME:
			return
		selection_mode.CONTINUE:
			show_continue_save_slots()

func show_continue_save_slots() -> void:
	# something like save_slots.show()
	return

func _on_leave_button_pressed() -> void:
	hide_menu()
