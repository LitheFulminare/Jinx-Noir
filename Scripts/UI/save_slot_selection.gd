class_name SaveSlotSelection
extends Control

@export var save_slot: SaveSlot
@export var save_slot_2: SaveSlot
@export var save_slot_3: SaveSlot

var fade_duration: float = 0.3

enum selection_mode {
	NEW_GAME,
	CONTINUE,
	}

var current_selection_mode := selection_mode.CONTINUE

func _ready() -> void:
	connect_signals()
	
	show_continue_save_slots()

func connect_signals() -> void:
	SaveManager.game_loaded.connect(on_game_loaded)
	
	save_slot.save_selected.connect(_on_save_slot_button_pressed)
	save_slot_2.save_selected.connect(_on_save_slot_button_pressed)
	save_slot_3.save_selected.connect(_on_save_slot_button_pressed)

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
			show_new_game_save_slots()
		selection_mode.CONTINUE:
			show_continue_save_slots()

func show_continue_save_slots() -> void:
	save_slot.show_continue_option()
	save_slot_2.show_continue_option()
	save_slot_3.show_continue_option()

func show_new_game_save_slots() -> void:
	save_slot.show_new_game_option()
	save_slot_2.show_new_game_option()
	save_slot_3.show_new_game_option()

func _on_leave_button_pressed() -> void:
	hide_menu()
